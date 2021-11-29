import 'package:Mecca/core/models/status.dart';
import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/ui/pages/user/Home_Page/home_page.dart';
import 'package:Mecca/ui/routes/route.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/buttons/normal_button.dart';
import 'package:Mecca/ui/widgets/loading.dart';
import 'package:Mecca/ui/widgets/reactive_widgets.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class PaymentsuccessPage extends StatelessWidget {
  final String serviceprice;
  PaymentsuccessPage({this.serviceprice});
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    bool loading = false;

    return BaseWidget<PaymentsuccessPageModel>(
        // initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
        //       m.get_status();
        //     }),
        model: PaymentsuccessPageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            context: context),
        builder: (context, model, _child) => Scaffold(
              appBar: AppBar(
                  elevation: 0,
                  title: Text(
                    locale.get("Payment") ?? "Payment",
                  ),
                  centerTitle: true,
                  backgroundColor: AppColors.primary,
                  leading: SizedBox()),
              body: Stack(
                children: [
                  loading
                      ? Center(
                          child: Loading(
                            color: AppColors.primary,
                            size: 50.0,
                          ),
                        )
                      : SizedBox(),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: screenHeight * 0.15,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SvgPicture.asset("assets/images/Done.svg"),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                locale.get(
                                      "Your Request has been added. We will notify you when someone approve.",
                                    ) ??
                                    "Your Request has been added. We will notify you when someone approve.",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FlatButton(
                                    onPressed: () {
                                      UI.pushReplaceAll(context, HomePage());
                                    },
                                    height: 50,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(
                                            width: 2,
                                            color: AppColors.primary)),
                                    child: Text(
                                      locale.get("Services") ?? "Services",
                                      style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FlatButton(
                                    onPressed: () {
                                      UI.pushReplaceAll(
                                          context,
                                          HomePage(
                                            index: 1,
                                          ));
                                    },
                                    height: 50,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(
                                            width: 2,
                                            color: AppColors.primary)),
                                    child: Text(
                                      locale.get("Requests") ?? "Requests",
                                      style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}

class PaymentsuccessPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  FormGroup form;
  var checkedValue = false;

  bool agree = true;
  String usertype;
  List<DropdownMenuItem> status = [];
  List<Status> all_stat;

  PaymentsuccessPageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.context,
  }) : super(state: state);
}
