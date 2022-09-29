class AgentOtpResponseModel
{
  bool status;
  String agent_id;
  String agentname;
  String mob;


  AgentOtpResponseModel();


  factory AgentOtpResponseModel.fromJson(Map<String, dynamic> json){
    AgentOtpResponseModel forgetPasswordResponseModel = new AgentOtpResponseModel();
    forgetPasswordResponseModel.status = json["status"];
    forgetPasswordResponseModel.agent_id = json["agent_id"];
    forgetPasswordResponseModel.agentname = json["agentname"];
    forgetPasswordResponseModel.mob = json["mob"];


    return forgetPasswordResponseModel;
  }

}