import 'dart:convert';

CatalougeModel catalougeModelFromJson(String str) =>
    CatalougeModel.fromJson(json.decode(str));

String catalougeModelToJson(CatalougeModel data) => json.encode(data.toJson());

class CatalougeModel {
  String id;
  String category;
  String name;
  String image;
  String description;
  String usageSpecies;

  CatalougeModel({
    required this.id,
    required this.category,
    required this.name,
    required this.image,
    required this.description,
    required this.usageSpecies,
  });

  factory CatalougeModel.fromJson(Map<String, dynamic> json) => CatalougeModel(
        id: json["id"],
        category: json["category"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        usageSpecies: json["usageSpecies"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        category:category,
        "name": name,
        "image": image,
        "description": description,
        "usageSpecies": usageSpecies,
      };
}
