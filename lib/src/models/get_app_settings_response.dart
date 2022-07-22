import 'serializable.dart';
import 'visual.dart';

class GetAppSettingsResponse extends Serializable {
  final Visual visual;

  GetAppSettingsResponse(Map<String, dynamic> json) : visual = Visual(json['visual']);

  Map<String, dynamic> toJson() => {'visual': visual};
}
