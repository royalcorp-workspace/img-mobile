import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/shared/widgets/text/text_price_line_through.dart';

import '../controllers/payment_method_controller.dart';

class PaymentMethodView extends GetView<PaymentMethodController> {
  const PaymentMethodView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 2,
        title: const Text(
          'Payment Method',
          style: AppTextStyle.xxLargeWhiteBold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: RPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              15.verticalSpace,
              Text(
                'Metode Pembayaran',
                style: AppTextStyle.largeBlackBold,
              ),

              // 15.verticalSpace,
              // AppExpansionTileCard(
              //   title: 'Transfer Bank (Virtual Account)',
              //   imgPath: 'img_va.png',
              //   children: <Widget>[
              //     RPadding(
              //       padding: const EdgeInsets.symmetric(horizontal: 14),
              //       child: const Divider(
              //           color: AppColors.lightGrey, thickness: 1.2),
              //     ),
              //     VirtualAccountListTile(
              //       imgPath: 'img_bca.png',
              //       title: 'Bank BCA',
              //       index: 0,
              //     ),
              //     VirtualAccountListTile(
              //       imgPath: 'img_mandiri.png',
              //       title: 'Bank Mandiri',
              //       index: 1,
              //     ),
              //     VirtualAccountListTile(
              //       imgPath: 'img_bsi.png',
              //       title: 'Bank BSI',
              //       index: 2,
              //     ),
              //     VirtualAccountListTile(
              //       imgPath: 'img_bni.png',
              //       title: 'Bank BNI',
              //       index: 3,
              //     ),
              //     VirtualAccountListTile(
              //       imgPath: 'img_bri.png',
              //       title: 'Bank BRI',
              //       index: 4,
              //     ),
              //     VirtualAccountListTile(
              //       imgPath: 'img_other_bank.png',
              //       title: 'Bank Lainnya',
              //       index: 5,
              //     ),
              //   ],
              // ),
              // 15.verticalSpace,
              // AppExpansionTileCard(
              //   title: 'Gerai/Agen',
              //   imgPath: 'img_market.png',
              //   children: <Widget>[
              //     RPadding(
              //       padding: const EdgeInsets.symmetric(horizontal: 14),
              //       child: const Divider(
              //           color: AppColors.lightGrey, thickness: 1.2),
              //     ),
              //     VirtualAccountListTile(
              //       imgPath: 'img_alfamart.png',
              //       title: 'Alfamart/Alfamidi/Lawson',
              //       index: 6,
              //     ),
              //     VirtualAccountListTile(
              //       imgPath: 'img_indomaret.png',
              //       title: 'Indomaret',
              //       index: 7,
              //     ),
              //   ],
              // ),
              // 15.verticalSpace,
              // AppExpansionTileCard(
              //   title: 'E-Wallet',
              //   imgPath: 'img_ewallet.png',
              //   children: <Widget>[
              //     RPadding(
              //       padding: const EdgeInsets.symmetric(horizontal: 14),
              //       child: const Divider(
              //           color: AppColors.lightGrey, thickness: 1.2),
              //     ),
              //     VirtualAccountListTile(
              //       imgPath: 'img_roku.png',
              //       title: 'Doku Pay',
              //       index: 8,
              //     ),
              //     VirtualAccountListTile(
              //       imgPath: 'img_gopay.png',
              //       title: 'GoPay',
              //       index: 9,
              //     ),
              //     VirtualAccountListTile(
              //       imgPath: 'img_dana.png',
              //       title: 'Dana',
              //       index: 10,
              //     ),
              //     VirtualAccountListTile(
              //       imgPath: 'img_linkaja.png',
              //       title: 'Link Aja',
              //       index: 11,
              //     ),
              //     VirtualAccountListTile(
              //       imgPath: 'img_ovo.png',
              //       title: 'OVO',
              //       index: 12,
              //     ),
              //     VirtualAccountListTile(
              //       imgPath: 'img_shopepay.png',
              //       title: 'Shopee Pay',
              //       index: 13,
              //     ),
              //   ],
              // ),

              15.verticalSpace,
              AppExpansionTileCard(
                title: 'Others',
                imgPath: 'img_ewallet.png',
                children: <Widget>[
                  RPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: const Divider(
                        color: AppColors.lightGrey, thickness: 1.2),
                  ),
                  Obx(
                    () => ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.paymentMethod.length,
                        itemBuilder: (contex, index) {
                          final data = controller.paymentMethod[index];
                          return VirtualAccountListTile(
                            imgPath: 'img_dana.png',
                            title: data.name,
                            index: index,
                          );
                        }),
                  ),
                ],
              ),
              15.verticalSpace,
              Text(
                'Ringkasan Pembayaran',
                style: AppTextStyle.mediumBlackBold,
              ),
              10.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Pembelian',
                    style: AppTextStyle.mediumBlack
                        .copyWith(color: AppColors.blackSecondary),
                  ),
                  Row(
                    children: [
                      TextPriceLineThrough(
                        price: Helper.formatCurrency(
                            (controller.selectedPrice.value *
                                    controller.selectedQty.value) +
                                200000),
                      ),
                      10.horizontalSpace,
                      Text(
                        Helper.formatCurrency(controller.selectedPrice.value *
                            controller.selectedQty.value),
                        style: AppTextStyle.mediumBlack,
                      )
                    ],
                  )
                ],
              ),
              10.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Biaya Admin',
                    style: AppTextStyle.mediumBlack
                        .copyWith(color: AppColors.blackSecondary),
                  ),
                  Text('Rp. 2.500', style: AppTextStyle.mediumBlack),
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
                    Helper.formatCurrency((controller.selectedPrice.value *
                            controller.selectedQty.value) +
                        2500),
                    style: AppTextStyle.largeBlackBold
                        .copyWith(color: AppColors.primaryColor),
                  ),
                ],
              ),
              20.verticalSpace,
            ],
          ),
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
              height: 95,
              child: Column(
                children: [
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
                                (controller.selectedPrice.value *
                                        controller.selectedQty.value) +
                                    2500),
                            style: AppTextStyle.largeBlackBold,
                          ),
                        ],
                      ),
                      Obx(
                        () => InkWell(
                          onTap: controller.isCreatingOrder.value
                              ? null
                              : () => controller.createOrder(),
                          child: Container(
                            height: 35.h,
                            width: 148.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primaryColor),
                              color: AppColors.primaryColor,
                            ),
                            child: Center(
                              child: controller.isCreatingOrder.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Bayar',
                                      style: AppTextStyle.largeWhiteBold,
                                    ),
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

class AppExpansionTileCard extends StatelessWidget {
  const AppExpansionTileCard({
    super.key,
    required this.title,
    required this.imgPath,
    required this.children,
  });

  final String title, imgPath;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        collapsedIconColor: AppColors.primaryColor,
        iconColor: AppColors.primaryColor,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightGrey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                width: 25,
                height: 25,
                Helper.getImagePath(imgPath),
              ),
            ),
            8.horizontalSpace,
            Text(
              title,
              style: AppTextStyle.mediumBlackBold,
            ),
          ],
        ),
        children: children,
      ),
    );
  }
}

class VirtualAccountListTile extends GetView<PaymentMethodController> {
  const VirtualAccountListTile({
    super.key,
    required this.title,
    required this.imgPath,
    required this.index,
  });

  final String title, imgPath;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightGrey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(
            width: 25,
            height: 25,
            Helper.getImagePath(imgPath),
          ),
        ),
        title: Text(
          title,
          style: AppTextStyle.mediumBlackBold,
        ),
        trailing: Obx(
          () => Radio(
            fillColor: WidgetStatePropertyAll(
              controller.selectedOption.value == controller.options[index]
                  ? AppColors.primaryColor
                  : AppColors.grey,
            ),
            value: controller.options[index],
            groupValue: controller.selectedOption.value,
            onChanged: (e) {
              controller.selectedOption.value = e!;
            },
          ),
        ));
  }
}
