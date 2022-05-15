import 'package:bitlabs/bitlabs.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(title: 'BitLabs Example'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BitLabs.instance.init('46d31e1e-315a-4b52-b0de-eca6062163af', 'USER_ID');
    BitLabs.instance.checkSurveys((hasSurveys) => print(
        '[Example] ${hasSurveys ? 'Surveys Available!' : 'No Surveys!'}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: const Center(child: Text("Hallo, BitLabs!")),
    );
  }
}
