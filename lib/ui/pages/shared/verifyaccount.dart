import 'package:Mecca/core/models/user.dart';
import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/ui/pages/provider_user/provider_home_Page.dart';
import 'package:Mecca/ui/pages/user/Home_Page/home_page.dart';
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
import 'dart:async';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timer_button/timer_button.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

import 'account_review.dart';

class VerifyAccountPage extends StatelessWidget {
  String number;
  String type;
  VerifyAccountPage({this.number, this.type});
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var _code;
    var _onEditing = true;
    bool loading = false;
    return BaseWidget<VerifyAccountPageModel>(

        // initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
        //       m.checkUser();
        //     }),
        model: VerifyAccountPageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            type: type,
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
                              locale.get('Verify Account') ?? 'Verify Account',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          Text(
                            locale.get(
                                  "Enter The 4-Digits Sent To Your Mobile",
                                ) ??
                                "Enter The 4-Digits Sent To Your Mobile",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Text(
                            locale.get('Or Email') ?? 'Or Email',
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
                                      '${locale.get("Your Code" ?? "Your Code")} $_code')
                                  : Text(
                                      locale.get('Please Enter Full Code') ??
                                          'Please Enter Full Code',
                                    )),
                          SizedBox(
                            height: screenHeight * 0.04,
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
                                model.resendCode();
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
                              await model.verifyCode();
                              loading = false;
                              model.setState();
                            },
                            text: locale.get("Verify") ?? "Verify",
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
}

class VerifyAccountPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  String type;
  FormGroup form;
  String code;
  VerifyAccountPageModel(
      {NotifierState state, this.api, this.auth, this.context, this.type})
      : super(state: state) {
    form = FormGroup({
      'code': FormControl(value: code),
    });
  }
  User user;

  Future<bool> verifyCode() async {
    var res = await api.verifyCode(context, code: code);
    res.fold((error) {
      UI.toast(error.toString());
      return false;
    }, (data) {
      user = User.fromJson(data);
      auth.saveUser(user: user);

      UI.push(context, HomePage());
    });
  }

  resendCode() async {
    var res = await api.resendCode(context, code: code);
    res.fold((error) {
      ErrorDialog(error: error, context: context).showError();

      return false;
    }, (data) {
      print(data);
      return true;
    });
  }
}
