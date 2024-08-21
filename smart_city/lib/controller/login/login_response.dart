class LoginResponse {
  String? username;
  String? pageMain;
  String? token;
  String? expiredAt;
  LoginResponse({this.username, this.pageMain, this.token, this.expiredAt});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    pageMain = json['pageMain'];
    token = json['token'];
    expiredAt = json['expiredAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['pageMain'] = pageMain;
    data['token'] = token;
    data['expiredAt'] = expiredAt;
    return data;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['pageMain'] = pageMain;
    data['token'] = token;
    data['expiredAt'] = expiredAt;
    return data;
  }
}
