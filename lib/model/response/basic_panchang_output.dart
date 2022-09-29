import 'package:ascology_app/model/response/astrologer_listing_response.dart';

class BasicPanchangOutput
{
  String day;
  String tithi;
  String nakshatra;
  String yog;
  String karan;
  String sunrise;
  String sunset;
  String vedic_sunrise;
  String vedic_sunset;



  BasicPanchangOutput();

  factory BasicPanchangOutput.fromJson(Map<String, dynamic> json) {
    BasicPanchangOutput astrologerDetails = new BasicPanchangOutput();
    astrologerDetails.day =  json["ascendant"];
    astrologerDetails.tithi =  json["ascendant_lord"];
    astrologerDetails.nakshatra =  json["Varna"];
    astrologerDetails.yog =  json["Vashya"];
    astrologerDetails.karan =  json["Yoni"];
    astrologerDetails.sunrise =  json["Gan"];
    astrologerDetails.sunset =  json["Nadi"];
    astrologerDetails.vedic_sunrise =  json["SignLord"];
    astrologerDetails.vedic_sunset =  json["sign"];

    return astrologerDetails;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['tithi'] = this.tithi;
    data['nakshatra'] = this.nakshatra;
    data['yog'] = this.yog;
    data['karan'] = this.karan;
    data['sunrise'] = this.sunrise;
    data['sunset'] = this.sunset;
    data['vedic_sunrise'] = this.vedic_sunrise;
    data['vedic_sunset'] = this.vedic_sunset;
    return data;
  }
}