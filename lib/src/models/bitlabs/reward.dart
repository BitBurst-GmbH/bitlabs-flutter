import 'serializable.dart';

class Reward extends Serializable {
  final int rank;
  final double rewardRaw;

  Reward(Map<String, dynamic> json)
      : rank = json['rank'],
        rewardRaw = (json['reward_raw'] as num).toDouble();

  Map<String, dynamic> toJson() => {
        'rank': rank,
        'reward_raw': rewardRaw,
      };
}
