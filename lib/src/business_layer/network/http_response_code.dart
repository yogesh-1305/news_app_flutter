class HttpResponseCode {
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int unAuthorized = 401;
  static const int forbidden = 403;
  static const int badGateway = 502;
  static const int badRequest = 400;
  static const int conflict = 409;
  static const int continueCode = 100;
  static const int exceptionFailed = 417;
  static const int failedDependency = 424;
  static const int found = 302;
  static const int gatewayTimeout = 504;
  static const int gone = 410;
  static const int httpVersionNotSupported = 505;
  static const int inSufficientStorage = 507;
  static const int internalServerError = 500;
  static const int lengthRequired = 411;
  static const int locked = 423;
  static const int methodNotAllowed = 405;
  static const int movedPermanently = 301;
  static const int multiStatus = 207;
  static const int multipleChoices = 300;
  static const int networkAuthenticationRequired = 511;
  static const int noContent = 204;
  static const int nonAuthoritativeInformation = 203;
  static const int notAcceptable = 406;
  static const int notExtended = 510;
  static const int notFound = 404;
  static const int notImplemented = 501;
  static const int notModified = 304;
  static const int partialContent = 206;
  static const int paymentRequired = 402;
  static const int preConditionFailed = 412;
  static const int preConditionRequired = 428;
  static const int processing = 102;
  static const int proxyAuthenticationRequired = 407;
  static const int requestEntityNoLarge = 413;
  static const int requestHeaderFieldTooLarge = 431;
  static const int requestTimeOut = 408;
  static const int requestUrlTooLong = 414;
  static const int requestedRangeNotSatisfiable = 416;
  static const int resetContent = 205;
  static const int seeOther = 303;
  static const int serviceUnavailable = 503;
  static const int switchingProtocols = 101;
  static const int temporaryRedirect = 307;
  static const int tooManyRequests = 429;
  static const int unorderedCollection = 425;
  static const int unProcessableEntity = 422;
  static const int unsupportedMetaType = 415;
  static const int upgradeRequired = 426;
  static const int useProxy = 305;
  static const int variantAlsoNegotiates = 506;
}

///this class provides Http request types
class HttpRequestMethods {
  static const String post = "POST";
  static const String get = "GET";
  static const String put = "PUT";
  static const String delete = "DELETE";
  static const String patch = "PATCH";
}

/// class to access timeout utilities
class TimeoutCode {
  static const Duration connectionTimeout = Duration(seconds: 120);
  static const Duration receiveTimeout = Duration(seconds: 120);
  static const Duration sendTimeout = Duration(seconds: 120);
}
