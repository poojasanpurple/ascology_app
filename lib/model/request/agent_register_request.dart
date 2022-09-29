import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class AgentRegisterRequestModel
{
  String agentname;
  String mobile;
  String timing;
  String experience;
  String category;
  String language;
  String image;
  String password;
  String device_name;
  String device_model;
  String apk_version;
  String imei_number;

  AgentRegisterRequestModel();

/*  LoginRequestModel(this.email, this.password, this.token, this.device_name,
      this.device_model, this.apk_version, this.imei_number);*/


  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'agentname': agentname.trim(),
      'mobile': mobile.trim(),
      'timing': timing.trim(),
      'experience': experience.trim(),
      'category': category.trim(),
      'language': language.trim(),
      'image': image.trim(),
      'password': password.trim(),
      'device_name': device_name.trim(),
      'device_model': device_model.trim(),
      'apk_version': apk_version.trim(),
      'imei_number': imei_number.trim(),
    };

    return map;
  }

}