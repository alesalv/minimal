<!--
  This file contains the Antigravity Agent Rules.
  These rules are functionally identical to the Cursor rules located in example/.cursor/rules/,
  consolidated into this single file for Antigravity's AGENTS.md format.
-->

# Antigravity Agent Rules

## Project Expertise
- Flutter for cross-platform development
- Dart as the primary programming language
- Minimal for state management and dependency injection
- Dart Mappable for immutable data models
- Firebase for backend services
- MVN design pattern
- Feature-first folder structure
- Clean separation of concerns

## Flutter Architecture
- Organize code according to feature-based MVN pattern:
  - featureA/
    - notifiers/
    - models/
      - data/
      - data_sources/
      - repositories/
    - views/
      - pages/
      - ui_states/
      - widgets/
- Place cross-feature components in the `core` directory
- Group shared widgets in `core/views/widgets` by type (animations, buttons, cards, etc)

### Notifiers
- Use MMNotifier for state management
- Consider notifiers as state holders
- For a notifier which holds a UI state, handle loading and error in the UI state explicitely
- Usually use one notifier per page or per widget
- Notifiers are focused on a single responsibility
- Notifiers depend on repositories, and sometimes on other notifiers

### Views
- Keep widgets small and focused
- Extract reusable widgets
- Each page widget must have a well defined corresponding UI state
- Widget build() method only builds, doesn't contain any business logic

## Data Models
The application uses a three-layer data model pattern to handle data transformation and state management:

1. **API Layer (ItemApiModel)**
   - Represents the raw data structure as received from the server
   - Contains all fields provided by the API
   - Should match the API contract exactly

2. **Domain Layer (Item)**
   - Represents the internal data model
   - Contains only the fields necessary for business logic
   - Strips out unnecessary API fields

3. **UI Layer (ItemUiState)**
   - Represents the data model optimized for UI rendering
   - Contains parsed and formatted data ready for display
   - Handles all UI-specific transformations

### Rules
- Use Dart Mappable for defining immutable UI states
- Each layer should have its own type definition
- The UI layer should use the UI state data models, never directly the domain model or the API model
- The UI state model should be derived from the domain model, not the API model
- The domain model should be derived from the API model, not the UI state model
- The repository should be the source of truth, and it returns the domain model (for example Item)
- The repository use data sources, which return the API model (for example ItemApiModel)

## State Management
- Use Minimal as the primary state management and dependency injection solution
- Use `MMManager` to provide a `MMNotifier`
- Use `MMLocator` to provide repositories and services
- Organize notifiers logically by feature

## Dart Coding
- Write concise, technical Dart code with accurate examples
- Use functional and declarative programming patterns
- Choose descriptive variable names with auxiliary verbs (e.g., `isLoading`, `hasError`)
- Keep functions and classes short (< 200 lines, < 10 public methods)
- Always use English for code and documentation
- Use PascalCase for classes, camelCase for variables and functions, snake_case for files, UPPERCASE for constants
- Use arrow syntax for simple methods and expression bodies for one-line getters/setters
- Avoid nesting blocks; prefer early checks and returns
- Pass and return parameters using RO-RO (Receive Object, Return Object)
- Avoid magic numbers; use well-named constants
- Follow an 100-character line limit and use trailing commas for better formatting
- Follow the lint rules set for this project (enabled in `all_lint_rules.yaml`, selectively disabled in `analysis_options.yaml`)
- Prefer `debugPrint()` over `print()` for debugging

## UI Design
- Keep widgets focused and composable with clear responsibilities
- Flatten widget hierarchies where reasonable for better rendering performance
- Design mobile first
- Use `LayoutBuilder` and `MediaQuery` for adaptive layouts
- Centralize themes and styles in `ThemeData` for consistency
- Design for different screen sizes and orientations using responsive breakpoints
- Use a loading indicator while fetching data
- Use an error indicator with appropriate messaging for error displays
- Handle empty states gracefully in UI with clear messaging

## Performance
- Optimize list views with `ListView.builder`
- Optimize image handling with `cached_network_image`
- Use `const` widgets and flatten widget hierarchies for improved rendering efficiency
- Handle asynchronous operations cleanly with proper cancellation during widget disposal
- Minimize unnecessary rebuilds using memoization techniques
- Implement pagination for large data sets

## Code Generation
- Generate code for Mappable classes, JSON serialization, and other generated code.
- Use this command for code generation: `fvm dart run build_runner build --delete-conflicting-outputs` (or `scripts/generate_models.sh`)
- Run code generation after adding or modifying Mappable classes

## Error Handling
- Throw errors when needed, and catch them at appropriate boundaries
- Log errors with context
- Present user-friendly error messages in the UI
- Avoid silent failures; always handle or propagate errors

## Testing
- Follow the Arrange-Act-Assert convention for clear and maintainable tests
- Use mocks for dependencies except for lightweight third-party services
- Test business logic in isolation from the UI
- Write widget tests for all major UI components
- Test user interactions and state changes

## Git Workflow
- Write atomic commits
- Do not commit files that are not related to the current feature
- When committing, write a short description of the changes you are making
- When creating a new feature, create a new branch from the `main` branch
- When merging a feature, merge the branch into the `main` branch
- **NEVER** automatically run `git merge`, `git push`, or `git tag` without explicitly asking the user for permission first. Always present the plan and wait for a clear "yes" before executing these final release/destructive actions.

## Documentation
- Follow official documentation for best practices (Flutter and Minimal Documentation)
- Document public classes and methods with clear descriptions, parameters, return values, and a code snippet taken from the codebase
- Comment briefly only complex logic and non-obvious code decisions
