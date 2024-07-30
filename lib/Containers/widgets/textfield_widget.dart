import 'package:flutter/material.dart';

TextField buildTextField(
      {required TextEditingController controller,
      required String hintText,
      required String key,
      TextInputType keyboardType = TextInputType.text,
      void onTap ( ) ?,
      void onChanged (String) ?,
      bool readOnly = false,
      bool enabled = true,
      int maxLine = 1,
      int minLine = 1,
      bool obscureText = false}) {
    return TextField(
      key: Key(key),
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLine,
      minLines: minLine,
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFF696969), fontSize: 15.0), 
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        labelText: hintText,
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF749891), width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
        focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2CC394), width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      obscureText: obscureText,
    );
  }