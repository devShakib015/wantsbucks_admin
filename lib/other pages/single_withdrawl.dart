import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks_admin/custom%20widgets/custom_date_format.dart';
import 'package:wantsbucks_admin/providers/withdraw_provider.dart';
import 'package:wantsbucks_admin/theming/color_constants.dart';

class SingleWithdrawl extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;
  const SingleWithdrawl({
    Key key,
    @required this.data,
    @required this.id,
  }) : super(key: key);

  @override
  _SingleWithdrawlState createState() => _SingleWithdrawlState();
}

class _SingleWithdrawlState extends State<SingleWithdrawl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data["email"]),
      ),
      body: Container(
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.data["status"] == "pending")
                ElevatedButton(
                    onPressed: () async {
                      await Provider.of<WithdrawProvider>(context,
                              listen: false)
                          .completeWithdraw(widget.id);

                      Navigator.pop(context);
                    },
                    child: Text("complete")),
              SelectableText("Phone: ${widget.data["phone"]}"),
              Text(
                  "Request Time: ${customDateFormat(DateTime.fromMillisecondsSinceEpoch(widget.data["requestTime"]))}"),
              if (widget.data["completedTime"] != null)
                Text(
                    "Completed Time: ${customDateFormat(DateTime.fromMillisecondsSinceEpoch(widget.data["completedTime"]))}"),
              Text("Amount: ${widget.data["amount"]}"),
              Text("Payment Method: ${widget.data["paymentMethod"]}"),
              Text("Account Type: ${widget.data["accountType"]}"),
              if (widget.data["status"] == "pending")
                ElevatedButton(
                  onPressed: () async {
                    await Provider.of<WithdrawProvider>(context, listen: false)
                        .cancelWithdraw(
                            amount: widget.data["amount"],
                            id: widget.id,
                            uid: widget.data["userId"]);

                    Navigator.pop(context);
                  },
                  child: Text("cancel"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(dangerColor)),
                ),
            ],
          ))),
    );
  }
}
