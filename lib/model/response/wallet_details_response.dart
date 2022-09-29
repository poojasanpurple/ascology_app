import 'package:ascology_app/model/response/astrologer_listing_response.dart';

class WalletDetails
{
 /* String id;
  String customer_id;*/

  String amount;
 // String created_date;

  WalletDetails();

  factory WalletDetails.fromJson(Map<String, dynamic> json) {
    WalletDetails details = new WalletDetails();
  /*  details.id =  json["id"];
    details.customer_id =  json["customer_id"];*/
    details.amount =  json["amount"];
   // details.created_date =  json["created_date"];

    return details;

  }
}