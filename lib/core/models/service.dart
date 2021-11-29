class Utility {
  String sId;
  List<UtilityStatus> utilityStatus;
  List<Prices> prices;
  String title;
  String description;
  String image;
  int defaultPrice;
  int iV;

  Utility(
      {this.sId,
      this.utilityStatus,
      this.prices,
      this.title,
      this.description,
      this.image,
      this.defaultPrice,
      this.iV});

  Utility.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['utilityStatus'] != null) {
      utilityStatus = new List<UtilityStatus>();
      json['utilityStatus'].forEach((v) {
        utilityStatus.add(new UtilityStatus.fromJson(v));
      });
    }
    if (json['prices'] != null) {
      prices = new List<Prices>();
      json['prices'].forEach((v) {
        prices.add(new Prices.fromJson(v));
      });
    }
    title = json['title'];
    description = json['description'];
    image = json['image'];
    defaultPrice = json['defaultPrice'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.utilityStatus != null) {
      data['utilityStatus'] =
          this.utilityStatus.map((v) => v.toJson()).toList();
    }
    if (this.prices != null) {
      data['prices'] = this.prices.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['defaultPrice'] = this.defaultPrice;
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
