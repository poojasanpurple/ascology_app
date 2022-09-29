
class ReviewDetails
{
  String id;
  String agent_id;

  String id_user;
  String name;
  String comment;
  String agentname;
  String rating;



  ReviewDetails();

  factory ReviewDetails.fromJson(Map<String, dynamic> json) {
    ReviewDetails details = new ReviewDetails();
    details.id =  json["id"];
    details.agent_id =  json["agent_id"];
    details.id_user =  json["id_user"];
    details.name =  json["name"];
    details.comment =  json["comment"];
    details.agentname =  json["agentname"];
    details.rating =  json["rating"];

    return details;

  }
}