import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/models/instagram_user.dart';
import 'package:instaclone/src/binding/init_bindings.dart';
import 'package:instaclone/src/repository/user_repsotiory.dart';

class AuthController extends GetxController {
  // AuthController에 쉽게 접근할 수 있도록 하는 method
  static AuthController get to => Get.find();

  // 반응형으로 관리되는 User Information
  Rx<IUser> user = IUser().obs;

  // Firebase Database의 uid가 있는지 확인하기 위한 전초 method 입니다.
  Future<IUser?> loginUser(String uid) async {
    IUser? userData = await UserRepository.loginUserById(uid);

    if (userData != null) {
      // Rx 상태 관리 변수의 값이 수정된다.(update 쓸 필요 없다.)
      user(userData);

      // MyPageController 등록
      InitBinding.additionalBinding();
    } else {
      return userData;
    }
  }

  // 회원가입을 위한 전초 1단계 method 입니다.
  Future<void> signup(IUser signupUser, XFile? thumbnail) async {
    // 이미지가 없는 경우면 그냥 갑니다.
    if (thumbnail == null) {
      _submitSignup(signupUser);
    }

    // 이미지가 있으면 이미지 처리까지 합니다.
    UploadTask task = upLoadXFile(
      thumbnail!,
      '${signupUser.uid}/profile.${thumbnail.path.split('.').last}',
    );
    task.snapshotEvents.listen(
      (event) async {
        print(event.bytesTransferred);
        if (event.bytesTransferred == event.totalBytes &&
            event.state == TaskState.success) {
          String downloadUrl = await event.ref.getDownloadURL();

          IUser updatedUserData = signupUser.copyWith(thumbnail: downloadUrl);
          _submitSignup(updatedUserData);
        }
      },
    );
  }

  // 이미지 경로를 설정하고 데이터를 넣는 method 입니다.
  UploadTask upLoadXFile(XFile file, String fileName) {
    File f = File(file.path);
    Reference ref =
        FirebaseStorage.instance.ref().child('users').child(fileName);
    SettableMetadata metaData = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );
    return ref.putFile(f, metaData);
  }

  // 회원가입을 위한 전초 2단계 method 입니다.
  Future<void> _submitSignup(IUser signupUser) async {
    bool result = await UserRepository.signup(signupUser);

    // 반응형 상태변수 update
    if (result) {
      loginUser(signupUser.uid!);
    }
  }
}
