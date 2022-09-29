import 'package:ascology_app/model/response/astrologer_listing_response.dart';

class AuspiciousMuhurtaOutput
{
  String status;
  String msg;



  AuspiciousMuhurtaOutput();

  factory AuspiciousMuhurtaOutput.fromJson(Map<String, dynamic> json) {
    AuspiciousMuhurtaOutput astrologerDetails = new AuspiciousMuhurtaOutput();
    astrologerDetails.status =  json["status"];
    astrologerDetails.msg =  json["msg"];


    return astrologerDetails;

  }
}