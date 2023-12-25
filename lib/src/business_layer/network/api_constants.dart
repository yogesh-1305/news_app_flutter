class ApiConstants {
  /// api URLs - start -------------------------------------------------
  /// Api URLS DEVELOPMENT
  static const urlDevServer = 'https://newsapi.org/v2/';
  static const devApiKey = 'f14ce12005374b77a2504832dd4ecab7';

  /// Api URLS PRODUCTION
  static const urlProdServer = '';
  static const prodApiKey = '';

  /// Api URLS STAGING
  static const urlStageServer = '';
  static const testApiKey = '';

  /// api URLs - end ---------------------------------------------------

  /// for checking network connection
  static const String googleLink = "google.com";

  /// api end_points - start ---------------------------------------------------

  static const String login = "admin/login";
  static const String homeManagement = "admin/home-management";
  static const String userManagement = "admin/user-management";
  static const String cleanerManagement = "admin/cleaner-management";
  static const String bookingManagement = "admin/booking-management";
  static const String notificationManagement = "admin/list-notification";
  static const String bannerManagement = "admin/banner-management";
  static const String paymentManagement = "admin/payment-management";
  static const String sendNotification = "admin/create-notification";
  static const String addBanner = "admin/create-banner";

  static String userActiveInactive(String? userId) {
    return "admin/active-inactive-user/$userId";
  }

  static String cleanerActiveInactive(String? cleanerId) {
    return "admin/active-inactive-cleaner/$cleanerId";
  }

  static String bannerActiveInactive(String? bannerId) {
    return "admin/active-inactive-banner/$bannerId";
  }

  /// passwords
  static const String changePassword = "/users/changePassword";

  /// booking
  static const String getAvailableSlots = "bookings/availableSlots";
  static const String payment = "bookings/payment";
  static const String getPropertyDetails = "bookings/getPropertyDetails";
  static const String createBooking = "bookings/create";
  static const String cancelBooking = "bookings/cancel";
  static const String addReviews = "serviceProviders/addReviews";
  static const String getSaveCards = "users/cards";
  static const String deleteSaveCard = "users/deleteCard";

  /// api end_points - end -----------------------------------------------------
}
