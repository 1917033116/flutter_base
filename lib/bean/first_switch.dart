import 'dart:convert';

FirstSwitch firstSwitchFromJson(String str) {
  final jsonData = json.decode(str);
  return FirstSwitch.fromJson(jsonData);
}

String firstSwitchToJson(FirstSwitch data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class FirstSwitch {
  int code;
  String data;

  FirstSwitch({
    this.code,
    this.data,
  });

  factory FirstSwitch.fromJson(Map<String, dynamic> json) => new FirstSwitch(
    code: json["Code"],
    data: json["Data"],
  );

  Map<String, dynamic> toJson() => {
    "Code": code,
    "Data": data,
  };
}


