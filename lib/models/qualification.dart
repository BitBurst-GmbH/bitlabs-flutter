import 'package:bitlabs/models/question.dart';

class Qualification {
  final int networkId;
  final String questionId;
  final String country;
  final String language;
  final Question question;
  final bool isStandardProfile;
  final bool isStartBonus;
  final double score;
  final int sequence;

  Qualification(Map<String, dynamic> json)
      : networkId = json['network_id'],
        questionId = json['question_id'],
        country = json['country'],
        language = json['language'],
        question = json['question'],
        isStandardProfile = json['is_standard_profile'],
        isStartBonus = json['is_start_bonus'],
        score = (json['score'] as num).toDouble(),
        sequence = json['sequence'];

  Map<String, dynamic> toJson() => {
        'network_id': networkId,
        'question_id': questionId,
        'country': country,
        'language': language,
        'question': question,
        'is_standard_profile': isStandardProfile,
        'is_start_bonus': isStartBonus,
        'score': score,
        'sequence': sequence
      };
}
