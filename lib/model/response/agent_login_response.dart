class AgentLoginResponseModel
{
  bool status;
  String message;
  String agent_id;
  String mobile;
  String name;
  String device_name;
  String device_model;
  String apk_version;
  String imei_number;
  String extension;
  String password;
  String token;

  AgentLoginResponseModel();


  factory AgentLoginResponseModel.fromJson(Map<String, dynamic> json){
    AgentLoginResponseModel agentLoginResponseModel = new AgentLoginResponseModel();
    agentLoginResponseModel.status = json["status"];
    agentLoginResponseModel.message = json["message"];
    agentLoginResponseModel.agent_id = json["agent_id"];
   agentLoginResponseModel.mobile = json["mobile"];
    agentLoginResponseModel.name = json["name"];
    agentLoginResponseModel.device_name = json["device_name"];
    agentLoginResponseModel.device_model = json["device_model"];
    agentLoginResponseModel.apk_version = json["apk_version"];
    agentLoginResponseModel.imei_number = json["imei_number"];
    agentLoginResponseModel.extension = json["extension"];
    agentLoginResponseModel.password = json["password"];
    agentLoginResponseModel.token = json["token"];

    return agentLoginResponseModel;
  }

}