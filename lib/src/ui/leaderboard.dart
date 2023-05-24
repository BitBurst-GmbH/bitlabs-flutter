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

  @override
  void initState() {
    super.initState();

    BitLabs.instance.getLeaderboard(
        (leaderboard) => setState(() => topUsers = leaderboard.topUsers));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Leaderboard', style: TextStyle(fontSize: 25)),
        const Text('You are currently ranked 6 on our leaderboard.'),
        const SizedBox(height: 4),
        Expanded(
          child: ListView(children: [
            for (User user in topUsers) LeaderboardItem(user: user),
          ]),
        )
      ]),
    );
  }
}
