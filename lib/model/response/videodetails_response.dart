class VideoDetailsResponse
{
  String id;
  String video;
  String agent_id;
  String created_date;
  String is_active;



  VideoDetailsResponse();

  factory VideoDetailsResponse.fromJson(Map<String, dynamic> json) {
    VideoDetailsResponse chatDetail = new VideoDetailsResponse();
    chatDetail.id =  json["id"];
    chatDetail.agent_id =  json["agent_id"];
    chatDetail.created_date =  json["created_date"];
    chatDetail.is_active =  json["is_active"];
    chatDetail.video =  json["video"];

    return chatDetail;

  }


}