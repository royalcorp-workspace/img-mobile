import 'package:dio/dio.dart';
import 'package:dio_request_inspector/dio_request_inspector.dart';
import 'package:get/get.dart';
import 'package:img/app/core/network/dio_network.dart';
import 'package:img/app/shared/data/app_shared_prefs.dart';
import 'package:img/app/core/utils/token_storage.dart';
import 'package:img/app/core/services/auth_service.dart';

Future<void> initInjections() async {
  final appSharedPrefs = AppSharedPrefs();
  await appSharedPrefs.init();
  await TokenStorage.init();

  final inspector = DioRequestInspector(isInspectorEnabled: true);
  DioNetwork.appAPI.interceptors.add(inspector.getDioRequestInterceptor());

  Get
    ..put<Dio>(DioNetwork.appAPI)
    ..put(appSharedPrefs)
    ..put(AuthService())
    ..put(DioNetwork())
    ..put(inspector);
}
