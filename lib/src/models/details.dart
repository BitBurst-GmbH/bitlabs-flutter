import 'category.dart';

class Details {
  final Category category;

  Details({required this.category});

  Details.fromJson(Map<String, dynamic> json)
      : category = Category.fromJson(json['category']);

  Map<String, Category> toJson() => {'category': category};
}
