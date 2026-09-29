import 'package:flutter/material.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';

class CountdownContainer extends StatelessWidget {
  const CountdownContainer({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 22,
      ),
      decoration: BoxDecoration(
        color: AppColors.redContrast,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: AppTextStyle.mediumWhite500,
      ),
    );
  }
}
