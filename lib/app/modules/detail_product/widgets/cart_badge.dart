import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({
    super.key,
    required this.iconPath,
    required this.count,
  });

  final String iconPath;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Badge(
      alignment: Alignment.topRight,
      label: Text(
        '$count',
        style: AppTextStyle.smallWhite500,
      ),
      child: SizedBox(
        height: 24,
        width: 24,
        child: SvgPicture.asset(
          Helper.getSvgPath(iconPath),
          colorFilter: ColorFilter.mode(
            AppColors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
