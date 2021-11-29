import 'dart:convert';
import 'package:Mecca/core/models/user.dart';
import 'package:either_option/either_option.dart';
import 'package:flutter/material.dart';
import 'package:Mecca/core/models/server_error.dart';
import 'package:Mecca/core/services/preference/preference.dart';

class RequestType {
  static const String Get = 'get';
  static const String Post = 'post';
  static const String Put = 'put';
  static const String Delete = 'delete';
}

class Header {
  // static Map<String, dynamic> clientAuth({@required String clientID}) {
  //   final hashedClient = const Base64Encoder().convert("$clientID:".codeUnits);
  //   return {'Authorization': 'Basic $hashedClient'};
  // }

  static Map<String, dynamic> get clientAuth =>
      {'Authorization': 'Bearer +2bhZa9iJzbgIqIZMNQQtLBpddwkvdv0+DXn0SckutQ='};

  static Map<String, dynamic> get userAuth =>
      {'Authorization': 'Bearer ${Preference.getString(PrefKeys.token)}'};
}

class EndPoint {
  static const String TODO = 'todos';
  static const String SIGNIN = 'auth/login';
  static const String ALL_BOATS = 'Boat/all';
  static const String REFRESH_TOKEN = 'auth/refreshToken';
  static const String LOGIN_SOCIAL = 'auth/loginSocial';
  static const String ONBOARDING = 'Splash/all/mobile';

  static const String NOTIFICATIONS = 'Notification';
  static const String FCMTOKEN = 'User/updateFcm/';
  static const String ALL_SERVICES = 'Utility/all';
  static const String ALL_Requests = 'RequestUtility/allUserRequests';
  static const String ALL_PROVIDER_REQUESTS = 'RequestUtility/all';
  static const String ALL_PROVIDER_REQUESTS_Pending =
      'RequestUtility/pending/all';

  static const String GET_BRANCHES = 'Branch/all';
  static const String UTILITY_PRICE = 'Utility/price';
  static const String ADD_REQ = 'RequestUtility';
  static const String UPD_REQ = 'RequestUtility/';
  static const String SEND_MESSAGE = 'ContactUs';
  static const String ALL_STATS = 'PersonStatus/all';
  static const String REGISTER = 'auth/register';
  static const String VERIF_YCODE = 'auth/changeStatus';
  static const String UPDATE_USER = 'User/';
  static const String GET_USER_BY_TOKEN = 'User/byToken';
  static const String GET_USER_WALLET = 'Wallet/walletUser';
  static const String WITH_DRAW_CASH = 'Withdraw';
  static const String RESET_PASSWORD_CODE = 'auth/resetPassword';
  static const String CHANGE_PASS = 'auth/changePasswordMobile';
  static const String CHECK_CODE_RESET_PASS =
      'auth/changePasswordCodeCheckMobile';
  static const String TOKEN = 'auth/token';
  static const String USER = 'user';
  static const String POST = 'posts';
  static const String COMMENT = 'comment';
  static const String REPLY = 'reply';
  static const String RESEND_CODE = 'auth/resendActiveCode';
}

abstract class Api {
  Future<User> getUser(int userId);

  Future<Either<ServerError, dynamic>> signIn(BuildContext context,
      {Map<String, dynamic> body});
}
