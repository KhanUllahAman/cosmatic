

import 'dart:convert';
ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));
String productModelToJson(ProductModel data) => json.encode(data.toJson());
class ProductModel {
  String id;
  String name;
  String image;
  String category;
  String price;
  String description;
  String usageSpecies;
  String status;
  bool isFav;
  int? quantity;
  ProductModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.category,
      required this.price,
      required this.description,
      required this.usageSpecies,
      required this.status,
      required this.isFav,
      this.quantity});
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      category: json["category"],
      price: json["price"].toString(),
      description: json["description"],
      usageSpecies: json["usageSpecies"],
      status: json["status"],
      isFav: false,
      quantity: json["quantity"]);
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "category":category,
        "price": price,
        "description": description,
        "usageSpecies": usageSpecies,
        "status": status,
        "isFav": isFav,
        "quantity": quantity
      };
  ProductModel copyWith({
    int? quantity,
  }) =>
      ProductModel(
        id: id,
        name: name,
        image: image,
        category: category,
        price: price,
        description: description,
        usageSpecies: usageSpecies,
        status: status,
        isFav: isFav,
        quantity: quantity ?? this.quantity,
      );
}