import 'serializable.dart';

class CheckSurveysResponse extends Serializable {
  final bool hasSurveys;

  CheckSurveysResponse(Map<String, dynamic> json)
      : hasSurveys = json['has_surveys'];

  Map<String, dynamic> toJson() => {'has_surveys': hasSurveys};
}
