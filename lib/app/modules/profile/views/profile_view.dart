import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/shared/widgets/button/primary_button.dart';
import 'package:img/app/shared/widgets/dropdown/dropdown_form_field_app.dart';
import 'package:img/app/shared/widgets/loading_indicator.dart';
import 'package:img/app/shared/widgets/textformfield/text_form_field_app.dart';

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
                                ? CircleAvatar(
                                    radius: 40.r,
                                    backgroundImage: NetworkImage(
                                      controller.customerModel.value!.avatar!,
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
                    16.verticalSpace,
                    GestureDetector(
                      onTap: () => controller.selectBirthDate(context),
                      child: AbsorbPointer(
                        child: TextFormfieldApp(
                          title: 'Tanggal Lahir',
                          controller: controller.birthdateController,
                          hintText: 'Pilih tanggal lahir (YYYY-MM-DD)',
                          readOnly: true,
                          suffixIcon: const Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    16.verticalSpace,
                    Obx(
                      () => DropdownFormFieldApp<String>(
                        title: 'Jenis Kelamin',
                        hintText: '',
                        value: controller.selectedGender.value,
                        items: controller.genderOptions.map((gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(
                              gender == 'Male' ? 'Laki-laki' : 'Perempuan',
                              style: AppTextStyle.mediumBlack,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          controller.selectedGender.value = val;
                        },
                      ),
                    ),
                    32.verticalSpace,
                    Obx(
                      () => ButtonPrimary(
                        fullWidth: true,
                        text: 'Simpan',
                        isLoading: controller.isLoading.value,
                        onPressed: () => controller.updateProfile(),
                        borderRadius: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
