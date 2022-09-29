class AstroRequestModel
{
  String price,search,expertise,service_id,user_id;

  AstroRequestModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'search': search.trim(),
      'price': price.trim(),
      'expertise': expertise.trim(),
      'service_id': service_id.trim(),
      'user_id': user_id.trim(),
    };

    return map;
  }


}