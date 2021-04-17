import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks_admin/ad_model.dart';
import 'package:wantsbucks_admin/other%20pages/loading.dart';
import 'package:wantsbucks_admin/providers/custom_ads_provider.dart';

class EditAd extends StatefulWidget {
  final String id;
  final Map<String, dynamic> data;
  final String adsCollection;

  const EditAd({Key key, this.id, this.adsCollection, this.data})
      : super(key: key);

  @override
  _EditAdState createState() => _EditAdState();
}

class _EditAdState extends State<EditAd> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      _titleController.text = widget.data["title"];
      _urlController.text = widget.data["url"];
      _imageUrlController.text = widget.data["adurl"];
      _priceController.text = widget.data["priceperday"].toString();
      _durationController.text =
          DateTime.fromMillisecondsSinceEpoch(widget.data["endDate"])
              .difference(DateTime.now())
              .inDays
              .toString();
    }
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.id == null ? "Add New Ad" : "Edit Ad"),
              actions: [
                widget.id == null
                    ? Opacity(
                        opacity: 0,
                        child: IconButton(
                            icon: Icon(Icons.delete), onPressed: null),
                      )
                    : IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          Provider.of<CustomAdsProvider>(context, listen: false)
                              .deleteAd(widget.adsCollection, widget.id);
                          Navigator.pop(context);
                        },
                      )
              ],
            ),
            body: Container(
              child: SingleChildScrollView(
                child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: widget.adsCollection == "homeads"
                                ? Text("Home Ads")
                                : widget.adsCollection == "directads"
                                    ? Text("Direct Ads")
                                    : Text("Earn Ads"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _titleController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "can't be empty";
                              } else if (value.length < 5) {
                                return "Title must be at least 5 characters!";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: "A title that can be identified.",
                                labelText: "Title"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _imageUrlController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "can't be empty";
                              } else if (!value.contains("https://")) {
                                return "Invalid Url. Must contain - https:// ";
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: "The ad image url!",
                                labelText: "Image Url"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _urlController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "can't be empty";
                              } else if (!value.contains("https://")) {
                                return "Invalid Url. Must contain - https:// ";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText:
                                    "The url where the link will redirect!",
                                labelText: "Redirect url"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _priceController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "can't be empty";
                              } else if (int.tryParse(value) == null) {
                                return "The price must be integer value";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: "200", labelText: "Price per day"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _durationController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "can't be empty";
                              } else if (int.tryParse(value) == null) {
                                return "The Duration must be integer value!";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: "Duration [in days]", hintText: "7"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: widget.id == null
                              ? ElevatedButton(
                                  onPressed: () async {
                                    if (_formkey.currentState.validate()) {
                                      DateTime _currentTime = DateTime.now();
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      await Provider.of<CustomAdsProvider>(
                                              context,
                                              listen: false)
                                          .addAds(
                                              widget.adsCollection,
                                              AdModel(
                                                  endDate: _currentTime.add(
                                                      Duration(
                                                          days: int.parse(
                                                                  _durationController
                                                                      .text) +
                                                              1)),
                                                  startDate: _currentTime,
                                                  title: _titleController.text,
                                                  url: _urlController.text,
                                                  adurl:
                                                      _imageUrlController.text,
                                                  priceperday: int.parse(
                                                      _priceController.text)));

                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text("Add This Ad"))
                              : ElevatedButton(
                                  onPressed: () async {
                                    if (_formkey.currentState.validate()) {
                                      DateTime _currentTime = DateTime.now();
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      await Provider.of<CustomAdsProvider>(
                                              context,
                                              listen: false)
                                          .updateAd(
                                              widget.adsCollection,
                                              AdModel(
                                                  endDate: _currentTime.add(
                                                      Duration(
                                                          days: int.parse(
                                                                  _durationController
                                                                      .text) +
                                                              1)),
                                                  startDate: _currentTime,
                                                  title: _titleController.text,
                                                  url: _urlController.text,
                                                  adurl:
                                                      _imageUrlController.text,
                                                  priceperday: int.parse(
                                                      _priceController.text)),
                                              widget.id);

                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text("Update")),
                        )
                      ],
                    )),
              ),
            ),
          );
  }
}
