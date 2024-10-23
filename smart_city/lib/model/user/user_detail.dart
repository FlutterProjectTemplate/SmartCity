class UserDetail {
  int? id;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? updatedBy;
  int? parentId;
  String? path;
  String? username;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? description;
  String? timezone;
  String? language;
  String? permission;
  int? roleId;
  bool? hasChild;
  String? roleName;
  String? roleKey;
  bool? pinCode;
  String? avatar;
  int? customerId;
  int? isEnabled;
  int? isAdmin;

  UserDetail(
      {this.id,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.parentId,
      this.path,
      this.username,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.description,
      this.timezone,
      this.language,
      this.permission,
      this.roleId,
      this.hasChild,
      this.roleName,
      this.roleKey,
      this.pinCode,
      this.avatar,
      this.customerId,
      this.isEnabled,
      this.isAdmin});

  UserDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    updatedAt = json['updatedAt'];
    updatedBy = json['updatedBy'];
    parentId = json['parentId'];
    path = json['path'];
    username = json['username'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    description = json['description'];
    timezone = json['timezone'];
    language = json['language'];
    permission = json['permission'];
    roleId = json['roleId'];
    hasChild = json['hasChild'];
    roleName = json['roleName'];
    roleKey = json['roleKey'];
    pinCode = json['pinCode'];
    avatar = json['avatar'];
    customerId = json['customerId'];
    isEnabled = json['isEnabled'];
    isAdmin = json['isAdmin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['createdBy'] = this.createdBy;
    data['updatedAt'] = this.updatedAt;
    data['updatedBy'] = this.updatedBy;
    data['parentId'] = this.parentId;
    data['path'] = this.path;
    data['username'] = this.username;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['description'] = this.description;
    data['timezone'] = this.timezone;
    data['language'] = this.language;
    data['permission'] = this.permission;
    data['roleId'] = this.roleId;
    data['hasChild'] = this.hasChild;
    data['roleName'] = this.roleName;
    data['roleKey'] = this.roleKey;
    data['pinCode'] = this.pinCode;
    data['avatar'] = this.avatar;
    data['customerId'] = this.customerId;
    data['isEnabled'] = this.isEnabled;
    data['isAdmin'] = this.isAdmin;
    return data;
  }

  UserDetail.initial() {
    id = 0;
    createdAt = "";
    createdBy = "";
    updatedAt = "";
    updatedBy = "";
    parentId = 0;
    path = "";
    username = "";
    name = "";
    email = "";
    phone = "";
    address = "";
    description = "";
    timezone = "";
    language = "";
    permission = "";
    roleId = 0;
    hasChild = false;
    roleName = "";
    roleKey = "";
    pinCode = false;
    avatar = "";
    customerId = 0;
    isEnabled = 0;
    isAdmin = 0;
  }

  UserDetail copyWith(
      {int? id,
      String? createdAt,
      String? createdBy,
      String? updatedAt,
      String? updatedBy,
      int? parentId,
      String? path,
      String? username,
      String? name,
      String? email,
      String? phone,
      String? address,
      String? description,
      String? timezone,
      String? language,
      String? permission,
      int? roleId,
      bool? hasChild,
      String? roleName,
      String? roleKey,
      bool? pinCode,
      String? avatar,
      int? customerId,
      int? isEnabled,
      int? isAdmin}) {
    return UserDetail(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        parentId: parentId ?? this.parentId,
        path: path ?? this.path,
        username: username ?? this.username,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        description: description ?? this.description,
        timezone: timezone ?? this.timezone,
        language: language ?? this.language,
        permission: permission ?? this.permission,
        roleId: roleId ?? this.roleId,
        hasChild: hasChild ?? this.hasChild,
        roleName: roleName ?? this.roleName,
        roleKey: roleKey ?? this.roleKey,
        pinCode: pinCode ?? this.pinCode,
        avatar: avatar ?? this.avatar,
        customerId: customerId ?? this.customerId,
        isEnabled: isEnabled ?? this.isEnabled,
        isAdmin: isAdmin ?? this.isAdmin);
  }

  UserDetail.copyWithUserInfo({required UserDetail userDetail}) {
    id = userDetail.id;
    createdAt = userDetail.createdAt;
    createdBy = userDetail.createdBy;
    updatedAt = userDetail.updatedAt;
    updatedBy = userDetail.updatedBy;
    parentId = userDetail.parentId;
    path = userDetail.path;
    username = userDetail.username;
    name = userDetail.name;
    email = userDetail.email;
    phone = userDetail.phone;
    address = userDetail.address;
    description = userDetail.description;
    timezone = userDetail.timezone;
    language = userDetail.language;
    permission = userDetail.permission;
    roleId = userDetail.roleId;
    hasChild = userDetail.hasChild;
    roleName = userDetail.roleName;
    roleKey = userDetail.roleKey;
    pinCode = userDetail.pinCode;
    avatar = userDetail.avatar;
    customerId = userDetail.customerId;
    isEnabled = userDetail.isEnabled;
    isAdmin = userDetail.isAdmin;
  }
}
