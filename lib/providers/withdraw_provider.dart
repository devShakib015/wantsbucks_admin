import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class WithdrawProvider extends ChangeNotifier {
  final _withdrawls = FirebaseFirestore.instance.collection("withdrawls");

  Stream<QuerySnapshot> getAllWithdrawls() {
    return _withdrawls.snapshots();
  }

  Future<void> completeWithdraw(String id) async {
    await _withdrawls.doc(id).update({
      "completedTime": DateTime.now().millisecondsSinceEpoch,
      "status": "completed",
    });

    notifyListeners();
  }

  Future<void> cancelWithdraw({String id, int amount, String uid}) async {
    final _currentUserEarningCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("earnings");

    await _withdrawls.doc(id).update({
      "status": "cancelled",
    });
    await _currentUserEarningCollection.get().then((value) async {
      List _withdrew = value.docs.first.data()["withdrew"];
      _withdrew.remove(amount);
      await _currentUserEarningCollection.doc("earning").update({
        "withdrew": _withdrew,
      });
    });

    await _currentUserEarningCollection.get().then((value) async {
      int _currentEarning = value.docs.first.data()["currentBalance"];
      await _currentUserEarningCollection.doc("earning").update({
        "currentBalance": _currentEarning + (amount ~/ 0.95),
      });
    });
  }
}
