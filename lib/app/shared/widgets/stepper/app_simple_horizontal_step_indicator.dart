import 'package:flutter/material.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';

class AppSimpleHorizontalStepIndicator extends StatelessWidget {
  const AppSimpleHorizontalStepIndicator(
      {required this.actualStep, this.steps = 4, this.width = 250, super.key});

  final int actualStep;
  final int steps;
  final double width;

  static const colorSuccess = Colors.green;
  static const colorEmpty = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var step in List.generate(steps, (index) => index)) ...[
                  Icon(
                    Icons.circle,
                    color: step <= actualStep
                        ? AppColors.primaryColor
                        : colorEmpty,
                    size: 14,
                  ),
                  SizedBox(
                    width: steps - 1 == step ? 0 : ((width - 20) / steps + 3),
                    child: Divider(
                      color: step < actualStep
                          ? AppColors.primaryColor
                          : colorEmpty,
                      thickness: 2,
                    ),
                  ),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
