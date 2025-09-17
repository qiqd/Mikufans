// @JsonSerializable()
class Anime {
  //动画id
  int? id;
  //剧集总数
  int? eps;

  ///元标签
  List<String>? metaTags;
  //放送时间
  String? date;
  //图片
  String image;
  //简介
  String? summary;
  //名称(日文)
  String? name;

  //名称(中文)
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
      image:
          (json['image'] ?? (json["images"] as Map<String, dynamic>)["medium"])
              as String,
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
