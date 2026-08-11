/// Category of an API failure, derived from the HTTP status / transport error.
enum ApiErrorType {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  validation,
  tooManyRequests,
  server,
  serviceUnavailable,
  timeout,
  noInternet,
  cancelled,
  unknown,
}

/// Uniform error passed through `ApiResult.failure`.
///
/// [message] is a user-safe, localized message. [errors] holds field-level
/// validation messages parsed from RFC 7807 ProblemDetails. [statusCode] and
/// [type] are transport metadata (not part of the JSON body).
///
/// Manual JSON (no build_runner) — this environment's Dart SDK cannot run
/// build_runner; see CLAUDE.md → Build & Code Generation.
class ErrorModel {
  final String? message;
  final Map<String, List<String>>? errors;
  final int? statusCode;
  final ApiErrorType type;

  ErrorModel({
    required this.message,
    this.errors,
    this.statusCode,
    this.type = ApiErrorType.unknown,
  });

  bool get isUnauthorized => type == ApiErrorType.unauthorized;

  bool get hasFieldErrors => errors != null && errors!.isNotEmpty;

  String? get firstFieldError {
    if (!hasFieldErrors) return null;
    for (final list in errors!.values) {
      if (list.isNotEmpty) return list.first;
    }
    return null;
  }

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        message: (json['message'] ?? json['detail'] ?? json['title'])?.toString(),
        errors: parseErrors(json['errors']),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        if (errors != null) 'errors': errors,
      };

  static Map<String, List<String>>? parseErrors(dynamic raw) {
    if (raw is Map) {
      final out = <String, List<String>>{};
      raw.forEach((key, value) {
        out[key.toString()] = value is List
            ? value.map((e) => e.toString()).toList()
            : <String>[value.toString()];
      });
      return out.isEmpty ? null : out;
    }
    return null;
  }
}
