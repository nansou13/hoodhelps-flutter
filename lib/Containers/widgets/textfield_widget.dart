import 'package:flutter/material.dart';
import 'package:hoodhelps/custom_colors.dart';

Column buildTextField(
    {required TextEditingController controller,
    String hintText = '',
    String labelText = '',
    required String key,
    TextInputType keyboardType = TextInputType.text,
    void Function()? onTap,
    void Function(String)? onChanged,
    bool readOnly = false,
    bool enabled = true,
    int maxLine = 1,
    int minLine = 1,
    bool obscureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start, // Aligne le label à gauche
    children: [
      if (labelText.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 13),
          child: Text(
            labelText, // Le label affiché au-dessus du champ de texte
            style: const FigmaTextStyles().body16pt.copyWith(
                  color: FigmaColors.darkDark0,
                ),
          ),
        ),

      const SizedBox(height: 4.0), // Un espace entre le label et le TextField
      TextField(
        key: Key(key),
        enabled: enabled,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLine,
        minLines: minLine,
        onChanged: onChanged,
        controller: controller,
        keyboardType: keyboardType,
        style: const FigmaTextStyles().body16pt.copyWith(
                  color: FigmaColors.darkDark0,
                ),
        decoration: InputDecoration(
            fillColor: FigmaColors.darkDark4,
            // filled: true,
            hintText: hintText,
            hintStyle: const FigmaTextStyles().body16pt.copyWith(
                  color: FigmaColors.darkDark3,
                ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                  color: FigmaColors.darkDark4, width: 1.0), // Bordure inactive
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                  color: FigmaColors.darkDark0,
                  width: 1.0), // Bordure rouge en focus
            ),
          ),
        obscureText: obscureText,
      ),
    ],
  );
}
