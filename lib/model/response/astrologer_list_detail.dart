import 'package:ascology_app/model/response/astrologer_listing_response.dart';

class AstrologerDetails
{
  String ID;
  String id_service;
  String id_language;
  String agentname;
  String price;
  String mob;
  String extension;
  String slug;
  String timing;
  String experience;
  String image;
  String image_big;
  String about;
  String short_description;
  String password;
  String sip;
  String status1;
  String callback;
  String is_active;
  String b_rate;
  String p_rate;
  String token;
  String otp;
  String device_name;
  String device_model;
  String apk_version;
  String imei_number;
  String title;
  String avg_rating;
  String PhoneCallStatus;
  String ChatStatus;
  String EmergencyCallStatus;
  String follow;

  AstrologerDetails();

  factory AstrologerDetails.fromJson(Map<String, dynamic> json) {
    AstrologerDetails astrologerDetails = new AstrologerDetails();
    astrologerDetails.ID =  json["ID"];
    astrologerDetails.id_service =  json["id_service"];
    astrologerDetails.id_language =  json["id_language"];
    astrologerDetails.agentname =  json["agentname"];
    astrologerDetails.price =  json["price"];
    astrologerDetails.mob =  json["mob"];
    astrologerDetails.extension =  json["extension"];
    astrologerDetails.slug =  json["slug"];
    astrologerDetails.timing =  json["timing"];
    astrologerDetails.experience =  json["experience"];
    astrologerDetails.image =  json["image"];
    astrologerDetails.image_big =  json["image_big"];
    astrologerDetails.about =  json["about"];
    astrologerDetails.short_description =  json["short_description"];
    astrologerDetails.password =  json["password"];
    astrologerDetails.sip =  json["sip"];
    astrologerDetails.status1 =  json["status1"];
    astrologerDetails.callback =  json["callback"];
    astrologerDetails.is_active =  json["is_active"];
    astrologerDetails.b_rate =  json["b_rate"];
    astrologerDetails.p_rate =  json["p_rate"];
    astrologerDetails.token =  json["token"];
    astrologerDetails.otp =  json["otp"];
    astrologerDetails.device_name =  json["device_name"];
    astrologerDetails.device_model =  json["device_model"];
    astrologerDetails.apk_version =  json["apk_version"];
    astrologerDetails.imei_number =  json["imei_number"];
    astrologerDetails.title =  json["title"];
    astrologerDetails.avg_rating =  json["avg_rating"];
    astrologerDetails.PhoneCallStatus =  json["PhoneCallStatus"];
    astrologerDetails.ChatStatus =  json["ChatStatus"];
    astrologerDetails.EmergencyCallStatus =  json["EmergencyCallStatus"];
    astrologerDetails.follow =  json["follow"];
      return astrologerDetails;

  }
}