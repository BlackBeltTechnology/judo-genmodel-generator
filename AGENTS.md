# JUDO GenModel Generator - Project Documentation

## Project Overview


**Repository:** BlackBeltTechnology/judo-genmodel-generator
**License:** Eclipse Public License 2.0 (EPL-2.0)
**Java Version:** 21 (compiler targets Java 11 bytecode via Tycho)
**Build System:** Maven 3.9.4 with Tycho 4.0.13 (Eclipse PDE build) and Xtext/Xtend 2.39.0

1. Generates JUDO runtime helper classes for EMF GenModels — producing type-safe Java wrapper classes with fluent builder APIs, load/save operations, and validation support
2. Uses Xtend templates to transform EMF `.genmodel` definitions into `{ModelName}Model.java` runtime classes
3. Orchestrates code generation through an MWE2 (Modeling Workflow Engine) pipeline with Guice dependency injection
4. Distributed as an Eclipse plugin via a P2 Update Site for installation into Eclipse-based IDEs
5. Part of the JUDO NG platform by BlackBelt Technology

## Code Instructions

1. First think through the problem, read the codebase for relevant files.
2. Before you make any major changes, check in with me and I will verify the plan.
3. Please every step of the way just give me a high level explanation of what changes you made.
4. Make every task and code change you do as simple as possible. We want to avoid making any massive or complex changes. Every change should impact as little code as possible. Everything is about simplicity.
5. Maintain a documentation file that describes how the architecture of the app works inside and out.
6. Never speculate about code you have not opened. If the user references a specific file, you MUST read the file before answering. Make sure to investigate and read relevant files BEFORE answering questions about the codebase. Never make any claims about code before investigating unless you are certain of the correct answer - give grounded and hallucination-free answers.
7. For implementation use TDD (Test-Driven Development): write or update tests first to define the expected behaviour, verify they fail, then write the minimal implementation to make them pass.
8. Use DRY (Don't Repeat Yourself): extract reusable logic into separate classes, utilities, or components. If the same pattern appears in multiple places, refactor it into a shared helper.

## Directory Structure

```
judo-genmodel-generator/
├── runtimemodel/           # Core Eclipse plugin — all source code lives here
│   ├── src/                # Xtend/Java sources (Eclipse PDE layout, NOT src/main/java)
│   ├── META-INF/           # OSGi bundle manifest
│   └── xtend-gen/          # Generated Java from Xtend (build output)
├── feature/                # Eclipse Feature packaging
│   └── feature.xml         # Feature descriptor
├── site/                   # P2 Update Site
│   └── category.xml        # Update site category definition
├── .mvn/                   # Maven Wrapper config and JVM arguments
├── .github/                # CI/CD workflows and documentation
├── .vscode/                # VS Code Java settings
├── .zed/                   # Zed editor settings
└── openspec/               # OpenSpec configuration and specs
```

## Core Modules

### Generator Plugin

| Module | Type | Purpose |
|--------|------|---------|
| `runtimemodel/` | `eclipse-plugin` | Core OSGi bundle containing the code generation engine: MWE2 workflow, Guice DI module, Xtend code generation templates, and naming utilities |

### Distribution

| Module | Type | Purpose |
|--------|------|---------|
| `feature/` | `eclipse-feature` | Eclipse Feature that packages the runtimemodel plugin for installation |
| `site/` | `eclipse-repository` | P2 Update Site aggregating features into a deployable repository |

## Technology Stack

### Core Technologies
- **Xtend 2.39.0** — JVM language used for code generation templates (compiles to Java via xtend-maven-plugin)
- **Eclipse MWE2** — Modeling Workflow Engine that orchestrates the generation pipeline
- **Eclipse EMF** — Eclipse Modeling Framework; the generator reads `.genmodel` files and produces model wrappers
- **Google Guice** — Dependency injection for binding generator components (`IGenerator2` interface)
- **Eclipse Xtext 2.39.0** — Language engineering framework providing the `IGenerator2` contract and file system access
- **Tycho 4.0.13** — Maven plugin for building Eclipse/OSGi bundles, features, and update sites

### Build & Quality
- **Maven 3.9.4** (via `./mvnw` wrapper with JVM config in `.mvn/jvm.config`)
- **Maven Surefire 3.5.1** — test execution
- **JaCoCo 0.8.12** — code coverage reporting
- **SonarQube** (sonar-maven-plugin 3.9.1.2184) — static analysis
- **Flatten Maven Plugin** — resolves CI-friendly `${revision}` version placeholders
- **Lombok 1.18.34** — boilerplate reduction annotations

## Build Commands

> Always use `./mvnw` (Maven Wrapper) — it pins the correct Maven version and JVM arguments.

```bash
# Full clean build (all modules)
./mvnw clean install

# Run tests only
./mvnw clean test

# Build without submodules (parent POM only)
./mvnw clean install -DskipModules=true

# Generate code coverage report
./mvnw clean test jacoco:report
```

### Maven Profiles

| Profile | Purpose |
|---------|---------|
| `modules` | Active by default — includes runtimemodel, feature, site. Deactivate with `-DskipModules=true` |
| `sign-artifacts` | GPG-signs artifacts for release distribution |
| `release-dummy` | Deploys to local `/tmp/` for testing the release process |
| `release-judong` | Deploys to JudoNG Nexus snapshot repository |
| `release-central` | Deploys to Maven Central via Sonatype OSSRH |
| `generate-github-asciidoc-diagrams` | Generates PNG diagrams from AsciiDoc documentation |
| `update-source-code-license` | Updates EPL-2.0 license headers across all source files |

## Key Configuration Files

| File | Purpose |
|------|---------|
| `pom.xml` | Parent POM — defines all dependency versions, plugin configurations, profiles, and module list |
| `.mvn/jvm.config` | JVM arguments for Maven: heap size (1024m–2048m), module opens, P2 mirror disable |
| `.mvn/extensions.xml` | Maven wagon extensions for file and WebDAV transport |
| `runtimemodel/META-INF/MANIFEST.MF` | OSGi bundle manifest — declares dependencies, exported packages, execution environment |
| `runtimemodel/build.properties` | Eclipse PDE build properties — source folders, output, binary includes |
| `runtimemodel/plugin.properties` | Eclipse plugin display metadata |
| `feature/feature.xml` | Eclipse Feature descriptor — lists included plugins |
| `site/category.xml` | P2 Update Site category — organizes features for the update site |
| `logback-test.xml` | Test logging configuration (used by Surefire via system property) |

## Source Code Layout

The `runtimemodel/` module uses Eclipse PDE conventions (source in `src/`, not `src/main/java/`):

```
runtimemodel/src/hu/blackbelt/judo/eclipse/emf/genmodel/generator/runtimemodel/
├── RuntimeModelGeneratorWorkflow.xtend  — MWE2 workflow component (orchestrates the pipeline)
├── engine/
│   ├── RuntimeModelGeneratorModule.java        — Guice module (binds IGenerator2)
│   ├── RuntimeModelGeneratorStandaloneSetup.java — Standalone injector setup
│   ├── RuntimeModelGeneratorConfig.xtend       — Configuration (modelDir, genModelNames, etc.)
│   └── GeneratorWorkflow.mwe2                  — MWE2 workflow definition
└── templates/
    ├── RuntimeModelGenerator.xtend  — IGenerator2 impl (entry point for generation)
    ├── RuntimeModel.xtend           — Main template (generates {ModelName}Model.java)
    └── Naming.xtend                 — Naming/package path utility extensions
```

## Development Environment

**Required:**
- Java 21 JDK ([Azul Zulu](https://www.azul.com/downloads/?version=java-21-lts&package=jdk) recommended)
- Maven 3.9.4+ (provided via `./mvnw`)

**Target Platform:**
- The Tycho build resolves Eclipse platform dependencies from P2 repositories
- Target environments: Linux (x86_64, aarch64), Windows (x86_64), macOS (x86_64, aarch64)

## Git Workflow

- **Main Branch:** `develop`
- **Release Branch:** `master`
- **Versioning:** `1.1.2-SNAPSHOT` (CI-friendly via `${revision}` property)
- **Branch naming:** `feature/JNG-XXX_description`, `bugfix/JNG-XXX_description`, `hotfix/JNG-XXX_description`
- **Commit rule:** Every commit must reference a JIRA ticket (`JNG-xxx`)
- **PR model:** GitHub forking model — fork the repo and submit PRs
- **CI/CD:** GitHub Actions with automated build, merge, and release workflows (see [CIFLOW.md](.github/CIFLOW.md))

## Important Notes

1. Source files use **Xtend** (`.xtend`), not plain Java — Xtend compiles to Java in the `xtend-gen/` directory during the build via the `xtend-maven-plugin`
2. The project uses **Eclipse PDE layout** (`src/` instead of `src/main/java/`) — this is required by Tycho and the OSGi bundle structure
3. The core generator framework classes (`AbstractGenModelGeneratorModule`, `AbstractGenModelGeneratorStandaloneSetup`, `GeneratorConfig`) come from the **`hu.blackbelt.eclipse.emf.genmodel.generator.core`** bundle — this is an external dependency resolved from the P2 repository
4. The `RuntimeModel.xtend` template is the heart of the project — it generates complete Java classes with builders, loaders, savers, validators, and exception classes for each GenModel
5. Generated output goes to `{javaGenPath}/{packagePath}/runtime/{ModelName}Model.java` — the `runtime` sub-package is hardcoded in the template
6. Configuration is injected via Guice: `RuntimeModelGeneratorConfig` holds `resolveModelName`, `resolveModelVersion`, and `genModelNames` which control which GenModels are processed and how the generated code behaves
7. The `bin/` directory contains Eclipse PDE build output and is gitignored — always look at `src/` for the authoritative source code

## Related Documentation

- [README.md](README.md) — Project overview and architecture diagrams
- [CONTRIBUTING.md](CONTRIBUTING.md) — Development setup and submission guidelines
- [.github/CIFLOW.md](.github/CIFLOW.md) — CI/CD pipeline and GitFlow branching strategy
