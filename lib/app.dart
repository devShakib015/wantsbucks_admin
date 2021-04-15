import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks_admin/other%20pages/loading.dart';
import 'package:wantsbucks_admin/providers/auth_provider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: Provider.of<AuthProvider>(context).getAdmin(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.error != null) {
              return Text(snapshot.error.toString());
            } else {
              final _adminID = snapshot.data.docs.first?.id;
              if (FirebaseAuth.instance.currentUser.uid != _adminID) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Hey?? WTF!"),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () async {
                          await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .logOut(context);
                        },
                      )
                    ],
                  ),
                  body: Center(
                      child: Text(
                    "You are not the admin!\nPlease logout and login as an admin.",
                    textAlign: TextAlign.center,
                  )),
                );
              } else
                return Scaffold(
                  appBar: AppBar(
                    title: Text("WantsBucks Admin"),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () async {
                          await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .logOut(context);
                        },
                      )
                    ],
                  ),
                  body: Center(
                    child: Text("Welcome Boss!!"),
                  ),
                );
            }
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
