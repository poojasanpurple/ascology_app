class CategoryModel{
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

  CategoryModel();

  CategoryModel.initial(
      this.id,
      this.title,
      this.position,
      this.image,
      this.app_image,
      this.slug,
      this.description,
      this.create_date,
      this.modified_date,
      this.is_active);

  factory CategoryModel.fromJson(Map<String, dynamic> json){
    CategoryModel serviceTypeResModel = new CategoryModel();
    serviceTypeResModel.id = json["Id"];
    serviceTypeResModel.title = json["title"];
    serviceTypeResModel.position = json["position"];
    serviceTypeResModel.image = json["image"];
    serviceTypeResModel.app_image = json["app_image"];
    serviceTypeResModel.slug = json["slug"];
    serviceTypeResModel.description = json["description"];
    serviceTypeResModel.create_date = json["create_date"];
    serviceTypeResModel.modified_date = json["modified_date"];
    serviceTypeResModel.is_active = json["AddedOn"];
    return serviceTypeResModel;
  }




}