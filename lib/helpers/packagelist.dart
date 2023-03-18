// To parse this JSON data, do
//
//     final packageList = packageListFromJson(jsonString);

import 'dart:convert';

List<PackageList> packageListFromJson(String str) => List<PackageList>.from(json.decode(str).map((x) => PackageList.fromJson(x)));

String packageListToJson(List<PackageList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PackageList {
    PackageList({
        required this.id,
        required this.packageName,
        required this.cost,
        required this.image,
        required this.description,
        required this.createdAt,
        required this.updatedAt,
    });

    int id;
    String packageName;
    String cost;
    String image;
    String description;
    DateTime createdAt;
    DateTime updatedAt;

    factory PackageList.fromJson(Map<String, dynamic> json) => PackageList(
        id: json["id"],
        packageName: json["package_name"],
        cost: json["cost"],
        image: json["image"],
        description: json["description"] ?? "",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "package_name": packageName,
        "cost": cost,
        "image": image,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
