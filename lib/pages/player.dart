import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:mikufans/component/anime_card.dart';
import 'package:mikufans/theme/theme.dart';
import 'package:video_player/video_player.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  late TabController _tabController;
  int episode = 0;
  var items = List.generate(13, (index) {
    return index;
  });
  ChewieController? _chewieController; // 使用可空类型

  String title = "jojo part 1";

  @override
  void initState() {
    super.initState();

    // 创建视频控制器
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse("https://www.w3schools.com/html/movie.mp4"),
    );

    // 等待视频控制器初始化完成后再创建 Chewie 控制器
    _videoPlayerController.initialize().then((_) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: false,
          showControls: true,
          allowFullScreen: true,
          allowMuting: true,
          autoInitialize: true,

          // 性能优化参数
          materialProgressColors: ChewieProgressColors(
            playedColor: GlobalTheme.primaryColor,
            handleColor: GlobalTheme.primaryColor,
            backgroundColor: Colors.grey,
            bufferedColor: Colors.lightGreen,
          ),

          // 禁用一些不必要的动画效果以提高性能
          showControlsOnInitialize: false,
          hideControlsTimer: const Duration(seconds: 3),

          // 使用简单的UI以提高性能
          useRootNavigator: true,

          // 禁用一些额外的功能以提高性能
          allowPlaybackSpeedChanging: false,
          // allowFullScreen: true,

          // 设置合适的宽高比
          aspectRatio: 16 / 9,

          // 设置错误处理
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                "加载视频时出错: $errorMessage",
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        );
      });
    });

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
        leading: InkWell(
          borderRadius: BorderRadius.circular(100),
          child: Icon(Icons.navigate_before),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 使用RepaintBoundary隔离视频播放区域以提高性能
          RepaintBoundary(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _chewieController == null
                  ? Container(color: Colors.black)
                  : Chewie(controller: _chewieController!),
            ),
          ),
          SizedBox(
            height: 48,
            child: TabBar(
              controller: _tabController,
              labelColor: GlobalTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: GlobalTheme.primaryColor,
              tabs: [
                Tab(text: "简介"),
                Tab(text: "剧集"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: KeepAliveWrapper(child: AnimeLoveCard()),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: KeepAliveWrapper(
                    child: EpisodeGrid(
                      episode: episode,
                      onEpisodeSelected: (index) {
                        setState(() {
                          episode = index;
                        });
                      },
                    ),
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

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({super.key, required this.child});

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class EpisodeGrid extends StatefulWidget {
  final int episode;
  final Function(int) onEpisodeSelected;

  const EpisodeGrid({
    super.key,
    required this.episode,
    required this.onEpisodeSelected,
  });

  @override
  State<EpisodeGrid> createState() => _EpisodeGridState();
}

class _EpisodeGridState extends State<EpisodeGrid>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GridView.builder(
      itemCount: 13,
      // padding: EdgeInsets.all(5),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
      // 修改 GridView.builder 中的 itemBuilder
      itemBuilder: (context, index) {
        return OutlinedButton(
          onPressed: () => widget.onEpisodeSelected(index),
          style: ButtonStyle(
            padding: WidgetStateProperty.all(
              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
            side: WidgetStateProperty.all(
              BorderSide(
                color: index == widget.episode
                    ? GlobalTheme.primaryColor
                    : Colors.grey[300]!,
                width: 1,
              ),
            ),
          ),
          child: Text(
            "第${index + 1}集",
            style: TextStyle(
              color: index == widget.episode
                  ? GlobalTheme.primaryColor
                  : Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
