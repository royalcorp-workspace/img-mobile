import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/styles/app_theme.dart';
import 'package:pos_royal/app/core/utils/flavor.dart';
import 'package:pos_royal/app/core/utils/injections.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options_dev.dart' as dev_opts;
import 'firebase_options_prod.dart' as prod_opts;

import 'package:responsive_framework/responsive_framework.dart';

import 'app/routes/app_pages.dart';
import 'app/shared/widgets/debug_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initRootLogger();

  final FirebaseOptions options = switch (AppFlavor.current) {
    Flavor.production => prod_opts.DefaultFirebaseOptions.currentPlatform,
    Flavor.development => dev_opts.DefaultFirebaseOptions.currentPlatform,
  };

  await Firebase.initializeApp(options: options);



  // Initialize dependencies
  await initInjections();

  runApp(
    ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          title: "IMG",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          theme: appTheme,
          builder: (context, widget) {
            final flavor = AppFlavor.current;
            final showBanner = flavor != Flavor.production;

            Widget child = showBanner
                ? Banner(
                    message: 'DEV',
                    location: BannerLocation.topStart,
                    child: DebugWidget(widget: widget!),
                  )
                : Stack(
                    children: [widget!],
                  );

            return ResponsiveBreakpoints.builder(
              child: MaxWidthBox(
                maxWidth: 1200,
                child: child,
              ),
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ],
            );
          },
        );
      },
    ),
  );
}
