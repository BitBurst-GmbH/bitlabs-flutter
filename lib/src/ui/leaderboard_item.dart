import 'package:flutter/material.dart';

class LeaderboardItem extends StatelessWidget {
  const LeaderboardItem({Key? key}) : super(key: key);

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text('1', style: TextStyle(fontSize: 16)),
            const Spacer(flex: 4),
            const Text('anonymous', style: TextStyle(fontSize: 16)),
            const Spacer(),
            const Text(
              '(You)',
              style: TextStyle(color: Colors.blueAccent, fontSize: 14),
            ),
            const Spacer(),
            getTrophy(1),
            const Spacer(flex: 15),
            const Text('25000', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    ]);
  }

  Widget getTrophy(int rank) => Stack(alignment: Alignment.center, children: [
        const Icon(Icons.emoji_events_sharp, size: 20),
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            rank.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        )
      ]);
}
