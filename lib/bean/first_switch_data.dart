import 'dart:convert';

FirstSwitchData firstSwitchDataFromJson(String str) {
  final jsonData = json.decode(str);
  return FirstSwitchData.fromJson(jsonData);
}

String firstSwitchDataToJson(FirstSwitchData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class FirstSwitchData {
  int id;
  String api;
  String url;
  int sort;
  int swi;
  int isOnline;
  int createTime;
  int updateTime;
  int cid;
  String isupdata;
  String updataUrl;
  String updatePackageName;
  String shieldedArea;
  String shieldedTime;

  FirstSwitchData({
    this.id,
    this.api,
    this.url,
    this.sort,
    this.swi,
    this.isOnline,
    this.createTime,
    this.updateTime,
    this.cid,
    this.isupdata,
    this.updataUrl,
    this.updatePackageName,
    this.shieldedArea,
    this.shieldedTime,
  });

  factory FirstSwitchData.fromJson(Map<String, dynamic> json) => new FirstSwitchData(
    id: json["id"],
    api: json["api"],
    url: json["url"],
    sort: json["sort"],
    swi: json["swi"],
    isOnline: json["is_online"],
    createTime: json["create_time"],
    updateTime: json["update_time"],
    cid: json["cid"],
    isupdata: json["isupdata"],
    updataUrl: json["updata_url"],
    updatePackageName: json["updatePackageName"],
    shieldedArea: json["shieldedArea"],
    shieldedTime: json["shieldedTime"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "api": api,
    "url": url,
    "sort": sort,
    "swi": swi,
    "is_online": isOnline,
    "create_time": createTime,
    "update_time": updateTime,
    "cid": cid,
    "isupdata": isupdata,
    "updata_url": updataUrl,
    "updatePackageName": updatePackageName,
    "shieldedArea": shieldedArea,
    "shieldedTime": shieldedTime,
  };
}