import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/core/services/notification/notification_service.dart';
import 'package:Mecca/core/services/preference/preference.dart';
import 'package:Mecca/ui/pages/provider_user/provider_home_Page.dart';
import 'package:Mecca/ui/pages/user/Home_Page/home_page.dart';
import 'package:Mecca/ui/routes/route.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/buttons/normal_button.dart';
import 'package:Mecca/ui/widgets/loading.dart';
import 'package:Mecca/ui/widgets/reactive_widgets.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    bool loading = false;
    return BaseWidget<LoginPage2Model>(

        // initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
        //       m.checkUser();
        //     }),
        model: LoginPage2Model(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            context: context),
        builder: (context, model, _child) => Scaffold(
              appBar: AppBar(
                  elevation: 0,
                  backgroundColor: AppColors.getDarkLightBackGround2(),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios,
                        color: AppColors.getDarkLightBackGround()),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              body: Stack(
                children: [
                  loading
                      ? Center(
                          child: Loading(
                            color: Colors.white,
                            size: 55.0,
                          ),
                        )
                      : SizedBox(),
                  SingleChildScrollView(
                    child: ReactiveForm(
                      formGroup: model.form,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: <Widget>[
                            // Image.network('https://picsum.photos/250?image=9'),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                locale.get("Log In") ?? "Log In",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.04,
                            ),

                            ReactiveField(
                              // filled: true,
                              // fillColor: Colors.grey[200],
                              borderColor: Colors.grey,
                              enabledBorderColor: Colors.grey,
                              hintColor: Colors.grey[100],
                              type: ReactiveFields.TEXT,
                              controllerName: 'email',
                              label: locale.get('Email or Phone Number') ??
                                  'Email or Phone Number',
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            ReactiveField(
                              // filled: true,
                              // fillColor: Colors.grey[200],
                              borderColor: Colors.grey,
                              enabledBorderColor: Colors.grey,
                              secure: true,
                              type: ReactiveFields.PASSWORD,
                              controllerName: 'password',
                              label: locale.get('Password') ?? 'Password',
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {
                                  UI.push(context, Routes.forgetpass);
                                },
                                child: Text(
                                  "Forget Password?",
                                  style: TextStyle(
                                    color: Colors.yellow[700],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            NormalButton(
                              onPressed: model.form.valid
                                  ? () async {
                                      if (model.form.valid) {
                                        loading = true;
                                        model.setState();
                                        await model.signin();
                                        loading = false;
                                        model.setState();
                                      } else {
                                        UI.toast(
                                            locale.get("Enter Empty Fields") ??
                                                "Enter Empty Fields");
                                      }
                                    }
                                  : null,
                              text: "Login",
                              color: model.form.valid
                                  ? AppColors.primary
                                  : Colors.grey,
                              raduis: 5,
                            ),
                            SizedBox(
                              height: screenHeight * 0.12,
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
                                    "Sign up",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  Widget loading() {
    return SpinKitRotatingCircle(
      color: Colors.white,
      size: 50.0,
    );
  }
}

class LoginPage2Model extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  var phoneRegex =
      r'(([+][(]?[0-9]{1,3}[)]?)|([(]?[0-9]{4}[)]?))\s*[)]?[-\s\.]?[(]?[0-9]{1,3}[)]?([-\s\.]?[0-9]{3})([-\s\.]?[0-9]{3,4})';
  FormGroup form;
  LoginPage2Model({
    NotifierState state,
    this.api,
    this.auth,
    this.context,
  }) : super(state: state) {
    // Validators.pattern(phoneRegex);
    form = FormGroup(
      {
        'email': FormControl(
          validators: [
            Validators.required,
            // Validators.composeOR(
            //     [Validators.email, Validators.pattern(phoneRegex)])
          ],
        ),
        'password': FormControl(
          validators: [
            Validators.required,
            Validators.minLength(8),
            Validators.maxLength(64),
          ],
        ),
        "fcmToken": FormControl(value: Preference.getString(PrefKeys.fcmToken)),
      },
    );
  }

  signin() async {
    bool res = false;

    setBusy();
    res = await auth.signIn(context, body: form.value);

    if (res) {
      setIdle();
      init();
      if (auth.user.user.userType != "admin") {
        if (auth.user.user.userType == "provider") {
          if (auth.user.user.isActive == false) {
            UI.pushReplaceAll(context, Routes.account_review);
            // await NotificationService().init(context);
          } else {
            //// push to provider home screen
            UI.pushReplaceAll(context, ProviderHomePage());
          }
        } else {
          if (auth.user.user.isActive == false) {
            // await NotificationService().init(context);

            UI.push(
                context,
                Routes.verifyaccount(
                    number: auth.user.user.email,
                    type: auth.user.user.userType));
          } else {
            // await NotificationService().init(context);
            UI.pushReplaceAll(context, HomePage());
          }
        }
      } else {
        UI.toast("Can't login as an admin, Go to Admin Panel");
      }
    } else {
      setError();
    }
  }

  void init() async {
    await Provider.of<NotificationService>(context, listen: false)
        .init(context);

    auth.sendFCMToken(context, fcm: Preference.getString(PrefKeys.fcmToken));
  }
}
