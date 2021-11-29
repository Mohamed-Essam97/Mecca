import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/ui/pages/provider_user/provider_home_Page.dart';
import 'package:Mecca/ui/pages/user/Home_Page/home_page.dart';
import 'package:Mecca/ui/routes/route.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/loading.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io' show Platform;

class LoginWithSocial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return BaseWidget<LoginWithSocialModel>(

        // initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
        //       m.checkUser();
        //     }),
        model: LoginWithSocialModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            context: context),
        builder: (context, model, _child) => Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Stack(
                  children: [
                    model.busy
                        ? Center(
                            child: Loading(
                              color: AppColors.primary,
                              size: 200.0,
                            ),
                          )
                        : SizedBox(),
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                          Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/a/a2/Makkah_logo.png'),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          InkWell(
                            onTap: () async {
                              await model.signInWithFacbook(context);
                            },
                            child: card(
                                "Log In with Facebook",
                                "assets/images/FaceBook.svg",
                                AppColors.facebook,
                                context),
                          ),
                          InkWell(
                            onTap: () async {
                              await model.signInWithGoogle(context);
                            },
                            child: card(
                                "Log In with Google",
                                "assets/images/google-symbol.svg",
                                AppColors.gmail,
                                context),
                          ),
                          Platform.isIOS
                              ? card(
                                  "Log In with Apple",
                                  "assets/images/Apple.svg",
                                  Colors.black,
                                  context)
                              : SizedBox(),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Text("OR"),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          InkWell(
                              onTap: () {
                                UI.push(context, Routes.login2);
                              },
                              child: card(
                                  "Log In with Mail",
                                  "assets/images/E-mail.svg",
                                  Colors.red,
                                  context)),
                          SizedBox(
                            height: screenHeight * 0.1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(locale.get("Haven't Account? ") ??
                                  "Haven't Account? "),
                              InkWell(
                                onTap: () {
                                  UI.push(context, Routes.signup);
                                },
                                child: Text(
                                  locale.get("Sign up") ?? "Sign up",
                                  style: TextStyle(color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  Widget card(name, String icon, color, BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(5.0) //                 <--- border radius here
              ),
          border: Border.all(
            color: color,
            width: 2,
          ),
          // borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(icon),
              SizedBox(
                width: 90,
              ),
              Text(
                locale.get(name) ?? name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginWithSocialModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  LoginWithSocialModel({
    NotifierState state,
    this.api,
    this.auth,
    this.context,
  }) : super(state: state);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  signInWithGoogle(BuildContext context) async {
    setBusy();

    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      setError();
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    if (user != null) {
      // Register to backend
      authenticateUser(context, user, "google");
    } else {
      UI.toast("Error");
      // UI.toast(locale.get("Error") ?? "Error");
      setError();
    }
  }

  // signInWithApple(BuildContext context) async {
  //   setBusy();

  //   // Trigger the authentication flow
  //   final AppleSignInAccount AppleUser = await AppleSignIn().signIn();

  //   if (AppleUser == null) {
  //     setError();
  //   }
  //   // Obtain the auth details from the request
  //   final AppleSignInAuthentication AppleAuth =
  //       await AppleUser.authentication;

  //   // Create a new credential
  //   final AppleAuthCredential credential = AppleAuthProvider.credential(
  //     accessToken: AppleAuth.accessToken,
  //     idToken: AppleAuth.idToken,
  //   );

  //   // Once signed in, return the UserCredential
  //   final UserCredential authResult =
  //       await _auth.signInWithCredential(credential);
  //   final User user = authResult.user;
  //   if (user != null) {
  //     // Register to backend
  //     // authenticateUser(context, user, "apple");
  //   } else {
  //     // UI.toast(locale.get("Error") ?? "Error");
  //     setError();
  //   }
  // }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  void authenticateUser(
      BuildContext context, User user, String provider) async {
    final locale = AppLocalizations.of(context);
    setBusy();

    if (await auth.loginWithSocial(body: {
      "email": user.providerData[0].email,
      provider: user.providerData[0].uid,
    })) {
      setIdle();
      // UI.toast("Success");
      if (auth.user.user.userType == 'user') {
        UI.pushReplaceAll(context, HomePage());
      } else if (auth.user.user.userType == 'provider') {
        if (auth.user.user.isActive) {
          UI.pushReplaceAll(context, ProviderHomePage());
        } else {
          UI.pushReplaceAll(context, Routes.account_review);
        }
      }
    } else {
      UI.toast("Error");

      setError();
    }
    setError();
  }

  void signInWithFacbook(BuildContext context) async {
    setBusy();

    final facebookLogin = FacebookLogin();

    final FacebookLoginResult result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        UI.toast("logged in");

        final FacebookAccessToken accessToken = result.accessToken;

        print("Access Token : " + accessToken.token);
        print("Access Token : " + accessToken.userId);
        // Create a credential from the access token
        final FacebookAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken.token);

        // Once signed in, return the UserCredential
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        final User user = userCredential.user;
        if (user != null) {
          // Register to backend
          authenticateUser(context, user, "facebook");
        } else {
          // UI.toast(locale.get("Error") ?? "Error");
          UI.toast("error");
          setError();
        }

        break;
      case FacebookLoginStatus.cancelledByUser:
        UI.toast("Cancel");
        setError();

        // _showCancelledMessage();
        break;
      case FacebookLoginStatus.error:
        UI.toast("Error");
        setError();

        // _showErrorOnUI(result.errorMessage);
        break;
    }
  }
}
