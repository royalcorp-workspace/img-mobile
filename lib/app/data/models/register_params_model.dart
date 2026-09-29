import 'package:img/app/domain/entities/register_params_entity.dart';

class RegisterParamsModel extends RegisterParamsEntity {
  RegisterParamsModel({
    required super.name,
    required super.email,
    required super.password,
    required super.phone,
  });

  factory RegisterParamsModel.fromJson(Map<String, dynamic> json) =>
      RegisterParamsModel(
        name: json["name"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
      };
}
