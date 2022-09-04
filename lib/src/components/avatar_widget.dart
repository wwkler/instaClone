import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// Avartar 종류를 나타내는 enum 입니다.
enum AvatarType {
  //상단 상대방 StoryBoard 입니다.
  TYPE1,

  // 상단 나의 StroyBoard 입니다.
  TYPE2,

  TYPE3,
}

class AvatarWidget extends StatelessWidget {
  AvatarWidget({
    required this.type,
    required this.thumbPath,
    this.hasStroy,
    this.nickname,
    this.size = 65,
    Key? key,
  }) : super(key: key);

  bool? hasStroy;
  String thumbPath;
  String? nickname;
  AvatarType type;
  double? size;

  // Type1 Widget
  Widget type1Widget() {
    return Container(
      width: size!,
      height: size!,
      margin: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 20.0,
      ),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.purple, Colors.orange],
        ),
        shape: BoxShape.circle,
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size!),
          child: CachedNetworkImage(
            imageUrl: thumbPath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // Type2 Widget
  Widget type2Widget() {
    return Container(
      width: size!,
      height: size!,
      margin: const EdgeInsets.only(
        left: 5.0,
        right: 10.0,
        top: 20.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size!),
        child: CachedNetworkImage(
          imageUrl: thumbPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Type3 Widget 입니다.
  Widget type3Widget() {
    return Row(
      children: [
        type1Widget(),
        Text(
          nickname ?? '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AvatarType.TYPE1:
        return type1Widget();
      case AvatarType.TYPE2:
        return type2Widget();
      case AvatarType.TYPE3:
        return type3Widget();
    }
  }
}
