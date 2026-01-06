# 📦 Publishing Packages

This guide explains how to publish the MuleSoft Developer Scripts to package managers.

## 🐍 PyPI (Python Package Index)

### Prerequisites

```bash
pip install build twine
```

### Build Package

```bash
# Build source distribution and wheel
python -m build

# This creates:
# - dist/mulesoft-dev-scripts-1.0.0.tar.gz
# - dist/mulesoft_dev_scripts-1.0.0-py3-none-any.whl
```

### Test Upload (TestPyPI)

```bash
# Upload to TestPyPI first
twine upload --repository testpypi dist/*

# Test installation
pip install --index-url https://test.pypi.org/simple/ mulesoft-dev-scripts
```

### Publish to PyPI

```bash
# Create PyPI account at https://pypi.org/account/register/
# Get API token from https://pypi.org/manage/account/token/

# Upload to PyPI
twine upload dist/*

# Or use token
twine upload dist/* --username __token__ --password pypi-xxxxxxxxxxxxx
```

### Install from PyPI

After publishing, users can install:

```bash
pip install mulesoft-dev-scripts
```

## 📋 Package Structure

The package includes:
- All Python scripts as console commands
- Example projects
- Documentation
- AI agent metadata

## 🔄 Version Management

Update version in:
- `setup.py` (version="X.Y.Z")
- `pyproject.toml` (version = "X.Y.Z")
- Commit and tag: `git tag v1.0.0`

## 🚀 Automated Publishing

Add to `.github/workflows/publish.yml`:

```yaml
name: Publish to PyPI

on:
  release:
    types: [created]

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.9'
      - run: pip install build twine
      - run: python -m build
      - run: twine upload dist/*
        env:
          TWINE_USERNAME: __token__
          TWINE_PASSWORD: ${{ secrets.PYPI_API_TOKEN }}
```

## 📝 Notes

- PyPI package name: `mulesoft-dev-scripts`
- GitHub repo: `mulesoft-dev-scripts`
- Keep versions in sync

