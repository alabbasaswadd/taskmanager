# CLAUDE.md

Guidance for Claude Code (claude.ai/code) when working in this repository.

> The Dart package name is **`wallet`** (a legacy artifact of the original
> template). All internal imports use `package:wallet/...`. The **product** is a
> Team Workspace / task-management app.

---

## Project Overview

Flutter frontend for the **Team Workspace** platform (projects, tasks, notes,
requests, notifications, workspaces). It talks to the ASP.NET Core Team Workspace
API. Primary UI language is **Arabic (RTL)**; Cairo font.

## Product Purpose

Help a small startup team manage projects, organize tasks and internal requests,
and stay updated through notifications — reachable within ~three interactions
(three-click principle).

## Commands

```bash
flutter pub get
flutter run
flutter analyze
flutter test
# Code generation (see "Build & Code Generation" — currently NOT runnable here)
dart run build_runner build --delete-conflicting-outputs
```

## Architecture

Feature-first under `lib/pages/<feature>/`:
```
<feature>/
  api/     ← repository (extends BaseApi, uses the shared Dio) → ApiResult<T>
  cubit/   ← Cubit state management (Tasks may also use BLoC)
  model/   ← plain models with manual fromJson/toJson
  screen/  ← UI (thin; no API calls / business logic)
```
Layering: `Screen → Cubit → Repository → BaseApi → Dio`. Widgets never touch Dio.

## Folder Structure (key paths)

- `lib/core/networking/` — `DioFactory`, `ApiResult`, `ErrorHandler`,
  `ApiConstants`, `pagination.dart`.
- `lib/core/constants/` — `BaseApi`, `BaseCubit`, `BaseState`, `colors`, `theme`,
  `functions.dart` (UserSession), `model/error_model.dart`.
- `lib/core/enums/domain_enums.dart` — backend-aligned enums + parse helpers.
- `lib/core/state/paged_list_state.dart` — reusable list state.
- `lib/core/components/` — shared widgets (`AppButton`, `AppText`,
  `AppTextFormField`, `AppSnackbar`, `state_views.dart`, shimmers…).
- `lib/pages/<feature>/` — auth, home (dashboard), main (shell), projects, taskes,
  notifications, workspaces.

## API Base URL

`https://mytasks.codetechsyria.com/api/` — set once in
`lib/core/networking/api_constans.dart` (`ApiConstants.apiBaseUrl`). **Never**
hard-code endpoint paths; use `ApiConstants` (all endpoints centralized there).

## Networking

- **`DioFactory`** — single shared Dio; `setTokenIntoHeaderAfterLogin(token)`
  attaches `Authorization: Bearer …`; `onUnauthorized` hook fires once on 401.
- **`BaseApi.execute<T>()`** — wraps a request, funnels every error through
  `ErrorHandler`, returns `ApiResult<T>`.
- **`ApiResult<T>`** — freezed union; use `.when(success:, failure:)` (import
  `api_result.dart` to get the generated `when`).
- Repositories `extend BaseApi` and use `DioFactory.getDio()`. **Do not** create
  another Dio/HTTP layer.

## Authentication

- Login: `POST /auth/login` via `AuthRepository` → `AuthCubit` → `SignInScreen`.
- On success: set Dio token → persist session (`UserSession.updateSession`) →
  `Get.offAllNamed(MainShell.id)` (login is removed from the stack).
- ⚠️ **The backend has no `/auth/login` yet** (auth was out of scope server-side;
  it currently authenticates via an `X-User-Id` header). The login flow is wired
  against an **assumed** `{ token, user }` contract and will work once the backend
  adds JWT. See **Known Issues**.

## Session Management

`UserSession` (`lib/core/constants/functions.dart`) — static session backed by
`SharedPreferences` (`UserPreferencesService`). `UserSession.init()` runs at
startup. Members: `token`, `user`, `isLoggedIn`, `displayName`, `updateSession`,
`clear`.

## Error Handling

Single flow: `Dio → BaseApi → ErrorHandler → ErrorModel → ApiResult.failure →
Cubit → UI`. `ErrorHandler` maps every case to a **localized** `ErrorModel`
(`message`, `errors: Map<String,List<String>>`, `statusCode`, `type`):
400/401/403/404/409/422/429/500/502-504, timeouts, no-internet, unknown. RFC 7807
ProblemDetails `detail`/`title`/`errors` are parsed. UI shows `error.message`
only — never raw Dio/Socket exceptions. 401 → central logout via
`DioFactory.onUnauthorized` (wired in `main.dart`).

## State Management

- **Cubit** for most features (`ProjectsCubit`, `TasksCubit`, `NotificationsCubit`,
  `DashboardCubit`, `AuthCubit`) over `PagedListState<T>` where paginated.
- **BLoC/Cubit not mixed within one feature.** `BaseCubit.executeApi()` remains
  available for loading/success/error flows.

## Dependency Injection

Lightweight: cubits construct their repository (default) or accept one for tests.
Repositories are thin and share the single Dio. (No `get_it`; expand only if a
real need arises.)

## API Features (implemented ↔ endpoint)

| Feature | Endpoints | Status |
|---|---|---|
| Auth / me | `POST /auth/login`, `GET/PUT /users/me`, `GET /users` | login wired (pending backend); repo ready |
| Projects | `GET/POST/GET{id}/PUT/DELETE /projects`, `PATCH /projects/{id}/status` | **Done** (list, details, create/edit, status, delete) |
| Tasks | `GET/POST/GET{id}/PUT/DELETE /tasks`, `PATCH .../status`, assignees, comments | list + details + status **done**; create/assignee/comment UI pending (repo ready) |
| Notifications | `GET /notifications`, `unread-count`, `PATCH {id}/read`, `read-all` | **Done** (center, badge, mark read, navigate by reference) |
| Workspaces | `GET /workspaces` (+ members endpoints) | list repo (used by project picker); full UI pending |
| Requests / Notes / Activity | `/requests`, `/notes`, `/activity-logs` | **Pending** (endpoints in `ApiConstants`) |

## Models

Plain Dart classes with **manual** `fromJson`/`toJson` (see Build & Code
Generation). Backend enums are strings; parsed via helpers in `domain_enums.dart`
(`projectStatusFromApi`, `taskStatusFromApi`, …). `PagedResult<T>` mirrors the
backend `{ items, page, pageSize, totalCount, totalPages }`.

## Navigation

GetX. Named routes in `lib/routes.dart`: `SignInScreen.id` (`/login`),
`MainShell.id` (`/home`), `ProjectDetailsScreen.id` (`/project-details`).
Typed-argument screens are pushed with `Get.to(() => Screen(...))`.
`MainShell` = bottom navigation (Dashboard / Projects / Tasks / Notifications).

## Onboarding

Pending (routing goes straight to login/home). Persist completion in prefs when
added.

## Notifications

In-app center only (list, all/unread, mark read/all, unread badge, navigate by
`referenceType`/`referenceId`). Badge refreshes on app resume, on entering the
tab, and after actions — never on every rebuild.

## Authentication persistence (no JWT refresh)

The session is **persistent**: the access token is saved via `UserSession` and
restored on every launch (`main.dart`), then attached to Dio. There is **no
refresh-token mechanism** and none should be added. The session is cleared only
when (a) the user explicitly logs out, or (b) the backend returns **401** (central
`DioFactory.onUnauthorized` → clear session → login). FCM token handling is
entirely separate from this and never triggers a logout.

## Firebase / FCM & Device Token Registration

Implemented via `firebase_core` + `firebase_messaging` (no extra plugins).

- **`PushNotificationService`** (`lib/core/push/push_notification_service.dart`) —
  the single push entry point: `initialize()` (called in `main`, sets up
  background/foreground/tap listeners + token-refresh; **no-ops gracefully if
  Firebase isn't configured**), and `requestPermissionAndRegister()` (called after
  login and for a returning authenticated user).
- **Permission** is requested only after login; denied/permanently-denied is
  respected (never re-prompted, no registration).
- **Device token** → `DevicesRepository.registerDevice(token, platform)` →
  `POST /api/users/me/devices`. `onTokenRefresh` re-registers (backend upserts by
  token, so no duplicates). This is FCM token management, **not** JWT refresh.
- **Foreground** → in-app banner (`Get.snackbar`); **background/terminated** →
  OS tray (top-level `firebaseBackgroundHandler`); **tap** (foreground or cold
  start) → `NotificationNavigator.open(referenceType, referenceId)` deep-links to
  the Task/Project (Request/Note pending their screens). Data keys from the
  backend: `notificationId`, `type`, `referenceType`, `referenceId`.
- **Unread count** — via the existing `/notifications/unread-count` (badge in the
  shell), unchanged.

⚠️ **Required setup (blocker until done):** the app needs Firebase **client**
config — run `flutterfire configure` (project `gallery-440f9`) to add
`google-services.json` (Android) / `GoogleService-Info.plist` (iOS) and the Gradle
wiring. Until then the Android/iOS build won't include Firebase and push stays
disabled (the app still runs; in-app notifications work over REST). The server
**admin** key is NOT the client config and must never ship in the app.

## Theme / Design System

- Calm indigo/teal palette (`lib/core/constants/colors.dart`, `AppColors`).
- `lib/core/constants/theme.dart` → `lightTheme`/`darkTheme` (AdaptiveTheme).
- Colors live in `AppColors`/theme — do not hard-code in screens.
- Status/priority colors via `domain_enums` extensions.

## Animation Guidelines

Use sparingly (page fades, snackbar slide, shimmer for list loading). Skeleton
shimmers (`shimmer_widgets.dart`) instead of full-screen spinners.

## Responsive Design

`flutter_screenutil` (design size `392×825`) — `.w/.h/.sp/.r`. No hard-coded
screen dimensions.

## Localization

GetX `.tr` on all user strings; maps in `lib/core/localization/app_translations.dart`
(`_ar`/`_en` + `_arWorkspace`/`_enWorkspace`). Locale `ar` (RTL), fallback `en`.
Do not scatter raw Arabic in widgets — add keys to the maps.

## Three-Click Navigation Principle

Home → Projects → Project (→ Tasks); Home → Tasks → Task; Home → Notifications →
target. Quick actions on the dashboard shortcut common tasks.

## Testing

`test/widget_test.dart` covers pagination parsing, page-size clamping, and enum
parsing. Broader widget/integration tests are pending.

## Build & Code Generation

⚠️ **`build_runner` does not run in this environment** (Dart 3.10 + build_runner
raises `'dart compile' does not support build hooks`). Because of this, **models
use manual `fromJson`/`toJson`** instead of `@JsonSerializable`, and there are no
`*.g.dart` for models. Only `api_result.freezed.dart` (committed) remains.
If build_runner is fixed later, models may be migrated back to `@JsonSerializable`.
Never hand-edit generated files.

## Known Issues

- **No backend `/auth/login`** — login is wired against an assumed `{token,user}`
  contract; works once the backend adds JWT. Until then the API also expects an
  `X-User-Id` header for authenticated calls.
- **Live API returns 404** at `…/api/*` at time of writing (API not yet routed at
  that host); code targets the known contract.
- `build_runner` unusable here (see above).
- Legacy `signalr_service.dart` stub remains; SignalR not wired.

## Future Improvements

- Task create/edit + assignee + comments UI; Requests, Notes, Workspaces (full),
  Activity screens; onboarding + notification-permission + FCM; profile edit
  (`PUT /users/me`); offline banner via `connectivity_plus`; migrate models back
  to `@JsonSerializable` once build_runner works; broaden tests.

## Change Log

### 2026-08-11 — FCM integration
- Added `firebase_core` + `firebase_messaging`; `PushNotificationService`
  (permission, token register/refresh, foreground banner, background handler,
  tap → deep-link) with graceful no-op when Firebase client config is absent.
- Device registration `DevicesRepository` → `POST/DELETE /api/users/me/devices`;
  registered after login and for returning authenticated users.
- Shared `NotificationNavigator` for reference-based navigation (reused by the
  notification center and FCM taps).
- Confirmed persistent session with **no JWT refresh** (logout / 401 only).
- Requires `flutterfire configure` (google-services.json) to activate push.

### 2026-08-11
- Connected the app to the Team Workspace API; centralized all endpoints in
  `ApiConstants` and fixed the base URL.
- Centralized RFC 7807 error handling (`ErrorHandler` → localized `ErrorModel`
  with status/type + field errors); UI never sees raw exceptions.
- Added Bearer-token injection + **central 401 handling** (`DioFactory.onUnauthorized`).
- Implemented auth/session integration (`AuthRepository`/`AuthCubit`, login screen,
  `UserSession`), pending backend `/auth/login`.
- Added reusable pagination (`PagedResult<T>`, `PageParams`, `PagedListState<T>`).
- Backend-aligned enums + models (Projects, Tasks, Notifications, Workspaces, User).
- Implemented main shell (bottom nav), Dashboard (overview + quick actions),
  Projects (list/details/create/edit/status/delete), Tasks (list/filter/details/
  status), Notifications (center + unread badge + reference navigation).
- Updated theme/design system to a calm indigo/teal palette; extended Arabic/English
  localization.
- Removed unused template plugins (scanner/mlkit/local_auth/etc.) and legacy
  placeholder screens.
- Switched models to manual JSON due to a build_runner/SDK incompatibility.
- `flutter analyze`: 0 errors / 0 warnings. `flutter test`: passing.
