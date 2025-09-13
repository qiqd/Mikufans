import 'package:mikufans/pages/index.dart';
import 'package:mikufans/pages/love.dart';
import 'package:mikufans/pages/me.dart';
import 'package:mikufans/pages/player.dart';
import 'package:mikufans/pages/schedule.dart';
import 'package:flutter/material.dart';
import 'package:mikufans/theme/theme.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final List<BottomNavigationBarItem> bottomNav = const [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '首页'),
    BottomNavigationBarItem(
      icon: Icon(Icons.calendar_month_rounded),
      label: '周更表',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.heat_pump_rounded), label: '追番'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
  ];
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  // 使用late关键字延迟初始化
  late final List<Widget> _pages = [
    const Index(),
    const Schedule(),
    const Love(),
    const Me(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: BottomNavigationBar(
          items: widget.bottomNav,
          selectedItemColor: GlobalTheme.primaryColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
      routes: {'/player': (context) => const Player()},
    );
  }
}
