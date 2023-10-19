import 'package:flutter/material.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/template.dart';
import 'package:provider/provider.dart';

import 'register_step/step_divider.dart';
import 'register_step/step_indicator.dart';

import 'register_step/step1_widget.dart';
import 'register_step/step2_widget.dart';
import 'register_step/step3_widget.dart';
import 'register_step/step4_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 1; // Étape actuelle du registre
  //bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _nextStep() {
    setState(() {
      if (_currentStep < 4) {
        _currentStep++;
      }
    });
  }

  void _previousStep() {
    setState(() {
      if (_currentStep > 1) {
        _currentStep--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    return Scaffold(
        body: Stack(children: [
      // Image de fond
      background(),

      Container(
        padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
        color: Colors.white.withOpacity(0.9),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          // Ajoutez le SingleChildScrollView ici
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Indicateurs d'étape
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildStepIndicator(1, _currentStep >= 1),
                  buildStepDivider(),
                  buildStepIndicator(2, _currentStep >= 2),
                  buildStepDivider(),
                  buildStepIndicator(3, _currentStep >= 3),
                  buildStepDivider(),
                  buildStepIndicator(4, _currentStep >= 4),
                ],
              ),
              const SizedBox(height: 20.0),

              // Contenu de l'étape actuelle
              _currentStep == 1
                  ? Step1Widget(
                      nextStepCallback: _nextStep,
                    )
                  : _currentStep == 2
                      ? Step2Widget(
                          nextStepCallback: _nextStep,
                        )
                      : _currentStep == 3
                          ? Step3Widget(
                              nextStepCallback: _nextStep,
                            )
                          : Step4Widget(
                              nextStepCallback: _nextStep,
                            ),

              // Boutons de navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 1)
                    ElevatedButton(
                      onPressed: _previousStep,
                      child: const Text('Précédent'),
                    ),
                  if (_currentStep < 4)
                    ElevatedButton(
                      onPressed: _nextStep,
                      child: const Text('Suivant'),
                    ),
                ],
              ),
              InkWell(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/login");
                  },
                  child: Center(
                    child: Text(
                      translationService.translate("FORM_LOGIN_ACCOUNT_LINK"),
                      style: const TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]));
  }
}
