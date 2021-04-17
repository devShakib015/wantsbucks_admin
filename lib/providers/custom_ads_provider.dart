import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:wantsbucks_admin/ad_model.dart';

class CustomAdsProvider extends ChangeNotifier {
  Future<QuerySnapshot> getCustomAds(String adsName) async {
    return await FirebaseFirestore.instance.collection(adsName).get();
  }

  Future<void> deleteAd(String adsCollection, String id) async {
    await FirebaseFirestore.instance.collection(adsCollection).doc(id).delete();
  }

  Future<void> addAds(String adsCollection, AdModel adModel) async {
    await FirebaseFirestore.instance.collection(adsCollection).add(
          adModel.toMap(),
        );
  }

  Future<void> updateAd(
      String adsCollection, AdModel adModel, String id) async {
    await FirebaseFirestore.instance
        .collection(adsCollection)
        .doc(id)
        .update(adModel.toMap());
  }
}
