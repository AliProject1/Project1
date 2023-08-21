class cart {
  String? sId;
  List<String>? productIds;

  cart({this.sId, this.productIds});

  cart.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productIds = json['productIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['productIds'] = this.productIds;
    return data;
  }
}