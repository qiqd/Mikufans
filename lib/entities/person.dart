// 人物信息实体类
class Person {
  final String name; // 中文名
  final String foreignName; // 外文名
  final String nationality; // 国籍
  final String birthPlace; // 出生地
  final DateTime? birthDate; // 出生日期
  final String zodiac; // 星座
  final List<String> graduatedFrom; // 毕业院校
  final String occupation; // 职业
  final List<String> majorWorks; // 代表作品
  final String description; // 简介

  Person({
    required this.name,
    required this.foreignName,
    required this.nationality,
    required this.birthPlace,
    this.birthDate,
    required this.zodiac,
    required this.graduatedFrom,
    required this.occupation,
    required this.majorWorks,
    required this.description,
  });

  @override
  String toString() {
    return 'Person{\n'
        '  name: $name,\n'
        '  foreignName: $foreignName,\n'
        '  nationality: $nationality,\n'
        '  birthPlace: $birthPlace,\n'
        '  birthDate: $birthDate,\n'
        '  zodiac: $zodiac,\n'
        '  graduatedFrom: $graduatedFrom,\n'
        '  occupation: $occupation,\n'
        '  majorWorks: $majorWorks,\n'
        '  description: $description\n'
        '}';
  }
}
