# OWASP Mobile Application Security Testing Guide (MASTG)

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

The OWASP MASTG is a documentation project focused on mobile application security testing guidance. It is primarily composed of markdown documentation files organized into structured categories with Python scripts for generating deliverables.

### Bootstrap and Environment Setup

**CRITICAL: Network Dependencies**
- **NEVER CANCEL**: Python dependency installation may fail due to network/firewall limitations with PyPI. Set timeout to 60+ minutes when attempting pip installs.
- **Docker builds may fail** due to SSL certificate verification issues with PyPI within containers.
- **Alternative approach**: Use the repository without full Python dependencies for basic documentation work.

#### Basic Environment (Always Works)
```bash
# Core tools that are always available
git --version
python3 --version  # Python 3.12.3
node --version     # Node.js for markdown linting
npm --version
docker --version
java --version     # For Android demo building
```

#### Python Dependencies (May Fail Due to Network)
```bash
# WARNING: This often fails due to firewall/network limitations
# NEVER CANCEL: Set timeout to 60+ minutes
pip3 install -r src/scripts/requirements.txt
```

**KNOWN ISSUE**: pip install frequently fails with SSL/network timeout errors. Document this in your work if encountered.

#### Docker Environment (May Fail Due to Network)
```bash
# WARNING: Docker build may fail due to SSL certificate issues
# NEVER CANCEL: Build takes 5-15 minutes when working. Set timeout to 30+ minutes.
docker build -t mastg-docs .
```

**KNOWN ISSUE**: Docker builds often fail during pip install step within container due to SSL verification.

### Markdown Linting and Validation (Always Works)
```bash
# Install markdown linting dependencies (usually works, takes ~1 second)
npm install markdownlint-rule-search-replace --save-dev

# Run markdown linting on single file (takes ~4 seconds)
npx markdownlint-cli2 --config .markdownlint.jsonc README.md

# Run on all files (takes ~4-11 seconds, may show lint errors)
npx markdownlint-cli2 --config .markdownlint.jsonc **/*.md
```

**NOTE**: Markdown linting processes 691 files and may report legitimate style issues that need fixing.

### Repository Validation Scripts (Always Work)
```bash
# Check for duplicate IDs (takes <1 second)
python3 .github/scripts/check_duplicate_ids.py

# Test case diff tool (requires YAML files)
python3 src/scripts/testcase_diff.py --help
```

### Website Development (Requires Docker Success)
```bash
# IF Docker build succeeded:
docker run -p 8000:8000 -v $(pwd):/workspaces/mastg mastg-docs

# This will start MkDocs server at http://localhost:8000
# NEVER CANCEL: MkDocs serves indefinitely until stopped
```

## Validation

**CRITICAL VALIDATION REQUIREMENTS:**
- **ALWAYS run markdown linting before committing changes** - this is enforced by CI
- **NEVER CANCEL long-running processes** - builds and tests have specific timeout requirements
- **Document network failures** when they occur rather than trying workarounds

### Required Validation Steps
1. **Markdown Linting** (4-11 seconds): `npx markdownlint-cli2 --config .markdownlint.jsonc **/*.md`
2. **Duplicate ID Check** (<1 second): `python3 .github/scripts/check_duplicate_ids.py`
3. **File Structure Validation**: Ensure any new files follow naming conventions (MASTG-*, MASVS-*)

### Manual Testing Scenarios
- **Documentation Changes**: Always validate markdown renders correctly and links work
- **Demo Script Changes**: Test that shell scripts have proper permissions and run without errors
- **Python Script Changes**: Test scripts with `--help` flag first, then with sample data

### CI Pipeline Validation
The CI will run these checks (you should pre-validate):
- **Markdown Linter** (4-11 seconds): Uses markdownlint-cli2 with custom configuration
- **Spell Checker**: Uses codespell with specific ignore list
- **URL Checker**: Validates all external links (may give false positives)
- **CodeQL Security Scan**: Analyzes Python code for security issues
- **Android Demo Builds** (30+ minutes): Builds APK files from demo code
- **Document Generation** (15+ minutes): Generates Excel checklists from markdown

**TIMING EXPECTATIONS:**
- Markdown linting: 4-11 seconds (processes 691 files)
- Duplicate ID check: <1 second  
- Full CI pipeline: 45+ minutes
- Android demo builds: 30+ minutes per demo
- Python dependency installs: Often fails, 60+ minutes when successful

## Common Tasks

### Repository Scale
- **703 markdown files** organized in structured categories
- **701 MASTG-prefixed files** following naming conventions  
- **123MB total size** including demos, documentation, and assets
- **Comprehensive coverage** of mobile security testing topics

### Repository Structure
```
/home/runner/work/mastg/mastg/
├── .github/                  # GitHub workflows and configurations
├── Document/                 # Main documentation files
├── techniques/               # Testing technique documentation
├── tests/                    # Test case documentation
├── tools/                    # Tool documentation
├── demos/                    # Demo applications and scripts
├── apps/                     # Mobile app documentation
├── src/scripts/              # Python utilities for deliverable generation
├── utils/                    # Utility scripts (bash)
├── Dockerfile               # Container for MkDocs development
└── README.md               # Project overview
```

### Frequently Used Commands Output

#### Repository Root Listing
```bash
ls -la
# Shows: .github, Document, techniques, tests, tools, demos, apps, etc.
```

#### Python Scripts Available
```bash
find . -name "*.py" | head -5
./.github/scripts/check_duplicate_ids.py      # ID validation
./src/scripts/yaml_to_excel.py               # Checklist generation  
./src/scripts/tools_healthcheck.py           # Tool validation
./src/scripts/testcase_diff.py               # Test case comparison
./src/contributors.py                        # Contributor management
```

#### Shell Scripts Available  
```bash
find . -name "*.sh" | head -5
./utils/mastg-android-backup-adb.sh          # Android backup utility
./demos/android/*/run.sh                     # Demo execution scripts
```

### Key File Locations
- **Main documentation**: `Document/`
- **Test cases**: `tests/android/`, `tests/ios/`
- **Techniques**: `techniques/android/`, `techniques/ios/`, `techniques/generic/`
- **Tools**: `tools/`
- **Android demos**: `demos/android/MASVS-*/MASTG-DEMO-*/`
- **iOS demos**: `demos/ios/MASVS-*/MASTG-DEMO-*/`
- **Python utilities**: `src/scripts/`
- **Bash utilities**: `utils/`

### Working with Demos
- **Android demos**: Each demo in `demos/android/` contains source files that get compiled into APKs
- **Demo structure**: Each demo has a run.sh script and may include Kotlin, XML, JavaScript files  
- **Build process**: Uses GitHub Actions to build APKs from demo source code
- **Testing**: Demos are designed to demonstrate specific security issues

### Working with Documentation
- **Markdown format**: All documentation uses markdown with YAML frontmatter
- **Cross-references**: Uses @MASTG-* format for internal references
- **Naming convention**: Files use MASTG-*, MASVS-* prefixes with specific numbering
- **Categories**: Organized by platform (android/ios/generic) and topic (MASVS-STORAGE, MASVS-CRYPTO, etc.)

## Important Notes

### Network Limitations
- **PyPI access**: Often blocked or has SSL certificate issues
- **Docker registry**: Usually accessible but pip within containers may fail
- **External links**: URL checker may report false positives due to rate limiting

### Build Expectations
- **Python installs**: Success rate is low due to network limitations
- **Markdown processing**: Always reliable and fast
- **Android builds**: Require Java/Gradle, take 30+ minutes
- **Documentation generation**: Works when Python dependencies are available

### Development Workflow
1. Make documentation changes in markdown files
2. Run markdown linting to validate
3. Check for duplicate IDs if adding new files  
4. Test any modified scripts with --help first
5. Commit changes (CI will run full validation)

**Remember**: This is primarily a documentation project. Most work involves editing markdown files and occasionally updating Python scripts for deliverable generation.