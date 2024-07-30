// step3_widget.dart
import 'package:flutter/material.dart';

Widget buildStepDivider(bool isActive) {
  return Container(
    width: 50.0,
    height: 4.0,
    color: isActive ? Color(0xFF2CC394) : Color(0xFFD9D9D9),
  );
}
