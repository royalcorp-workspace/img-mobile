import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/core/utils/token_storage.dart';
import 'package:pos_royal/app/data/datasources/customer_remote_datasource.dart';
import 'package:pos_royal/app/data/datasources/region_remote_datasource.dart';
import 'package:pos_royal/app/data/models/customer_update_request.dart';
import 'package:pos_royal/app/data/models/user_model.dart';
import 'package:pos_royal/app/data/repositories/customer_repository_impl.dart';
import 'package:pos_royal/app/data/repositories/region_repository_impl.dart';
import 'package:pos_royal/app/domain/entities/city_entity.dart';
import 'package:pos_royal/app/domain/entities/provincy_entity.dart';
import 'package:pos_royal/app/domain/entities/sub_district_entity.dart';
import 'package:pos_royal/app/domain/usecases/add_address_usecase.dart';
import 'package:pos_royal/app/domain/usecases/get_region_city_usecase.dart';
import 'package:pos_royal/app/domain/usecases/get_region_provincy_usecase.dart';
import 'package:pos_royal/app/domain/usecases/get_region_sub_district_usecase.dart';

class DetailAddressController extends GetxController {
  DetailAddressController({
    this.getRegionProvincyUsecase,
    this.getRegionCityUsecase,
    this.getRegionSubDistrictUsecase,
    this.addAddressUsecase,
  });

  final GetRegionProvincyUsecase? getRegionProvincyUsecase;
  final GetRegionCityUsecase? getRegionCityUsecase;
  final GetRegionSubDistrictUsecase? getRegionSubDistrictUsecase;
  final AddAddressUsecase? addAddressUsecase;

  final recipientNameController = TextEditingController();
  final phoneController = TextEditingController();
  final labelController = TextEditingController();
  final addressController = TextEditingController();

  var isPrimary = false.obs;
  var provincy = <ProvincyEntity>[].obs;
  var city = <CityEntity>[].obs;
  var subDistrict = <SubDistrictEntity>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMoreProvincy = true.obs;
  var hasMoreCity = true.obs;
  var hasMoreSubDistrict = true.obs;
  var currentPage = 1;
  final int itemsPerPage = 10;
  var productErrorMessage = ''.obs;

  RxString selectedCity = ''.obs;
  RxString selectedProvincy = ''.obs;
  RxString selectedSubDistrict = ''.obs;
  RxString selectedPostalCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchProvincy();
  }

  @override
  void onClose() {
    recipientNameController.dispose();
    phoneController.dispose();
    labelController.dispose();
    addressController.dispose();
    super.onClose();
  }

  Future<void> _fetchProvincy() async {
    try {
      isLoading.value = true;
      currentPage = 1;
      hasMoreProvincy.value = true;

      final useCase = getRegionProvincyUsecase ??
          GetRegionProvincyUsecase(
            RegionRepositoryImpl(
              remoteDataSource: RegionRemoteDataSourceImpl(),
            ),
          );

      final result =
          await useCase.call(page: currentPage, itemsPerPage: itemsPerPage);
      provincy.assignAll(result.data);
      hasMoreProvincy.value = result.hasMore;
    } catch (e, stackTrace) {
      logger.severe('❌ [PROVINCY] Failed to fetch provincy: $e');
      if (kDebugMode) {
        print('❌ [PROVINCY] Error: $e');
        print(stackTrace);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCity(String provincyID) async {
    try {
      isLoading.value = true;
      currentPage = 1;
      hasMoreCity.value = true;

      final useCase = getRegionCityUsecase ??
          GetRegionCityUsecase(
            RegionRepositoryImpl(
              remoteDataSource: RegionRemoteDataSourceImpl(),
            ),
          );

      final result = await useCase.call(
        page: currentPage,
        itemsPerPage: itemsPerPage,
        provincyID: provincyID,
      );
      city.assignAll(result.data);
      hasMoreCity.value = result.hasMore;
    } catch (e, stackTrace) {
      logger.severe('❌ [CITY] Failed to fetch city: $e');
      if (kDebugMode) {
        print('❌ [CITY] Error: $e');
        print(stackTrace);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSubDistrict(String cityID) async {
    try {
      isLoading.value = true;
      currentPage = 1;
      hasMoreSubDistrict.value = true;

      final useCase = getRegionSubDistrictUsecase ??
          GetRegionSubDistrictUsecase(
            RegionRepositoryImpl(
              remoteDataSource: RegionRemoteDataSourceImpl(),
            ),
          );

      final result = await useCase.call(
        page: currentPage,
        itemsPerPage: itemsPerPage,
        cityID: cityID,
      );
      subDistrict.assignAll(result.data);
      hasMoreSubDistrict.value = result.hasMore;
    } catch (e, stackTrace) {
      logger.severe('❌ [SUB DISTRICT] Failed to fetch sub district: $e');
      if (kDebugMode) {
        print('❌ [SUB DISTRICT] Error: $e');
        print(stackTrace);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void toggleIsPrimary(bool? value) {
    if (value != null) {
      isPrimary.value = value;
    }
  }

  Future<String?> _getOrFetchCustomerId() async {
    try {
      final userDataStr = await TokenStorage.getUserData();
      if (userDataStr != null && userDataStr.isNotEmpty) {
        final Map<String, dynamic> userMap = jsonDecode(userDataStr);
        final userModel = UserModel.fromJson(userMap);
        final customerId = userModel.customer?.id;
        if (customerId != null && customerId.isNotEmpty) {
          return customerId;
        }
        final userId = userModel.id;
        if (userId != null && userId.isNotEmpty) {
          return userId;
        }
      }
    } catch (e) {
      logger.warning(
          '⚠️ [DETAIL_ADDRESS] Could not parse stored user customer ID: $e');
    }
    return null;
  }

  bool validateForm() {
    if (recipientNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Nama penerima tidak boleh kosong.',
      );
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Nomor HP tidak boleh kosong.',
      );
      return false;
    }
    if (labelController.text.trim().isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Label alamat tidak boleh kosong.',
      );
      return false;
    }
    if (selectedProvincy.value.isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Silakan pilih Provinsi.',
      );
      return false;
    }
    if (selectedCity.value.isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Silakan pilih Kota.',
      );
      return false;
    }
    if (selectedSubDistrict.value.isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Silakan pilih Desa / Kelurahan.',
      );
      return false;
    }
    if (selectedPostalCode.value.isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Silakan pilih Kode Pos.',
      );
      return false;
    }
    if (addressController.text.trim().isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Alamat lengkap tidak boleh kosong.',
      );
      return false;
    }
    return true;
  }

  Future<void> addAddress() async {
    if (isLoading.value) return;

    if (!validateForm()) return;

    try {
      isLoading.value = true;

      final userDataStr = await TokenStorage.getUserData();
      if (userDataStr == null || userDataStr.isEmpty) {
        Get.snackbar(
          'Gagal',
          'Data pengguna tidak ditemukan. Silakan login kembali.',
        );
        return;
      }

      final Map<String, dynamic> userMap = jsonDecode(userDataStr);
      final userModel = UserModel.fromJson(userMap);
      final customer = userModel.customer;

      final String? customerId = await _getOrFetchCustomerId();
      if (customerId == null || customerId.isEmpty) {
        Get.snackbar(
          'Gagal',
          'Customer ID tidak ditemukan.',
        );
        return;
      }

      final newAddressRequest = AddressRequest(
        address: addressController.text.trim(),
        cityId: selectedCity.value,
        isPrimary: isPrimary.value,
        label: labelController.text.trim(),
        phone: phoneController.text.trim(),
        postalCode: selectedPostalCode.value,
        recipientName: recipientNameController.text.trim(),
        subDistrictId: selectedSubDistrict.value,
      );

      final updateRequest = CustomerUpdateRequest(
        userId: customer?.userId ?? userModel.id,
        name: customer?.name ?? userModel.name,
        email: customer?.email ?? userModel.email,
        phone: phoneController.text.trim().isNotEmpty
            ? phoneController.text.trim()
            : (customer?.phone ?? ''),
        addresses: [newAddressRequest],
      );

      final useCase = addAddressUsecase ??
          AddAddressUsecase(
            CustomerRepositoryImpl(
              remoteDataSource: CustomerRemoteDataSourceImpl(),
            ),
          );

      final updatedCustomer = await useCase.call(
        customerId: customerId,
        request: updateRequest,
      );

      try {
        final updatedUserModel = UserModel(
          id: userModel.id,
          email: userModel.email,
          name: userModel.name,
          username: userModel.username,
          customer: updatedCustomer,
        );
        if (TokenStorage.serverToken != null) {
          await TokenStorage.save(
            TokenStorage.serverToken!,
            userDataJson: jsonEncode(updatedUserModel.toJson()),
          );
        }
      } catch (e) {
        logger.warning(
            '⚠️ [DETAIL_ADDRESS] Failed to save updated user data: $e');
      }

      Get.back(result: true);
    } catch (e, stackTrace) {
      logger.severe('❌ [DETAIL_ADDRESS] Failed to add address: $e');
      if (kDebugMode) {
        print('❌ [DETAIL_ADDRESS] Error: $e');
        print(stackTrace);
      }
      Get.snackbar(
        'Gagal',
        'Gagal menyimpan alamat. Silakan coba lagi.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
