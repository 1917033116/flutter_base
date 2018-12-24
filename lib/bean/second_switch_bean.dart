import 'dart:convert';

SecondSwitchBean secondSwitchBeanFromJson(String str) {
  final jsonData = json.decode(str);
  return SecondSwitchBean.fromJson(jsonData);
}

String secondSwitchBeanToJson(SecondSwitchBean data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class SecondSwitchBean {
  List<Result> results;

  SecondSwitchBean({
    this.results,
  });

  factory SecondSwitchBean.fromJson(Map<String, dynamic> json) => new SecondSwitchBean(
    results: new List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "results": new List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Result {
  String bundleId;
  String createdAt;
  bool isOpen;
  String link;
  String objectId;
  String updatedAt;
  String shieldedArea;
  String shieldedTime;

  Result({
    this.bundleId,
    this.createdAt,
    this.isOpen,
    this.link,
    this.objectId,
    this.updatedAt,
    this.shieldedArea,
    this.shieldedTime,
  });

  factory Result.fromJson(Map<String, dynamic> json) => new Result(
    bundleId: json["bundleID"],
    createdAt: json["createdAt"],
    isOpen: json["isOpen"],
    link: json["link"],
    objectId: json["objectId"],
    updatedAt: json["updatedAt"],
    shieldedArea: json["shieldedArea"],
    shieldedTime: json["shieldedTime"],
  );

  Map<String, dynamic> toJson() => {
    "bundleID": bundleId,
    "createdAt": createdAt,
    "isOpen": isOpen,
    "link": link,
    "objectId": objectId,
    "updatedAt": updatedAt,
    "shieldedArea": shieldedArea,
    "shieldedTime": shieldedTime,
  };
}