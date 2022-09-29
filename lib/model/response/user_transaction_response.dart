import 'package:ascology_app/model/response/astrologer_listing_response.dart';

class TransactionHistoryResponse
{
  String pay_amount;
  String customer_id;
  String payment_id;
  String payment_date;
  String payment_mode;
  String payment_status;
  String id;
  String name;
  String mobile;
  String rtn;
  String email;
  String address;
  String gender;
  String state;
  String wallet;
  String user_expiry_date;
  String voucher_expiry_date;
  String added_date;
  String voucher_code;


  TransactionHistoryResponse();

  factory TransactionHistoryResponse.fromJson(Map<String, dynamic> json) {
    TransactionHistoryResponse details = new TransactionHistoryResponse();
    details.pay_amount =  json["pay_amount"];
    details.customer_id =  json["customer_id"];
    details.payment_id =  json["payment_id"];
    details.payment_date =  json["payment_date"];
    details.payment_mode =  json["payment_mode"];
    details.payment_status =  json["payment_status"];
    details.id =  json["id"];
    details.name =  json["name"];
    details.mobile =  json["mobile"];
    details.rtn =  json["rtn"];
    details.email =  json["email"];
    details.address =  json["address"];
    details.gender =  json["gender"];
    details.state =  json["state"];
    details.wallet =  json["wallet"];
    details.user_expiry_date =  json["user_expiry_date"];
    details.voucher_expiry_date =  json["voucher_expiry_date"];
    details.added_date=  json["added_date"];
    details.voucher_code =  json["voucher_code"];


    return details;

  }
}