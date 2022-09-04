import 'package:get/get.dart';
import 'package:instaclone/src/controller/auth_controler.dart';
import 'package:instaclone/src/controller/bottom_nav_controller.dart';
import 'package:instaclone/src/controller/home_controller.dart';
import 'package:instaclone/src/controller/mypage_controller.dart';

//  Data Instance에 접근할 수 있도록 도와주는 class
class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BottomNavController(), permanent: true);
    Get.put(AuthController(), permanent: true);
  }

  // 최종 로고인이 인증되면 MyPageController와 HomeController가 등록된다.
  static additionalBinding() {
    Get.put(MyPageController(), permanent: true);
    Get.put(HomeController(), permanent: true);
  }
}
