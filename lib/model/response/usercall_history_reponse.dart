import 'package:ascology_app/model/response/astrologer_listing_response.dart';

class CallHistoryResponse
{
  int id;
  int order_id;
  String calldate;
  String src;
  String name;
  String duration;
  String min;
  String cust_bill_rate;
  String agent_pay_rate;
  String disposition;
  String uniqueid;
  String extension;
  String end;
  String cust_bbc;
  String cust_bac;
  String cust_bill_amt;
  String agent_bill;
  String filename;
  String gender;
  String address;
  String short_description;
  String agentname;
  String status;
  String CustName;


  CallHistoryResponse();

  factory CallHistoryResponse.fromJson(Map<String, dynamic> json) {
    CallHistoryResponse details = new CallHistoryResponse();
   // details.id =  json["id"];
    details.order_id =  json["order_id"];
    details.calldate =  json["calldate"];
    details.src =  json["src"];
    details.name =  json["name"];
    details.duration =  json["duration"];
    details.min =  json["min"];
    details.cust_bill_rate =  json["cust_bill_rate"];
    details.agent_pay_rate =  json["agent_pay_rate"];
    details.disposition =  json["disposition"];
    details.uniqueid =  json["uniqueid"];
    details.extension =  json["extension"];
    details.end =  json["end"];
    details.cust_bbc =  json["cust_bbc"];
    details.cust_bac =  json["cust_bac"];
    details.cust_bill_amt =  json["cust_bill_amt"];
    details.agent_bill =  json["agent_bill"];
    details.filename =  json["filename"];
    details.gender =  json["gender"];
    details.address =  json["address"];
    details.short_description =  json["short_description"];
    details.agentname =  json["agentname"];
    details.status =  json["status"];
    details.CustName =  json["CustName"];

    return details;

  }
}