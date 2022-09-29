
class SlugDetails
{
  String id;
  String title;
  String short_description;
  String description;
  String image;
  String second_image;
  String slug;
  String create_date;
  String modified_date;
  String is_active;


  SlugDetails();

  factory SlugDetails.fromJson(Map<String, dynamic> json) {
    SlugDetails slugDetails = new SlugDetails();
    slugDetails.id =  json["id"];
    slugDetails.title =  json["title"];
    slugDetails.short_description =  json["short_description"];
    slugDetails.description =  json["description"];
    slugDetails.image =  json["image"];
    slugDetails.second_image =  json["second_image"];
    slugDetails.slug =  json["slug"];
    slugDetails.create_date =  json["create_date"];
    slugDetails.modified_date =  json["modified_date"];
    slugDetails.is_active =  json["is_active"];

    return slugDetails;

  }
}