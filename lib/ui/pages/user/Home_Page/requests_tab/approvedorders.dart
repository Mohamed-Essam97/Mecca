import 'package:Mecca/core/models/request.dart';
import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/core/services/preference/preference.dart';
import 'package:Mecca/ui/pages/user/Home_Page/home_page.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/buttons/normal_button.dart';
import 'package:Mecca/ui/widgets/loading.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:intl/intl.dart';

class ApprovedRequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;

    return BaseWidget<ApprovedRequestsPageModel>(
        initState: (m) => WidgetsBinding.instance
            .addPostFrameCallback((_) => m.getAllrequests()),
        model: ApprovedRequestsPageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            context: context),
        builder: (context, model, _child) => Scaffold(
              backgroundColor: AppColors.getDarkLightBackGround(),
              body: SafeArea(
                child: !model.busy
                    ? model.requests != null
                        ? model.requests.isEmpty
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: screenHeight * 0.2,
                                  ),
                                  SvgPicture.asset("assets/images/Request.svg"),
                                  SizedBox(
                                    height: screenHeight * 0.02,
                                  ),
                                  Center(
                                    child: Text(
                                      "It has been quiet here.",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.05,
                                  ),
                                  NormalButton(
                                    onPressed: () {
                                      UI.pushReplaceAll(
                                          context,
                                          HomePage(
                                            index: 0,
                                          ));
                                    },
                                    raduis: 4,
                                    width: 200,
                                    color: AppColors.primary,
                                    text: "Browse Services",
                                  )
                                ],
                              )
                            : Center(child: requests(context, model))
                        : Center(
                            child: Loading(
                              color: AppColors.primary,
                              size: 100.0,
                            ),
                          )
                    : Center(
                        child: Loading(
                          color: AppColors.primary,
                          size: 100.0,
                        ),
                      ),
              ),
            ));
  }

  Widget requests(BuildContext context, model) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: () {
          model.refresh();
        },
        onLoading: () {
          model.onload(context);
        },
        controller: model._refreshController,
        child: ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: model.requests.length,
          itemBuilder: (BuildContext context, int index) {
            return getreq(model, index, context, model.requests);
          },
        ),
      ),
    );
  }
}

Widget getreq(
  ApprovedRequestsPageModel model,
  int index,
  context,
  allreq,
) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  var parsedDate =
      DateTime.fromMillisecondsSinceEpoch(allreq[index].executionTime);
  print(parsedDate);
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 3),
                  child: Align(
                    child: Text(
                      "${allreq[index].name}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.topLeft,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        locale.get("Price") ?? "Price",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${allreq[index].totalPrice} \$",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow[800]),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        locale.get("Date") ?? "Date",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatter.format(parsedDate),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        locale.get("Status") ?? "Status",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(allreq[index].requestUtilityStatus,
                          style: TextStyle(
                              color: allreq[index].requestUtilityStatus ==
                                      "pending"
                                  ? Colors.red[900]
                                  : Colors.green,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                )
              ],
            ),
          ),
          height: 150,
          color: Colors.transparent,
        ),
      ));
}

class ApprovedRequestsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  RefreshController _refreshController = RefreshController();

  ApprovedRequestsPageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.context,
  }) : super(state: state);

  List<Request> requests;
  Map<String, dynamic> param = {'page': 1};

  refresh() {
    print("here");
    setBusy();
    param['page'] = 1;
    requests = [];
    getAllrequests();
    _refreshController.refreshCompleted();
  }

  getAllrequests() async {
    setBusy();
    String langCode = await Preference.getString(PrefKeys.languageCode);
    param['status'] = 'approved';

    var res = await api.getAllRequests(context, langCode, param);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      setIdle();
      requests = data.map<Request>((item) => Request.fromJson(item)).toList();
    });
    print(requests);
    requests != null ? setIdle() : setError();
  }

  onload(BuildContext context) async {
    List<Request> moreitems;
    String langCode = await Preference.getString(PrefKeys.languageCode);

    param['page'] = param['page'] + 1;
    var res;
    res = await api.getAllRequests(context, langCode, param);
    res.fold((error) => UI.toast(error.toString()), (data) {
      moreitems = data.map<Request>((item) => Request.fromJson(item)).toList();
    });
    requests.addAll(moreitems);
    _refreshController.loadComplete();
    setIdle();
  }
}
