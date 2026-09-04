import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';

class AppSimpleVerticalStepIndicator extends StatelessWidget {
  const AppSimpleVerticalStepIndicator({
    required this.actualStep,
    this.steps = 4,
    this.height = 300,
    this.width = 250,
    super.key,
    required this.titles,
    required this.timestamps,
  });

  final int actualStep;
  final int steps;
  final double height;
  final double width;
  final List<String> titles;
  final List<String> timestamps;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(titles.length, (step) {
          final isActive = step <= actualStep;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Circle + line
              Column(
                children: [
                  isActive
                      ? Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        )
                      : Icon(
                          Icons.circle,
                          color: AppColors.grey,
                          size: 18,
                        ),
                  Container(
                    width: 2,
                    height: step < titles.length - 1 ? 45 : 0,
                    color: step < actualStep
                        ? AppColors.primaryColor
                        : AppColors.grey,
                  ),
                ],
              ),
              12.horizontalSpace,

              /// Keterangan dinamis
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titles[step],
                      style: isActive
                          ? AppTextStyle.mediumBlack
                          : AppTextStyle.mediumBlack.copyWith(
                              color: AppColors.grey,
                            ),
                    ),
                    Text(
                      timestamps[step],
                      style: isActive
                          ? AppTextStyle.mediumGrey
                          : AppTextStyle.mediumGrey.copyWith(
                              color: AppColors.grey,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
