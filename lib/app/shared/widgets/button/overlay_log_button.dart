import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/shared/widgets/button/log_button.dart';

class OverlayLogButton extends StatefulWidget {
  const OverlayLogButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  State<OverlayLogButton> createState() => _OverlayLogButtonState();
}

class _OverlayLogButtonState extends State<OverlayLogButton> {
  double _y = 100;

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) => Positioned(
            right: 0,
            top: _y,
            child: SizedBox(
              height: 48.w,
              width: 48.w,
              child: Draggable(
                onDragEnd: (details) {
                  setState(() {
                    _y = details.offset.dy - 20;
                  });
                },
                childWhenDragging: Container(),
                feedback: LogButton(
                  color: AppColors.green,
                  onTap: widget.onTap,
                ),
                child: LogButton(
                  color: AppColors.greyWhite.withOpacity(0.3),
                  onTap: widget.onTap,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
