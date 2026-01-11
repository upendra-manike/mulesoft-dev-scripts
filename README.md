# MuleSoft Developer Scripts

Open-source scripts and tools to solve common MuleSoft development and operations problems.

## 📦 Overview

This repository contains production-ready scripts for MuleSoft developers to validate configurations, diagnose runtime issues, analyze logs, scan for security vulnerabilities, validate APIs, and analyze test coverage.

## 🚀 Quick Start

**New to this repository?** Start with the [Quick Start Guide](QUICKSTART.md) to get up and running in minutes!

## 🛠️ Available Scripts

### ✅ Production Ready (6 scripts)

1. **🔧 Configuration Validator** (`config-validator/`)
   - Validates property placeholders and configuration files
   - Checks mule-artifact.json
   - Detects duplicate and unused properties
   - [Read more →](config-validator/README.md)

2. **⚙️ Runtime Diagnostics** (`runtime-diagnostics/`)
   - Checks Java version compatibility
   - Validates Mule runtime version
   - Detects port conflicts and memory issues
   - [Read more →](runtime-diagnostics/README.md)

3. **📊 Log Analyzer** (`log-analyzer/`)
   - Analyzes logs for correlation IDs
   - Detects error patterns and log flooding
   - Identifies performance issues
   - [Read more →](log-analyzer/README.md)

4. **🔐 Security Scanner** (`security-scanner/`)
   - Detects hardcoded secrets
   - Validates TLS versions
   - Checks for insecure HTTP listeners
   - [Read more →](security-scanner/README.md)

5. **🔌 API Validator** (`api-validator/`)
   - Validates RAML/OpenAPI contracts
   - Checks contract vs implementation matching
   - Validates TLS/HTTPS configuration
   - [Read more →](api-validator/README.md)

6. **🧪 MUnit Analyzer** (`munit-analyzer/`)
   - Calculates test coverage
   - Analyzes flow coverage
   - Validates test quality
   - [Read more →](munit-analyzer/README.md)

### 🚧 Coming Soon (3 scripts)

7. **🏗️ Architecture Analyzer** - Static analysis for architecture issues
8. **☁️ CloudHub Readiness** - CloudHub deployment readiness checks
9. **📈 Project Health** - Project health scoring and metrics

## 📖 Documentation

- **[Quick Start Guide](QUICKSTART.md)** - Get started in minutes
- **[Project Status](PROJECT_STATUS.md)** - Detailed status of all projects
- **[Contributing Guide](CONTRIBUTING.md)** - How to contribute
- **[AI Agent Integration](README_AI_AGENTS.md)** - For AI agents and tools

## 🎯 Common Use Cases

### Before Deployment
```bash
# Validate configuration
python config-validator/validate-properties.py --project-path ./my-mule-app

# Security scan
python security-scanner/secret-scan.py --path ./my-mule-app --fail-on high

# API validation
python api-validator/raml-vs-flow-check.py --project-path ./my-mule-app
```

### Troubleshooting
```bash
# Runtime diagnostics
./runtime-diagnostics/mule-runtime-check.sh ./my-mule-app

# Log analysis
python log-analyzer/analyze-logs.py ./logs/application.log --verbose
```

### Testing
```bash
# Test coverage analysis
python munit-analyzer/munit-coverage.py --project-path ./my-mule-app
```

## 🧪 Example Projects

Test scripts without real projects using the example projects in `examples/`:

```bash
cd examples
./test-all-scripts.sh
```

## 📋 Requirements

- **Python 3.7+** (for Python scripts)
- **Bash 4.0+** (for shell scripts)
- **MuleSoft project** or log files (or use the example projects!)

## 🔧 CI/CD Integration

All scripts support JSON output for CI/CD integration:

```bash
python config-validator/validate-properties.py --project-path ./app --format json
```

## 📝 Output Formats

- **Text** (default) - Human-readable output
- **JSON** (`--format json`) - Machine-readable for CI/CD pipelines

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Need Help?

Each script has its own detailed README with:
- Problem descriptions
- Usage examples
- Error scenarios
- Troubleshooting tips

Navigate to any script's directory and read its README.md!

## 🔗 Links

- [Quick Start Guide](QUICKSTART.md)
- [Project Status](PROJECT_STATUS.md)
- [Contributing Guide](CONTRIBUTING.md)
- [AI Agent Integration](README_AI_AGENTS.md)

---

**Ready to solve MuleSoft problems?** Check out the [Quick Start Guide](QUICKSTART.md) to get started! 🚀
