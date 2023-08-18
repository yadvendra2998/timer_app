import 'package:flutter/material.dart';
import 'package:timer_app/bindings.dart';
import 'package:timer_app/utils/themes.dart';
import 'package:timer_app/view/final_view.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: MyBindings(),
      debugShowCheckedModeBanner: false,
      title: 'Timer',
      darkTheme: MyThemes.darkTheme,
      themeMode: ThemeMode.light,
      theme: MyThemes.lightTheme,
      home: const FinalView(),
    );
  }
}
