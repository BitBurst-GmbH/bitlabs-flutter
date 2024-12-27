import 'serializable.dart';

class Promotion extends Serializable {
  final String startDate;
  final String endDate;
  final int bonusPercentage;

  Promotion(Map<String, dynamic> json)
      : startDate = json['start_date'],
        endDate = json['end_date'],
        bonusPercentage = json['bonus_percentage'];

  Map<String, dynamic> toJson() => {
        'start_date': startDate,
        'end_date': endDate,
        'bonus_percentage': bonusPercentage,
      };
}
