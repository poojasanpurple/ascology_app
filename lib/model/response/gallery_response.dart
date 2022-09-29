import 'package:ascology_app/model/response/gallery_details_response.dart';
import 'package:ascology_app/model/response/testimonal_details_response.dart';

class GalleryResponse
{
  bool status;
  String message;
  List<GalleryDetails> data;

//  AstrologerListingResponse(this.status, this.message, [this.data]);

  GalleryResponse();

  factory GalleryResponse.fromJson(Map<dynamic, dynamic> json){
    GalleryResponse galleryResponse = new GalleryResponse();
    galleryResponse.status = json["status"];
    galleryResponse.message = json["message"];

    var list = json["data"] as List;

    galleryResponse.data = list.map((i) => GalleryDetails.fromJson(i)).toList();

    return galleryResponse;
  }


}