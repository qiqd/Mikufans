import 'package:json_annotation/json_annotation.dart';

part 'history.g.dart';

@JsonSerializable()
class History {
  History({
    required this.id,
    required this.isFollow,
    required this.name,
    required this.image,
    required this.time,
    required this.dateTime,
  });
  //动漫id
  String id;
  //动漫名称(中文优先,如果没有日文的话)
  String name;
  //动漫图片
  String image;
  //视频播放时间
  Duration time;
  //最近播放时间
  DateTime dateTime;
  //该番剧是否追番
  bool isFollow = false;
  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}
