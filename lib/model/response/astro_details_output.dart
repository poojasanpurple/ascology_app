import 'package:ascology_app/model/response/astrologer_listing_response.dart';

class AstroDetailsOutput
{
  String ascendant;
  String ascendant_lord;
  String Varna;
  String Vashya;
  String Yoni;
  String Gan;
  String Nadi;
  String SignLord;
  String sign;
  String Naksahtra;
  String NaksahtraLord;
  String Charan;
  String Yog;
  String Karan;
  String Tithi;
  String yunja;
  String tatva;
  String name_alphabet;
  String paya;


  AstroDetailsOutput();

  factory AstroDetailsOutput.fromJson(Map<String, dynamic> json) {
    AstroDetailsOutput astrologerDetails = new AstroDetailsOutput();
    astrologerDetails.ascendant =  json["ascendant"];
    astrologerDetails.ascendant_lord =  json["ascendant_lord"];
    astrologerDetails.Varna =  json["Varna"];
    astrologerDetails.Vashya =  json["Vashya"];
    astrologerDetails.Yoni =  json["Yoni"];
    astrologerDetails.Gan =  json["Gan"];
    astrologerDetails.Nadi =  json["Nadi"];
    astrologerDetails.SignLord =  json["SignLord"];
    astrologerDetails.sign =  json["sign"];
    astrologerDetails.Naksahtra =  json["Naksahtra"];
    astrologerDetails.NaksahtraLord =  json["NaksahtraLord"];
    astrologerDetails.Charan =  json["Charan"];
    astrologerDetails.Yog =  json["Yog"];
    astrologerDetails.Karan =  json["Karan"];
    astrologerDetails.Tithi =  json["Tithi"];
    astrologerDetails.yunja =  json["yunja"];
    astrologerDetails.tatva =  json["tatva"];
    astrologerDetails.name_alphabet =  json["name_alphabet"];
    astrologerDetails.paya =  json["paya"];

    return astrologerDetails;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ascendant'] = this.ascendant;
    data['ascendant_lord'] = this.ascendant_lord;
    data['Varna'] = this.Varna;
    data['Vashya'] = this.Vashya;
    data['Yoni'] = this.Yoni;
    data['Gan'] = this.Gan;
    data['Nadi'] = this.Nadi;
    data['SignLord'] = this.SignLord;
    data['sign'] = this.sign;
    data['Naksahtra'] = this.Naksahtra;
    data['NaksahtraLord'] = this.NaksahtraLord;
    data['Charan'] = this.Charan;
    data['Yog'] = this.Yog;
    data['Karan'] = this.Karan;
    data['Tithi'] = this.Tithi;
    data['yunja'] = this.yunja;
    data['tatva'] = this.tatva;
    data['name_alphabet'] = this.name_alphabet;
    data['paya'] = this.paya;
    return data;
  }
}