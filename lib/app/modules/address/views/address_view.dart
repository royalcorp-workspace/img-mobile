import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';

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
          'Tambah Alamat',
          style: AppTextStyle.xxLargeWhiteBold,
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => RPadding(
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
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    color:
                        controller.selectedOption.value == controller.options[0]
                            ? AppColors.white12
                            : AppColors.white,
                    border: Border.all(
                        color: controller.selectedOption.value ==
                                controller.options[0]
                            ? AppColors.primaryColor
                            : AppColors.lightGrey,
                        width: 2),
                    borderRadius: BorderRadius.circular(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      minVerticalPadding: 0,
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 0,
                      title: Text('Alghany Kennedy Adam'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          5.verticalSpace,
                          Text('(+62) 81255550324'),
                          10.verticalSpace,
                          Text(
                            'Jl. H. R. Rasuna Said No.Kav. 19A, RT.8/RW.4, Kuningan Tim., Kecamatan Setiabudi, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12950',
                            style: AppTextStyle.mediumBlackSecondary,
                          ),
                          Visibility(
                            visible: controller.selectedOption.value ==
                                controller.options[0],
                            child: 10.verticalSpace,
                          ),
                          Visibility(
                            visible: controller.selectedOption.value ==
                                controller.options[0],
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: AppColors.shadeRed,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Alamat Utama',
                                style: AppTextStyle.mediumBlack
                                    .copyWith(color: AppColors.redContrast),
                              ),
                            ),
                          )
                        ],
                      ),
                      isThreeLine: true,
                      leading: Radio(
                        fillColor: WidgetStatePropertyAll(
                          controller.selectedOption.value ==
                                  controller.options[0]
                              ? AppColors.primaryColor
                              : AppColors.grey,
                        ),
                        value: controller.options[0],
                        groupValue: controller.selectedOption.value,
                        onChanged: (e) {
                          controller.selectedOption.value = e!;
                        },
                      ),
                      trailing: RPadding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                        child: Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              15.verticalSpace,
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    color:
                        controller.selectedOption.value == controller.options[1]
                            ? AppColors.white12
                            : AppColors.white,
                    border: Border.all(
                        color: controller.selectedOption.value ==
                                controller.options[1]
                            ? AppColors.primaryColor
                            : AppColors.lightGrey,
                        width: 2),
                    borderRadius: BorderRadius.circular(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      minVerticalPadding: 0,
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 0,
                      title: Text('Alghany Kennedy Adam'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          5.verticalSpace,
                          Text('(+62) 81255550324'),
                          10.verticalSpace,
                          Text(
                            'Jl. Sungai bambu 2B RT.007/008, kel. Sungai bambu , kec. Tanjung Priok, Jakarta Utara, DKI Jakarta, 14330',
                            style: AppTextStyle.mediumBlackSecondary,
                          ),
                          Visibility(
                            visible: controller.selectedOption.value ==
                                controller.options[1],
                            child: 10.verticalSpace,
                          ),
                          Visibility(
                            visible: controller.selectedOption.value ==
                                controller.options[1],
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: AppColors.shadeRed,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Alamat Utama',
                                style: AppTextStyle.mediumBlack
                                    .copyWith(color: AppColors.redContrast),
                              ),
                            ),
                          )
                        ],
                      ),
                      isThreeLine: true,
                      leading: Radio(
                        fillColor: WidgetStatePropertyAll(
                          controller.selectedOption.value ==
                                  controller.options[1]
                              ? AppColors.primaryColor
                              : AppColors.grey,
                        ),
                        value: controller.options[1],
                        groupValue: controller.selectedOption.value,
                        onChanged: (value) {
                          controller.selectedOption.value = value!;
                        },
                      ),
                      trailing: RPadding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                        child: Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              50.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
