import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:mikufans/entities/aafun_data.dart';
import 'package:mikufans/entities/detail_item.dart';
import 'package:mikufans/entities/play_data.dart';
import 'package:mikufans/entities/search_item.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/cbc.dart';
import 'package:string_similarity/string_similarity.dart';

class AAFunParser {
  static const _baseurl = "https://www.aafun.cc";

  static Future<String?> parsePlayer(String url) async {
    final result = await _parsePlayerData(url);
    if (result == null) {
      return null;
    }
    final aaFunData = await _parseAAFunData(result.url!, result.currentUrl!);
    // 解密URL
    final decryptedUrl = AAFunParser._decryptAES(
      aaFunData.encryptedUrl,
      aaFunData.sessionKey,
    );
    return decryptedUrl;
  }

  static Future<List<List<DetailItem>>> parseDetail(String url) async {
    // final detailUrl = "/feng-n$url";
    List<List<DetailItem>> episodes = [];
    final response = await http.get(Uri.parse(_baseurl + url));
    _validateResponse(response);
    final document = html_parser.parse(response.body);
    final List<Element> divs = document.querySelectorAll("div.hl-tabs-box ");
    for (int i = 0; i < divs.length; i++) {
      final a = divs[i].querySelectorAll("li.hl-col-xs-4 a");
      List<DetailItem> details = a
          .map(
            (item) =>
                DetailItem(title: item.text, url: item.attributes["href"]),
          )
          .toList();
      episodes.add(details);
    }
    return episodes;
  }

  static Future<SearchItem> parseSearch(String keyword) async {
    final searchUrl = "/feng-s.html?wd=$keyword&submit=";
    final response = await http.get(Uri.parse(_baseurl + searchUrl));
    _validateResponse(response);

    final document = html_parser.parse(response.body);
    final List<Element> searchItem = document.querySelectorAll(
      "li.hl-list-item",
    );
    final items = searchItem.map((li) {
      final a = li.querySelector("div.hl-item-div a");
      return SearchItem(
        title: a?.attributes['title'],
        url: a?.attributes['href'],
      );
    }).toList();
    return findBestMatchBySimilarity(items, keyword);
  }

  /// 从指定URL获取HTML页面并解析player_aaaa变量中的url和url_next属性
  static Future<PlayerData?> _parsePlayerData(String playerUrl) async {
    final fullUrl = _baseurl + playerUrl;
    try {
      // 发送HTTP请求获取HTML内容
      final response = await http.get(Uri.parse(fullUrl));

      if (response.statusCode != 200) {
        log('Failed to load page: ${response.statusCode}');
        return null;
      }
      // 解析HTML文档
      final document = html_parser.parse(response.body);
      // 查找包含player_aaaa变量的script标签
      final scriptElements = document.querySelectorAll('script');
      for (final script in scriptElements) {
        final scriptContent = script.text;
        // 查找包含player_aaaa变量定义的部分
        if (scriptContent.contains('var player_aaaa')) {
          final match = scriptContent.substring(scriptContent.indexOf("{"));

          final jsonString = match;
          // 解析JSON对象
          final playerData = json.decode(jsonString) as Map<String, dynamic>;

          // 提取url和url_next并进行URL解码
          final url = playerData['url'] as String?;
          final urlNext = playerData['url_next'] as String?;

          // URL解码
          final decodedUrl = url != null ? Uri.decodeComponent(url) : null;
          final decodedUrlNext = urlNext != null
              ? Uri.decodeComponent(urlNext)
              : null;
          return PlayerData(
            url: decodedUrl,
            urlNext: decodedUrlNext,
            currentUrl: playerUrl,
          );
        }
      }
    } catch (e) {
      log('Error parsing player data: $e');
    }
    return null;
  }

  /// 从指定URL获取HTML页面并解析encryptedUrl和sessionKey属性
  static Future<AAFunData> _parseAAFunData(
    String url,
    String refererUrl,
  ) async {
    final fullUrl = "$_baseurl/player/?url=$url";
    try {
      // 发送HTTP请求获取HTML内容
      final header = <String, String>{};
      header["Host"] = 'www.aafun.cc';
      header["Referer"] = 'https://www.aafun.cc$refererUrl';
      log("fullUrl:$fullUrl");
      log("header:$header");
      final response = await http.get(Uri.parse(fullUrl), headers: header);
      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }
      // 解析HTML文档
      final document = html_parser.parse(response.body);
      // 查找包含_decryptAES函数的script标签
      final scriptElements = document.querySelectorAll('script');
      String? encryptedUrl;
      String? sessionKey;
      for (final script in scriptElements) {
        final scriptContent = script.text;
        // 查找包含encryptedUrl定义的部分
        if (scriptContent.contains('const encryptedUrl')) {
          // 使用正则表达式提取encryptedUrl的值
          final encryptedUrlRegExp = RegExp(
            r'const\s+encryptedUrl\s*=\s*"([^"]+)"',
          );
          final encryptedUrlMatch = encryptedUrlRegExp.firstMatch(
            scriptContent,
          );
          if (encryptedUrlMatch != null) {
            encryptedUrl = encryptedUrlMatch.group(1);
          }
        }

        // 查找包含sessionKey定义的部分
        if (scriptContent.contains('const sessionKey')) {
          // 使用正则表达式提取sessionKey的值
          final sessionKeyRegExp = RegExp(
            r'const\s+sessionKey\s*=\s*"([^"]+)"',
          );
          final sessionKeyMatch = sessionKeyRegExp.firstMatch(scriptContent);
          if (sessionKeyMatch != null) {
            sessionKey = sessionKeyMatch.group(1);
          }
        }
      }
      if (encryptedUrl != null && sessionKey != null) {
        return AAFunData(encryptedUrl: encryptedUrl, sessionKey: sessionKey);
      } else {
        throw Exception('encryptedUrl or sessionKey not found in the page');
      }
    } catch (e) {
      throw Exception('Error parsing AAFun data: $e');
    }
  }

  /// Dart版本的_decryptAES函数，与JavaScript版本功能相同
  static String _decryptAES(String ciphertext, String key) {
    try {
      // 将密文从Base64解码
      final rawBytes = base64Decode(ciphertext);

      // 提取IV（前16字节）
      final ivBytes = Uint8List.view(rawBytes.buffer, 0, 16);

      // 提取加密数据（剩余部分）
      final encryptedBytes = Uint8List.view(rawBytes.buffer, 16);

      // 创建AES解密器
      final aes = CBCBlockCipher(AESFastEngine())
        ..init(
          false,
          ParametersWithIV(
            KeyParameter(Uint8List.fromList(utf8.encode(key))),
            ivBytes,
          ),
        );

      // PKCS7填充解密
      final paddedPlainText = _decryptBlocks(aes, encryptedBytes);

      // 移除PKCS7填充
      final plainText = _removePKCS7Padding(paddedPlainText);

      return utf8.decode(plainText);
    } catch (e) {
      log('URL解密失败: $e');
      return '';
    }
  }

  /// 解密数据块
  static Uint8List _decryptBlocks(CBCBlockCipher cipher, Uint8List encrypted) {
    final blockSize = cipher.blockSize;
    final output = Uint8List(encrypted.length);

    for (var offset = 0; offset < encrypted.length; offset += blockSize) {
      cipher.processBlock(encrypted, offset, output, offset);
    }

    return output;
  }

  /// 移除PKCS7填充
  static Uint8List _removePKCS7Padding(Uint8List data) {
    if (data.isEmpty) return data;

    final paddingLength = data[data.length - 1];
    if (paddingLength > 16 || paddingLength == 0) return data;

    // 验证填充是否正确
    for (var i = data.length - paddingLength; i < data.length; i++) {
      if (data[i] != paddingLength) {
        // 填充不正确，返回原始数据
        return data;
      }
    }

    return Uint8List.view(data.buffer, 0, data.length - paddingLength);
  }

  static void _validateResponse(http.Response res) {
    if (res.statusCode != 200) {
      throw Exception('Failed to load page: ${res.statusCode}');
    }
  }

  /// 根据关键词相似度从搜索结果中找出最匹配的项目
  static SearchItem findBestMatchBySimilarity(
    List<SearchItem> items,
    String keyword,
  ) {
    if (items.isEmpty) return SearchItem();

    // 过滤掉标题为空的项目
    final validItems = items
        .where((item) => item.title != null && item.title!.isNotEmpty)
        .toList();
    if (validItems.isEmpty) return SearchItem();

    // 使用 string_similarity 库计算每个项目的相似度
    final bestMatch = StringSimilarity.findBestMatch(
      keyword.toLowerCase(),
      validItems.map((item) => item.title!.toLowerCase()).toList(),
    );

    // 获取最佳匹配项的索引
    final bestMatchIndex = bestMatch.bestMatchIndex;

    // 返回相似度最高的项目
    return validItems[bestMatchIndex];
  }

  /// 根据关键词相似度从搜索结果中找出最匹配的项目（带相似度阈值）
  static SearchItem? _findBestMatchBySimilarityWithThreshold(
    List<SearchItem> items,
    String keyword,
    double threshold,
  ) {
    if (items.isEmpty) return null;

    // 过滤掉标题为空的项目
    final validItems = items
        .where((item) => item.title != null && item.title!.isNotEmpty)
        .toList();
    if (validItems.isEmpty) return null;

    // 使用 string_similarity 库计算每个项目的相似度
    final bestMatch = StringSimilarity.findBestMatch(
      keyword.toLowerCase(),
      validItems.map((item) => item.title!.toLowerCase()).toList(),
    );
    // 检查最佳匹配的相似度是否超过阈值
    if (bestMatch.bestMatch.rating! >= threshold) {
      final bestMatchIndex = bestMatch.bestMatchIndex;
      return validItems[bestMatchIndex];
    }
    // 如果没有项目超过阈值，返回 null
    return null;
  }
}
