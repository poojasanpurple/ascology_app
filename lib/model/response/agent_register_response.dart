class AgentRegisterResponseModel
{
  bool status;
  String message;

  AgentRegisterResponseModel();


  factory AgentRegisterResponseModel.fromJson(Map<String, dynamic> json){
    AgentRegisterResponseModel agentRegisterResponseModel = new AgentRegisterResponseModel();
    agentRegisterResponseModel.status = json["status"];
    agentRegisterResponseModel.message = json["message"];

    return agentRegisterResponseModel;
  }

}