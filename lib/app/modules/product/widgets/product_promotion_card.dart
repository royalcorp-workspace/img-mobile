import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/shared/widgets/text/text_price_bold.dart';
import 'package:img/app/shared/widgets/text/text_price_line_through.dart';

class ProductPromotionCard extends StatelessWidget {
  const ProductPromotionCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Helper.getImagePath(
                    'img_product1.jpg',
                  ),
                ),
              ),
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        8.verticalSpace,
        const TextPriceLineThrough(price: 'Rp 72.000'),
        4.verticalSpace,
        const TextPriceBold(
          price: 'Rp 54.000',
          color: AppColors.black,
        )
      ],
    );
  }
}
