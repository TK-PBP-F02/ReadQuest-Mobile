// To parse this JSON data, do
//
//     final replies = repliesFromJson(jsonString);

import 'dart:convert';

List<Replies> repliesFromJson(String str) => List<Replies>.from(json.decode(str).map((x) => Replies.fromJson(x)));

String repliesToJson(List<Replies> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Replies {
    String model;
    int pk;
    Fields fields;

    Replies({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Replies.fromJson(Map<String, dynamic> json) => Replies(
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
    int author;
    int parentForum;
    String content;
    DateTime createdAt;

    Fields({
        required this.author,
        required this.parentForum,
        required this.content,
        required this.createdAt,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        author: json["author"],
        parentForum: json["parent_forum"],
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "author": author,
        "parent_forum": parentForum,
        "content": content,
        "created_at": createdAt.toIso8601String(),
    };
}
