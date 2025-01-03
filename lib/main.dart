import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop_record/constants/colors.dart';
import 'package:shop_record/providers/category_provider.dart';
import 'package:shop_record/providers/inventory_provider.dart';
import 'package:shop_record/providers/sales_provider.dart';
import 'package:shop_record/providers/shop_record_provider.dart';
import 'package:shop_record/screens/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryProvider>(
            create: (context) => CategoryProvider()),
        ChangeNotifierProvider<ShopRecordProvider>(
            create: (context) => ShopRecordProvider()),
        ChangeNotifierProvider<InventoryProvider>(
            create: (context) => InventoryProvider()),
        ChangeNotifierProvider<SalesProvider>(
            create: (context) => SalesProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop Record',
        theme: ThemeData(
            primarySwatch: pkColor,
            appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true)),
        home: const OnboardingScreen(),
      ),
    );
  }
}
