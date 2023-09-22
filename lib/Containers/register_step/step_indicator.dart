// step3_widget.dart
import 'package:flutter/material.dart';

Widget buildStepIndicator(int stepNumber, bool isActive) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.blue : Colors.grey,
      ),
      alignment: Alignment.center,
      child: Text(
        stepNumber.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }