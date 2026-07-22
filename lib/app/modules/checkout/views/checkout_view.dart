import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/routes/app_pages.dart';
import 'package:pos_royal/app/shared/widgets/app_divider.dart';
import 'package:pos_royal/app/shared/widgets/text/text_price_bold.dart';
import 'package:pos_royal/app/shared/widgets/text/text_price_line_through.dart';

import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 2,
        title: const Text(
          'Checkout',
          style: AppTextStyle.xxLargeWhiteBold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            15.verticalSpace,
            RPadding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: InkWell(
                onTap: () => Get.toNamed(Routes.ADDRESS),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_sharp,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
                        5.horizontalSpace,
                        RichText(
                          text: TextSpan(
                            text: 'Dikirim ke ',
                            style: AppTextStyle.mediumGrey,
                            children: [
                              TextSpan(
                                text: 'Jl. Raya Batujajar, Bandung Barat',
                                style: AppTextStyle.mediumBlackBold,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: AppColors.blackSecondary,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
            15.verticalSpace,
            RPadding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Obx(
                () => CheckoutItemCard(
                  qty: controller.selectedQty.value.toString(),
                ),
              ),
            ),
            15.verticalSpace,
            RPadding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: AddMessageWidget(),
            ),
            15.verticalSpace,
            AppDivider(),
            15.verticalSpace,
            RPadding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 18,
                              color: AppColors.primaryColor,
                            ),
                            5.horizontalSpace,
                            Expanded(
                              child: RichText(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text: 'Akan dikirim dari ',
                                  style: AppTextStyle.mediumGrey,
                                  children: [
                                    TextSpan(
                                      text: 'Royal Pusat',
                                      style: AppTextStyle.mediumBlackBold,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: AppColors.blackSecondary,
                        size: 15,
                      )
                    ],
                  ),
                  10.verticalSpace,
                  Text(
                    'Jl.Raya Barat, Cimareme, Kec. Ngamprah, Kabupaten Bandung Barat, Jawa Barat 40552',
                    style: AppTextStyle.mediumBlackSecondary,
                  ),
                  10.verticalSpace,
                  const Divider(color: AppColors.lightGrey, thickness: 1.2),
                  15.verticalSpace,
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          constraints: BoxConstraints.loose(
                            Size(MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height * 0.62),
                          ),
                          isScrollControlled: true,
                          showDragHandle: true,
                          context: context,
                          builder: (_) {
                            return RPadding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 40),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.08),
                                              offset: const Offset(0, -1),
                                              blurRadius: 12,
                                              spreadRadius: 0,
                                            ),
                                          ],
                                          border: Border.all(
                                            color: AppColors.primaryColor,
                                            width: 1.2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              Helper.getSvgPath(
                                                'ic_delivery.svg',
                                              ),
                                            ),
                                            10.horizontalSpace,
                                            Text(
                                              'Di antar',
                                              style: AppTextStyle.mediumBlack
                                                  .copyWith(
                                                color: AppColors.primaryColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 40),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.08),
                                              offset: const Offset(0, -1),
                                              blurRadius: 12,
                                              spreadRadius: 0,
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              Helper.getSvgPath(
                                                'ic_pickup.svg',
                                              ),
                                            ),
                                            10.horizontalSpace,
                                            Text(
                                              'Ambil',
                                              style: AppTextStyle.mediumBlack
                                                  .copyWith(
                                                color: AppColors.primaryColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  10.verticalSpace,
                                  const Divider(
                                    color: AppColors.lightGrey,
                                    thickness: 1.2,
                                  ),
                                  10.verticalSpace,
                                  Text(
                                    'Pilih Pengiriman',
                                    style: AppTextStyle.largeBlack,
                                  ),
                                  5.verticalSpace,
                                  Text(
                                    'Kami berusaha dengan maksimal untuk menyiapkan dan melakukan pengemasan dengan cepat dan tepat, agar produk sampai dilokasi kamu secepatnya.',
                                    style: AppTextStyle.mediumBlack,
                                  ),
                                  10.verticalSpace,
                                  const Divider(
                                      color: AppColors.lightGrey,
                                      thickness: 1.2),
                                  InkWell(
                                    onTap: () {
                                      controller.selectedShippingMethod.value =
                                          'Instant';
                                      showModalBottomSheet(
                                          barrierColor: Colors.transparent,
                                          constraints: BoxConstraints.loose(
                                            Size(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.8),
                                          ),
                                          isScrollControlled: true,
                                          showDragHandle: true,
                                          context: context,
                                          builder: (_) {
                                            return RPadding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      14, 0, 14, 0),
                                              child: SizedBox(
                                                width: Get.width,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Pilih Kurir',
                                                      style: AppTextStyle
                                                          .largeBlackBold,
                                                    ),
                                                    10.verticalSpace,
                                                    const Divider(
                                                        color:
                                                            AppColors.lightGrey,
                                                        thickness: 1.2),
                                                    10.verticalSpace,
                                                    InkWell(
                                                      onTap: () {
                                                        controller
                                                            .selectedShipping
                                                            .value = 'AnterAja';
                                                        controller
                                                                .selectedShippingImg
                                                                .value =
                                                            'img_anteraja.png';
                                                        Get.back();
                                                        Get.back();
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Image.asset(
                                                                    height: 18,
                                                                    width: 18,
                                                                    Helper.getImagePath(
                                                                        'img_anteraja.png'),
                                                                  ),
                                                                  6.horizontalSpace,
                                                                  Text(
                                                                    'AnterAja',
                                                                    style: AppTextStyle
                                                                        .largeBlack,
                                                                  ),
                                                                ],
                                                              ),
                                                              TextPriceLineThrough(
                                                                  price:
                                                                      'Rp. 400.000')
                                                            ],
                                                          ),
                                                          8.verticalSpace,
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Estimasi tiba sebelum jam 12:00 WIB',
                                                                style: AppTextStyle
                                                                    .mediumBlack
                                                                    .copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .grey,
                                                                ),
                                                              ),
                                                              TextPriceBold(
                                                                price:
                                                                    'Rp. 200.000',
                                                                color: AppColors
                                                                    .primaryColor,
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    10.verticalSpace,
                                                    const Divider(
                                                        color:
                                                            AppColors.lightGrey,
                                                        thickness: 1.2),
                                                    10.verticalSpace,
                                                    InkWell(
                                                      onTap: () {
                                                        controller
                                                                .selectedShipping
                                                                .value =
                                                            'Ninja Xpress';
                                                        controller
                                                                .selectedShippingImg
                                                                .value =
                                                            'img_ninjaxpress.png';
                                                        Get.back();
                                                        Get.back();
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Image.asset(
                                                                    height: 18,
                                                                    width: 18,
                                                                    Helper.getImagePath(
                                                                        'img_ninjaxpress.png'),
                                                                  ),
                                                                  6.horizontalSpace,
                                                                  Text(
                                                                    'Ninja Xpress',
                                                                    style: AppTextStyle
                                                                        .largeBlack,
                                                                  ),
                                                                ],
                                                              ),
                                                              TextPriceLineThrough(
                                                                  price:
                                                                      'Rp. 400.000')
                                                            ],
                                                          ),
                                                          8.verticalSpace,
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Estimasi tiba sebelum jam 12:00 WIB',
                                                                style: AppTextStyle
                                                                    .mediumBlack
                                                                    .copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .grey,
                                                                ),
                                                              ),
                                                              TextPriceBold(
                                                                price:
                                                                    'Rp. 200.000',
                                                                color: AppColors
                                                                    .primaryColor,
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    10.verticalSpace,
                                                    const Divider(
                                                        color:
                                                            AppColors.lightGrey,
                                                        thickness: 1.2),
                                                    10.verticalSpace,
                                                    InkWell(
                                                      onTap: () {
                                                        controller
                                                                .selectedShipping
                                                                .value =
                                                            'Lion Parcel';
                                                        controller
                                                                .selectedShippingImg
                                                                .value =
                                                            'img_lion_parcel.png';
                                                        Get.back();
                                                        Get.back();
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Image.asset(
                                                                    height: 18,
                                                                    width: 18,
                                                                    Helper.getImagePath(
                                                                        'img_lion_parcel.png'),
                                                                  ),
                                                                  6.horizontalSpace,
                                                                  Text(
                                                                    'Lion Parcel',
                                                                    style: AppTextStyle
                                                                        .largeBlack,
                                                                  ),
                                                                ],
                                                              ),
                                                              TextPriceLineThrough(
                                                                  price:
                                                                      'Rp. 400.000')
                                                            ],
                                                          ),
                                                          8.verticalSpace,
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Estimasi tiba sebelum jam 12:00 WIB',
                                                                style: AppTextStyle
                                                                    .mediumBlack
                                                                    .copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .grey,
                                                                ),
                                                              ),
                                                              TextPriceBold(
                                                                price:
                                                                    'Rp. 200.000',
                                                                color: AppColors
                                                                    .primaryColor,
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    10.verticalSpace,
                                                    const Divider(
                                                        color:
                                                            AppColors.lightGrey,
                                                        thickness: 1.2),
                                                    10.verticalSpace,
                                                    InkWell(
                                                      onTap: () {
                                                        controller
                                                                .selectedShipping
                                                                .value =
                                                            'JNE Express';
                                                        controller
                                                                .selectedShippingImg
                                                                .value =
                                                            'img_jnt_express.png';
                                                        Get.back();
                                                        Get.back();
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Image.asset(
                                                                    height: 18,
                                                                    width: 18,
                                                                    Helper.getImagePath(
                                                                        'img_jne_express.png'),
                                                                  ),
                                                                  6.horizontalSpace,
                                                                  Text(
                                                                    'JNE Express',
                                                                    style: AppTextStyle
                                                                        .largeBlack,
                                                                  ),
                                                                ],
                                                              ),
                                                              TextPriceLineThrough(
                                                                  price:
                                                                      'Rp. 400.000')
                                                            ],
                                                          ),
                                                          8.verticalSpace,
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Estimasi tiba sebelum jam 12:00 WIB',
                                                                style: AppTextStyle
                                                                    .mediumBlack
                                                                    .copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .grey,
                                                                ),
                                                              ),
                                                              TextPriceBold(
                                                                price:
                                                                    'Rp. 200.000',
                                                                color: AppColors
                                                                    .primaryColor,
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    10.verticalSpace,
                                                    const Divider(
                                                        color:
                                                            AppColors.lightGrey,
                                                        thickness: 1.2),
                                                    10.verticalSpace,
                                                    InkWell(
                                                      onTap: () {
                                                        controller
                                                                .selectedShipping
                                                                .value =
                                                            'JNT Express';
                                                        controller
                                                                .selectedShippingImg
                                                                .value =
                                                            'img_jnt_express.png';
                                                        Get.back();
                                                        Get.back();
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Image.asset(
                                                                    height: 18,
                                                                    width: 18,
                                                                    Helper.getImagePath(
                                                                        'img_jnt_express.png'),
                                                                  ),
                                                                  6.horizontalSpace,
                                                                  Text(
                                                                    'JNT Express',
                                                                    style: AppTextStyle
                                                                        .largeBlack,
                                                                  ),
                                                                ],
                                                              ),
                                                              TextPriceLineThrough(
                                                                  price:
                                                                      'Rp. 400.000')
                                                            ],
                                                          ),
                                                          8.verticalSpace,
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Estimasi tiba sebelum jam 12:00 WIB',
                                                                style: AppTextStyle
                                                                    .mediumBlack
                                                                    .copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .grey,
                                                                ),
                                                              ),
                                                              TextPriceBold(
                                                                price:
                                                                    'Rp. 200.000',
                                                                color: AppColors
                                                                    .primaryColor,
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    10.verticalSpace,
                                                    const Divider(
                                                        color:
                                                            AppColors.lightGrey,
                                                        thickness: 1.2),
                                                    10.verticalSpace,
                                                    InkWell(
                                                      onTap: () {
                                                        controller
                                                            .selectedShipping
                                                            .value = 'SiCepat';
                                                        controller
                                                                .selectedShippingImg
                                                                .value =
                                                            'img_sicepat.png';
                                                        Get.back();
                                                        Get.back();
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Image.asset(
                                                                    height: 18,
                                                                    width: 18,
                                                                    Helper.getImagePath(
                                                                        'img_sicepat.png'),
                                                                  ),
                                                                  6.horizontalSpace,
                                                                  Text(
                                                                    'SiCepat',
                                                                    style: AppTextStyle
                                                                        .largeBlack,
                                                                  ),
                                                                ],
                                                              ),
                                                              TextPriceLineThrough(
                                                                  price:
                                                                      'Rp. 400.000')
                                                            ],
                                                          ),
                                                          8.verticalSpace,
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Estimasi tiba sebelum jam 12:00 WIB',
                                                                style: AppTextStyle
                                                                    .mediumBlack
                                                                    .copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .grey,
                                                                ),
                                                              ),
                                                              TextPriceBold(
                                                                price:
                                                                    'Rp. 200.000',
                                                                color: AppColors
                                                                    .primaryColor,
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Instant',
                                              style: AppTextStyle.largeBlack,
                                            ),
                                            TextPriceLineThrough(
                                                price: 'Rp. 400.000')
                                          ],
                                        ),
                                        8.verticalSpace,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Estimasi tiba sebelum 12.00 WIB',
                                              style: AppTextStyle.mediumBlack
                                                  .copyWith(
                                                color: AppColors.grey,
                                              ),
                                            ),
                                            TextPriceBold(
                                              price: 'Rp. 200.000',
                                              color: AppColors.primaryColor,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  10.verticalSpace,
                                  const Divider(
                                      color: AppColors.lightGrey,
                                      thickness: 1.2),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Same Day',
                                            style: AppTextStyle.largeBlack,
                                          ),
                                          TextPriceLineThrough(
                                              price: 'Rp. 400.000')
                                        ],
                                      ),
                                      8.verticalSpace,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Diterima di hari yang sama',
                                            style: AppTextStyle.mediumBlack
                                                .copyWith(
                                              color: AppColors.grey,
                                            ),
                                          ),
                                          TextPriceBold(
                                            price: 'Rp. 200.000',
                                            color: AppColors.primaryColor,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  10.verticalSpace,
                                  const Divider(
                                      color: AppColors.lightGrey,
                                      thickness: 1.2),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Reguler',
                                            style: AppTextStyle.largeBlack,
                                          ),
                                          TextPriceLineThrough(
                                              price: 'Rp. 400.000')
                                        ],
                                      ),
                                      8.verticalSpace,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Estimasi tiba sebelum tanggal 7-8 Sep',
                                            style: AppTextStyle.mediumBlack
                                                .copyWith(
                                              color: AppColors.grey,
                                            ),
                                          ),
                                          TextPriceBold(
                                            price: 'Rp. 200.000',
                                            color: AppColors.primaryColor,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          color: AppColors.lightGrey,
                        ),
                        borderRadius: controller.selectedShippingMethod.isEmpty
                            ? BorderRadius.all(
                                Radius.circular(8),
                              )
                            : BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                size: 18,
                                color: AppColors.primaryColor,
                              ),
                              10.horizontalSpace,
                              Obx(
                                () => Text(
                                  controller
                                          .selectedShippingMethod.value.isEmpty
                                      ? 'Pilih Metode Pengiriman'
                                      : 'Pengiriman ${controller.selectedShippingMethod.value}',
                                  style: AppTextStyle.mediumBlackBold,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: AppColors.blackSecondary,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: controller.selectedShipping.value.isNotEmpty ||
                              controller.selectedShippingImg.value.isNotEmpty
                          ? true
                          : false,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: AppColors.white12,
                          border: Border(
                            left: BorderSide(
                              color: AppColors.lightGrey,
                            ),
                            bottom: BorderSide(
                              color: AppColors.lightGrey,
                            ),
                            right: BorderSide(
                              color: AppColors.lightGrey,
                            ),
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  height: 18,
                                  width: 18,
                                  Helper.getImagePath(
                                      controller.selectedShippingImg.value),
                                ),
                                6.horizontalSpace,
                                Text(
                                  controller.selectedShipping.value,
                                  style: AppTextStyle.largeBlack,
                                ),
                              ],
                            ),
                            8.verticalSpace,
                            Text(
                              'Estimasi tiba sebelum jam 12:00 WIB',
                              style: AppTextStyle.mediumBlack.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  Text(
                    'Rincian Pembayaran',
                    style: AppTextStyle.mediumBlackBold,
                  ),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Pembelian',
                        style: AppTextStyle.mediumGrey,
                      ),
                      Text(
                        Helper.formatCurrency(controller.selectedPrice.value *
                            controller.selectedQty.value),
                        style: AppTextStyle.mediumBlack,
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ongkos Kirim',
                        style: AppTextStyle.mediumGrey,
                      ),
                      Text(
                        'Rp. 200.000',
                        style: AppTextStyle.mediumBlack,
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Voucher Diskon (%)',
                        style: AppTextStyle.mediumGrey,
                      ),
                      Text(
                        '-Rp. 200.000',
                        style: AppTextStyle.mediumBlack
                            .copyWith(color: AppColors.red),
                      ),
                    ],
                  ),
                  15.verticalSpace,
                  Image.asset(
                    Helper.getImagePath('img_divider.png'),
                  ),
                  15.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Pembayaran',
                        style: AppTextStyle.mediumBlack,
                      ),
                      Text(
                        Helper.formatCurrency(controller.selectedPrice.value *
                            controller.selectedQty.value),
                        style: AppTextStyle.mediumBlackBold,
                      ),
                    ],
                  ),
                  50.verticalSpace,
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, -8),
              blurRadius: 16,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          child: BottomAppBar(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              height: 150,
              child: Column(
                children: [
                  15.verticalSpace,
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    width: Get.width,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightGrey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.discount_outlined,
                              size: 20,
                              color: AppColors.primaryColor,
                            ),
                            15.horizontalSpace,
                            Text(
                              '1 Voucher terpasang',
                              style: AppTextStyle.mediumBlackBold,
                            ),
                          ],
                        ),
                        Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: AppColors.black,
                        ),
                      ],
                    ),
                  ),
                  15.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Pembayaran',
                            style: AppTextStyle.mediumBlack,
                          ),
                          Text(
                            Helper.formatCurrency(
                                controller.selectedPrice.value *
                                    controller.selectedQty.value),
                            style: AppTextStyle.largeBlackBold,
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () =>
                            Get.toNamed(Routes.PAYMENT_METHOD, arguments: [
                          controller.selectedPrice.value,
                          controller.selectedQty.value,
                        ]),
                        child: Container(
                          height: 35.h,
                          width: 148.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.primaryColor),
                            color: AppColors.primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              'Pilih Pembayaran',
                              style: AppTextStyle.largeWhiteBold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class AddMessageWidget extends StatelessWidget {
  const AddMessageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tambahkan Pesan',
          style: AppTextStyle.mediumBlackBold,
        ),
        10.verticalSpace,
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.lightGrey,
              ),
              borderRadius: BorderRadius.circular(8)),
          child: TextField(
            decoration: InputDecoration.collapsed(
              hintText: '(Optional) Tinggalkan pesan untuk penjual',
              hintStyle: AppTextStyle.mediumGrey,
            ),
            cursorColor: AppColors.primaryColor,
            style: AppTextStyle.mediumBlack,
          ),
        ),
      ],
    );
  }
}

class CheckoutItemCard extends StatelessWidget {
  const CheckoutItemCard({
    super.key,
    required this.qty,
  });

  final String qty;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.lightGrey,
              ),
              bottom: BorderSide(
                color: AppColors.lightGrey,
              ),
            ),
          ),
          width: Get.width,
          child: Row(
            children: [
              Image.asset(
                height: 80,
                width: 80,
                Helper.getImagePath(
                  'img_product1.jpg',
                ),
              ),
              15.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Elite Springbed Kasur Pocket Emporium New Edition",
                      style: AppTextStyle.mediumBlackBold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Promo kemerdekaan + Gratis Ongkir',
                      style: AppTextStyle.mediumGrey,
                    ),
                    10.verticalSpace,
                    Text(
                      'Rp 1.087.210',
                      style: AppTextStyle.mediumBlackBold,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          right: 12,
          child: Row(
            children: [
              Icon(Icons.close, size: 15, color: AppColors.black),
              5.horizontalSpace,
              Text(qty, style: AppTextStyle.mediumBlackBold)
            ],
          ),
        ),
      ],
    );
  }
}
