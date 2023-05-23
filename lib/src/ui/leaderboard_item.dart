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
          children: const [
            Text('1', style: TextStyle(fontSize: 16)),
            Spacer(),
            Text('anonymous', style: TextStyle(fontSize: 16)),
            Spacer(flex: 5),
            Text('25000', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    ]);
  }
}
