# MUnit Analyzer

Analyzes MUnit test coverage, execution time, and test quality in MuleSoft projects.

## Purpose

This script helps assess test coverage and quality in MuleSoft projects:
- Test coverage calculation
- Flow coverage analysis
- Test quality checks (assertions, mocks)
- Uncovered flow identification
- Error handling validation

## Usage

### Basic Usage

```bash
python munit-coverage.py --project-path /path/to/mule/project
```

### With Options

```bash
# Verbose output with warnings
python munit-coverage.py --project-path ./my-app --verbose

# JSON output for CI/CD
python munit-coverage.py --project-path ./my-app --format json

# Fail if no tests found (strict mode)
python munit-coverage.py --project-path ./my-app --fail-on-no-tests
```

## What It Analyzes

1. **Test Coverage** - Calculates percentage of flows covered by tests
2. **Flow Coverage** - Lists covered and uncovered flows
3. **Test Quality** - Checks for assertions and mocks
4. **Test Structure** - Validates test best practices
5. **Error Handling** - Identifies flows without error handling

## Output

### Text Format (Default)
- Coverage statistics
- List of uncovered flows
- Test quality warnings
- Recommendations

### JSON Format
- Machine-readable output
- Suitable for CI/CD integration
- Includes detailed coverage metrics

## Examples

```bash
# Analyze example project
python munit-coverage.py --project-path ../examples/sample-mule-project

# Analyze with verbose output
python munit-coverage.py --project-path ./my-app --verbose

# JSON output for CI
python munit-coverage.py --project-path ./my-app --format json

# Strict mode (fail if no tests)
python munit-coverage.py --project-path ./my-app --fail-on-no-tests
```

## Exit Codes

- `0` - Analysis complete (no errors, or no tests found by default)
- `1` - Errors found or `--fail-on-no-tests` flag used with no tests

## Notes

- By default, "No MUnit tests found" is treated as a warning (exit code 0)
- Use `--fail-on-no-tests` flag to treat missing tests as an error
- Coverage threshold: <50% is an error, <80% is a warning

## Requirements

- Python 3.7+
- MuleSoft project with MUnit test files
