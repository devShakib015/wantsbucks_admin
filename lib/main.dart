import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks_admin/app.dart';
import 'package:wantsbucks_admin/custom%20widgets/internet_checkup.dart';
import 'package:wantsbucks_admin/login.dart';
import 'package:wantsbucks_admin/other%20pages/loading.dart';
import 'package:wantsbucks_admin/other%20pages/something_went_wrong.dart';
import 'package:wantsbucks_admin/providers/auth_provider.dart';
import 'package:wantsbucks_admin/theming/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Phoenix(child: WantsBucksAdminApp()));
}

class WantsBucksAdminApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MainApp();
        }

        return Loading();
      },
    );
  }
}

//! MainApp

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

Future<User> _getUser() async {
  return FirebaseAuth.instance.currentUser;
}

class _MainAppState extends State<MainApp> {
  Widget build(BuildContext context) {
    return OfflineBuilder(
      debounceDuration: Duration.zero,
      connectivityBuilder:
          (BuildContext context, ConnectivityResult result, Widget widget) {
        if (result == ConnectivityResult.none) {
          return internetConnectionWidget(context);
        } else {
          return widget;
        }
      },
      child: FutureBuilder<User>(
        future: _getUser(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.error != null) {
              return Text(snapshot.error.toString());
            }
            return snapshot.hasData ? _appProvider() : _loginProvider();
          } else {
            return Loading();
          }
        },
      ),
    );
  }

  //! Providing MultiProvider

  Widget _appProvider() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'wantsBucks Admin',
        debugShowCheckedModeBanner: false,
        theme: mainTheme,
        home: App(),
      ),
    );
  }

  Widget _loginProvider() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'wantsBucks_login',
        debugShowCheckedModeBanner: false,
        theme: mainTheme,
        home: Login(),
      ),
    );
  }
}
