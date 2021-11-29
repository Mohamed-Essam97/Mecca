class OnBoarding {
  String sId;
  String image;
  String description;
  int iV;

  OnBoarding({this.sId, this.image, this.description, this.iV});

  OnBoarding.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    image = json['image'];
    description = json['description'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['image'] = this.image;
    data['description'] = this.description;
    data['__v'] = this.iV;
    return data;
  }
}
