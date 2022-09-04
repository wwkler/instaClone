import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instaclone/models/post.dart';

class PostRepository {
  // Post Model을 Firebase에 넣는 통신 class
  static Future<void> updatePost(Post postData) async {
    await FirebaseFirestore.instance.collection('posts').add(postData.toMap());
  }

  // Firebase에 있는 Post Json을 가져오는 통신 class
  static Future<List<Post>> loadFeedList() async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .get();

    return data.docs
        .map<Post>(
          (e) => Post.fromJson(e.data()),
        )
        .toList();
  }
}
