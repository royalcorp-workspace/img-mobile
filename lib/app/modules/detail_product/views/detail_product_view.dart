import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/modules/detail_product/widgets/cart_badge.dart';
import 'package:pos_royal/app/modules/detail_product/widgets/comment_card.dart';
import 'package:pos_royal/app/modules/detail_product/widgets/detail_product_card.dart';
import 'package:pos_royal/app/modules/home/widgets/product_card.dart';
import 'package:pos_royal/app/routes/app_pages.dart';
import 'package:pos_royal/app/shared/widgets/app_divider.dart';
import 'package:pos_royal/app/shared/widgets/text/text_price_line_through.dart';
import 'package:readmore/readmore.dart';

import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  const DetailProductView({super.key});
  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
      cartKey: controller.cartKey,
      height: 30,
      width: 30,
      opacity: 0.85,
      dragAnimation: const DragToCartAnimationOptions(
        duration: Duration(milliseconds: 500),
      ),
      jumpAnimation: const JumpAnimationOptions(),
      createAddToCartAnimation: (runAddToCartAnimation) {
        controller.runAddToCartAnimation = runAddToCartAnimation;
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: DetailProductCard(
                  widgetKey: controller.widgetKey,
                ),
              ),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: const Text(
                  'Elite Springbed Kasur Pocket Emporium New Edition',
                  style: AppTextStyle.xLargeBlackBold,
                ),
              ),
              5.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.yellow,
                          size: 20,
                        ),
                        5.horizontalSpace,
                        Text(
                          '4.2',
                          style: AppTextStyle.mediumBlackBold.copyWith(
                            color: AppColors.yellow,
                          ),
                        ),
                        5.horizontalSpace,
                        const Text(
                          '(128)',
                          style: AppTextStyle.mediumGrey,
                        ),
                      ],
                    ),
                    8.horizontalSpace,
                    Text(
                      '|',
                      style: AppTextStyle.mediumGrey
                          .copyWith(color: AppColors.lightGrey),
                    ),
                    8.horizontalSpace,
                    Row(
                      children: [
                        const Text(
                          '30',
                          style: AppTextStyle.mediumBlack,
                        ),
                        5.horizontalSpace,
                        const Text(
                          'Terjual',
                          style: AppTextStyle.mediumGrey,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Text(
                      'RP 1.087.210',
                      style: AppTextStyle.xLargeBlackBold.copyWith(
                        color: AppColors.orange,
                      ),
                    ),
                    8.horizontalSpace,
                    const TextPriceLineThrough(price: 'Rp 3.749.000'),
                    8.horizontalSpace,
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.shadeRed,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.remove,
                            size: 12,
                            color: AppColors.orange,
                          ),
                          Text(
                            '71%',
                            style: AppTextStyle.mediumBlackBold.copyWith(
                              color: AppColors.orange,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              10.verticalSpace,
              const Divider(color: AppColors.lightGrey, thickness: 1.2),
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Image.asset(
                    height: 60,
                    width: 60,
                    Helper.getImagePath('img_free_ongkir.png'),
                  ),
                  title: const Text(
                    'Pengiriman Gratis Ongkir',
                    style: AppTextStyle.largeBlackBold,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: AppColors.grey,
                  ),
                ),
              ),
              AppDivider(),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: const Text(
                  'Pilih Ukuran',
                  style: AppTextStyle.largeBlackBold,
                ),
              ),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SizedBox(
                  height: 32.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: controller.sizeProduct.length,
                    itemBuilder: (context, index) => Obx(
                      () => SizeContainer(
                        label: controller.sizeProduct[index],
                        isSelected: controller.selectedIndex.value == index,
                        onTap: () => controller.selectedIndex.value = index,
                      ),
                    ),
                  ),
                ),
              ),
              10.verticalSpace,
              AppDivider(),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: const Text(
                  'Deskripsi Produk',
                  style: AppTextStyle.largeBlackBold,
                ),
              ),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ReadMoreText(
                  '''
Kasur Modern Emporium, didesain khusus dengan fondasi yang kokoh dan semua lini kasur memiliki keunggulan dalam semua dasar material premium, penyangga yang konsisten, dan kebersihan yang maksimal, hingga membuat tidur semakin optimal dan nyenyak semalaman.

Kelengkapan Produk :
Full set : Mattress Emporium, Headboard Watsonia & Divan Paris
Mattres Only : Hanya Kasur Emporium Saja
Feel: Medium
Tebal/Tinggi Kasur: 35 cm

Tersedia Ukuran (Lebar x Panjang):

100 cm x 200 cm
120 cm x 200 cm
160 cm x 200 cm
180 cm x 200 cm
200 cm x 200 cm

EKSTRA BONUS :
Ukuran 200 x 100 = 1 Bantal + 1 Guling Elite Dacron + 1 Elite Mattress Protector
Ukuran 200 x 120 = 1 Bantal + 1 Guling Elite Dacron + 1 Elite Mattress Protector
Ukuran 200 x 160 = 2 Bantal + 2 Guling Elite Dacron + 1 Elite Mattress Protector
Ukuran 200 x 180 = 2 Bantal + 2 Guling Elite Dacron + 1 Elite Mattress Protector
Ukuran 200 x 200 = 2 Bantal + 2 Guling Elite Dacron + 1 Elite Mattress Protector

Pillow Top System
- Comfort Layer: Visco I-Gel, Viro Clean, Sanitized, High Density Dura Foam
- Support Layer: Pocketed Coils With Encase
- Garansi 15 tahun dan dukungan layanan purna jual.

Pengiriman meliputi wilayah Jabodetabek, Bandung, Cirebon, Surabaya, Tasikmalaya, Sukabumi, Karawang, Yogyakarta. Estimasi waktu pengiriman selama 5 -14 hari kerja. Untuk kota lain bisa konfirmasi terlebih dahulu ya ke Admin.

Seluruh Komplain Akan Kami Terima, Apabila Anda Dapat Memenuhi Syarat Sebagai Berikut:
1. Videokan paket yang sudah diterima, dibongkar, dan perlihatkan seluruh barang yang Anda terima serta sesuaikan dengan barang yang Anda pesan.
2. Informasikan paket yang telah tiba pada Admin kami (waktu dapat disesuaikan Brand).
3. Apabila tidak memenuhi dan mengikuti syarat yang telah kami tentukan, maka Anda tidak bisa mengklaim atau membuktikan bahwa barang yang kami kirimkan kurang atau reject.
''',
                  trimMode: TrimMode.Line,
                  trimLines: 4,
                  style: AppTextStyle.mediumBlackSecondary,
                  lessStyle: AppTextStyle.mediumBlack600
                      .copyWith(color: AppColors.primaryColor),
                  trimCollapsedText: 'Lihat Semua',
                  trimExpandedText: 'Lihat Sedikit',
                  moreStyle: AppTextStyle.mediumBlack600
                      .copyWith(color: AppColors.primaryColor),
                ),
              ),
              10.verticalSpace,
              AppDivider(),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ulasan Produk',
                      style: AppTextStyle.largeBlackBold,
                    ),
                    Text(
                      'Lihat Semua',
                      style: AppTextStyle.mediumBlackBold,
                    ),
                  ],
                ),
              ),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.verticalSpace,
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: AppColors.yellow,
                              ),
                              5.horizontalSpace,
                              Text(
                                '4.2',
                                style: AppTextStyle.xLargeBlackBold,
                              ),
                            ],
                          ),
                          12.verticalSpace,
                          Text(
                            '128 Rating\ndan 24 Review',
                            style: AppTextStyle.mediumGrey,
                          )
                        ],
                      ),
                      VerticalDivider(
                        color: AppColors.lightGrey,
                        thickness: 1,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '5',
                                style: AppTextStyle.mediumGrey,
                              ),
                              5.horizontalSpace,
                              Icon(
                                Icons.star,
                                size: 15,
                                color: AppColors.yellow,
                              ),
                              5.horizontalSpace,
                              SizedBox(
                                width: 120,
                                child: LinearProgressIndicator(
                                  backgroundColor: AppColors.lightGrey,
                                  value: 0.8,
                                ),
                              ),
                              5.horizontalSpace,
                              Text(
                                '67%',
                                style: AppTextStyle.mediumGrey,
                              ),
                            ],
                          ),
                          3.verticalSpace,
                          Row(
                            children: [
                              Text(
                                '4',
                                style: AppTextStyle.mediumGrey,
                              ),
                              5.horizontalSpace,
                              Icon(
                                Icons.star,
                                size: 15,
                                color: AppColors.yellow,
                              ),
                              5.horizontalSpace,
                              SizedBox(
                                width: 120,
                                child: LinearProgressIndicator(
                                  backgroundColor: AppColors.lightGrey,
                                  value: 0.2,
                                ),
                              ),
                              5.horizontalSpace,
                              Text(
                                '20%',
                                style: AppTextStyle.mediumGrey,
                              ),
                            ],
                          ),
                          3.verticalSpace,
                          Row(
                            children: [
                              Text(
                                '3',
                                style: AppTextStyle.mediumGrey,
                              ),
                              5.horizontalSpace,
                              Icon(
                                Icons.star,
                                size: 15,
                                color: AppColors.yellow,
                              ),
                              5.horizontalSpace,
                              SizedBox(
                                width: 120,
                                child: LinearProgressIndicator(
                                  backgroundColor: AppColors.lightGrey,
                                  value: 0,
                                ),
                              ),
                              5.horizontalSpace,
                              Text(
                                '7%',
                                style: AppTextStyle.mediumGrey,
                              ),
                            ],
                          ),
                          3.verticalSpace,
                          Row(
                            children: [
                              Text(
                                '2',
                                style: AppTextStyle.mediumGrey,
                              ),
                              5.horizontalSpace,
                              Icon(
                                Icons.star,
                                size: 15,
                                color: AppColors.yellow,
                              ),
                              5.horizontalSpace,
                              SizedBox(
                                width: 120,
                                child: LinearProgressIndicator(
                                  backgroundColor: AppColors.lightGrey,
                                  value: 0,
                                ),
                              ),
                              5.horizontalSpace,
                              Text(
                                '0%',
                                style: AppTextStyle.mediumGrey,
                              ),
                            ],
                          ),
                          3.verticalSpace,
                          Row(
                            children: [
                              Text(
                                '1',
                                style: AppTextStyle.mediumGrey,
                              ),
                              5.horizontalSpace,
                              Icon(
                                Icons.star,
                                size: 15,
                                color: AppColors.yellow,
                              ),
                              5.horizontalSpace,
                              SizedBox(
                                width: 120,
                                child: LinearProgressIndicator(
                                  backgroundColor: AppColors.lightGrey,
                                  value: 0.1,
                                ),
                              ),
                              5.horizontalSpace,
                              Text(
                                '2%',
                                style: AppTextStyle.mediumGrey,
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: CommentCard(),
              ),
              10.verticalSpace,
              AppDivider(),
              10.verticalSpace,
              RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Produk Serupa',
                      style: AppTextStyle.largeBlackBold,
                    ),
                    Text(
                      'Lihat Semua',
                      style: AppTextStyle.mediumBlackBold,
                    ),
                  ],
                ),
              ),
              10.verticalSpace,
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(14),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: 4,
                itemBuilder: (context, index) => ProductsCard(
                  onTap: (p0) => Get.toNamed(Routes.DETAIL_PRODUCT),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0, -8),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
          ),
          child: BottomAppBar(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.lightGrey),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.message_outlined,
                      size: 20,
                      color: AppColors.black,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Get.toNamed(Routes.CART),
                  child: Container(
                    height: 35.h,
                    width: 148.w,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Beli Langsung',
                        style: AppTextStyle.largeBlackBold.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.addToCart(controller.widgetKey);
                  },
                  child: Container(
                    height: 35.h,
                    width: 148.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primaryColor,
                      ),
                      color: AppColors.primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        '+ Keranjang',
                        style: AppTextStyle.largeWhiteBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // AppBar with search and action icons
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Detail Produk',
        style: AppTextStyle.xxLargeWhiteBold,
      ),
      backgroundColor: AppColors.primaryColor,
      actions: [
        SizedBox(
          height: 22,
          width: 22,
          child: SvgPicture.asset(
            Helper.getSvgPath('ic_share.svg'),
          ),
        ),
        2.horizontalSpace,
        Obx(
          () => AddToCartIcon(
            key: controller.cartKey,
            icon: InkWell(
              onTap: () => Get.toNamed(Routes.CART),
              child: CartBadge(
                iconPath: 'ic_cart.svg',
                count: controller.cartQuantityItems.value,
              ),
            ),
            badgeOptions: const BadgeOptions(
              width: 0,
              height: 0,
              fontSize: 0,
              active: false,
            ),
          ),
        ),
        7.horizontalSpace,
      ],
    );
  }
}

class SizeContainer extends StatelessWidget {
  const SizeContainer({
    super.key,
    required this.label,
    this.onTap,
    required this.isSelected,
  });

  final String label;
  final void Function()? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.lightGrey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: AppTextStyle.mediumBlack.copyWith(
            color: isSelected ? AppColors.primaryColor : AppColors.black,
          ),
        ),
      ),
    );
  }
}
