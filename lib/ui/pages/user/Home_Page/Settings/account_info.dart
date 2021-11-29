import 'dart:math';

import 'package:Mecca/core/models/onboarding.dart';
import 'package:Mecca/core/models/user.dart';
import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/ui/pages/shared/login_Social.dart';
import 'package:Mecca/ui/routes/route.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/buttons/normal_button.dart';
import 'package:Mecca/ui/widgets/loading.dart';
import 'package:Mecca/ui/widgets/reactive_widgets.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:custom_switch/custom_switch.dart';

class AccountInfoPage extends StatelessWidget {
  UserInfo user;
  AccountInfoPage({this.user});
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return BaseWidget<AccountInfoPageModel>(
        initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
              m.get_countries();
              m.getUserById();
            }),
        model: AccountInfoPageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            userr: user,
            context: context),
        builder: (context, model, _child) => Scaffold(
              appBar: AppBar(
                title: Text(locale.get("Account-Info") ?? "Account-Info"),
                centerTitle: true,
                backgroundColor: AppColors.primary,
                leading: InkWell(
                    onTap: () {
                      Navigator.pop(context, () {
                        model.setState();
                      });
                    },
                    child: Icon(Icons.arrow_back_ios)),
              ),
              body: model.busy
                  ? Center(child: Loading(color: AppColors.primary, size: 40.0))
                  : model.userr == null
                      ? Loading(
                          color: AppColors.primary,
                          size: 30.0,
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ReactiveForm(
                                  formGroup: model.form,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 30,
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
                                            hint: Text("Country"),
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
                                              label: locale.get('State') ??
                                                  'State',
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
                                              label:
                                                  locale.get('City') ?? 'City',
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
                                        initialValue: user.phone,
                                        decoration: InputDecoration(
                                          labelText:
                                              locale.get("Phone Number") ??
                                                  "Phone Number",
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(),
                                          ),
                                        ),
                                        initialCountryCode: 'SA',
                                        onChanged: (phone) {
                                          model.form
                                              .control('phone')
                                              .updateValue(phone.countryCode +
                                                  int.parse(phone.number)
                                                      .toString());
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
                                        label: locale.get('Password') ??
                                            'Password',
                                      ),
                                      // Row(
                                      //   children: [
                                      //     Expanded(
                                      //       child: ReactiveRadioListTile(
                                      //           formControlName: "userType",
                                      //           title: Text("User"),
                                      //           value: "user"),
                                      //     ),
                                      //     Expanded(
                                      //       child: ReactiveRadioListTile(
                                      //           formControlName: "userType",
                                      //           title: Text("Provider"),
                                      //           value: "provider"),
                                      //     ),
                                      //   ],
                                      // ),
                                      NormalButton(
                                        onPressed: () async {
                                          if (model.form.valid) {
                                            model.updateUser();
                                          } else {
                                            UI.toast(locale
                                                    .get("Check your info.") ??
                                                "Check your info.");
                                          }
                                        },
                                        text: "Save",
                                        color: AppColors.primary,
                                        raduis: 5,
                                      ),

                                      SizedBox(
                                        height: screenHeight * 0.02,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
            ));
  }
}

class AccountInfoPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  FormGroup form;
  UserInfo userr;
  AccountInfoPageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.userr,
    this.context,
  }) : super(state: state) {
    form = FormGroup({
      'phone': FormControl(
        value: userr?.phone,
      ),
      'password': FormControl(value: "***********", validators: [
        Validators.minLength(8),
        Validators.maxLength(64),
      ]),
      'name': FormControl(
        value: userr?.name,
      ),
      'email': FormControl(
          value: userr?.email,
          validators: [Validators.email, Validators.required]),
      'state': FormControl(
        value: userr?.state,
      ),
      'city': FormControl(
        value: userr?.city,
      ),
      'country': FormControl(
        value: userr?.country,
      ),
      'userType': FormControl(
          validators: [Validators.required], value: userr?.userType),
    });
  }

  List<DropdownMenuItem> countries = [];
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

  User users;
  String email;

  getUserById() async {
    setBusy();

    var res = await api.getUserByToken(context);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      setIdle();
      users = User.fromJson(data);
      email = users.user.email;
      print(users.user.email);
    });

    users != null ? setIdle() : setError();
  }

  void updateUser() async {
    setBusy();
    bool res = await auth.updateUser(context, body: form.value);
    if (res) {
      setIdle();
      Navigator.pop(context);
    } else {
      setError();
      UI.toast("Error");
    }
  }
}
