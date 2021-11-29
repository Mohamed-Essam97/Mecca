import 'package:Mecca/core/models/user.dart';
import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/ui/pages/user/Home_Page/home_page.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/buttons/normal_button.dart';
import 'package:Mecca/ui/widgets/error.dart';
import 'package:Mecca/ui/widgets/reactive_widgets.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return BaseWidget<ContactUsPageModel>(
        initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {}),
        model: ContactUsPageModel(
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
                  "Contact Us",
                  style: TextStyle(fontSize: 16),
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          locale.get("Get in touch") ?? "Get in touch",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              wordSpacing: 4),
                        ),
                      ),
                      Text(
                        locale.get("We are here for you! How can we help?") ??
                            "We are here for you! How can we help?",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                UrlLauncher.launch('tel:+9660123456789');
                              },
                              child: Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/images/phone-call.svg",
                                    width: 20,
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.02,
                                  ),
                                  Text("+9660123456789"),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.1,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/images/whatsapp.svg",
                                    width: 20,
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.02,
                                  ),
                                  Text("+966 0123456789"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                              onTap: () {},
                              child: Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/images/phone-call.svg",
                                    width: 20,
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.02,
                                  ),
                                  Text("+966 0123456789"),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.1,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/images/whatsapp.svg",
                                    width: 20,
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.02,
                                  ),
                                  Text("+966 0123456789"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Drop us a message",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ReactiveForm(
                        formGroup: model.form,
                        child: Column(
                          children: <Widget>[
                            //SizedBox(height: screenHeight*0.01,),

                            SizedBox(
                              height: screenHeight * 0.03,
                            ),

                            ReactiveField(
                              borderColor: Colors.grey,
                              enabledBorderColor: Colors.grey,
                              hintColor: Colors.grey[50],
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
                            ReactiveField(
                              borderColor: Colors.grey,
                              enabledBorderColor: Colors.grey,
                              hintColor: Colors.grey[100],
                              type: ReactiveFields.TEXT,
                              controllerName: 'subject',
                              label: locale.get('Subject') ?? 'Subject',
                            ),

                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            ReactiveField(
                              borderColor: Colors.grey,
                              enabledBorderColor: Colors.grey,
                              type: ReactiveFields.HUGE_TEXT,
                              label: "Enter your message here",
                              keyboardType: TextInputType.text,
                              controllerName: 'message',
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: NormalButton(
                                onPressed: model.form.valid
                                    ? () {
                                        if (model.form.valid) {
                                          model.sendmessge();
                                        }
                                      }
                                    : null,
                                raduis: 5,
                                color: model.form.valid
                                    ? AppColors.primary
                                    : Colors.grey,
                                text: locale.get("Send") ?? "Send",
                              ),
                            ),
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

class ContactUsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  FormGroup form;
  UserInfo userr;
  ContactUsPageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.userr,
    this.context,
  }) : super(state: state) {
    form = FormGroup({
      'name': FormControl(
        validators: [Validators.required],
      ),
      'email': FormControl<String>(
        validators: [Validators.required],
      ),
      'subject': FormControl<String>(
        validators: [Validators.required],
      ),
      'message': FormControl(
        validators: [Validators.required],
      ),
    });
  }

  sendmessge() async {
    var res = await api.sendMessage(context, body: form.value);
    res.fold((error) {
      ErrorDialog(error: error, context: context).showError();
      return false;
    }, (data) {
      UI.pushReplaceAll(context, HomePage());
      UI.toast("Sent Succesfully");
      return true;
    });
  }
}
