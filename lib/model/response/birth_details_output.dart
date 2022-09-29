import 'package:ascology_app/model/response/astrologer_listing_response.dart';

class BirthDetailsOutput
{
  String year;
  String month;
  String day;
  String hour;
  String minute;
  String latitude;
  String longitude;
  String timezone;
  String name;
  String seconds;
  String ayanamsha;
  String sunrise;
  String sunset;


  BirthDetailsOutput();

  factory BirthDetailsOutput.fromJson(Map<String, dynamic> json) {
    BirthDetailsOutput astrologerDetails = new BirthDetailsOutput();
    astrologerDetails.year =  json["year"];
    astrologerDetails.month =  json["month"];
    astrologerDetails.day =  json["day"];
    astrologerDetails.hour =  json["hour"];
    astrologerDetails.minute =  json["minute"];
    astrologerDetails.latitude =  json["latitude"];
    astrologerDetails.longitude =  json["longitude"];
    astrologerDetails.timezone =  json["timezone"];
    astrologerDetails.seconds =  json["seconds"];
    astrologerDetails.name =  json["name"];
    astrologerDetails.ayanamsha =  json["ayanamsha"];
    astrologerDetails.sunrise =  json["sunrise"];
    astrologerDetails.sunset =  json["sunset"];

    return astrologerDetails;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
    data['month'] = this.month;
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['minute'] = this.minute;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['timezone'] = this.timezone;
    data['name'] = this.name;
    data['seconds'] = this.seconds;
    data['ayanamsha'] = this.ayanamsha;
    data['sunrise'] = this.sunrise;
    data['sunset'] = this.sunset;
    return data;
  }
}