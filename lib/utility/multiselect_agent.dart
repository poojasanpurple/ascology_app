// Multi Select widget
// This widget is reusable
import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/agent_request_model.dart';
import 'package:ascology_app/model/request/user_request.dart';
import 'package:ascology_app/model/response/astrologer_listing_response.dart';
import 'package:ascology_app/model/response/user_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MultiSelectAgent extends StatefulWidget {
  final List<String> items;
  const MultiSelectAgent({Key key,  this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectAgentState();
}

class _MultiSelectAgentState extends State<MultiSelectAgent> {
  // this variable holds the selected items
  List<String> _selectedItems = [];
  SharedPreferences logindata;
  String user_name,user_mobile,user_email,user_gender,user_desc,user_img,
      user_birthdate,user_birthplace,user_time,agent_desc;
  DateTime selectedDate = DateTime.now();
  String desc_all= " ",session_agent_id;
  List<String> gotlist = [];
  List<String> selectedlist = [];


  @override
  void initState() {
    fetch_Agent_details();
  }

  void fetch_Agent_details() async {

    logindata = await SharedPreferences.getInstance();
    session_agent_id = logindata.getString('agent_id');

    var _loginApiClient = LoginApiClient();
    AgentRequestModel model = AgentRequestModel();
    model.agent_id = session_agent_id;
    print(model.toString());

    AstrologerListingResponse listingResponse = await _loginApiClient.getagentprofile(model);

    print("!Q!Q!QQ!Q!Q!Q ${listingResponse.toString()}");
    // (data?.isEmpty ?? true
    //  if (userModel?.status ?? true) {
    //   if (userModel!=null) {
    //  if (userModel.status == true) {
    if (listingResponse.status == true) {
      print(listingResponse.data);



      desc_all = listingResponse.data[0].short_description.toString();
      gotlist = desc_all.split(',');

      //print(problemarealist);
      print(gotlist);

      setState(() {
        _selectedItems = gotlist;
      });


  }
    else {
      print(listingResponse.message);

    }
    }


// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select expertise areas'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item),
            title: Text(item),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) =>

                _itemChange(item, isChecked),
          ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: _cancel,
        ),
        ElevatedButton(
          child: const Text('Submit'),
          onPressed: _submit,
        ),
      ],
    );
  }
}
