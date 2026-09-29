import 'package:flutter/material.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';

class TextPriceLineThrough extends StatelessWidget {
  const TextPriceLineThrough({
    super.key,
    required this.price,
  });

  final String price;

  @override
  Widget build(BuildContext context) {
    return Text(
      price,
      style: AppTextStyle.mediumGrey.copyWith(
        decoration: TextDecoration.lineThrough,
      ),
    );
  }
}
