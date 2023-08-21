class Product {
  String? sId;
  String? sellerId;
  String? nomProduit;
  String? prixProduitAfter;
  String? prixProduitBefore;
  String? photoProduitPrincipale;
  String? description;
  int? iV;

  Product({
    this.sId,
    this.sellerId,
    this.nomProduit,
    this.prixProduitAfter,
    this.prixProduitBefore,
    this.photoProduitPrincipale,
    this.description,
    this.iV,
  });

  Product.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sellerId = json['sellerId'];
    nomProduit = json['nomProduit'];
    prixProduitAfter = json['prixProduitAfter'];
    prixProduitBefore = json['prixProduitBefore'];
    photoProduitPrincipale = json['photoProduitPrincipale'];
    description = json['description'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{}; // Use type inference
    data['_id'] = sId;
    data['sellerId'] = sellerId;
    data['nomProduit'] = nomProduit;
    data['prixProduitAfter'] = prixProduitAfter;
    data['prixProduitBefore'] = prixProduitBefore;
    data['photoProduitPrincipale'] = photoProduitPrincipale;
    data['description'] = description;
    data['__v'] = iV;
    return data;
  }
}
