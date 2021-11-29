import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/ui/routes/route.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/buttons/normal_button.dart';
import 'package:Mecca/ui/widgets/error.dart';
import 'package:Mecca/ui/widgets/loading.dart';
import 'package:Mecca/ui/widgets/reactive_widgets.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:provider/provider.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ForgetPass1Page extends StatelessWidget {
  String number;
  ForgetPass1Page({this.number});
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var _code;
    var _onEditing = true;
    bool loading = false;
    return BaseWidget<ForgetPass1PageModel>(

        // initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
        //       m.checkUser();
        //     }),
        model: ForgetPass1PageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            phone: number,
            context: context),
        builder: (context, model, _child) => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              body: Stack(
                children: [
                  loading
                      ? Center(
                          child: Loading(
                            color: AppColors.primary,
                            size: 50.0,
                          ),
                        )
                      : SizedBox(),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          children: <Widget>[
                            Container(
                                height: 100,
                                child: Image.network(
                                    'https://picsum.photos/250?image=9')),
                            //SizedBox(height: screenHeight*0.01,),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                locale.get('Reset Password') ?? 'Reset Password',
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.03,
                            ),
                            Text(
                              locale.get(
                                    "Enter The 4-Digits Sent To Your",
                                  ) ??
                                  "Enter The 4-Digits Sent To Your",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              "$number",
                              style: TextStyle(color: Colors.black54),
                            ),
                            SizedBox(
                              height: screenHeight * 0.03,
                            ),

                            VerificationCode(
                              textStyle:
                                  TextStyle(fontSize: 20.0, color: Colors.black),
                              underlineColor: AppColors.primary,
                              keyboardType: TextInputType.number,
                              length: 4,
                              // clearAll is NOT required, you can delete it
                              // takes any widget, so you can implement your design
                              clearAll: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  locale.get('Clear All') ?? 'Clear All',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue[700]),
                                ),
                              ),
                              onCompleted: (String value) {
                                model.setState();
                                _code = value;
                                model.code = _code;
                                model.setState();
                              },
                              onEditing: (bool value) {
                                model.setState();
                                _onEditing = value;
                                model.setState();
                              },
                            ),
                            Center(
                              child: (_onEditing != true)
                                  ? Text(
                                      '${locale.get("Your Code") ?? "Your Code"} $_code')
                                  : Text(locale.get('Please Enter Full Code') ??
                                      'Please Enter Full Code'),
                            ),
                            ArgonTimerButton(
                              elevation: 0,
                              initialTimer: 40, // Optional
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.25,
                              minWidth: MediaQuery.of(context).size.width * 0.30,
                              color: Colors.white,
                              borderRadius: 5.0,
                              child: Text(
                                locale.get("Resend Code") ?? "Resend Code",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                              ),
                              loader: (timeLeft) {
                                return Text(
                                  "${locale.get("Wait" ?? "Wait")} | $timeLeft",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                );
                              },
                              onTap: (startTimer, btnState) {
                                if (btnState == ButtonState.Idle) {
                                  startTimer(60);
                                  model.resetpasswordcode();
                                }
                              },
                            ),

                            SizedBox(
                              height: screenHeight * 0.04,
                            ),

                            NormalButton(
                              onPressed: () async {
                                loading = true;
                                model.setState();
                                await model.checkcode();
                                loading = false;
                                model.setState();
                              },
                              text: locale.get("Confirm") ?? "Confirm",
                              color: AppColors.primary,
                              raduis: 5,
                            )
                          ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  Widget card() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
          width: 2,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      height: 63.0,
      width: 55,
      child: TextFormField(
        maxLength: 1,
        onChanged: (value) {},
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 7.0),
        ),
      ),
    );
  }
}

class ForgetPass1PageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  String phone;
  String code;
  ForgetPass1PageModel(
      {NotifierState state, this.api, this.auth, this.context, this.phone})
      : super(state: state);

  Future<bool> resetpasswordcode() async {
    var res = await api.resetpasswordCode(context, phone: phone);
    res.fold((error) {
      print(error);
      UI.toast("User not found");
      return false;
    }, (data) {
      UI.push(context, Routes.forgetpass1(number: phone));
      return true;
    });
  }

  // Future<bool> changepassword() async {
  //   var res = await api.changepassowrd(context, code: code);
  //   res.fold((error) {
  //     print(error);
  //     UI.toast(error.toString());
  //     return false;
  //   }, (data) {
  //     UI.toast("Password Changed Succesfully");
  //     UI.push(context, Routes.splash);
  //     return true;
  //   });
  // }
  Future<bool> checkcode() async {
    var res = await api.checkcode(context, code: code, email: phone);
    res.fold((error) {
      ErrorDialog(error: error, context: context).showError();

      return false;
    }, (data) {
      UI.push(context, Routes.forgetpass2(email: phone));
      return true;
    });
  }
}
