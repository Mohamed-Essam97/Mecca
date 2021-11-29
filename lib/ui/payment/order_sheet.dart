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
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'colors.dart';
import 'cookie_button.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';

enum PaymentType { giftcardPayment, cardPayment, googlePay, applePay }
final int cookieAmount = 100;

String getCookieAmount() => (cookieAmount / 100).toStringAsFixed(2);

class OrderSheet extends StatelessWidget {
  final bool googlePayEnabled;
  final bool applePayEnabled;
  final AuthenticationService auth;
  final String servicename;
  final String serviceprice;
  final String no_of_services;

  OrderSheet(
      {this.googlePayEnabled,
      this.applePayEnabled,
      this.auth,
      this.servicename,
      this.no_of_services,
      this.serviceprice});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                child: _title(context),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    minHeight: 300,
                    maxHeight: MediaQuery.of(context).size.height,
                    maxWidth: MediaQuery.of(context).size.width),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _ShippingInformation(
                        auth: auth,
                        servicename: servicename,
                      ),
                      _LineDivider(),
                      _PaymentTotal(
                          serviceprice: serviceprice,
                          numberofservice: no_of_services),
                      _LineDivider(),
                      _RefundInformation(),
                      _payButtons(context),
                    ]),
              ),
            ]),
      );

  Widget _title(context) =>
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
                color: closeButtonColor)),
        Container(
          child: Expanded(
            child: Text(
              "Place your order",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(right: 56)),
      ]);

  Widget _payButtons(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // CookieButton(
          //   text: "Pay with gift card",
          //   onPressed: () {
          //     Navigator.pop(context, PaymentType.giftcardPayment);
          //   },
          // ),
          CookieButton(
            text: "Pay with card",
            onPressed: () {
              Navigator.pop(context, PaymentType.cardPayment);
            },
          ),
          // Container(
          //   height: 64,
          //   width: MediaQuery.of(context).size.width * .3,
          //   child: RaisedButton(
          //     onPressed: googlePayEnabled || applePayEnabled
          //         ? () {
          //             if (Platform.isAndroid) {
          //               Navigator.pop(context, PaymentType.googlePay);
          //             } else if (Platform.isIOS) {
          //               Navigator.pop(context, PaymentType.applePay);
          //             }
          //           }
          //         : null,
          //     child: Image(
          //         image: (Theme.of(context).platform == TargetPlatform.iOS)
          //             ? AssetImage("assets/images/applePayLogo.png")
          //             : AssetImage("assets/images/googlePayLogo.png")),
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(30.0)),
          //     color: Colors.black,
          //   ),
          // ),
        ],
      );
}

class _ShippingInformation extends StatelessWidget {
  var auth;
  var servicename;
  _ShippingInformation({this.auth, this.servicename});
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 30)),
          Text(
            "Service",
            style: TextStyle(fontSize: 16, color: mainTextColor),
          ),
          Padding(padding: EdgeInsets.only(left: 30)),
          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "$servicename",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 6),
                ),
              ]),
        ],
      );
}

class _LineDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      child: Divider(
        height: 1,
        color: dividerColor,
      ));
}

class _PaymentTotal extends StatelessWidget {
  String serviceprice;
  String numberofservice;
  _PaymentTotal({this.serviceprice, this.numberofservice});
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 30)),
          Text(
            "Total",
            style: TextStyle(fontSize: 16, color: mainTextColor),
          ),
          Padding(padding: EdgeInsets.only(right: 47)),
          Text(
            "${int.parse(serviceprice) * int.parse(numberofservice)}\$",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      );
}

class _RefundInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 30.0, right: 30.0),
              width: MediaQuery.of(context).size.width - 60,
              child: Text(
                "You can refund this transaction by contacting us.",
                style: TextStyle(fontSize: 12, color: subTextColor),
              ),
            ),
          ],
        ),
      );
}
