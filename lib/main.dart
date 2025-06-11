import 'package:flight_booking/controller/theme_controller.dart';
import 'package:flight_booking/routes/app_routes.dart';
import 'package:flight_booking/theme/theme.dart';
import 'package:flight_booking/view/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(YellowJetApp());
}

class YellowJetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'YellowJet AI Travel',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: SplashScreen(),
          getPages: AppRoutes.routes,
          initialBinding: BindingsBuilder(() {
            Get.put(ThemeController());
          }),
        );
      },
    );
  }
}