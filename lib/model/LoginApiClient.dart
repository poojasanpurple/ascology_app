import 'dart:convert';

import 'package:ascology_app/global/http_web_call.dart';
import 'package:ascology_app/model/request/NewAgentRequestModel.dart';
import 'package:ascology_app/model/request/NotifySendRequest.dart';
import 'package:ascology_app/model/request/agent_callhistory_request.dart';
import 'package:ascology_app/model/request/agent_chat_hist_request.dart';
import 'package:ascology_app/model/request/agent_follow_request.dart';
import 'package:ascology_app/model/request/agent_forgetpasswd_request.dart';
import 'package:ascology_app/model/request/agent_login_request.dart';
import 'package:ascology_app/model/request/agent_register_request.dart';
import 'package:ascology_app/model/request/agent_reject_request.dart';
import 'package:ascology_app/model/request/agent_request_model.dart';
import 'package:ascology_app/model/request/agent_update_profile.dart';
import 'package:ascology_app/model/request/agent_video_request.dart';
import 'package:ascology_app/model/request/astro_category_model.dart';
import 'package:ascology_app/model/request/astro_request.dart';
import 'package:ascology_app/model/request/astro_request_model.dart';
import 'package:ascology_app/model/request/available_agent_request.dart';
import 'package:ascology_app/model/request/birthdetails_request.dart';
import 'package:ascology_app/model/request/chat_send_request.dart';
import 'package:ascology_app/model/request/check_endchat_request.dart';
import 'package:ascology_app/model/request/contact_request.dart';
import 'package:ascology_app/model/request/delete_queue_agentrequest.dart';
import 'package:ascology_app/model/request/forget_passwd_request.dart';
import 'package:ascology_app/model/request/get_chat_request.dart';
import 'package:ascology_app/model/request/get_status_request.dart';
import 'package:ascology_app/model/request/login_request.dart';
import 'package:ascology_app/model/request/resent_otp_request.dart';
import 'package:ascology_app/model/request/review_request_model.dart';
import 'package:ascology_app/model/request/static_data_request.dart';
import 'package:ascology_app/model/request/update_chatstatus_request.dart';
import 'package:ascology_app/model/request/update_status_request.dart';
import 'package:ascology_app/model/request/user_callhistory_request.dart';
import 'package:ascology_app/model/request/user_feedback_request.dart';
import 'package:ascology_app/model/request/user_mobile_request.dart';
import 'package:ascology_app/model/request/user_payment_request.dart';
import 'package:ascology_app/model/request/user_register_request.dart';
import 'package:ascology_app/model/request/user_request.dart';
import 'package:ascology_app/model/request/user_update_profile.dart';
import 'package:ascology_app/model/request/user_verifyotp_request.dart';
import 'package:ascology_app/model/request/userchng_passwd_request.dart';
import 'package:ascology_app/model/response/AgentStatus_Response.dart';
import 'package:ascology_app/model/response/agent_chat_detail.dart';
import 'package:ascology_app/model/response/agent_chat_msg.dart';
import 'package:ascology_app/model/response/agent_forgtpasswd_response.dart';
import 'package:ascology_app/model/response/agent_login_response.dart';
import 'package:ascology_app/model/response/agent_otp_response.dart';
import 'package:ascology_app/model/response/agent_register_response.dart';
import 'package:ascology_app/model/response/astrologer_agentstatus.dart';
import 'package:ascology_app/model/response/astrologer_list_detail.dart';
import 'package:ascology_app/model/response/astrologer_listing_response.dart';
import 'package:ascology_app/model/response/astrologer_premium_response.dart';
import 'package:ascology_app/model/response/birth_details_response.dart';
import 'package:ascology_app/model/response/category_model.dart';
import 'package:ascology_app/model/response/check_follow_user_response.dart';
import 'package:ascology_app/model/response/expertise_response.dart';
import 'package:ascology_app/model/response/feedback_response.dart';
import 'package:ascology_app/model/response/followers_response.dart';
import 'package:ascology_app/model/response/gallery_details_response.dart';
import 'package:ascology_app/model/response/gallery_response.dart';
import 'package:ascology_app/model/response/get_chat_listing.dart';
import 'package:ascology_app/model/response/get_chat_listing_response.dart';
import 'package:ascology_app/model/response/get_status_response.dart';
import 'package:ascology_app/model/response/login_response.dart';
import 'package:ascology_app/model/response/my_wallet_response.dart';
import 'package:ascology_app/model/response/otp_response.dart';
import 'package:ascology_app/model/response/review_detail.dart';
import 'package:ascology_app/model/response/review_response.dart';
import 'package:ascology_app/model/response/service_details_response.dart';
import 'package:ascology_app/model/response/static_data_response.dart';
import 'package:ascology_app/model/response/testimonal_response.dart';
import 'package:ascology_app/model/response/user_chat_hist_response.dart';
import 'package:ascology_app/model/response/user_chat_list_response.dart';
import 'package:ascology_app/model/response/user_chatlist_detail.dart';
import 'package:ascology_app/model/response/user_chngpasswd_response.dart';
import 'package:ascology_app/model/response/user_response.dart';
import 'package:ascology_app/model/response/user_transaction_response.dart';
import 'package:ascology_app/model/response/usercall_history_reponse.dart';
import 'package:ascology_app/model/response/userforget_passwd_response.dart';
import 'package:ascology_app/model/response/videodetails_response.dart';
import 'package:ascology_app/utility/app_url.dart';
import 'package:http/http.dart' as http;

class LoginApiClient {
  HttpWebCall webClient = HttpWebCall();

  // user login
  Future<LoginResponseModel> loginUser(LoginRequestModel loginRequestModel) async {

    try {
      final response = await http.post(AppUrl.user_login, body:loginRequestModel.toJson());

      if (response.statusCode == 200 ||  response.statusCode == 400) {
        return LoginResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }


    } catch (e) {
      print(e);
      return null;
    }
  }

  // user resend otp

  Future<OtpResponseModel> user_resendotp(ResendOtpRequestModel loginRequestModel) async {
    try{

      final response = await http.post(AppUrl.user_resendotp, body: loginRequestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return OtpResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }

    } catch (e) {
      print(e);
      return null;
    }

  }


  // agent resend otp

  Future<OtpResponseModel> agent_resendotp(ResendOtpRequestModel loginRequestModel) async {
    try{

      final response = await http.post(AppUrl.agent_resendotp, body: loginRequestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return OtpResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }

    } catch (e) {
      print(e);
      return null;
    }

  }


  //agent login
  Future<AgentLoginResponseModel> agentlogin(AgentLoginRequestModel loginRequestModel) async {
    try{

    final response = await http.post(AppUrl.agent_login, body: loginRequestModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      return AgentLoginResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to load data!');
    }

    } catch (e) {
      print(e);
      return null;
    }

  }

  //update agent profile
  Future<UserChangePasswordResponseModel> updateagent(AgentUpdateProfileRequest loginRequestModel) async {
    try{

      final response = await http.post(AppUrl.update_agent_profile, body: loginRequestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return UserChangePasswordResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }

    } catch (e) {
      print(e);
      return null;
    }

  }



  //update user profile
  Future<UserChangePasswordResponseModel> updateuser(UserUpdateProfileRequest loginRequestModel) async {
    try{

    final response = await http.post(AppUrl.update_user_profile, body: loginRequestModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      return UserChangePasswordResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to load data!');
    }

    } catch (e) {
      print(e);
      return null;
    }

  }


  //upload youtube video url by agent
  Future<UserChangePasswordResponseModel> uploadvideo(AgentVideoRequestModel loginRequestModel) async {
    try{

      final response = await http.post(AppUrl.submit_upload_video, body: loginRequestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return UserChangePasswordResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }

    } catch (e) {
      print(e);
      return null;
    }

  }

  //get agent call , chat  status

  Future<StatusResponse> get_status_call(StatusRequestModel loginRequestModel) async {
    try{

      final response = await http.post(AppUrl.get_timetable_data, body: loginRequestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return StatusResponse.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }

    } catch (e) {
      print(e);
      return null;
    }

  }



  //update call, chat status  for agent

  Future<UserChangePasswordResponseModel> update_status(UpdateStatusRequest loginRequestModel) async {
    try{

      final response = await http.post(AppUrl.update_weekly_timetable, body: loginRequestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return UserChangePasswordResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }

    } catch (e) {
      print(e);
      return null;
    }

  }

  //user forget password

  Future<UserForgetPasswordResponseModel> userforgotPassword(UserForgetPasswdRequestModel forgetPasswdRequestModel) async {
    try{

      final response = await http.post(AppUrl.user_forget_password, body: forgetPasswdRequestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return UserForgetPasswordResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }


    } catch (e) {
      print(e);
      return null;
    }
  }

  //update agent chat status

  Future<UserChangePasswordResponseModel> updatechatstatus(UpdateChatStatusRequestModel forgetPasswdRequestModel) async {
    try{

      final response = await http.post(AppUrl.update_agent_chatstatus, body: forgetPasswdRequestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return UserChangePasswordResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }


    } catch (e) {
      print(e);
      return null;
    }
  }


  //update user chat status

  Future<UserChangePasswordResponseModel> updateuserchatstatus(UpdateChatStatusRequestModel forgetPasswdRequestModel) async {
    try{

      final response = await http.post(AppUrl.update_user_chatstatus, body: forgetPasswdRequestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return UserChangePasswordResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }


    } catch (e) {
      print(e);
      return null;
    }
  }


  //get gallery data
  Future<List<VideoDetailsResponse>> getvideos() async {
    List<VideoDetailsResponse> list;

    var response = await http.post(AppUrl.fetch_video, body:'');

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<VideoDetailsResponse>((json) => VideoDetailsResponse.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }


  // agent reject user chat

  Future<UserForgetPasswordResponseModel> agent_reject_user_chat(AgentRejectRequest forgetPasswdRequestModel) async {
    try{

      final response = await http.post(AppUrl.reject_agentuser_chat, body: forgetPasswdRequestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return UserForgetPasswordResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }


    } catch (e) {
      print(e);
      return null;
    }
  }

  //accept agent to user chat

  Future<UserForgetPasswordResponseModel> agent_user_chat(AgentRejectRequest forgetPasswdRequestModel) async {
    try{

      final response = await http.post(AppUrl.agent_user_chat, body: forgetPasswdRequestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return UserForgetPasswordResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }


    } catch (e) {
      print(e);
      return null;
    }
  }


  //agent follow/unfollow

  Future<UserChangePasswordResponseModel> sendfollowagent(AgentFollowRequestModel requestModel) async {
    try{

      final response = await http.post(AppUrl.submit_follow_agent, body: requestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return UserChangePasswordResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }


    } catch (e) {
      print(e);
      return null;
    }
  }

  //user change password

  Future<UserChangePasswordResponseModel> userchangepassword(UserChangePasswordRequest passwordRequest) async {
    try{

      final response = await http.post(AppUrl.user_newpassword, body: passwordRequest.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return UserChangePasswordResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }


    } catch (e) {
      print(e);
      return null;
    }
  }


  //agent change password

  Future<UserChangePasswordResponseModel> agentchngpassword(UserChangePasswordRequest passwordRequest) async {
    try{

      final response = await http.post(AppUrl.agent_newpassword, body: passwordRequest.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return UserChangePasswordResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }


    } catch (e) {
      print(e);
      return null;
    }
  }


  // agent forget password
  Future<AgentForgetPasswordResponseModel> agentforgotPassword(
      AgentForgetPasswdRequestModel forgetPasswdRequestModel) async {

    try{

      final response = await http.post(AppUrl.agent_forget_pwd, body: forgetPasswdRequestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return AgentForgetPasswordResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }


    } catch (e) {
      print(e);
      return null;
    }



  }

  //register user

  Future<UserForgetPasswordResponseModel> registerUser(UserRegisterRequestModel registerModel) async {
    try{

      final response = await http.post(AppUrl.user_signup, body: registerModel.toJson());

      if(response.statusCode == 200 || response.statusCode ==400)
      {
      return UserForgetPasswordResponseModel.fromJson(json.decode(response.body),
      );

      }
      else{
        throw Exception('Failed to load data!');
      }


    } catch (e) {
      print(e);
      return null;
    }
  }

  //send notification

  Future<UserChangePasswordResponseModel> send_notification(NotifySendRequestModel registerModel) async {
    try{

      final response = await http.post(AppUrl.send_user_to_agent_noti, body: registerModel.toJson());

      if(response.statusCode == 200 || response.statusCode ==400)
      {
        return UserChangePasswordResponseModel.fromJson(json.decode(response.body),
        );

      }
      else{
        throw Exception('Failed to load data!');
      }


    } catch (e) {
      print(e);
      return null;
    }
  }


  //send chat  msg to agent by user

  Future<UserChangePasswordResponseModel> sendmsgtoagent(ChatSendRequestModel registerModel) async {
    try{

      final response = await http.post(AppUrl.chat_save, body: registerModel.toJson());

      if(response.statusCode == 200 || response.statusCode ==400)
      {
        return UserChangePasswordResponseModel.fromJson(json.decode(response.body),
        );

      }
      else{
        throw Exception('Failed to load data!');
      }


    } catch (e) {
      print(e);
      return null;
    }
  }

  //check end chat
  Future<StatusResponse> checkendchat(CheckendChatRequestModel registerModel) async {
    try{

      final response = await http.post(AppUrl.chat_status, body: registerModel.toJson());

      if(response.statusCode == 200 || response.statusCode ==400)
      {
        return StatusResponse.fromJson(json.decode(response.body),
        );

      }
      else{
        throw Exception('Failed to load data!');
      }


    } catch (e) {
      print(e);
      return null;
    }
  }

  //send chat  msg to user by agent
  Future<UserChangePasswordResponseModel> sendmsgtouser(ChatSendRequestModel registerModel) async {
    try{

      final response = await http.post(AppUrl.chat_save_agent, body: registerModel.toJson());

      if(response.statusCode == 200 || response.statusCode ==400)
      {
        return UserChangePasswordResponseModel.fromJson(json.decode(response.body),
        );

      }
      else{
        throw Exception('Failed to load data!');
      }


    } catch (e) {
      print(e);
      return null;
    }
  }


  //send payment details

  Future<UserChangePasswordResponseModel> sendpaymentdetails(UserPaymentRequestModel registerModel) async {
    try{

      final response = await http.post(AppUrl.payment_success, body: registerModel.toJson());

      if(response.statusCode == 200 || response.statusCode ==400)
      {
        return UserChangePasswordResponseModel.fromJson(json.decode(response.body),
        );

      }
      else{
        throw Exception('Failed to load data!');
      }


    } catch (e) {
      print(e);
      return null;
    }
  }

  //register agent


  Future<AgentRegisterResponseModel> agentregister(AgentRegisterRequestModel registerModel) async {
    try{

      final response = await http.post(AppUrl.agent_registration, body: registerModel.toJson());

      if(response.statusCode == 200 || response.statusCode ==400)
      {
        return AgentRegisterResponseModel.fromJson(json.decode(response.body),
        );

      }
      else{
        throw Exception('Failed to load data!');
      }


/* if (response == null) {
        return null;
      } else {
        print(response);
        Map<String, dynamic> data = json.decode(response);
        print(response);
        int responseCode = data["responseCode"];
        if (responseCode == 200) {
          Map<String, dynamic> response = data["output"];
          return UserForgetPasswordResponseModel.fromJson(response);
        } else {
          return null;
        }
      }*/

    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<AgentOtpResponseModel> agentverifyotp(UserVerifyOtpRequest userVerifyOtp) async {

print('send'+userVerifyOtp.toJson().toString());
    try {
      final response = await http.post(AppUrl.agent_verify_otp, body: userVerifyOtp.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return AgentOtpResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }

      /* if (response == null) {
        return null;
      } else {
        print(response);
        Map<String, dynamic> data = json.decode(response);
        print(response);
        int responseCode = data["responseCode"];
        if (responseCode == 200) {
          Map<String, dynamic> response = data["output"];
          return UserForgetPasswordResponseModel.fromJson(response);
        } else {
          return null;
        }
      }*/
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserForgetPasswordResponseModel> userverifyotp(UserVerifyOtpRequest userVerifyOtp) async {


    try {
      final response = await http.post(AppUrl.user_verify_otp, body: userVerifyOtp.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return UserForgetPasswordResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }

     /* if (response == null) {
        return null;
      } else {
        print(response);
        Map<String, dynamic> data = json.decode(response);
        print(response);
        int responseCode = data["responseCode"];
        if (responseCode == 200) {
          Map<String, dynamic> response = data["output"];
          return UserForgetPasswordResponseModel.fromJson(response);
        } else {
          return null;
        }
      }*/
    } catch (e) {
      print(e);
      return null;
    }
  }

  //send review
  Future<ReviewResponseModel> send_review(ReviewRequestModel feedbackModel) async {

    try {
      final response = await http.post(AppUrl.astrologer_review, body:feedbackModel.toJson());

      if (response.statusCode == 200) {
        return ReviewResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }

    } catch (e) {
      print(e);
      return null;
    }
  }

  //send user feedback
  Future<SendFeedbackResponse> send_user_feedback(UserFeedbackModel feedbackModel) async {

    try {
      final response = await http.post(AppUrl.user_feedback, body:feedbackModel.toJson());

      if (response.statusCode == 200) {
        return SendFeedbackResponse.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }

    } catch (e) {
      print(e);
      return null;
    }
  }

  //send delete from queue for agent
  Future<UserChangePasswordResponseModel> delete_queue_member_record(AgentDelRequestModel feedbackModel) async {

    try {
      final response = await http.post(AppUrl.delete_queue_member_record, body:feedbackModel.toJson());

      if (response.statusCode == 200 || response.statusCode == 400) {
        return UserChangePasswordResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }

    } catch (e) {
      print(e);
      return null;
    }
  }

  //get chat list
 // List<ChatDetails> dataFromServer = List();

/*
    Future<List<GetChatListingResponse>> getchatlist(GetChatListRequestModel requestModel) async {
      //  print(request);


      var response = await webClient.post(AppUrl.chat_data_return, body:requestModel);


      if(response != null){
        Map<String, dynamic> responseMap = json.decode(response);
        int responseCode = responseMap["responseCode"];
        if(responseCode == 200){
          var output = responseMap["data"] as List;
          List<TestimonalResponse> requestListRes = output.map((i) => TestimonalResponse.fromJson(i)).toList();
          return requestListRes;
        }
      }
      return null;


      try {
        final response = await http.post(AppUrl.chat_data_return, body: requestModel.toJson());
        Map<String, dynamic> responseMap = json.decode(response.body);

        if (response == null) {
          return null;
        } else {
          var responseJson = json.decode(response);
          if (responseJson["responseCode"] == 200) {
            print("DADT ------- :${responseJson}");
            dataFromServer = (responseJson['output'] as List).map((p) => ChatDetails.fromJson(p)).toList();
            return dataFromServer;
          } else {
            return null;
          }
        }
      } catch (e) {
        print(e);
        return null;
      }
    }
*/


  //get astrologers list

  Future<List<AstrologerListingResponse>> getastrologerslist() async {
    //  print(request);

    try {
      final response = await http.post(AppUrl.astrologer_listing, body: '');
      Map<String, dynamic> responseMap = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        var output = responseMap["data"] as List;
        List<AstrologerListingResponse> requestListRes = output.map((i) =>
            AstrologerListingResponse.fromJson(i)).toList();
        return requestListRes;
      } else {
        throw Exception('Failed to load data!');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

   /* var response = await _webCall.post(Webservices.getConfirmedCustomers, request);

    print(response);

    if(response != null){
      Map<String, dynamic> responseMap = json.decode(response);
      int responseCode = responseMap["responseCode"];
      if(responseCode == 200){
        var output = responseMap["output"] as List;
        List<GetServiceRequestResModel> requestListRes = output.map((i) => GetServiceRequestResModel.fromJson(i)).toList();
        return requestListRes;
      }
    }
    return null;
  */

  Future<List<AstrologerListingResponse>> getastrologers() async {

    var response = await webClient.post(AppUrl.astrologer_listing, '');

    if(response != null){
      Map<String, dynamic> responseMap = json.decode(response);
      int responseCode = responseMap["responseCode"];
      if(responseCode == 200){

        var decodedJson = json.decode(response);
        List jsondata = decodedJson['data'];
        jsondata
            .map((item) => AstrologerDetails.fromJson(item as Map<String, dynamic>))
            .toList();
        return jsondata;
       /* var output = responseMap["data"] as List;
        List<AstrologerListingResponse> requestListRes = output.map((i) => AstrologerListingResponse.fromJson(i)).toList();
     print(requestListRes.length);
        return requestListRes;*/

      }
    }
    return null;

    /*if (response == null) {
      return null;
    } else {
      Map<String, dynamic> data = json.decode(response);

      int responseCode = data["responseCode"];
      print('data ;-$data');
      if (responseCode == 200) {
        var output = data["data"] as List;
        List<AstrologerListingResponse> requestListRes = output.map((i) =>
            AstrologerListingResponse.fromJson(i)).toList();
        return requestListRes;

      } else {
        return null;
      }
    }*/
  }


  //get astrologer images

  Future<AstrologerListingResponse> getastroimages(AstrologerRequestModel astrologerRequestModel) async {
    try {
      final response = await http.post(
          AppUrl.get_image_data, body: astrologerRequestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return AstrologerListingResponse.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
  //get selected astrologerdetails

  Future<AstrologerListingResponse> getastrologerdetails(AstrologerRequestModel astrologerRequestModel) async {
    try {
      final response = await http.post(
          AppUrl.astrologer_details, body: astrologerRequestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return AstrologerListingResponse.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  //get selected agent call status

  Future<AgentStatusListingResponse> getcallstatus(AstrologerRequestModel astrologerRequestModel) async {
    try {
      final response = await http.post(
          AppUrl.queue_agent, body: astrologerRequestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return AgentStatusListingResponse.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  //get  agent profile details

  Future<AstrologerListingResponse> getagentprofile(AgentRequestModel requestModel) async {
    try {
      final response = await http.post(
          AppUrl.agent_my_profiles, body: requestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return AstrologerListingResponse.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }


  //get  wallet balance

  Future<WalletResponseModel> getwalletbalance(UserRequestModel requestModel) async {
    try {
      final response = await http.post(
          AppUrl.my_wallet, body: requestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return WalletResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }





  //get  user profile details

  Future<UserListingResponse> getprofiledetails(UserRequestModel requestModel) async {
    try {
      final response = await http.post(
          AppUrl.user_my_profiles, body: requestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return UserListingResponse.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }


  //get aboutus,terms and conditions, pivacy policy
  Future<DataResponseModel> getstaticdetails(DataRequestModel dataRequestModel) async {
    try {
      final response = await http.post(
          AppUrl.get_static_data, body: dataRequestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        return DataResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load data!');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  //submit contact form


  Future<AgentRegisterResponseModel> submitcontact(ContactRequestModel contactRequestModel) async {
    try{

      final response = await http.post(AppUrl.contactus, body: contactRequestModel.toJson());

      if(response.statusCode == 200 || response.statusCode ==400)
      {
        return AgentRegisterResponseModel.fromJson(json.decode(response.body),
        );

      }
      else{
        throw Exception('Failed to load data!');
      }


    } catch (e) {
      print(e);
      return null;
    }
  }
  //get gallery data
  Future<List<GalleryDetails>> getgallery() async {
    List<GalleryDetails> list;

    var response = await http.post(AppUrl.fetch_gallary, body:'');

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<GalleryDetails>((json) => GalleryDetails.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }


  //get premium astrologers
  Future<List<AstrologerDetailsNew>> getpremiumdata(UserRequestModel requestModel) async {
    List<AstrologerDetailsNew> list;

    var response = await http.post(AppUrl.primium_list, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<AstrologerDetailsNew>((json) => AstrologerDetailsNew.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }



  //get testimonal data
  Future<List<TestimonalResponse>> gettestimonals() async {

    var response = await webClient.post(AppUrl.testimonal_data, '');


    if(response != null){
      Map<String, dynamic> responseMap = json.decode(response);
      int responseCode = responseMap["responseCode"];
      if(responseCode == 200){
        var output = responseMap["data"] as List;
        List<TestimonalResponse> requestListRes = output.map((i) => TestimonalResponse.fromJson(i)).toList();
        return requestListRes;
      }
    }
    return null;

  }

  //check which user follows which agent
  Future<List<CheckFollowUser>> checkfollowagent(UserRequestModel requestModel) async {
    List<CheckFollowUser> list;

    var response = await http.post(AppUrl.follow_user_listing, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<CheckFollowUser>((json) => CheckFollowUser.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }


  //get agent reviews
  Future<List<ReviewDetails>> getagentreviews(NewAgentRequestModel requestModel) async {
    List<ReviewDetails> list;

    var response = await http.post(AppUrl.agent_review_data, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<ReviewDetails>((json) => ReviewDetails.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }

  //get number of followers data
  Future<List<FollowersDetails>> getcountoffollowers(AgentRequestModel requestModel) async {
    List<FollowersDetails> list;

    var response = await http.post(AppUrl.follow_agent_listing, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<FollowersDetails>((json) => FollowersDetails.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }

  //get chatdetail data
  Future<List<ChatDetails>> getuserdetailchat(GetChatListRequestModel requestModel) async {
    List<ChatDetails> list;

    var response = await http.post(AppUrl.chat_data_return, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<ChatDetails>((json) => ChatDetails.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }
  //get userchats data
  Future<List<UserChatDetail>> postchatdata(UserRequestModel requestModel) async {
    List<UserChatDetail> list;

    var response = await http.post(AppUrl.chat_users, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<UserChatDetail>((json) => UserChatDetail.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }

  //get agent call history
  Future<List<CallHistoryResponse>> getagentcallhistory(AgentCallHistoryRequestModel requestModel) async {
    List<CallHistoryResponse> list;

    var response = await http.post(AppUrl.call_history_agent, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<CallHistoryResponse>((json) => CallHistoryResponse.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }

  //get user call history
  Future<List<CallHistoryResponse>> getusercallhistory(UserCallHistoryRequestModel requestModel) async {
    List<CallHistoryResponse> list;

    var response = await http.post(AppUrl.call_history_user, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<CallHistoryResponse>((json) => CallHistoryResponse.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }

  //get user chat history
  Future<List<UserChatHistResponse>> getuserchathistory(UserChatHistRequest requestModel) async {
    List<UserChatHistResponse> list;

    var response = await http.post(AppUrl.fetch_chatCDR, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<UserChatHistResponse>((json) => UserChatHistResponse.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }

  //get agent chat history
  Future<List<UserChatHistResponse>> getagentchathistory(AgentChatHistRequest requestModel) async {
    List<UserChatHistResponse> list;

    var response = await http.post(AppUrl.fetch_chatCDR_agent, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<UserChatHistResponse>((json) => UserChatHistResponse.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }



  //get birth details

  Future<List<BirthDetailsResponse>> getbirthdetails(BirthDetailsRequestModel requestModel) async {
    List<BirthDetailsResponse> list;

    var response = await http.post(AppUrl.birth_details, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      Map<String, dynamic> outputMap = data;
      return (outputMap['birth_details'] as List).map((f) => BirthDetailsResponse.fromJson(f)).toList();
     /* var rest1 = data["birth_details"] as List;
      var rest2 = data["astro_details"] as List;
      var rest3 = data["auspicious_muhurta_marriage"] as List;
      var rest4 = data["basic_panchang"] as List;*/
      print(data);
     // list = rest.map<BirthDetailsResponse>((json) => BirthDetailsResponse.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }





  //get user transaction history
  Future<List<TransactionHistoryResponse>> gettransactionhistory(UserRequestModel requestModel) async {
    List<TransactionHistoryResponse> list;

    var response = await http.post(AppUrl.user_transcation_history, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<TransactionHistoryResponse>((json) => TransactionHistoryResponse.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }


  //get available agents
  Future<List<AstrologerDetailsNew>> getavailableagent(AvailableAgentRequestModel requestModel) async {
    List<AstrologerDetailsNew> list;

    var response = await http.post(AppUrl.astrologer_agent_available, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<AstrologerDetailsNew>((json) => AstrologerDetailsNew.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }


  //get categorywise data
  Future<List<AstrologerDetails>> getcategorywisedata(AstroCategoryRequestModel requestModel) async {
    List<AstrologerDetails> list;

    var response = await http.post(AppUrl.get_agent_experwise_servicewise, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<AstrologerDetails>((json) => AstrologerDetails.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }

  //get dashboard astrologers according to service data (Psychology, Numerology,etc)
  Future<List<AstrologerDetailsNew>> getcurrentavailable(AstroRequestModel requestModel) async {
    List<AstrologerDetailsNew> list;

    var response = await http.post(AppUrl.astrologer_agent_available, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<AstrologerDetailsNew>((json) => AstrologerDetailsNew.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }

  //get dashboard astrologers according to service data (Psychology, Numerology,etc)
  Future<List<AstrologerDetails>> getastrologersdata(AstroRequestModel requestModel) async {
    List<AstrologerDetails> list;

    var response = await http.post(AppUrl.astrologer_listing, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<AstrologerDetails>((json) => AstrologerDetails.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }

  //get agentchats data
  Future<List<AgentChatDetail>> agentchatdata(AgentRequestModel requestModel) async {
    List<AgentChatDetail> list;

    var response = await http.post(AppUrl.chat_agent, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<AgentChatDetail>((json) => AgentChatDetail.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }

  //   get agent user chat data
  Future<List<AgentChatMsg>> newagentchatdata(NewAgentRequestModel requestModel) async {
    List<AgentChatMsg> list;

    var response = await http.post(AppUrl.agent_user_chat_listing, body:requestModel.toJson());

    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["data"] as List;
      print(rest);
      list = rest.map<AgentChatMsg>((json) => AgentChatMsg.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }

/*
  Future<List<ServiceDetails>> getcategory() async {
    var res = await http.get(AppUrl.get_services);
    if(res == null){
      return null;
    }
    else{
      print(res);
      Map<String, dynamic> data = json.decode(res);
      print(res);
      int responseCode = data["responseCode"];
      if(responseCode == 200){
        var list = data["services"] as List;
        List<CategoryModel> serviceTypeResList = list.map((i) => CategoryModel.fromJson(i)).toList();
        CategoryModel initialServiceType = CategoryModel.initial("", "Select Service","", "", "","","","","","");
        serviceTypeResList.insert(0, initialServiceType);
        return serviceTypeResList;
      }
      else{
        return null;
      }
    }
  }
*/


  /*Future<String> getlanguage() async {
    var res = await http
        .get(Uri.encodeFull(AppUrl.get_language));
    if (res == null) {
      return null;
    }
    else {
      // var resBody = json.decode(res.body);
      Map<String, dynamic> map = json.decode(res.body);
      List<dynamic> data2 = map["lang"];

      setState(() {
        language_list = data2;
      });

      print(data2);

      return "Success";
    }
  }
*/


  //get expertise data / problem areas
  Future<List<ExpertiseDetail>> getexpertise() async {

    var response = await webClient.post(AppUrl.get_expertise, '');


    if(response != null){
      Map<String, dynamic> responseMap = json.decode(response);
      int responseCode = responseMap["responseCode"];
      if(responseCode == 200){
        var output = responseMap["data"] as List;
        List<ExpertiseDetail> requestListRes = output.map((i) => ExpertiseDetail.fromJson(i)).toList();
        return requestListRes;
      }
    }
    return null;

  }


}
