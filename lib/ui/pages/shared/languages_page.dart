import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/ui/pages/shared/login_Social.dart';
import 'package:Mecca/ui/routes/route.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class LanguagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);

    return BaseWidget<LanguagesPageModel>(

        // initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
        //       m.checkUser();
        //     }),
        model: LanguagesPageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            context: context),
        builder: (context, model, _child) => Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Pattern.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                margin: EdgeInsets.fromLTRB(5, 50, 5, 50),
                child: GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  padding: const EdgeInsets.all(10.0),
                  mainAxisSpacing: 30.0,
                  crossAxisSpacing: 10.0,
                  children: <Widget>[
                    card(context, "English", "en"),
                    card(context, "العربية", "ar"),
                    card(context, "français", "fr"),
                    card(context, "فارسی", "fa"),
                    card(context, "Türkçe", "tr"),
                    card(context, "भारतीय", "hi"),
                    card(context, "中文", "zh"),
                    card(context, "پاکستانی", "ur"),
                    card(context, "Bahasa Indonesia", "id"),
                    card(context, "Deutsche", "de"),
                  ],
                ),
              ),
            ));
  }

  Widget card(context, name, langCode) {
    return InkWell(
      onTap: () {
        Provider.of<AppLanguageModel>(context, listen: false)
            .changeLanguage(Locale(langCode));
        UI.push(context, Routes.onboard);
      },
      child: Container(
        decoration: BoxDecoration(
          //color: Colors.white,
          border: Border.all(
            color: Colors.grey[300],
            width: 3,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.green[900],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LanguagesPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  LanguagesPageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.context,
  }) : super(state: state);
}
