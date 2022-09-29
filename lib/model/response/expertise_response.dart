class ExpertiseDetail
{
  String id;
  String name;
  String is_active;

  ExpertiseDetail();

  factory ExpertiseDetail.fromJson(Map<String, dynamic> json) {
    ExpertiseDetail detail = new ExpertiseDetail();
    detail.id =  json["id"];
    detail.name =  json["name"];
    detail.is_active =  json["is_active"];
    return detail;

  }
}