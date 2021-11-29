import 'package:Mecca/core/models/status.dart';
import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/ui/pages/user/Home_Page/payment_success.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/buttons/normal_button.dart';
import 'package:Mecca/ui/widgets/loading.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/google_pay_constants.dart'
    as google_pay_constants;
import 'package:square_in_app_payments/models.dart';
import 'config.dart';
import 'dart:io' show Platform;
import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'transaction_service.dart';
import 'dialog_modal.dart';
// We use a custom modal bottom sheet to override the default height (and remove it).
import 'modal_bottom_sheet.dart' as custom_modal_bottom_sheet;
import 'order_sheet.dart';
// import 'package:square_in_app_payments/models.dart';
// import 'package:square_in_app_payments/in_app_payments.dart';
// import 'package:square_in_app_payments/google_pay_constants.dart'
// as google_pay_constants;

class PaymentPage extends StatelessWidget {
  final String serviceprice;
  final String servicename;
  final String numberofservices;
  bool isCash;
  final formdata;
  PaymentPage(
      {this.serviceprice,
      this.servicename,
      this.formdata,
      this.isCash,
      this.numberofservices});
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    bool loading = false;
    int checked = 1;
    return BaseWidget<PaymentPageModel>(
        initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
              m._initSquarePayment();
            }),
        model: PaymentPageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            servicename: servicename,
            serviceprice: serviceprice,
            numberofservices: numberofservices,
            formdata: formdata,
            context: context),
        builder: (context, model, _child) => Scaffold(
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(8.0),
                child: NormalButton(
                  onPressed: () {
                    model._showOrderSheet();
                  },
                  raduis: 2,
                  color: AppColors.primary,
                  text: locale.get("Confirm") ?? "Confirm",
                ),
              ),
              appBar: AppBar(
                  elevation: 0,
                  title: Text(
                    locale.get("Payment") ?? "Payment",
                  ),
                  centerTitle: true,
                  backgroundColor: AppColors.primary,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  locale.get("Total Price") ?? "Total Price",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${int.parse(serviceprice) * int.parse(numberofservices)}\$",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.yellow[800]),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                locale.get("Payment Method") ??
                                    "Payment Method",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Row(
                            children: [
                              new Radio(
                                onChanged: (value) {},
                                activeColor: AppColors.primary,
                                value: checked,
                                groupValue: checked,
                              ),
                              new Text(
                                locale.get("Apple Pay & Google Pay") ??
                                    "Apple Pay & Google Pay",
                                style: new TextStyle(fontSize: 16.0),
                              ),

                              // Padding(
                              //   padding: const EdgeInsets.all(20.0),
                              //   child: SvgPicture.asset(
                              //       "assets/images/applelogo.svg"),
                              // ),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     new Radio(
                          //       onChanged: (value) {
                          //         isCash = value;
                          //         model.setState();
                          //       },
                          //       activeColor: AppColors.primary,
                          //       value: isCash,
                          //       groupValue: checked,
                          //     ),
                          //     new Text(
                          //       locale.get("Cash") ?? "Cash",
                          //       style: new TextStyle(fontSize: 16.0),
                          //     ),

                          //     // Padding(
                          //     //   padding: const EdgeInsets.all(20.0),
                          //     //   child: SvgPicture.asset(
                          //     //       "assets/images/applelogo.svg"),
                          //     // ),
                          //   ],
                          // ),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: ReactiveRadioListTile(
                          //           formControlName: "paymentType",
                          //           title: Text(
                          //             locale.get("Google Pay") ??
                          //                 "Google Pay",
                          //           ),
                          //           value: "google"),
                          //     ),
                          //     Padding(
                          //       padding: const EdgeInsets.all(20.0),
                          //       child: SvgPicture.asset(
                          //           "assets/images/gopaylogo.svg"),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}

enum ApplePayStatus { success, fail, unknown }

class PaymentPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  FormGroup form;
  var checkedValue = false;

  bool agree = true;
  String usertype;
  String servicename;
  String serviceprice;
  String numberofservices;
  List<DropdownMenuItem> status = [];
  List<Status> all_stat;
  var formdata;
  bool isLoading = true;
  bool applePayEnabled = false;
  bool googlePayEnabled = false;

  PaymentPageModel(
      {NotifierState state,
      this.api,
      this.auth,
      this.context,
      this.servicename,
      this.formdata,
      this.numberofservices,
      this.serviceprice})
      : super(state: state);
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
  Future<void> _initSquarePayment() async {
    await InAppPayments.setSquareApplicationId(squareApplicationId);

    var canUseApplePay = false;
    var canUseGooglePay = false;
    if (Platform.isAndroid) {
      await InAppPayments.initializeGooglePay(
          squareLocationId, google_pay_constants.environmentTest);
      canUseGooglePay = await InAppPayments.canUseGooglePay;
    } else if (Platform.isIOS) {
      await _setIOSCardEntryTheme();
      await InAppPayments.initializeApplePay(applePayMerchantId);
      canUseApplePay = await InAppPayments.canUseApplePay;
    }
    setState();

    isLoading = false;
    applePayEnabled = canUseApplePay;
    googlePayEnabled = canUseGooglePay;
    print(googlePayEnabled);
    setState();
  }

  Future _setIOSCardEntryTheme() async {
    var themeConfiguationBuilder = IOSThemeBuilder();
    themeConfiguationBuilder.saveButtonTitle = 'Pay';
    themeConfiguationBuilder.errorColor = RGBAColorBuilder()
      ..r = 255
      ..g = 0
      ..b = 0;
    themeConfiguationBuilder.tintColor = RGBAColorBuilder()
      ..r = 36
      ..g = 152
      ..b = 141;
    themeConfiguationBuilder.keyboardAppearance = KeyboardAppearance.light;
    themeConfiguationBuilder.messageColor = RGBAColorBuilder()
      ..r = 114
      ..g = 114
      ..b = 114;

    await InAppPayments.setIOSCardEntryTheme(themeConfiguationBuilder.build());
  }

  ApplePayStatus _applePayStatus = ApplePayStatus.unknown;

  bool get _chargeServerHostReplaced => chargeServerHost != "REPLACE_ME";

  bool get _squareLocationSet => squareLocationId != "REPLACE_ME";

  bool get _applePayMerchantIdSet => applePayMerchantId != "REPLACE_ME";

  void _showOrderSheet() async {
    var selection =
        await custom_modal_bottom_sheet.showModalBottomSheet<PaymentType>(
            context: context,
            builder: (context) => OrderSheet(
                  applePayEnabled: applePayEnabled,
                  googlePayEnabled: googlePayEnabled,
                  auth: auth,
                  servicename: servicename,
                  serviceprice: serviceprice,
                  no_of_services: numberofservices,
                ));

    switch (selection) {
      case PaymentType.giftcardPayment:
        // call _onStartGiftCardEntryFlow to start Gift Card Entry.
        await _onStartGiftCardEntryFlow();
        break;
      case PaymentType.cardPayment:
        // call _onStartCardEntryFlow to start Card Entry without buyer verification (SCA)
        await _onStartCardEntryFlow();
        // OR call _onStartCardEntryFlowWithBuyerVerification to start Card Entry with buyer verification (SCA)
        // NOTE this requires _squareLocationSet to be set
        // await _onStartCardEntryFlowWithBuyerVerification();
        break;
      case PaymentType.googlePay:
        if (_squareLocationSet && googlePayEnabled) {
          _onStartGooglePay();
        } else {
          _showSquareLocationIdNotSet();
        }
        break;
      case PaymentType.applePay:
        if (_applePayMerchantIdSet && applePayEnabled) {
          _onStartApplePay();
        } else {
          _showapplePayMerchantIdNotSet();
        }
        break;
    }
  }

  void printCurlCommand(String nonce, String verificationToken) {
    var hostUrl = 'https://connect.squareup.com';
    if (squareApplicationId.startsWith('sandbox')) {
      hostUrl = 'https://connect.squareupsandbox.com';
    }
    var uuid = Uuid().v4();

    if (verificationToken == null) {
      print('curl --request POST $hostUrl/v2/payments \\'
          '--header \"Content-Type: application/json\" \\'
          '--header \"Authorization: Bearer YOUR_ACCESS_TOKEN\" \\'
          '--header \"Accept: application/json\" \\'
          '--data \'{'
          '\"idempotency_key\": \"$uuid\",'
          '\"amount_money\": {'
          '\"amount\": $cookieAmount,'
          '\"currency\": \"USD\"},'
          '\"source_id\": \"$nonce\"'
          '}\'');
    } else {
      print('curl --request POST $hostUrl/v2/payments \\'
          '--header \"Content-Type: application/json\" \\'
          '--header \"Authorization: Bearer YOUR_ACCESS_TOKEN\" \\'
          '--header \"Accept: application/json\" \\'
          '--data \'{'
          '\"idempotency_key\": \"$uuid\",'
          '\"amount_money\": {'
          '\"amount\": $cookieAmount,'
          '\"currency\": \"USD\"},'
          '\"source_id\": \"$nonce\",'
          '\"verification_token\": \"$verificationToken\"'
          '}\'');
    }
  }

  void _showUrlNotSetAndPrintCurlCommand(String nonce,
      {String verificationToken}) {
    String title;
    if (verificationToken != null) {
      title = "Nonce and verification token generated but not charged";
    } else {
      title = "Nonce generated but not charged";
    }
    showAlertDialog(
        context: scaffoldKey.currentContext,
        title: title,
        description:
            "Check your console for a CURL command to charge the nonce, or replace CHARGE_SERVER_HOST with your server host.");
    printCurlCommand(nonce, verificationToken);
  }

  void _showSquareLocationIdNotSet() {
    showAlertDialog(
        context: scaffoldKey.currentContext,
        title: "Missing Square Location ID",
        description:
            "To request a Google Pay nonce, replace squareLocationId in main.dart with a Square Location ID.");
  }

  void _showapplePayMerchantIdNotSet() {
    showAlertDialog(
        context: scaffoldKey.currentContext,
        title: "Missing Apple Merchant ID",
        description:
            "To request an Apple Pay nonce, replace applePayMerchantId in main.dart with an Apple Merchant ID.");
  }

  void _onCardEntryComplete() {
    if (_chargeServerHostReplaced) {
      showAlertDialog(
          context: scaffoldKey.currentContext,
          title: "Your order was successful",
          description:
              "Go to your Square dashboard to see this order reflected in the sales tab.");
    }
  }

  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    // await chargeCard(result);

    if (!_chargeServerHostReplaced) {
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
      _showUrlNotSetAndPrintCurlCommand(result.nonce);
      return;
    }
    try {
      await chargeCard(result, formdata, context);
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
    } on ChargeException catch (ex) {
      InAppPayments.showCardNonceProcessingError(ex.errorMessage);
    }
  }

  Future<void> _onStartCardEntryFlow() async {
    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: _onCancelCardEntryFlow,
        collectPostalCode: true);
  }

  Future<void> _onStartGiftCardEntryFlow() async {
    await InAppPayments.startGiftCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: _onCancelCardEntryFlow);
  }

  Future<void> _onStartCardEntryFlowWithBuyerVerification(formbody) async {
    var money = Money((b) => b
      ..amount = 100
      ..currencyCode = 'USD');

    var contact = Contact((b) => b
      ..givenName = "John"
      ..familyName = "Doe"
      ..addressLines =
          new BuiltList<String>(["London Eye", "Riverside Walk"]).toBuilder()
      ..city = "London"
      ..countryCode = "GB"
      ..email = "johndoe@example.com"
      ..phone = "8001234567"
      ..postalCode = "SE1 7");

    await InAppPayments.startCardEntryFlowWithBuyerVerification(
        onBuyerVerificationSuccess: _onBuyerVerificationSuccess,
        onBuyerVerificationFailure: _onBuyerVerificationFailure,
        onCardEntryCancel: _onCancelCardEntryFlow,
        buyerAction: "Charge",
        money: money,
        squareLocationId: squareLocationId,
        contact: contact,
        collectPostalCode: true);
  }

  void _onCancelCardEntryFlow() {
    _showOrderSheet();
  }

  void _onStartGooglePay() async {
    try {
      // await InAppPayments.startCardEntryFlow(
      //     onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
      //     onCardEntryCancel: _onCancelCardEntryFlow);
      await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onGooglePayNonceRequestSuccess,
      );
      await InAppPayments.requestGooglePayNonce(
          priceStatus: google_pay_constants.totalPriceStatusFinal,
          price: serviceprice,
          currencyCode: 'USD',
          onGooglePayNonceRequestSuccess: _onGooglePayNonceRequestSuccess,
          onGooglePayNonceRequestFailure: _onGooglePayNonceRequestFailure,
          onGooglePayCanceled: onGooglePayEntryCanceled);
    } on PlatformException catch (ex) {
      showAlertDialog(
          context: scaffoldKey.currentContext,
          title: "Failed to start GooglePay",
          description: ex.toString());
    }
  }

  void _onGooglePayNonceRequestSuccess(CardDetails result) async {
    if (!_chargeServerHostReplaced) {
      _showUrlNotSetAndPrintCurlCommand(result.nonce);
      return;
    }
    try {
      await chargeCard(result, formdata, context);
      showAlertDialog(
          context: scaffoldKey.currentContext,
          title: "Your order was successful",
          description:
              "Go to your Square dashbord to see this order reflected in the sales tab.");
    } on ChargeException catch (ex) {
      showAlertDialog(
          context: scaffoldKey.currentContext,
          title: "Error processing GooglePay payment",
          description: ex.errorMessage);
    }
  }

  void _onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
    showAlertDialog(
        context: scaffoldKey.currentContext,
        title: "Failed to request GooglePay nonce",
        description: errorInfo.toString());
  }

  void onGooglePayEntryCanceled() {
    _showOrderSheet();
  }

  void _onBuyerVerificationFailure(ErrorInfo errorInfo) async {
    showAlertDialog(
        context: scaffoldKey.currentContext,
        title: "Error verifying buyer",
        description: errorInfo.toString());
  }

  void _onStartApplePay() async {
    try {
      await InAppPayments.requestApplePayNonce(
          price: getCookieAmount(),
          summaryLabel: 'Cookie',
          countryCode: 'US',
          currencyCode: 'USD',
          paymentType: ApplePayPaymentType.finalPayment,
          onApplePayNonceRequestSuccess: _onApplePayNonceRequestSuccess,
          onApplePayNonceRequestFailure: _onApplePayNonceRequestFailure,
          onApplePayComplete: _onApplePayEntryComplete);
    } on PlatformException catch (ex) {
      showAlertDialog(
          context: scaffoldKey.currentContext,
          title: "Failed to start ApplePay",
          description: ex.toString());
    }
  }

  void _onApplePayNonceRequestSuccess(CardDetails result) async {
    if (!_chargeServerHostReplaced) {
      await InAppPayments.completeApplePayAuthorization(isSuccess: false);
      _showUrlNotSetAndPrintCurlCommand(result.nonce);
      return;
    }
    try {
      await chargeCard(result, formdata, context);
      _applePayStatus = ApplePayStatus.success;
      showAlertDialog(
          context: scaffoldKey.currentContext,
          title: "Your order was successful",
          description:
              "Go to your Square dashbord to see this order reflected in the sales tab.");
      await InAppPayments.completeApplePayAuthorization(isSuccess: true);
    } on ChargeException catch (ex) {
      await InAppPayments.completeApplePayAuthorization(
          isSuccess: false, errorMessage: ex.errorMessage);
      showAlertDialog(
          context: scaffoldKey.currentContext,
          title: "Error processing ApplePay payment",
          description: ex.errorMessage);
      _applePayStatus = ApplePayStatus.fail;
    }
  }

  void _onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    _applePayStatus = ApplePayStatus.fail;
    await InAppPayments.completeApplePayAuthorization(
        isSuccess: false, errorMessage: errorInfo.message);
    showAlertDialog(
        context: scaffoldKey.currentContext,
        title: "Error request ApplePay nonce",
        description: errorInfo.toString());
  }

  void _onApplePayEntryComplete() {
    if (_applePayStatus == ApplePayStatus.unknown) {
      // the apple pay is canceled
      _showOrderSheet();
    }
  }

  _onBuyerVerificationSuccess(BuyerVerificationDetails result) async {
    if (!_chargeServerHostReplaced) {
      _showUrlNotSetAndPrintCurlCommand(result.nonce,
          verificationToken: result.token);
      return;
    }

    try {
      await chargeCardAfterBuyerVerification(result, formdata);
    } on ChargeException catch (ex) {
      showAlertDialog(
          context: scaffoldKey.currentContext,
          title: "Error processing card payment",
          description: ex.errorMessage);
    }
  }
}
