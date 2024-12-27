import 'currency.dart';
import 'promotion.dart';
import 'serializable.dart';
import 'visual.dart';

class GetAppSettingsResponse extends Serializable {
  final Visual visual;
  final Currency currency;
  final Promotion? promotion;

  GetAppSettingsResponse(Map<String, dynamic> json)
      : visual = Visual(json['visual']),
        currency = Currency(json['currency']),
        promotion =
            json['promotion'] != null ? Promotion(json['promotion']) : null;

  Map<String, dynamic> toJson() => {
        'visual': visual,
        'currency': currency,
        'promotion': promotion,
      };
}
