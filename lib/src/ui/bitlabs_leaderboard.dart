import 'dart:typed_data';

import 'package:bitlabs/bitlabs.dart';
import 'package:bitlabs/src/api/bitlabs_repository.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../utils/notifiers.dart';
import 'leaderboard_item.dart';

class BitLabsLeaderboard extends StatefulWidget {
  const BitLabsLeaderboard({Key? key}) : super(key: key);

  @override
  State<BitLabsLeaderboard> createState() => _BitLabsLeaderboardState();
}

class _BitLabsLeaderboardState extends State<BitLabsLeaderboard> {
  List<User> topUsers = [];
  User? ownUser;
  Color color = Colors.blueAccent;
  String url = '';
  Uint8List? image;

  void _updateColor() {
    setState(() => color = widgetColor.value.first);
  }

  @override
  void initState() {
    super.initState();

    widgetColor.addListener(_updateColor);

    BitLabsRepository.getCurrencyIcon(
        url, (imageData) => setState(() => image = imageData));

    BitLabs.instance.getLeaderboard((leaderboard) => setState(() {
          ownUser = leaderboard.ownUser;
          topUsers = leaderboard.topUsers;
        }));
  }

  @override
  void dispose() {
    widgetColor.removeListener(_updateColor);
    super.dispose();
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
              LeaderboardItem(
                user: user,
                ownUser: ownUser,
                color: color,
                image: image,
              ),
          ]),
        )
      ]),
    );
  }
}
