import 'address_model.dart';

class CustomerModel {
  final String? id;
  final String? userId;
  final String? name;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? photoUrl;
  final String? birthdate;
  final String? gender;
  final dynamic meta;
  final String? createdAt;
  final String? updatedAt;
  final List<AddressModel>? addresses;

  CustomerModel({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.avatar,
    this.photoUrl,
    this.birthdate,
    this.gender,
    this.meta,
    this.createdAt,
    this.updatedAt,
    this.addresses,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      photoUrl: json['photo_url'] as String?,
      birthdate: json['birthdate'] as String? ??
          (json['meta'] is Map ? json['meta']['birthdate'] as String? : null),
      gender: json['gender'] as String? ??
          (json['meta'] is Map ? json['meta']['gender'] as String? : null),
      meta: json['meta'],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'photo_url': photoUrl,
      'birthdate': birthdate,
      'gender': gender,
      'meta': meta,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'addresses': addresses?.map((e) => e.toJson()).toList(),
    };
  }
}
