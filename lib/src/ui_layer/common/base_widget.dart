import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app_flutter/src/data_layer/res/app_colors.dart';

class BaseWidget extends StatelessWidget {
  const BaseWidget({
    Key? key,
    required this.body,
    this.padding,
    this.backgroundColor = AppColors.colorPrimary,
    this.bottomNavigationBar,
    this.systemUiOverlayStyle,
    this.topSafeArea = true,
    this.bottomSafeArea = true,
    this.leftSafeArea = true,
    this.rightSafeArea = true,
    this.appBar,
    this.bottomSheet,
  }) : super(key: key);

  final Widget body;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;
  final Widget? bottomNavigationBar;
  final SystemUiOverlayStyle? systemUiOverlayStyle;
  final bool topSafeArea;
  final bool bottomSafeArea;
  final bool leftSafeArea;
  final bool rightSafeArea;
  final PreferredSizeWidget? appBar;
  final Widget? bottomSheet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemUiOverlayStyle ?? SystemUiOverlayStyle.dark,
        child: SafeArea(
            top: topSafeArea,
            bottom: bottomSafeArea,
            left: leftSafeArea,
            right: rightSafeArea,
            child: body),
      ),
      bottomNavigationBar: bottomNavigationBar,
      appBar: appBar,
    );
  }
}
