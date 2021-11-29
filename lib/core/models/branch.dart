class Branch {
  String sId;
  String name;
  String address;
  int iV;

  Branch({this.sId, this.name, this.address, this.iV});

  Branch.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    address = json['address'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['__v'] = this.iV;
    return data;
  }
}
