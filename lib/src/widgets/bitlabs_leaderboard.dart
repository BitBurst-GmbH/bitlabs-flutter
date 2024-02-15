import 'dart:developer';

import 'package:bitlabs/bitlabs.dart';
import 'package:bitlabs/src/api/bitlabs_repository.dart';
import 'package:bitlabs/src/widgets/styled_text.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../utils/notifiers.dart' as notifiers;
import 'leaderboard_item.dart';

class BitLabsLeaderboard extends StatefulWidget {
  const BitLabsLeaderboard({Key? key}) : super(key: key);

  @override
  State<BitLabsLeaderboard> createState() => _BitLabsLeaderboardState();
}

class _BitLabsLeaderboardState extends State<BitLabsLeaderboard> {
  User? ownUser;
  List<User>? topUsers;

  Widget? image;
  Color color = notifiers.widgetColor.value.first;

  void _updateColor() {
    setState(() => color = notifiers.widgetColor.value.first);
  }

  void _updateImageWidget() {
    BitLabsRepository.getCurrencyIcon(
      notifiers.currencyIconURL.value,
      (imageData) => setState(() => image = imageData),
      (e) => log(e.toString()),
    );
  }

  @override
  void initState() {
    super.initState();

    notifiers.widgetColor.addListener(_updateColor);

    notifiers.currencyIconURL.addListener(_updateImageWidget);

    BitLabs.instance.getLeaderboard((leaderboard) => setState(() {
          ownUser = leaderboard.ownUser;
          topUsers = leaderboard.topUsers;
        }));
  }

  @override
  Widget build(BuildContext context) => topUsers == null || topUsers!.isEmpty
      ? const SizedBox.shrink()
      : SizedBox(
          height: 200,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const StyledText('Leaderboard', fontSize: 25),
              Text(ownUser == null
                  ? 'Participate in a survey to join the leaderboard.'
                  : 'You are currently ranked ${ownUser!.rank} on our leaderboard.'),
              const SizedBox(height: 4),
              Expanded(
                child: ListView(children: [
                  for (User user in topUsers!)
                    LeaderboardItem(
                      user: user,
                      color: color,
                      image: image,
                      ownUser: ownUser,
                    ),
                ]),
              )
            ],
          ),
        );

  @override
  void dispose() {
    notifiers.currencyIconURL.removeListener(_updateImageWidget);
    notifiers.widgetColor.removeListener(_updateColor);
    super.dispose();
  }
}
