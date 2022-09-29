import 'package:ascology_app/model/response/astrologer_listing_response.dart';

class AgentCallSatatus
{
  String id;
  String agentstatus;

  AgentCallSatatus();

  factory AgentCallSatatus.fromJson(Map<String, dynamic> json) {
    AgentCallSatatus astrologerDetails = new AgentCallSatatus();
    astrologerDetails.id =  json["id"];
    astrologerDetails.agentstatus =  json["agentstatus"];
    return astrologerDetails;

  }
}