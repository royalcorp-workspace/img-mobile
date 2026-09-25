import 'address_model.dart';

class AddressRequest {
  final String? address;
  final String? cityId;
  final bool? isPrimary;
  final String? label;
  final String? phone;
  final String? postalCode;
  final String? recipientName;
  final String? subDistrictId;

  AddressRequest({
    this.address,
    this.cityId,
    this.isPrimary,
    this.label,
    this.phone,
    this.postalCode,
    this.recipientName,
    this.subDistrictId,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city_id': cityId,
      'is_primary': isPrimary ?? false,
      'label': label,
      'phone': phone,
      'postal_code': postalCode,
      'recipient_name': recipientName,
      'sub_district_id': subDistrictId,
    };
  }

  factory AddressRequest.fromAddressModel(AddressModel model, {bool? overrideIsPrimary}) {
    return AddressRequest(
      address: model.address,
      cityId: model.cityId,
      isPrimary: overrideIsPrimary ?? model.isPrimary,
      label: model.label,
      phone: model.phone,
      postalCode: model.postalCode,
      recipientName: model.recipientName,
      subDistrictId: model.subDistrictId,
    );
  }
}

class CustomerUpdateRequest {
  final String? userId;
  final String? name;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? photoUrl;
  final String? birthdate;
  final String? gender;
  final dynamic meta;
  final String? currentPassword;
  final String? oldPassword;
  final String? password;
  final String? newPassword;
  final String? confirmPassword;
  final String? passwordConfirmation;
  final List<AddressRequest>? addresses;

  CustomerUpdateRequest({
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.avatar,
    this.photoUrl,
    this.birthdate,
    this.gender,
    this.meta,
    this.currentPassword,
    this.oldPassword,
    this.password,
    this.newPassword,
    this.confirmPassword,
    this.passwordConfirmation,
    this.addresses,
  });

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (avatar != null) 'avatar': avatar,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (birthdate != null) 'birthdate': birthdate,
      if (gender != null) 'gender': gender,
      if (meta != null) 'meta': meta,
      if (currentPassword != null) 'current_password': currentPassword,
      if (oldPassword != null) 'old_password': oldPassword,
      if (password != null) 'password': password,
      if (newPassword != null) 'new_password': newPassword,
      if (confirmPassword != null) 'confirm_password': confirmPassword,
      if (passwordConfirmation != null)
        'password_confirmation': passwordConfirmation,
      if (addresses != null)
        'addresses': addresses?.map((e) => e.toJson()).toList(),
    };
  }
}
