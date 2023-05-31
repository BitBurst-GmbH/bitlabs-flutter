import 'currency.dart';
import 'serializable.dart';
import 'visual.dart';

class GetAppSettingsResponse extends Serializable {
  final Visual visual;
  final Currency currency;

  GetAppSettingsResponse(Map<String, dynamic> json)
      : visual = Visual(json['visual']),
        currency = Currency(json['currency']);

  Map<String, dynamic> toJson() => {'visual': visual};
}
