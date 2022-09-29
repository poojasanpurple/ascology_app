class ReviewResponseModel
{
  bool status;
  String message;

  ReviewResponseModel();


  factory ReviewResponseModel.fromJson(Map<String, dynamic> json){
    ReviewResponseModel forgetPasswordResponseModel = new ReviewResponseModel();
    forgetPasswordResponseModel.status = json["status"];
    forgetPasswordResponseModel.message = json["message"];

    return forgetPasswordResponseModel;
  }

}