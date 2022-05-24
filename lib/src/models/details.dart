import 'category.dart';

class Details {
  final Category category;

  Details(Map<String, dynamic> json) : category = Category(json['category']);

  Map<String, Category> toJson() => {'category': category};
}
