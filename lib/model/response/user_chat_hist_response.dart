class UserChatHistResponse
{
  String agentname;
  String name;
  String DateTime;
  String duration;
  String CustBillRate;
  String AgentPayRate;
  String uniqueid;
  String AgentExtension;
  String EndDateTime;
  String cust_bbc;
  String agent_bill;
  String cust_bill_amt;
  String filename;
  String flag;


  UserChatHistResponse();

  factory UserChatHistResponse.fromJson(Map<String, dynamic> json) {
    UserChatHistResponse userDetails = new UserChatHistResponse();
    userDetails.agentname =  json["agentname"];
    userDetails.name =  json["name"];
    userDetails.DateTime =  json["DateTime"];
    userDetails.duration =  json["duration"];
    userDetails.CustBillRate =  json["CustBillRate"];
    userDetails.AgentPayRate =  json["AgentPayRate"];
    userDetails.uniqueid =  json["uniqueid"];
    userDetails.AgentExtension =  json["AgentExtension"];
    userDetails.EndDateTime =  json["EndDateTime"];
    userDetails.cust_bbc =  json["cust_bbc"];
    userDetails.agent_bill =  json["agent_bill"];
    userDetails.cust_bill_amt =  json["cust_bill_amt"];
    userDetails.filename =  json["filename"];
    userDetails.flag =  json["flag"];
    return userDetails;

  }
}