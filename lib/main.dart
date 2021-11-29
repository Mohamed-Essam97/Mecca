import 'package:Mecca/ui/pages/provider_user/provider_home_Page.dart';
import 'package:Mecca/ui/pages/shared/splash_screen.dart';
import 'package:Mecca/ui/pages/user/Home_Page/home_page.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'core/services/localization/localization.dart';
import 'core/services/navigaation_service.dart';
import 'core/services/preference/preference.dart';
import 'core/services/theme/theme_provider.dart';
import 'core/utils/provider_setup.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:Mecca/ui/payment/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preference.init();
  await Firebase.initializeApp();
  await InAppPayments.setSquareApplicationId(squareApplicationId);

  runApp(MyApp());
}

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};
MaterialColor colorCustom = MaterialColor(0xFF315b4d, color);

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MultiProvider(
        providers: providers,
        child: Consumer2<AppLanguageModel, ThemeProvider>(
          builder: (context, language, theme, child) {
            return MaterialApp(
              navigatorKey: NavigationService.navigationKey,
              onGenerateRoute: (RouteSettings settings) {
                switch (settings.name) {
                  case '/ProviderHome':
                    return MaterialPageRoute(
                        builder: (_) => ProviderHomePage());
                  case '/UserHome':
                    return MaterialPageRoute(builder: (_) => HomePage());
                  default:
                    return null;
                }
              },
              home: SplashScreen(),
              debugShowCheckedModeBanner: false,
              // darkTheme: theme.isDark ? ThemeData.dark() : ThemeData.light(),
              // theme: theme.isDark ? theme.dark : theme.light,
              // theme: ThemeData.light(), // Provide light theme.
              theme: theme.isDark ? theme.dark : theme.light,

              locale: language.appLocal,
              supportedLocales: [
                const Locale('en'), //English
                const Locale('ar'), //العربية
                const Locale('fr'), //français
                const Locale('fa'), //فارسى
                const Locale('tr'), //Türkçe
                const Locale('hi'), //भारतीय
                const Locale('zh'), //中文
                const Locale('ur'), //پاکستانی
                const Locale('id'), //BahasaIndonesia
                const Locale('de'), //Deutsche
              ],
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
            );
          },
        ),
      ),
    );
  }

}
