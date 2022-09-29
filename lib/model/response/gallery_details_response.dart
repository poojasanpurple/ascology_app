class GalleryDetails
{
  String id;
  String image;
  String agent_id;
  String created_date;
  String is_active;



  GalleryDetails();

  factory GalleryDetails.fromJson(Map<String, dynamic> json) {
    GalleryDetails chatDetail = new GalleryDetails();
    chatDetail.id =  json["id"];
    chatDetail.agent_id =  json["agent_id"];
    chatDetail.created_date =  json["created_date"];
    chatDetail.is_active =  json["is_active"];
    chatDetail.image =  json["image"];

    return chatDetail;

  }


}