# Log Analyzer

Analyzes MuleSoft application logs to identify common issues, missing correlation IDs, log flooding, and error patterns.

## Purpose

This script helps diagnose issues from MuleSoft application logs:
- Missing correlation IDs
- High error rates
- Log flooding patterns
- Error pattern analysis
- Performance issue identification

## Usage

### Basic Usage

```bash
# Analyze a log file
python analyze-logs.py /path/to/application.log

# Analyze multiple log files
python analyze-logs.py log1.log log2.log log3.log
```

### With Project Path

```bash
# Analyze logs from a project directory
python analyze-logs.py --project-path /path/to/mule/project
```

### With Options

```bash
# Verbose output with warnings
python analyze-logs.py application.log --verbose

# JSON output for CI/CD
python analyze-logs.py application.log --format json

# Specific checks
python analyze-logs.py application.log --check-correlation --check-errors
```

## What It Analyzes

1. **Correlation IDs** - Detects missing correlation IDs in log entries
2. **Error Patterns** - Analyzes error types and rates
3. **Log Flooding** - Identifies excessive logging patterns
4. **Log Levels** - Checks log level distribution
5. **Performance** - Identifies potential performance issues

## Output

### Text Format (Default)
- Summary statistics
- Error and warning lists
- Correlation ID coverage
- Error rate analysis

### JSON Format
- Machine-readable output
- Suitable for CI/CD integration
- Includes detailed statistics

## Examples

```bash
# Analyze application log
python analyze-logs.py ./logs/application.log

# Analyze with project path (searches for logs)
python analyze-logs.py --project-path ./my-app

# Verbose analysis
python analyze-logs.py ./logs/application.log --verbose

# JSON output
python analyze-logs.py ./logs/application.log --format json
```

## Exit Codes

- `0` - Analysis complete (no critical issues)
- `1` - Critical issues found or script error

## Requirements

- Python 3.7+
- MuleSoft application log files
