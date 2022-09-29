import 'package:ascology_app/model/response/service_details_response.dart';
import 'package:ascology_app/model/response/testimonal_details_response.dart';
import 'package:ascology_app/model/response/user_chatlist_detail.dart';
import 'package:ascology_app/model/response/usercall_history_reponse.dart';

class ServiceListingResponse
{
  bool status;
  String message;
  List<ServiceDetails> services;

//  AstrologerListingResponse(this.status, this.message, [this.data]);

  ServiceListingResponse();

  factory ServiceListingResponse.fromJson(Map<dynamic, dynamic> json){
    ServiceListingResponse response = new ServiceListingResponse();
    response.status = json["status"];
    response.message = json["message"];

    var list = json["services"] as List;

    response.services = list.map((i) => ServiceDetails.fromJson(i)).toList();

    return response;
  }


}