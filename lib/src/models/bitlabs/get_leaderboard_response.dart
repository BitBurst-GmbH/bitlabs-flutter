import 'dart:convert';

import 'reward.dart';
import 'serializable.dart';
import 'user.dart';

class GetLeaderboardResponse extends Serializable {
  final String nextResetAt;
  final User? ownUser;
  final List<Reward> rewards;
  final List<User>? topUsers;

  GetLeaderboardResponse(Map<String, dynamic> json)
      : nextResetAt = json['next_reset_at'],
        ownUser = json.containsKey('own_user') ? User(json['own_user']) : null,
        rewards = List<Reward>.from(
            json['rewards'].map((reward) => Reward(reward)).toList()),
        topUsers = json.containsKey('top_users') && json['top_users'] != null
            ? List<User>.from(json['top_users'].map((u) => User(u)).toList())
            : null;

  Map<String, dynamic> toJson() => {
        'next_reset_at': nextResetAt,
        'own_user': ownUser?.toJson(),
        'rewards': rewards.map((reward) => reward.toJson()).toList(),
        'top_users': topUsers?.map((user) => user.toJson()).toList(),
      };

  @override
  String toString() => jsonEncode(this);
}
