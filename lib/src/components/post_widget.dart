import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/post.dart';
import 'package:instaclone/src/components/avatar_widget.dart';
import 'package:instaclone/src/components/image_data.dart';
import 'package:timeago/timeago.dart' as timeago;


// Post Page를 관리하는 Widget 입니다.
class PostWidget extends StatelessWidget {
  const PostWidget({
    required this.post,
    Key? key,
  }) : super(key: key);

  final Post post;

  // Post Page - 상단 부분
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AvatarWidget(
            type: AvatarType.TYPE3,
            nickname: post.userInfo!.nickname,
            size: 40,
            thumbPath: post.userInfo!.thumbnail!,
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ImageData(
                IconsPath.postMoreIcon,
                width: 30,
              ),
            ),
          )
        ],
      ),
    );
  }

  // Post Page - image
  Widget _image() {
    return CachedNetworkImage(
      imageUrl: post.thumbnail!,
    );
  }

  // Post Page - 좋아요, 쪽지, 북마크 icon
  Widget _infoCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ImageData(
                IconsPath.likeOffIcon,
                width: 65,
              ),
              const SizedBox(width: 15.0),
              ImageData(
                IconsPath.replyIcon,
                width: 60,
              ),
              const SizedBox(width: 15.0),
              ImageData(
                IconsPath.directMessage,
                width: 55,
              ),
            ],
          ),
          ImageData(
            IconsPath.bookMarkOffIcon,
            width: 50,
          ),
        ],
      ),
    );
  }

  // 좋아요와 글 텍스트 나타내기
  Widget _infoDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '좋아요 1개',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          ExpandableText(
            post.description ?? '',
            expandText: '더보기',
            collapseText: '접기',
            prefixText: post.userInfo!.nickname,
            onPrefixTap: () {
              print('페이지 이동');
            },
            prefixStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 3,
            expandOnTextTap: true,
            collapseOnTextTap: true,
            linkColor: Colors.pink,
          ),
        ],
      ),
    );
  }

  // 댓글 갯수 확인
  Widget _replyTextBtn() {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Text(
          '댓글 200개 모두 보기',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  // 몇일전인지 나타내는
  Widget _dateAgo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
        timeago.format(post.createdAt!),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(),
          const SizedBox(
            height: 15.0,
          ),
          _image(),
          const SizedBox(
            height: 15.0,
          ),
          _infoCount(),
          const SizedBox(
            height: 15.0,
          ),
          _infoDescription(),
          const SizedBox(
            height: 15.0,
          ),
          _replyTextBtn(),
          _dateAgo(),
        ],
      ),
    );
  }
}
