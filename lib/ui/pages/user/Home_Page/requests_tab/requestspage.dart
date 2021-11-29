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
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../../styles/colors.dart';

class RequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              locale.get("Requests") ?? "Requests",
            ),
            centerTitle: true,
            backgroundColor: AppColors.primary,
            leading: SizedBox(),
          ),
          body: BaseWidget<RequestsPageModel>(
              // initState: (m) => WidgetsBinding.instance
              //     .addPostFrameCallback((_) => m.getAllrequests()),
              model: RequestsPageModel(
                  api: Provider.of<Api>(context),
                  auth: Provider.of(context),
                  context: context),
              builder: (context, model, child) {
                return Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(
                          text: "${locale.get("All") ?? "All"}",
                        ),
                        Tab(text: "${locale.get("Pending") ?? "Pending"}"),
                        Tab(text: "${locale.get("Approved") ?? "Approved"}"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          AllRequestsPage(),
                          PendingRequestsPage(),
                          ApprovedRequestsPage(),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class RequestsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  RequestsPageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.context,
  }) : super(state: state);
}
