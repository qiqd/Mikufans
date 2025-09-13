import 'package:cached_network_image/cached_network_image.dart';
import 'package:mikufans/entities/anime.dart';
import 'package:mikufans/theme/theme.dart';
import 'package:flutter/material.dart';

class AnimeCard extends StatelessWidget {
  final Anime _anime;
  const AnimeCard(this._anime, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.amberAccent,
        border: BoxBorder.all(color: Colors.grey.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            child: CachedNetworkImage(
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
              // fadeInDuration: Duration.zero, // 淡入时间为0
              // fadeOutDuration: Duration.zero, // 淡出时间为0
              memCacheWidth: 300, // 内存缓存宽度
              memCacheHeight: 400, // 内存缓存高度
              placeholder: (context, url) => Image.asset(
                'lib/static/loading.gif',
                width: double.infinity,
                height: 170,
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              imageUrl: _anime.image,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                Visibility(
                  visible: _anime.eps != null,
                  child: Text(
                    "更新至${_anime.eps}集",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: GlobalTheme.primaryColor,
                    ),
                  ),
                ),
                Text(
                  _anime.nameCn ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimeLoveCard extends StatefulWidget {
  const AnimeLoveCard({super.key});

  @override
  State<AnimeLoveCard> createState() => _AnimeLoveCardState();
}

class _AnimeLoveCardState extends State<AnimeLoveCard> {
  bool isLove = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          SizedBox(
            width: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: FadeInImage(
                // // color: Colors.amber,
                // width: 120,
                placeholder: AssetImage('lib/static/loading.gif'),
                image: NetworkImage(
                  "https://bkimg.cdn.bcebos.com/pic/c75c10385343fbf2896bb4c8b17eca8064388f91?x-bce-process=image/format,f_auto/watermark,image_d2F0ZXIvYmFpa2UyNzI,g_7,xp_5,yp_5,P_20/resize,m_lfit,limit_1,h_1080",
                ),
              ),
            ),
          ),
          SizedBox(
            height: 160,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "JOJO的奇妙冒险",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "更新至20集/每周4点更新",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  "导演: 宫崎骏,张三",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  "演员: 张三,李四,王五",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Visibility(
                  visible: isLove,
                  child: Text(
                    "追番时间: 2023-01-01",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
                Text(
                  "最近观看时间: 2023-01-01",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
