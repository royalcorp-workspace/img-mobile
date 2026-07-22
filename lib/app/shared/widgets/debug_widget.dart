import 'package:dio_request_inspector/dio_request_inspector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/shared/widgets/button/overlay_log_button.dart';

class DebugWidget extends StatelessWidget {
  final Widget widget;
  const DebugWidget({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget,
        OverlayLogButton(
          onTap: () => Get.find<DioRequestInspector>().goToInspector(),
        )
      ],
    );
  }
}
