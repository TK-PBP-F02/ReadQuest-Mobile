// To parse this JSON data, do
//
//     final forum = forumFromJson(jsonString);

import 'dart:convert';

List<Forum> forumFromJson(String str) => List<Forum>.from(json.decode(str).map((x) => Forum.fromJson(x)));

String forumToJson(List<Forum> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Forum {
    String model;
    int pk;
    Fields fields;

    Forum({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Forum.fromJson(Map<String, dynamic> json) => Forum(
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
    int book;
    String title;
    String content;
    DateTime createdAt;

    Fields({
        required this.author,
        required this.book,
        required this.title,
        required this.content,
        required this.createdAt,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        author: json["author"],
        book: json["book"],
        title: json["title"],
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "author": author,
        "book": book,
        "title": title,
        "content": content,
        "created_at": createdAt.toIso8601String(),
    };
}
