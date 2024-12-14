import 'package:equatable/equatable.dart';

class UserInfo extends Equatable {
  String? userId;

  String? customerId;
  String? username;
  String? password;
  String? phoneNumber;
  String? address;
  String? rules;
  String? tokenFireBase;
  String? token;
  String? refreshToken;
  String? expiredAt;

  UserInfo(
      {this.userId,
      this.customerId,
      this.username,
      this.password,
      this.phoneNumber,
      this.address,
      this.rules,
      this.tokenFireBase,
      this.token,
      this.refreshToken,
      this.expiredAt,});

  UserInfo.initial() {
    userId = "0";
    customerId = "1";
    username = "";
    password = "";
    phoneNumber = "";
    address = "";
    rules = "";
    tokenFireBase = "";
    token = "";
    refreshToken = "";
    expiredAt = "";
  }

  UserInfo copyWith(
      {String? userId = "",
      String? customerId = "",
      String? username,
      String? password,
      String? phoneNumber,
      String? address,
      String? rules,
      String? tokenFireBase,
      String? token,
      String? refreshToken,
      String? expiredAt,}) {
    return UserInfo(
        userId: userId ?? this.userId,
        customerId: customerId ?? this.customerId,
        username: username ?? this.username,
        password: password ?? this.password,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address ?? this.address,
        rules: rules ?? this.rules,
        tokenFireBase: tokenFireBase ?? this.tokenFireBase,
        token: token ?? this.token,
        refreshToken: refreshToken ?? this.refreshToken,
        expiredAt: expiredAt ?? this.expiredAt,);
  }

  UserInfo.copyWithUserInfo({required UserInfo userInfo}) {
    userId = userInfo.userId;
    customerId = userInfo.customerId;
    username = userInfo.username;
    password = userInfo.password;
    phoneNumber = userInfo.phoneNumber;
    address = userInfo.address;
    rules = userInfo.rules;
    tokenFireBase = userInfo.tokenFireBase;
    token = userInfo.token;
    refreshToken = userInfo.refreshToken;
    expiredAt = userInfo.expiredAt;
  }

  UserInfo.fromJsonForDB(Map<String, dynamic> json) {
    userId = json['userId'];
    customerId = json['customerId'];
    username = json['username'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    rules = json['rules'];
    tokenFireBase = json['tokenFireBase'];
    token = json['token'];
    refreshToken = json['refreshToken'];
    expiredAt = json['expiredAt'];
  }

  UserInfo.fromJsonForAPI(Map<String, dynamic> json) {
    userId = json['id'];
    customerId = json['customerId'];
    username = json['username'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    rules = json['rules'];
    tokenFireBase = json['tokenFireBase'];
    token = json['token'];
    refreshToken = json['refreshToken'];
    expiredAt = json['expiredAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['customerId'] = customerId;
    data['username'] = username;
    data['password'] = password;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['rules'] = rules;
    data['tokenFireBase'] = tokenFireBase;
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    data['expiredAt'] = expiredAt;
    return data;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['customerId'] = customerId;
    data['username'] = username;
    data['password'] = password;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['rules'] = rules;
    data['tokenFireBase'] = tokenFireBase;
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    data['expiredAt'] = expiredAt;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        userId,
        customerId,
        username,
        password,
        phoneNumber,
        address,
        rules,
        tokenFireBase,
        token,
        refreshToken,
        expiredAt,
      ];
}

class RecentUserList {
  List<UserInfo>? recentUserContentList;

  RecentUserList({this.recentUserContentList}) {
    recentUserContentList ??= [];
  }

  RecentUserList.fromJson(Map<String, dynamic> json) {
    recentUserContentList = <UserInfo>[];
    if (json['RecentUser'] != null) {
      json['RecentUser'].forEach((v) {
        recentUserContentList!.add(UserInfo.fromJsonForDB(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (recentUserContentList != null) {
      data['RecentUser'] =
          recentUserContentList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
