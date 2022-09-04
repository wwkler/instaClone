import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclone/models/instagram_user.dart';
import 'package:instaclone/src/controller/auth_controler.dart';

// MyPageController는 AuthController에 있는 User 정보를 가져와서 
// 여기로 정착시키기 위해 필요한 MyPageController이다.
class MyPageController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;

  // 반응형으로 관리하는 User Information
  Rx<IUser> targetUser = IUser().obs;

  // MyPageController가 등록될 떄 처음 호출되는 method 
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() {
    setTargetUser();
  }

  void setTargetUser() {
    String? uid = Get.parameters['targetUid'];
    if (uid == null) {
      // 반응형 상태 변수 데이터 수정 (update 쓰지 않고 자동으로 반영)
      targetUser(AuthController.to.user.value);
    }
    else {}
  }
}
