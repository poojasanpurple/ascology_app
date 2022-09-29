class SendFeedbackResponse
{
  bool status;
  String name;
  String user_id;
  String mobile;



  SendFeedbackResponse({
    this.status,
    this.name,
    this.user_id,
    this.mobile,
   });

  factory SendFeedbackResponse.fromJson(Map<String, dynamic> json){
    // LoginResponseModel loginResponseModel = new LoginResponseModel();
    return SendFeedbackResponse(
      status: json["status"] != null ? json["status"] : "",
      user_id: json["user_id"] != null ? json["user_id"] : "",
      mobile: json["mobile"] != null ? json["mobile"] : "",
      name: json["name"] != null ? json["name"] : "",


    );

  }

  /*
  SendFeedbackResponse();

  factory SendFeedbackResponse.fromJson(Map<String, dynamic> json) {
    SendFeedbackResponse followUser = new SendFeedbackResponse();
    followUser.status =  json["status"];
    followUser.name =  json["name"];
    followUser.user_id =  json["user_id"];
    followUser.mobile =  json["mobile"];

    return followUser;

  }*/
}