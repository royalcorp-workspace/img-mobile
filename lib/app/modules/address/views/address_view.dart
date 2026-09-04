import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/data/models/address_model.dart';
import 'package:img/app/routes/app_pages.dart';

import '../controllers/address_controller.dart';

class AddressView extends GetView<AddressController> {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 2,
        title: const Text(
          'Daftar Alamat',
          style: AppTextStyle.xxLargeWhiteBold,
        ),
        centerTitle: true,
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }

          return SingleChildScrollView(
            child: RPadding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.verticalSpace,
                  Text(
                    'Alamat Pengiriman',
                    style: AppTextStyle.largeBlackBold,
                  ),
                  15.verticalSpace,
                  if (controller.addresses.isEmpty) ...[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          'Belum ada alamat pengiriman.',
                          style: AppTextStyle.mediumBlackSecondary,
                        ),
                      ),
                    ),
                  ] else ...[
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.addresses.length,
                      separatorBuilder: (context, index) => 15.verticalSpace,
                      itemBuilder: (context, index) {
                        final AddressModel item = controller.addresses[index];
                        final String itemKey =
                            item.id ?? item.address ?? index.toString();
                        final bool isSelected =
                            controller.selectedOption.value == itemKey ||
                                (controller.selectedOption.value.isEmpty &&
                                    item.isPrimary == true);

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.white12
                                : AppColors.white,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.lightGrey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                horizontalTitleGap: 0,
                                title: Text(
                                  item.label ?? '',
                                  style: AppTextStyle.mediumBlackBold,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    5.verticalSpace,
                                    Text(
                                      item.recipientName ?? '',
                                      style: AppTextStyle.mediumBlackBold,
                                    ),
                                    if (item.phone != null &&
                                        item.phone!.isNotEmpty) ...[
                                      5.verticalSpace,
                                      Text(item.phone!),
                                    ],
                                    10.verticalSpace,
                                    Text(
                                      '${item.address}, ${item.subDistrictId}, ${item.cityId}, ${item.postalCode}',
                                      style: AppTextStyle.mediumBlackSecondary,
                                    ),
                                    if (item.isPrimary == true) ...[
                                      10.verticalSpace,
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.shadeRed,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'Alamat Utama',
                                          style:
                                              AppTextStyle.mediumBlack.copyWith(
                                            color: AppColors.redContrast,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                isThreeLine: true,
                                leading: Radio<String>(
                                  fillColor: WidgetStatePropertyAll(
                                    isSelected
                                        ? AppColors.primaryColor
                                        : AppColors.grey,
                                  ),
                                  value: itemKey,
                                  groupValue: controller.selectedOption.value,
                                  onChanged: (value) {
                                    if (value != null) {
                                      controller.selectedOption.value = value;
                                      controller.selectedAddressId.value =
                                          item.id ?? '';
                                    }
                                    controller.setPrimaryAddress(
                                        controller.selectedAddressId.value);
                                  },
                                ),
                                // trailing: const RPadding(
                                //   padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                //   child: Icon(
                                //     Icons.edit,
                                //     color: Colors.grey,
                                //   ),
                                // ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                  5.verticalSpace,
                  GestureDetector(
                    onTap: () async {
                      final result = await Get.toNamed(Routes.DETAIL_ADDRESS);
                      if (result == true) {
                        await controller.fetchCustomerAddresses();
                        controller.syncPrimarySelection(controller.addresses);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add,
                          color: AppColors.primaryColor,
                        ),
                        5.horizontalSpace,
                        Text(
                          'Tambahkan Alamat Baru',
                          style: AppTextStyle.largeBlackBold.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  40.verticalSpace,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
