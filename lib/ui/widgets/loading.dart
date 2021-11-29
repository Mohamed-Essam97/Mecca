import 'dart:ffi';

import 'package:Mecca/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


enum Type {
  SpinKitPulse,
  SpinKitCircle,
  SpinKitDoubleBounce,
  SpinKitFadingCircle,
  SpinKitPouringHourGlass,
  SpinKitDualRing,
  SpinKitChasingDots,
  SpinKitThreeBounce
}

class Loading extends StatelessWidget {
  @required
  final size;
  final Color color;
  const Loading({
    Key key,
    this.size,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SpinKitPulse(
        color: color,
        size: size,
      ),
    );
  }
}
