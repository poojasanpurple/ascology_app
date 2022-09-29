
import 'package:flutter/material.dart';

InputDecoration buildInputDecorationnew(String hintText, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: const Color(0xffe22525)),
    //(50, 62, 72, 1.0)),
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.black),
    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0),borderSide: BorderSide(color: const Color(0xffe22525))),
  );
}