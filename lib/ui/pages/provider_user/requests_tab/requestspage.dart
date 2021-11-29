import 'package:Mecca/core/models/providerRequest.dart';
import 'package:Mecca/core/models/request.dart';
import 'package:Mecca/core/models/status.dart';
import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/core/services/preference/preference.dart';
import 'package:Mecca/ui/pages/user/Home_Page/home_page.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/buttons/normal_button.dart';
import 'package:Mecca/ui/widgets/error.dart';
import 'package:Mecca/ui/widgets/loading.dart';
import 'package:Mecca/ui/widgets/reactive_widgets.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:intl/intl.dart';

import '../provider_home_Page.dart';

bool loading = false;

class ProviderRequestsPage extends StatelessWidget {
  bool isDark = Preference.getBool(PrefKeys.isDark);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    return BaseWidget<ProviderRequestsPageModel>(
        initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
              m.getAllrequests();
            }),
        model: ProviderRequestsPageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            context: context),
        builder: (context, model, _child) => Scaffold(
              appBar: AppBar(
                title: Text(
                  locale.get("Requests") ?? "Requests",
                ),
                centerTitle: true,
                backgroundColor: AppColors.primary,
                leading: SizedBox(),
              ),
              // backgroundColor: Colors.white,
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/Pattern.png"),
                      fit: BoxFit.cover,
                      colorFilter:
                          isDark ? ColorFilter.linearToSrgbGamma() : null),
                ),
                child: SafeArea(
                    child: model.requests != null
                        ? model.requests.isEmpty
                            ? Stack(
                                children: [
                                  loading
                                      ? Center(
                                          child: Loading(
                                            color: Colors.white,
                                            size: 55.0,
                                          ),
                                        )
                                      : SizedBox(),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: screenHeight * 0.2,
                                      ),
                                      SvgPicture.asset(
                                          "assets/images/Request.svg"),
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
                                              ProviderHomePage(
                                                index: 0,
                                              ));
                                        },
                                        raduis: 4,
                                        width: 200,
                                        color: AppColors.primary,
                                        text: "Browse Services",
                                      )
                                    ],
                                  ),
                                ],
                              )
                            : Center(child: requests(context, model))
                        : Center(
                            child: Loading(
                              color: AppColors.primary,
                              size: 100.0,
                            ),
                          )),
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
  ProviderRequestsPageModel model,
  int index,
  context,
  allreq,
) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  var parsedDate =
      DateTime.fromMillisecondsSinceEpoch(allreq[index].executionTime);
  print(parsedDate);
  final locale = AppLocalizations.of(model.context);
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 2),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color.fromRGBO(255, 210, 41, 1))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Align(
              child: Text(
                "${allreq[index].utility.title}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.topLeft,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                  "${formatter.format(parsedDate)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                  allreq[index].numberOfUtilities.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                  allreq[index].name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  locale.get("Status") ?? "Status",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(allreq[index].personStatus.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    // print(model.requests[index].utilityCurrentStatus.name);
                  },
                  child: Text(
                    locale.get("Service Status") ?? "Service Status",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  child: Container(
                      width: 150,
                      height: 50,
                      // child: ReactiveField(

                      //   type: ReactiveFields.DROP_DOWN,
                      //   context: context,
                      //   items: model.requests[index].utility.utilityStatus,
                      //   controllerName: "serviceStatus",
                      //   decoration: InputDecoration.collapsed(hintText: ''),
                      //   hint: "hint",
                      //   onChange: (val) {
                      //     print(val);
                      //   },
                      // )
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: model.requests[index].utilityCurrentStatus ==
                                  null
                              ? null
                              : model.requests[index].utilityCurrentStatus.sId,
                          hint: Text(
                            "${model.requests[index].utilityCurrentStatus == null ? "Change Stage" : model.requests[index].utilityCurrentStatus.name}",
                            style: TextStyle(color: Colors.black),
                          ),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          items: model.requests[index].utility.utilityStatus
                              .map((value) {
                            return DropdownMenuItem<String>(
                              value: value.sId,
                              child: Text(value.name),
                            );
                          }).toList(),
                          onChanged: (val) async {
                            if (model.requests[index].utilityCurrentStatus !=
                                    null &&
                                val ==
                                    model.requests[index].utilityCurrentStatus
                                        .sId) {
                              UI.toast("You are already in this stage");
                            } else {
                              loading = true;
                              await model
                                  .changestatus(model.requests[index].sId, val)
                                  .then((val) async {
                                await model.getAllrequests().then((value) {
                                  loading = false;
                                  model.setState();
                                });
                              });
                            }
                          },
                        ),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
      // height: 700,
    ),
  );
}

class ProviderRequestsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  RefreshController _refreshController = RefreshController();
  FormGroup form;

  ProviderRequestsPageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.context,
  }) : super(state: state);

  List<ProviderRequest> requests;
  Map<String, dynamic> param = {'page': 1};
  List<Status> all_stat;

  refresh() {
    setBusy();
    param['page'] = 1;
    requests = [];
    getAllrequests();
    _refreshController.refreshCompleted();
  }

  getAllrequests() async {
    setBusy();
    String langCode = await Preference.getString(PrefKeys.languageCode);

    var res = await api.getAllRequests(context, langCode, param);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      setIdle();
      requests = data
          .map<ProviderRequest>((item) => ProviderRequest.fromJson(item))
          .toList();
    });
    print(requests);
    requests != null ? setIdle() : setError();
  }

  onload(BuildContext context) async {
    List<ProviderRequest> moreitems;
    String langCode = await Preference.getString(PrefKeys.languageCode);

    param['page'] = param['page'] + 1;
    var res;
    res = await api.getAllRequests(context, langCode, param);
    res.fold((error) => UI.toast(error.toString()), (data) {
      moreitems = data
          .map<ProviderRequest>((item) => ProviderRequest.fromJson(item))
          .toList();
    });
    requests.addAll(moreitems);
    _refreshController.loadComplete();
    setIdle();
  }

  changestatus(reqid, statid) async {
    var body = {
      "utilityCurrentStatus": {"_id": "$statid"}
    };
    var res = await api.changeStatus(context, body: body, id: reqid);
    res.fold((error) {
      ErrorDialog(error: error, context: context).showError();
      return false;
    }, (data) {
      // UI.push(context, Routes.forgetpass2(email: phone));
      UI.toast("Changed Succesfully");
      print("herhehrehrehrererere");
      return true;
    });
  }
}
