import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Widgets/template_two_blocks.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:provider/provider.dart';

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
  String appBarTitle = 'Création de compte';
  void _nextStep() {
    setState(() {
      if (_currentStep < 4) _currentStep++;
    });
  }

  void _previousStep() {
    setState(() {
      if (_currentStep > 1) _currentStep--;
    });
  }

  void updateAppBarTitle(String newTitle) {
    setState(() {
      appBarTitle = newTitle;
    });
  }

  Map<String, dynamic> returnButtonManage() {
    return {
      'showLeading': _currentStep != 1,
      'leading':
          _currentStep == 1 ? () => Navigator.of(context).pop() : _previousStep,
    };
  }

  String getTitleByStep(int step, translationService) {
    switch (step) {
      case 3:
        return translationService.translate("ADD_JOBS");
      case 4:
        return translationService.translate("JOIN_A_GROUP");
      default:
        return translationService.translate("ACCOUNT_CREATION");
    }
  }

  getPageByStep(int step) {
    final steps = [
      Step1Widget(nextStepCallback: _nextStep),
      Step2Widget(nextStepCallback: _nextStep),
      Step3Widget(nextStepCallback: _nextStep),
      Step4Widget(nextStepCallback: _nextStep),
    ];

    return steps[step - 1];
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    final appBarConfig = returnButtonManage();

    return Scaffold(
      appBar: genericAppBar(
        context: context,
        appTitle: getTitleByStep(_currentStep, translationService),
        showLeading: appBarConfig['showLeading'],
        leadingAction: appBarConfig['leading'],
      ),
      body: getPageByStep(_currentStep),
    );
  }
}
