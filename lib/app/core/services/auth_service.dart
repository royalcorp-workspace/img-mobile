import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:img/app/core/network/dio_network.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/core/utils/token_storage.dart';
import 'package:img/app/data/models/auth_response_model.dart';
import 'package:img/app/routes/app_pages.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> login({required String email, required String password}) async {
    logger.info('🔍 [AUTH-LOGIN] Starting email login: $email');
    try {
      logger.info('🔍 [AUTH-LOGIN] Sending POST /auth/login');
      final resp = await DioNetwork.appAPI
          .post('/auth/login', data: {'email': email, 'password': password});

      logger.info('🔍 [AUTH-LOGIN] Response status: ${resp.statusCode}');
      logger.info('🔍 [AUTH-LOGIN] Response data: ${resp.data}');

      if (resp.statusCode != null &&
          resp.statusCode! < 300 &&
          resp.data != null) {
        final Map<String, dynamic> dataMap = resp.data is String
            ? jsonDecode(resp.data as String)
            : Map<String, dynamic>.from(resp.data as Map);

        final authResponse = AuthResponseModel.fromJson(dataMap);
        final serverToken = authResponse.accessToken;

        if (serverToken != null && serverToken.isNotEmpty) {
          logger.info(
              '✅ [AUTH-LOGIN] Server token received: ${serverToken.substring(0, 20)}...');
          await TokenStorage.save(
            serverToken,
            csrf: authResponse.csrfToken,
            userDataJson: authResponse.user != null
                ? jsonEncode(authResponse.user!.toJson())
                : null,
          );
          logger.info('✅ [AUTH-LOGIN] Token and user data saved to storage');
          return true;
        } else {
          logger.warning('⚠️ [AUTH-LOGIN] No token in response');
        }
      } else {
        logger.warning(
            '⚠️ [AUTH-LOGIN] Invalid response status: ${resp.statusCode}');
      }
    } catch (e) {
      logger.severe('❌ [AUTH-LOGIN] Server verification failed: $e');
      logger.severe('  Error type: ${e.runtimeType}');
      rethrow;
    }
    return false;
  }

  Future<UserCredential> loginWithEmailFirebase(
      {required String email, required String password}) async {
    logger.info('🔍 [AUTH] Starting email login: $email');
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      logger.info('✅ [AUTH] Email login successful: ${cred.user?.uid}');
      await _handlePostAuth();
      return cred;
    } catch (e) {
      logger.severe('❌ [AUTH] Email login failed: $e');
      rethrow;
    }
  }

  /// Sign in with Google and link to Firebase
  Future<bool?> loginWithGmail() async {
    logger.info('🔍 [AUTH-GOOGLE] Starting Google sign in...');
    try {
      logger.info('🔍 [AUTH-GOOGLE] Creating GoogleSignIn instance...');
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'profile',
        ],
      );

      logger.info('🔍 [AUTH-GOOGLE] Calling GoogleSignIn.signIn()...');
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        logger.warning('⚠️ [AUTH-GOOGLE] Google sign in aborted by user');
        return null;
      }

      logger.info('✅ [AUTH-GOOGLE] Google user signed in: ${googleUser.email}');
      logger.info('🔍 [AUTH-GOOGLE] Getting authentication tokens...');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      logger.info('✅ [AUTH-GOOGLE] Got authentication tokens');
      logger.info(
          '  - Access Token: ${googleAuth.accessToken?.substring(0, 20)}...');
      logger.info('  - ID Token: ${googleAuth.idToken?.substring(0, 20)}...');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      logger.info('🔍 [AUTH-GOOGLE] Signing in with Firebase...');
      final userCred = await _auth.signInWithCredential(credential);
      logger.info(
          '✅ [AUTH-GOOGLE] Firebase sign in successful: ${userCred.user?.uid}');

      final verified = await _handlePostAuth();
      if (!verified) {
        logger.warning(
            '⚠️ [AUTH-GOOGLE] Server verification failed; navigation blocked');
        throw Exception('Server verification failed');
      }
      return true;
    } on PlatformException catch (e) {
      logger.severe('❌ [AUTH-GOOGLE] PlatformException: ${e.code}');
      logger.severe('  Message: ${e.message}');
      logger.severe('  Details: ${e.details}');

      // Error code 10 = Configuration error (SHA-1 mismatch, missing google-services.json, etc)
      if (e.code == 'sign_in_failed' && e.message?.contains('10') == true) {
        logger.severe('');
        logger.severe('⚠️ *** FIREBASE CONFIGURATION ERROR ***');
        logger
            .severe('Error Code 10: Google Play Services Configuration Issue');
        logger.severe('');
        logger.severe('DEBUGGING STEPS:');
        logger.severe('1. Check SHA-1 Fingerprint:');
        logger.severe(
            '   Run: keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android');
        logger.severe(
            '2. Go to Firebase Console > Project Settings > Your App (Android)');
        logger.severe('3. Add or update the SHA-1 fingerprint');
        logger.severe('4. Download updated google-services.json');
        logger.severe('5. Replace android/app/google-services.json');
        logger.severe('6. Rebuild: flutter clean && flutter pub get');
        logger.severe('');
        logger.severe('OR if using production signing key:');
        logger.severe(
            '   Run: keytool -list -v -keystore /path/to/your/keystore -alias your-alias');
        logger.severe('');
      }
      rethrow;
    } on FirebaseAuthException catch (e) {
      logger.severe(
          '❌ [AUTH-GOOGLE] FirebaseAuthException: ${e.code} - ${e.message}');
      logger.severe('  Details: ${e.toString()}');
      rethrow;
    } catch (e) {
      logger.severe('❌ [AUTH-GOOGLE] Google sign in failed: $e');
      logger.severe('  Error type: ${e.runtimeType}');
      logger.severe('  Stack trace: ${e.toString()}');
      rethrow;
    }
  }

  /// Sign in with Apple and link to Firebase
  Future<UserCredential?> loginWithApple() async {
    logger.info('🔍 [AUTH-APPLE] Starting Apple sign in...');
    try {
      logger.info('🔍 [AUTH-APPLE] Getting Apple ID credential...');
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      logger.info('✅ [AUTH-APPLE] Got Apple credential');
      logger.info('  - User ID: ${appleCredential.userIdentifier}');
      logger.info('  - Email: ${appleCredential.email}');

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      logger.info('🔍 [AUTH-APPLE] Signing in with Firebase...');
      final userCred = await _auth.signInWithCredential(oauthCredential);
      logger.info(
          '✅ [AUTH-APPLE] Firebase sign in successful: ${userCred.user?.uid}');

      await _handlePostAuth();
      return userCred;
    } on FirebaseAuthException catch (e) {
      logger.severe(
          '❌ [AUTH-APPLE] FirebaseAuthException: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      logger.severe('❌ [AUTH-APPLE] Apple sign in failed: $e');
      rethrow;
    }
  }

  /// Call Laravel backend to verify firebase token and receive server token
  Future<bool> _verifyWithServer(String firebaseToken) async {
    logger.info('🔍 [AUTH-VERIFY] Verifying token with server...');
    try {
      logger.info('🔍 [AUTH-VERIFY] Sending POST /auth/firebase-login');
      final resp = await DioNetwork.appAPI.post('/auth/firebase-login',
          data: {'firebase_token': firebaseToken});

      logger.info('🔍 [AUTH-VERIFY] Response status: ${resp.statusCode}');
      logger.info('🔍 [AUTH-VERIFY] Response data: ${resp.data}');

      if (resp.statusCode != null &&
          resp.statusCode! < 300 &&
          resp.data != null) {
        final Map<String, dynamic> dataMap = resp.data is String
            ? jsonDecode(resp.data as String)
            : Map<String, dynamic>.from(resp.data as Map);

        final authResponse = AuthResponseModel.fromJson(dataMap);
        final serverToken = authResponse.accessToken;

        if (serverToken != null && serverToken.isNotEmpty) {
          logger.info(
              '✅ [AUTH-VERIFY] Server token received: ${serverToken.substring(0, 20)}...');
          await TokenStorage.save(
            serverToken,
            csrf: authResponse.csrfToken,
            userDataJson: authResponse.user != null
                ? jsonEncode(authResponse.user!.toJson())
                : null,
          );
          logger.info('✅ [AUTH-VERIFY] Token and user data saved to storage');
          return true;
        } else {
          logger.warning('⚠️ [AUTH-VERIFY] No token in response');
        }
      } else {
        logger.warning(
            '⚠️ [AUTH-VERIFY] Invalid response status: ${resp.statusCode}');
      }
    } catch (e) {
      logger.severe('❌ [AUTH-VERIFY] Server verification failed: $e');
      logger.severe('  Error type: ${e.runtimeType}');
    }

    return false;
  }

  Future<String?> _getFirebaseToken() async {
    logger.info('🔍 [AUTH] Getting Firebase token...');
    try {
      final user = _auth.currentUser;
      if (user == null) {
        logger.warning('⚠️ [AUTH] No current user found');
        return null;
      }
      logger.info('🔍 [AUTH] Current user: ${user.uid} - ${user.email}');
      final token = await user.getIdToken();
      logger.info(
          '✅ [AUTH] Firebase token obtained: ${token?.substring(0, 20)}...');
      return token;
    } catch (e) {
      logger.severe('❌ [AUTH] Failed to get Firebase token: $e');
      rethrow;
    }
  }

  Future<bool> logout() async {
    logger.info('🔍 [AUTH-LOGOUT] Starting logout');
    try {
      logger.info('🔍 [AUTH-LOGOUT] Sending POST /auth/logout');
      final resp = await DioNetwork.appAPI.post('/auth/logout');

      logger.info('🔍 [AUTH-LOGOUT] Response status: ${resp.statusCode}');
      logger.info('🔍 [AUTH-LOGOUT] Response data: ${resp.data}');

      if (resp.statusCode != null &&
          resp.statusCode! < 300 &&
          resp.data != null) {
        final Map<String, dynamic> dataMap = resp.data is String
            ? jsonDecode(resp.data as String)
            : Map<String, dynamic>.from(resp.data as Map);

        LogoutResponseModel.fromJson(dataMap);

        return true;
      } else {
        logger.warning(
            '⚠️ [AUTH-LOGOUT] Invalid response status: ${resp.statusCode}');
      }
    } catch (e) {
      logger.severe('❌ [AUTH-LOGOUT] Server verification failed: $e');
      logger.severe('  Error type: ${e.runtimeType}');
      rethrow;
    }
    return false;
  }

  Future<void> register(Map<String, dynamic> body) async {
    logger.info('🔍 [AUTH-REGISTER] Starting body: $body');
    try {
      logger.info('🔍 [AUTH-REGISTER] Sending POST /auth/register');
      final resp = await DioNetwork.appAPI.post(
        '/auth/register',
        data: body,
      );

      logger.info('🔍 [AUTH-REGISTER] Response status: ${resp.statusCode}');
      logger.info('🔍 [AUTH-REGISTER] Response data: ${resp.data}');

      String userEmail = body['email'] ?? 'email Anda';
      String verificationLink = '';

      if (resp.statusCode != null &&
          resp.statusCode! < 300 &&
          resp.data != null) {
        Map<String, dynamic> responseData = resp.data is String
            ? jsonDecode(resp.data as String) as Map<String, dynamic>
            : Map<String, dynamic>.from(resp.data as Map);

        verificationLink = responseData['activation_url'] ?? '';
      } else {
        logger.warning(
            '⚠️ [AUTH-REGISTER] Invalid response status: ${resp.statusCode}');
        throw Exception('Gagal mendaftar: Status ${resp.statusMessage}');
      }

      Get.dialog(
        Dialog(
          backgroundColor: AppColors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Periksa Kotak Masuk Anda ✉️',
                  style: AppTextStyle.xLargeBlackBold,
                  textAlign: TextAlign.center,
                ),
                12.verticalSpace,
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Kami telah mengirimkan link verifikasi ke ',
                    style: AppTextStyle.mediumGrey.copyWith(height: 1.2),
                    children: [
                      TextSpan(
                        text: userEmail,
                        style:
                            AppTextStyle.mediumBlackBold.copyWith(height: 1.2),
                      ),
                      TextSpan(
                        text:
                            '\nSilakan klik link tersebut untuk mengaktifkan akun Anda.',
                        style: AppTextStyle.mediumGrey.copyWith(height: 1.2),
                      )
                    ],
                  ),
                ),
                24.verticalSpace,
                SizedBox(
                  width: Get.width,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (verificationLink.isEmpty) {
                        Get.snackbar(
                          'Kesalahan',
                          'Link verifikasi tidak valid atau tidak ditemukan.',
                          backgroundColor: AppColors.red,
                          colorText: AppColors.white,
                        );
                        return;
                      }

                      try {
                        Get.showOverlay(
                          asyncFunction: () async {
                            logger.info(
                                '🔗 [VERIFY-EMAIL] Verifying token via HTTP GET: $verificationLink');

                            final resp =
                                await DioNetwork.appAPI.get(verificationLink);

                            logger.info(
                                '🔗 [VERIFY-EMAIL] Status: ${resp.statusCode}, Data: ${resp.data}');

                            if (resp.statusCode != null &&
                                resp.statusCode! < 300) {
                              Get.back();

                              await Future.delayed(
                                  const Duration(milliseconds: 300));

                              Get.snackbar(
                                'Sukses Berhasil',
                                'Email Anda berhasil diverifikasi!',
                                backgroundColor: AppColors.green,
                                colorText: AppColors.white,
                                snackPosition: SnackPosition.TOP,
                                duration: const Duration(seconds: 3),
                              );

                              Get.offAllNamed(Routes.LOGIN);
                            } else {
                              throw Exception('Respons server tidak valid');
                            }
                          },
                          loadingWidget: const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        );
                      } on DioException catch (e) {
                        String errorMsg = 'Gagal verifikasi akun, coba lagi';
                        if (e.response != null && e.response?.data != null) {
                          final resData = e.response!.data;
                          final errorResponse = resData is String
                              ? jsonDecode(resData) as Map<String, dynamic>
                              : Map<String, dynamic>.from(resData as Map);
                          if (errorResponse.containsKey('detail')) {
                            errorMsg = errorResponse['detail'];
                          } else if (errorResponse.containsKey('message')) {
                            errorMsg = errorResponse['message'];
                          }
                        }

                        Get.snackbar(
                          'Kesalahan',
                          errorMsg,
                          backgroundColor: AppColors.red,
                          colorText: AppColors.white,
                        );
                      } catch (e) {
                        Get.snackbar(
                          'Kesalahan',
                          'Terjadi kesalahan koneksi internet',
                          backgroundColor: AppColors.red,
                          colorText: AppColors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Verifikasi Email',
                      style: AppTextStyle.largeWhiteBold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    } on DioException catch (e) {
      String serverMessage = 'Gagal mendaftar, silakan coba lagi';

      if (e.response != null && e.response?.data != null) {
        final resData = e.response!.data;
        Map<String, dynamic> errorResponse = resData is String
            ? jsonDecode(resData) as Map<String, dynamic>
            : Map<String, dynamic>.from(resData as Map);

        if (errorResponse.containsKey('detail')) {
          serverMessage = errorResponse['detail'];
        }
      }
      logger.severe('❌ [AUTH-REGISTER] Server Error: $serverMessage');

      throw Exception(serverMessage);
    } catch (e) {
      logger.severe('❌ [AUTH-REGISTER] Server verification failed: $e');
      rethrow;
    }
  }

  Future<bool> _handlePostAuth() async {
    logger.info('🔍 [AUTH-POST] Starting post-auth verification...');
    try {
      final fbToken = await _getFirebaseToken();
      if (fbToken != null) {
        final success = await _verifyWithServer(fbToken);
        logger.info(success
            ? '✅ [AUTH-POST] Post-auth verification completed'
            : '⚠️ [AUTH-POST] Post-auth verification failed');
        return success;
      } else {
        logger.warning('⚠️ [AUTH-POST] No Firebase token available');
      }
    } catch (e) {
      logger.severe('❌ [AUTH-POST] Post-auth failed: $e');
    }

    return false;
  }
}
