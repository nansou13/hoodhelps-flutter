import 'package:flutter/material.dart';
import 'package:hoodhelps/custom_colors.dart';

class TemplateTwoBlocks extends StatelessWidget {
  final Widget middleChild;
  final Widget bottomChild;
  final bool showLeading;
  final String appTitle;

  const TemplateTwoBlocks({
    super.key,
    required this.middleChild,
    required this.bottomChild,
    this.showLeading = true,
    this.appTitle = '...',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppBar(
          appTitle: appTitle, context: context, showLeading: showLeading),
      body: genericSafeAreaTwoBlocks(
        middleChild: middleChild,
        bottomChild: bottomChild,
      ),
    );
  }
}

AppBar genericAppBar({
  required BuildContext context,
  required String appTitle,
  bool showLeading = true, // Valeur par défaut à `true`
  void Function()? leadingAction,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: FigmaColors.lightLight4,
    centerTitle: false,
    titleTextStyle: const FigmaTextStyles().headingsh3.copyWith(
          color: FigmaColors.darkDark0,
        ),
    leading: showLeading && (leadingAction != null || Navigator.canPop(context))
        ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: leadingAction ??
                () {
                  // Utiliser l'action de navigation par défaut si leadingAction est null
                  Navigator.of(context).pop();
                },
          )
        : null,
    title: Text(
      appTitle,
      style: const FigmaTextStyles().headingsh3.copyWith(
            color: FigmaColors.darkDark0,
          ),
      maxLines: 1, // Limite à 2 lignes
      overflow: TextOverflow.ellipsis,
    ),
  );
}

SafeArea genericSafeAreaTwoBlocks({
  required Widget middleChild,
  required Widget bottomChild,
  // Fonction optionnelle avec valeur par défaut à `null`
}) {
  return SafeArea(
    child: Container(
      color: FigmaColors.lightLight4,
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: SingleChildScrollView(child: middleChild)),
          Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: bottomChild),
        ],
      ),
    ),
  );
}
