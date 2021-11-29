import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/core/services/notification/notification_service.dart';
import 'package:Mecca/core/services/preference/preference.dart';
import 'package:Mecca/ui/routes/route.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/buttons/normal_button.dart';
import 'package:Mecca/ui/widgets/loading.dart';
import 'package:Mecca/ui/widgets/reactive_widgets.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';
import 'login_Social.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    bool loading = false;

    return BaseWidget<SignUpPageModel>(
        initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
              m.get_countries();
            }),
        model: SignUpPageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            context: context),
        builder: (context, model, _child) => Scaffold(
              appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
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
                      child: ReactiveForm(
                        formGroup: model.form,
                        child: Column(
                          children: <Widget>[
                            //SizedBox(height: screenHeight*0.01,),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                locale.get("Sign Up") ?? "Sign Up",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.03,
                            ),

                            ReactiveField(
                              borderColor: Colors.grey,
                              enabledBorderColor: Colors.grey,
                              hintColor: Colors.grey[100],
                              type: ReactiveFields.TEXT,
                              controllerName: 'name',
                              label: locale.get('Name') ?? 'Name',
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            ReactiveField(
                              borderColor: Colors.grey,
                              enabledBorderColor: Colors.grey,
                              hintColor: Colors.grey[100],
                              type: ReactiveFields.TEXT,
                              controllerName: 'email',
                              label: locale.get('Email') ?? 'Email',
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ReactiveDropdownField(
                                  formControlName: "country",
                                  hint:
                                      Text(locale.get("Country") ?? "Country"),
                                  items: model.countries),
                            ),

                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: ReactiveField(
                                    borderColor: Colors.grey,
                                    enabledBorderColor: Colors.grey,
                                    hintColor: Colors.grey[100],
                                    type: ReactiveFields.TEXT,
                                    controllerName: 'state',
                                    label: locale.get('State') ?? 'State',
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.05,
                                ),
                                Expanded(
                                  child: ReactiveField(
                                    borderColor: Colors.grey,
                                    enabledBorderColor: Colors.grey,
                                    hintColor: Colors.grey[100],
                                    type: ReactiveFields.TEXT,
                                    controllerName: 'city',
                                    label: locale.get('City') ?? 'City',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),

                            // ReactiveField(
                            //   borderColor: Colors.grey,
                            //   enabledBorderColor: Colors.grey,
                            //   hintColor: Colors.grey[100],
                            //   type: ReactiveFields.TEXT,
                            //   keyboardType: TextInputType.number,
                            //   controllerName: 'phone',
                            //   label: locale.get('Phone Number') ??
                            //       'Phone Number',
                            // ),
                            IntlPhoneField(
                              decoration: InputDecoration(
                                labelText: locale.get("Phone Number") ??
                                    "Phone Number",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                              initialCountryCode: 'SA',
                              onChanged: (phone) {
                                model.form.control('phone').updateValue(
                                    phone.countryCode +
                                        int.parse(phone.number).toString());
                              },
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            ReactiveField(
                              borderColor: Colors.grey,
                              enabledBorderColor: Colors.grey,
                              hintColor: Colors.grey[100],
                              type: ReactiveFields.PASSWORD,
                              secure: true,
                              controllerName: 'password',
                              label: locale.get('Password') ?? 'Password',
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ReactiveRadioListTile(
                                      activeColor: AppColors.primary,
                                      formControlName: "userType",
                                      title: Text("User"),
                                      value: "user"),
                                ),
                                Expanded(
                                  child: ReactiveRadioListTile(
                                      formControlName: "userType",
                                      title: Text("Provider"),
                                      value: "provider"),
                                ),
                              ],
                            ),
                            CheckboxListTile(
                              activeColor: AppColors.primary,
                              title: Text(
                                locale.get(
                                        "By Creating Account You Agree The Term Of Use And Privacy Policy") ??
                                    "By Creating Account You Agree The Term Of Use And Privacy Policy",
                                style: TextStyle(fontSize: 13),
                              ),
                              value: model.checkedValue,
                              onChanged: (newValue) {
                                model.checkedValue = !model.checkedValue;

                                model.setState();
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),

                            NormalButton(
                              onPressed: model.form.valid
                                  ? () async {
                                      if (model.form.valid) {
                                        if (model.checkedValue) {
                                          loading = true;
                                          model.setState();
                                          await model.signUp();
                                          loading = false;
                                          model.setState();
                                        } else {
                                          UI.toast(locale.get(
                                              "Please Agree to terms of use and policy." ??
                                                  "Please Agree to terms of use and policy."));
                                        }
                                      } else {
                                        UI.toast(
                                            locale.get("Check your info.") ??
                                                "Check your info.");
                                      }
                                    }
                                  : null,
                              text: locale.get("Sign Up") ?? "Sign Up",
                              color: model.form.valid
                                  ? AppColors.primary
                                  : Colors.grey,
                              raduis: 5,
                            ),

                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(locale.get("Already Have Account? ") ??
                                    "Already Have Account? "),
                                InkWell(
                                  onTap: () {
                                    UI.push(context, LoginWithSocial());
                                  },
                                  child: Text(
                                    locale.get("Log In") ?? "Log In",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}

class SignUpPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  FormGroup form;
  var checkedValue = false;
  var phoneRegex =
      r'(([+][(]?[0-9]{1,3}[)]?)|([(]?[0-9]{4}[)]?))\s*[)]?[-\s\.]?[(]?[0-9]{1,3}[)]?([-\s\.]?[0-9]{3})([-\s\.]?[0-9]{3,4})';
  bool agree = true;
  String usertype;
  List<DropdownMenuItem> countries = [];
  SignUpPageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.context,
  }) : super(state: state) {
    form = FormGroup({
      'phone': FormControl(
        validators: [Validators.required, Validators.pattern(phoneRegex)],
      ),
      'password': FormControl(validators: [
        Validators.minLength(8),
        Validators.maxLength(64),
        Validators.required
      ]),
      'name': FormControl(validators: [Validators.required]),
      'email': FormControl(validators: [Validators.email]),
      'state': FormControl(validators: [Validators.required]),
      'city': FormControl(validators: [Validators.required]),
      'country': FormControl(validators: [Validators.required]),
      'acceptCondition':
          FormControl(validators: [Validators.required], value: agree),
      'userType':
          FormControl(validators: [Validators.required], value: usertype),
      "fcmToken": FormControl(value: Preference.getString(PrefKeys.fcmToken)),
    });
  }

  get_countries() {
    countries.clear();
    var list = ["Egypt", "Egypt2"];
    list.forEach((element) {
      countries.add(DropdownMenuItem<String>(
        value: "$element",
        child: new Text("$element"),
      ));
    });
    setState();
  }

  signUp() async {
    bool res = false;

    setBusy();
    res = await auth.signUp(context, body: form.value);
    if (res) {
      setIdle();
      if (form.control("userType").value == "provider") {
        await NotificationService().init(context);

        UI.pushReplaceAll(context, Routes.account_review);
      } else {
        await NotificationService().init(context);

        UI.push(
            context,
            Routes.verifyaccount(
                number: form.control("phone").value,
                type: form.control("userType").value));
      }
    } else {
      setError();
    }
  }
}
