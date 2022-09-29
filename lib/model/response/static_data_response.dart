
import 'package:ascology_app/model/response/slug_data_details.dart';

class DataResponseModel {
  bool status;
  String message;
  List<SlugDetails> data;

//  AstrologerListingResponse(this.status, this.message, [this.data]);

  DataResponseModel();

  factory DataResponseModel.fromJson(Map<dynamic, dynamic> json){
    DataResponseModel dataResponseModel = new DataResponseModel();
    dataResponseModel.status = json["status"];
    dataResponseModel.message = json["message"];

    var list = json["data"] as List;

    dataResponseModel.data = list.map((i) => SlugDetails.fromJson(i)).toList();

    return dataResponseModel;
  }

/*factory AstrologerListingResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      var tagObjsJson = json['data'] as List;
      List<AstrologerDetails> _astrologertags = tagObjsJson
          .map((tagJson) => AstrologerDetails.fromJson(tagJson))
          .toList();

      return AstrologerListingResponse(
          json['status'] as bool, json['message'], _astrologertags);
    }
  }*/
}