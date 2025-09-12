import 'package:mikufans/component/anime_card.dart';
import 'package:mikufans/theme/theme.dart';
import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("首页"), forceMaterialTransparency: true),

      body: SizedBox(
        // margin: EdgeInsets.only(top: 5),
        child: Column(
          children: [
            TextField(
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
                    childAspectRatio: 1 / 1.8,
                  ),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return AnimeCard();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
