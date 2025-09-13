import 'package:mikufans/api/bangumi.dart';
import 'package:mikufans/component/anime_card.dart';
import 'package:mikufans/entities/anime.dart';
import 'package:mikufans/theme/theme.dart';
import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> with AutomaticKeepAliveClientMixin {
  List<Anime> _animes = [];
  void _performSearch(String keyword) async {
    if (keyword.isNotEmpty) {
      List<Anime> results = await Bangumi.getSearch(keyword);
      setState(() {
        _animes = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text("首页"), forceMaterialTransparency: true),

      body: SizedBox(
        // margin: EdgeInsets.only(top: 5),
        child: Column(
          children: [
            TextField(
              onSubmitted: (value) => _performSearch(value),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: '请善用搜索',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: GlobalTheme.primaryColor),
                ),
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3列
                    crossAxisSpacing: 5.0, // 水平间距
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 1 / 1.6,
                  ),
                  itemCount: _animes.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: AnimeCard(_animes[index]),
                      onTap: () => Navigator.pushNamed(context, '/player'),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
