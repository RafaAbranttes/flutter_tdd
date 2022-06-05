import 'package:flutter/material.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Rafa App",
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
