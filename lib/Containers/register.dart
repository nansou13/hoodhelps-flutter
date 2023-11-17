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
  String appBarTitle = 'Création de compte'; 

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


  void updateAppBarTitle(String newTitle) {
    setState(() {
      appBarTitle = newTitle;
    });
  }

  returnButtonManage() {
    if(_currentStep == 1) {
      return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
    } else if(_currentStep == 2){
      return null;
    }else{
      return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _previousStep,
          );
    }
  } 

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: returnButtonManage(),
          title: _currentStep == 1
                  ? Text(translationService.translate("ACCOUNT_CREATION"))
                  : _currentStep == 2
                      ? Text(translationService.translate("ACCOUNT_CREATION"))
                      : _currentStep == 3
                          ? Text(translationService.translate("ADD_JOBS"))
                          : Text(translationService.translate("JOIN_A_GROUP"))
        ),
        body: Stack(children: [
      // Image de fond
      background(),

      Container(
        padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     if (_currentStep > 1)
              //       ElevatedButton(
              //         onPressed: _previousStep,
              //         child: const Text('Précédent'),
              //       ),
              //     if (_currentStep < 4)
              //       ElevatedButton(
              //         onPressed: _nextStep,
              //         child: const Text('Suivant'),
              //       ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    ]));
  }
}
