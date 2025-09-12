import 'package:mikufans/pages/index.dart';
import 'package:mikufans/pages/love.dart';
import 'package:mikufans/pages/me.dart';
import 'package:mikufans/pages/weekly.dart';
import 'package:flutter/material.dart';
import 'package:mikufans/theme/theme.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final Map<String, Widget Function(BuildContext)> routes =
      const <String, WidgetBuilder>{};
  final List<BottomNavigationBarItem> bottomNav = const [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '首页'),
    BottomNavigationBarItem(
      icon: Icon(Icons.calendar_month_rounded),
      label: '周更表',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.heat_pump_rounded), label: '追番'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
  ];
  final List<Widget> pages = const [Index(), Weekly(), Love(), Me()];
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // routes: {
      //   '/': (context) => const MyApp(),
      // },
      // debugShowMaterialGrid: true,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(title: Text(widget.bottomNav[currentIndex].label!)),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: widget.pages[currentIndex],
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: widget.bottomNav,
          selectedItemColor: GlobalTheme.primaryColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) {
            // print("Tapped on ${widget.bottomNav[index].label}");
            setState(() {
              if (index == currentIndex) return;
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
