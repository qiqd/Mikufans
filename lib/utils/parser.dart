// 使用html包的解析器
import 'dart:developer';

import 'package:mikufans/entities/person.dart';
import 'dart:convert';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

class PersonHtmlParser {
  /// 解析HTML内容，提取人物信息
  static Person parsePersonFromHtml(String htmlContent) {
    // 解析HTML文档
    final document = html_parser.parse(htmlContent);

    // 从script标签中提取PAGE_DATA
    final pageData = _extractPageData(document);

    if (pageData == null) {
      throw Exception('无法从HTML中提取PAGE_DATA');
    }

    // 解析基本信息
    final card = pageData['card'] as Map<String, dynamic>;
    final left = card['left'] as List<dynamic>;
    final right = card['right'] as List<dynamic>;

    // 初始化变量
    String name = '';
    String foreignName = '';
    String nationality = '';
    String birthPlace = '';
    DateTime? birthDate;
    String zodiac = '';
    List<String> graduatedFrom = [];
    String occupation = '';
    List<String> majorWorks = [];

    // 解析左侧信息
    for (var item in left) {
      final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
      final key = itemMap['key'] as String?;
      final data = itemMap['data'] as List<dynamic>?;

      if (key == null || data == null || data.isEmpty) continue;

      switch (key) {
        case 'name':
          name = _extractText(data[0]);
          break;
        case 'foreignName':
          foreignName = _extractText(data[0]);
          break;
        case 'nationality':
          nationality = _extractText(data[0]);
          break;
        case 'birthPlace':
          birthPlace = _extractText(data[0]);
          break;
        case 'dateOfBirth':
          birthDate = _parseDate(data[0]);
          break;
        case 'zodiac':
          zodiac = _extractText(data[0]);
          break;
        case 'graduatedFrom':
          graduatedFrom = _extractList(data);
          break;
      }
    }

    // 解析右侧信息
    for (var item in right) {
      final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
      final key = itemMap['key'] as String?;
      final data = itemMap['data'] as List<dynamic>?;

      if (key == null || data == null || data.isEmpty) continue;

      switch (key) {
        case 'occupation':
          occupation = _extractText(data[0]);
          break;
        case 'majorWorks':
          majorWorks = _extractList(data);
          break;
      }
    }

    // 解析简介信息
    final description = pageData['description'] as String? ?? '';

    return Person(
      name: name,
      foreignName: foreignName,
      nationality: nationality,
      birthPlace: birthPlace,
      birthDate: birthDate,
      zodiac: zodiac,
      graduatedFrom: graduatedFrom,
      occupation: occupation,
      majorWorks: majorWorks,
      description: description,
    );
  }

  /// 从HTML文档中提取PAGE_DATA
  static Map<String, dynamic>? _extractPageData(Document document) {
    try {
      // 查找包含PAGE_DATA的script标签
      final scriptElements = document.querySelectorAll('script');

      for (var script in scriptElements) {
        final text = script.text;
        if (text.contains('window.PAGE_DATA')) {
          // 使用正则表达式提取JSON部分
          log("");

          final RegExp pattern = RegExp(
            r'window\.PAGE_DATA\s*=\s*(\{.*?\})',
            dotAll: true,
            multiLine: true,
          );
          final match = pattern.firstMatch(text);
          log("match:$match");
          if (match != null && match.groupCount >= 1) {
            final jsonString = match.group(1)!;
            log("jsonString:$jsonString");
            return null;
            // 解析JSON
            return json.decode(jsonString) as Map<String, dynamic>;
          }
        }
      }

      return null;
    } catch (e) {
      log('解析PAGE_DATA时出错: $e');
      return null;
    }
  }

  /// 提取文本内容
  static String _extractText(dynamic dataItem) {
    if (dataItem == null) return '';

    try {
      final itemMap = dataItem as Map<String, dynamic>;
      final dataType = itemMap['dataType'] as String?;

      if (dataType == 'text') {
        final textList = itemMap['text'] as List<dynamic>;
        if (textList.isNotEmpty) {
          final firstText = textList[0] as Map<String, dynamic>;
          return firstText['text'] as String? ?? '';
        }
      } else if (dataType == 'lemma' || dataType == 'enum') {
        final textList = itemMap['text'] as List<dynamic>;
        if (textList.isNotEmpty) {
          final firstText = textList[0] as Map<String, dynamic>;
          return firstText['text'] as String? ?? '';
        }
      } else if (dataType == 'dateTime') {
        final textList = itemMap['text'] as List<dynamic>;
        if (textList.isNotEmpty) {
          final firstText = textList[0] as Map<String, dynamic>;
          return firstText['text'] as String? ?? '';
        }
      }

      return '';
    } catch (e) {
      log('提取文本时出错: $e');
      return '';
    }
  }

  /// 解析日期
  static DateTime? _parseDate(dynamic dataItem) {
    if (dataItem == null) return null;

    try {
      final itemMap = dataItem as Map<String, dynamic>;
      final dataType = itemMap['dataType'] as String?;

      if (dataType == 'dateTime') {
        final value = itemMap['value'] as Map<String, dynamic>?;
        if (value != null) {
          final year = value['year'] as String?;
          final month = value['month'] as String?;
          final day = value['day'] as String?;

          if (year != null && month != null && day != null) {
            return DateTime(int.parse(year), int.parse(month), int.parse(day));
          }
        }
      }
      return null;
    } catch (e) {
      log('解析日期时出错: $e');
      return null;
    }
  }

  /// 提取列表内容
  static List<String> _extractList(List<dynamic> dataList) {
    final result = <String>[];

    for (var item in dataList) {
      final text = _extractText(item);
      if (text.isNotEmpty) {
        result.add(text);
      }
    }

    return result;
  }

  /// 备用方法：直接从HTML元素中提取基本信息
  static Person? parseBasicInfoFromHtmlElements(String htmlContent) {
    try {
      final document = html_parser.parse(htmlContent);

      // 提取基本信息项
      String name = '';
      String foreignName = '';
      String nationality = '';
      String birthPlace = '';
      String occupation = '';
      List<String> majorWorks = [];

      // 从基本信息表格中提取
      final basicInfoItems = document.querySelectorAll('.basicInfoItem_m1yjL');

      for (var item in basicInfoItems) {
        final dt = item.querySelector('dt');
        final dd = item.querySelector('dd');

        if (dt != null && dd != null) {
          final key = dt.text.trim();
          final value = dd.text.trim();

          switch (key) {
            case '中文名':
              name = value;
              break;
            case '外文名':
              foreignName = value;
              break;
            case '国    籍':
              nationality = value;
              break;
            case '出生地':
              birthPlace = value;
              break;
            case '职    业':
              occupation = value;
              break;
            case '代表作品':
              // 代表作品可能包含多个，用顿号或逗号分隔
              majorWorks = value
                  .split(RegExp(r'[、，,]'))
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              break;
          }
        }
      }

      // 提取简介
      final summaryElement = document.querySelector('.lemmaSummary_vhQwk');
      final description = summaryElement?.text.trim() ?? '';

      return Person(
        name: name,
        foreignName: foreignName,
        nationality: nationality,
        birthPlace: birthPlace,
        birthDate: null, // 从HTML元素中较难准确提取日期
        zodiac: '', // 从HTML元素中较难准确提取星座
        graduatedFrom: [], // 从HTML元素中较难准确提取毕业院校
        occupation: occupation,
        majorWorks: majorWorks,
        description: description,
      );
    } catch (e) {
      log('从HTML元素中提取基本信息时出错: $e');
      return null;
    }
  }
}
