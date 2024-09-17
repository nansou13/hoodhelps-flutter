
import 'package:flutter/material.dart';

class FigmaColors {
  const FigmaColors();

  static const Color darkDark0 = Color(0xff0f1e2e);
  static const Color darkDark1 = Color(0xff2a3540);
  static const Color darkDark2 = Color(0xff58626b);
  static const Color darkDark3 = Color(0xff9ea4a8);
  static const Color darkDark4 = Color(0xffd6dade);
  static const Color lightLight0 = Color(0xffe3e4ed);
  static const Color lightLight1 = Color(0xffe9e9f0);
  static const Color lightLight2 = Color(0xfff0f0f5);
  static const Color lightLight3 = Color(0xfff8f8fa);
  static const Color lightLight4 = Color(0xffffffff);
  static const Color primaryPrimary0 = Color(0xff3e55cd);
  static const Color primaryPrimary1 = Color(0xff5169e7);
  static const Color primaryPrimary2 = Color(0xff7589f5);
  static const Color primaryPrimary3 = Color(0xffacb9ff);
  static const Color primaryPrimary4 = Color(0xfff2f4ff);
  static const Color greenGreen0 = Color(0xff05a660);
  static const Color greenGreen1 = Color(0xff06c270);
  static const Color greenGreen2 = Color(0xff39d98a);
  static const Color greenGreen3 = Color(0xff70edae);
  static const Color greenGreen4 = Color(0xffe3fff1);
  static const Color forestForest0 = Color(0xff236d60);
  static const Color forestForest1 = Color(0xff2a8d7b);
  static const Color forestForest2 = Color(0xff45a090);
  static const Color forestForest3 = Color(0xff7dcdbf);
  static const Color forestForest4 = Color(0xffd4f5ef);
  static const Color turquoiseTurquoise0 = Color(0xff00bbb0);
  static const Color turquoiseTurquoise1 = Color(0xff00d4c8);
  static const Color turquoiseTurquoise2 = Color(0xff11e7db);
  static const Color turquoiseTurquoise3 = Color(0xff4ef5eb);
  static const Color turquoiseTurquoise4 = Color(0xffe3fffd);
  static const Color skySky0 = Color(0xff1cc4db);
  static const Color skySky1 = Color(0xff35cdee);
  static const Color skySky2 = Color(0xff51e0ff);
  static const Color skySky3 = Color(0xff9aedff);
  static const Color skySky4 = Color(0xffe8fbff);
  static const Color blueBlue0 = Color(0xff0799e7);
  static const Color blueBlue1 = Color(0xff12acff);
  static const Color blueBlue2 = Color(0xff34b8ff);
  static const Color blueBlue3 = Color(0xff8fd8ff);
  static const Color blueBlue4 = Color(0xffcfeeff);
  static const Color grapeGrape0 = Color(0xff424bc2);
  static const Color grapeGrape1 = Color(0xff505bec);
  static const Color grapeGrape2 = Color(0xff6e77f0);
  static const Color grapeGrape3 = Color(0xffaab0ff);
  static const Color grapeGrape4 = Color(0xffeff0ff);
  static const Color purplePurple0 = Color(0xff440d9e);
  static const Color purplePurple1 = Color(0xff6600cc);
  static const Color purplePurple2 = Color(0xff7d5dd9);
  static const Color purplePurple3 = Color(0xffa385f9);
  static const Color purplePurple4 = Color(0xffeae2ff);
  static const Color magentaMagenta0 = Color(0xffb552ce);
  static const Color magentaMagenta1 = Color(0xffe270ff);
  static const Color magentaMagenta2 = Color(0xffeb9bff);
  static const Color magentaMagenta3 = Color(0xfff3c3ff);
  static const Color magentaMagenta4 = Color(0xfffae4ff);
  static const Color pinkPink0 = Color(0xffda2450);
  static const Color pinkPink1 = Color(0xffff416e);
  static const Color pinkPink2 = Color(0xffff5c83);
  static const Color pinkPink3 = Color(0xffff86a3);
  static const Color pinkPink4 = Color(0xfffff0f4);
  static const Color redRed0 = Color(0xffe53535);
  static const Color redRed1 = Color(0xffff3b3b);
  static const Color redRed2 = Color(0xffff5c5c);
  static const Color redRed3 = Color(0xffff8080);
  static const Color redRed4 = Color(0xffffe5e5);
  static const Color corailCorail0 = Color(0xffe16834);
  static const Color corailCorail1 = Color(0xffff763b);
  static const Color corailCorail2 = Color(0xffff8c5b);
  static const Color corailCorail3 = Color(0xffffa681);
  static const Color corailCorail4 = Color(0xffffe7dd);
  static const Color orangeOrange0 = Color(0xffeb920d);
  static const Color orangeOrange1 = Color(0xffffab2d);
  static const Color orangeOrange2 = Color(0xffffba52);
  static const Color orangeOrange3 = Color(0xffffd495);
  static const Color orangeOrange4 = Color(0xffffedd2);
  static const Color yellowYellow0 = Color(0xffe3bf00);
  static const Color yellowYellow1 = Color(0xffffd600);
  static const Color yellowYellow2 = Color(0xffffe664);
  static const Color yellowYellow3 = Color(0xfffff1a8);
  static const Color yellowYellow4 = Color(0xfffff8d4);

}



class FigmaTextStyles {
  const FigmaTextStyles();


  TextStyle get body16pt => const TextStyle(
    fontSize: 15,
    decoration: TextDecoration.none,
    fontFamily: 'Poppins-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 20 / 15,
    letterSpacing: 0,
  );

  TextStyle get body14pt => const TextStyle(
    fontSize: 13,
    decoration: TextDecoration.none,
    fontFamily: 'Poppins-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 18 / 13,
    letterSpacing: 0,
  );

  TextStyle get headingsh1 => const TextStyle(
    fontSize: 26,
    decoration: TextDecoration.none,
    fontFamily: 'Poppins-SemiBold',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    height: 38 / 26,
    letterSpacing: 0,
  );

  TextStyle get headingsh2 => const TextStyle(
    fontSize: 24,
    decoration: TextDecoration.none,
    fontFamily: 'Poppins-SemiBold',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: 0,
  );

  TextStyle get headingsh3 => const TextStyle(
    fontSize: 20,
    decoration: TextDecoration.none,
    fontFamily: 'Poppins-Medium',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 28 / 20,
    letterSpacing: 0,
  );

  TextStyle get headingsh4 => const TextStyle(
    fontSize: 18,
    decoration: TextDecoration.none,
    fontFamily: 'Poppins-Medium',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 22 / 18,
    letterSpacing: 0,
  );

  TextStyle get headingsh5 => const TextStyle(
    fontSize: 16,
    decoration: TextDecoration.none,
    fontFamily: 'Poppins-Medium',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 22 / 16,
    letterSpacing: 0,
  );

  TextStyle get displayDisplay1 => const TextStyle(
    fontSize: 64,
    decoration: TextDecoration.none,
    fontFamily: 'Poppins-SemiBold',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    height: 64 / 64,
    letterSpacing: 0,
  );

  TextStyle get displayDisplay2 => const TextStyle(
    fontSize: 56,
    decoration: TextDecoration.none,
    fontFamily: 'Poppins-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 56 / 56,
    letterSpacing: 0,
  );

  TextStyle get stylizedLead => const TextStyle(
    fontSize: 14,
    decoration: TextDecoration.none,
    fontFamily: 'Poppins-Medium',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 18 / 14,
    letterSpacing: 0,
  );

  TextStyle get stylizedBlockquote => const TextStyle(
    fontSize: 17,
    decoration: TextDecoration.none,
    fontFamily: 'Poppins-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 21 / 17,
    letterSpacing: 0,
  );

  TextStyle get stylizedCAPITALIZED => const TextStyle(
    fontSize: 12,
    decoration: TextDecoration.none,
    fontFamily: 'Poppins-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 12 / 12,
    letterSpacing: 1.2,
  );

  TextStyle get stylizedMedium => const TextStyle(
    fontSize: 16,
    decoration: TextDecoration.none,
    fontFamily: 'Poppins-Medium',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 22 / 16,
    letterSpacing: 0,
  );

  TextStyle get stylizedLight => const TextStyle(
    fontSize: 16,
    decoration: TextDecoration.none,
    fontFamily: 'Poppins-Light',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
    height: 22 / 16,
    letterSpacing: 0,
  );

  TextStyle get stylizedSmall => const TextStyle(
    fontSize: 12,
    decoration: TextDecoration.none,
    fontFamily: 'Poppins-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 17 / 12,
    letterSpacing: 0,
  );

  TextStyle get stylizedTiny => const TextStyle(
    fontSize: 12,
    decoration: TextDecoration.none,
    fontFamily: 'Poppins-Light',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
    height: 12 / 12,
    letterSpacing: 0,
  );

}
