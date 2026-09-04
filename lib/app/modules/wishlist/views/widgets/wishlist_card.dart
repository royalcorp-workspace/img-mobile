import 'package:flutter/material.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/shared/widgets/text/text_price_bold.dart';
import 'package:img/app/shared/widgets/text/text_price_line_through.dart';

class WishlistCard extends StatelessWidget {
  const WishlistCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: Image.asset(
                  height: 130,
                  width: double.infinity,
                  Helper.getImagePath(
                    'img_product1.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
                // Image.network(
                //   "https://picsum.photos/300",
                //   height: 130,
                //   width: double.infinity,
                //   fit: BoxFit.cover,
                // ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "-30%",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Elite Springbed Kasur Pocket Emporium New Edition",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.mediumBlackBold,
                  ),
                  const SizedBox(height: 6),
                  TextPriceLineThrough(price: 'Rp. 120.000'),
                  TextPriceBold(price: 'Rp. 85.000'),
                  const Spacer(),
                  Container(
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppColors.secondaryColor,
                    ),
                    child: Center(
                      child: Text("+ Keranjang",
                          style: AppTextStyle.mediumWhiteBold),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
