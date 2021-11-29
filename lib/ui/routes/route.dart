import 'package:Mecca/ui/pages/shared/account_review.dart';
import 'package:Mecca/ui/pages/shared/codeafterreset.dart';
import 'package:Mecca/ui/pages/shared/forgetpass.dart';
import 'package:Mecca/ui/pages/shared/languages_page.dart';
import 'package:Mecca/ui/pages/shared/login_page2.dart';
import 'package:Mecca/ui/pages/shared/newpassword.dart';
import 'package:Mecca/ui/pages/shared/on_boarding.dart';
import 'package:Mecca/ui/pages/shared/signup_page.dart';
import 'package:Mecca/ui/pages/shared/splash_screen.dart';
import 'package:Mecca/ui/pages/shared/verifyaccount.dart';
import 'package:flutter/material.dart';

class Routes {
  static Widget get splash => SplashScreen();
  static Widget current;

  static Widget _setRoute(Widget route) {
    current = route;
    return route;
  }

  static Widget get languagePage => LanguagesPage();
  static Widget get onboard => On_boardingPage();
  // static Widget get loginWithSocial => LoginWithSocial();
  static Widget get login2 => LoginPage2();
  static Widget get signup => SignUpPage();
  static Widget get forgetpass => ForgetPassPage();
  static Widget get account_review => AccountReviewPage();
  static Widget verifyaccount({String number, String type}) =>
      _setRoute(VerifyAccountPage(number: number, type: type));
  static Widget forgetpass1({String number}) =>
      _setRoute(ForgetPass1Page(number: number));
  static Widget forgetpass2({String email}) =>
      _setRoute(ForgetPass2Page(email: email));
}
