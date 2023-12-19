// To parse this JSON data, do
//
//     final display = displayFromJson(jsonString);

import 'dart:convert';

List<Display> displayFromJson(String str) =>
    List<Display>.from(json.decode(str).map((x) => Display.fromJson(x)));

String displayToJson(List<Display> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Display {
  String model;
  int pk;
  Fields fields;

  Display({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Display.fromJson(Map<String, dynamic> json) => Display(
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
  String nickname;
  int akun;

  Fields({
    required this.nickname,
    required this.akun,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        nickname: json["nickname"],
        akun: json["akun"],
      );

  Map<String, dynamic> toJson() => {
        "nickname": nickname,
        "akun": akun,
      };
}
