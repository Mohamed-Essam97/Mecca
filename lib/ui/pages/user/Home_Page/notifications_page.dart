import 'package:Mecca/core/models/notification.dart';
import 'package:Mecca/core/models/request.dart';
import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/core/services/preference/preference.dart';
import 'package:Mecca/ui/pages/user/Home_Page/requests_tab/allrequests.dart';
import 'package:Mecca/ui/pages/user/Home_Page/requests_tab/approvedorders.dart';
import 'package:Mecca/ui/pages/user/Home_Page/requests_tab/pendingrequests.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/loading.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ui_utils/ui_utils.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          backgroundColor: AppColors.getDarkLightBackGround(),
          appBar: AppBar(
            title: Text(
              locale.get("Notifications") ?? "Notifications",
            ),
            centerTitle: true,
            backgroundColor: AppColors.primary,
            leading: SizedBox(),
          ),
          body: BaseWidget<NotificationsPageModel>(
              initState: (m) => WidgetsBinding.instance
                  .addPostFrameCallback((_) => m.getAllNotifications()),
              model: NotificationsPageModel(
                  api: Provider.of<Api>(context),
                  auth: Provider.of(context),
                  context: context),
              builder: (context, model, child) {
                return SingleChildScrollView(
                  child: !model.busy
                      ? model.notifications != null
                          ? !model.notifications.isEmpty
                              ? Column(
                                  children: [
                                    ListView.builder(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: model.notifications.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return getAllNotifications(
                                            model, index);
                                      },
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: screenHeight * 0.2,
                                      ),
                                      SvgPicture.asset(
                                        "assets/images/empty_notifications.svg",
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.02,
                                      ),
                                      Text(locale.get(
                                              "We will let you know when we've got something new for you") ??
                                          "We will let you know when we've got something new for you")
                                    ],
                                  ),
                                )
                          : Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: ScreenUtil.screenHeightDp / 3,
                                  ),
                                  Loading(
                                    color: AppColors.primary,
                                    size: 100.0,
                                  ),
                                ],
                              ),
                            )
                      : Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: ScreenUtil.screenHeightDp / 3,
                              ),
                              Loading(
                                color: AppColors.primary,
                                size: 100.0,
                              ),
                            ],
                          ),
                        ),
                );
              }),
        ),
      ),
    );
  }

  Widget getAllNotifications(
    NotificationsPageModel model,
    int index,
  ) {
    final locale = AppLocalizations.of(model.context);
    return InkWell(
        onTap: () async {},
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Container(
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.getDarkLightBackGround2(),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/images/accept.svg"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 3),
                          child: Align(
                            child: Text(
                              model.notifications[index].title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            alignment: Alignment.topLeft,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      model.notifications[index].description,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow[800]),
                    ),
                    Row(
                      children: [
                        Text(
                          model.notifications[index].createAt.substring(0, 10),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[500]),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          model.notifications[index].createAt.substring(11, 16),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            color: Colors.transparent,
          ),
        ));
  }
}

class NotificationsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  NotificationsPageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.context,
  }) : super(state: state);

  List<Noification> notifications;

  getAllNotifications() async {
    setBusy();

    var res = await api.getAllUserNotifications(context);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      setIdle();
      notifications =
          data.map<Noification>((item) => Noification.fromJson(item)).toList();
    });
    notifications != null ? setIdle() : setError();
  }
}
