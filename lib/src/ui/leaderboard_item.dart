import 'package:flutter/material.dart';

import '../models/User.dart';

class LeaderboardItem extends StatelessWidget {
  final User user;
  final User? ownUser;

  const LeaderboardItem({Key? key, required this.user, required this.ownUser})
      : super(key: key);

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
          Text('${user.rank}', style: const TextStyle(fontSize: 16)),
          const Spacer(flex: 4),
          Text(user.name, style: const TextStyle(fontSize: 16)),
          if (user.rank == ownUser?.rank ) const Spacer(),
          if (user.rank == ownUser?.rank)
            const Text(
              '(You)',
              style: TextStyle(color: Colors.blueAccent, fontSize: 14),
            ),
          const Spacer(),
          getTrophy(user.rank),
          const Spacer(flex: 15),
          Text('${user.earningsRaw}', style: const TextStyle(fontSize: 16)),
        ]),
      ),
    ]);
  }

  Widget getTrophy(int rank) => rank < 4
      ? Stack(alignment: Alignment.center, children: [
          const Icon(Icons.emoji_events_sharp, size: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              rank.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          )
        ])
      : const SizedBox.shrink();
}
