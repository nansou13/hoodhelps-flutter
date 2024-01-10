import 'package:flutter/material.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:provider/provider.dart';

import 'Modules/register/step_divider.dart';
import 'Modules/register/step_indicator.dart';

import 'Modules/register/step1_widget.dart';
import 'Modules/register/step2_widget.dart';
import 'Modules/register/step3_widget.dart';
import 'Modules/register/step4_widget.dart';

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
    if (_currentStep == 1) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    } else if (_currentStep == 2) {
      return null;
    } else {
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
          backgroundColor: Color(0xFFF2F2F2),
          automaticallyImplyLeading: false,
          leading: returnButtonManage(),
          centerTitle: false,
          titleTextStyle: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
          title: _currentStep == 1
              ? Text(translationService.translate("ACCOUNT_CREATION"))
              : _currentStep == 2
                  ? Text(translationService.translate("ACCOUNT_CREATION"))
                  : _currentStep == 3
                      ? Text(translationService.translate("ADD_JOBS"))
                      : Text(translationService.translate("JOIN_A_GROUP"))),
      body: Stack(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
          color: Color(0xFFF2F2F2),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Indicateurs d'étape
              // GestureDetector(
              //   onTap: () {
              //     // Action à effectuer lors du clic sur le texte
              //     _previousStep();
              //   },
              //   child: Text(
              //     "<",

              //   ),
              // ),
              // GestureDetector(
              //   onTap: () {
              //     // Action à effectuer lors du clic sur le texte
              //     _nextStep();
              //   },
              //   child: Text(
              //     ">",

              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildStepIndicator(1, _currentStep >= 1),
                  buildStepDivider(_currentStep >= 2),
                  buildStepIndicator(2, _currentStep >= 2),
                  buildStepDivider(_currentStep >= 3),
                  buildStepIndicator(3, _currentStep >= 3),
                  buildStepDivider(_currentStep >= 4),
                  buildStepIndicator(4, _currentStep >= 4),
                ],
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints viewportConstraints) {
                  return SingleChildScrollView(
                      // Ajoutez le SingleChildScrollView ici
                      child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child:
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
                    ),
                  ));
                }),
              )
            ],
          ),
        )
      ]),
    );
  }
}
