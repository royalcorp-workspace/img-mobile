import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/core/utils/token_storage.dart';
import 'package:img/app/data/models/customer_model.dart';
import 'package:img/app/data/models/customer_update_request.dart';
import 'package:img/app/data/models/user_model.dart';
import 'package:img/app/domain/usecases/get_customer_profile_usecase.dart';
import 'package:img/app/domain/usecases/update_customer_profile_usecase.dart';
import 'package:img/app/modules/setting/controllers/setting_controller.dart';

class ProfileController extends GetxController {
  final GetCustomerProfileUsecase getCustomerProfileUsecase;
  final UpdateCustomerProfileUsecase updateCustomerProfileUsecase;

  ProfileController({
    required this.getCustomerProfileUsecase,
    required this.updateCustomerProfileUsecase,
  });

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final birthdateController = TextEditingController();

  final selectedGender = RxnString();
  final selectedBirthDate = Rxn<DateTime>();

  final genderOptions = const ['Male', 'Female'];

  final isFetching = false.obs;
  final isLoading = false.obs;

  final customerModel = Rxn<CustomerModel>();
  final userModel = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    _initFromArguments();
    fetchProfile();
  }

  void _initFromArguments() {
    if (Get.arguments != null) {
      if (Get.arguments is UserModel) {
        userModel.value = Get.arguments as UserModel;
        final cust = userModel.value?.customer;
        if (cust != null) {
          customerModel.value = cust;
          _populateControllers(cust);
        } else if (userModel.value != null) {
          nameController.text = userModel.value?.name ?? '';
          emailController.text = userModel.value?.email ?? '';
        }
      } else if (Get.arguments is CustomerModel) {
        customerModel.value = Get.arguments as CustomerModel;
        _populateControllers(customerModel.value!);
      }
    }
  }

  void _populateControllers(CustomerModel customer) {
    nameController.text = customer.name ?? '';
    phoneController.text = customer.phone ?? '';
    emailController.text = customer.email ?? '';

    if (customer.birthdate != null && customer.birthdate!.isNotEmpty) {
      birthdateController.text = customer.birthdate!;
      try {
        selectedBirthDate.value = DateTime.parse(customer.birthdate!);
      } catch (_) {}
    }

    if (customer.gender != null && customer.gender!.isNotEmpty) {
      final g = customer.gender!.trim();
      if (g.toLowerCase() == 'male' || g.toLowerCase() == 'laki-laki') {
        selectedGender.value = 'Male';
      } else if (g.toLowerCase() == 'female' ||
          g.toLowerCase() == 'perempuan') {
        selectedGender.value = 'Female';
      } else {
        selectedGender.value = g;
      }
    }
  }

  Future<void> selectBirthDate(BuildContext context) async {
    final DateTime initial = selectedBirthDate.value ?? DateTime(2000, 1, 1);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedBirthDate.value = picked;
      birthdateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> fetchProfile() async {
    try {
      isFetching.value = true;
      final result = await getCustomerProfileUsecase();
      customerModel.value = result;
      _populateControllers(result);
      await _syncLocalUserData(result);
    } catch (e) {
      logger.severe('❌ [PROFILE-CONTROLLER] Error fetching profile: $e');
    } finally {
      isFetching.value = false;
    }
  }

  Future<void> updateProfile() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final birthdate = birthdateController.text.trim();
    final gender = selectedGender.value;

    if (name.isEmpty) {
      Get.snackbar('Kesalahan', 'Nama tidak boleh kosong',
          backgroundColor: Get.context!.theme.colorScheme.error,
          colorText: Colors.white);
      return;
    }

    if (email.isEmpty) {
      Get.snackbar('Kesalahan', 'Email tidak boleh kosong',
          backgroundColor: Get.context!.theme.colorScheme.error,
          colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final request = CustomerUpdateRequest(
        name: name,
        email: email,
        phone: phone,
        birthdate: birthdate.isNotEmpty ? birthdate : null,
        gender: gender,
        meta: {
          if (birthdate.isNotEmpty) 'birthdate': birthdate,
          if (gender != null) 'gender': gender,
        },
      );

      final updatedCustomer = await updateCustomerProfileUsecase(request);
      customerModel.value = updatedCustomer;
      _populateControllers(updatedCustomer);
      await _syncLocalUserData(updatedCustomer);

      if (Get.isRegistered<SettingController>()) {
        Get.find<SettingController>().loadUserProfile();
      }

      Get.snackbar(
        'Berhasil',
        'Profil Anda berhasil diperbarui',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      logger.severe('❌ [PROFILE-CONTROLLER] Error updating profile: $e');
      Get.snackbar(
        'Gagal',
        'Gagal memperbarui profil. Silakan coba lagi.',
        backgroundColor: Get.context!.theme.colorScheme.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _syncLocalUserData(CustomerModel customer) async {
    try {
      final existingData = await TokenStorage.getUserData();
      Map<String, dynamic> userMap = {};
      if (existingData != null && existingData.isNotEmpty) {
        userMap = jsonDecode(existingData);
      }
      userMap['name'] = customer.name;
      userMap['email'] = customer.email;
      userMap['customer'] = customer.toJson();

      if (TokenStorage.serverToken != null) {
        await TokenStorage.save(
          TokenStorage.serverToken!,
          refresh: TokenStorage.refreshToken,
          userDataJson: jsonEncode(userMap),
        );
      }
    } catch (e) {
      logger.warning(
          '⚠️ [PROFILE-CONTROLLER] Failed to sync local user data: $e');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    birthdateController.dispose();
    super.onClose();
  }
}
