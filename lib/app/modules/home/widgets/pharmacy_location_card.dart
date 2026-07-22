// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pos_royal/app/core/helper/helper.dart';
// import 'package:pos_royal/app/core/styles/app_color.dart';
// import 'package:pos_royal/app/core/styles/app_text_style.dart';

// class PharmacyLocationCard extends StatelessWidget {
//   const PharmacyLocationCard({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(20),
//       onTap: () {},
//       child: Container(
//         width: 150.w,
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: AppColors.lightGrey),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.lightGrey.withOpacity(0.3),
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 108.h,
//               decoration: BoxDecoration(
//                 color: AppColors.white12,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//                 image: DecorationImage(
//                   image: AssetImage(
//                     Helper.getImagePath('img_location.png'),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             const RPadding(
//               padding: EdgeInsets.symmetric(horizontal: 8),
//               child: Text(
//                 'Apotek Roxy Koja',
//                 style: AppTextStyle.largeBlackBold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const RPadding(
//               padding: EdgeInsets.symmetric(horizontal: 8),
//               child: Text(
//                 'Jl. Maja, RT.2/RW.11 Lagoa, Koja, Jakarta Utara, Jakarta',
//                 style: AppTextStyle.smallGrey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
