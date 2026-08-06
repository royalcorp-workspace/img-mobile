import 'customer_model.dart';

class UserModel {
  final String? id;
  final String? email;
  final String? name;
  final String? username;
  final CustomerModel? customer;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.username,
    this.customer,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      username: json['username'] as String?,
      customer: json['customer'] != null
          ? CustomerModel.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'customer': customer?.toJson(),
    };
  }
}
