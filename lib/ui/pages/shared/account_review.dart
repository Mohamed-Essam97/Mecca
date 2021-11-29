import 'package:Mecca/core/models/user.dart';
import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/ui/pages/provider_user/provider_home_Page.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/loading.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class AccountReviewPage extends StatelessWidget {
  String number;
  AccountReviewPage({this.number});
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final locale = AppLocalizations.of(context);

    return BaseWidget<AccountReviewPageModel>(
        initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
              m.getUserById();
            }),
        model: AccountReviewPageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            context: context),
        builder: (context, model, _child) => Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: !model.busy
                        ? model.user != null
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: ScreenUtil.screenHeightDp / 4,
                                  ),
                                  Container(
                                    width: ScreenUtil.screenWidthDp / 1.5,
                                    height: ScreenUtil.screenHeightDp / 4,
                                    child: Image.network(
                                      "https://banner2.cleanpng.com/20190121/ly/kisspng-kaaba-masjid-al-haram-hajj-umrah-islam-fileemoji-u1f54b-svg-wikimedia-commons-5c45e1d37fed77.306928401548083667524.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.15,
                                  ),
                                  Center(
                                      child: Text(
                                    locale.get(
                                            '"Your account will be reviewed by the admin, We will notify you when you are ready."') ??
                                        '"Your account will be reviewed by the admin, We will notify you when you are ready."',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),

                                  // RaisedButton(
                                  //   onPressed: () async {
                                  //     await model.auth.updateUser(context,
                                  //         body: {'isActive': true});
                                  //     // UI.pushReplaceAll(context, LoginWithSocial());
                                  //   },
                                  //   child: Text("true"),
                                  // ),
                                  // RaisedButton(
                                  //   onPressed: () async {
                                  //     await model.auth
                                  //         .updateUser(context, body: {'isActive': false});
                                  //     // UI.pushReplaceAll(context, LoginWithSocial());
                                  //   },
                                  //   child: Text("false"),
                                  // )
                                ],
                              )
                            : Center(
                                child: Loading(
                                  color: AppColors.primary,
                                  size: 30.0,
                                ),
                              )
                        : Center(
                            child: Loading(
                              color: AppColors.primary,
                              size: 30.0,
                            ),
                          ),
                  ),
                ),
              ),
            ));
  }
}

class AccountReviewPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  FormGroup form;
  AccountReviewPageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.context,
  }) : super(state: state);

  User user;

  getUserById() async {
    setBusy();

    var res = await api.getUserByToken(context);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      setIdle();
      user = User.fromJson(data);
      auth.saveUser(user: user);
      if (user.user.isActive) {
        UI.pushReplaceAll(context, ProviderHomePage());
      }
    });

    user != null ? setIdle() : setError();
  }
}
