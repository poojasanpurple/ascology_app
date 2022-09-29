import 'package:ascology_app/model/response/astrologer_agentstatus.dart';
import 'package:ascology_app/model/response/astrologer_list_detail.dart';

class AgentStatusListingResponse {
  bool status;
  String message;
  List<AgentCallSatatus> data;

//  AstrologerListingResponse(this.status, this.message, [this.data]);

  AgentStatusListingResponse();

  factory AgentStatusListingResponse.fromJson(Map<dynamic, dynamic> json){
    AgentStatusListingResponse astrologerListingResponse = new AgentStatusListingResponse();
    astrologerListingResponse.status = json["status"];
    astrologerListingResponse.message = json["message"];

    var list = json["data"] as List;

    astrologerListingResponse.data = list.map((i) => AgentCallSatatus.fromJson(i)).toList();

    return astrologerListingResponse;
  }

/*factory AstrologerListingResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      var tagObjsJson = json['data'] as List;
      List<AstrologerDetails> _astrologertags = tagObjsJson
          .map((tagJson) => AstrologerDetails.fromJson(tagJson))
          .toList();

      return AstrologerListingResponse(
          json['status'] as bool, json['message'], _astrologertags);
    }
  }*/
}