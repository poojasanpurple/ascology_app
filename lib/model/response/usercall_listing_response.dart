import 'package:ascology_app/model/response/testimonal_details_response.dart';
import 'package:ascology_app/model/response/user_chatlist_detail.dart';
import 'package:ascology_app/model/response/usercall_history_reponse.dart';

class UserCallHistoryListingResponse
{
  bool status;
  String message;
  List<CallHistoryResponse> data;

//  AstrologerListingResponse(this.status, this.message, [this.data]);

  UserCallHistoryListingResponse();

  factory UserCallHistoryListingResponse.fromJson(Map<dynamic, dynamic> json){
    UserCallHistoryListingResponse response = new UserCallHistoryListingResponse();
    response.status = json["status"];
    response.message = json["message"];

    var list = json["data"] as List;

    response.data = list.map((i) => CallHistoryResponse.fromJson(i)).toList();

    return response;
  }


}