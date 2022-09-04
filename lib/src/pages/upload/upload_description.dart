import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclone/src/components/image_data.dart';
import 'package:instaclone/src/controller/upload_controller.dart';

// 새 게시물에 대한 Widget
class UploadDescription extends GetView<UploadController> {
  const UploadDescription({Key? key}) : super(key: key);

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Image.file(
              controller.filteredImage!,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller.textEditingController,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 10),
                hintText: '문구 입력....',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoOne(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }

  Widget get line => const Divider(color: Colors.grey);

  Widget _snsInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Facebook', style: const TextStyle(fontSize: 17)),
              Switch(
                value: false,
                onChanged: (bool value) {},
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Twitter', style: const TextStyle(fontSize: 17)),
              Switch(
                value: false,
                onChanged: (bool value) {},
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Thumblr', style: const TextStyle(fontSize: 17)),
              Switch(
                value: false,
                onChanged: (bool value) {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: Get.back,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ImageData(IconsPath.backBtnIcon, width: 50),
          ),
        ),
        title: const Text('새 게시물',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          GestureDetector(
            onTap: controller.uploadPost,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ImageData(IconsPath.uploadComplete, width: 50),
            ),
          )
        ],
      ),
      body: GestureDetector(
        // Keyboard Down
        onTap: controller.unfocusKeyboard,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _description(),
              line,
              _infoOne('사람 태그하기'),
              line,
              _infoOne('위치 추가'),
              line,
              _infoOne('다른 미디어에도 게시'),
              _snsInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
