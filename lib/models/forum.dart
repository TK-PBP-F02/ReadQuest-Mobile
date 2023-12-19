// To parse this JSON data, do
//
//     final forum = forumFromJson(jsonString);

import 'dart:convert';

List<Forum> forumFromJson(String str) =>
    List<Forum>.from(json.decode(str).map((x) => Forum.fromJson(x)));

String forumToJson(List<Forum> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Forum {
  int id;
  String bookTitle;
  String bookAuthor;
  String bookThumbnail;
  String title;
  String content;
  String author;
  DateTime createdAt;
  bool isOwner;

  Forum({
    required this.id,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookThumbnail,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.isOwner,
  });

  factory Forum.fromJson(Map<String, dynamic> json) => Forum(
        id: json["id"],
        bookTitle: json["book_title"],
        bookAuthor: json["book_author"],
        bookThumbnail: json["book_thumbnail"],
        title: json["title"],
        content: json["content"],
        author: json["author"],
        createdAt: DateTime.parse(json["created_at"]),
        isOwner: json["is_owner"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "book_title": bookTitle,
        "book_author": bookAuthor,
        "book_thumbnail": bookThumbnail,
        "title": title,
        "content": content,
        "author": author,
        "created_at": createdAt.toIso8601String(),
        "is_owner": isOwner,
      };
}
