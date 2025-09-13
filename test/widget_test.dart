// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mikufans/entities/person.dart';
import 'package:mikufans/utils/parser.dart';

void main() {
  group("api test", () {
    test("profile api test", () async {
      final response = await http.get(
        Uri.parse(
          'https://baike.baidu.com/item/%E5%A4%A7%E6%B2%B3%E5%86%85%E4%B8%80%E6%A5%BC',
        ),
      );
      print("body${response.body}");
      Person person = PersonHtmlParser.parsePersonFromHtml(response.body);
      print(person.toString());
    });
  });
}
