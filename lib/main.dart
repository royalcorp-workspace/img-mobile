import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:img/app/core/styles/app_theme.dart';
import 'package:img/app/core/utils/flavor.dart';
import 'package:img/app/core/utils/injections.dart';
import 'package:img/app/core/utils/log/logger.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options_dev.dart' as dev_opts;
import 'firebase_options_prod.dart' as prod_opts;

import 'package:responsive_framework/responsive_framework.dart';

import 'app/routes/app_pages.dart';
import 'app/shared/widgets/debug_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await initializeDateFormatting('id_ID', null);

  initRootLogger();
  logger.info('✅ Logger initialized');

  // Silently handle NetworkImageLoadException (404/network errors) to prevent compiler/debugger pause
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    final String exceptionStr = details.exception.toString();
    final String libraryStr = details.library ?? '';
    final String stackStr = details.stack?.toString() ?? '';

    final bool isNetworkImageError =
        details.exception is NetworkImageLoadException ||
            libraryStr == 'image resource service' ||
            libraryStr == 'painting library' ||
            exceptionStr.contains('NetworkImage') ||
            exceptionStr.contains('NetworkImageLoadException') ||
            exceptionStr.contains('HTTP request failed') ||
            exceptionStr.contains('statusCode: 404') ||
            stackStr.contains('_network_image_io.dart');

    if (isNetworkImageError) {
      logger.warning(
          '⚠️ Network image load failure caught silently: ${details.exception}');
      return;
    }
    originalOnError?.call(details);
  };

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
