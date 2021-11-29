import 'package:Mecca/core/models/user.dart';
import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/ui/pages/provider_user/provider_home_Page.dart';
import 'package:Mecca/ui/pages/user/Home_Page/Settings/wallet.dart';
import 'package:Mecca/ui/pages/user/Home_Page/home_page.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/buttons/normal_button.dart';
import 'package:Mecca/ui/widgets/error.dart';
import 'package:Mecca/ui/widgets/reactive_widgets.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class WithDrawPage extends StatelessWidget {
  String wallet;
  WithDrawPage({this.wallet});
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return BaseWidget<WithDrawPageModel>(
        initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {}),
        model: WithDrawPageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            wallet: wallet,
            context: context),
        builder: (context, model, _child) => Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.primary,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  locale.get("Withdraw Cash") ?? "Withdraw Cash",
                  style: TextStyle(fontSize: 16),
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        locale.get("Withdraw Cash") ?? "Withdraw Cash",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ReactiveForm(
                              formGroup: model.form,
                              child: Column(
                                children: [
                                  ReactiveField(
                                    borderColor: Colors.grey,
                                    enabledBorderColor: Colors.grey,
                                    hintColor: Colors.grey[50],
                                    type: ReactiveFields.TEXT,
                                    controllerName: 'bankName',
                                    label:
                                        locale.get('Bank name') ?? 'Bank name',
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ReactiveField(
                                    borderColor: Colors.grey,
                                    enabledBorderColor: Colors.grey,
                                    hintColor: Colors.grey[50],
                                    type: ReactiveFields.TEXT,
                                    controllerName: 'accountName',
                                    label: locale.get('Account name') ??
                                        'Account name',
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ReactiveField(
                                    borderColor: Colors.grey,
                                    enabledBorderColor: Colors.grey,
                                    hintColor: Colors.grey[50],
                                    type: ReactiveFields.TEXT,
                                    controllerName: 'accountNumber',
                                    label: locale.get('Account number') ??
                                        'Account number',
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ReactiveField(
                                    borderColor: Colors.grey,
                                    enabledBorderColor: Colors.grey,
                                    hintColor: Colors.grey[50],
                                    type: ReactiveFields.TEXT,
                                    controllerName: 'ipan',
                                    label: locale.get('IPAN') ?? 'IPAN',
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ReactiveField(
                                    borderColor: Colors.grey,
                                    enabledBorderColor: Colors.grey,
                                    hintColor: Colors.grey[50],
                                    type: ReactiveFields.TEXT,
                                    keyboardType: TextInputType.number,
                                    controllerName: 'amountPriceDraw',
                                    label: locale.get('Amount') ?? 'Amount',
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil.screenWidthDp * 0.3,
                            ),
                            NormalButton(
                              onPressed: model.form.valid
                                  ? () {
                                      if (model.form.valid) {
                                        model.withDraw();
                                      } else {
                                        UI.toast(
                                            locale.get("Please fill data") ??
                                                "Please fill data");
                                      }
                                    }
                                  : null,
                              text: "Request",
                              width: ScreenUtil.screenWidthDp * 0.7,
                              color: model.form.valid
                                  ? AppColors.primary
                                  : Colors.grey,
                              raduis: 5,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}

void showDialog(BuildContext context) {
  final locale = AppLocalizations.of(context);

  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 700),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          height: ScreenUtil.screenHeightDp / 4,
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      locale.get("Successful request") ?? "Successful request",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(locale.get(
                            "You will receive a notification with bank deposits.") ??
                        "You will receive a notification with bank deposits."),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      onPressed: () {
                        UI.pushReplaceAll(context, ProviderHomePage());
                      },
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(width: 2, color: AppColors.primary)),
                      child: Text(
                        locale.get("Home") ?? "Home",
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}

class WithDrawPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  String wallet;
  FormGroup form;

  WithDrawPageModel({
    NotifierState state,
    this.api,
    this.wallet,
    this.auth,
    this.context,
  }) {
    form = FormGroup({
      'bankName': FormControl(
        validators: [Validators.required],
      ),
      'accountName': FormControl<String>(
        validators: [Validators.required],
      ),
      'accountNumber': FormControl<String>(
        validators: [
          Validators.required,
        ],
      ),
      'ipan': FormControl<String>(
        validators: [Validators.required],
      ),
      'amountPriceDraw': FormControl<String>(
        validators: [
          Validators.required,
        ],
      ),
      'approver': FormGroup({
        '_id': FormControl<String>(
          value: auth.user.user.sId,
          validators: [Validators.required],
        ),
      }),
    });
  }

  withDraw() async {
    var res = await api.withDrawCash(context, body: form.value);
    res.fold((error) {
      ErrorDialog(error: error, context: context).showError();
      return false;
    }, (data) {
      showDialog(context);
      UI.toast("Sent Succesfully");
      return true;
    });
  }
}
