// To parse this JSON data, do
//
//     final replies = repliesFromJson(jsonString);

import 'dart:convert';

List<Replies> repliesFromJson(String str) => List<Replies>.from(json.decode(str).map((x) => Replies.fromJson(x)));

String repliesToJson(List<Replies> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Replies {
    int id;
    int forumId;
    String content;
    String author;
    DateTime createdAt;
    bool isOwner;

    Replies({
        required this.id,
        required this.forumId,
        required this.content,
        required this.author,
        required this.createdAt,
        required this.isOwner,
    });

    factory Replies.fromJson(Map<String, dynamic> json) => Replies(
        id: json["id"],
        forumId: json["ForumId"],
        content: json["content"],
        author: json["author"],
        createdAt: DateTime.parse(json["created_at"]),
        isOwner: json["is_owner"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "ForumId": forumId,
        "content": content,
        "author": author,
        "created_at": createdAt.toIso8601String(),
        "is_owner": isOwner,
    };
}
