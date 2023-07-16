import 'package:bitlabs/src/ui/styled_text.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

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
        thickness: 1,
        color: Colors.black,
        indent: 4,
        endIndent: 4,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          StyledText('${user.rank}', fontSize: 16),
          const Spacer(flex: 4),
          StyledText(user.name, fontSize: 16),
          if (user.rank == ownUser?.rank) const Spacer(),
          if (user.rank == ownUser?.rank)
            const StyledText('(You)', color: Colors.blueAccent, fontSize: 14),
          const Spacer(),
          getTrophy(user.rank, color),
          const Spacer(flex: 15),
          StyledText('${user.earningsRaw}', fontSize: 16),
          image ?? const SizedBox.shrink()
        ]),
      ),
    ]);
  }

  Widget getTrophy(int rank, Color color) => rank < 4
      ? Stack(alignment: Alignment.center, children: [
          Icon(Icons.emoji_events_sharp, size: 20, color: color),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: StyledText(
              rank.toString(),
              color: Colors.white,
              fontSize: 10,
            ),
          )
        ])
      : const SizedBox.shrink();
}
