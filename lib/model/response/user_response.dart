import 'package:ascology_app/model/response/astrologer_list_detail.dart';
import 'package:ascology_app/model/response/user_detail_response.dart';

class UserListingResponse {
  bool status;
  String message;
  List<UserDetails> data;

//  AstrologerListingResponse(this.status, this.message, [this.data]);

  UserListingResponse();

  factory UserListingResponse.fromJson(Map<dynamic, dynamic> json){
    UserListingResponse listingResponse = new UserListingResponse();
    listingResponse.status = json["status"];
    listingResponse.message = json["message"];

    var list = json["data"] as List;

    listingResponse.data = list.map((i) => UserDetails.fromJson(i)).toList();

    return listingResponse;
  }

}