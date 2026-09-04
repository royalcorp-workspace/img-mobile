import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/network/logger_interceptor.dart';
import 'package:img/app/core/utils/constants/network_constant.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/core/utils/token_storage.dart';
import 'package:img/app/routes/app_pages.dart';

class DioNetwork {
  static final Dio appAPI = Dio(_baseOptions(apiUrl))
    ..interceptors.addAll([
      loggerInterceptor(),
      appQueuedInterceptorsWrapper(),
    ]);

  static LoggerInterceptor loggerInterceptor() {
    return LoggerInterceptor(
      logger,
      request: true,
      requestBody: true,
      error: true,
      responseBody: true,
      responseHeader: false,
      requestHeader: true,
    );
  }

  ///__________App__________///

  /// App Api Queued Interceptor
  static QueuedInterceptorsWrapper appQueuedInterceptorsWrapper() {
    return QueuedInterceptorsWrapper(
      onRequest: (RequestOptions options, r) async {
        Map<String, dynamic> headers = Helper.getHeaders();

        if (kDebugMode) {
          print("Headers");
          print(json.encode(headers));
        }
        options.headers = headers;
        appAPI.options.headers = headers;
        return r.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          logger.severe(
              '⚠️ [HTTP-401] Unauthorized / Token expired. Redirecting to LOGIN...');
          await TokenStorage.clear();
          if (Get.currentRoute != Routes.LOGIN) {
            Get.offAllNamed(Routes.LOGIN);
            if (Get.context != null) {
              Get.snackbar(
                'Sesi Berakhir',
                'Sesi Anda telah berakhir, silakan masuk kembali.',
                backgroundColor: Get.context!.theme.colorScheme.error,
                colorText: Colors.white,
              );
            }
          }
        }
        try {
          return handler.next(error);
        } catch (e) {
          return handler.reject(error);
        }
      },
      onResponse: (Response<dynamic> response,
          ResponseInterceptorHandler handler) async {
        return handler.next(response);
      },
    );
  }

  /// App interceptor
  static InterceptorsWrapper interceptorsWrapper() {
    return InterceptorsWrapper(
      onRequest: (RequestOptions options, r) async {
        Map<String, dynamic> headers = Helper.getHeaders();

        options.headers = headers;
        appAPI.options.headers = headers;

        return r.next(options);
      },
      onResponse: (response, handler) async {
        if ("${(response.data["code"] ?? "0")}" != "0") {
          return handler.resolve(response);
        } else {
          return handler.next(response);
        }
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          logger.severe(
              '⚠️ [HTTP-401] Unauthorized / Token expired. Redirecting to LOGIN...');
          await TokenStorage.clear();
          if (Get.currentRoute != Routes.LOGIN) {
            Get.offAllNamed(Routes.LOGIN);
          }
        }
        try {
          return handler.next(error);
        } catch (e) {
          return handler.reject(error);
        }
      },
    );
  }

  static BaseOptions _baseOptions(String url) {
    Map<String, dynamic> headers = Helper.getHeaders();

    return BaseOptions(
        baseUrl: url,
        validateStatus: (s) {
          return s != null && s < 300;
        },
        headers: headers..removeWhere((key, value) => value == null),
        responseType: ResponseType.json);
  }
}
