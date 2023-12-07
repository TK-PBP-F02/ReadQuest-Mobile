// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<InventoryBook> productFromJson(String str) => List<InventoryBook>.from(json.decode(str).map((x) => InventoryBook.fromJson(x)));

String productToJson(List<InventoryBook> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InventoryBook {
    String model;
    int pk;
    Fields fields;

    InventoryBook({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory InventoryBook.fromJson(Map<String, dynamic> json) => InventoryBook(
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
    int inventory;
    int book;

    Fields({
        required this.inventory,
        required this.book,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        inventory: json["inventory"],
        book: json["book"],
    );

    Map<String, dynamic> toJson() => {
        "inventory": inventory,
        "book": book,
    };
}
