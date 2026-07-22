import 'package:flutter/material.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';

class ProductCategoryCard extends StatelessWidget {
  const ProductCategoryCard({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.lightGrey),
          boxShadow: [
            BoxShadow(
              color: AppColors.lightGrey.withOpacity(0.3),
              offset: const Offset(0, 3),
            ),
          ],
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(
              Helper.getImagePath(image),
            ),
          ),
        ),
      ),
    );
  }
}
