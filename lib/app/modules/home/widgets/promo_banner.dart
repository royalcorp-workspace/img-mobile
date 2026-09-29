import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Temporary Promo Banner widget based on Reference Image 1 target design.
/// TODO: Replace dummy promo banner data when Promo Banner API is available.
class PromoBanner extends StatelessWidget {
  const PromoBanner({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 100.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF7A1212),
                Color(0xFF9E1B1B),
                Color(0xFF5A0A0A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7A1212).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative background shape / circle accent
              Positioned(
                right: -20,
                bottom: -30,
                child: Container(
                  width: 80.r,
                  height: 80.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
