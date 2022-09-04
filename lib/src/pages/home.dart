import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:instaclone/src/components/avatar_widget.dart';
import 'package:instaclone/src/components/image_data.dart';
import 'package:instaclone/src/components/post_widget.dart';
import 'package:instaclone/src/controller/home_controller.dart';

// Instagram 홈 화면 입니다.
class Home extends GetView<HomeController> {
  const Home({Key? key}) : super(key: key);

  // My StroyBoard 입니다.
  Widget _myStroy() {
    return Stack(
      children: [
        AvatarWidget(
          type: AvatarType.TYPE2,
          thumbPath:
              'https://mediahub.seoul.go.kr/wp-content/uploads/2015/02/ec8056cf7e38460f6269f97c67163269.jpg',
        ),
        Positioned(
          right: 10,
          bottom: 0,
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Center(
              child: Text(
                '+',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  height: 1.1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 상단 StoryBoard 화면 입니다.
  Widget _storyBoardList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: PageScrollPhysics(),
      child: Row(
        children: [
          const SizedBox(
            width: 20.0,
          ),
          // My StroyBoard
          _myStroy(),

          // 상대방 StroyBoard
          ...List.generate(
            100,
            (index) => AvatarWidget(
              type: AvatarType.TYPE1,
              thumbPath:
                  'https://ichef.bbci.co.uk/news/640/cpsprodpb/4118/production/_119546661_gettyimages-1294130887.jpg',
            ),
          ),
        ],
      ),
    );
  }

  // PostList 입니다.
  Widget _postList() {
    return Obx(
      () => Column(
        children: List.generate(
          controller.postList.length,
          (index) => PostWidget(post: controller.postList[index]),
        ).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Home Build');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: ImageData(
          IconsPath.logo,
          width: 350,
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ImageData(
                IconsPath.directMessage,
                width: 60,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          // Story Board를 관리합니다.
          _storyBoardList(),

          const SizedBox(
            height: 30.0,
          ),

          // PostList를 관리합니다.
          _postList(),
        ],
      ),
    );
  }
}
