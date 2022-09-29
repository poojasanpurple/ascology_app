import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
    suffixIcon: Icon(icon, color: const Color(0xffe22525)),
      //(50, 62, 72, 1.0)),
    hintText: hintText,
    fillColor: Colors.white,
    enabledBorder:OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey, width: 2.0),
      borderRadius: BorderRadius.circular(30.0),
    ),
    /*enabledBorder: new OutlineInputBorder(
      borderRadius: new BorderRadius.circular(20.0),
      borderSide:  BorderSide(color: const Color(0xffe22525)Accent ),

    ),*/
   // border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: const Color(0xffe22525)Accent),),
   // border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: const Color(0xffe22525)Accent),),
    hintStyle: TextStyle(color: Colors.black,fontFamily: 'Poppins'),
    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0),borderSide: BorderSide(color: const Color(0xffe22525))),
  );
}




InputDecoration buildInputDecorationlogin(String hintText, IconData icon) {
  return InputDecoration(
    suffixIcon: Icon(icon, color: const Color(0xffe22525)),
    //(50, 62, 72, 1.0)),
    hintText: hintText,
    fillColor: Colors.white,
    enabledBorder:OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2.0),
      borderRadius: BorderRadius.circular(30.0),
    ),
    /*enabledBorder: new OutlineInputBorder(
      borderRadius: new BorderRadius.circular(20.0),
      borderSide:  BorderSide(color: const Color(0xffe22525)Accent ),

    ),*/
    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: const Color(0xffe22525)Accent),),
    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: const Color(0xffe22525)Accent),),
    hintStyle: TextStyle(color: Colors.black,fontFamily: 'Poppins'),
    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0),borderSide: BorderSide(color: const Color(0xffe22525))),
  );
}



MaterialButton longButtons(String title, Function fun,
    {Color color: const Color(0xffe22525), Color textColor: Colors.white, InputDecoration:InputDecoration}) {
  return MaterialButton(
    onPressed: fun,
    textColor: textColor,
    color: color,
    child: SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    ),
    height: 45,
    minWidth: 600,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
  );
}
