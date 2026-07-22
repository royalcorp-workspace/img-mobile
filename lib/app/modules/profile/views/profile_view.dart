import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/shared/widgets/textformfield/text_form_field_app.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.shadowGrey,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 2,
          title: const Text(
            'Ubah Profile Saya',
            style: AppTextStyle.xxLargeWhiteBold,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: RPadding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.verticalSpace,
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 38.r,
                        backgroundColor: AppColors.primaryColor,
                        child: Icon(
                          Icons.person_outline,
                          size: 35,
                        ),
                      ),
                      Positioned(
                          bottom: 3,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 20,
                              color: AppColors.white,
                            ),
                          ))
                    ],
                  ),
                ),
                20.verticalSpace,
                Text(
                  'Informasi Umum',
                  style: AppTextStyle.largeBlackBold,
                ),
                20.verticalSpace,
                TextFormfieldApp(
                  title: 'Nama Lengkap',
                  hintText: 'Alghany Kennedy Adam',
                ),
                10.verticalSpace,
                TextFormfieldApp(
                  title: 'Tanggal Lahir',
                  hintText: 'Cth: 01 Januari 1990',
                ),
                10.verticalSpace,
                TextFormfieldApp(
                  title: 'Jenis Kelamin',
                  hintText: 'Laki-laki',
                ),
                10.verticalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Berat/Tinggi Badan',
                      style: AppTextStyle.mediumBlackBold,
                    ),
                    5.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.02),
                                  offset: const Offset(0, -4),
                                  blurRadius: 16,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: TextFormField(
                              style: AppTextStyle.mediumBlack,
                              decoration: InputDecoration(
                                hintText: '65 kg',
                                fillColor: AppColors.white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.lightGrey),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.primaryColor),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                suffixIcon: Icon(
                                  Icons.scale_outlined,
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        15.horizontalSpace,
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.02),
                                  offset: const Offset(0, -4),
                                  blurRadius: 16,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: TextFormField(
                              style: AppTextStyle.mediumBlack,
                              decoration: InputDecoration(
                                hintText: '170 cm',
                                fillColor: AppColors.white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: AppColors.lightGrey,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.primaryColor),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                suffixIcon: Icon(
                                  Icons.height_outlined,
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                    width: Get.width,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(
                        'Simpan',
                        style: AppTextStyle.largeWhiteBold,
                      ),
                    ),
                  ),
                ),
                20.verticalSpace,
              ],
            ),
          ),
        ));
  }
}
