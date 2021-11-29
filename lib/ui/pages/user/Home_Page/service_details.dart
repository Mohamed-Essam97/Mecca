import 'package:Mecca/core/models/onboarding.dart';
import 'package:Mecca/core/models/service.dart';
import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/ui/pages/shared/login_Social.dart';
import 'package:Mecca/ui/pages/user/Home_Page/request_service.dart';
import 'package:Mecca/ui/routes/route.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/buttons/normal_button.dart';
import 'package:Mecca/ui/widgets/loading.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class ServiceDetailsPage extends StatelessWidget {
  Utility service;
  ServiceDetailsPage({this.service});
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return BaseWidget<ServiceDetailsPageModel>(
        // initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
        //       m.getOnboarding();
        //     }),
        model: ServiceDetailsPageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            context: context),
        builder: (context, model, _child) => Scaffold(
            backgroundColor: AppColors.getDarkLightBackGround(),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Stack(
                        children: [
                          Container(
                            height: screenHeight * 0.45,
                            child: CachedNetworkImage(
                              imageUrl: service.image,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Center(
                                  child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Loading(
                                    color: AppColors.primary,
                                    size: 30.0,
                                  ),
                                ),
                              )),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                                alignment: Alignment.topLeft,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    // color: Colors.white,
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "${service.title}",
                                style: TextStyle(
                                    // color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 12, 15, 8),
                      child: Container(
                        height: 530,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              color:
                                  AppColors.getDarkLightSecondaryBackGround(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: Align(
                                  child: Text(
                                    "${service.title}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.getDarkLightColor(),
                                        fontSize: 18),
                                  ),
                                  alignment: Alignment.topLeft,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      locale.get("Price") ?? "Price",
                                      style: TextStyle(
                                          color: Colors.grey[950],
                                          fontSize: 16),
                                    ),
                                    Text(
                                      "${service.defaultPrice} \$",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.yellow[800]),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      locale.get(
                                              "Prices may vary according to days of service") ??
                                          "Prices may vary according to days of service",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          buttonSheet(context, locale);
                                        },
                                        child: Icon(Icons.info_outline_rounded))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: Align(
                                  child: Text(
                                    "${service.description}",
                                    maxLines: 14,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        color: Colors.grey[950], fontSize: 14),
                                  ),
                                  alignment: Alignment.topLeft,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, top: 8.0),
                                  child: NormalButton(
                                    onPressed: () {
                                      UI.push(
                                          context,
                                          RequestServicePage(
                                              servicetitle: service.title,
                                              serviceprice: service.defaultPrice
                                                  .toString(),
                                              serviceid: service.sId));
                                    },
                                    raduis: 5,
                                    height: 100,
                                    width: 50,
                                    color: AppColors.primary,
                                    text: locale.get("Request Now") ??
                                        "Request Now",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  Widget buttonSheet(BuildContext context, locale) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            // color: Colors.white,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locale.get("Date") ?? "Date",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          locale.get("Price") ?? "Price",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: service.prices.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "${(service.prices[index].from.toString().substring(0, 10))}   -   ${(service.prices[index].to.toString().substring(0, 10))}"),
                                    Text(
                                      service.prices[index].price ,
                                      style: TextStyle(
                                          color: AppColors.secondary,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class ServiceDetailsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  ServiceDetailsPageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.context,
  }) : super(state: state);
}
