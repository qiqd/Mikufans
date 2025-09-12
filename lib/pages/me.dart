import 'package:flutter/material.dart';

class Me extends StatefulWidget {
  const Me({super.key});

  @override
  State<Me> createState() => _MeState();
}

class _MeState extends State<Me> {
  // 定义一个列表
  final List<Map<String, dynamic>> list = [
    {'icon': Icons.history, 'title': '观看记录'},
    // {'icon': Icons.favorite, 'title': '我的收藏'},
    {'icon': Icons.info_outline, 'title': '关于'},
    // {'icon': Icons.help, 'title': '帮助'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('我的'), forceMaterialTransparency: true),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(list[index]['icon']),
            title: Text(list[index]['title']),
          );
        },
      ),
    );
  }
}
