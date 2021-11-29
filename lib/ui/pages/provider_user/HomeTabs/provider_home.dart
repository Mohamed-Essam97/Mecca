import 'package:Mecca/core/models/providerRequest.dart';
import 'package:Mecca/core/models/providerRequest.dart';
import 'package:Mecca/core/models/providerRequest.dart';
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

class ProviderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('MMMM dd,yyyy').format(now);
    bool isDark = Preference.getBool(PrefKeys.isDark);

    return BaseWidget<ProviderPageModel>(
        initState: (m) => WidgetsBinding.instance
            .addPostFrameCallback((_) => m.getAllProviderrequests()),
        model: ProviderPageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            context: context),
        builder: (context, model, _child) => Scaffold(
              // backgroundColor: Colors.white,
              body: SafeArea(
                  child: Center(
                      child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${locale.get("Welcome") ?? "Welcome"} ${model.auth.user.user.name}",
                          style: TextStyle(fontSize: 25),
                        ),
                        Text(
                          "${formattedDate}",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Divider()
                      ],
                    ),
                  ),
                  !model.busy
                      ? model.requests != null
                          ? model.requests.isEmpty
                              ? SingleChildScrollView(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/Pattern.png"),
                                          fit: BoxFit.cover,
                                          colorFilter: isDark
                                              ? ColorFilter.linearToSrgbGamma()
                                              : null),
                                    ),
                                    height: ScreenUtil.screenHeightDp / 1.4,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: screenHeight * 0.2,
                                        ),
                                        Center(
                                          child: Text(
                                            "No New Requests",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.05,
                                        ),
                                        Center(
                                          child: Container(
                                            width:
                                                ScreenUtil.screenWidthDp * 0.9,
                                            child: Text(
                                              "We will let you know when we've got something new for you",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/Pattern.png"),
                                            fit: BoxFit.cover,
                                            colorFilter: isDark
                                                ? ColorFilter
                                                    .linearToSrgbGamma()
                                                : null),
                                      ),
                                      child: requests(context, model)))
                          : Loading(
                              color: AppColors.primary,
                              size: 30.0,
                            )
                      : Loading(
                          color: AppColors.primary,
                          size: 30.0,
                        ),
                ],
              ))),
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
  ProviderPageModel model,
  int index,
  context,
  allreq,
) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  var parsedDate =
      DateTime.fromMillisecondsSinceEpoch(allreq[index].executionTime);
  final locale = AppLocalizations.of(model.context);
  return InkWell(
      onTap: () async {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Container(
          decoration: BoxDecoration(

              // color: Colors.white,
              border: Border.all(color: AppColors.secondary),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                          color: AppColors.secondary),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                      "${formatter.format(parsedDate)} to ${formatter.format(parsedDate)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.get("Number of service") ?? "Number of service",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${allreq[index].numberOfUtilities} to ${locale.get("Times") ?? "Times"}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.get("Name") ?? "Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${model.requests[index].requestBy.name}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.get("Status") ?? "Status",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(model.requests[index].personStatus.name,
                        style: TextStyle(
                             fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: NormalButton(
                  onPressed: () {
                    model.acceptRequest(model.requests[index].sId);
                    model.requests.removeAt(index);
                    model.setState();
                  },
                  text: "Accept",
                  width: 60,
                  raduis: 5,
                  color: AppColors.primary,
                ),
              )
            ],
          ),
        ),
      ));
}

class ProviderPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  RefreshController _refreshController = RefreshController();

  ProviderPageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.context,
  }) : super(state: state);

  List<ProviderRequest> requests;
  Map<String, dynamic> param = {'page': 1};

  refresh() {
    setBusy();
    param['page'] = 1;
    requests = [];
    getAllProviderrequests();
    _refreshController.refreshCompleted();
  }

  getAllProviderrequests() async {
    setBusy();
    String langCode = await Preference.getString(PrefKeys.languageCode);

    var res = await api.getAllProviderRequests(context, langCode, param);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      setIdle();
      requests = data
          .map<ProviderRequest>((item) => ProviderRequest.fromJson(item))
          .toList();
    });
    // print(requests);
    requests != null ? setIdle() : setError();
  }

  onload(BuildContext context) async {
    List<ProviderRequest> moreitems;
    String langCode = await Preference.getString(PrefKeys.languageCode);

    param['page'] = param['page'] + 1;
    var res;
    res = await api.getAllProviderRequests(context, langCode, param);
    res.fold((error) => UI.toast(error.toString()), (data) {
      moreitems = data
          .map<ProviderRequest>((item) => ProviderRequest.fromJson(item))
          .toList();
    });
    requests.addAll(moreitems);
    _refreshController.loadComplete();
    setIdle();
  }

  void acceptRequest(String requestId) async {
    Map<String, dynamic> body;
    body = {
      "approver": {"_id": auth.user.user.sId},
      "requestUtilityStatus": "approved"
    };

    setBusy();
    var res =
        await api.acceptRequest(context, body: body, requestId: requestId);
    res.fold((error) {
      UI.toast("Error");
    }, (data) {
      setIdle();
      setState();
      // UI.toast("success");
    });

    // Navigator.pop(context);
  }
}
