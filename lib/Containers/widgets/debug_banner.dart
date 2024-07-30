
import 'package:flutter/material.dart';

class DebugBanner extends StatelessWidget {
  final String text;

  DebugBanner(this.text);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 15,  // Ajustez la position verticale pour le placement optimal
      right: -30,  // Ajustez la position horizontale pour le placement optimal
      child: Transform.rotate(
        angle: 45 * 3.14159265359 / 180,
        child: Container(
          width: 100,
          decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
          child: Container(
            color: Colors.yellow,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
        ),
      ),
    ),
    );
  }
}