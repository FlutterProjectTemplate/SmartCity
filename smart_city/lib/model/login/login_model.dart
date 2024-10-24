class LoginModel {
  String? token;
  String? username;
  String? refreshToken;
  String? expiredAt;

  LoginModel({this.token, this.username, this.refreshToken, this.expiredAt});

  LoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    username = json['username'];
    refreshToken = json['refreshToken'];
    expiredAt = json['expiredAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['username'] = username;
    data['refreshToken'] = refreshToken;
    data['expiredAt'] = expiredAt;
    return data;
  }
}
