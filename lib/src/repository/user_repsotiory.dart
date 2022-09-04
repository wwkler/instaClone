import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaclone/models/instagram_user.dart';

// FireStore Database와 연동하는 class
class UserRepository {
  // Firebase Database에서 uid를 확인하는 Method
  static Future<IUser?> loginUserById(String uid) async {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();

    // FireStore DataBase에 있는 json 데이터를 Model 데이터로 변환하는 부분
    if (data.size == 0) {
      return null;
    } else {
      return IUser.fromJson(data.docs.first.data());
    }
  }

  // 회원 가입을 위해 Firebase Database에 회원 정보를 넣는 Method 입니다.
  static Future<bool> signup(IUser user) async {
    try {
      await FirebaseFirestore.instance.collection('users').add(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
}
