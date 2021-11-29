import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/core/services/notification/notification_service.dart';
import 'package:Mecca/ui/pages/provider_user/provider_home_Page.dart';
import 'package:Mecca/ui/pages/shared/account_review.dart';
import 'package:Mecca/ui/pages/user/Home_Page/home_page.dart';
import 'package:Mecca/ui/routes/route.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:Mecca/core/services/preference/preference.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var items = [1, 2, 3, 4, 5];
    int _current = 0;
    return BaseWidget<SplashScreenModel>(
        initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
              Future.delayed(Duration(seconds: 2)).then((value) async {
                var authmodel =
                    Provider.of<AuthenticationService>(context, listen: false);

                if (authmodel.userLoged) {
                  // load user
                  await authmodel.loadUser;
                  if (authmodel.user.user.userType != "admin") {
                    if (authmodel.user.user.userType == "provider") {
                      if (authmodel.user.user.isActive) {
                        UI.pushReplaceAll(context, ProviderHomePage());
                      } else {
                        UI.pushReplaceAll(context, AccountReviewPage());
                      }
                    } else {
                      if (authmodel.user.user.isActive) {
                        UI.pushReplaceAll(context, HomePage());
                      } else {
                        UI.pushReplaceAll(
                            context,
                            Routes.verifyaccount(
                                number: authmodel.user.user.phone,
                                type: "user"));
                      }
                    }
                  } else {
                    UI.toast("Can't login as an admin, Go to Admin Panel");
                  }
                } else {
                  UI.pushReplaceAll(context, Routes.languagePage);
                }
              });
            }),
        model: SplashScreenModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            context: context),
        builder: (context, model, _child) => Scaffold(
              backgroundColor: AppColors.primary,
              body: Container(),
            ));
  }
}

class SplashScreenModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  SplashScreenModel({
    NotifierState state,
    this.api,
    this.auth,
    this.context,
  }) : super(state: state) {
    init();
    // NotificationService().init(context);
  }

  void init() async {
    await Provider.of<NotificationService>(context, listen: false)
        .init(context);
    auth.loadUser;
    auth.sendFCMToken(context,
        fcm: Preference.getString(PrefKeys.fcmToken), id: auth.user.user.sId);
  }
}
