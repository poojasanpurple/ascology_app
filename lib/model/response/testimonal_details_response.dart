class TestimonalDetails
{
  String id;
  String title;
  String position;
  String description;
  String image;
  String create_date;
  String modified_date;
  String is_active;



  TestimonalDetails({this.id, this.title, this.position,
      this.description, this.image, this.create_date, this.modified_date,
      this.is_active });

  factory TestimonalDetails.fromJson(Map<dynamic, dynamic> json) {
    TestimonalDetails testimonalDetails = new TestimonalDetails();
    testimonalDetails.id =  json["id"];
    testimonalDetails.title =  json["title"];
    testimonalDetails.position =  json["position"];
    testimonalDetails.description =  json["description"];
    testimonalDetails.image =  json["image"];
    testimonalDetails.create_date =  json["create_date"];
    testimonalDetails.modified_date =  json["modified_date"];
    testimonalDetails.is_active =  json["is_active"];


    return testimonalDetails;


  }

}