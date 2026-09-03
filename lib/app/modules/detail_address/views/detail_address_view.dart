import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/domain/entities/city_entity.dart';
import 'package:pos_royal/app/domain/entities/provincy_entity.dart';
import 'package:pos_royal/app/domain/entities/sub_district_entity.dart';
import 'package:pos_royal/app/shared/widgets/app_divider.dart';
import 'package:pos_royal/app/shared/widgets/button/primary_button.dart';
import 'package:pos_royal/app/shared/widgets/dropdown/dropdown_form_field_app.dart';
import 'package:pos_royal/app/shared/widgets/textformfield/text_form_field_app.dart';

import '../controllers/detail_address_controller.dart';

class DetailAddressView extends GetView<DetailAddressController> {
  const DetailAddressView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 2,
        title: const Text(
          'Detail Alamat',
          style: AppTextStyle.xxLargeWhiteBold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            RPadding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  TextFormfieldApp(
                    title: 'Nama Lengkap Penerima',
                    controller: controller.recipientNameController,
                  ),
                  10.verticalSpace,
                  TextFormfieldApp(
                    title: 'Nomor HP',
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            AppDivider(),
            10.verticalSpace,
            RPadding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  TextFormfieldApp(
                    title: 'Label Alamat',
                    controller: controller.labelController,
                  ),
                  10.verticalSpace,
                  Obx(
                    () {
                      final String? selectedProvId =
                          controller.selectedProvincy.value.isEmpty
                              ? null
                              : controller.selectedProvincy.value;
                      final bool provExists = controller.provincy
                          .any((item) => item.id == selectedProvId);

                      final String? selectedCityId =
                          controller.selectedCity.value.isEmpty
                              ? null
                              : controller.selectedCity.value;
                      final bool cityExists = controller.city
                          .any((item) => item.id == selectedCityId);

                      return Row(
                        children: [
                          Expanded(
                            child: DropdownFormFieldApp<String>(
                              title: 'Provinsi',
                              value: provExists ? selectedProvId : null,
                              items: controller.provincy
                                  .map((ProvincyEntity item) {
                                return DropdownMenuItem<String>(
                                  value: item.id ?? item.name ?? '',
                                  child: Text(
                                    item.name ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                );
                              }).toList(),
                              onChanged: (e) {
                                if (e != null) {
                                  controller.selectedProvincy.value = e;
                                  controller.selectedCity.value = '';
                                  controller.fetchCity(e);
                                }
                              },
                            ),
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: DropdownFormFieldApp<String>(
                              title: 'Kota',
                              value: cityExists ? selectedCityId : null,
                              items: controller.city.map((CityEntity item) {
                                return DropdownMenuItem<String>(
                                  value: item.id ?? item.name ?? '',
                                  child: Text(
                                    item.name ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                );
                              }).toList(),
                              onChanged: (e) {
                                if (e != null) {
                                  controller.selectedCity.value = e;
                                  controller.fetchSubDistrict(e);
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  10.verticalSpace,
                  Obx(
                    () {
                      final String? selectedSubDistrict =
                          controller.selectedSubDistrict.value.isEmpty
                              ? null
                              : controller.selectedSubDistrict.value;

                      final bool subDisExists = controller.subDistrict
                          .any((item) => item.id == selectedSubDistrict);

                      final String? selectedPostalID =
                          controller.selectedPostalCode.value.isEmpty
                              ? null
                              : controller.selectedPostalCode.value;

                      final bool postalCodeExist = controller.subDistrict
                          .any((item) => item.postalCode == selectedPostalID);

                      return Row(
                        children: [
                          Expanded(
                            child: DropdownFormFieldApp<String>(
                              isExpanded: true,
                              title: 'Desa / Kelurahan',
                              value: subDisExists ? selectedSubDistrict : null,
                              items: controller.subDistrict
                                  .map((SubDistrictEntity item) {
                                return DropdownMenuItem<String>(
                                  value: item.id ?? item.district ?? '',
                                  child: Text(
                                    item.district ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                );
                              }).toList(),
                              onChanged: (e) {
                                if (e != null) {
                                  controller.selectedSubDistrict.value = e;
                                }
                              },
                            ),
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: DropdownFormFieldApp<String>(
                              title: 'Postal Code',
                              value: postalCodeExist ? selectedPostalID : null,
                              items: controller.subDistrict
                                  .map((SubDistrictEntity item) {
                                return DropdownMenuItem<String>(
                                  value: item.postalCode ?? '',
                                  child: Text(
                                    item.postalCode ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                );
                              }).toList(),
                              onChanged: (e) {
                                if (e != null) {
                                  controller.selectedPostalCode.value = e;
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  10.verticalSpace,
                  TextFormfieldApp(
                    title: 'Alamat Lengkap',
                    controller: controller.addressController,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            25.verticalSpace,
            Row(
              children: [
                Obx(
                  () => Checkbox(
                    focusColor: AppColors.red,
                    value: controller.isPrimary.value,
                    onChanged: controller.toggleIsPrimary,
                    activeColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r)),
                  ),
                ),
                Text(
                  'Jadikan alamat utama',
                  style: AppTextStyle.mediumBlack,
                )
              ],
            ),
            RPadding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Obx(
                () => ButtonPrimary(
                  text: 'Simpan',
                  fullWidth: true,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.addAddress,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
