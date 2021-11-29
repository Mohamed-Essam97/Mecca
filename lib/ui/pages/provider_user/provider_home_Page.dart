import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/ui/pages/provider_user/HomeTabs/provider_home.dart';
import 'package:Mecca/ui/pages/provider_user/requests_tab/requestspage.dart';
import 'package:Mecca/ui/pages/user/Home_Page/Settings/settings.dart';
import 'package:Mecca/ui/pages/user/Home_Page/notifications_page.dart';
import 'package:Mecca/ui/pages/user/Home_Page/user_home.dart';
import 'package:Mecca/ui/pages/user/Home_Page/requests_tab/requestspage.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class ProviderHomePage extends StatelessWidget {
  int index;
ProviderHomePage({this.index});
  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: BaseWidget<ProviderHomePageModel>(
          // initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.getTEAM_ID()),
          model: ProviderHomePageModel(
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
                            coming_index: index,

              context: context),
          builder: (context, model, child) {
            return Scaffold(
                key: model.homeScaffoldKey,

                //endDrawer: NotificationDrawer(context, model),
                // drawer: AppDrawer(ctx: context, model: model),
                bottomNavigationBar: bottomNavBar(context, model),
                body: model.pages[model.currentPageIndex]);
          }),
    );
  }

  bottomNavBar(BuildContext context, ProviderHomePageModel model) {
    final locale = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15), topLeft: Radius.circular(15)),
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: model.currentPageIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (i) {
          model.changeTap(context, i);
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/images/services.svg",
                color: model.currentPageIndex == 0
                    ? AppColors.primary
                    : Colors.grey),
            title: Text(
              locale.get('Services') ?? 'Services',
              style: TextStyle(
                color: model.currentPageIndex == 0
                    ? AppColors.primary
                    : Colors.grey,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/images/requests.svg",
                color: model.currentPageIndex == 1
                    ? AppColors.primary
                    : Colors.grey),
            title: Text(
              locale.get('Requests') ?? 'Requests',
              style: TextStyle(
                  color: model.currentPageIndex == 1
                      ? AppColors.primary
                      : Colors.grey),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/images/bell.svg",
                color: model.currentPageIndex == 2
                    ? AppColors.primary
                    : Colors.grey),
            title: Text(
              locale.get('Notification') ?? 'Notification',
              style: TextStyle(
                  color: model.currentPageIndex == 2
                      ? AppColors.primary
                      : Colors.grey),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/images/settings.svg",
                color: model.currentPageIndex == 3
                    ? AppColors.primary
                    : Colors.grey),
            title: Text(
              locale.get('Setting') ?? 'Setting',
              style: TextStyle(
                  color: model.currentPageIndex == 3
                      ? AppColors.primary
                      : Colors.grey),
            ),
          ),
        ],
        selectedItemColor: AppColors.primary,
      ),
    );
  }
}

class ProviderHomePageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  final GlobalKey<ScaffoldState> homeScaffoldKey =
      new GlobalKey<ScaffoldState>();

  int currentPageIndex = 0;
  int coming_index;

  ProviderHomePageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.coming_index,
    this.context,
  }) : super(state: state){    check_index();
}
  final List<Widget> pages = [
    ProviderPage(),
    ProviderRequestsPage(),
    NotificationsPage(),
    SettingsPage(),
  ];


    check_index() {
    if (coming_index == null) {
      currentPageIndex = 0;
      setState();
    } else {
      currentPageIndex = coming_index;
      setState();
    }
  }

  changeTap(BuildContext context, int i) {
    final locale = AppLocalizations.of(context);

    if (i != currentPageIndex) {
      currentPageIndex = i;
      setState();
    } else {
      return null;
    }
  }
}
