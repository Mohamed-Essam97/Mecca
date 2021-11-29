class Noification {
  String createAt;
  String sId;
  String title;
  String description;
  String sender;
  String reciver;
  int iV;

  Noification(
      {this.createAt,
      this.sId,
      this.title,
      this.description,
      this.sender,
      this.reciver,
      this.iV});

  Noification.fromJson(Map<String, dynamic> json) {
    createAt = json['createAt'];
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    sender = json['sender'];
    reciver = json['reciver'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createAt'] = this.createAt;
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['sender'] = this.sender;
    data['reciver'] = this.reciver;
    data['__v'] = this.iV;
    return data;
  }
}
