import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/models/post.dart';
import 'package:instaclone/src/components/message_popup.dart';
import 'package:instaclone/src/controller/auth_controler.dart';
import 'package:instaclone/src/controller/home_controller.dart';
import 'package:instaclone/src/pages/upload/upload_description.dart';
import 'package:instaclone/src/repository/post_repository.dart';
import 'package:instaclone/src/utils/data_util.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;

// BottomNavigationBar에 Upload 쪽을 누르면 Routing으로 Upload Page로 전환된다.
// 그에 따라 UploadController도 등록되는 경우가 무수히 많다.
// 즉 onInit()이 불리는 경우가 많다는 것이다.
// 앨범 페이지를 보여주기 위한 사전 설정, Post Model를 생성하는 작업이 빈번하게 발생한다.

class UploadController extends GetxController {
  // 여러 앨범을 담고 있는 List
  List<AssetPathEntity> albums = [];

  // 필터링된 image
  File? filteredImage;

  // Text Editing Controller
  TextEditingController textEditingController = TextEditingController();

  // Post Model
  Post? post;

  // //  Rx 반응형 상태 변수

  // 앨범 제목
  RxString headerTitle = ''.obs;

  // 앨범에 있는 여러 image
  RxList<AssetEntity> imageList = <AssetEntity>[].obs;

  // 선택한 이미지
  Rx<AssetEntity> selectedImage = AssetEntity(
    id: '0',
    typeInt: 0,
    width: 0,
    height: 0,
  ).obs;

  // UploadController가 등록되면 맨 처음 호출되는 onInit method
  @override
  void onInit() {
    super.onInit();
    print('uploadController - onInit()이 호출되었습니다.');

    // 이미 만들어진 User Model을 바탕으로 일단 Post Model을 만들어놓는다.
    post = Post.init(AuthController.to.user.value);


    // 앨범 제목을 보여주기 위한 설정 준비
    // 앨범에 있는 default 사진을 보여주기 위한 설정 준비
    // 앨범에 있는 여러 이미지를 GridView로 보여주기 위한 설정 준비
    _loadPhotos();
  }

  // PhotoManager Package를 이용해 image를 가져오는 method
  void _loadPhotos() async {
    PermissionState result = await PhotoManager.requestPermissionExtend();

    if (result.isAuth) {
      albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          imageOption: const FilterOption(
            sizeConstraint: SizeConstraint(minHeight: 100, minWidth: 100),
          ),
          orders: [
            const OrderOption(type: OrderOptionType.createDate, asc: false),
          ],
        ),
      );

      // async method
      _loadData();
    } else {}
  }

  // 그냥 중간다리 역할 하는 method
  void _loadData() async {
    changeAlbum(albums.first);
  }

  // 앨범을 바꾸는 method -> 앨범을 바꾸면 그 안에 있는 여러 image를 가져온다.
  Future<void> changeAlbum(AssetPathEntity album) async {
    headerTitle(album.name);
    await _pagingPhotos(album);
  }

  // 앨범에 있는 여러 image를 담는 List에 넣는 method
  Future<void> _pagingPhotos(AssetPathEntity album) async {
    imageList.clear();

    List<AssetEntity> photos = await album.getAssetListPaged(page: 0, size: 30);
    imageList.addAll(photos);

    changeSelectedImage(imageList.first);
  }

  // 선택한 사진을 selectedImage에 저장하는 method
  void changeSelectedImage(AssetEntity image) {
    // 반응형 상태 변수 데이터 수정 (upadate 안해도 자동으로 설정됨)
    selectedImage(image);
  }

  // 선택한 사진에 대해서 Filter를 씌우는 method
  void gotoImageFilter() async {
    File? file = await selectedImage.value.file;
    String fileName = basename(file!.path);
    var image = imageLib.decodeImage(file.readAsBytesSync());
    image = imageLib.copyResize(image!, width: 600);

    Map imagefile = await Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => PhotoFilterSelector(
          title: const Text("Photo Filter Example"),
          image: image!,
          filters: presetFiltersList,
          filename: fileName,
          loader: const Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        ),
      ),
    );

    // 이미지가 필터링 됐으면 페이지 전환을 한다.
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      filteredImage = imagefile['image_filtered'];
      Get.to(() => UploadDescription());
    }
  }

  // 키보드 unfocus
  void unfocusKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // 게시물 업로드 하는 일련의 method 입니다.
  void uploadPost() {
    unfocusKeyboard();
    String filename = DataUtil.makeFilePath();
    UploadTask task = upLoadFile(
      filteredImage!,
      '${AuthController.to.user.value.uid}/${filename}',
    );

    if (task != null) {
      task.snapshotEvents.listen((event) async {
        if (event.bytesTransferred == event.totalBytes &&
            event.state == TaskState.success) {
          String downloadUrl = await event.ref.getDownloadURL();

          // 새 게시물에 대한 thumbnail과 description을 추가하여 Post Model을 clone 한다.
          Post updatedPost = post!.copyWith(
            thumbnail: downloadUrl,
            description: textEditingController.text,
          );

          _submitPost(updatedPost);
        }
      });
    }
  }

  // 이미지를 Firebase Storage에 추가하는 method 입니다.
  UploadTask upLoadFile(File file, String fileName) {
    Reference ref =
        FirebaseStorage.instance.ref().child('instagram').child(fileName);
    SettableMetadata metaData = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );
    return ref.putFile(file, metaData);
  }

  // Firebase에 Post Model을 업로드 하기 위한 전초 method 입니다.
  Future<void> _submitPost(Post postData) async {
    // 새 게시물을 Firebase에 저장한다.
    await PostRepository.updatePost(postData);

    // 새 게시물 포스팅이 완료됨을 알리는 Dialogue
    showDialog(
      context: Get.context!,
      builder: (context) => MessagePopup(
        title: '포스트',
        message: '포스팅이 완료되었습니다.',

        // 원하는 특정 페이지로 이동(여기서는 /)
        okCallback: () async {
          // HomeController에 있는 loadFeedList method를 불러서 상태 관리 변수를 Update 한다.
          await Get.find<HomeController>().loadFeedList();

          // Upload Routing 되기 전 page로 다시 이동된다. 
          Get.until((route) => Get.currentRoute == '/');
        },
        cancelCallback: () {},
      ),
    );
  }
}
