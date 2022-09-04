import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:instaclone/models/instagram_user.dart';
import 'package:instaclone/src/pages/app.dart';
import 'package:instaclone/src/controller/auth_controler.dart';
import 'package:instaclone/src/pages/Login.dart';
import 'package:instaclone/src/pages/signup_page.dart';

class Root extends GetView<AuthController> {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext _, AsyncSnapshot<User?> user) {
        if (user.hasData) {
          return FutureBuilder<IUser?>(
            future: controller.loginUser(user.data!.uid),
            builder: (context, snapshot) {
              // Firebase에 데이터가 남아있어 로고인 처리 
              if (snapshot.hasData) {
                return const App();
              } 
              
              // 회원가입 후 로고인 처리 
              else {
                return Obx(
                  () => controller.user.value.uid != null
                      ? const App()
                      : SignupPage(uid: user.data!.uid),
                );
              }
            },
          );
        } else {
          return const Login();
        }
      },
    );
  }
}
