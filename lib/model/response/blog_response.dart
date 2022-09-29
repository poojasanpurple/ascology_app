import 'package:ascology_app/model/response/astrologer_list_detail.dart';
import 'package:ascology_app/model/response/blog_detail_response.dart';

class BlogListingResponse {
  bool status;
  String message;
  List<BlogDetails> data;

//  AstrologerListingResponse(this.status, this.message, [this.data]);

  BlogListingResponse();

  factory BlogListingResponse.fromJson(Map<dynamic, dynamic> json){
    BlogListingResponse blogListingResponse = new BlogListingResponse();
    blogListingResponse.status = json["status"];
    blogListingResponse.message = json["message"];

    var list = json["data"] as List;

    blogListingResponse.data = list.map((i) => BlogDetails.fromJson(i)).toList();

    return blogListingResponse;
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