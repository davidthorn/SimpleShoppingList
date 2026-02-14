# AGENTS.md

This file defines repository-specific rules for coding agents (including Codex) working on `SimpleShoppingList`.

## Mission

Keep this project a clean, scalable SwiftUI scaffold that junior and intermediate developers can adopt and extend.

Prioritize:

- clear architecture boundaries
- safe concurrency
- testable dependencies
- maintainable feature growth

## Non-Negotiable Rules

1. Keep Swift version compatibility at **Swift 6**.
2. Do not add business logic directly in Views.
3. Keep navigation ownership in `Scene` types.
4. Keep persistence/state mutation in the store layer (`Services/ShoppingStore.swift`), not in views/view models.
5. Use protocol-driven dependency injection at boundaries.
6. Keep store streaming based on `AsyncStream` (do not replace with Combine in store layer).

## Project Architecture

### Folder responsibilities

- `Scenes/`: top-level navigation owners (`NavigationStack` + destinations)
- `Views/`: screen UI only
- `Components/`: reusable UI units shared by views
- `ViewModels/`: presentation/business logic, async workflows, derived UI state
- `Services/`: concrete service implementations (including actor-backed store) + service container
- `Protocols/`: dependency contracts (`*Protocol`)
- `Routes/`: route enums used by scene-owned navigation
- `Models/`: domain models + sample data

### Navigation rules

- `Scene` owns `.navigationDestination(for:)` for its flow.
- Child views/components emit route values, but do not own destination mapping.
- Do not scatter navigation destination wiring across feature views.

## View / ViewModel Rules

1. Views render state and forward user actions.
2. ViewModels perform async work and hold mutable presentation state.
3. If logic grows beyond simple UI glue, move it from View to ViewModel.
4. Keep view models `@MainActor` when publishing UI-facing state.
5. View starts async work using `Task` and calls async ViewModel methods.

## Store + Concurrency Rules

1. Store implementation is actor-backed for serialized mutable access.
2. Expose change stream using `AsyncStream`.
3. Treat store snapshots as canonical state for view models.
4. Avoid manual synchronization primitives when actor isolation already solves the problem.
5. Keep file persistence concerns in store layer only.
6. Persist shopping data to Documents directory JSON.

## Dependency Injection Rules

1. Depend on protocols (`*Protocol`) at boundaries.
2. Compose concrete implementations in app root/container.
3. Prefer initializer injection.
4. Avoid direct concrete construction deep inside Views/ViewModels.
5. Keep dependencies swappable for tests.

## Existential / `any` Guidance

Current default in this repo is protocol-driven DI without introducing `any` broadly.

- Do not introduce `any` pervasively unless specifically requested or justified.
- If introduced in future, do it intentionally at clear dependency boundaries.

## Styling and UI Changes

1. Preserve the existing visual language unless user asks for a redesign.
2. Keep accessibility in mind (readable typography, contrast, VoiceOver labels for key dynamic values).
3. Keep reusable styling decisions consistent across views/components.

## When Adding Features

Follow this sequence:

1. Model updates in `Models/`
2. Protocol updates in `Protocols/`
3. Store/service updates in `Services/`
4. ViewModel updates in `ViewModels/`
5. UI in `Views/` / `Components/`
6. Route and destination updates in owning `Scene` and `Routes/`
7. Container wiring updates in `Services/` or app root

## Testing Guidance

- Prefer tests for store and view model behavior.
- Favor deterministic tests via protocol stubs and injectable dependencies.
- Do not couple tests to real documents directory persistence.

## Contribution Expectations

- Keep PRs focused and small when possible.
- Preserve architecture boundaries; do not “quick-fix” by breaking layering.
- Document noteworthy architectural changes in `README.md`.
