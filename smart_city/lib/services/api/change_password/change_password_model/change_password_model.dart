class ChangePasswordModel {
  String passwordOld = "";
  String passwordNew = "";
  int userId = 0;

  ChangePasswordModel({
    required this.passwordOld,
    required this.passwordNew,
    required this.userId,
  });

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    passwordOld = json['passwordOld'];
    passwordNew = json['passwordNew'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['passwordOld'] = passwordOld;
    data['passwordNew'] = passwordNew;
    data['userId'] = userId;
    return data;
  }
}
