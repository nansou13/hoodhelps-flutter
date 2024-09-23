import 'package:flutter/material.dart';
import 'package:hoodhelps/custom_colors.dart';

class ProgressBarWithCounter extends StatelessWidget {
  final int currentStep; // L'étape actuelle
  final int totalSteps;  // Le nombre total d'étapes

  const ProgressBarWithCounter({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = currentStep / totalSteps; // Calcul de la progression

    return Row(
        children: [
          // Barre de progression
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0), // Rayon des bords arrondis
              child: LinearProgressIndicator(
                value: progress,  // La progression (entre 0.0 et 1.0)
                backgroundColor: const Color.fromARGB(255, 225, 229, 251), // Couleur de fond
                color: FigmaColors.primaryPrimary1,  // Couleur de la barre
                minHeight: 8.0,      // Hauteur de la barre
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          // Affichage de la progression sous forme de fraction
          Text(
            '$currentStep/$totalSteps',
            style: FigmaTextStyles().stylizedSmall.copyWith(
              color: FigmaColors.darkDark2,
            ),
          ),
        ],
    );
  }
}