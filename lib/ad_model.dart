import 'dart:convert';

import 'package:flutter/cupertino.dart';

class AdModel {
  DateTime endDate;
  DateTime startDate;
  String title;
  String url;
  String adurl;
  int priceperday;
  AdModel({
    @required this.endDate,
    @required this.startDate,
    @required this.title,
    @required this.url,
    @required this.adurl,
    @required this.priceperday,
  });

  Map<String, dynamic> toMap() {
    return {
      'endDate': endDate.millisecondsSinceEpoch,
      'startDate': startDate.millisecondsSinceEpoch,
      'title': title,
      'url': url,
      'adurl': adurl,
      'priceperday': priceperday,
    };
  }

  factory AdModel.fromMap(Map<String, dynamic> map) {
    return AdModel(
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      title: map['title'],
      url: map['url'],
      adurl: map['adurl'],
      priceperday: map['priceperday'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AdModel.fromJson(String source) =>
      AdModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AdModel(endDate: $endDate, startDate: $startDate, title: $title, url: $url, adurl: $adurl, priceperday: $priceperday)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AdModel &&
        other.endDate == endDate &&
        other.startDate == startDate &&
        other.title == title &&
        other.url == url &&
        other.adurl == adurl &&
        other.priceperday == priceperday;
  }

  @override
  int get hashCode {
    return endDate.hashCode ^
        startDate.hashCode ^
        title.hashCode ^
        url.hashCode ^
        adurl.hashCode ^
        priceperday.hashCode;
  }
}
