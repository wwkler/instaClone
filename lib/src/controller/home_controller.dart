import 'package:get/get.dart';
import 'package:instaclone/models/post.dart';
import 'package:instaclone/src/repository/post_repository.dart';


class HomeController extends GetxController {
  // Rx 상태 관리 변수
  RxList<Post> postList = <Post>[].obs;

  @override
  void onInit() {
    super.onInit();

    loadFeedList();
  }

  // Firebase Posts에 있는 데이터를 가져오는 method
  Future<void> loadFeedList() async {
    postList.clear();

    List<Post> feedList = await PostRepository.loadFeedList();

    // 상태 관리 변수 업데이트 (Update 칠 필요 없음)
    postList.addAll(feedList);
  }
}
