import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:img/app/core/helper/helper.dart';
import 'package:img/app/core/styles/app_color.dart';
import 'package:img/app/domain/entities/content_event_active_data_entity.dart';

class EventTimerCard extends StatelessWidget {
  const EventTimerCard({
    super.key,
    this.event,
    required this.duration,
    required this.eventTitle,
    required this.isEventActive,
    this.bannerImageUrl,
    this.onTap,
  });

  final ContentEventActiveDataEntity? event;
  final String duration;
  final String eventTitle;
  final bool isEventActive;
  final String? bannerImageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (!isEventActive && duration == '00 : 00 : 00') {
      return const SizedBox.shrink();
    }

    final imageUrl = event?.bannerImageUrl ??
        event?.bannerImage ??
        bannerImageUrl ??
        '';

    final bool isNetwork =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    final titleText = (eventTitle.isNotEmpty)
        ? eventTitle
        : (event?.title ?? 'Promo Mega Campaign');

    // Parse duration string "HH : mm : ss" into time units
    final timeParts = duration.split(':').map((e) => e.trim()).toList();
    final hours = timeParts.isNotEmpty ? timeParts[0] : '00';
    final minutes = timeParts.length > 1 ? timeParts[1] : '00';
    final seconds = timeParts.length > 2 ? timeParts[2] : '00';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF8B1212),
                Color(0xFFB82424),
                Color(0xFF6B0B0B),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B1212).withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Stack(
              children: [
                // Background Banner Image if available
                if (imageUrl.isNotEmpty)
                  Positioned.fill(
                    child: isNetwork
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                          )
                        : Image.asset(
                            Helper.getImagePath(imageUrl),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                          ),
                  ),

                // Dark Gradient Overlay for readability
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.80),
                          Colors.black.withOpacity(0.45),
                          Colors.black.withOpacity(0.80),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                ),

                // Content Row
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  child: Row(
                    children: [
                      // Title & Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                'PROMO SPECIAL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              titleText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            2.verticalSpace,
                            Text(
                              'Berakhir Dalam',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),

                      10.horizontalSpace,

                      // Countdown Timer Digit Boxes
                      Row(
                        children: [
                          _buildTimeBox(hours),
                          _buildColon(),
                          _buildTimeBox(minutes),
                          _buildColon(),
                          _buildTimeBox(seconds),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeBox(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      constraints: BoxConstraints(minWidth: 28.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFF8B1212),
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildColon() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Text(
        ':',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
