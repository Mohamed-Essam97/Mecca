/*
 Copyright 2018 Square Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Mecca/core/services/preference/preference.dart';
import 'package:Mecca/ui/pages/user/Home_Page/payment_success.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:http/http.dart' as http;
import 'package:ui_utils/ui_utils.dart';

// Replace this with the server host you create, if you have your own server running
// e.g. https://server-host.com
String chargeServerHost = "http://mecca.remabackend.com/v1";
String chargeUrl = "$chargeServerHost/Reservation/process-payment";

class ChargeException implements Exception {
  String errorMessage;
  ChargeException(this.errorMessage);
}

Future<void> chargeCard(CardDetails result, formbody, context) async {
  var body = jsonEncode({"nonce": result.nonce, "serviceBody": formbody});
  http.Response response;
  try {
    response = await http.post(chargeUrl, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${Preference.getString(PrefKeys.token)}"
    });
  } on SocketException catch (ex) {
    throw ChargeException(ex.message);
  }

  var responseBody = json.decode(response.body);
  if (response.statusCode == 201) {
    UI.pushReplaceAll(context, PaymentsuccessPage());
    return;
  } else {
    var responseBody2 = json.decode(responseBody["message"]);

    throw ChargeException(responseBody2["result"]["code"]);
  }
}

Future<void> chargeCardAfterBuyerVerification(
    BuyerVerificationDetails result, formbody) async {
  var body = jsonEncode(
      {"nonce": result.nonce, "token": result.token, "serviceBody": formbody});
  http.Response response;
  try {
    response = await http.post(chargeUrl, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
  } on SocketException catch (ex) {
    throw ChargeException(ex.message);
  }

  var responseBody = json.decode(response.body);
  if (response.statusCode == 201) {
    return;
  } else {
    throw ChargeException(responseBody["message"]);
  }
}
