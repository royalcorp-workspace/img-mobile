import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:pos_royal/app/core/network/dio_network.dart';
import 'package:pos_royal/app/core/utils/token_storage.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> registerWithEmail(
      {required String email, required String password}) async {
    logger.info('🔍 [AUTH] Starting email registration: $email');
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      logger.info('✅ [AUTH] Email registration successful: ${cred.user?.uid}');
      await _handlePostAuth();
      return cred;
    } catch (e) {
      logger.severe('❌ [AUTH] Email registration failed: $e');
      rethrow;
    }
  }

  Future<UserCredential> loginWithEmail(
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

  Future<void> signOut() async {
    logger.info('🔍 [AUTH] Starting sign out...');
    try {
      await _auth.signOut();
      await TokenStorage.clear();
      logger.info('✅ [AUTH] Sign out successful');
    } catch (e) {
      logger.severe('❌ [AUTH] Sign out failed: $e');
      rethrow;
    }
  }

  /// Sign in with Google and link to Firebase
  Future<UserCredential?> signInWithGoogle() async {
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

      await _handlePostAuth();
      return userCred;
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
  Future<UserCredential?> signInWithApple() async {
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

  /// Call Laravel backend to verify firebase token and receive server token
  Future<bool> _verifyWithServer(String firebaseToken) async {
    logger.info('🔍 [AUTH-VERIFY] Verifying token with server...');
    try {
      logger.info('🔍 [AUTH-VERIFY] Sending POST /auth/verify');
      final resp = await DioNetwork.appAPI.post('/auth/firebase-login',
          data: {'firebase_token': firebaseToken});

      logger.info('🔍 [AUTH-VERIFY] Response status: ${resp.statusCode}');
      logger.info('🔍 [AUTH-VERIFY] Response data: ${resp.data}');

      if (resp.statusCode != null && resp.statusCode! < 300) {
        final serverToken = resp.data['token']?.toString();
        if (serverToken != null) {
          logger.info(
              '✅ [AUTH-VERIFY] Server token received: ${serverToken.substring(0, 20)}...');
          await TokenStorage.save(serverToken);
          logger.info('✅ [AUTH-VERIFY] Token saved to storage');
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

  Future<void> _handlePostAuth() async {
    logger.info('🔍 [AUTH-POST] Starting post-auth verification...');
    try {
      final fbToken = await _getFirebaseToken();
      if (fbToken != null) {
        await _verifyWithServer(fbToken);
        logger.info('✅ [AUTH-POST] Post-auth verification completed');
      } else {
        logger.warning('⚠️ [AUTH-POST] No Firebase token available');
      }
    } catch (e) {
      logger.severe('❌ [AUTH-POST] Post-auth failed: $e');
    }
  }
}
