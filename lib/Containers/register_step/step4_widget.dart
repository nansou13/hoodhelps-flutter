import 'package:flutter/material.dart';

class Step4Widget extends StatelessWidget {
  const Step4Widget({Key? key}) : super(key: key);

  // final TextEditingController firstNameController;
  // final TextEditingController lastNameController;
  // final TextEditingController dateOfBirthController;
  // final TextEditingController phoneController;
  // final Function nextStepCallback;
  // final String errorMessage; // Ajout de errorMessage comme paramètre

  // Step4Widget({
  //   required this.firstNameController,
  //   required this.lastNameController,
  //   required this.dateOfBirthController,
  //   required this.phoneController,
  //   required this.nextStepCallback,
  //   required this.errorMessage, // Ajout de errorMessage
  // });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Étape 4',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Text('Terminez votre inscription...'),
        // Ajoutez ici d'autres champs de formulaire pour l'étape 3
      ],
    );
  }
}