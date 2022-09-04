import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclone/src/components/message_popup.dart';
import 'package:instaclone/src/controller/upload_controller.dart';
import 'package:instaclone/src/pages/upload.dart';

enum PageName {
  HOME,
  SEARCH,
  UPLOAD,
  ACTIVITY,
  MYPAGE,
}

// Reactive Controller
class BottomNavController extends GetxController {
  // Tab Index를 관리하는 상태 변수
  RxInt pageIndex = 0.obs;

  // Tab 한 것을 기록하는 상태 변수
  List<int> bottomHistory = [0];

  // Navgation Key 입니다.
  GlobalKey<NavigatorState> searchPageNavigationKey =
      GlobalKey<NavigatorState>();

  // Get.find()를 더 쉽게 사용할 수 있도록 하는 get 함수
  static BottomNavController get to => Get.find();

  void changeBottomNav(int value) {
    var page = PageName.values[value];

    switch (page) {
      case PageName.HOME:
        _change(value);
        break;
      case PageName.SEARCH:
        _change(value);
        break;
      
      // BottomNavigationBar에서 Upload쪽을 계속 클릭하면 새로운 Upload Page가 생겨난다.
      // 왜냐하면 Upload page로 Route하기 떄문이다. 그래서 계속 onInit()이 호출된다.
      case PageName.UPLOAD:
        Get.to(
          () => Upload(),
          
          binding: BindingsBuilder(() {
            Get.put(UploadController());
          }),
        );
        break;
      case PageName.ACTIVITY:
        _change(value);
        break;
      case PageName.MYPAGE:
        _change(value);
        break;
    }
  }

  void _change(int value) {
    // 1번쨰, 2번쨰 오류 개선
    if (bottomHistory.last == value) {
      print('해당 TabBar를 다시 그립니다.');
      pageIndex(value);
      return;
    }

    bottomHistory.add(value);
    print('bottomHistory : ${bottomHistory}');
    pageIndex(value);
  }

  Future<bool> willPopAction() async {
    if (bottomHistory.length == 1) {
      // Dialogue 표시
      showDialog(
        context: Get.context!,
        builder: (context) => MessagePopup(
          cancelCallback: () {
            Get.back();
          },
          okCallback: () {
            exit(0);
          },
          message: '화면을 종료하시겠습니까?',
          title: '맨 처음 화면 입니다.',
        ),
      );
      return true;
    } else {
      // Search 화면에서 쌓인 부분을 처리하기 라우팅하기 위한 코드
      var page = PageName.values[bottomHistory.last];
      if (page == PageName.SEARCH) {
        var value = await searchPageNavigationKey.currentState!.maybePop();
        if (value) return false;
      }

      bottomHistory.removeLast();
      print('bottomHistory : ${bottomHistory}');

      changeBottomNav(bottomHistory.last);

      return false;
    }
  }
}
