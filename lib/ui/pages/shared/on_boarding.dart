import 'package:Mecca/core/models/onboarding.dart';
import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/core/services/preference/preference.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/loading.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';
import 'login_Social.dart';

class On_boardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var items = [1, 2, 3, 4, 5];
    int _current = 0;
    int end = 0;
    return BaseWidget<On_boardingPageModel>(
        initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
              m.getOnboarding();
            }),
        model: On_boardingPageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            context: context),
        builder: (context, model, _child) => Scaffold(
              bottomNavigationBar: model.onboarding != null || !model.busy
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: model.onboarding.map((url) {
                        int index = model.onboarding.indexOf(url);
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index
                                ? Color.fromRGBO(0, 0, 0, 0.9)
                                : Color.fromRGBO(0, 0, 0, 0.4),
                          ),
                        );
                      }).toList(),
                    )
                  : SizedBox(),
              body: SingleChildScrollView(
                  child: !model.busy || model.onboarding != null
                      ? Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 40, 20, 0),
                                child: InkWell(
                                  onTap: () {
                                    UI.push(context, LoginWithSocial());
                                  },
                                  child: Text(
                                    locale.get('Skip') ?? 'Skip',
                                    style: TextStyle(
                                        color: Colors.green[900], fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            CarouselSlider(
                              options: CarouselOptions(
                                  onPageChanged: (index, reason) {
                                    _current = index;
                                    end += 1;

                                    model.setState();
                                    if (end == model.onboarding.length) {
                                      UI.push(context, LoginWithSocial());
                                    }
                                  },
                                  height: MediaQuery.of(context).size.height),
                              items: model.onboarding.map((index) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        decoration: BoxDecoration(
                                            color: Colors.transparent),
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: screenHeight * 0.17,
                                              ),
                                              Container(
                                                width:
                                                    ScreenUtil.screenWidthDp /
                                                        1.5,
                                                height:
                                                    ScreenUtil.screenHeightDp /
                                                        4,
                                                child: Image.network(
                                                  index.image,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.07,
                                              ),
                                              Container(
                                                width:
                                                    ScreenUtil.screenWidthDp /
                                                        1.5,
                                                height:
                                                    ScreenUtil.screenHeightDp /
                                                        4,
                                                child: Text(index.description),
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.23,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: ScreenUtil.screenHeightDp / 3,
                              ),
                              Center(
                                  child: Loading(
                                color: AppColors.primary,
                                size: 50.0,
                              )),
                            ],
                          ),
                        )),
            ));
  }
}

class On_boardingPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  On_boardingPageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.context,
  }) : super(state: state);

  List<OnBoarding> onboarding;

  getOnboarding() async {
    setBusy();
    String langCode = await Preference.getString(PrefKeys.languageCode);

    var res = await api.getOnboardingPage(context, langCode);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      setIdle();
      onboarding =
          data.map<OnBoarding>((item) => OnBoarding.fromJson(item)).toList();
    });

    onboarding != null ? setIdle() : setError();
  }
}
