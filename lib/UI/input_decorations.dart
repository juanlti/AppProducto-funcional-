import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintextP,
    required String labelTextP,
     Icon? IconsP,
  }) {
    //authInputDecoration the password and email  Icon(Icons.alternate_email_sharp, color: Colors.deepPurple),
    return InputDecoration(
        prefixIcon: IconsP != null ? IconsP : null,
        hintText: hintextP,
        labelText: labelTextP,
        labelStyle: const TextStyle(color: Colors.grey),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple)));
  }
}
