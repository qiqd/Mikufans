import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mikufans/entities/history.dart';
import 'package:mikufans/entities/anime.dart';
import 'package:mikufans/component/anime_card.dart';

class Love extends StatefulWidget {
  const Love({super.key});

  @override
  State<Love> createState() => _LoveState();
}

class _LoveState extends State<Love> {
  late Box<History> _historyBox;
  List<History> _followedAnimes = [];

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  // 初始化Hive并加载追番数据
  void _initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HistoryAdapter());
    _historyBox = await Hive.openBox<History>('history');
    _loadFollowedAnimes();
  }

  // 加载追番的动漫
  void _loadFollowedAnimes() {
    final followedList = <History>[];
    for (var key in _historyBox.keys) {
      final history = _historyBox.get(key);
      if (history != null && history.isFollow) {
        followedList.add(history);
      }
    }

    // 去重：按ID分组，取最新的一条
    final uniqueAnimes = <History>[];
    final seenIds = <String>{};

    for (final history in followedList) {
      if (!seenIds.contains(history.id)) {
        seenIds.add(history.id);
        uniqueAnimes.add(history);
      }
    }

    setState(() {
      _followedAnimes = uniqueAnimes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('追番'), forceMaterialTransparency: true),
      body: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: _followedAnimes.isEmpty
            ? Center(child: Text("暂无数据"))
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3列
                  crossAxisSpacing: 5.0, // 水平间距
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 1 / 1.8,
                ),
                itemCount: _followedAnimes.length,
                itemBuilder: (context, index) {
                  final history = _followedAnimes[index];

                  // 创建一个Anime对象用于展示
                  final anime = Anime(
                    id: int.tryParse(history.id),
                    nameCn: history.name,
                    image: history.image,
                  );

                  return AnimeCard(anime);
                },
              ),
      ),
    );
  }
}
