import 'user_model.dart';

class AuthResponseModel {
  final String? csrfToken;
  final String? accessToken;
  final String? tokenType;
  final UserModel? user;

  AuthResponseModel({
    this.csrfToken,
    this.accessToken,
    this.tokenType,
    this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      csrfToken: json['csrf_token'] as String?,
      accessToken: (json['access_token'] ?? json['token']) as String?,
      tokenType: json['token_type'] as String?,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'csrf_token': csrfToken,
      'access_token': accessToken,
      'token_type': tokenType,
      'user': user?.toJson(),
    };
  }
}

class LogoutResponseModel {
  final String message;

  LogoutResponseModel({
    required this.message,
  });

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) =>
      LogoutResponseModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
