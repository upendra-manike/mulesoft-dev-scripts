#!/bin/bash
#
# MuleSoft Runtime Diagnostics Checker
#
# Checks Java version, Mule runtime compatibility, memory, ports, and classpath
# to identify common runtime issues before deployment.
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
PROJECT_PATH="."
VERBOSE=false
FORMAT="text"
CHECK_JAVA=true
CHECK_MEMORY=true
CHECK_PORTS=true
CHECK_CLASSPATH=true
CHECK_BUILD=true

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --project-path)
            PROJECT_PATH="$2"
            shift 2
            ;;
        --check-java)
            CHECK_JAVA=true
            shift
            ;;
        --check-memory)
            CHECK_MEMORY=true
            shift
            ;;
        --check-ports)
            CHECK_PORTS=true
            shift
            ;;
        --check-classpath)
            CHECK_CLASSPATH=true
            shift
            ;;
        --check-build)
            CHECK_BUILD=true
            shift
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --format)
            FORMAT="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS] [PROJECT_PATH]"
            echo ""
            echo "Options:"
            echo "  --project-path PATH    Path to MuleSoft project (default: current dir)"
            echo "  --check-java           Check Java version compatibility"
            echo "  --check-memory         Check memory settings"
            echo "  --check-ports          Check port availability"
            echo "  --check-classpath      Check classpath issues"
            echo "  --check-build          Check if project builds"
            echo "  --verbose, -v          Show detailed output"
            echo "  --format FORMAT        Output format: text or json"
            echo "  --help, -h             Show this help message"
            exit 0
            ;;
        -*)
            echo "Unknown option: $1"
            exit 1
            ;;
        *)
            PROJECT_PATH="$1"
            shift
            ;;
    esac
done

# Arrays to store results
ERRORS=()
WARNINGS=()
INFO=()

# Check if project path exists
if [[ ! -d "$PROJECT_PATH" ]]; then
    echo -e "${RED}❌ Error: Project path does not exist: $PROJECT_PATH${NC}"
    exit 1
fi

cd "$PROJECT_PATH"

# Function to check Java version
check_java() {
    if ! command -v java &> /dev/null; then
        ERRORS+=("Java is not installed or not in PATH")
        return 1
    fi

    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | sed '/^1\./s///' | cut -d'.' -f1)
    JAVA_FULL_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
    
    if [[ -z "$JAVA_VERSION" ]] || [[ "$JAVA_VERSION" -lt 11 ]]; then
        ERRORS+=("Java version: $JAVA_FULL_VERSION (incompatible)\n   Required: Java 11 or higher\n   Fix: Update JAVA_HOME to Java 11+")
        return 1
    else
        INFO+=("Java version: $JAVA_FULL_VERSION (compatible)")
        
        if [[ -n "${JAVA_HOME:-}" ]]; then
            INFO+=("JAVA_HOME: $JAVA_HOME")
        else
            WARNINGS+=("JAVA_HOME is not set (may cause issues)")
        fi
        return 0
    fi
}

# Function to check Mule runtime version
check_mule_version() {
    ARTIFACT_FILE="mule-artifact.json"
    
    if [[ ! -f "$ARTIFACT_FILE" ]]; then
        WARNINGS+=("mule-artifact.json not found (cannot verify Mule version)")
        return 0
    fi

    if command -v jq &> /dev/null; then
        MIN_MULE_VERSION=$(jq -r '.minMuleVersion // empty' "$ARTIFACT_FILE")
    else
        MIN_MULE_VERSION=$(grep -o '"minMuleVersion"[[:space:]]*:[[:space:]]*"[^"]*"' "$ARTIFACT_FILE" | cut -d'"' -f4 || echo "")
    fi

    if [[ -n "$MIN_MULE_VERSION" ]]; then
        INFO+=("Mule runtime version: $MIN_MULE_VERSION (detected from mule-artifact.json)")
        
        # Check if version is 4.x
        if [[ "$MIN_MULE_VERSION" =~ ^4\. ]]; then
            INFO+=("Mule 4.x detected - requires Java 11+")
        fi
    else
        WARNINGS+=("Could not determine minMuleVersion from mule-artifact.json")
    fi
}

# Function to check memory
check_memory() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        TOTAL_MEM=$(sysctl -n hw.memsize | awk '{print int($1/1024/1024/1024)}')
    else
        # Linux
        TOTAL_MEM=$(free -g | awk '/^Mem:/{print $2}')
    fi

    if [[ -z "$TOTAL_MEM" ]] || [[ "$TOTAL_MEM" -lt 2 ]]; then
        WARNINGS+=("Available memory: ${TOTAL_MEM}GB\n   Recommended: 2GB minimum for Mule 4.x")
    else
        INFO+=("Memory: ${TOTAL_MEM}GB available (OK)")
    fi

    # Check Java heap if available
    if command -v java &> /dev/null; then
        JAVA_HEAP=$(java -XX:+PrintFlagsFinal -version 2>&1 | grep -i "MaxHeapSize" | awk '{print $4}' || echo "")
        if [[ -n "$JAVA_HEAP" ]] && [[ "$VERBOSE" == true ]]; then
            HEAP_MB=$((JAVA_HEAP / 1024 / 1024))
            INFO+=("Java MaxHeapSize: ${HEAP_MB}MB")
        fi
    fi
}

# Function to check ports
check_ports() {
    DEFAULT_PORTS=(8081 8091)
    PORT_FILE="src/main/resources/mule-deploy.properties"
    
    # Try to read custom port from config
    CUSTOM_PORT=""
    if [[ -f "$PORT_FILE" ]]; then
        CUSTOM_PORT=$(grep -i "http.port" "$PORT_FILE" | cut -d'=' -f2 | tr -d ' ' || echo "")
    fi

    PORTS_TO_CHECK=("${DEFAULT_PORTS[@]}")
    if [[ -n "$CUSTOM_PORT" ]]; then
        PORTS_TO_CHECK+=("$CUSTOM_PORT")
    fi

    for PORT in "${PORTS_TO_CHECK[@]}"; do
        if command -v lsof &> /dev/null; then
            if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
                PID=$(lsof -ti:$PORT)
                PROCESS=$(ps -p "$PID" -o comm= 2>/dev/null || echo "unknown")
                ERRORS+=("Port $PORT already in use\n   Process: $PROCESS (PID: $PID)\n   Fix: Stop the process or change port in mule-deploy.properties")
            else
                INFO+=("Port $PORT: available")
            fi
        elif command -v netstat &> /dev/null; then
            if netstat -an | grep -q ":$PORT.*LISTEN"; then
                ERRORS+=("Port $PORT already in use\n   Fix: Stop the process or change port in mule-deploy.properties")
            else
                INFO+=("Port $PORT: available")
            fi
        else
            WARNINGS+=("Cannot check port $PORT (lsof/netstat not available)")
        fi
    done
}

# Function to check classpath
check_classpath() {
    if [[ ! -d "target" ]] && [[ ! -d ".mule" ]]; then
        WARNINGS+=("Project not built yet (target/ or .mule/ not found)\n   Run 'mvn clean package' or build in Anypoint Studio")
    else
        INFO+=("Build artifacts found: OK")
    fi

    # Check for common classpath issues
    if [[ -f "pom.xml" ]]; then
        if grep -q "mule-module" pom.xml 2>/dev/null; then
            INFO+=("Maven project detected")
        fi
    fi
}

# Function to check build
check_build() {
    if [[ -f "pom.xml" ]]; then
        if command -v mvn &> /dev/null; then
            if [[ "$VERBOSE" == true ]]; then
                echo "🔍 Checking if project builds..."
                if mvn -q validate 2>&1 | grep -i error; then
                    WARNINGS+=("Maven validation found issues (run 'mvn clean package' for details)")
                else
                    INFO+=("Maven project structure: OK")
                fi
            fi
        else
            WARNINGS+=("Maven not found (cannot verify build)")
        fi
    fi
}

# Run checks
echo "🔍 Running MuleSoft runtime diagnostics..."

if [[ "$CHECK_JAVA" == true ]]; then
    check_java
    check_mule_version
fi

if [[ "$CHECK_MEMORY" == true ]]; then
    check_memory
fi

if [[ "$CHECK_PORTS" == true ]]; then
    check_ports
fi

if [[ "$CHECK_CLASSPATH" == true ]]; then
    check_classpath
fi

if [[ "$CHECK_BUILD" == true ]]; then
    check_build
fi

# Print results
if [[ "$FORMAT" == "json" ]]; then
    echo "{"
    echo "  \"valid\": $([[ ${#ERRORS[@]} -eq 0 ]] && echo 'true' || echo 'false'),"
    echo "  \"errors\": ["
    for i in "${!ERRORS[@]}"; do
        echo -n "    \"${ERRORS[$i]//$'\n'/\\n}\""
        [[ $i -lt $((${#ERRORS[@]} - 1)) ]] && echo "," || echo
    done
    echo "  ],"
    echo "  \"warnings\": ["
    for i in "${!WARNINGS[@]}"; do
        echo -n "    \"${WARNINGS[$i]//$'\n'/\\n}\""
        [[ $i -lt $((${#WARNINGS[@]} - 1)) ]] && echo "," || echo
    done
    echo "  ],"
    echo "  \"info\": ["
    for i in "${!INFO[@]}"; do
        echo -n "    \"${INFO[$i]}\""
        [[ $i -lt $((${#INFO[@]} - 1)) ]] && echo "," || echo
    done
    echo "  ]"
    echo "}"
else
    # Text output
    if [[ ${#ERRORS[@]} -gt 0 ]]; then
        echo ""
        echo -e "${RED}❌ Runtime Issues Found:${NC}"
        echo ""
        for error in "${ERRORS[@]}"; do
            echo -e "${RED}  ${error}${NC}"
            echo ""
        done
    fi

    if [[ ${#WARNINGS[@]} -gt 0 ]] && [[ "$VERBOSE" == true ]]; then
        echo ""
        echo -e "${YELLOW}⚠️  Warnings:${NC}"
        echo ""
        for warning in "${WARNINGS[@]}"; do
            echo -e "${YELLOW}  ${warning}${NC}"
            echo ""
        done
    fi

    if [[ ${#INFO[@]} -gt 0 ]]; then
        echo ""
        for info in "${INFO[@]}"; do
            echo -e "${GREEN}✅ ${info}${NC}"
        done
    fi

    if [[ ${#ERRORS[@]} -eq 0 ]]; then
        echo ""
        echo -e "${GREEN}✅ All runtime checks passed!${NC}"
        if [[ ${#WARNINGS[@]} -gt 0 ]] && [[ "$VERBOSE" != true ]]; then
            echo -e "${YELLOW}⚠️  ${#WARNINGS[@]} warning(s) found (use --verbose to see)${NC}"
        fi
    else
        echo ""
        echo -e "${RED}❌ Found ${#ERRORS[@]} error(s)${NC}"
    fi
fi

# Exit with error code if issues found
exit $([[ ${#ERRORS[@]} -eq 0 ]] && echo 0 || echo 1)

