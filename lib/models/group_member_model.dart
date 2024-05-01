// To parse this JSON data, do
//
//     final memberModel = memberModelFromJson(jsonString);

import 'dart:convert';

MemberModel memberModelFromJson(String str) => MemberModel.fromJson(json.decode(str));

String memberModelToJson(MemberModel data) => json.encode(data.toJson());

class MemberModel {
  String keyName;
  String name;
  String mobile;
  String postCode;
  String divisionName;
  String cityName;
  String districtName;
  String profileImage;

  MemberModel({
    required this.keyName,
    required this.name,
    required this.mobile,
    required this.postCode,
    required this.divisionName,
    required this.cityName,
    required this.districtName,
    required this.profileImage,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) => MemberModel(
    keyName: json["key_name"].toString(),
    name: json["name"].toString(),
    mobile: json["mobile"].toString(),
    postCode: json["post_code"].toString(),
    divisionName: json["division_name"].toString(),
    cityName: json["city_name"].toString(),
    districtName: json["district_name"].toString(),
    profileImage: json["profile_image"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "key_name": keyName,
    "name": name,
    "mobile": mobile,
    "post_code": postCode,
    "division_name": divisionName,
    "city_name": cityName,
    "district_name": districtName,
    "profile_image": profileImage,
  };
}
