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
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ForgetPassPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    bool loading = false;
    return BaseWidget<ForgetPassPageModel>(

        // initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
        //       m.checkUser();
        //     }),
        model: ForgetPassPageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            context: context),
        builder: (context, model, _child) => GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Scaffold(
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
                        child: ReactiveForm(
                          formGroup: model.form,
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
                                  locale.get('Reset Password') ??
                                      'Reset Password',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.03,
                              ),
                              Text(
                                locale.get('Enter Your Mobile Number To Get') ??
                                    'Enter Your Mobile Number To Get',
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text(
                                locale.get('Verification Code') ??
                                    'Verification Code',
                                style: TextStyle(color: Colors.black54),
                              ),
                              SizedBox(
                                height: screenHeight * 0.03,
                              ),

                              ReactiveField(
                                // filled: true,
                                // fillColor: Colors.grey[200],
                                borderColor: Colors.grey,
                                enabledBorderColor: Colors.grey,
                                hintColor: Colors.grey[100],

                                type: ReactiveFields.TEXT,
                                controllerName: 'phone',
                                label: locale.get('Email or Phone Number') ??
                                    'Email or Phone Number',
                              ),
                              SizedBox(
                                height: screenHeight * 0.04,
                              ),

                              NormalButton(
                                onPressed: model.form.valid
                                    ? () async {
                                        loading = true;
                                        model.setState();
                                        await model.resetpasswordcode();
                                        loading = false;
                                        model.setState();
                                      }
                                    : null,
                                text: locale.get('Send Code') ?? 'Send Code',
                                color: model.form.valid
                                    ? AppColors.primary
                                    : Colors.grey,
                                raduis: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}

class ForgetPassPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  FormGroup form;
  var phoneRegex =
      r'(([+][(]?[0-9]{1,3}[)]?)|([(]?[0-9]{4}[)]?))\s*[)]?[-\s\.]?[(]?[0-9]{1,3}[)]?([-\s\.]?[0-9]{3})([-\s\.]?[0-9]{3,4})';
  ForgetPassPageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.context,
  }) : super(state: state) {
    form = FormGroup({
      'phone': FormControl(validators: [
        Validators.required,
        Validators.composeOR([Validators.email, Validators.pattern(phoneRegex)])
      ]),
    });
  }
  Future<bool> resetpasswordcode() async {
    var res = await api.resetpasswordCode(context,
        phone: form.control('phone').value);
    res.fold((error) {
      ErrorDialog(error: error, context: context).showError();

      return false;
    }, (data) {
      UI.push(context, Routes.forgetpass1(number: form.control("phone").value));
      return true;
    });
  }
}
