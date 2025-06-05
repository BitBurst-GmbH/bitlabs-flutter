import 'configuration.dart';
import 'serializable.dart';

class GetAppSettingsResponse extends Serializable {
  final List<Configuration> configuration;

  GetAppSettingsResponse(Map<String, dynamic> json)
      : configuration = (json['configuration'] as List)
            .map((e) => Configuration(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'configuration': configuration.map((e) => e.toJson()).toList(),
    };
  }
}
