import 'package:mikufans/api/bangumi.dart';
import 'package:mikufans/component/anime_card.dart';
import 'package:mikufans/entities/anime.dart';
import 'package:mikufans/entities/weekly.dart';
import 'package:mikufans/pages/anime_player.dart';
import 'package:mikufans/theme/theme.dart';
import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _WeeklyState();
}

class _WeeklyState extends State<Schedule>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  List<Weekly> _weeklyList = [];
  void initWeekly() async {
    List<Weekly> res = await Bangumi.getWeekly();
    setState(() => _weeklyList = res);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    initWeekly();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('周更表'),
        bottom: TabBar(
          tabAlignment: TabAlignment.center,
          controller: _tabController,
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: GlobalTheme.primaryColor,
          dividerColor: Colors.transparent,
          indicatorColor: GlobalTheme.primaryColor,
          tabs: [
            Tab(text: '一'),
            Tab(text: '二'),
            Tab(text: '三'),
            Tab(text: '四'),
            Tab(text: '五'),
            Tab(text: '六'),
            Tab(text: '日'),
          ],
        ),
      ),

      body: Container(
        margin: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: TabBarView(
          controller: _tabController,
          children: List.generate(7, (index) {
            // 获取当前星期的数据
            final weeklyData = _weeklyList.isEmpty ? null : _weeklyList[index];

            return Center(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3列
                  crossAxisSpacing: 5.0, // 水平间距
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 1 / 1.6,
                ),
                itemCount: weeklyData?.items?.length ?? 0,
                itemBuilder: (context, itemIndex) {
                  final item = weeklyData?.items?[itemIndex];
                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AnimePlayer(item.id!, item.nameCn!),
                      ),
                    ),

                    child: AnimeCard(
                      Anime(
                        image: item!.image,
                        name: item.name,
                        nameCn: item.nameCn,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
