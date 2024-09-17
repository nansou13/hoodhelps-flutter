import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Widgets/template_two_blocks.dart';
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

  Map<String, dynamic> returnButtonManage() {
  if (_currentStep == 1) {
    return {
      'showLeading': true,
      'leading': () => Navigator.of(context).pop(),
    };
  } else if (_currentStep == 2) {
    return {
      'showLeading': false,
      'leading': null,
    };
  } else {
    return {
      'showLeading': true,
      'leading': _previousStep,
    };
  }
}

  String getTitleByStep(int step, translationService) {
    switch (step) {
      case 1:
        return translationService.translate("ACCOUNT_CREATION");
      case 2:
        return translationService.translate("ACCOUNT_CREATION");
      case 3:
        return translationService.translate("ADD_JOBS");
      case 4:
        return translationService.translate("JOIN_A_GROUP");
      default:
        return translationService.translate("ACCOUNT_CREATION");
    }
  }

  getPageByStep(int step) {
    //Cette fonction doit me retourner le middleChild et le bottomChild
    switch (step) {
      case 1:
        return Step1Widget(
          nextStepCallback: _nextStep,
        );
      case 2:
        return Step2Widget(
          nextStepCallback: _nextStep,
        );
      case 3:
        return Step3Widget(
          nextStepCallback: _nextStep,
        );
      case 4:
        return Step4Widget(
          nextStepCallback: _nextStep,
        );
      default:
        return Step1Widget(
          nextStepCallback: _nextStep,
        );
    }
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
      
      
      
      
      // Stack(children: [
      //   Container(
      //     padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
      //     width: double.infinity,
      //     height: double.infinity,
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       // crossAxisAlignment: CrossAxisAlignment.stretch,
      //       children: [
      //         // Indicateurs d'étape
      //         // GestureDetector(
      //         //   onTap: () {
      //         //     // Action à effectuer lors du clic sur le texte
      //         //     _previousStep();
      //         //   },
      //         //   child: Text(
      //         //     "<",

      //         //   ),
      //         // ),
      //         // GestureDetector(
      //         //   onTap: () {
      //         //     // Action à effectuer lors du clic sur le texte
      //         //     _nextStep();
      //         //   },
      //         //   child: Text(
      //         //     ">",

      //         //   ),
      //         // ),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             buildStepIndicator(1, _currentStep >= 1),
      //             buildStepDivider(_currentStep >= 2),
      //             buildStepIndicator(2, _currentStep >= 2),
      //             buildStepDivider(_currentStep >= 3),
      //             buildStepIndicator(3, _currentStep >= 3),
      //             buildStepDivider(_currentStep >= 4),
      //             buildStepIndicator(4, _currentStep >= 4),
      //           ],
      //         ),
      //         const SizedBox(height: 20.0),
      //         Expanded(
      //           child: LayoutBuilder(builder:
      //               (BuildContext context, BoxConstraints viewportConstraints) {
      //             return SingleChildScrollView(
      //                 // Ajoutez le SingleChildScrollView ici
      //                 child: ConstrainedBox(
      //               constraints: BoxConstraints(
      //                 minHeight: viewportConstraints.maxHeight,
      //               ),
      //               child: IntrinsicHeight(
      //                 child:
      //                     // Contenu de l'étape actuelle
      //                     _currentStep == 1
      //                         ? Step1Widget(
      //                             nextStepCallback: _nextStep,
      //                           )
      //                         : _currentStep == 2
      //                             ? Step2Widget(
      //                                 nextStepCallback: _nextStep,
      //                               )
      //                             : _currentStep == 3
      //                                 ? Step3Widget(
      //                                     nextStepCallback: _nextStep,
      //                                   )
      //                                 : Step4Widget(
      //                                     nextStepCallback: _nextStep,
      //                                   ),
      //               ),
      //             ));
      //           }),
      //         )
      //       ],
      //     ),
      //   )
      // ]),
    );
  }
}
