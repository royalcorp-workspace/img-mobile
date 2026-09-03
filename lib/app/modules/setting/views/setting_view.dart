import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/routes/app_pages.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80.h,
            pinned: true,
            backgroundColor: AppColors.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryColor.withOpacity(0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        16.horizontalSpace,
                        Expanded(
                          child: Obx(
                            () => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.userModel.value.name ?? '-',
                                  style: AppTextStyle.largeWhiteBold,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                4.verticalSpace,
                                Text(
                                  controller.userModel.value.email ?? '-',
                                  style: AppTextStyle.mediumWhite,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () => Get.toNamed(Routes.PROFILE),
                        //   icon: const Icon(Icons.edit, color: Colors.white),
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black.withOpacity(0.08),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _menuTile(Icons.feedback_outlined, "Ulasan Produk", () {}),
                    _divider(),
                    _menuTile(
                      Icons.local_offer_outlined,
                      "Voucher & Promo",
                      () => Get.toNamed(Routes.VOUCHER),
                    ),
                    _divider(),
                    _menuTile(
                      Icons.location_on_outlined,
                      "Daftar Alamat",
                      () => Get.toNamed(Routes.ADDRESS),
                    ),
                    _divider(),
                    _menuTile(Icons.security_outlined, "Keamanan", () {}),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black.withOpacity(0.08),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _menuTile(Icons.support_agent, "Bantuan Royal Care", () {}),
                    _divider(),
                    _menuTile(Icons.info_outline, "Ketentuan Privasi", () {}),
                    _divider(),
                    ListTile(
                      leading: Icon(Icons.star_border,
                          color: AppColors.secondaryColor),
                      title: const Text("Beri Rating"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("V 1.0.0", style: AppTextStyle.mediumGrey),
                          8.horizontalSpace,
                          const Icon(Icons.arrow_forward_ios, size: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// LOGOUT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.redContrast,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () => controller.showDeleteConfirmationDialog(),
                icon: const Icon(
                  Icons.logout,
                  color: AppColors.white,
                ),
                label: Text(
                  "Keluar",
                  style: AppTextStyle.largeWhiteBold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile(IconData icon, String title, void Function()? onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.secondaryColor),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, thickness: 0.8);
  }
}
