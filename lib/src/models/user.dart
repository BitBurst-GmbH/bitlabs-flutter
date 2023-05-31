import 'package:bitlabs/src/models/serializable.dart';

class User extends Serializable {
  final double earningsRaw;
  final String name;
  final int rank;

  User(Map<String, dynamic> json)
      : earningsRaw = (json['earnings_raw'] as num).toDouble(),
        name = json['name'],
        rank = json['rank'];

  Map<String, dynamic> toJson() => {
        'earnings_raw': earningsRaw,
        'name': name,
        'rank': rank,
      };
}
