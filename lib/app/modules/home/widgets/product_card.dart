import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/shared/widgets/text/text_price_bold.dart';
import 'package:pos_royal/app/shared/widgets/text/text_price_line_through.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    super.key,
    required this.onTap,
  });

  final GlobalKey widgetKey = GlobalKey();
  final void Function(GlobalKey) onTap;

  @override
  Widget build(BuildContext context) {
    Container mandatoryContainer = Container(
      key: widgetKey,
      width: 150.w,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGrey.withOpacity(0.3),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 125.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      Helper.getImagePath(
                        'img_product1.jpg',
                      ),
                    ),
                  ),
                ),
              ),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Elite Springbed Kasur Pocket Emporium New Edition",
                      style: AppTextStyle.largeBlackBold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    15.verticalSpace,
                    TextPriceBold(price: 'Rp 1.087.210'),
                    5.verticalSpace,
                    TextPriceLineThrough(price: 'Rp 3.749.000'),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 22,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              width: 48.w,
              height: 20.h,
              decoration: const BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    color: AppColors.white,
                    size: 15,
                  ),
                  2.horizontalSpace,
                  Text(
                    '4.2',
                    style: AppTextStyle.mediumWhite500,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: const DiscountTag(
              discountPercentage: '20',
              label: 'Off',
            ),

            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 5),
            //   width: 48,
            //   height: 20,
            //   decoration: const BoxDecoration(
            //     color: AppColors.redContrast,
            //   ),
            //   child: Center(
            //     child: Text(
            //       '-71%',
            //       style: AppTextStyle.mediumWhite500,
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => onTap(widgetKey),
      child: mandatoryContainer,
    );
  }
}

class ProductsCard extends StatelessWidget {
  ProductsCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.formattedPrice,
    required this.formattedOriginalPrice,
    required this.rating,
    required this.review,
    required this.imageProvider,
  });

  final GlobalKey widgetKey = GlobalKey();
  final void Function(GlobalKey) onTap;
  final String title, formattedPrice, formattedOriginalPrice, rating, review;
  final ImageProvider<Object> imageProvider;

  @override
  Widget build(BuildContext context) {
    Container mandatoryContainer = Container(
      key: widgetKey,
      width: 150.w,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGrey.withOpacity(0.3),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 80.h,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: imageProvider,
                onError: (exception, stackTrace) {},
              ),
            ),
          ),
          10.verticalSpace,
          RPadding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.largeBlackBold,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                15.verticalSpace,
                TextPriceBold(price: formattedPrice),
                5.verticalSpace,
                Visibility(
                    visible: formattedOriginalPrice.isNotEmpty,
                    child: TextPriceLineThrough(price: formattedOriginalPrice)),
              ],
            ),
          ),
          8.verticalSpace,
          RPadding(
            padding: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: AppColors.yellow,
                  size: 15,
                ),
                2.horizontalSpace,
                Text(
                  rating,
                  style: AppTextStyle.mediumBlackBold.copyWith(
                    color: AppColors.yellow,
                  ),
                ),
                4.horizontalSpace,
                Text(
                  review,
                  style: AppTextStyle.smallGrey,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => onTap(widgetKey),
      child: mandatoryContainer,
    );
  }
}

class DiscountTag extends StatelessWidget {
  final String discountPercentage;
  final String label;
  final Color tagColor;
  final double width;
  final double height;
  final double fontSizePercentage;
  final double fontSizeLabel;

  const DiscountTag({
    super.key,
    required this.discountPercentage,
    required this.label,
    this.tagColor = AppColors.red,
    this.width = 35.0,
    this.height = 45.0,
    this.fontSizePercentage = 12.0,
    this.fontSizeLabel = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: _DiscountTagPainter(tagColor),
            size: Size(width, height),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$discountPercentage%', style: AppTextStyle.smallWhiteBold),
              Text(label, style: AppTextStyle.xSmallWhite),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiscountTagPainter extends CustomPainter {
  final Color tagColor;

  _DiscountTagPainter(this.tagColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = tagColor
      ..style = PaintingStyle.fill;

    final path = Path();

    // Define the rounded rectangle part
    // Top-left corner
    // path.moveTo(0, size.height * 0.1);
    // path.arcToPoint(
    //   const Offset(10, 0), // Adjust for desired top-left radius
    //   radius: const Radius.circular(10),
    //   clockwise: false,
    // );

    // Top-right corner
    path.lineTo(size.width, 0);
    // path.arcToPoint(
    //   Offset(
    //       size.width, size.height * 0.1), // Adjust for desired top-right radius
    //   radius: const Radius.circular(10),
    //   clockwise: false,
    // );

    // Right side
    path.lineTo(size.width, size.height * 0.82);

    // Bottom point of the tag
    path.lineTo(size.width / 2, size.height);

    // Left side
    path.lineTo(0, size.height * 0.82);

    // Close the path
    path.close();

    // Apply a subtle blur/shadow effect to the tag itself
    canvas.drawPath(
      path,
      Paint()
        ..color = tagColor.withOpacity(0.8)
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as _DiscountTagPainter).tagColor != tagColor;
  }
}
