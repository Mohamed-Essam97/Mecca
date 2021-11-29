import 'package:dio/dio.dart';
import 'package:either_option/either_option.dart';
import 'dart:convert';
import 'package:Mecca/core/models/user.dart';

// import 'package:Mecca/core/models/user.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/preference/preference.dart';
import 'package:Mecca/ui/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:Mecca/core/models/server_error.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';
import 'api.dart';

class HttpApi implements Api {
  Future<Either<ServerError, dynamic>> request(String endPoint,
      {body,
      BuildContext context,
      // String serverPath = 'http://server.overrideeg.net:3340/v1/',
      String serverPath = 'http://debug.overrideeg.net:3341/v1/',
      // String serverPath = 'http://mecca.remabackend.com/v1/',
      // String serverPath = 'http://192.168.1.10:3340/v1/',
      Function onSendProgress,
      Map<String, dynamic> headers,
      String type = RequestType.Get,
      Map<String, dynamic> queryParameters,
      String contentType = Headers.jsonContentType,
      bool retry = false,
      ResponseType responseType = ResponseType.json}) async {
    Response response;

    final dio = Dio(BaseOptions(
        baseUrl: serverPath, connectTimeout: 60000, receiveTimeout: 60000));

    final options = Options(
        headers: headers, contentType: contentType, responseType: responseType);

    if (onSendProgress == null) {
      onSendProgress = (int sent, int total) {
        print('$endPoint\n sent: $sent total: $total\n');
      };
    }

    try {
      switch (type) {
        case RequestType.Get:
          {
            response = await dio.get(serverPath + endPoint,
                queryParameters: queryParameters, options: options);
          }
          break;
        case RequestType.Post:
          {
            response = await dio.post(serverPath + endPoint,
                queryParameters: queryParameters,
                onSendProgress: onSendProgress,
                data: body,
                options: options);
          }
          break;
        case RequestType.Put:
          {
            response = await dio.put(endPoint,
                queryParameters: queryParameters, data: body, options: options);
          }
          break;
        case RequestType.Delete:
          {
            response = await dio.delete(endPoint,
                queryParameters: queryParameters, data: body, options: options);
          }
          break;
        default:
          break;
      }

      Logger().i(
          ">>> $type $serverPath$endPoint\n$headers\n Param:$queryParameters");

      print('$type $endPoint\n$headers\nstatusCode:${response.statusCode}\n');

      if (response.statusCode == 201 || response.statusCode == 200) {
        Logger().i(response.data);

        return Right(response.data); //map of string dynamic...
      } else {
        return Left(ServerError(response.data['message']));
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 401 &&
            !retry &&
            context != null &&
            e.response.data["message"] != "invalid password") {
          // sending Refresh token
          Logger().w('Try to send refresh token');
          if (await refreshToken(context)) {
            return await request(endPoint,
                body: body,
                queryParameters: queryParameters,
                serverPath: serverPath,
                headers: Header.userAuth,
                context: context,
                type: type,
                contentType: contentType,
                responseType: responseType,
                retry: true);
          }
        } else if (e.response.statusCode == 401 && retry && context != null) {
          Logger().w("Checking session expired");
          await checkSessionExpired(context: context, response: e.response);
        }
      } else {
        return Left(ServerError(e.response.data['message']));
      }
      return Left(ServerError(e.response.data['message']));
    }
  }

  checkSessionExpired({Response response, BuildContext context}) async {
    if (context != null &&
        (response.statusCode == 401 || response.statusCode == 500)) {
      final expiredMsg = response.data['message'];
      final authExpired = expiredMsg != null && expiredMsg == 'Unauthorized';

      if (authExpired) {
        // await AuthenticationService.handleAuthExpired(context: context);
      }
      return true;
    }
  }

  Future<bool> refreshToken(BuildContext context) async {
    // String oldToken =
    //     Provider.of<AuthenticationService>(context, listen: false).user.token;
    String token;
    User user;

    if (Preference.getString(PrefKeys.userData) != null) {
      var res =
          User.fromJson(jsonDecode(Preference.getString(PrefKeys.userData)));

      // String oldToken = res.token;
      String oldToken = Preference.getString(PrefKeys.token);

      final body = {"oldtoken": oldToken, "email": res.user.email};
      print(body);
      var tokenResponse;
      tokenResponse = await request(EndPoint.REFRESH_TOKEN,
          type: RequestType.Put,
          body: body,
          headers: Header.clientAuth,
          context: context);

      if (tokenResponse != null) {
        tokenResponse.fold((erorr) {
          UI.toast("Error");
        }, (data) {
          print("New token : ${data["token"]}");
          token = data["token"];
          user = User.fromJson(data);
        });
        if (tokenResponse != null && token != null) {
          user.token = token;
          Provider.of<AuthenticationService>(context, listen: false)
              .saveUser(user: user);
        }

        final tokenRefreshed = token != null;

        if (tokenRefreshed) {
          await Preference.setString(PrefKeys.token, token);
          print("token saved");
        }
        return tokenRefreshed;
      } else {
        UI.toast("Error in token");
      }
    } else {
      await Preference.clear();
      UI.pushReplaceAll(context, Routes.login2);
    }
  }

  sendFcmToken(BuildContext context, String fcm, String userId) async {
    final response = await request(EndPoint.FCMTOKEN + userId,
        headers: Header.userAuth,
        type: RequestType.Put,
        context: context,
        body: {"fcmToken": fcm});

    return response;
  }

  Future<Either<ServerError, dynamic>> signInSocial(
      {Map<String, dynamic> body}) async {
    final response = await request(EndPoint.LOGIN_SOCIAL,
        type: RequestType.Post, body: body, headers: Header.clientAuth);
    return response;
  }

  Future<Either<ServerError, dynamic>> signIn(BuildContext context,
      {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.SIGNIN,
        body: body,
        context: context,
        headers: Header.clientAuth,
        type: RequestType.Post);

    return res;
  }

  Future<Either<ServerError, dynamic>> signUp(BuildContext context,
      {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.REGISTER,
        body: body,
        context: context,
        headers: Header.clientAuth,
        type: RequestType.Post);

    return res;
  }

  Future<Either<ServerError, dynamic>> verifyCode(
    BuildContext context, {
    @required String code,
  }) async {
    final res = await request(EndPoint.VERIF_YCODE + '/$code',
        type: RequestType.Post, context: context, headers: Header.userAuth);

    return res;
  }

  Future<Either<ServerError, dynamic>> resetpasswordCode(
    BuildContext context, {
    @required String phone,
  }) async {
    final res = await request(EndPoint.RESET_PASSWORD_CODE + '/$phone',
        type: RequestType.Post, context: context, headers: Header.clientAuth);

    return res;
  }

  Future<Either<ServerError, dynamic>> updateUser(BuildContext context,
      {Map<String, dynamic> body, String userId}) async {
    final res = await request(EndPoint.UPDATE_USER + "$userId",
        context: context,
        type: RequestType.Put,
        headers: Header.userAuth,
        body: body);

    return res;
  }

  Future<Either<ServerError, dynamic>> changepassowrd(
    BuildContext context, {
    @required String email,
    @required String password,
  }) async {
    print(email);
    print(password);
    final res = await request(EndPoint.CHANGE_PASS,
        type: RequestType.Post,
        context: context,
        body: {"email": "$email", "password": "$password"},
        headers: Header.clientAuth);

    return res;
  }

  Future<Either<ServerError, dynamic>> checkcode(BuildContext context,
      {@required String code, String email}) async {
    final res = await request(EndPoint.CHECK_CODE_RESET_PASS + '/$code',
        type: RequestType.Post,
        context: context,
        body: {
          "email": "$email",
        },
        headers: Header.clientAuth);

    return res;
  }

  Future<Either<ServerError, dynamic>> resendCode(
    BuildContext context, {
    @required String code,
  }) async {
    final res = await request(EndPoint.RESEND_CODE,
        type: RequestType.Get, context: context, headers: Header.userAuth);

    return res;
  }

  Future<Either<ServerError, dynamic>> getOnboardingPage(
      BuildContext context, String langCode) async {
    var header = Header.clientAuth;
    header['lang'] = langCode;
    final res = await request(EndPoint.ONBOARDING,
        type: RequestType.Get, context: context, headers: header);

    return res;
  }

  Future<Either<ServerError, dynamic>> getAllServices(
      BuildContext context, String langCode) async {
    var header = Header.userAuth;
    header['lang'] = langCode;
    final res = await request(EndPoint.ALL_SERVICES,
        type: RequestType.Get, context: context, headers: header);

    return res;
  }

  Future<Either<ServerError, dynamic>> getAllRequests(
      BuildContext context, String langCode, param) async {
    var header = Header.userAuth;
    header['lang'] = langCode;
    final res = await request(EndPoint.ALL_Requests,
        type: RequestType.Get,
        queryParameters: param,
        context: context,
        headers: header);

    return res;
  }

  Future<Either<ServerError, dynamic>> getAllPrice(
      BuildContext context, param, String utilityId) async {
    var header = Header.userAuth;
    final res = await request(EndPoint.UTILITY_PRICE + "/${utilityId}",
        type: RequestType.Get,
        queryParameters: param,
        context: context,
        headers: header);

    return res;
  }

  Future<Either<ServerError, dynamic>> getAllBranches(
      BuildContext context) async {
    var header = Header.userAuth;
    final res = await request(EndPoint.GET_BRANCHES,
        type: RequestType.Get, context: context, headers: header);

    return res;
  }

  Future<Either<ServerError, dynamic>> getAllProviderRequests(
      BuildContext context, String langCode, param) async {
    var header = Header.userAuth;
    header['lang'] = langCode;
    final res = await request(EndPoint.ALL_PROVIDER_REQUESTS_Pending,
        type: RequestType.Get,
        queryParameters: param,
        context: context,
        headers: header);

    return res;
  }

  Future<Either<ServerError, dynamic>> acceptRequest(BuildContext context,
      {Map<String, dynamic> body, String requestId}) async {
    final res = await request(EndPoint.ADD_REQ + "/$requestId",
        context: context,
        type: RequestType.Put,
        headers: Header.userAuth,
        body: body);

    return res;
  }

  Future<Either<ServerError, dynamic>> getAllUserNotifications(
      BuildContext context) async {
    final res = await request(EndPoint.NOTIFICATIONS,
        type: RequestType.Get, context: context, headers: Header.userAuth);

    return res;
  }

  Future<Either<ServerError, dynamic>> getUserByToken(
      BuildContext context) async {
    final res = await request(EndPoint.GET_USER_BY_TOKEN,
        type: RequestType.Get, context: context, headers: Header.userAuth);

    return res;
  }

  Future<Either<ServerError, dynamic>> getstats(BuildContext context) async {
    final res = await request(EndPoint.ALL_STATS,
        type: RequestType.Get, context: context, headers: Header.userAuth);
    return res;
  }

  Future<Either<ServerError, dynamic>> getUserWallet(
      BuildContext context) async {
    final res = await request(EndPoint.GET_USER_WALLET,
        type: RequestType.Get, context: context, headers: Header.userAuth);

    return res;
  }

  Future<Either<ServerError, dynamic>> withDrawCash(BuildContext context,
      {@required body}) async {
    final res = await request(EndPoint.WITH_DRAW_CASH,
        type: RequestType.Post,
        context: context,
        body: body,
        headers: Header.userAuth);
    return res;
  }

  Future<Either<ServerError, dynamic>> postRequest(BuildContext context,
      {@required body}) async {
    final res = await request(EndPoint.ADD_REQ,
        type: RequestType.Post,
        context: context,
        body: body,
        headers: Header.userAuth);
    return res;
  }

  Future<Either<ServerError, dynamic>> changeStatus(BuildContext context,
      {@required body, id}) async {
    print(id);
    print(body);
    final res = await request(EndPoint.ADD_REQ + "/$id",
        type: RequestType.Put,
        context: context,
        body: body,
        headers: Header.userAuth);
    return res;
  }

  Future<Either<ServerError, dynamic>> sendMessage(BuildContext context,
      {@required body}) async {
    final res = await request(EndPoint.SEND_MESSAGE,
        type: RequestType.Post,
        context: context,
        body: body,
        headers: Header.userAuth);
    return res;
  }

  @override
  Future<User> getUser(int userId) {
    // TODO: implement getUser
    throw UnimplementedError();
  }
}

//   Future<User> registerUser({@required User user}) async {
//     final response = await request(EndPoint.REGISTER, type: RequestType.Post, body: user.toJson());
//     return response != null ? User.fromJson(response) : null;
//   }

//   Future<String> refreshToken({@required String username, String password}) async {
//     print(username + " " + password);
//     try {
//       final body = {'username': username, 'password': password, 'grant_type': 'password'};
//       final response = await request(EndPoint.TOKEN, type: RequestType.Post, headers: Header.clientAuth, contentType: Headers.formUrlEncodedContentType, body: body);
//       return response != null ? response['access_token'] : null;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   Future<String> uploadImage({@required File image}) async {
//     final formData = FormData.fromMap({'file': await MultipartFile.fromFile(image.path, filename: 'image.png')});
//     final response = await request('upload', type: RequestType.Post, contentType: Headers.contentTypeHeader, body: formData);
//     return response['fileURL'] ?? null;
//   }

//   Future<User> getUser({@required int id}) async {
//     final response = await request(EndPoint.USER + '/$id');

//     return response != null ? User.fromJson(response) : null;
//   }
