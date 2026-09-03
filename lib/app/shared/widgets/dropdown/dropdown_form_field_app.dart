import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';

class DropdownFormFieldApp<T> extends StatelessWidget {
  const DropdownFormFieldApp({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.title,
    this.hintText,
    this.prefix,
    this.isExpanded = true,
  });

  final String? title, hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final Widget? prefix;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Matching Title Text
        if (title != null && title!.isNotEmpty) ...[
          Text(
            title!,
            style: AppTextStyle.mediumBlackBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          5.verticalSpace,
        ],

        // Matching Shadow Wrapper
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.02),
                offset: const Offset(0, -4),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
          ),
          child: DropdownButtonFormField<T>(
            isExpanded: isExpanded,
            value: value,
            items: items,
            onChanged: onChanged,
            style: AppTextStyle.mediumBlack,
            icon: const Icon(Icons.keyboard_arrow_down,
                color: AppColors.lightGrey),
            dropdownColor:
                AppColors.white, // Background color of opened overlay menu
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyle.mediumGrey,
              fillColor: AppColors.white,
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

              // Matching Borders
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.lightGrey),
                borderRadius: BorderRadius.circular(14),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(14),
              ),
              prefixIcon:
                  prefix, // Used prefixIcon to keep inside padding consistent
            ),
          ),
        ),
      ],
    );
  }
}
