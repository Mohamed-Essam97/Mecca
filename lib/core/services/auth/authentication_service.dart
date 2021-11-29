import 'dart:async';
import 'dart:convert';
import 'package:Mecca/core/models/user.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/preference/preference.dart';
import 'package:Mecca/ui/routes/route.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/error.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ui_utils/ui_utils.dart';

class AuthenticationService {
  final HttpApi api;

  User _user;
  User get user => _user;

  AuthenticationService({this.api}) {
    // loadUser;
  }
  bool get userLoged => Preference.getBool(PrefKeys.userLogged) ?? false;

  Future<void> get loadUser async {
    if (userLoged) {
      _user =
          User.fromJson(json.decode(Preference.getString(PrefKeys.userData)));
      // print('\n\n\n\n $_user');
      print('user');
      // Logger().i(_user.toJson());
      // print('\n\n\n\n');
    } else {
      print('\n\n\n\n There is no user saved');
    }
  }

  Future<void> get signOut async {
    await Preference.remove(PrefKeys.userData);
    await Preference.remove(PrefKeys.userLogged);
    await Preference.remove(PrefKeys.fcmToken);
    await Preference.remove(PrefKeys.token);

    _user = null;
  }

  saveUser({User user}) {
    Preference.setBool(PrefKeys.userLogged, true);
    Preference.setString(PrefKeys.userData, json.encode(user.toJson()));
    Preference.setString(PrefKeys.token, user.token);
    _user = user;
  }

  signIn(BuildContext context, {Map<String, dynamic> body}) async {
    var res = await api.signIn(context, body: body);

    User user;

    res.fold((error) {
      ErrorDialog(error: error, context: context).showError();
    }, (data) {
      user = User.fromJson(data);
    });
    if (user != null) {
      // save user
      saveUser(user: user);

      // UI.toast("Hello");
      return true;
    }

    return false;
  }

  signUp(BuildContext context, {Map<String, dynamic> body}) async {
    var res = await api.signUp(context, body: body);
    User user;

    res.fold((error) {
      ErrorDialog(error: error, context: context).showError();
    }, (data) {
      user = User.fromJson(data);
    });

    if (user != null) {
      // save user
      saveUser(user: user);
      UI.toast("Hello");
      return true;
    }

    return false;
  }

  loginWithSocial({Map<String, dynamic> body}) async {
    var res = await api.signInSocial(body: body);

    User user;

    res.fold((error) {
      UI.dialog(msg: error.toString());
    }, (data) {
      user = User.fromJson(data);
    });

    if (user != null) {
      // save user
      saveUser(user: user);
      // UI.toast("Success");
      return true;
    }

    return false;
  }

  sendFCMToken(BuildContext context, {String fcm, String id}) async {
    var res = await api.sendFcmToken(context, fcm, id);
    res.fold((error) {
      UI.toast(error.toString());
    }, (data) async {
      UserInfo us = UserInfo.fromJson(data);
      _user.user = us;
      saveUser(user: _user);
      Logger().i(user.toJson());
      // await Preference.setString(
      //     PrefKeys.fcmToken, user.user.notificationToken);
      return true;
    });
  }

  Future<dynamic> updateUser(BuildContext context,
      {Map<String, dynamic> body}) async {
    var res = await api.updateUser(context, body: body, userId: user.user.sId);

    bool ress = false;

    res.fold((error) {
      UI.toast(error.toString());
      ress = false;
    }, (data) {
      var newUserInfo = UserInfo.fromJson(data);
      user.user = newUserInfo;
      saveUser(user: user);
      ress = true;
    });

    return ress;
  }

  getUserById(BuildContext context) async {
    var res = await api.getUserByToken(context);
    res.fold((error) {
      UI.toast(error.toString());
    }, (data) {
      _user.user = UserInfo.fromJson(data);
      saveUser(user: _user);
    });
  }
}
