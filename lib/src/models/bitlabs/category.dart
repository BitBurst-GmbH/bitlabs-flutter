import '../../utils/extensions.dart';

class Category {
  final String name;
  final String iconUrl;
  final String iconName;
  final String nameInternal;

  Category(
      {required this.name,
      required this.iconUrl,
      required this.iconName,
      required this.nameInternal});

  Category.fromJson(Map json)
      : name = json.getValue('name'),
        iconUrl = json.getValue('iconUrl'),
        iconName = json.getValue('iconName'),
        nameInternal = json.getValue('nameInternal');

  Map<String, String> toJson() => {
        'name': name,
        'iconUrl': iconUrl,
        'iconName': iconName,
        'nameInternal': nameInternal
      };
}
