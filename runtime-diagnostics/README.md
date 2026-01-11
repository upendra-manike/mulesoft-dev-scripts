# Runtime Diagnostics

Diagnoses MuleSoft runtime issues including Java version compatibility, port conflicts, memory problems, and classpath issues.

## Purpose

This script helps identify runtime issues before deployment:
- Java version compatibility
- Mule runtime version detection
- Memory validation
- Port availability checking
- Classpath validation

## Usage

### Basic Usage

```bash
./mule-runtime-check.sh /path/to/mule/project
```

### With Options

```bash
# Specify project path
./mule-runtime-check.sh --project-path ./my-app

# JSON output
./mule-runtime-check.sh --project-path ./my-app --format json

# Verbose output
./mule-runtime-check.sh --project-path ./my-app --verbose
```

## What It Checks

1. **Java Version** - Verifies Java version compatibility with Mule runtime
2. **Mule Runtime** - Detects Mule runtime version from project files
3. **Memory** - Validates memory settings and recommendations
4. **Ports** - Checks for port conflicts
5. **Classpath** - Validates classpath configuration

## Output

### Text Format (Default)
- Color-coded output (green/yellow/red)
- Detailed diagnostics
- Recommendations for fixes

### JSON Format
- Machine-readable output
- Suitable for CI/CD integration
- Includes all diagnostic results

## Examples

```bash
# Check example project
./mule-runtime-check.sh ../examples/sample-mule-project

# Check with JSON output
./mule-runtime-check.sh --project-path ./my-app --format json

# Verbose diagnostics
./mule-runtime-check.sh --project-path ./my-app --verbose
```

## Exit Codes

- `0` - All checks passed
- `1` - Issues found or script error

## Requirements

- Bash 4.0+
- Java (for version checking)
- MuleSoft project
