import 'package:ascology_app/model/response/wallet_details_response.dart';

class WalletResponseModel
{
  bool status;
  String message;
  List<WalletDetails> data;

  WalletResponseModel();

  factory WalletResponseModel.fromJson(Map<dynamic, dynamic> json){
    WalletResponseModel walletResponseModel = new WalletResponseModel();
    walletResponseModel.status = json["status"];
    walletResponseModel.message = json["message"];

    var list = json["data"] as List;

    walletResponseModel.data = list.map((i) => WalletDetails.fromJson(i)).toList();

    return walletResponseModel;
  }
}