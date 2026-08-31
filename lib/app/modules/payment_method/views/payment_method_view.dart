import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';

import '../controllers/payment_method_controller.dart';

class PaymentMethodView extends GetView<PaymentMethodController> {
  const PaymentMethodView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final selectedCode = controller.selectedOption.value;
        final selectedEntity = controller.paymentMethod.firstWhereOrNull(
          (e) => e.code == selectedCode,
        );
        Get.back(result: selectedEntity ?? selectedCode);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 2,
          title: const Text(
            'Metode Pembayaran',
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
                // Text(
                //   'Metode Pembayaran',
                //   style: AppTextStyle.largeBlackBold,
                // ),

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

                // 15.verticalSpace,
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
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          itemCount: controller.paymentMethod.length,
                          itemBuilder: (contex, index) {
                            final data = controller.paymentMethod[index];
                            final itemCode = data.code ?? '';
                            return VirtualAccountListTile(
                              imgPath: 'img_dana.png',
                              title: data.name ?? '',
                              index: index,
                              code: itemCode,
                              onChanged: (val) {
                                if (val != null) {
                                  controller.selectedOption.value = val;
                                  Get.back(result: data);
                                }
                              },
                              onTap: () {
                                controller.selectedOption.value = itemCode;
                                Get.back(result: data);
                              },
                            );
                          }),
                    ),
                  ],
                ),

                20.verticalSpace,
              ],
            ),
          ),
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
        initiallyExpanded: true,
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
    this.code,
    this.isSelected,
    this.onChanged,
    this.onTap,
  });

  final String title, imgPath;
  final int index;
  final String? code;
  final bool? isSelected;
  final ValueChanged<String?>? onChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final String itemCode = code ??
        ((index >= 0 && index < controller.paymentMethod.length)
            ? (controller.paymentMethod[index].code ?? '')
            : '');

    final bool activeSelected = isSelected ??
        (controller.selectedOption.value == itemCode && itemCode.isNotEmpty);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Image.asset(
        width: 25,
        height: 25,
        Helper.getImagePath(imgPath),
      ),
      title: Text(
        title,
        style: AppTextStyle.mediumBlackBold,
      ),
      trailing: Radio<String>(
        fillColor: WidgetStatePropertyAll(
          activeSelected ? AppColors.primaryColor : AppColors.grey,
        ),
        value: itemCode,
        groupValue: activeSelected ? itemCode : '',
        onChanged: (e) {
          if (onChanged != null) {
            onChanged!(e);
          } else if (e != null) {
            controller.selectedOption.value = e;
          }
        },
      ),
    );
  }
}
