import 'package:flutter/material.dart';
import 'package:hoodhelps/custom_colors.dart';

//function return colors object from buildButton variant with switch case
Map<String, Color> getButtonColors(String variant) {
  switch (variant) {
    case 'primary':
      return {
        'color': FigmaColors.darkDark0,
        'textColor': FigmaColors.lightLight4,
      };
    case 'secondary':
      return {
        'color': FigmaColors.lightLight2,
        'textColor': FigmaColors.darkDark0,
      };
    default:
      return {
        'color': FigmaColors.darkDark0,
        'textColor': FigmaColors.lightLight4,
      };
  }
}

MaterialButton buildButton({
  Function()? onPressed,
  String variant = 'primary',
  Color? color,
  Color? textColor,
  String text = '',
  bool disabled = false,
}) {
  Map<String, Color> colorTheme = getButtonColors(variant);
  return MaterialButton(
    onPressed: onPressed != null
        ? () async {
            // Si onPressed est asynchrone (Future), on l'attend, sinon on l'appelle directement.
            var result = onPressed();
            if (result is Future) {
              await result; // Attendre si c'est une fonction asynchrone
            }
          }
        : null,
    color: color ?? colorTheme['color'],
    disabledColor: FigmaColors.darkDark3,
    textColor: textColor ?? colorTheme['textColor'],
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Container(
      width: double.infinity,
      height: 50.0,
      alignment: Alignment.center,
      child: Text(
        text,
        style: FigmaTextStyles().stylizedMedium,
      ),
    ),
  );
}
