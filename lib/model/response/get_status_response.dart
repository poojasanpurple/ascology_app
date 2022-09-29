import 'package:ascology_app/model/response/astrologer_list_detail.dart';
import 'package:ascology_app/model/response/status_details_response.dart';
import 'package:ascology_app/model/response/user_detail_response.dart';

class StatusResponse {
  bool status;
  String message;
  List<StatusDetails> data;

//  AstrologerListingResponse(this.status, this.message, [this.data]);

  StatusResponse();

  factory StatusResponse.fromJson(Map<dynamic, dynamic> json){
    StatusResponse listingResponse = new StatusResponse();
    listingResponse.status = json["status"];
    listingResponse.message = json["message"];

    var list = json["data"] as List;

    listingResponse.data = list.map((i) => StatusDetails.fromJson(i)).toList();

    return listingResponse;
  }

}