// @JsonSerializable()
class Anime {
  int? id;
  int? eps;

  // @JsonKey(name: 'meta_tags')
  List<String>? metaTags;
  String? date;
  String image;
  String? summary;
  String? name;

  // @JsonKey(name: 'name_cn')
  String? nameCn;

  Anime({
    this.id,
    this.eps,
    this.metaTags,
    this.date,
    required this.image,
    this.summary,
    this.name,
    this.nameCn,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['id'] as int?,
      eps: json['eps'] as int?,
      metaTags: (json['meta_tags'] as List?)?.map((e) => e as String).toList(),
      date: json['date'] as String?,
      image: json['image'] as String,
      summary: (json['summary'] as String?)?.replaceAll(RegExp(r'\s+'), ''),
      name: json['name'] as String?,
      nameCn: json['name_cn'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eps': eps,
      'meta_tags': metaTags,
      'date': date,
      'image': image,
      'summary': summary,
      'name': name,
      'name_cn': nameCn,
    };
  }

  @override
  String toString() {
    return 'Anime{id: $id, eps: $eps, metaTags: $metaTags, date: $date, image: $image, summary: $summary, name: $name, nameCn: $nameCn}';
  }
}
