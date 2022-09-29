class DataRequestModel
{
  String slug;

  DataRequestModel();



  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'slug': slug.trim(),

    };

    return map;
  }


}