import 'package:bitlabs/src/widgets/reward_view.dart';
import 'package:bitlabs/src/widgets/styled_text.dart';
import 'package:flutter/material.dart';

import '../models/bitlabs/user.dart';

class LeaderboardItem extends StatelessWidget {
  final User user;
  final User? ownUser;
  final Color color;
  final Widget? image;

  const LeaderboardItem({
    Key? key,
    required this.user,
    required this.ownUser,
    required this.color,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Divider(
        height: 1,
        indent: 4,
        thickness: 1,
        endIndent: 4,
        color: Colors.black,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          StyledText('${user.rank}', fontSize: 16),
          const Spacer(flex: 4),
          StyledText(user.name, fontSize: 16),
          if (user.rank == ownUser?.rank) const Spacer(),
          if (user.rank == ownUser?.rank)
            const StyledText('(You)', color: Colors.blueAccent),
          const Spacer(),
          if (user.rank < 4) Trophy(rank: user.rank, color: color),
          const Spacer(flex: 15),
          RewardView(
            size: 16,
            fontSize: 16,
            color: Colors.black,
            currencyIcon: image,
            reward: user.earningsRaw.toString(),
          ),
        ]),
      ),
    ]);
  }
}

class Trophy extends StatelessWidget {
  final int rank;
  final Color color;

  const Trophy({Key? key, required this.rank, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Stack(alignment: Alignment.center, children: [
        Icon(Icons.emoji_events_sharp, size: 20, color: color),
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: StyledText(
            rank.toString(),
            fontSize: 10,
            color: Colors.white,
          ),
        )
      ]);
}
