class ApiName {
  static ApiName ?_instance = ApiName();

  static ApiName getInstance() {
    _instance ??= ApiName();
    return _instance!;
  }

  final int connectTimeout = 30000;
  final int readTimeout = 20000;

  //user
  final String LOGIN = "/login";
  final String LOGOUT = "/logout";
  final String REQUEST_OTP = "/request-otp";
  final String VERIFY_OTP = "/verify-otp";
  final String CREATE_PIN = "/pin-code";
  final String UPDATE_PIN = "/pin-code";
  final String RESET_PIN = "/pin-code/reset";

  final String LOGIN_WITH_PIN = "/login-pin";
  final String LOGIN_WITH_OTP = "/login-otp";
  final String SEARCH_USER ="/search-child-users";
  final String CREATE_USER = "";
  final String CREATE_CUSTOM_USER = "/customer";

  final String DELETE_USER = "";
  final String GET_WALLET_BALANCE = "/wallet-balance";
  final String PROFILE = "/profile";
  final String CHANGE_PASSWORD = "/change-password";
  final String USER_CHILD_LIST = "/get-child-users";
  final String FORGOT_PASSWORD = "/forgot-password";


  ///tracking
  final String LIST_EV_CHARGE = "/ev-charge";
  final String NEAREST_EV_CHARGE = "/ev-charge/nearest";
  final String EV_CHARGE_DETAIL = "/ev-charge";
  final String EV_CHARGE_GET_ALL_CONFIG= "/devices/config";


  /// report api
  final String REPORT_SPEED = "/speed";
  final String REPORT_SUMMARY_BY_DEVICE = "/summary-by-device";
  final String REPORT_ENGINE_HOURS = "/engine";
  final String REPORT_HISTORY_STATUS = "/status-history";
  final String REPORT_ROUTE = "/route";
  final String REPORT_GEO_SUMMARY = "/geofence";
  final String REPORT_GEO_DETAIL = "/geofence-detail";
  final String REPORT_FUEL_CHANGE= "/fuel-change";


  ///setting
  final String GET_ALL_CONFIG = "/config";

  /// booking
  final String BOOKING_CREATE = "";
  final String BOOKING_CONFIRM = "/confirm/";
  final String BOOKING_CANCEL = "/cancel";
  final String BOOKING_DETAIL = "";
  final String BOOKING_GET_PERIOD_TIME = "/period-time";
  final String BOOKING_SEARCH = "/search";


  ///favourite

  final String DEVICE_FAVOURITE_CREATE= "/device-favourite";
  final String DEVICE_FAVOURITE_DELETE= "/device-favourite";
  final String DEVICE_FAVOURITE_SEARCH= "/device-favourite/search";

  /// payment and charring
  final String remoteStartTransaction= "remotestarttransaction";
  final String remoteStopTransaction= "remotestoptransaction";

  final String getChargingStatus ="/charging";

  ///charging list
  final String CHARGING_SEARCH = "/search";

  final String getPaymentQrCode= "/get-balance-qr";
  final String getPaymentDetail= "/search-By-RefNum";

  /// dardboard
  final String dashboard= "dashboard";

  /// qr_code
  final String getQrCodeByType= "/info";
  final String notifyHistory="/search";
  final String notifyUpdateReadStatus="/is-read";

}

