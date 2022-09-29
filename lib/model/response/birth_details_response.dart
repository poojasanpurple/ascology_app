import 'package:ascology_app/model/response/astro_details_output.dart';
import 'package:ascology_app/model/response/astrologer_list_detail.dart';
import 'package:ascology_app/model/response/auspicious_output.dart';
import 'package:ascology_app/model/response/basic_panchang_output.dart';
import 'package:ascology_app/model/response/birth_details_output.dart';
import 'package:ascology_app/screens/birth_details.dart';

class BirthDetailsResponse {
  bool status;
  String message;
  BirthDetailsOutput birthDetails;
  AstroDetailsOutput astroDetails;
  AuspiciousMuhurtaOutput auspiciousMuhurtaMarriage;
  BasicPanchangOutput basicPanchang;

  BirthDetailsResponse(
      {this.status,
        this.message,
        this.birthDetails,
        this.astroDetails,
        this.auspiciousMuhurtaMarriage,
        this.basicPanchang});

  BirthDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    birthDetails = json['birth_details'] != null
        ? new BirthDetailsOutput.fromJson(json['birth_details'])
        : null;
    astroDetails = json['astro_details'] != null
        ? new AstroDetailsOutput.fromJson(json['astro_details'])
        : null;
    auspiciousMuhurtaMarriage = json['auspicious_muhurta_marriage'] != null
        ? new AuspiciousMuhurtaOutput.fromJson(json['auspicious_muhurta_marriage'])
        : null;
    basicPanchang = json['basic_panchang'] != null
        ? new BasicPanchangOutput.fromJson(json['basic_panchang'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.birthDetails != null) {
      data['birth_details'] = this.birthDetails.toJson();
    }
    if (this.astroDetails != null) {
      data['astro_details'] = this.astroDetails.toJson();
    }
    data['auspicious_muhurta_marriage'] = this.auspiciousMuhurtaMarriage;
    if (this.basicPanchang != null) {
      data['basic_panchang'] = this.basicPanchang.toJson();
    }
    return data;
  }

}