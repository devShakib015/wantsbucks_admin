import 'package:flutter/material.dart';
import 'package:wantsbucks_admin/theming/theme.dart';

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text("Something went Wrong"),
        ),
      ),
    );
  }
}
