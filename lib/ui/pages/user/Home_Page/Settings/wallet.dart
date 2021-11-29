import 'package:Mecca/core/models/user.dart';
import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/ui/pages/provider_user/provider_home_Page.dart';
import 'package:Mecca/ui/pages/user/Home_Page/Settings/with_draw_cash.dart';
import 'package:Mecca/ui/pages/user/Home_Page/home_page.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/buttons/normal_button.dart';
import 'package:Mecca/ui/widgets/loading.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return BaseWidget<WalletPagePageModel>(
        initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
              m.getUserWallet();
            }),
        model: WalletPagePageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            context: context),
        builder: (context, model, _child) => Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.primary,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  locale.get("Wallet") ?? "Wallet",
                  style: TextStyle(fontSize: 16),
                ),
                centerTitle: true,
              ),
              body: model.wallet == null
                  ? Center(
                      child: Loading(
                        color: AppColors.primary,
                        size: 50.0,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              locale.get("Available Credit") ??
                                  "Available Credit",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              "${model.wallet.toString()} \$",
                              style: TextStyle(fontSize: 20),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: ScreenUtil.screenWidthDp * 0.3,
                                ),
                                Center(
                                    child: SvgPicture.asset(
                                        "assets/images/wallet.svg")),
                                SizedBox(
                                  height: ScreenUtil.screenHeightDp * 0.05,
                                ),
                                model.wallet == 0
                                    ? Column(
                                        children: [
                                          Text(
                                            locale.get(
                                                    "Help People And make Money") ??
                                                "Help People And make Money",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil.screenHeightDp *
                                                0.05,
                                          ),
                                          Container(
                                            width:
                                                ScreenUtil.screenWidthDp * 0.7,
                                            child: FlatButton(
                                              onPressed: () {
                                                UI.pushReplaceAll(
                                                    context,
                                                    ProviderHomePage(
                                                        // index: 1,
                                                        ));
                                              },
                                              height: 50,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  side: BorderSide(
                                                      width: 2,
                                                      color:
                                                          AppColors.primary)),
                                              child: Text(
                                                locale.get(
                                                        "Explore Requests") ??
                                                    "Explore Requests",
                                                style: TextStyle(
                                                    color: AppColors.primary,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : NormalButton(
                                        onPressed: () {
                                          UI.push(
                                              context,
                                              WithDrawPage(
                                                wallet: model.wallet.toString(),
                                              ));
                                        },
                                        text: "Withdraw Cash",
                                        width: ScreenUtil.screenWidthDp * 0.7,
                                        color: AppColors.primary,
                                        raduis: 5,
                                      ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
            ));
  }
}

class WalletPagePageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  FormGroup form;
  UserInfo userr;
  WalletPagePageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.userr,
    this.context,
  }) : super(state: state);

  int wallet;
  getUserWallet() async {
    setBusy();

    var res = await api.getUserWallet(context);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      wallet = data['wallet'];
      setIdle();
    });
  }
}
