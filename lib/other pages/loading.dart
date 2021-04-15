import 'package:flutter/material.dart';

import 'package:wantsbucks_admin/theming/theme.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
