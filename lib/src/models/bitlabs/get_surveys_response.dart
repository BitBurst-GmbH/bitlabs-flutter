import 'response_reason.dart';
import 'serializable.dart';
import 'survey.dart';

class GetSurveysResponse extends Serializable {
  final RestrictionReason? restrictionReason;
  final List<Survey> surveys;

  GetSurveysResponse(Map<String, dynamic> json)
      : restrictionReason = json.containsKey('restriction_reason')
            ? json['restriction_reason']
            : null,
        surveys = List<Survey>.from(
            json['surveys'].map((survey) => Survey.fromJson(survey)));

  Map<String, dynamic> toJson() => {
        'restriction_reason': restrictionReason,
        'surveys': surveys,
      };
}
