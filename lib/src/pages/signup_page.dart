import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/models/instagram_user.dart';
import 'package:instaclone/src/controller/auth_controler.dart';

// 회원가입 Page
class SignupPage extends StatefulWidget {
  const SignupPage({
    Key? key,
    required this.uid,
  }) : super(key: key);

  // uid
  final String uid;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nicknameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? thumbnailXFile;

  // setState 하는 method
  void update() => setState(() {});

  // 아바타
  Widget _avatar() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: SizedBox(
            width: 100,
            height: 100,
            child: thumbnailXFile != null
                ? Image.file(
                    File(thumbnailXFile!.path),
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/default_image.png',
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        const SizedBox(height: 15.0),
        ElevatedButton(
          onPressed: () async {
            thumbnailXFile = await _picker.pickImage(
              source: ImageSource.gallery,
              imageQuality: 10,
            );
            update();
          },
          child: const Text('이미지 변경'),
        ),
      ],
    );
  }

  // 닉네임
  Widget _nickname() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: TextField(
        controller: nicknameController,
        decoration: const InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          hintText: '닉네임',
        ),
      ),
    );
  }

  // 설명
  Widget _description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: TextField(
        controller: descriptionController,
        decoration: const InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          hintText: '설명',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '회원가입',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            _avatar(),
            const SizedBox(height: 30),
            _nickname(),
            const SizedBox(height: 30),
            _description(),
          ],
        ),
      ),
      // 회원가입 버튼 입니다.
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        child: ElevatedButton(
          onPressed: () {
            // Instance를 만들어요...
            IUser signupUser = IUser(
              uid: widget.uid,
              nickname: nicknameController.text,
              description: descriptionController.text,
              // 자동으로 thumbnail은 null이 된다.
            );

            AuthController.to.signup(signupUser, thumbnailXFile);
          },
          child: const Text('회원가입'),
        ),
      ),
    );
  }
}
