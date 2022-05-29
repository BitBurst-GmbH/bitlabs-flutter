import 'survey.dart';
import 'qualification.dart';
import 'response_reason.dart';
import 'serializable.dart';
import 'start_bonus.dart';

class GetActionsResponse extends Serializable {
  final bool isNewUser;
  final StartBonus? startBonus;
  final RestrictionReason? restrictionReason;
  final List<Survey> surveys;
  final Qualification? qualification;

  GetActionsResponse(Map<String, dynamic> json)
      : isNewUser = json['is_new_user'] as bool,
        startBonus =
            json.containsKey('start_bonus') ? json['start_bonus'] : null,
        restrictionReason = json.containsKey('restriction_reason')
            ? json['restriction_reason']
            : null,
        surveys =
            List<Survey>.from(json['surveys'].map((survey) => Survey(survey))),
        qualification = json.containsKey('qualification')
            ? Qualification(json['qualification'])
            : null;

  Map<String, dynamic> toJson() => {
        'is_new_user': isNewUser,
        'start_bonus': startBonus,
        'restriction_reason': restrictionReason,
        'surveys': surveys,
        'qualification': qualification
      };
}
