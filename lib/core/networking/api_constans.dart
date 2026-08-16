/// Centralized API endpoint catalogue for the Team Workspace backend.
///
/// Base URL ends with a trailing slash and every path is relative (no leading
/// slash) so Dio resolves them under the `/api/` segment. Never hard-code paths
/// in feature code — reference [ApiConstants] instead.
class ApiConstants {
  ApiConstants._();

  static const String apiBaseUrl = "https://mytasks.codetechsyria.com/api/";

  // ── Auth & current user ────────────────────────────────────────────────
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String me = "users/me";
  static const String users = "users";

  // Future device-token registration (backend endpoint does not exist yet).
  static const String myDevices = "users/me/devices";

  // ── Workspaces ─────────────────────────────────────────────────────────
  static const String workspaces = "workspaces";
  static String workspace(String id) => "workspaces/$id";
  static String workspaceMembers(String id) => "workspaces/$id/members";
  static String workspaceMember(String id, String userId) =>
      "workspaces/$id/members/$userId";

  // ── Projects ───────────────────────────────────────────────────────────
  static const String projects = "projects";
  static String project(String id) => "projects/$id";
  static String projectStatus(String id) => "projects/$id/status";

  // ── Tasks ──────────────────────────────────────────────────────────────
  static const String tasks = "tasks";
  static String task(String id) => "tasks/$id";
  static String taskStatus(String id) => "tasks/$id/status";
  static String taskAssignees(String id) => "tasks/$id/assignees";
  static String taskAssignee(String id, String userId) =>
      "tasks/$id/assignees/$userId";
  static String taskComments(String id) => "tasks/$id/comments";
  static String taskComment(String id, String commentId) =>
      "tasks/$id/comments/$commentId";

  // ── Notes ──────────────────────────────────────────────────────────────
  static const String notes = "notes";
  static String note(String id) => "notes/$id";
  static String notePin(String id) => "notes/$id/pin";

  // ── Requests ───────────────────────────────────────────────────────────
  static const String requests = "requests";
  static String request(String id) => "requests/$id";
  static String requestStatus(String id) => "requests/$id/status";
  static String requestAssign(String id) => "requests/$id/assign";

  // ── Notifications ──────────────────────────────────────────────────────
  static const String notifications = "notifications";
  static const String notificationsUnreadCount = "notifications/unread-count";
  static String notificationRead(String id) => "notifications/$id/read";
  static const String notificationsReadAll = "notifications/read-all";

  // ── Activity logs (read-only) ──────────────────────────────────────────
  static const String activityLogs = "activity-logs";
}

/// Localization keys for common API error messages (values live in the GetX
/// translation maps).
class ApiErrors {
  static const String badRequestError = "error_bad_request";
  static const String unauthorizedError = "error_unauthorized";
  static const String forbiddenError = "error_forbidden";
  static const String notFoundError = "error_not_found";
  static const String conflictError = "error_conflict";
  static const String validationError = "error_validation";
  static const String tooManyRequests = "error_too_many_requests";
  static const String internalServerError = "error_server";
  static const String serviceUnavailable = "error_service_unavailable";
  static const String timeoutError = "error_timeout";
  static const String noInternetError = "error_no_internet";
  static const String unknownError = "error_unknown";
}
