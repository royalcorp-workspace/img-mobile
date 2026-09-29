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
        child: Obx(() {
          if (controller.isFetching.value &&
              controller.customerModel.value == null) {
            return const Center(child: LoadingIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => controller.fetchProfile(),
            color: AppColors.primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 42.r,
                            backgroundColor: AppColors.primaryColor,
                            child: controller.customerModel.value?.avatar !=
                                        null &&
                                    controller
                                        .customerModel.value!.avatar!.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      controller.customerModel.value!.avatar!,
                                      width: 80.r,
                                      height: 80.r,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.person_outline,
                                        size: 45,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.person_outline,
                                    size: 45,
                                    color: Colors.white,
                                  ),
                          ),
                        ],
                      ),
                    ),
                    24.verticalSpace,
                    TextFormfieldApp(
                      title: 'Nama Lengkap',
                      controller: controller.nameController,
                      hintText: 'Masukkan nama lengkap',
                    ),
                    16.verticalSpace,
                    TextFormfieldApp(
                      title: 'Nomor Telepon',
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      hintText: 'Masukkan nomor telepon',
                    ),
                    16.verticalSpace,
                    TextFormfieldApp(
                      title: 'Email',
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'Masukkan email',
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
