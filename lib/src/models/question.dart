import 'answer.dart';

class Question {
  final int networkId;
  final String id;
  final String country;
  final String language;
  final String type;
  final String localizedText;
  final List<Answer> answers;
  final bool canSkip;

  Question(Map<String, dynamic> json)
      : networkId = json['network_id'],
        id = json['id'],
        country = json['country'],
        language = json['language'],
        type = json['type'],
        localizedText = json['localized_text'],
        answers = List.from(json['answers'].map((answer) => Answer(answer))),
        canSkip = json['can_skip'];

  Map<String, dynamic> toJson() => {
        'network_id': networkId,
        'id': id,
        'country': country,
        'language': language,
        'type': type,
        'localized_text': localizedText,
        'answers': answers,
        'can_skip': canSkip
      };
}
