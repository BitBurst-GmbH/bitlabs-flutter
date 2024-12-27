import 'serializable.dart';
import 'symbol.dart';

class Currency extends Serializable {
  final int bonusPercentage;
  final int? currencyPromotion;
  final String factor;
  final bool floorDecimal;
  final Symbol symbol;

  Currency(Map<String, dynamic> json)
      : bonusPercentage = json['bonus_percentage'],
        currencyPromotion = json.containsKey('currency_promotion')
            ? json['currency_promotion']
            : null,
        factor = json['factor'],
        floorDecimal = json['floor_decimal'],
        symbol = Symbol(json['symbol']);

  Map<String, dynamic> toJson() => {
        'bonus_percentage': bonusPercentage,
        'currency_promotion': currencyPromotion,
        'factor': factor,
        'floor_decimal': floorDecimal,
        'symbol': symbol,
      };
}
