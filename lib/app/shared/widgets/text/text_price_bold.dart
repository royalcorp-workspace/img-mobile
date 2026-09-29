import 'package:flutter/material.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';

class TextPriceBold extends StatelessWidget {
  const TextPriceBold({
    super.key,
    required this.price,
    this.color,
  });

  final String price;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      price,
      style: AppTextStyle.mediumBlackBold.copyWith(
        color: color ?? AppColors.red,
      ),
    );
  }
}
