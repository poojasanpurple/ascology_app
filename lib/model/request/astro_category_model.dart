class AstroCategoryRequestModel
{
  String service_id,expertise;

  AstroCategoryRequestModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'service_id': service_id.trim(),

      'expertise': expertise.trim(),
    };

    return map;
  }


}