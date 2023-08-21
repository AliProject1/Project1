class Order {
  List<Data>? data;

  Order({this.data});

  Order.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? userId;
  String? productID;
  String? amount;
  String? rue;
  String? mo3tamdia;
  String? wileya;
  String? codePostal;
  String? phone;
  String? nameUser;
  String? lastName;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? namep;
  String? pricep;
  String? pphote;

  Data(
      {this.sId,
      this.userId,
      this.productID,
      this.amount,
      this.rue,
      this.mo3tamdia,
      this.wileya,
      this.codePostal,
      this.phone,
      this.nameUser,
      this.lastName,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.namep,
      this.pricep,
      this.pphote});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    productID = json['productID'];
    amount = json['amount'];
    rue = json['rue'];
    mo3tamdia = json['mo3tamdia'];
    wileya = json['wileya'];
    codePostal = json['code_postal'];
    phone = json['phone'];
    nameUser = json['nameUser'];
    lastName = json['lastName'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    namep = json['namep'];
    pricep = json['pricep'];
    pphote = json['pphote'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['productID'] = this.productID;
    data['amount'] = this.amount;
    data['rue'] = this.rue;
    data['mo3tamdia'] = this.mo3tamdia;
    data['wileya'] = this.wileya;
    data['code_postal'] = this.codePostal;
    data['phone'] = this.phone;
    data['nameUser'] = this.nameUser;
    data['lastName'] = this.lastName;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['namep'] = this.namep;
    data['pricep'] = this.pricep;
    data['pphote'] = this.pphote;
    return data;
  }
}