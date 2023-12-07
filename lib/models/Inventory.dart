// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Inventory> productFromJson(String str) => List<Inventory>.from(json.decode(str).map((x) => Inventory.fromJson(x)));

String productToJson(List<Inventory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Inventory {
    String model;
    int pk;
    Fields fields;

    Inventory({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String name;

    Fields({
        required this.user,
        required this.name,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "name": name,
    };
}
