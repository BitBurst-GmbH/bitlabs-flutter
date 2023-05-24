import 'package:bitlabs/bitlabs.dart';
import 'package:flutter/material.dart';

import '../models/User.dart';
import 'leaderboard_item.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<User> topUsers = [];
  User? ownUser;

  @override
  void initState() {
    super.initState();

    BitLabs.instance.getLeaderboard((leaderboard) => setState(() {
          ownUser = leaderboard.ownUser;
          topUsers = leaderboard.topUsers;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Leaderboard', style: TextStyle(fontSize: 25)),
        ownUser == null
            ? const Text('Participate in a survey to join the leaderboard.')
            : Text(
                'You are currently ranked ${ownUser!.rank} on our leaderboard.'),
        const SizedBox(height: 4),
        Expanded(
          child: ListView(children: [
            for (User user in topUsers)
              LeaderboardItem(user: user, ownUser: ownUser),
          ]),
        )
      ]),
    );
  }
}
