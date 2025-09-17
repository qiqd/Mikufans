import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mikufans/entities/anime.dart';
import 'package:mikufans/entities/weekly.dart';

class Bangumi {
  static const String _baseUrl = "https://api.bgm.tv";
  // static Future<
  static Future<List<Weekly>> getWeekly() async {
    log("获取周更表");
    try {
      final response = await http.get(Uri.parse("$_baseUrl/calendar"));
      final jsonResponse = json.decode(response.body);
      final dataList = jsonResponse as List;
      final List<Weekly> timeTable = dataList
          .map((item) => Weekly.fromJson(item as Map<String, dynamic>))
          .toList();
      return timeTable;
    } catch (e) {
      log("请求失败: $e");
      return [];
    }
  }

  static Future<List<Anime>> getSearch(String keyword) async {
    log("搜索关键字: $keyword");
    var body = <String, dynamic>{};
    body["keyword"] = keyword;
    body["sort"] = "match";
    body["filter"] = {
      "type": [2],
    };
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/v0/search/subjects"),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode >= 400) {
        throw Exception("请求失败,状态码:${response.statusCode}");
      }
      final jsonResponse = json.decode(response.body);
      final dataList = jsonResponse as Map<String, dynamic>;
      final List<Anime> animeList = (dataList["data"] as List)
          .map((item) => Anime.fromJson(item as Map<String, dynamic>))
          .toList();
      return animeList;
    } catch (error) {
      log("请求失败: $error");
      return [];
    }
  }

  static Future<Anime?> getSubject(int subjectId) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/v0/subjects/$subjectId"),
      );
      if (response.statusCode != 200) {
        throw Exception("请求失败: ${response.statusCode}");
      }
      final jsonResponse = json.decode(response.body);
      return Anime.fromJson(jsonResponse);
    } catch (error) {
      log("请求失败: $error");
      return null;
    }
  }
}
