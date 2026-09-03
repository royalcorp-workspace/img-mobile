import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:pos_royal/app/core/utils/token_storage.dart';
import 'package:pos_royal/app/data/datasources/customer_remote_datasource.dart';
import 'package:pos_royal/app/data/models/address_model.dart';
import 'package:pos_royal/app/data/models/user_model.dart';
import 'package:pos_royal/app/data/repositories/customer_repository_impl.dart';
import 'package:pos_royal/app/domain/usecases/get_customer_usecase.dart';
import 'package:pos_royal/app/domain/usecases/set_primary_address_usecase.dart';

class AddressController extends GetxController {
  AddressController({this.getCustomerUsecase, this.setPrimaryAddressUsecase});

  final GetCustomerUsecase? getCustomerUsecase;
  final SetPrimaryAddressUsecase? setPrimaryAddressUsecase;

  var addresses = <AddressModel>[].obs;
  var isLoading = false.obs;
  RxString selectedAddressId = ''.obs;
  RxString selectedOption = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomerAddresses();
  }

  Future<void> setPrimaryAddress(String addressID) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      final String? customerId = await _getOrFetchCustomerId();
      if (customerId == null || customerId.isEmpty) {
        Get.snackbar(
          'Gagal',
          'Customer ID tidak ditemukan.',
        );
        return;
      }

      final useCase = setPrimaryAddressUsecase ??
          SetPrimaryAddressUsecase(
            CustomerRepositoryImpl(
              remoteDataSource: CustomerRemoteDataSourceImpl(),
            ),
          );

      await useCase.call(customerId, addressID);

      final current = List<AddressModel>.from(addresses);
      final updated = applyPrimarySelection(current, addressID);
      addresses.assignAll(updated);
      syncPrimarySelection(addresses);
    } catch (e, stackTrace) {
      logger
          .severe('❌ [SET PRIMARY ADDRESS] Failed to set primary address: $e');
      if (kDebugMode) {
        print('❌ [SET PRIMARY ADDRESS] Error: $e');
        print(stackTrace);
      }
      Get.snackbar(
        'Gagal',
        'Gagal mengubah alamat utama. Silakan coba lagi.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<AddressModel> applyPrimarySelection(
    List<AddressModel> currentAddresses,
    String selectedId,
  ) {
    if (selectedId.isEmpty) return currentAddresses;

    final mapped = currentAddresses.map((address) {
      final isSelected = address.id == selectedId;
      return AddressModel(
        id: address.id,
        userId: address.userId,
        cityId: address.cityId,
        subDistrictId: address.subDistrictId,
        label: address.label,
        recipientName: address.recipientName,
        phone: address.phone,
        address: address.address,
        postalCode: address.postalCode,
        isPrimary: isSelected,
        createdAt: address.createdAt,
        updatedAt: address.updatedAt,
      );
    }).toList();

    return reorderPrimaryAddressFirst(mapped, selectedId);
  }

  List<AddressModel> reorderPrimaryAddressFirst(
    List<AddressModel> currentAddresses,
    String selectedId,
  ) {
    if (selectedId.isEmpty || currentAddresses.isEmpty) {
      return currentAddresses;
    }

    final selectedIndex =
        currentAddresses.indexWhere((a) => a.id == selectedId);
    if (selectedIndex <= 0) {
      return currentAddresses;
    }

    final selectedAddress = currentAddresses.removeAt(selectedIndex);
    final updated = [
      AddressModel(
        id: selectedAddress.id,
        userId: selectedAddress.userId,
        cityId: selectedAddress.cityId,
        subDistrictId: selectedAddress.subDistrictId,
        label: selectedAddress.label,
        recipientName: selectedAddress.recipientName,
        phone: selectedAddress.phone,
        address: selectedAddress.address,
        postalCode: selectedAddress.postalCode,
        isPrimary: true,
        createdAt: selectedAddress.createdAt,
        updatedAt: selectedAddress.updatedAt,
      ),
      ...currentAddresses.map((address) => AddressModel(
            id: address.id,
            userId: address.userId,
            cityId: address.cityId,
            subDistrictId: address.subDistrictId,
            label: address.label,
            recipientName: address.recipientName,
            phone: address.phone,
            address: address.address,
            postalCode: address.postalCode,
            isPrimary: false,
            createdAt: address.createdAt,
            updatedAt: address.updatedAt,
          )),
    ];

    return updated;
  }

  void syncPrimarySelection(List<AddressModel> currentAddresses) {
    if (currentAddresses.isEmpty) {
      selectedAddressId.value = '';
      selectedOption.value = '';
      return;
    }

    final primary = currentAddresses.firstWhere(
      (element) => element.isPrimary == true,
      orElse: () => currentAddresses.first,
    );

    selectedAddressId.value = primary.id ?? '';
    selectedOption.value = primary.id ?? '';
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
      logger
          .warning('⚠️ [ADDRESS] Could not parse stored user customer ID: $e');
    }
    return null;
  }

  Future<void> fetchCustomerAddresses() async {
    try {
      isLoading.value = true;
      final customerId = await _getOrFetchCustomerId();
      if (customerId == null || customerId.isEmpty) {
        logger.warning('⚠️ [ADDRESS] Customer ID is null or empty');
        return;
      }

      final useCase = getCustomerUsecase ??
          GetCustomerUsecase(
            CustomerRepositoryImpl(
              remoteDataSource: CustomerRemoteDataSourceImpl(),
            ),
          );

      final customerModel = await useCase.call(customerId);
      final fetchedAddresses = customerModel.addresses;
      if (fetchedAddresses != null) {
        addresses.assignAll(fetchedAddresses);
        syncPrimarySelection(addresses);
      } else {
        addresses.clear();
        selectedAddressId.value = '';
        selectedOption.value = '';
      }
    } catch (e, stackTrace) {
      logger.severe('❌ [ADDRESS] Failed to fetch customer addresses: $e');
      if (kDebugMode) {
        print('❌ [ADDRESS] Error: $e');
        print(stackTrace);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
