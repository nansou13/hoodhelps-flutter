// step3_widget.dart
import 'package:flutter/material.dart';

Widget buildStepIndicator(int stepNumber, bool isActive) {
  return Container(
    width: 40.0,
    height: 40.0,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: isActive ? Color(0xFF2CC394) : Color(0xFFD9D9D9),
    ),
    alignment: Alignment.center,
    child: Text(
      stepNumber.toString(),
      style: TextStyle(
        color: isActive ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
