import 'package:flutter/material.dart';
import 'package:img/app/core/styles/app_color.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      color: AppColors.shadowGrey,
    );
  }
}
