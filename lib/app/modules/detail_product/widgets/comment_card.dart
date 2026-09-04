import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/core/styles/app_text_style.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Erric Hoffman', style: AppTextStyle.mediumBlackBold),
            Text('11-Mar 2026', style: AppTextStyle.smallGrey),
          ],
        ),
        5.verticalSpace,
        Row(
          children: [
            Icon(
              Icons.star,
              size: 15,
              color: AppColors.yellow,
            ),
            2.horizontalSpace,
            Text(
              '5.0',
              style: AppTextStyle.smallGrey,
            ),
          ],
        ),
        5.verticalSpace,
        Text(
          'Lorem ipsum dolor sit amet consectetur. Laoreet molestie porta ultrices aenenan arcu. Imperdiet volutpat egastas congue enim aenean velit sed lacus malesuada. Nunc id',
          style: AppTextStyle.mediumGrey,
        ),
      ],
    );
  }
}
