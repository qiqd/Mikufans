class Weekly {
  Weekday? weekday;
  List<Item>? items;

  Weekly({this.weekday, this.items});

  factory Weekly.fromJson(Map<String, dynamic> json) {
    return Weekly(
      weekday: json['weekday'] != null
          ? Weekday.fromJson(json['weekday'] as Map<String, dynamic>)
          : null,
      items: (json['items'] as List?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekday': weekday?.toJson(),
      'items': items?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Weekly{weekday: $weekday, items: $items}';
  }
}

class Weekday {
  String? en;
  String? cn;
  String? ja;
  int? id;

  Weekday({this.en, this.cn, this.ja, this.id});

  factory Weekday.fromJson(Map<String, dynamic> json) {
    return Weekday(
      en: json['en'] as String?,
      cn: json['cn'] as String?,
      ja: json['ja'] as String?,
      id: json['id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'en': en, 'cn': cn, 'ja': ja, 'id': id};
  }

  @override
  String toString() {
    return 'Weekday{en: $en, cn: $cn, ja: $ja, id: $id}';
  }
}

class Item {
  int? id;
  String? url;
  int? type;
  String? name;
  String? nameCn;
  String? summary;
  String? airDate;
  int? airWeekday;
  String image;

  Item({
    this.id,
    this.url,
    this.type,
    this.name,
    this.nameCn,
    this.summary,
    this.airDate,
    this.airWeekday,
    required this.image,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int?,
      url: json['url'] as String?,
      type: json['type'] as int?,
      name: json['name'] as String?,
      nameCn: json['name_cn'] as String?,
      summary: (json['summary'] as String?)?.replaceAll(RegExp(r'\s+'), ' '),
      airDate: json['air_date'] as String?,
      airWeekday: json['air_weekday'] as int?,
      image: (json['images'] as Map<String, dynamic>?)?["large"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'type': type,
      'name': name,
      'name_cn': nameCn,
      'summary': summary,
      'air_date': airDate,
      'air_weekday': airWeekday,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'Item{id: $id, url: $url, type: $type, name: $name, nameCn: $nameCn, summary: $summary, airDate: $airDate, airWeekday: $airWeekday, image: $image}';
  }
}
