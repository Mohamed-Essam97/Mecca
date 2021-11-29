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

class ForgetPass2Page extends StatelessWidget {
  String email;
  ForgetPass2Page({this.email});
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var _code;
    var _onEditing = true;
    bool loading = false;
    return BaseWidget<ForgetPass2PageModel>(

        // initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
        //       m.checkUser();
        //     }),
        model: ForgetPass2PageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            email: email,
            context: context),
        builder: (context, model, _child) => Scaffold(
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
                                "Reset Password",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),

                            SizedBox(
                              height: screenHeight * 0.04,
                            ),

                            ReactiveField(
                              secure: true,
                              borderColor: Colors.grey,
                              enabledBorderColor: Colors.grey,
                              hintColor: Colors.grey[100],
                              type: ReactiveFields.PASSWORD,
                              controllerName: 'newpassword',
                              label:
                                  locale.get('New Password') ?? 'New Password',
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            ReactiveField(
                              secure: true,
                              borderColor: Colors.grey,
                              enabledBorderColor: Colors.grey,
                              hintColor: Colors.grey[100],
                              type: ReactiveFields.PASSWORD,
                              controllerName: 'newpassword2',
                              label: locale.get('Confirm Password') ??
                                  'Confirm Password',
                            ),
                            SizedBox(
                              height: screenHeight * 0.05,
                            ),

                            NormalButton(
                              onPressed: model.form.valid
                                  ? () async {
                                      if (model.form.valid) {
                                        loading = true;
                                        model.setState();
                                        await model.changepassword();
                                        loading = false;
                                        model.setState();
                                      }
                                    }
                                  : null,
                              text: locale.get('Change Password') ??
                                  'Change Password',
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
            ));
  }
}

class ForgetPass2PageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  FormGroup form;
  String email;
  ForgetPass2PageModel(
      {NotifierState state, this.api, this.auth, this.context, this.email})
      : super(state: state) {
    form = FormGroup({
      'newpassword': FormControl(validators: [
        Validators.required,
      ]),
      'newpassword2': FormControl(validators: [
        Validators.required,
      ]),
    }, validators: [
      Validators.mustMatch('newpassword', 'newpassword2'),
    ]);
  }

  Future<bool> changepassword() async {
    var res = await api.changepassowrd(context,
        email: email, password: form.control('newpassword').value);
    res.fold((error) {
      ErrorDialog(error: error, context: context).showError();
    }, (data) {
      UI.toast("Password Changed Succesfully");
      UI.push(context, Routes.login2);
      return true;
    });
  }
}
