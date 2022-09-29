import 'package:ascology_app/model/response/astrologer_listing_response.dart';

class ServiceDetails
{
  String id;
  String title;
  String position;
  String image;
  String app_image;
  String slug;
  String description;
  String create_date;
  String modified_date;
  String is_active;

  ServiceDetails();

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    ServiceDetails details = new ServiceDetails();
    details.id =  json["id"];
    details.title =  json["title"];
    details.position =  json["position"];
    details.image =  json["image"];
    details.app_image =  json["app_image"];
    details.slug =  json["slug"];
    details.description =  json["description"];
    details.create_date =  json["create_date"];
    details.modified_date =  json["modified_date"];
    details.is_active =  json["is_active"];

    return details;

  }
}