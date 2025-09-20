import 'dart:convert';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:mikufans/api/bangumi.dart';
import 'package:mikufans/component/anime_detail_card.dart';
import 'package:mikufans/entities/anime.dart';
import 'package:mikufans/entities/detail_item.dart';
import 'package:mikufans/entities/search_item.dart';
import 'package:mikufans/theme/theme.dart';
import 'package:mikufans/utils/aafun_parser.dart';
import 'package:video_player/video_player.dart';
import 'package:mikufans/entities/history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimePlayer extends StatefulWidget {
  final int id;
  final String title;
  final bool formHistory;
  const AnimePlayer(this.id, this.title, {super.key, this.formHistory = false});

  @override
  State<AnimePlayer> createState() => _AnimePlayerState();
}

class _AnimePlayerState extends State<AnimePlayer>
    with TickerProviderStateMixin {
  Anime? _anime;
  SharedPreferences? instance;
  VideoPlayerController? _controller;
  late String _currentVideoUrl;
  late TabController _tabController;
  TabController? _subTabController;
  List<List<DetailItem>> _detail = [];
  ChewieController? _chewieController;
  int _currentEpisode = 0;
  final int _currentLine = 0;
  bool _isInitialized = true;
  bool _isFollowed = false; // 追番状态
  List<History> historyList = [];
  void _initPlayer() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(_currentVideoUrl));
    _controller?.initialize().then((_) {
      if (mounted) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _controller!,
            autoPlay: true,
            looping: true,
            placeholder: Center(child: CircularProgressIndicator()),
          );
          _isInitialized = false;
        });
      }
    });
  }

  void _initAnimeInfo() async {
    Anime? anime = await Bangumi.getSubject(widget.id);
    if (anime == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("获取信息失败"), duration: Duration(seconds: 1)),
      );
    }
    setState(() {
      _anime = anime;
    });
  }

  void _initAnimeEpisode() async {
    setState(() {
      _isInitialized = true;
    });
    SearchItem item = await AAFunParser.parseSearch(widget.title);
    List<List<DetailItem>> detail = await AAFunParser.parseDetail(item.url!);
    setState(() {
      _detail = detail;
      _subTabController = TabController(
        length: detail.length,
        vsync: this,
        initialIndex: 0,
      );
    });
    String? videoUrl = await AAFunParser.parsePlayer(detail[0][0].url!);
    if (videoUrl == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('无法获取播放地址'), duration: Duration(seconds: 1)),
      );
      return;
    }
    setState(() {
      _currentVideoUrl = videoUrl!.replaceFirst("http://", "https://");
    });
    _initPlayer();
  }

  void episodeChange(int index, int line) async {
    var lineLength = _detail.map((e) => e.length).toList();
    if (lineLength.any((e) => e < line)) return;
    if (_isInitialized) return;
    setState(() {
      _isInitialized = true;
      _currentEpisode = index;
    });
    String? videoUrl = await AAFunParser.parsePlayer(
      _detail[_currentLine][index].url!,
    );
    if (videoUrl == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('无法获取播放地址'), duration: Duration(seconds: 1)),
      );
      return;
    }
    setState(() {
      _currentVideoUrl = videoUrl!.replaceFirst("http://", "https://");
    });
    _initPlayer();
  }

  // 加载追番状态
  void _loadLocalHistory() async {
    instance = await SharedPreferences.getInstance();
    var history = instance?.get("loclalHistory") as String?;
    if (history != null) {
      historyList = json.decode(history) as List<History>;
    }
    for (var item in historyList) {
      if (item.id == widget.id.toString()) {
        setState(() {
          _isFollowed = item.isFollow;
        });
      }
    }
  }

  // 切换追番状态
  void _toggleFollow() {
    setState(() {
      _isFollowed = !_isFollowed;
    });

    // 保存历史记录
    _saveHistory();
  }

  // 保存或更新历史记录
  void _saveHistory() async {
    if (_anime == null) return;
    final historyId = _anime!.id.toString();
    var first = historyList
        .map((item) {
          if (item.id == historyId) {
            return item;
          }
        })
        .toList()
        .first;
    if (first != null) {
      first.dateTime = DateTime.now();
    } else {
      // 创建新的历史记录
      first = History(
        id: historyId,
        isFollow: _isFollowed,
        name: _anime!.nameCn ?? _anime!.name ?? "未知番剧",
        image: _anime!.image,
        time: _controller?.value.position ?? Duration(seconds: 0, minutes: 0),
        dateTime: DateTime.now(),
      );
    }

    historyList.add(first);
    // 将 historyList 序列化为 JSON 字符串并保存
    List<Map<String, dynamic>> jsonList = historyList
        .map((history) => history.toJson())
        .toList();
    String jsonString = json.encode(jsonList);
    await instance?.setString("localHistory", jsonString);
  }

  @override
  void initState() {
    super.initState();
    if (widget.formHistory) {
      _loadLocalHistory();
    }
    _initAnimeInfo();
    _initAnimeEpisode();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // 页面销毁时保存历史记录
    _saveHistory();
    _subTabController?.dispose();
    _tabController.dispose();
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.navigate_before),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _isInitialized
                  ? Center(child: CircularProgressIndicator())
                  : Chewie(controller: _chewieController!),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                TabBar(
                  isScrollable: false,
                  controller: _tabController,
                  tabs: [
                    Tab(text: "简介"),
                    Tab(text: "剧集"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      Center(
                        child: _anime == null
                            ? CircularProgressIndicator()
                            : Stack(
                                children: [
                                  ListView(
                                    children: [AnimeDetailCard(anime: _anime!)],
                                  ),
                                  // 添加追番按钮
                                  Positioned(
                                    right: 16,
                                    top: 16,
                                    child: ElevatedButton(
                                      onPressed: _toggleFollow,
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.resolveWith<
                                              Color
                                            >((Set<WidgetState> states) {
                                              return _isFollowed
                                                  ? GlobalTheme.primaryColor
                                                  : Colors.transparent;
                                            }),
                                        foregroundColor:
                                            WidgetStateProperty.resolveWith<
                                              Color
                                            >((Set<WidgetState> states) {
                                              return _isFollowed
                                                  ? Colors.white
                                                  : GlobalTheme.primaryColor;
                                            }),
                                        side:
                                            WidgetStateProperty.resolveWith<
                                              BorderSide?
                                            >((Set<WidgetState> states) {
                                              if (!_isFollowed) {
                                                return BorderSide(
                                                  color:
                                                      GlobalTheme.primaryColor,
                                                );
                                              }
                                              return null;
                                            }),
                                        minimumSize: WidgetStateProperty.all(
                                          Size(100, 40),
                                        ),
                                        shape:
                                            WidgetStateProperty.all<
                                              RoundedRectangleBorder
                                            >(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                      ),
                                      child: Text(_isFollowed ? "已追番" : "追番"),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      Visibility(
                        visible: _detail.isNotEmpty,
                        replacement: Center(child: CircularProgressIndicator()),
                        child: Column(
                          children: [
                            SizedBox(
                              child: _subTabController == null
                                  ? Container()
                                  : TabBar(
                                      dividerHeight: 0,
                                      tabAlignment: TabAlignment.center,
                                      padding: EdgeInsets.all(0),
                                      indicatorPadding: EdgeInsets.all(10),
                                      controller: _subTabController,
                                      tabs: List.generate(_detail.length, (
                                        index,
                                      ) {
                                        return Tab(text: "线路${index + 1}");
                                      }),
                                    ),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _subTabController,
                                children: List.generate(_detail.length, (line) {
                                  return GridView.builder(
                                    itemCount: _detail.isEmpty
                                        ? 0
                                        : _detail[line].length,
                                    padding: EdgeInsets.all(5),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 5,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                        ),
                                    itemBuilder: (context, index) {
                                      //剧集部分
                                      return _currentEpisode != index
                                          ? OutlinedButton(
                                              style: ButtonStyle(
                                                padding:
                                                    WidgetStateProperty.all(
                                                      EdgeInsets.all(0),
                                                    ),
                                                foregroundColor:
                                                    WidgetStateProperty.all(
                                                      GlobalTheme.primaryColor,
                                                    ),
                                                shape: WidgetStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (_isInitialized) return;
                                                setState(() {
                                                  episodeChange(index, line);
                                                });
                                              },
                                              child: Text(
                                                (index + 1).toString(),
                                              ),
                                            )
                                          : ElevatedButton(
                                              style: ButtonStyle(
                                                padding:
                                                    WidgetStateProperty.all(
                                                      EdgeInsets.all(0),
                                                    ),

                                                shape: WidgetStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                      GlobalTheme.primaryColor,
                                                    ),
                                                foregroundColor:
                                                    WidgetStateProperty.all(
                                                      Colors.white,
                                                    ),
                                              ),
                                              onPressed: () {},
                                              child: Text(
                                                (index + 1).toString(),
                                              ),
                                            );
                                    },
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
