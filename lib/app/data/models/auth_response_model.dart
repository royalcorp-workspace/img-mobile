import 'user_model.dart';

class AuthResponseModel {
  final String? csrfToken;
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final UserModel? user;

  AuthResponseModel({
    this.csrfToken,
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      csrfToken: json['csrf_token'] as String?,
      accessToken: (json['access_token'] ?? json['token']) as String?,
      refreshToken: (json['refresh_token'] ?? json['refresh_token']) as String?,
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
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'user': user?.toJson(),
    };
  }
}
