# runtimemodel Specification

## Purpose

The runtimemodel module is an Eclipse plugin that generates Java runtime model wrapper classes from EMF GenModel definitions. It produces `{ModelName}Model.java` files containing fluent builders, load/save operations, validation, diagnostics, and EMF ResourceSet management — giving consumers a clean API over raw EMF resources.

## Architecture

The module consists of three layers:

- **Workflow layer** (`RuntimeModelGeneratorWorkflow`) — MWE2 component that orchestrates the generation pipeline: configures model directories, registers readers, sets up outlets, and invokes the generator.
- **Engine layer** (`RuntimeModelGeneratorModule`, `RuntimeModelGeneratorStandaloneSetup`, `RuntimeModelGeneratorConfig`) — Guice-based dependency injection setup that binds the `IGenerator2` interface to the template implementation and manages configuration.
- **Template layer** (`RuntimeModelGenerator`, `RuntimeModel`, `Naming`) — Xtend code generation templates that implement `IGenerator2`, iterate over GenModel resources, and expand Xtend string templates into Java source files.

Key classes and their relationships:
- `RuntimeModelGeneratorWorkflow` creates `RuntimeModelGeneratorStandaloneSetup` with `RuntimeModelGeneratorConfig`
- `RuntimeModelGeneratorStandaloneSetup` creates a Guice injector using `RuntimeModelGeneratorModule`
- `RuntimeModelGeneratorModule` binds `IGenerator2` to `RuntimeModelGenerator`
- `RuntimeModelGenerator` delegates to `RuntimeModel` (injected) for actual code generation
- `RuntimeModel` uses `Naming` (injected extension) for package/path conventions
- `RuntimeModel` reads `RuntimeModelGeneratorConfig` (injected) for model name/version resolution and GenModel filtering

## Requirements

### Requirement: GenModel filtering by configuration

The generator SHALL only process GenModel resources whose names are listed in `RuntimeModelGeneratorConfig.genModelNames`.

#### Scenario: Matching GenModel is processed
- **GIVEN** a `RuntimeModelGeneratorConfig` with `genModelNames` containing `"MyModel"`
- **WHEN** the generator encounters a GenModel resource named `MyModel`
- **THEN** it SHALL generate a `MyModelModel.java` output file

#### Scenario: Non-matching GenModel is skipped
- **GIVEN** a `RuntimeModelGeneratorConfig` with `genModelNames` containing only `"MyModel"`
- **WHEN** the generator encounters a GenModel resource named `OtherModel`
- **THEN** it SHALL NOT generate any output for that GenModel

### Requirement: Output file placement

The generator SHALL write generated files to `{javaGenPath}/{packagePath}/runtime/{ModelName}Model.java` where `packagePath` is derived from the GenModel's root package.

#### Scenario: Correct output path
- **GIVEN** a GenModel with root package `com.example.model` and model name `Foo`
- **WHEN** the generator produces output
- **THEN** the file SHALL be written to `{javaGenPath}/com/example/model/runtime/FooModel.java`

### Requirement: Generated class contains builder

The generated `{ModelName}Model.java` SHALL include a static `build{ModelName}Model()` method that returns a `{ModelName}ModelBuilder` with fluent setter methods for `name`, `uri`, `version`, `resourceSet`, and `uriHandler`.

#### Scenario: Builder creates valid model instance
- **GIVEN** the generated `FooModel` class
- **WHEN** a caller invokes `FooModel.buildFooModel().name("test").uri(someUri).build()`
- **THEN** a `FooModel` instance SHALL be returned with the specified name and URI

### Requirement: Generated class supports load operations

The generated class SHALL provide static `load{ModelName}Model(LoadArguments)` factory methods and instance `loadResource(LoadArguments)` methods for loading model content from URI, File, or InputStream sources.

#### Scenario: Load from URI
- **GIVEN** a valid EMF model file at a known URI
- **WHEN** `FooModel.loadFooModel(LoadArguments.fooLoadArgumentsBuilder().uri(modelUri).build())` is called
- **THEN** a `FooModel` instance SHALL be returned with the model content loaded

#### Scenario: Load with validation enabled
- **GIVEN** a model file containing validation errors
- **WHEN** loading with `validateModel(true)` (the default)
- **THEN** a `FooValidationException` SHALL be thrown containing diagnostic details

### Requirement: Generated class supports save operations

The generated class SHALL provide `save{ModelName}Model()` methods that persist the model content to File, OutputStream, or the original URI, with optional validation before saving.

#### Scenario: Save to file
- **GIVEN** a loaded `FooModel` instance
- **WHEN** `saveFooModel(SaveArguments.fooSaveArgumentsBuilder().file(outputFile).build())` is called
- **THEN** the model content SHALL be written to the specified file

### Requirement: Generated class provides validation and diagnostics

The generated class SHALL provide `isValid()`, `getDiagnostics()`, and `getDiagnosticsAsString()` methods for inspecting model validation state.

#### Scenario: Valid model
- **GIVEN** a `FooModel` with no ERROR-level diagnostics
- **WHEN** `isValid()` is called
- **THEN** it SHALL return `true`

#### Scenario: Invalid model diagnostics
- **GIVEN** a `FooModel` with ERROR-level diagnostics
- **WHEN** `getDiagnostics()` is called
- **THEN** it SHALL return a non-empty `Set<Diagnostic>` containing all WARN and ERROR diagnostics

### Requirement: Conditional name/version fields based on configuration

When `RuntimeModelGeneratorConfig.resolveModelName` is blank, the generated class SHALL include a configurable `name` field and corresponding builder method. When it is non-blank, the name SHALL be hardcoded to the configured value.

#### Scenario: Blank resolveModelName
- **GIVEN** `resolveModelName` is empty
- **WHEN** the class is generated
- **THEN** the generated builder SHALL include a `name(String)` method and the model SHALL have a mutable `name` field

#### Scenario: Non-blank resolveModelName
- **GIVEN** `resolveModelName` is `"fixedName"`
- **WHEN** the class is generated
- **THEN** the generated `getName()` SHALL return `"fixedName"` and no `name(String)` builder method SHALL be generated

### Requirement: Guice dependency injection binding

`RuntimeModelGeneratorModule.bindIGenerator2()` SHALL return `RuntimeModelGenerator.class`, ensuring the Xtext generation framework uses the correct generator implementation.

#### Scenario: Correct binding
- **WHEN** the Guice injector is created from `RuntimeModelGeneratorModule`
- **THEN** `IGenerator2` SHALL resolve to an instance of `RuntimeModelGenerator`

### Requirement: MWE2 workflow pipeline setup

`RuntimeModelGeneratorWorkflow.preInvoke()` SHALL configure the MWE2 pipeline with a resource reader, the generator standalone setup, and a generator component with the configured output directory.

#### Scenario: Workflow configuration
- **GIVEN** a `RuntimeModelGeneratorWorkflow` with `modelDir="/models"` and `javaGenPath="/output"`
- **WHEN** `preInvoke()` is called
- **THEN** the workflow SHALL register a reader for the model directory and a generator component targeting the output directory

### Requirement: Naming conventions

The `Naming` utility class SHALL derive package names from `GenModel.genPackages[0].basePackage + "." + genPackages[0].ecorePackage.name` and convert them to file paths by replacing dots with slashes.

#### Scenario: Package name derivation
- **GIVEN** a GenModel with `basePackage = "com.example"` and `ecorePackage.name = "model"`
- **WHEN** `packageName(genModel)` is called
- **THEN** it SHALL return `"com.example.model"`

#### Scenario: Package path derivation
- **GIVEN** a GenModel with package name `"com.example.model"`
- **WHEN** `packagePath(genModel)` is called
- **THEN** it SHALL return `"com/example/model"`
