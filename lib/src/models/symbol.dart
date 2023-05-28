import 'serializable.dart';

class Symbol extends Serializable {
  final String content;
  final bool isImage;

  Symbol(Map<String, dynamic> json)
      : content = json['content'],
        isImage = json['is_image'];

  Map<String, dynamic> toJson() => {
        'content': content,
        'is_image': isImage,
      };
}
