import 'dart:developer';

import 'package:Mecca/core/models/service.dart';
import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/core/services/preference/preference.dart';
import 'package:Mecca/ui/pages/user/Home_Page/service_details.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/loading.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ui_utils/ui_utils.dart';

class UserHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    bool isDark = Preference.getBool(PrefKeys.isDark);

    return FocusWidget(
      child: BaseWidget<UserHomePageModel>(
          initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
                m.getAllServices();
              }),
          model: UserHomePageModel(
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
              context: context),
          builder: (context, model, _child) => Scaffold(
                body: SingleChildScrollView(
                  child: model.busy
                      ? Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: ScreenUtil.screenHeightDp / 2,
                              ),
                              Loading(
                                color: AppColors.primary,
                                size: 40.0,
                              ),
                            ],
                          ),
                        )
                      : model.services == null
                          ? Loading(
                            color: AppColors.primary,
                              size: 30.0,
                            )
                          : model.services.isEmpty
                              ? Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: ScreenUtil.screenHeightDp / 3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(50)),
                                        //  child: Image.network(model.product.image),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://cdn.britannica.com/20/153520-050-177A78E4/Kabah-hajj-pilgrims-Saudi-Arabia-Mecca.jpg",
                                          imageBuilder:
                                              (context, imageProvider) =>
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
                                              padding:
                                                  const EdgeInsets.all(20.0),
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
                                    ),
                                    SizedBox(
                                      height: ScreenUtil.screenHeightDp / 4,
                                    ),
                                    Center(
                                      child: Container(
                                        child: Text(
                                            locale.get("Services Is Empty") ??
                                                "Services Is Empty"),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  height: ScreenUtil.screenHeightDp,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/Pattern.png"),
                                          fit: BoxFit.cover,
                                          colorFilter: isDark
                                              ? ColorFilter.linearToSrgbGamma()
                                              : null)),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: ScreenUtil.screenHeightDp / 3,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(50)),
                                          //  child: Image.network(model.product.image),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "https://cdn.britannica.com/20/153520-050-177A78E4/Kabah-hajj-pilgrims-Saudi-Arabia-Mecca.jpg",
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                Center(
                                                    child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Loading(
                                                  color: AppColors.primary,
                                                  size: 30.0,
                                                ),
                                              ),
                                            )),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "${model.services.length} ${locale.get("Services") ?? "Services"}"),
                                            Row(
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      model.list = false;
                                                      model.setState();
                                                    },
                                                    child: Icon(
                                                      Icons.grid_view,
                                                      color: model.list
                                                          ? Colors.grey
                                                          : Colors.black,
                                                    )),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      model.list = true;
                                                      model.setState();
                                                    },
                                                    child: Icon(
                                                      Icons.view_list,
                                                      color: model.list
                                                          ? Colors.black
                                                          : Colors.grey,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          child: model.list
                                              ? allServicesListView(
                                                  context, model)
                                              : allServicesGridView(
                                                  context, model))
                                    ],
                                  ),
                                ),
                ),
              )),
    );
  }

  Widget allServicesGridView(context, UserHomePageModel model) {
    var mediaQueryData = MediaQuery.of(context);
    final double widthScreen = mediaQueryData.size.width;
    final double heightScreen = mediaQueryData.size.height;
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: (itemWidth / itemHeight), crossAxisCount: 3),
        padding: const EdgeInsets.all(10),
        shrinkWrap: true,
        itemCount: model.services.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                UI.push(
                    context,
                    ServiceDetailsPage(
                      service: model.services[index],
                    ));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      width: ScreenUtil.screenWidthDp / 1,
                      height: ScreenUtil.screenHeightDp / 5,
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        image: DecorationImage(
                            image: AssetImage('assets/images/Mehrab.png')),
                        // border: Border.all(color: AppColors.secondary),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                model.services[index].title,
                                maxLines: 2,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("${model.services[index].defaultPrice} \$")
                          ],
                        ),
                      )),
                ],
              ),
            ),
          );
        });
  }

  Widget allServicesListView(context, UserHomePageModel model) {
    var mediaQueryData = MediaQuery.of(context);
    final double widthScreen = mediaQueryData.size.width;
    final double heightScreen = mediaQueryData.size.height;
    final locale = AppLocalizations.of(context);

    return ListView.builder(
        padding: const EdgeInsets.all(10),
        shrinkWrap: true,
        itemCount: model.services.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                UI.push(
                    context,
                    ServiceDetailsPage(
                      service: model.services[index],
                    ));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        border: Border.all(color: AppColors.secondary),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(model.services[index].title),
                                Text("${model.services[index].defaultPrice} \$")
                              ],
                            ),
                            Icon(
                              model.lang.contains(locale.locale.languageCode)
                                  ? Icons.keyboard_arrow_left_rounded
                                  : Icons.keyboard_arrow_right_rounded,
                              size: 35,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          );
        });
  }
}

class UserHomePageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  final AppLocalizations locale;
  bool list = false;

  UserHomePageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.context,
    this.locale,
  }) : super(state: state);

  List<Utility> services;

  List lang = ["ar", "fa", "ur"];

  getAllServices() async {
    setBusy();
    String langCode = await Preference.getString(PrefKeys.languageCode);

    var res = await api.getAllServices(context, langCode);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      setIdle();
      services = data.map<Utility>((item) => Utility.fromJson(item)).toList();
    });

    services != null ? setIdle() : setError();
  }
}
