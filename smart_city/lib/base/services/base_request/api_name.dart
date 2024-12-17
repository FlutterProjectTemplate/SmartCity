class ApiName {
  static ApiName ?_instance;
  ApiName._internal();

  static ApiName getInstance() {
    _instance ??= ApiName._internal();
    return _instance!;
  }

  final int connectTimeout = 30000;
  final int readTimeout = 20000;

  //user
  final String LOGIN = "/login";
  final String refreshToken = "/refresh-token";
  final String LOGOUT = "/logout";
  final String REQUEST_OTP = "/request-otp";
  final String VERIFY_OTP = "/verify-otp";
  final String CREATE_PIN = "/pin-code";
  final String UPDATE_PIN = "/pin-code";
  final String RESET_PIN = "/pin-code/reset";

  final String LOGIN_WITH_PIN = "/login-pin";
  final String LOGIN_WITH_OTP = "/login-otp";
  final String CREATE_USER = "/customer";
  final String DELETE_USER = "";

  final String PROFILE = "/profile";
  final String AVATAR = "/avatar";
  final String CHANGE_PASSWORD = "/change-password";
  final String FORGOT_PASSWORD = "/forgot-password";

  //Node
  final String Node = "";
  final String GET_ALL = "/get-all";
  final String GET_ALL_CUSTOMER = "/get-all";

  //Vechicle type
  final String ALL = '/all';

  //Vector
  final String Seach_by_radious = "/search-by-radius";
  final String Search = "/search";

}

