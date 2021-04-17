import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks_admin/other%20pages/edit_ad.dart';
import 'package:wantsbucks_admin/other%20pages/loading.dart';
import 'package:wantsbucks_admin/other%20pages/something_went_wrong.dart';
import 'package:wantsbucks_admin/providers/custom_ads_provider.dart';
import 'package:wantsbucks_admin/theming/color_constants.dart';

class CustomAds extends StatefulWidget {
  @override
  _CustomAdsState createState() => _CustomAdsState();
}

class _CustomAdsState extends State<CustomAds> {
  @override
  Widget build(BuildContext context) {
    List<String> _tabs = ["Home Page", "Direct Page", "Earn Page"];
    return DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Custom Ads"),
            bottom: TabBar(
              isScrollable: true,
              tabs: _tabs
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(e),
                      ))
                  .toList(),
            ),
          ),
          body: TabBarView(children: [
            _adsListByPage(
                context: context,
                adsCollection: "homeads",
                color: dangerColor,
                onAddPressed: (adsCollection) async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditAd(
                                adsCollection: adsCollection,
                              ))).then((value) {
                    setState(() {});
                  });
                },
                onTilePressed: (id, adsCollection, data) async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditAd(
                                adsCollection: adsCollection,
                                id: id,
                                data: data,
                              ))).then((value) {
                    setState(() {});
                  });
                }),
            _adsListByPage(
                context: context,
                adsCollection: "directads",
                color: mainColor,
                onAddPressed: (adsCollection) async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditAd(
                                adsCollection: adsCollection,
                              ))).then((value) {
                    setState(() {});
                  });
                },
                onTilePressed: (id, adsCollection, data) async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditAd(
                                adsCollection: adsCollection,
                                id: id,
                                data: data,
                              ))).then((value) {
                    setState(() {});
                  });
                }),
            _adsListByPage(
                context: context,
                adsCollection: "earnads",
                color: Colors.lightBlue,
                onAddPressed: (adsCollection) async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditAd(
                                adsCollection: adsCollection,
                              ))).then((value) {
                    setState(() {});
                  });
                },
                onTilePressed: (id, adsCollection, data) async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditAd(
                                adsCollection: adsCollection,
                                id: id,
                                data: data,
                              ))).then((value) {
                    setState(() {});
                  });
                }),
          ]),
        ));
  }

  Scaffold _adsListByPage(
      {BuildContext context,
      Color color,
      onAddPressed(String adsCollection),
      onTilePressed(String id, String adsCollection, Map<String, dynamic> data),
      String adsCollection}) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: color,
        onPressed: () {
          onAddPressed(adsCollection);
        },
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: Provider.of<CustomAdsProvider>(context)
              .getCustomAds(adsCollection),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Loading();
            } else if (snapshot.hasError) {
              return SomethingWentWrong();
            } else {
              final _data = snapshot.data.docs;
              if (_data.isEmpty) {
                return Container(
                  child: Center(
                    child: Text("Empty!"),
                  ),
                );
              } else
                return Container(
                  child: SingleChildScrollView(
                      child: Column(
                    children: _data.map((e) {
                      int _daysLeft = DateTime.fromMillisecondsSinceEpoch(
                              e.data()["endDate"])
                          .difference(DateTime.now())
                          .inDays;
                      return Card(
                        color: _daysLeft == 0 ? Colors.blueGrey : color,
                        child: ListTile(
                          onTap: () {
                            onTilePressed(e.id, adsCollection, e.data());
                          },
                          leading: Text("${_data.indexOf(e) + 1}"),
                          title: Text(e.data()["title"]),
                          subtitle: Text("Days Left : $_daysLeft"),
                        ),
                      );
                    }).toList(),
                  )),
                );
            }
          },
        ),
      ),
    );
  }
}
