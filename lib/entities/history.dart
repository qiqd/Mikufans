import 'package:hive/hive.dart';

part 'history.g.dart';

@HiveType(typeId: 0)
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
  @HiveField(0)
  final String id;

  //动漫名称(中文优先,如果没有日文的话)
  @HiveField(1)
  final String name;

  //动漫图片
  @HiveField(2)
  final String image;

  //视频播放时间
  @HiveField(3)
  final String time;

  //最近播放时间
  @HiveField(4)
  final DateTime dateTime;

  //该番剧是否追番
  @HiveField(5)
  bool isFollow = false;
}
