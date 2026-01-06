# 🤖 AI Agent Integration Guide

This repository is designed to be easily discoverable and usable by AI agents (Cursor, GitHub Copilot, ChatGPT, etc.).

## 📋 Metadata Files

### `.cursorrules`
Contains structured rules for Cursor AI to understand:
- Available scripts and their purposes
- When to use each script
- Command syntax
- Example usage

### `.ai-agent-metadata.json`
Machine-readable JSON metadata including:
- Script descriptions
- Problems solved
- Usage patterns
- Output formats
- Example project locations

## 🔍 How AI Agents Can Use This Repository

### 1. Script Discovery
AI agents can read `.ai-agent-metadata.json` to discover:
- What scripts are available
- What problems they solve
- How to use them

### 2. Command Generation
Agents can generate appropriate commands:
```python
# AI agent can suggest:
python config-validator/validate-properties.py --project-path ./my-mule-app
```

### 3. Workflow Integration
Agents can create workflows combining multiple scripts:
```bash
# Pre-deployment validation workflow
python config-validator/validate-properties.py --project-path ./app
python security-scanner/secret-scan.py --path ./app --fail-on high
python api-validator/raml-vs-flow-check.py --project-path ./app
```

### 4. Problem Diagnosis
Agents can suggest scripts based on error messages:
- "Property not found" → config-validator
- "Port already in use" → runtime-diagnostics
- "Missing correlation ID" → log-analyzer

## 📝 Example AI Agent Prompts

### For Cursor AI
```
I have a MuleSoft project with property placeholder errors. 
What script should I use?
```

### For GitHub Copilot
```
Generate a CI/CD pipeline that validates MuleSoft projects 
before deployment using the scripts in this repo.
```

### For ChatGPT/Claude
```
I need to analyze MuleSoft logs for errors. 
Use the log-analyzer script from mulesoft-dev-scripts.
```

## 🎯 Best Practices for AI Agents

1. **Check metadata first** - Read `.ai-agent-metadata.json` for available tools
2. **Use appropriate script** - Match problem to script purpose
3. **Include example projects** - Reference `examples/` for testing
4. **Support JSON output** - Use `--format json` for programmatic use
5. **Handle errors gracefully** - Scripts exit with appropriate codes

## 🔧 Integration Examples

### Cursor AI Rules
The `.cursorrules` file helps Cursor understand:
- When to suggest these scripts
- How to use them correctly
- What problems they solve

### GitHub Copilot
Copilot can:
- Autocomplete script commands
- Suggest script usage based on context
- Generate workflows using these scripts

### Custom AI Agents
Any AI agent can:
1. Parse `.ai-agent-metadata.json`
2. Understand script purposes
3. Generate appropriate commands
4. Integrate into workflows

## 📦 Package Installation (For AI Agents)

When published to PyPI, AI agents can suggest:
```bash
pip install mulesoft-dev-scripts
```

Then use scripts as:
```bash
mule-validate-config --project-path ./app
mule-analyze-logs application.log
mule-scan-security --path ./app
```

## 🚀 Future Enhancements

- API endpoints for script execution
- REST API for remote execution
- Docker images for containerized execution
- Webhook integration for CI/CD

---

**This repository is AI-agent friendly!** 🤖✨

