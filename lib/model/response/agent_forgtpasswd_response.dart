class AgentForgetPasswordResponseModel
{
  bool status;
  String message;
  String mobile;


  AgentForgetPasswordResponseModel();


  factory AgentForgetPasswordResponseModel.fromJson(Map<String, dynamic> json){
    AgentForgetPasswordResponseModel forgetPasswordResponseModel = new AgentForgetPasswordResponseModel();
    forgetPasswordResponseModel.status = json["status"];
    forgetPasswordResponseModel.message = json["message"];
    forgetPasswordResponseModel.mobile = json["mobile"];


    return forgetPasswordResponseModel;
  }

}