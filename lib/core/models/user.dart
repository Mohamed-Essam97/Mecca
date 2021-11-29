class User {
  String token;
  UserInfo user;

  User({this.token, this.user});

  User.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new UserInfo.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class UserInfo {
  bool enableNotification;
  bool acceptCondition;
  String phone;
  bool isActive;
  String userType;
  String email;
  String name;
  String sId;
  String password;
  String state;
  String city;
  String country;
  int iV;
  String fcmToken;

  UserInfo(
      {this.enableNotification,
      this.acceptCondition,
      this.phone,
      this.isActive,
      this.userType,
      this.email,
      this.name,
      this.sId,
      this.password,
      this.state,
      this.city,
      this.country,
      this.iV,
      this.fcmToken});

  UserInfo.fromJson(Map<String, dynamic> json) {
    enableNotification = json['enableNotification'];
    acceptCondition = json['acceptCondition'];
    phone = json['phone'];
    isActive = json['isActive'];
    userType = json['userType'];
    email = json['email'];
    name = json['name'];
    sId = json['_id'];
    password = json['password'];
    state = json['state'];
    city = json['city'];
    country = json['country'];
    iV = json['__v'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enableNotification'] = this.enableNotification;
    data['acceptCondition'] = this.acceptCondition;
    data['phone'] = this.phone;
    data['isActive'] = this.isActive;
    data['userType'] = this.userType;
    data['email'] = this.email;
    data['name'] = this.name;
    data['_id'] = this.sId;
    data['password'] = this.password;
    data['state'] = this.state;
    data['city'] = this.city;
    data['country'] = this.country;
    data['__v'] = this.iV;
    data['fcmToken'] = this.fcmToken;
    return data;
  }
}
