import 'package:Mecca/core/models/onboarding.dart';
import 'package:Mecca/core/models/user.dart';
import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/core/services/preference/preference.dart';
import 'package:Mecca/core/services/theme/theme_provider.dart';
import 'package:Mecca/ui/pages/shared/login_Social.dart';
import 'package:Mecca/ui/pages/user/Home_Page/Settings/aboutus.dart';
import 'package:Mecca/ui/pages/user/Home_Page/Settings/account_info.dart';
import 'package:Mecca/ui/pages/user/Home_Page/Settings/contactus.dart';
import 'package:Mecca/ui/pages/user/Home_Page/Settings/privacypolicy.dart';
import 'package:Mecca/ui/pages/user/Home_Page/Settings/termsofuse.dart';
import 'package:Mecca/ui/pages/user/Home_Page/Settings/wallet.dart';
import 'package:Mecca/ui/routes/route.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/styles/text_styles.dart';
import 'package:Mecca/ui/widgets/loading.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:day_night_switcher/day_night_switcher.dart';

class SettingsPage extends StatelessWidget {
  bool status = false;
  bool dark = Preference.getBool(PrefKeys.isDark);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return BaseWidget<SettingsPageModel>(
        initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
              m.getUserById();
            }),
        model: SettingsPageModel(
            themeProvider: Provider.of(context),
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            context: context),
        builder: (context, model, _child) => Scaffold(
              appBar: AppBar(
                title: Text(locale.get("Settings") ?? "Settings"),
                centerTitle: true,
                backgroundColor: AppColors.primary,
                leading: SizedBox(),
              ),
              body: model.busy
                  ? Loading(
                      color: AppColors.primary,
                      size: 30.0,
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                UI
                                    .push(context,
                                        AccountInfoPage(user: model.user.user))
                                    .then((value) => model.onGoBack());
                              },
                              title: Text(
                                locale.get("Account Info") ?? "Account Info",
                              ),
                              trailing: Icon(
                                model.lang.contains(locale.locale.languageCode)
                                    ? Icons.keyboard_arrow_left_rounded
                                    : Icons.keyboard_arrow_right_rounded,
                                size: 35,
                              ),
                            ),
                            model.auth.user.user.userType == "provider"
                                ? ListTile(
                                    onTap: () {
                                      UI.push(context, WalletPage());
                                    },
                                    title: Text(
                                      locale.get("My Wallet") ?? "My Wallet",
                                    ),
                                    trailing: Icon(
                                      model.lang.contains(
                                              locale.locale.languageCode)
                                          ? Icons.keyboard_arrow_left_rounded
                                          : Icons.keyboard_arrow_right_rounded,
                                      size: 35,
                                    ),
                                  )
                                : SizedBox(),
                            ListTile(
                              title: Text(
                                locale.get("Notifications") ?? "Notifications",
                              ),
                              trailing: Container(
                                height: 32,
                                width: 70,
                                child: CustomSwitch(
                                  activeColor: AppColors.primary,
                                  value:
                                      model.auth.user.user.enableNotification,
                                  onChanged: (value) {
                                    print("VALUE : $value");
                                    model.notificationOff(value);

                                    model.setState();
                                  },
                                ),
                              ),
                            ),

                            ListTile(
                              title: Text(
                                  locale.get("Night Mode") ?? "Night Mode"),
                              trailing: Container(
                                // height: 32,
                                width: 70,
                                child: DayNightSwitcher(
                                    isDarkModeEnabled: dark,
                                    onStateChanged: (isDarkModeEnabled) {
                                      dark = isDarkModeEnabled;
                                      model.themeProvider.switchTheme;
                                      dark = isDarkModeEnabled;
                                      model.setState();
                                    }),
                              ),
                            ),

                            Row(
                              children: [
                                SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    locale.get("Language") ?? "Language",
                                  ),
                                ),
                                DropdownButton(
                                  hint: Text('${locale.locale.languageCode}'),
                                  items: [
                                    DropdownMenuItem(
                                        child: Text('English'), value: 'en'),
                                    DropdownMenuItem(
                                        child: Text('Français'), value: 'fr'),
                                    DropdownMenuItem(
                                        child: Text('Arabic'), value: 'ar'),
                                    DropdownMenuItem(
                                        child: Text('فارسی'), value: 'fa'),
                                    DropdownMenuItem(
                                        child: Text('भारतीय'), value: 'hi'),
                                    DropdownMenuItem(
                                        child: Text('中文'), value: 'zh'),
                                    DropdownMenuItem(
                                        child: Text('پاکستانی'), value: 'ur'),
                                    DropdownMenuItem(
                                        child: Text('BahasaIndonesia'),
                                        value: 'id'),
                                    DropdownMenuItem(
                                        child: Text(
                                          'Deutsche',
                                        ),
                                        value: 'de'),
                                  ],
                                  onChanged: (value) {
                                    print(value);
                                    // model.setLang(value);
                                    Provider.of<AppLanguageModel>(context,
                                            listen: false)
                                        .changeLanguage(Locale(value));

                                    print(locale.locale.languageCode);
                                    model.setState();
                                  },
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                            Divider(),
                            InkWell(
                              onTap: () {
                                UI.push(context, AboutUsPage());
                              },
                              child: ListTile(
                                title: Text(
                                  locale.get("About Us") ?? "About Us",
                                ),
                                trailing: Icon(
                                  model.lang
                                          .contains(locale.locale.languageCode)
                                      ? Icons.keyboard_arrow_left_rounded
                                      : Icons.keyboard_arrow_right_rounded,
                                  size: 35,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                UI.push(context, TermsofUsePage());
                              },
                              child: ListTile(
                                title: Text(
                                  locale.get("Terms Of Use") ?? "Terms Of Use",
                                ),
                                trailing: Icon(
                                  model.lang
                                          .contains(locale.locale.languageCode)
                                      ? Icons.keyboard_arrow_left_rounded
                                      : Icons.keyboard_arrow_right_rounded,
                                  size: 35,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                UI.push(context, PrivacyPolicyPage());
                              },
                              child: ListTile(
                                title: Text(
                                  locale.get("Privacy Policy") ??
                                      "Privacy Policy",
                                ),
                                trailing: Icon(
                                  model.lang
                                          .contains(locale.locale.languageCode)
                                      ? Icons.keyboard_arrow_left_rounded
                                      : Icons.keyboard_arrow_right_rounded,
                                  size: 35,
                                ),
                              ),
                            ),
                            Divider(),
                            InkWell(
                              onTap: () {
                                UI.push(context, ContactUsPage());
                              },
                              child: ListTile(
                                title: Text(
                                    locale.get("Contact Us") ?? "Contact Us"),
                                trailing: Icon(
                                  model.lang
                                          .contains(locale.locale.languageCode)
                                      ? Icons.keyboard_arrow_left_rounded
                                      : Icons.keyboard_arrow_right_rounded,
                                  size: 35,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(locale.get("Rate App") ?? "Rate App"),
                              trailing: Icon(
                                model.lang.contains(locale.locale.languageCode)
                                    ? Icons.keyboard_arrow_left_rounded
                                    : Icons.keyboard_arrow_right_rounded,
                                size: 35,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ListTile(
                              onTap: () {
                                model.auth.signOut;
                                UI.pushReplaceAll(context, LoginWithSocial());
                              },
                              title: Text(
                                locale.get("Log Out") ?? "Log Out",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            // ListTile(
                            //   onTap: () async {
                            //     await model.auth.updateUser(context,
                            //         body: {'isActive': false});
                            //     // UI.pushReplaceAll(context, LoginWithSocial());
                            //   },
                            //   title: Text(
                            //     locale.get("Is active false") ??
                            //         "Is active false",
                            //     style: TextStyle(
                            //         color: Colors.black, fontSize: 18),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
            ));
  }
}

class SettingsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  final ThemeProvider themeProvider;
  SettingsPageModel({
    NotifierState state,
    this.api,
    this.themeProvider,
    this.auth,
    this.context,
  }) : super(state: state) {
    getUserById();
  }

  onGoBack() {
    getUserById();
    setState();
  }

  User user;
  String email;

  List lang = ["ar", "fa", "ur"];

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

      email = user.user.email;
      print(user.user.email);
    });

    user != null ? setIdle() : setError();
  }

  User users;

  notificationOff(bool value) async {
    var res = await api.updateUser(context,
        body: {"enableNotification": value}, userId: auth.user.user.sId);
    res.fold((error) {
      UI.toast("Error");
    }, (data) {
      users = User.fromJson(data);
      auth.saveUser(user: user);
      UI.toast("Notification Is $value");
    });
  }
}
