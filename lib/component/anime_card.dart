import 'package:mikufans/theme/theme.dart';
import 'package:flutter/material.dart';

class AnimeCard extends StatelessWidget {
  const AnimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amberAccent,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            child: FadeInImage(
              placeholder: AssetImage('lib/static/loading.gif'),
              image: NetworkImage(
                "https://bkimg.cdn.bcebos.com/pic/c75c10385343fbf2896bb4c8b17eca8064388f91?x-bce-process=image/format,f_auto/watermark,image_d2F0ZXIvYmFpa2UyNzI,g_7,xp_5,yp_5,P_20/resize,m_lfit,limit_1,h_1080",
              ),
            ),
          ),
          Text(
            "更新至20集/每周4点更新",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, color: GlobalTheme.primaryColor),
          ),
          Text("JOJO的奇妙冒险"),
        ],
      ),
    );
  }
}

class AnimeLoveCard extends StatelessWidget {
  const AnimeLoveCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
            child: Column(
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
                  "追番时间: 2023-01-01",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
