import 'dart:io';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class MyLoadingWidget extends StatelessWidget {
  const MyLoadingWidget({
    super.key,
    this.color,
    this.strokeWidth = 4.0,
    this.value,
  });
  final Color? color;
  final double strokeWidth;
  final double? value;
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Center(
        child: CircularProgressIndicator(
          value: value,
          strokeWidth: strokeWidth,
          color: color ?? AppColors.kPrimaryColor,
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
  }
}
