# Configuration Validator

Validates MuleSoft project configuration files and property placeholders to catch issues before deployment.

## Purpose

This script helps identify common configuration issues in MuleSoft projects:
- Missing property placeholders
- Invalid mule-artifact.json
- Duplicate properties
- Unused properties

## Usage

### Basic Usage

```bash
python validate-properties.py --project-path /path/to/mule/project
```

### With Options

```bash
# Show warnings
python validate-properties.py --project-path ./my-app --verbose

# JSON output for CI/CD
python validate-properties.py --project-path ./my-app --format json
```

## What It Checks

1. **Property Placeholders** - Validates all `${property.name}` placeholders have corresponding properties
2. **mule-artifact.json** - Checks required fields and structure
3. **Duplicate Properties** - Detects properties defined in multiple files
4. **Unused Properties** - Identifies properties that are never referenced

## Output

### Text Format (Default)
- Lists errors and warnings
- Shows property locations
- Provides recommendations

### JSON Format
- Machine-readable output
- Suitable for CI/CD integration
- Includes validation status and statistics

## Examples

```bash
# Validate example project
python validate-properties.py --project-path ../examples/sample-mule-project

# Validate with verbose output
python validate-properties.py --project-path ./my-app --verbose

# JSON output for CI
python validate-properties.py --project-path ./my-app --format json
```

## Exit Codes

- `0` - Validation passed (no errors)
- `1` - Validation failed (errors found)

## Requirements

- Python 3.7+
- MuleSoft project with XML configuration files
