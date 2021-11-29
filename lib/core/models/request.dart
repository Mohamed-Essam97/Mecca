import 'package:Mecca/core/models/service.dart';

class Request {
  String sId;
  String createdAt;
  String requestUtilityStatus;
  bool isCashed;
  int totalPrice;
  int numberOfUtilities;
  String name;
  int executionTime;
  String otherDetails;
  Utility utility;
  String requestBy;
  String personStatus;
  String branch;
  int iV;

  Request(
      {this.sId,
      this.createdAt,
      this.requestUtilityStatus,
      this.isCashed,
      this.totalPrice,
      this.numberOfUtilities,
      this.name,
      this.executionTime,
      this.otherDetails,
      this.utility,
      this.requestBy,
      this.personStatus,
      this.branch,
      this.iV});

  Request.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdAt = json['createdAt'];
    requestUtilityStatus = json['requestUtilityStatus'];
    isCashed = json['isCashed'];
    totalPrice = json['totalPrice'];
    numberOfUtilities = json['numberOfUtilities'];
    name = json['name'];
    executionTime = json['executionTime'];
    otherDetails = json['otherDetails'];
    utility =
        json['utility'] != null ? new Utility.fromJson(json['utility']) : null;
    requestBy = json['requestBy'];
    personStatus = json['personStatus'];
    branch = json['branch'];
    iV = json['__v'];
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
    data['executionTime'] = this.executionTime;
    data['otherDetails'] = this.otherDetails;
    if (this.utility != null) {
      data['utility'] = this.utility.toJson();
    }
    data['requestBy'] = this.requestBy;
    data['personStatus'] = this.personStatus;
    data['branch'] = this.branch;
    data['__v'] = this.iV;
    return data;
  }
}

class UtilityStatus {
  String sId;
  String name;
  int iV;
  bool isDone;

  UtilityStatus({this.sId, this.name, this.iV, this.isDone});

  UtilityStatus.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    iV = json['__v'];
    isDone = json['isDone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['__v'] = this.iV;
    data['isDone'] = this.isDone;
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
