import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DashboardProvider extends ChangeNotifier {
  Future<Map<String, int>> getDashBoardInfo() async {
    Map<String, int> _dashboard = {
      "totalUsers": 0,
      "totalPayable": 0,
      "totalWithdrawRequest": 0,
    };
    try {
      await FirebaseFirestore.instance.collection("users").get().then((value) {
        int _users = value.docs.length;
        _dashboard["totalUsers"] = _users;
      });

      await FirebaseFirestore.instance
          .collection("users")
          .get()
          .then((value) async {
        int _totalPayable = 0;
        List<QueryDocumentSnapshot> _users = value.docs;
        for (var item in _users) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(item.id)
              .collection("earnings")
              .get()
              .then((value) {
            num _currentEarning = value.docs.first.data()["currentBalance"];
            _totalPayable += _currentEarning;
          });
        }
        _dashboard["totalPayable"] = _totalPayable;
      });

      await FirebaseFirestore.instance
          .collection("withdrawls")
          .where("status", isEqualTo: "pending")
          .get()
          .then((value) {
        int _req = value.docs.length;
        _dashboard["totalWithdrawRequest"] = _req;
      });
    } catch (e) {}

    return _dashboard;
  }
}
