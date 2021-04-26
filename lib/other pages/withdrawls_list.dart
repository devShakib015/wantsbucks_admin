import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks_admin/custom%20widgets/custom_date_format.dart';
import 'package:wantsbucks_admin/other%20pages/loading.dart';
import 'package:wantsbucks_admin/other%20pages/single_withdrawl.dart';
import 'package:wantsbucks_admin/providers/withdraw_provider.dart';
import 'package:wantsbucks_admin/theming/color_constants.dart';

class Withdrawls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Withdrawls"),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Provider.of<WithdrawProvider>(context).getAllWithdrawls(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Loading();
            } else {
              final _d = snapshot.data.docs;
              final _dataList = List.from(_d.reversed);
              return Container(
                child: Scrollbar(
                    child: ListView.builder(
                  itemBuilder: (context, index) {
                    final _data = _dataList[index].data();
                    final _dataId = _dataList[index].id;
                    DateTime _requestTime = DateTime.fromMillisecondsSinceEpoch(
                        _data["requestTime"]);
                    return Card(
                      color: _data["status"] == "pending"
                          ? Colors.blueGrey
                          : _data["status"] == "cancelled"
                              ? dangerColor
                              : mainColor,
                      child: ListTile(
                        onTap: _data["status"] == "cancelled"
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SingleWithdrawl(
                                      data: _data,
                                      id: _dataId,
                                    ),
                                  ),
                                );
                              },
                        title: Text(_data["email"]),
                        trailing: Text(_data["amount"].toString()),
                        subtitle: Text(
                            "Status: ${_data["status"]}\nTime: ${customDateFormat(_requestTime)}"),
                      ),
                    );
                  },
                  itemCount: _dataList.length,
                )),
              );
            }
          },
        ),
      ),
    );
  }
}
