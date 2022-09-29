import 'package:ascology_app/model/response/testimonal_details_response.dart';

class TestimonalResponse
{
  bool status;
  String message;
  List<TestimonalDetails> data;

//  AstrologerListingResponse(this.status, this.message, [this.data]);

  TestimonalResponse();

  factory TestimonalResponse.fromJson(Map<dynamic, dynamic> json){
    TestimonalResponse testimonalResponse = new TestimonalResponse();
    testimonalResponse.status = json["status"];
    testimonalResponse.message = json["message"];

    var list = json["data"] as List;

    testimonalResponse.data = list.map((i) => TestimonalDetails.fromJson(i)).toList();

    return testimonalResponse;
  }


}