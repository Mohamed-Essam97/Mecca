import 'package:Mecca/core/models/user.dart';
import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TermsofUsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return BaseWidget<TermsofUsePageModel>(
        initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {}),
        model: TermsofUsePageModel(
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
                  "Terms of Use",
                  style: TextStyle(fontSize: 16),
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Definition",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor",
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "First Title",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor",
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}

class TermsofUsePageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  FormGroup form;
  UserInfo userr;
  TermsofUsePageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.userr,
    this.context,
  }) : super(state: state);
}
