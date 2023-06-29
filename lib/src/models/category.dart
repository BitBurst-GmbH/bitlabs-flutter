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

  Category.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        iconUrl = json['icon_url'],
        iconName = json['icon_name'],
        nameInternal = json['name_internal'];

  Map<String, String> toJson() => {
        'name': name,
        'icon_url': iconUrl,
        'icon_name': iconName,
        'name_internal': nameInternal
      };
}
