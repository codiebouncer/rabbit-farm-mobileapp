# AGENTS.md

This file defines how AI coding agents must work in this Flutter repository. Follow it together with the user's request and any more specific `AGENTS.md` found deeper in the project tree.

## 1. Mission

Build a reliable, maintainable, accessible Flutter mobile application without changing established behavior or architecture unnecessarily.

For every task:

1. Understand the requested outcome and inspect the relevant code before editing.
2. Make the smallest coherent change that fully solves the problem.
3. Preserve existing conventions unless the user explicitly requests a migration.
4. Run the most relevant formatting, analysis, and tests.
5. Report what changed, what was verified, and any remaining risk or blocker.

Never claim a command, test, build, migration, or user flow passed unless it was actually run successfully.

## 2. Instruction Priority

When instructions conflict, use this order:

1. The user's current request.
2. The nearest nested `AGENTS.md`.
3. This file.
4. Existing repository conventions.

Ask before making a decision that materially changes product behavior, public API contracts, persistence, authentication, payments, analytics, or supported platforms.

## 3. Inspect Before Editing

Before implementation, inspect only what is relevant:

- `pubspec.yaml` and `pubspec.lock`
- `analysis_options.yaml`
- the affected feature, tests, and shared components
- routing, dependency injection, API client, theme, and localization setup when applicable
- platform files under `android/` or `ios/` only when the task affects them

Use existing dependencies and patterns first. Do not introduce a package merely to save a few lines of code. Before adding one, explain why the SDK or current dependencies are insufficient, check compatibility with the project's Flutter/Dart versions, and prefer actively maintained packages.

Do not modify generated files manually. Common generated files include:

- `*.g.dart`
- `*.freezed.dart`
- generated localization files
- generated plugin registrants

Change the source or configuration and rerun the repository's generator instead.

## 4. Default Architecture

Preserve the architecture already present. For a new feature in a project without an established structure, use feature-first organization with clear presentation, domain, and data boundaries:

```text
lib/
  app/
    app.dart
    router/
    theme/
  core/
    api/
    errors/
    services/
    utils/
    widgets/
  features/
    <feature>/
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        bloc/
        pages/
        widgets/
  l10n/
  main.dart
test/
```

Do not create empty layers or one-line abstractions solely to match this diagram. Add boundaries when they protect business rules, external integrations, or testability.

### Dependency direction

- Presentation may depend on domain abstractions.
- Data implements domain repository contracts.
- Domain must not import Flutter UI, Dio, platform plugins, or concrete data sources.
- Features should communicate through explicit interfaces, not imports into another feature's internal folders.
- `core/` is for genuinely shared infrastructure, not miscellaneous feature code.

## 5. Preferred Project Stack

When the repository already uses these tools, follow their established setup:

- State management: `flutter_bloc`
- Value equality: `equatable`
- Networking: `dio`
- Dependency injection: `get_it`
- Navigation: `go_router`

Do not mix state-management, routing, HTTP, or dependency-injection approaches within the same feature. A migration must be explicitly requested and completed in a controlled, testable scope.

## 6. Dart and Flutter Coding Rules

- Follow Effective Dart and all configured lints.
- Keep null safety intact; do not use `!` unless the invariant is demonstrably guaranteed.
- Prefer `final`, immutable models, `const` constructors, and `const` widgets where meaningful.
- Prefer composition over inheritance.
- Keep widgets focused. Extract a widget when it has its own responsibility, state, semantics, or reuse value—not merely to reduce line count.
- Keep business logic out of widgets, route builders, and `build()` methods.
- Never perform network requests, persistence, dependency registration, or navigation side effects directly in `build()`.
- Avoid unbounded `Column` or `ListView` layouts and unnecessary nested scrolling.
- Check `context.mounted` after an `await` before using `BuildContext`.
- Dispose controllers, focus nodes, animation controllers, streams, and subscriptions owned by a widget or service.
- Avoid `dynamic`; deserialize external data defensively.
- Use named parameters for APIs with multiple or unclear arguments.
- Add comments for reasoning, invariants, and non-obvious trade-offs—not for restating code.
- Do not leave debug prints, commented-out code, fake production data, or unresolved TODOs without an issue/reference and explanation.

## 7. State Management

For BLoC/Cubit code:

- One state owner should represent one cohesive user workflow.
- Events describe user or system intent; states describe observable UI conditions.
- Keep states immutable and equatable.
- Model initial, loading, success, empty, and failure states where the UI distinguishes them.
- Prevent duplicate submissions and accidental concurrent operations.
- Keep repository and use-case calls out of widgets.
- Use `BlocBuilder` for rendering, `BlocListener` for one-time effects, and `BlocSelector` or `buildWhen` only when measurable rebuild control is useful.
- Do not navigate or show snackbars from a bloc.
- Do not emit after a bloc or cubit is closed.
- When refreshing existing content, prefer preserving usable data while showing refresh progress instead of replacing the entire screen with a loader.

## 8. Networking and API Contracts

- Keep base URLs, timeouts, and environment-specific configuration outside feature widgets.
- Use the project's configured Dio instance and interceptors.
- Keep authentication and refresh-token behavior centralized.
- Never log access tokens, refresh tokens, passwords, OTPs, payment details, cookies, full authorization headers, or sensitive personal data.
- Map transport models to domain entities at the data boundary.
- Treat response fields as untrusted. Validate required fields, nullable values, enums, dates, and numeric conversions.
- Preserve the backend's documented request/response contract. Do not silently rename fields or invent fallback values that hide invalid server data.
- Convert Dio and platform exceptions into the project's typed failures. UI-facing messages should be safe, understandable, and actionable.
- Handle offline, timeout, cancelled, unauthorized, validation, server, parsing, and unknown failures when relevant.
- Cancel requests only when cancellation is supported by the flow and cannot corrupt state.
- Do not retry non-idempotent requests automatically unless the backend provides an idempotency mechanism.

## 9. Models and Serialization

- Follow the repository's existing model approach, whether manual, `json_serializable`, Freezed, or another generator.
- Keep API DTOs separate from domain entities when transport concerns differ from business concepts.
- Parse timestamps explicitly and consistently. Store/transport UTC unless the contract states otherwise; localize only for display.
- Represent money using the project's precise decimal/minor-unit strategy—never binary floating-point for financial calculations.
- Handle unknown enum values safely when the server may add values independently.
- After annotated model changes, run the established code-generation command and include all required generated output if the repository commits it.

## 10. Navigation and Authentication

- Keep route names/paths centralized and typed where the project supports it.
- Pass identifiers or small serializable arguments through navigation; load authoritative data through the relevant state owner.
- Preserve deep links, back behavior, nested navigation, and state restoration.
- Route guards must rely on authoritative authentication/authorization state, not UI visibility.
- Hiding a control is not authorization. The backend remains responsible for enforcing permissions.
- On logout, clear sensitive in-memory state and locally stored credentials using the existing auth service.
- Do not create redirect loops during auth loading, token refresh, onboarding, or role resolution.

## 11. UI and Design System

- Reuse the project's theme, typography, spacing, color tokens, icons, and shared components.
- Do not hardcode colors, text styles, radii, shadows, or repeated spacing when a design token exists.
- Support text scaling and avoid fixed-height text containers that clip content.
- Respect safe areas, keyboard insets, orientation, and common phone sizes.
- Every data-driven page should deliberately handle loading, empty, error, and success states.
- Forms must show field-level validation, preserve input after recoverable failures, prevent duplicate submission, and make disabled/loading states clear.
- Use optimistic UI only when rollback behavior is defined and tested.
- Avoid unrelated visual redesigns during functional fixes.

## 12. Accessibility and Localization

- Provide semantic labels for meaningful icons, images, and custom controls.
- Ensure interactive targets are at least 48 by 48 logical pixels where practical.
- Maintain sufficient color contrast and never communicate status using color alone.
- Preserve logical focus and traversal order; support keyboard interaction where the platform permits it.
- Announce important asynchronous outcomes accessibly.
- Do not concatenate translated fragments into sentences.
- Put user-visible strings in the established localization system; use pluralization, date, number, and currency formatting appropriate to locale.
- Test layouts with large text and long translated strings when changing UI.

## 13. Security and Privacy

- Never commit secrets, signing files, production credentials, service-account files, or real user data.
- Do not place secrets in Dart code or bundled assets; mobile binaries are inspectable.
- Use the project's secure-storage solution for credentials. Do not store sensitive values in plain preferences.
- Validate untrusted deep links, file paths, URLs, and external intents.
- Use HTTPS for production endpoints and keep any certificate-pinning behavior consistent with the existing security design.
- Request only necessary device permissions and provide clear purpose text.
- Redact sensitive fields from logs, crash reports, analytics, screenshots, and tests.
- Do not weaken TLS, authentication, authorization, input validation, or platform security to make development easier.

## 14. Performance

- Optimize after identifying a real risk or measurement; do not obscure code for speculative gains.
- Use lazy builders for long or dynamic lists.
- Paginate large datasets and prevent duplicate page requests.
- Avoid expensive parsing, image processing, or computation on the UI isolate; move demonstrably heavy work to an isolate.
- Constrain and cache images appropriately using established project tooling.
- Reduce unnecessary rebuilds through proper widget boundaries and state selection.
- Never trade correctness, accessibility, or maintainability for a micro-optimization without evidence.

## 15. Testing Expectations

Add or update tests whenever behavior changes.

Use the smallest effective test level:

- Unit tests for use cases, repositories, parsing, validation, blocs/cubits, and utilities.
- Widget tests for rendering, interactions, validation, accessibility semantics, and state-driven UI.
- Golden tests only if the repository already uses a stable golden workflow or the task explicitly requires them.
- Integration tests for critical cross-screen flows such as authentication, checkout/payment, persistence, and deep links.

Tests should cover the happy path plus meaningful failures and boundary cases. Prefer fakes for simple deterministic collaborators and mocks where interaction verification matters. Do not call live production services in automated tests.

When fixing a bug, first add a regression test that fails for the original behavior when practical.

Do not weaken assertions, delete tests, add broad ignores, or increase timeouts merely to make the suite pass.

## 16. Commands and Verification

Use the repository's pinned Flutter version or version manager when present. Prefer project scripts documented in the repository.

Typical verification sequence:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

When code generation is configured, use the repository's command; a common default is:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For a focused change, run focused tests first, then the broader relevant suite. Run platform builds when native configuration, plugins, permissions, signing-related configuration, flavors, or release behavior changed:

```bash
flutter build apk --debug
flutter build ios --no-codesign
```

Run only commands supported by the available environment. If iOS tooling is unavailable, say so clearly instead of claiming iOS verification.

## 17. Platform-Specific Changes

- Keep Android and iOS behavior aligned unless the requirement is platform-specific.
- Before changing minimum SDK/deployment targets, Gradle, Kotlin, Java, Swift, CocoaPods, manifests, entitlements, permissions, or signing configuration, inspect current constraints and plugin requirements.
- Do not modify signing identities, keystores, provisioning profiles, bundle identifiers, application IDs, or store configuration without explicit authorization.
- Explain any new permission and ensure it is requested only when needed.

## 18. Data and Persistence

- Preserve backward compatibility for persisted models when possible.
- Schema changes require a deliberate migration and tests for upgrading existing data.
- Never solve a migration failure by deleting user data unless the user explicitly authorizes that behavior.
- Make multi-step writes atomic when partial completion would create inconsistent state.
- Define conflict, retry, and synchronization behavior for offline-capable features.

## 19. Git and Scope Discipline

- Treat existing uncommitted changes as user work. Do not overwrite or revert them.
- Do not use destructive Git commands or rewrite history unless explicitly requested.
- Keep changes limited to the task. Avoid drive-by refactors, mass formatting, dependency upgrades, and generated-file churn.
- Do not commit, push, open a pull request, deploy, publish, or change remote services unless the user asks.
- If generated files are tracked, keep them synchronized with their source changes.

## 20. Definition of Done

A task is complete when:

- the requested behavior is implemented;
- relevant architecture and API contracts are preserved;
- loading, empty, error, and edge states are handled where applicable;
- accessibility and localization implications are addressed;
- secrets and sensitive data are protected;
- changed code is formatted;
- relevant analysis, tests, generators, and builds have been run successfully, or limitations are stated;
- the final report is concise and factual.

Use this final report format:

1. **Outcome** — what now works.
2. **Changed** — important files or components and why.
3. **Verified** — exact checks run and their results.
4. **Remaining** — blockers, risks, assumptions, or follow-up work; omit if none.

## 21. Stop and Ask

Pause and ask the user when:

- requirements are contradictory or materially ambiguous;
- a change would alter a public API, data schema, authentication, authorization, payment, or privacy behavior beyond the request;
- required credentials, design decisions, backend contracts, or platform access are missing;
- existing user changes conflict with the requested implementation;
- the only apparent solution is destructive or would remove user data;
- a dependency or SDK migration would have broad project impact.

Otherwise, proceed autonomously: inspect, implement, verify, and report.
