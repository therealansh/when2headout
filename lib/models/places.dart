// To parse this JSON data, do
//
//     final places = placesFromJson(jsonString);

import 'dart:convert';

Places placesFromJson(String str) => Places.fromJson(json.decode(str));

String placesToJson(Places data) => json.encode(data.toJson());

class Places {
    Places({
        required this.items,
        this.nextUrl,
        this.prevUrl,
        this.total,
        this.nextOffset,
    });

    List<Item> items;
    dynamic nextUrl;
    dynamic prevUrl;
    int? total;
    dynamic nextOffset;

    factory Places.fromJson(Map<String, dynamic> json) => Places(
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        nextUrl: json["nextUrl"],
        prevUrl: json["prevUrl"],
        total: json["total"],
        nextOffset: json["nextOffset"],
    );

    Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "nextUrl": nextUrl,
        "prevUrl": prevUrl,
        "total": total,
        "nextOffset": nextOffset,
    };
}

class Item {
    Item({
        this.code,
        this.name,
        this.image,
    });

    String? code;
    String? name;
    Img? image;

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        code: json["code"],
        name: json["name"],
        image: Img.fromJson(json["image"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "image": image!.toJson(),
    };
}

class Img {
    Img({
         this.url,
    });

    String? url;

    factory Img.fromJson(Map<String, dynamic> json) => Img(
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
    };
}
