import 'package:mikufans/component/anime_card.dart';
import 'package:mikufans/theme/theme.dart';
import 'package:flutter/material.dart';

class Weekly extends StatefulWidget {
  const Weekly({super.key});

  @override
  State<Weekly> createState() => _WeeklyState();
}

class _WeeklyState extends State<Weekly> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('周更表'),
        bottom: TabBar(
          tabAlignment: TabAlignment.center,
          controller: _tabController,
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: GlobalTheme.primaryColor,

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
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          // border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            // 星期一的内容
            Center(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3列
                  crossAxisSpacing: 5.0, // 水平间距
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 1 / 1.8,
                ),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return AnimeCard();
                },
              ),
            ),
            // 星期二的内容
            Center(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3列
                  crossAxisSpacing: 5.0, // 水平间距
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 1 / 1.8,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  return AnimeCard();
                },
              ),
            ),
            // 星期三的内容
            Center(child: Text('星期三内容')),
            // 星期四的内容
            Center(child: Text('星期四内容')),
            // 星期五的内容
            Center(child: Text('星期五内容')),
            // 星期六的内容
            Center(child: Text('星期六内容')),
            // 星期日的内容
            Center(child: Text('星期日内容')),
          ],
        ),
      ),
    );
  }
}
