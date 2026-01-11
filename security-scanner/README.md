# Security Scanner

Scans MuleSoft projects for security vulnerabilities including hardcoded secrets, weak TLS configurations, and insecure configurations.

## Purpose

This script helps identify security issues in MuleSoft projects:
- Hardcoded secrets (passwords, API keys, tokens)
- Weak TLS versions
- Insecure HTTP listeners
- Missing security configurations

## Usage

### Basic Usage

```bash
python secret-scan.py --path /path/to/mule/project
```

### With Options

```bash
# Fail on high severity issues (for CI/CD)
python secret-scan.py --path ./my-app --fail-on high

# Show all severity levels
python secret-scan.py --path ./my-app --fail-on low

# JSON output
python secret-scan.py --path ./my-app --format json

# Verbose output
python secret-scan.py --path ./my-app --verbose
```

## What It Scans

1. **Hardcoded Secrets** - Detects passwords, API keys, tokens in code
2. **TLS Configuration** - Validates TLS version requirements
3. **HTTP Listeners** - Checks for insecure HTTP configurations
4. **Security Policies** - Identifies missing security policies

## Severity Levels

- **HIGH** - Critical security issues (default fail threshold)
- **MEDIUM** - Important security concerns
- **LOW** - Minor security recommendations

## Output

### Text Format (Default)
- Lists security issues by severity
- Shows file locations and line numbers
- Provides remediation recommendations

### JSON Format
- Machine-readable output
- Suitable for CI/CD integration
- Includes severity classification

## Examples

```bash
# Basic scan
python secret-scan.py --path ./my-app

# CI/CD integration (fail on high severity)
python secret-scan.py --path ./my-app --fail-on high --format json

# Comprehensive scan
python secret-scan.py --path ./my-app --fail-on low --verbose
```

## Exit Codes

- `0` - No issues found or below fail threshold
- `1` - Issues found above fail threshold or script error

## Requirements

- Python 3.7+
- MuleSoft project files
