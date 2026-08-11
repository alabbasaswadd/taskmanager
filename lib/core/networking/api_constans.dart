class ApiConstants {
  static const String apiBaseUrl =
      "https://shamcash.runasp.net/currency-exchange-api/api/";

  // Auth
  static const String signin = "v1/Auth/login";

  // Exchange Rates
  static const String exchangeRates = "v1/ExchangeRate";
  static const String exchangeRateUpdate = "v1/ExchangeRate";

  // Currencies
  static const String currencies = "v1/Currency";
  // System Settings
  static const String systemSettings = "v1/SystemSettings";
  static const String systemSettingsStatus = "v1/SystemSettings/status";

  // Notifications
  // static const String notifications = "v1/Notification/GetAll";
  // static const String notificationMarkAsRead = "v1/Notification/MarkAsRead";
  // static const String notificationMarkAllAsRead = "v1/Notification/MarkAllAsRead";

  // Exchange Requests
  static const String exchangeRequests = "v1/ExchangeRequest";
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
