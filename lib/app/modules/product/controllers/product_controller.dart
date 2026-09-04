import 'dart:async';

import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:img/app/data/datasources/homepage_content_remote_datasource.dart';
import 'package:img/app/data/repositories/homepage_content_repository_impl.dart';
import 'package:img/app/domain/entities/homepage_content_entity.dart';
import 'package:img/app/domain/usecases/get_homepage_content_usecase.dart';

class ProductController extends GetxController {
  ProductController({
    this.getHomepageContentUsecase,
  });

  final GetHomepageContentUsecase? getHomepageContentUsecase;

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Timer _timer;

  RxInt selectedIndex = 0.obs;
  RxInt start = 3600.obs;
  final SearchController searchAnchorController = SearchController();
  final homepageContent = <HomepageContentSectionEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();
    fetchHomepageContent();
  }

  @override
  void onClose() {
    _timer.cancel();
    searchAnchorController.dispose();
    super.onClose();
  }

  String get formattedTime {
    final duration = Duration(seconds: start.value);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours : $minutes : $seconds';
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
        } else {
          start--;
        }
      },
    );
  }

  Future<void> fetchHomepageContent() async {
    try {
      final useCase = getHomepageContentUsecase ??
          GetHomepageContentUsecase(
            HomepageContentRepositoryImpl(
              remoteDataSource: HomepageContentRemoteDataSourceImpl(),
            ),
          );
      final result = await useCase.call();
      homepageContent.assignAll(
        result.data.where((section) => section.isVisible),
      );
    } catch (e) {
      logger.warning('Failed to load homepage content: $e');
    }
  }
}
