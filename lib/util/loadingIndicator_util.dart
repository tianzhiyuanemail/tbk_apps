import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingIndicatorUtil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(185),
      child: Container(
        alignment: Alignment.center,
        child: LoadingIndicator(
          indicatorType: Indicator.ballRotateChase,
          color: Colors.black45,
        ),
      ),
    );
  }
}
