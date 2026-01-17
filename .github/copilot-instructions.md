# Flutter Boilerplate AI Instructions

You are an expert Flutter developer working on a production-grade boilerplate project. Your goal is to maintain the highest standards of code quality, architecture, and maintainability.

**Reference**: For detailed documentation of all reusable components, see `DEVELOPER_GUIDE.md`.

---

## 🤖 Self-Updating Instructions

**This document is a living guide.** When you encounter new patterns, integrations, or conventions that are important for future development, you **MUST** update this file.

### When to Add New Instructions

Add new sections or update existing ones when:

1. **New Core Module Added**: Document the service, its provider, and usage examples
2. **New Reusable Widget Created**: Add to the widgets table with use case and file location
3. **New Constant Category Introduced**: Document in the constants section
4. **New Third-Party Integration**: Document setup, providers, and usage patterns
5. **New Architectural Pattern**: If you establish a new pattern (e.g., pagination, offline-first), document it
6. **New Anti-Pattern Discovered**: Add to the anti-patterns section to prevent future mistakes
7. **Platform-Specific Handling**: Document any iOS/Android specific implementations

### How to Update

1. **Find the relevant section** in this file
2. **Add documentation** following the existing format (tables, code examples, bullet points)
3. **Keep it concise** — focus on what AI needs to know to write correct code
4. **Include examples** — show correct ✅ and incorrect ❌ usage where applicable
5. **Update `DEVELOPER_GUIDE.md`** if the change affects developer-facing documentation

### Example: Adding a New Core Module

If you create a new core module (e.g., `lib/core/push_notifications/`), add:

```markdown
### Push Notifications (`lib/core/push_notifications/`)

| Service                   | Provider                   | Use For                   |
| :------------------------ | :------------------------- | :------------------------ |
| `PushNotificationService` | `pushNotificationProvider` | FCM token & notifications |

**Usage:**
\`\`\`dart
// Register for push notifications
await ref.read(pushNotificationProvider).requestPermission();

// Get FCM token
final token = await ref.read(pushNotificationProvider).getToken();
\`\`\`
```

### Validation Before Completion

Before finishing any task that introduces new reusable patterns:

- [ ] Did I create something that future tasks will need? → **Update this file**
- [ ] Did I add a new constant category? → **Document it**
- [ ] Did I discover a gotcha or edge case? → **Add to anti-patterns**
- [ ] Did I integrate a new package? → **Document the pattern**
- [ ] Did I make a significant change worth noting? → **Update CHANGELOG.md**

### Updating CHANGELOG.md

When making significant changes (new features, bug fixes, breaking changes), update `CHANGELOG.md`:

1. Add entry under `## [Unreleased]` section
2. Use appropriate category: `Added`, `Changed`, `Fixed`, `Removed`, `Security`
3. Keep entries concise but descriptive

```markdown
## [Unreleased]

### Added

- New `useNetworkStatus` hook for connectivity monitoring

### Fixed

- URL validator now correctly rejects URLs without host
```

---

## ⚠️ Critical: Architectural Constraints

### File Size & Organization

You must strictly adhere to the following file size limits to ensure maintainability. If a file exceeds these limits, you **MUST** refactor it immediately by extracting widgets, configuration, or logic into separate files.

| File Type            | Max Lines     | Action if Exceeded                              |
| -------------------- | ------------- | ----------------------------------------------- |
| **Services / Logic** | **200 lines** | Extract configs, enums, or sub-services.        |
| **UI Widgets**       | **250 lines** | Extract private widgets or separate components. |
| **Test Files**       | ~300 lines    | Split by test group if possible (flexible).     |

**Never** bypass these limits. If you write code that exceeds them, stop and refactor.

### One Class Per File

- **Rule**: One public class/widget per file (one responsibility per file)
- **Benefits**: Easier to navigate, maintain, test, and reason about code
- **Exception**: Private helper classes/widgets are acceptable if they only serve one specific parent class
- **When to extract**: If you have multiple independent classes/widgets, give each their own file

```dart
// ✅ Good - one widget per file
// button.dart
class MyButton extends StatelessWidget { ... }

// ❌ Avoid - multiple unrelated classes in one file
// button.dart
class MyButton extends StatelessWidget { ... }
class MyCard extends StatelessWidget { ... }
class MyDialog extends StatelessWidget { ... }
```

---

## 🏗️ Project Architecture

This project follows a **Feature-First Clean Architecture** with **Riverpod** for state management.

### Directory Structure

```
lib/
├── app/                    # App-level setup
│   ├── router/             # GoRouter configuration & routes
│   └── startup/            # App lifecycle & startup state machine
├── config/                 # Environment configuration
├── core/                   # Shared utilities & foundational code (27 modules)
│   ├── analytics/          # Firebase Analytics
│   ├── biometric/          # Biometric authentication
│   ├── cache/              # Offline-first caching (Drift)
│   ├── constants/          # App-wide constants
│   ├── crashlytics/        # Firebase Crashlytics
│   ├── deep_link/          # Deep links & universal links
│   ├── extensions/         # Dart/Flutter extensions
│   ├── feedback/           # Context-free snackbars/dialogs
│   ├── forms/              # Reactive Forms configurations
│   ├── hooks/              # Flutter Hooks utilities
│   ├── localization/       # Locale management & persistence
│   ├── network/            # Dio, interceptors, API client
│   ├── notifications/      # Local notifications
│   ├── performance/        # Firebase Performance
│   ├── permissions/        # Permission handling
│   ├── remote_config/      # Firebase Remote Config
│   ├── result/             # Result monad for error handling
│   ├── review/             # In-app review prompts
│   ├── session/            # Session state management
│   ├── storage/            # Secure storage utilities
│   ├── theme/              # App theming
│   ├── utils/              # Validators, logger, etc.
│   ├── version/            # App version & force update
│   └── widgets/            # Reusable UI components (25+)
├── features/               # Feature modules
│   ├── auth/               # Authentication feature
│   ├── home/               # Home feature
│   ├── onboarding/         # Onboarding feature
│   └── settings/           # Settings feature
└── l10n/                   # Localization files
```

### Feature Module Structure

Each feature **MUST** follow this structure:

```
features/<feature_name>/
├── data/               # Data layer
│   └── repositories/   # Repository implementations
├── domain/             # Domain layer
│   ├── entities/       # Business objects
│   └── repositories/   # Repository interfaces
└── presentation/       # Presentation layer
    ├── pages/          # Full screens
    ├── widgets/        # Feature-specific widgets
    └── providers/      # Riverpod Notifiers
```

---

## 🔄 State Management (Riverpod)

### Widget Class Selection

Choose the appropriate widget class based on your needs:

| Widget Type              | When to Use                                     |
| :----------------------- | :---------------------------------------------- |
| `HookConsumerWidget`     | **Default for pages** - Riverpod + Hooks access |
| `ConsumerWidget`         | Simple widgets needing only Riverpod            |
| `HookWidget`             | Widgets needing only hooks (no Riverpod)        |
| `ConsumerStatefulWidget` | When you need `initState`/`dispose` lifecycle   |
| `StatelessWidget`        | Pure UI with no state or providers              |

**Recommendation**: Use `HookConsumerWidget` for all pages to leverage `useOnMount` for analytics.

### Rules

- **Mandatory**: Use **Riverpod** for all state management.
- **Code Generation**: Use `@riverpod` / `@Riverpod(keepAlive: true)`.
- **Logic Location**: Business logic resides in **Notifiers** (Presentation) or **Services** (Domain/Data).
- **UI Role**: Widgets only `watch` state and `read` methods. No complex logic in `build()`.
- **Avoid**: `StatefulWidget` for logic (use only for animation/input controllers).

### keepAlive Guidelines

Use `@Riverpod(keepAlive: true)` **ONLY** for:

- Global app state (auth, theme, user preferences)
- Expensive services (network clients, database connections)
- State that must survive navigation (audio player, download manager)

**Default to autoDispose** for page-specific providers.

### Example Provider

```dart
@riverpod
class MyFeatureNotifier extends _$MyFeatureNotifier {
  @override
  Future<MyData> build() async {
    final repo = ref.watch(myRepositoryProvider);
    return repo.fetchData();
  }

  Future<void> doSomething() async {
    state = const AsyncLoading();
    final result = await ref.read(myRepositoryProvider).doAction();
    state = result.fold(
      onSuccess: AsyncData.new,
      onFailure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}
```

---

## 🛣️ Routing (GoRouter)

- Use **GoRouter** for all navigation.
- Define routes in `lib/app/router/`.
- Use `AppRoute` enum for type-safe route paths.

### Route Navigation

```dart
// Using extension methods (preferred)
context.goRoute(AppRoute.home);
context.pushRoute(AppRoute.settings);

// With parameters
context.goRouteWith(AppRoute.productDetail, {'id': '123'});

// Standard GoRouter (also works)
context.go('/home');
context.push('/settings');
```

### Adding New Routes

1. Add enum entry to `AppRoute` in `app_router.dart`
2. Create route definition in appropriate file (`auth_routes.dart`, `protected_routes.dart`)
3. Set `requiresAuth` appropriately

---

## 📋 Forms

- Use **`reactive_forms`** for all complex form handling.
- Use pre-built form groups from `lib/core/forms/` (e.g., `AuthForms.login()`).
- Validation logic should be reusable (e.g., `lib/core/utils/validators.dart`).

---

## 📦 Mandatory Reusable Components

**You MUST use these existing components. Do NOT create alternatives.**

### Widgets (`lib/core/widgets/`)

Widgets are organized into separate files. Use barrel exports (`animations.dart`, `dialogs.dart`, `inputs.dart`) for imports.

| Widget                               | Use For                                                     | File                        |
| :----------------------------------- | :---------------------------------------------------------- | :-------------------------- |
| `AsyncValueWidget<T>`                | Displaying Riverpod `AsyncValue` (loading/error/data)       | `async_value_widget.dart`   |
| `LoadingWidget`                      | Any loading state                                           | `async_value_widget.dart`   |
| `AppErrorWidget`                     | Any error state with retry action                           | `async_value_widget.dart`   |
| `EmptyWidget`                        | Empty lists / no data states                                | `async_value_widget.dart`   |
| `AppButton`                          | All buttons (use `AppButtonVariant.primary/secondary/text`) | `buttons.dart`              |
| `AppIconButton`                      | All icon buttons                                            | `buttons.dart`              |
| `VerticalSpace` / `HorizontalSpace`  | All spacing (`.xs()`, `.sm()`, `.md()`, `.lg()`, `.xl()`)   | `spacing.dart`              |
| `AppTextField`                       | Text input fields                                           | `text_fields.dart`          |
| `AppSearchField`                     | Search input with clear button                              | `text_fields.dart`          |
| `AppChip`                            | Filter/input chips                                          | `chips.dart`                |
| `AppBadge`                           | Count/status badges                                         | `badges.dart`               |
| `StatusDot`                          | Status indicators (online/offline/busy)                     | `status_indicators.dart`    |
| `AppDivider`                         | Dividers with optional labels                               | `dividers.dart`             |
| `CachedImage`                        | All network images                                          | `cached_image.dart`         |
| `ResponsiveBuilder`                  | Adaptive layouts                                            | `responsive_builder.dart`   |
| `AppDialogs.confirm()`               | Confirmation dialogs                                        | `app_dialogs.dart`          |
| `AppBottomSheets.confirm()`          | Bottom sheet confirmations                                  | `bottom_sheets.dart`        |
| `FadeIn` / `SlideIn` / `ScaleIn`     | Entry animations (use `.staggered()` for lists)             | `entry_animations.dart`     |
| `StaggeredList`                      | Staggered list animations                                   | `staggered_list.dart`       |
| `Bounce` / `Pulse` / `ShakeWidget`   | Attention/feedback animations                               | `attention_animations.dart` |
| `FlipCard`                           | 3D flip transitions                                         | `flip_card.dart`            |
| `ExpandableWidget`                   | Expand/collapse sections                                    | `expandable_widget.dart`    |
| `AnimatedCounter`                    | Animated number changes                                     | `animated_counter.dart`     |
| `AnimatedProgress`                   | Animated progress bars                                      | `animated_progress.dart`    |
| `TypewriterText`                     | Typewriter text effect                                      | `typewriter_text.dart`      |
| `ShimmerLoading` / `ShimmerListTile` | Skeleton loading states                                     | `shimmer_loading.dart`      |

### Constants (`lib/core/constants/`)

| File                 | Contains                          |
| :------------------- | :-------------------------------- |
| `app_constants.dart` | Durations, dimensions, validation |
| `api_endpoints.dart` | API endpoint paths                |
| `assets.dart`        | Image, icon, animation paths      |
| `storage_keys.dart`  | Secure storage and prefs keys     |

| Constant Class                   | Use For               |
| :------------------------------- | :-------------------- |
| `AppConstants.animationFast`     | Fast transitions      |
| `AppConstants.animationNormal`   | Standard animations   |
| `AppConstants.animationSlow`     | Emphasized animations |
| `AppConstants.staggerDelay`      | List item stagger     |
| `AppConstants.counterAnimation`  | Counter animations    |
| `AppConstants.flipAnimation`     | Flip card duration    |
| `AppConstants.bounceAnimation`   | Bounce effects        |
| `AppConstants.expandAnimation`   | Expand/collapse       |
| `AppConstants.shakeAnimation`    | Shake effects         |
| `AppConstants.pulseAnimation`    | Pulse effects         |
| `AppConstants.borderRadiusSM`    | Small border radii    |
| `AppConstants.borderRadiusMD`    | Medium border radii   |
| `AppConstants.borderRadiusLG`    | Large border radii    |
| `AppConstants.iconSizeSM`        | Small icons (16px)    |
| `AppConstants.iconSizeMD`        | Medium icons (24px)   |
| `AppConstants.iconSizeXL`        | Large icons (48px)    |
| `AppConstants.iconSizeXXL`       | XL icons (80px)       |
| `AppConstants.dialogIconSize`    | Dialog icons (48px)   |
| `AppConstants.chipIconSize`      | Chip icons (18px)     |
| `AppConstants.debounceDelay`     | Debounce delays       |
| `AppConstants.defaultPageSize`   | Pagination            |
| `ApiEndpoints.login`             | API endpoint paths    |
| `StorageKeys.accessToken`        | Secure storage keys   |
| `Assets.logo`                    | Asset paths           |
| `AppIcons.home`                  | Icon paths            |
| `AnalyticsEvents.login`          | Analytics event keys  |
| `RemoteConfigKeys.minAppVersion` | Remote config keys    |

### Extensions (`lib/core/extensions/`)

```dart
// ✅ Use extensions (preferred)
context.colorScheme         // instead of Theme.of(context).colorScheme
context.textTheme           // instead of Theme.of(context).textTheme
context.theme               // instead of Theme.of(context)
context.screenWidth         // instead of MediaQuery.of(context).size.width
context.isMobile            // responsive checks
context.unfocus()           // dismiss keyboard
context.showSnackBar(msg)   // show snackbar
context.showErrorSnackBar() // error snackbar
'hello'.capitalized         // string utilities
DateTime.now().timeAgo      // date formatting
```

### Hooks (`lib/core/hooks/`)

For `HookWidget` and `HookConsumerWidget` classes. **Prefer `HookConsumerWidget` for pages** as it combines Riverpod access with hooks.

| Hook                        | Use For                                        |
| :-------------------------- | :--------------------------------------------- |
| `useOnMount(callback)`      | **One-time effect on mount** (analytics, init) |
| `useDebounce(value, delay)` | Debounced values (search fields)               |
| `useToggle(initial)`        | Boolean toggle state                           |
| `usePrevious(value)`        | Previous render's value                        |
| `useTextController()`       | TextEditingController with auto-dispose        |
| `useFocusNode()`            | FocusNode with auto-dispose                    |
| `useScrollController()`     | ScrollController with auto-dispose             |
| `usePageController()`       | PageController with auto-dispose               |

**Critical**: Always use `useOnMount` for analytics tracking, never track in `build()`:

```dart
// ✅ Correct - tracks once on mount
class MyPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'my_page');
    });
    return Scaffold(...);
  }
}

// ❌ Wrong - tracks on every rebuild!
class BadPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(analyticsServiceProvider).logScreenView(screenName: 'bad'); // BAD!
    return Scaffold(...);
  }
}
```

### Firebase Services (`lib/core/`)

| Service                       | Path             | Use For                         |
| :---------------------------- | :--------------- | :------------------------------ |
| `CrashlyticsService`          | `crashlytics/`   | Crash reporting & error logging |
| `AnalyticsService`            | `analytics/`     | User analytics & event tracking |
| `PerformanceService`          | `performance/`   | Performance monitoring & traces |
| `FirebaseRemoteConfigService` | `remote_config/` | Feature flags & A/B testing     |

### Other Core Services (`lib/core/`)

| Service                    | Path             | Use For                          |
| :------------------------- | :--------------- | :------------------------------- |
| `DeepLinkService`          | `deep_link/`     | Universal links & app links      |
| `FeedbackService`          | `feedback/`      | Context-free snackbars & dialogs |
| `InAppReviewService`       | `review/`        | Smart in-app review prompting    |
| `AppVersionService`        | `version/`       | Version check & force update     |
| `LocaleNotifier`           | `localization/`  | Locale management & persistence  |
| `BiometricService`         | `biometric/`     | Face ID / Touch ID auth          |
| `LocalNotificationService` | `notifications/` | Local push notifications         |
| `PermissionService`        | `permissions/`   | Runtime permission handling      |

```dart
// Analytics
ref.read(analyticsServiceProvider).logLogin(method: 'email');
ref.read(analyticsServiceProvider).logEvent(AnalyticsEvents.featureUsed);

// Performance (custom traces)
await ref.read(performanceServiceProvider).traceAsync('checkout', () => process());

// Remote Config (feature flags)
ref.read(firebaseRemoteConfigServiceProvider).getBool(RemoteConfigKeys.newFeatureEnabled);
ref.read(firebaseRemoteConfigServiceProvider).isMaintenanceMode;
```

---

## 📝 Coding Standards & Style

### Hard Constraints

- **No Magic Numbers**: CRITICAL - Every numeric value must use a pre-defined constant (see detailed rules below)
- **No Direct Colors**: Use `context.colorScheme.primary` (via extension).
- **No Raw SizedBox for Spacing**: Use `VerticalSpace.md()` or `HorizontalSpace.sm()`.
- **No Custom Loading Widgets**: Use `LoadingWidget`.
- **No Custom Error Widgets**: Use `AppErrorWidget`.
- **No Hardcoded Strings**: ALL user-facing text must be localized (see section below).
- **Enum Shorthand**: Use Dart 3 enum shorthand syntax (e.g., `variant: .primary` instead of `variant: AppButtonVariant.primary`).

### No Magic Numbers - Detailed Rules

**NEVER use raw numeric values in your code.** Every number must come from a pre-defined constant.

#### Where to find constants:

| Category               | Constants Class | Location               | Examples                                                                |
| :--------------------- | :-------------- | :--------------------- | :---------------------------------------------------------------------- |
| **Animations**         | `AppConstants`  | `lib/core/constants/`  | `animationNormal` (300ms), `pageIndicatorAnimation` (200ms)             |
| **Spacing**            | `AppSpacing`    | `lib/core/extensions/` | `.xs()`, `.sm()`, `.md()`, `.lg()`, `.xl()`                             |
| **Border Radius**      | `AppConstants`  | `lib/core/constants/`  | `borderRadiusSM` (4px), `borderRadiusMD` (8px), `borderRadiusXL` (16px) |
| **Icon Sizes**         | `AppConstants`  | `lib/core/constants/`  | `iconSizeSM` (16px), `iconSizeMD` (24px), `iconSizeLG` (32px)           |
| **Component Heights**  | `AppConstants`  | `lib/core/constants/`  | `buttonHeight` (48px), `inputHeight` (56px)                             |
| **Component Widths**   | `AppConstants`  | `lib/core/constants/`  | `pageIndicatorActiveWidth` (24px), `pageIndicatorInactiveWidth` (8px)   |
| **Opacity/Alpha**      | `AppConstants`  | `lib/core/constants/`  | `pageIndicatorInactiveOpacity` (0.3)                                    |
| **Timeouts**           | `AppConstants`  | `lib/core/constants/`  | `connectTimeout`, `receiveTimeout`                                      |
| **Validation Lengths** | `AppConstants`  | `lib/core/constants/`  | `minPasswordLength` (8), `minUsernameLength` (3)                        |
| **API Config**         | `ApiEndpoints`  | `lib/core/constants/`  | API paths and endpoints                                                 |
| **Storage Keys**       | `StorageKeys`   | `lib/core/constants/`  | Secure storage and shared prefs keys                                    |
| **Asset Paths**        | `Assets`        | `lib/core/constants/`  | Image, icon, animation file paths                                       |

#### Examples of violations (❌ WRONG):

```dart
// ❌ Raw duration
AnimatedContainer(duration: const Duration(milliseconds: 200))

// ❌ Raw numbers for dimensions
width: 24,
height: 8,

// ❌ Raw opacity
color.withValues(alpha: 0.3)

// ❌ Raw border radius
borderRadius: BorderRadius.circular(4)

// ❌ Raw spacing
padding: const EdgeInsets.all(16)
```

#### Examples of correct usage (✅ CORRECT):

```dart
// ✅ Use AppConstants for animations
AnimatedContainer(duration: AppConstants.pageIndicatorAnimation)

// ✅ Use AppConstants for dimensions
width: AppConstants.pageIndicatorActiveWidth,
height: AppConstants.pageIndicatorHeight,

// ✅ Use AppConstants for opacity
color.withValues(alpha: AppConstants.pageIndicatorInactiveOpacity)

// ✅ Use AppConstants for border radius
borderRadius: BorderRadius.circular(AppConstants.borderRadiusSM)

// ✅ Use AppSpacing for spacing
padding: const EdgeInsets.all(AppSpacing.md)
```

#### Before submitting code:

1. **Search for any numeric literals** in your code (regex: `\d+` for numbers in contexts like dimensions, opacity, duration)
2. **Check if a constant exists** - look in `AppConstants`, `AppSpacing`, `ApiEndpoints`, `StorageKeys`, or `Assets`
3. **If no constant exists, CREATE IT** - add it to the appropriate constants file with proper documentation
4. **Replace all raw numbers** with the corresponding constant
5. **Never add a magic number thinking "it's just this once"** - the boilerplate is a template that will be reused across projects

### Naming Conventions

| Type            | Convention  | Example                |
| :-------------- | :---------- | :--------------------- |
| Files           | snake_case  | `user_repository.dart` |
| Classes         | PascalCase  | `UserRepository`       |
| Variables       | camelCase   | `userData`             |
| Private Members | \_camelCase | `_privateField`        |
| Constants       | camelCase   | `maxRetryAttempts`     |
| JSON Fields     | snake_case  | `user_name`            |

### Error Handling

Always use the `Result<T>` monad for operations that can fail:

```dart
// Repository
Future<Result<User>> fetchUser(String id) async {
  try {
    final response = await apiClient.get<Map<String, dynamic>>('/users/$id');
    return response.map((data) => User.fromJson(data));
  } catch (e) {
    return Failure(UnexpectedException(message: e.toString()));
  }
}

// Usage
final result = await repo.fetchUser('123');
result.fold(
  onSuccess: (user) => handleUser(user),
  onFailure: (error) => showError(error.message),
);
```

### Validation

Use `Validators.compose()` for form validation:

```dart
TextFormField(
  validator: Validators.compose([
    Validators.required('Email is required'),
    Validators.email('Invalid email format'),
  ]),
)
```

**Note**: `Validators.strongPassword()` requires 8+ characters with uppercase, lowercase, number, and special character. Don't add redundant `minLength` validators.

---

## 🌍 Localization & i18n

- **All user-facing text MUST be localized** in `lib/l10n/` files (`.arb` format)
- Use `AppLocalizations.of(context)` to access localized strings
- Never hardcode UI text like button labels, titles, or messages
- Support at least English and one additional language (Bengali in this boilerplate)

```dart
// ✅ Correct
Text(AppLocalizations.of(context).loginButtonLabel)

// ❌ Wrong - hardcoded string
Text('Login')
```

---

## 📊 Analytics & Screen Tracking

- **Track screen views** for all new pages using `useOnMount` hook (HookConsumerWidget):

```dart
class MyPage extends HookConsumerWidget {
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // Track screen view once on mount (not on every rebuild!)
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'my_feature');
    });

    return Scaffold(...);
  }
}
```

For `ConsumerStatefulWidget`, use `initState`:

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(analyticsServiceProvider).logScreenView(screenName: 'my_feature');
  });
}
```

- **Track user actions** like button clicks and form submissions:

```dart
ref.read(analyticsServiceProvider).logEvent(
  AnalyticsEvents.featureUsed,
  parameters: {'feature_name': 'checkout'},
);
```

---

## 🛠️ Development Workflow

### Adding a New Feature

**Always use the generator script:**

```bash
make feature NAME=my_feature
```

Then implement:

1. Define `Entity` in `domain/entities/`.
2. Define `Repository Interface` in `domain/repositories/`.
3. Implement `Repository` in `data/repositories/`.
4. Create `Provider` in `presentation/providers/`.
5. Build `Page` in `presentation/pages/`.
6. Add entry to `AppRoute` enum.

### Build Commands

```bash
make gen       # Run code generation (build_runner + l10n)
make format    # Format code & apply fixes
make lint      # Run static analysis
make test      # Run all tests
make prepare   # Full setup (clean + l10n + gen)
```

### Testing Guidelines

- **Unit Tests**: For Logic/Repositories
- **Widget Tests**: For UI Components
- **Pattern**: Arrange-Act-Assert
- **Shared Mocks**: Place in `test/helpers/mocks.dart`
- **Library**: Use `mocktail` for all mocking
- **Result<void>**: Return `const Success(null)` when mocking

---

## 🎨 Visual Design & Theming

### Material 3

- **ThemeData**: Centralized in `lib/core/theme/`.
- **ColorScheme**: Uses `ColorScheme.light()` and `ColorScheme.dark()`.
- **Dark Mode**: Support `ThemeMode.system`, `light`, and `dark`.

### Layout Best Practices

- **Responsiveness**: Use `ResponsiveBuilder` or `context.responsive()`.
- **Spacing**: Use `VerticalSpace` / `HorizontalSpace` widgets.
- **Lists**: Use `ListView.builder` for performance.
- **Safe Areas**: Respect `SafeArea`.

### Accessibility

- **Contrast**: Ensure 4.5:1 ratio.
- **Semantics**: Use `Semantics` widgets where necessary.
- **Scaling**: Test with dynamic text scaling.

---

## 🔐 Security Best Practices

### Secure Storage

- Use `FlutterSecureStorage` for sensitive data (tokens, credentials).
- Never log sensitive information.
- iOS Keychain data persists across reinstalls — use `FreshInstallHandler`.

### Network Security

- Auth tokens are automatically injected via `AuthInterceptor`.
- 401 responses trigger automatic token refresh with `Completer` coordination.
- Failed requests retry with exponential backoff.

---

## 📱 Platform Considerations

### iOS

- Keychain accessibility: `first_unlock_this_device`.
- Handle fresh install scenarios (clear stale keychain data).

### Android

- Encrypted SharedPreferences for secure storage.
- Native Cronet adapter for HTTP/3 support (release mode).

---

## ❌ Anti-Patterns to Avoid

1. **Don't** use `StatefulWidget` for business logic
2. **Don't** call `ref.read` in `build()` — use `ref.watch`
3. **Don't** create custom loading/error widgets
4. **🔴 CRITICAL: Don't** use magic numbers for spacing/dimensions/durations/opacity. **ALWAYS** use constants from `AppConstants`, `AppSpacing`, `ApiEndpoints`, `StorageKeys`, or `Assets`. This includes:
   - Durations: Use `AppConstants.animationNormal` instead of `Duration(milliseconds: 300)`
   - Stagger delays: Use `AppConstants.staggerDelay * N` instead of `Duration(milliseconds: N * 50)`
   - Icon sizes: Use `AppConstants.iconSizeMD` (24px), `iconSizeXL` (48px), `iconSizeXXL` (80px)
   - Dimensions: Use `AppConstants.pageIndicatorActiveWidth` instead of `24`
   - Opacity: Use `AppConstants.pageIndicatorInactiveOpacity` instead of `0.3`
   - Border radius: Use `AppConstants.borderRadiusSM` instead of `4`
   - Spacing: Use `AppSpacing.md` instead of `16`
   - **Rule**: Before submitting, search your code for numeric literals and replace with constants
5. **Don't** store tokens in plain SharedPreferences
6. **Don't** ignore `Result` failures
7. **Don't** use `!` bang operator without checking null first
8. **🔴 CRITICAL: Don't** hardcode ANY user-facing strings in code. **ALL** text must use localization keys from `app_en.arb` and `app_bn.arb`. This includes:
   - Button labels, titles, descriptions
   - Dialog/snackbar messages
   - Placeholder texts, error messages
   - ANY text displayed to users
   - **Rule**: Before submitting code, search for quoted strings and ensure they use `l10n.<key>` instead
9. **🔴 CRITICAL: Don't** track analytics in `build()` methods - use `useOnMount()` hook for `HookConsumerWidget` or `initState()` with `addPostFrameCallback` for `ConsumerStatefulWidget`. Analytics in build() will fire on every rebuild!
10. **Don't** bypass file size limits — refactor immediately if exceeded
11. **Don't** forget try-catch blocks for operations that can fail (especially async operations)
12. **Do** use `.staggered()` factories for list animations instead of manually calculating delays
