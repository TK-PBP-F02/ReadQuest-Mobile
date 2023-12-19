import 'dart:convert';

List<Books> booksFromJson(String str) => List<Books>.from(json.decode(str).map((x) => Books.fromJson(x)));

String booksToJson(List<Books> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Books {
    Model model;
    int pk;
    Fields fields;

    Books({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Books.fromJson(Map<String, dynamic> json) => Books(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String isbn;
    String title;
    String author;
    String description;
    String publishedDate;
    String thumbnail;
    String publisher;
    String publicationDate;
    int pageCount;
    String category;
    String imageUrl;
    Lang lang;
    int readed;
    int buys;
    int questAmount;

    Fields({
        required this.isbn,
        required this.title,
        required this.author,
        required this.description,
        required this.publishedDate,
        required this.thumbnail,
        required this.publisher,
        required this.publicationDate,
        required this.pageCount,
        required this.category,
        required this.imageUrl,
        required this.lang,
        required this.readed,
        required this.buys,
        required this.questAmount,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        isbn: json["isbn"],
        title: json["title"],
        author: json["author"],
        description: json["description"],
        publishedDate: json["published_date"],
        thumbnail: json["thumbnail"],
        publisher: json["publisher"],
        publicationDate: json["publication_date"],
        pageCount: json["page_count"],
        category: json["category"],
        imageUrl: json["image_url"],
        lang: langValues.map[json["lang"]]!,
        readed: json["readed"],
        buys: json["buys"],
        questAmount: json["quest_amount"],
    );

    Map<String, dynamic> toJson() => {
        "isbn": isbn,
        "title": title,
        "author": author,
        "description": description,
        "published_date": publishedDate,
        "thumbnail": thumbnail,
        "publisher": publisher,
        "publication_date": publicationDate,
        "page_count": pageCount,
        "category": category,
        "image_url": imageUrl,
        "lang": langValues.reverse[lang],
        "readed": readed,
        "buys": buys,
        "quest_amount": questAmount,
    };
}

enum Lang {
    EN,
    ID
}

final langValues = EnumValues({
    "en": Lang.EN,
    "id": Lang.ID
});

enum Model {
    BOOKS_BOOK
}

final modelValues = EnumValues({
    "books.book": Model.BOOKS_BOOK
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
