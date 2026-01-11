# API Validator

Validates API configurations, listeners, TLS settings, and contract mismatches in MuleSoft projects. Checks for RAML/OpenAPI vs implementation mismatches.

## Purpose

This script helps validate API configurations in MuleSoft projects:
- RAML/OpenAPI contract validation
- HTTP listener configuration
- TLS/HTTPS settings
- Contract vs implementation matching
- CORS configuration

## Usage

### Basic Usage

```bash
python raml-vs-flow-check.py --project-path /path/to/mule/project
```

### With Options

```bash
# Verbose output
python raml-vs-flow-check.py --project-path ./my-app --verbose

# JSON output for CI/CD
python raml-vs-flow-check.py --project-path ./my-app --format json
```

## What It Validates

1. **API Contracts** - Validates RAML/OpenAPI files
2. **HTTP Listeners** - Checks listener configurations
3. **TLS/HTTPS** - Validates TLS settings
4. **Contract Matching** - Compares contracts with implementation
5. **CORS** - Checks CORS configuration
6. **Timeouts** - Validates timeout settings

## Output

### Text Format (Default)
- Lists validation errors and warnings
- Shows contract mismatches
- Provides configuration recommendations

### JSON Format
- Machine-readable output
- Suitable for CI/CD integration
- Includes detailed validation results

## Examples

```bash
# Validate example project
python raml-vs-flow-check.py --project-path ../examples/sample-mule-project

# Validate with verbose output
python raml-vs-flow-check.py --project-path ./my-app --verbose

# JSON output for CI
python raml-vs-flow-check.py --project-path ./my-app --format json
```

## Exit Codes

- `0` - Validation passed (no errors)
- `1` - Validation failed (errors found)

## Requirements

- Python 3.7+
- MuleSoft project with API definitions (RAML/OpenAPI)
- MuleSoft flows with HTTP listeners
