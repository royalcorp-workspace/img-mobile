import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';

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
    this.width,
    this.height,
    this.brand,
    this.discountPercentage,
    this.onAddToCart,
  });

  final GlobalKey widgetKey = GlobalKey();
  final void Function(GlobalKey) onTap;
  final void Function(GlobalKey)? onAddToCart;
  final String title;
  final String formattedPrice;
  final String formattedOriginalPrice;
  final String rating;
  final String review;
  final ImageProvider<Object> imageProvider;
  final double? width;
  final double? height;
  final String? brand;
  final String? discountPercentage;

  @override
  Widget build(BuildContext context) {
    // Calculate approximate discount percentage if not provided directly
    String? calculatedDiscount = discountPercentage;
    if ((calculatedDiscount == null || calculatedDiscount.isEmpty) &&
        formattedOriginalPrice.isNotEmpty &&
        formattedPrice.isNotEmpty) {
      try {
        final origStr =
            formattedOriginalPrice.replaceAll(RegExp(r'[^0-9]'), '');
        final currStr = formattedPrice.replaceAll(RegExp(r'[^0-9]'), '');
        final double orig = double.tryParse(origStr) ?? 0;
        final double curr = double.tryParse(currStr) ?? 0;
        if (orig > curr && orig > 0) {
          final disc = (((orig - curr) / orig) * 100).round();
          if (disc > 0) {
            calculatedDiscount = '-$disc%';
          }
        }
      } catch (_) {}
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: widgetKey,
        borderRadius: BorderRadius.circular(16.r),
        onTap: () => onTap(widgetKey),
        child: Container(
          width: width ?? 160.w,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.lightGrey.withOpacity(0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final hasBoundedHeight = constraints.hasBoundedHeight;

              Widget infoContent = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.mediumBlack600.copyWith(
                      fontSize: 10.sp,
                      height: 1.25,
                    ),
                  ),
                  6.verticalSpace,
                  // Price Section
                  Text(
                    formattedPrice,
                    style: AppTextStyle.mediumBlackBold.copyWith(
                      fontSize: 10.5.sp,
                      color: const Color(0xFFD32F2F),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (formattedOriginalPrice.isNotEmpty) ...[
                    2.verticalSpace,
                    Text(
                      formattedOriginalPrice,
                      style: AppTextStyle.smallGrey.copyWith(
                        fontSize: 10.sp,
                        decoration: TextDecoration.lineThrough,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ],
              );

              Widget ratingRow = Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: AppColors.yellow,
                          size: 14.sp,
                        ),
                        2.horizontalSpace,
                        Text(
                          rating,
                          style: AppTextStyle.smallBlackBold.copyWith(
                            fontSize: 10.5.sp,
                          ),
                        ),
                        2.horizontalSpace,
                        Flexible(
                          child: Text(
                            review,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.xSmallGrey.copyWith(
                              fontSize: 10.5.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              Widget productInfoSection;
              if (hasBoundedHeight) {
                productInfoSection = Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        infoContent,
                        ratingRow,
                      ],
                    ),
                  ),
                );
              } else {
                productInfoSection = Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      infoContent,
                      10.verticalSpace,
                      ratingRow,
                    ],
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:
                    hasBoundedHeight ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  // Image Container with Badge
                  Stack(
                    children: [
                      Container(
                        height: 120.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.greyWhite,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.r),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.r),
                          ),
                          child: Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              Helper.getImagePath('img_product1.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      // Discount Badge
                      if (calculatedDiscount != null &&
                          calculatedDiscount.isNotEmpty)
                        Positioned(
                          top: 8.h,
                          left: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 7.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE53935),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              calculatedDiscount,
                              style: AppTextStyle.xSmallWhiteBold.copyWith(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Product Info Section
                  productInfoSection,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  ProductCard({
    super.key,
    required this.onTap,
  });

  final GlobalKey widgetKey = GlobalKey();
  final void Function(GlobalKey) onTap;

  @override
  Widget build(BuildContext context) {
    return ProductsCard(
      onTap: onTap,
      title: "Elite Springbed Kasur Pocket Emporium New Edition",
      formattedPrice: "Rp 1.087.210",
      formattedOriginalPrice: "Rp 3.749.000",
      rating: "4.2",
      review: "(128)",
      brand: "Elite",
      discountPercentage: "-71%",
      imageProvider: AssetImage(
        Helper.getImagePath('img_product1.jpg'),
      ),
    );
  }
}

class ProductCardShimmer extends StatefulWidget {
  const ProductCardShimmer({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<ProductCardShimmer> createState() => _ProductCardShimmerState();
}

class _ProductCardShimmerState extends State<ProductCardShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = (_controller.value * 2) - 1;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment(offset - 1, 0),
            end: Alignment(offset + 1, 0),
            colors: const [
              Color(0xFFE8E8E8),
              Color(0xFFF7F7F7),
              Color(0xFFE8E8E8),
            ],
          ).createShader(bounds),
          child: child,
        );
      },
      child: Container(
        width: widget.width ?? 160.w,
        height: widget.height,
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final hasBoundedHeight = constraints.hasBoundedHeight;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize:
                  hasBoundedHeight ? MainAxisSize.max : MainAxisSize.min,
              children: [
                Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                10.verticalSpace,
                Container(
                  width: 60.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                6.verticalSpace,
                Container(
                  width: double.infinity,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                4.verticalSpace,
                FractionallySizedBox(
                  widthFactor: .7,
                  child: Container(
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                if (hasBoundedHeight) const Spacer() else 12.verticalSpace,
                Container(
                  width: 90.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            );
          },
        ),
      ),
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: tagColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(12.r),
        ),
      ),
      child: Text(
        '-$discountPercentage%',
        style: AppTextStyle.xSmallWhiteBold.copyWith(fontSize: 10.sp),
      ),
    );
  }
}
