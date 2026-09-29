import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';

class ShowModalShippingCategory extends StatelessWidget {
  const ShowModalShippingCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 40),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                offset: const Offset(0, -1),
                                blurRadius: 12,
                                spreadRadius: 0,
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 1.2,
                            ),
                            borderRadius: BorderRadius.circular(12),
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
                                style: AppTextStyle.mediumBlack.copyWith(
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
                                color: Colors.black.withOpacity(0.08),
                                offset: const Offset(0, -1),
                                blurRadius: 12,
                                spreadRadius: 0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12),
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
                                style: AppTextStyle.mediumBlack.copyWith(
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
                    // InkWell(
                    //   onTap: () {
                    //     controller.selectedShippingMethod.value = 'Instant';
                    //     showModalBottomSheet(
                    //         barrierColor: Colors.transparent,
                    //         constraints: BoxConstraints.loose(
                    //           Size(MediaQuery.of(context).size.width,
                    //               MediaQuery.of(context).size.height * 0.8),
                    //         ),
                    //         isScrollControlled: true,
                    //         showDragHandle: true,
                    //         context: context,
                    //         builder: (_) {
                    //           return RPadding(
                    //             padding:
                    //                 const EdgeInsets.fromLTRB(14, 0, 14, 0),
                    //             child: SizedBox(
                    //               width: Get.width,
                    //               child: Column(
                    //                 children: [
                    //                   Text(
                    //                     'Pilih Kurir',
                    //                     style: AppTextStyle.largeBlackBold,
                    //                   ),
                    //                   10.verticalSpace,
                    //                   const Divider(
                    //                       color: AppColors.lightGrey,
                    //                       thickness: 1.2),
                    //                   10.verticalSpace,
                    //                   SizedBox(
                    //                     height: 100.h,
                    //                     child: ListView.separated(
                    //                         itemCount: controller
                    //                             .shippingAddresses.length,
                    //                         separatorBuilder: (_, __) =>
                    //                             const Divider(
                    //                                 color: AppColors.lightGrey,
                    //                                 thickness: 1.2),
                    //                         itemBuilder: (context, index) {
                    //                           final data = controller
                    //                               .shippingAddresses[index];

                    //                           return InkWell(
                    //                             onTap: () {
                    //                               controller.selectedShipping
                    //                                       .value =
                    //                                   data.courier.name;
                    //                               controller.selectedShippingImg
                    //                                       .value =
                    //                                   'img_jne_express.png';
                    //                               controller
                    //                                       .selectedShippingPrice
                    //                                       .value =
                    //                                   data.price.toInt();
                    //                               Get.back();
                    //                               Get.back();
                    //                             },
                    //                             child: Column(
                    //                               children: [
                    //                                 Row(
                    //                                   mainAxisAlignment:
                    //                                       MainAxisAlignment
                    //                                           .spaceBetween,
                    //                                   children: [
                    //                                     Row(
                    //                                       children: [
                    //                                         Image.asset(
                    //                                           height: 18,
                    //                                           width: 18,
                    //                                           Helper.getImagePath(
                    //                                               'img_jne_express.png'),
                    //                                         ),
                    //                                         6.horizontalSpace,
                    //                                         Text(
                    //                                           data.courier.name,
                    //                                           style: AppTextStyle
                    //                                               .largeBlack,
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                     TextPriceLineThrough(
                    //                                         price:
                    //                                             'Rp. 400.000')
                    //                                   ],
                    //                                 ),
                    //                                 8.verticalSpace,
                    //                                 Row(
                    //                                   mainAxisAlignment:
                    //                                       MainAxisAlignment
                    //                                           .spaceBetween,
                    //                                   children: [
                    //                                     Text(
                    //                                       'Estimasi tiba sebelum jam 12:00 WIB',
                    //                                       style: AppTextStyle
                    //                                           .mediumBlack
                    //                                           .copyWith(
                    //                                         color:
                    //                                             AppColors.grey,
                    //                                       ),
                    //                                     ),
                    //                                     TextPriceBold(
                    //                                       price: Helper
                    //                                           .formatCurrency(
                    //                                               data.price
                    //                                                   .toInt()),
                    //                                       color: AppColors
                    //                                           .primaryColor,
                    //                                     )
                    //                                   ],
                    //                                 )
                    //                               ],
                    //                             ),
                    //                           );
                    //                         }),
                    //                   ),
                    //                   10.verticalSpace,
                    //                 ],
                    //               ),
                    //             ),
                    //           );
                    //         });
                    //   },
                    //   child: Column(
                    //     children: [
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(
                    //             'Instant',
                    //             style: AppTextStyle.largeBlack,
                    //           ),
                    //           TextPriceLineThrough(price: 'Rp. 400.000')
                    //         ],
                    //       ),
                    //       8.verticalSpace,
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(
                    //             'Estimasi tiba sebelum 12.00 WIB',
                    //             style: AppTextStyle.mediumBlack.copyWith(
                    //               color: AppColors.grey,
                    //             ),
                    //           ),
                    //           TextPriceBold(
                    //             price: 'Rp. 200.000',
                    //             color: AppColors.primaryColor,
                    //           )
                    //         ],
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // 10.verticalSpace,
                    // const Divider(color: AppColors.lightGrey, thickness: 1.2),
                    // Column(
                    //   children: [
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //           'Same Day',
                    //           style: AppTextStyle.largeBlack,
                    //         ),
                    //         TextPriceLineThrough(price: 'Rp. 400.000')
                    //       ],
                    //     ),
                    //     8.verticalSpace,
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //           'Diterima di hari yang sama',
                    //           style: AppTextStyle.mediumBlack.copyWith(
                    //             color: AppColors.grey,
                    //           ),
                    //         ),
                    //         TextPriceBold(
                    //           price: 'Rp. 200.000',
                    //           color: AppColors.primaryColor,
                    //         )
                    //       ],
                    //     )
                    //   ],
                    // ),
                    // 10.verticalSpace,
                    // const Divider(color: AppColors.lightGrey, thickness: 1.2),
                    // Column(
                    //   children: [
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //           'Reguler',
                    //           style: AppTextStyle.largeBlack,
                    //         ),
                    //         TextPriceLineThrough(price: 'Rp. 400.000')
                    //       ],
                    //     ),
                    //     8.verticalSpace,
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //           'Estimasi tiba sebelum tanggal 7-8 Sep',
                    //           style: AppTextStyle.mediumBlack.copyWith(
                    //             color: AppColors.grey,
                    //           ),
                    //         ),
                    //         TextPriceBold(
                    //           price: 'Rp. 200.000',
                    //           color: AppColors.primaryColor,
                    //         )
                    //       ],
                    //     )
                    //   ],
                    // ),
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
          // borderRadius: controller.selectedShippingMethod.isEmpty
          //     ? BorderRadius.all(
          //         Radius.circular(8),
          //       )
          //     : BorderRadius.only(
          //         topLeft: Radius.circular(8),
          //         topRight: Radius.circular(8),
          //       ),
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
                // Obx(
                //   () => Text(
                //     controller.selectedShippingMethod.value.isEmpty
                //         ? 'Pilih Metode Pengiriman'
                //         : 'Pengiriman ${controller.selectedShippingMethod.value}',
                //     style: AppTextStyle.mediumBlackBold,
                //   ),
                // ),
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
    );
  }
}
