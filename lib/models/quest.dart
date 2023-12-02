// To parse this JSON data, do
//
//     final quest = questFromJson(jsonString);

import 'dart:convert';

List<Quest> questFromJson(String str) => List<Quest>.from(json.decode(str).map((x) => Quest.fromJson(x)));

String questToJson(List<Quest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Quest {
    String model;
    int pk;
    Fields fields;

    Quest({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Quest.fromJson(Map<String, dynamic> json) => Quest(
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
    String name;
    String desc;
    String goal;
    int point;
    String type;
    int amount;
    int bookId;
    int? container;

    Fields({
        required this.name,
        required this.desc,
        required this.goal,
        required this.point,
        required this.type,
        required this.amount,
        required this.bookId,
        required this.container,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        desc: json["desc"],
        goal: json["goal"],
        point: json["point"],
        type: json["type"],
        amount: json["amount"],
        bookId: json["book_id"],
        container: json["container"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "desc": desc,
        "goal": goal,
        "point": point,
        "type": type,
        "amount": amount,
        "book_id": bookId,
        "container": container,
    };
}
