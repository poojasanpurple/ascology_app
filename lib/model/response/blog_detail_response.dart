
class BlogDetails
{
  String id;
  String title;
  String description;
  String image;
  String create_date;
  String modified_date;
  String is_active;
  String heading;
  String id_service;

  BlogDetails();

  factory BlogDetails.fromJson(Map<String, dynamic> json) {
    BlogDetails blogDetails = new BlogDetails();
    blogDetails.id =  json["id"];
    blogDetails.title =  json["title"];
    blogDetails.description =  json["description"];
    blogDetails.image =  json["image"];
    blogDetails.create_date =  json["create_date"];
    blogDetails.modified_date =  json["modified_date"];
    blogDetails.is_active =  json["is_active"];
    blogDetails.heading =  json["heading"];
    blogDetails.id_service =  json["id_service"];
    return blogDetails;

  }
}