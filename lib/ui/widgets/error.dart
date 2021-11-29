import 'dart:ffi';

import 'package:Mecca/ui/styles/colors.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ErrorDialog {
  @required
  final error;
  final context;
  const ErrorDialog({this.error, this.context});
  @override
  showError() {
    CoolAlert.show(
      
      context: context,
      type: CoolAlertType.error,
      backgroundColor: AppColors.primary,
      confirmBtnColor: AppColors.primary,
      text: "${error.toString().substring(11)}",
    );
  }
}
