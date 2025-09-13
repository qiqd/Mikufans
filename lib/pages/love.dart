import 'package:mikufans/component/anime_card.dart';
import 'package:flutter/material.dart';
import 'package:mikufans/entities/anime.dart';

class Love extends StatefulWidget {
  const Love({super.key});

  @override
  State<Love> createState() => _LoveState();
}

class _LoveState extends State<Love> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('追番'), forceMaterialTransparency: true),
      body: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3列
            crossAxisSpacing: 5.0, // 水平间距
            mainAxisSpacing: 5.0,
            childAspectRatio: 1 / 1.8,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            return Text("data");
          },
        ),
      ),
    );
  }
}
