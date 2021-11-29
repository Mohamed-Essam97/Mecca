import 'package:Mecca/core/models/service.dart';

class ProviderRequest {
  String sId;
  String createdAt;
  String requestUtilityStatus;
  bool isCashed;
  int totalPrice;
  int numberOfUtilities;
  String name;
  String otherDetails;
  Utility utility;
  RequestBy requestBy;
  RequestBy approver;
  PersonStatus personStatus;
  PersonStatus utilityCurrentStatus;
  String branch;
  int iV;
  int executionTime;

  ProviderRequest(
      {this.sId,
      this.createdAt,
      this.requestUtilityStatus,
      this.isCashed,
      this.totalPrice,
      this.numberOfUtilities,
      this.name,
      this.otherDetails,
      this.utility,
      this.requestBy,
      this.approver,
      this.personStatus,
      this.utilityCurrentStatus,
      this.branch,
      this.iV,
      this.executionTime});

  ProviderRequest.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdAt = json['createdAt'];
    requestUtilityStatus = json['requestUtilityStatus'];
    isCashed = json['isCashed'];
    totalPrice = json['totalPrice'];
    numberOfUtilities = json['numberOfUtilities'];
    name = json['name'];
    otherDetails = json['otherDetails'];
    utility =
        json['utility'] != null ? new Utility.fromJson(json['utility']) : null;
    requestBy = json['requestBy'] != null
        ? new RequestBy.fromJson(json['requestBy'])
        : null;
    approver = json['approver'] != null
        ? new RequestBy.fromJson(json['approver'])
        : null;
    personStatus = json['personStatus'] != null
        ? new PersonStatus.fromJson(json['personStatus'])
        : null;
    utilityCurrentStatus = json['utilityCurrentStatus'] != null
        ? new PersonStatus.fromJson(json['utilityCurrentStatus'])
        : null;
    branch = json['branch'];
    iV = json['__v'];
    executionTime = json['executionTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['requestUtilityStatus'] = this.requestUtilityStatus;
    data['isCashed'] = this.isCashed;
    data['totalPrice'] = this.totalPrice;
    data['numberOfUtilities'] = this.numberOfUtilities;
    data['name'] = this.name;
    data['otherDetails'] = this.otherDetails;
    if (this.utility != null) {
      data['utility'] = this.utility.toJson();
    }
    if (this.requestBy != null) {
      data['requestBy'] = this.requestBy.toJson();
    }
    if (this.approver != null) {
      data['approver'] = this.approver.toJson();
    }
    if (this.personStatus != null) {
      data['personStatus'] = this.personStatus.toJson();
    }
    if (this.utilityCurrentStatus != null) {
      data['utilityCurrentStatus'] = this.utilityCurrentStatus.toJson();
    }
    data['branch'] = this.branch;
    data['__v'] = this.iV;
    data['executionTime'] = this.executionTime;
    return data;
  }
}

class Prices {
  String from;
  String to;
  String price;

  Prices({this.from, this.to, this.price});

  Prices.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['to'] = this.to;
    data['price'] = this.price;
    return data;
  }
}

class RequestBy {
  String sId;
  bool acceptCondition;
  String phone;
  bool isActive;
  String userType;
  String email;
  String name;
  String password;
  String state;
  String city;
  String country;
  int iV;
  String apple;
  String facebook;
  String google;
  String fcmToken;

  RequestBy(
      {this.sId,
      this.acceptCondition,
      this.phone,
      this.isActive,
      this.userType,
      this.email,
      this.name,
      this.password,
      this.state,
      this.city,
      this.country,
      this.iV,
      this.apple,
      this.facebook,
      this.google,
      this.fcmToken});

  RequestBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    acceptCondition = json['acceptCondition'];
    phone = json['phone'];
    isActive = json['isActive'];
    userType = json['userType'];
    email = json['email'];
    name = json['name'];
    password = json['password'];
    state = json['state'];
    city = json['city'];
    country = json['country'];
    iV = json['__v'];
    apple = json['apple'];
    facebook = json['facebook'];
    google = json['google'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['acceptCondition'] = this.acceptCondition;
    data['phone'] = this.phone;
    data['isActive'] = this.isActive;
    data['userType'] = this.userType;
    data['email'] = this.email;
    data['name'] = this.name;
    data['password'] = this.password;
    data['state'] = this.state;
    data['city'] = this.city;
    data['country'] = this.country;
    data['__v'] = this.iV;
    data['apple'] = this.apple;
    data['facebook'] = this.facebook;
    data['google'] = this.google;
    data['fcmToken'] = this.fcmToken;
    return data;
  }
}

class PersonStatus {
  String sId;
  String name;
  int iV;

  PersonStatus({this.sId, this.name, this.iV});

  PersonStatus.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['__v'] = this.iV;
    return data;
  }
}
