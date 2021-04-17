import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks_admin/other%20pages/custom_ads_page.dart';
import 'package:wantsbucks_admin/other%20pages/loading.dart';
import 'package:wantsbucks_admin/other%20pages/something_went_wrong.dart';
import 'package:wantsbucks_admin/providers/auth_provider.dart';
import 'package:wantsbucks_admin/providers/dashboard_provider.dart';
import 'package:wantsbucks_admin/theming/color_constants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AdminApp extends StatefulWidget {
  const AdminApp({
    Key key,
  }) : super(key: key);

  @override
  _AdminAppState createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    setState(() {});
    // monitor network fetch
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WantsBucks Admin"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false)
                  .logOut(context);
            },
          )
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CircularProgressIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Container(
          child: FutureBuilder<Map<String, int>>(
            future: Provider.of<DashboardProvider>(context).getDashBoardInfo(),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, int>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Loading();
              } else if (snapshot.hasError) {
                return SomethingWentWrong();
              } else {
                final _data = snapshot.data;
                return SingleChildScrollView(
                  child: Container(
                      child: Column(
                    children: [
                      _dashCard(
                          data: _data["totalUsers"],
                          color: mainColor,
                          title: "Total Users"),
                      _dashCard(
                          data: _data["totalPayable"],
                          color: dangerColor,
                          title: "Totat Payable"),
                      GestureDetector(
                        onTap: () {},
                        child: _dashCard(
                            color: Colors.lightBlue,
                            data: _data["totalWithdrawRequest"],
                            title: "Withdraw Requests"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomAds()));
                        },
                        child: Card(
                          color: Colors.teal,
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Center(
                              child: Text(
                                "Custom Ads",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Card _dashCard({
    int data,
    String title,
    Color color,
  }) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text.rich(
            TextSpan(
                text: "$title\n",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: "$data",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  )
                ]),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
