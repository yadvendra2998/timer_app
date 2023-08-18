import 'package:get/get.dart';
import 'package:timer_app/controller/theme_controller.dart';

class MyBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ThemeController());
  }
}
