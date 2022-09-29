// Multi Select widget
// This widget is reusable
import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/user_request.dart';
import 'package:ascology_app/model/response/user_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key key,  this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
   List<String> _selectedItems = [];
  SharedPreferences logindata;
  String user_name,user_mobile,user_email,user_gender,user_desc,user_img,
      user_birthdate,user_birthplace,user_time;
  DateTime selectedDate = DateTime.now();
  String desc_all= " ",session_user_id;
  List<String> gotlist = [];
  List<String> selectedlist = [];


  @override
  void initState() {
    fetch_user_details();
  }

  void fetch_user_details() async {

    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');

    var _loginApiClient = LoginApiClient();
    UserRequestModel model = UserRequestModel();
    model.user_id = session_user_id;
    print(model.toString());

    UserListingResponse userListingResponse = await _loginApiClient.getprofiledetails(model);

    print("!Q!Q!QQ!Q!Q!Q ${userListingResponse.toString()}");
    // (data?.isEmpty ?? true
    //  if (userModel?.status ?? true) {
    //   if (userModel!=null) {
    //  if (userModel.status == true) {
    if (userListingResponse.status == true) {
      print(userListingResponse.data);

      desc_all = userListingResponse.data[0].short_description.toString();

      gotlist = desc_all.split(',');

      //print(problemarealist);
      print(gotlist);

      setState(() {
        _selectedItems = gotlist;
      });

      /* for(int i = 0 ; i < gotlist.length; i++) {
        myMultiSelectController.select(i);
      }*/

      /*  for(int i = 0; i < problemarealist.length; i++)
      {
        if(problemarealist[i] == gotlist[i])
        {

          selectedlist.add(i.toString());

        }
        else
        {
          // print(i);
        }
      }*/

      //  var sellist = problemarealist.toSet().intersection(gotlist.toSet()).toList();






/*

           if(user_gender == "female")
        {
          dropdownvalue_gender = user_gender;
        }
      else if(user_gender == "male")
        {
          dropdownvalue_gender = user_gender;
        }
*/



      /*  AstrologerDetails details = AstrologerDetails();
          details.agentname = userModel.data.asMap()
*/
    }
    else {
      print(userListingResponse.message);

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
      title: const Text('Select problem areas'),
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
