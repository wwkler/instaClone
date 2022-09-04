import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclone/src/components/image_data.dart';
import 'package:instaclone/src/controller/upload_controller.dart';
import 'package:photo_manager/photo_manager.dart';

// GetX 개념을 적용한 코드
class Upload extends GetView<UploadController> {
  Upload({Key? key}) : super(key: key);

  // ImagePreview 입니다.
  Widget _imagePreview() {
    var width = Get.width;

    return Obx(
      () => Container(
        width: width,
        height: width,
        color: Colors.grey,
        child: _photoWidget(
          controller.selectedImage.value,
          width.toInt(),
          builder: (data) {
            return Image.memory(
              data,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  // Header 부분 입니다.
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 갤러리 부분
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: Get.context!,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                isScrollControlled:
                    controller.albums.length > 10 ? true : false,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(Get.context!).size.height -
                      MediaQuery.of(Get.context!).padding.top,
                ),
                builder: (_) => Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          margin: const EdgeInsets.only(top: 7),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black54),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: List.generate(
                              controller.albums.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  controller
                                      .changeAlbum(controller.albums[index]);
                                  Get.back();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  child: Text(controller.albums[index].name),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Obx(
                    () => Text(controller.headerTitle.value,
                        style: TextStyle(color: Colors.black, fontSize: 18.0)),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),

          Row(
            children: [
              // 여러 항목 선택 부분
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF808080),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    ImageData(IconsPath.imageSelectIcon),
                    const SizedBox(width: 7),
                    const Text(
                      '여러 항목 선택',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10.0),

              // 카메라 부분
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: const Color(0xFF808080)),
                child: ImageData(IconsPath.cameraIcon),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Image을 보여주기 위해 GridView를 설정한다.
  Widget _imageSelectList() {
    return Obx(
      () => GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          childAspectRatio: 1,
        ),
        itemCount: controller.imageList.length,
        itemBuilder: (context, index) {
          return _photoWidget(
            controller.imageList[index],
            200,
            builder: (data) {
              return GestureDetector(
                onTap: () {
                  controller.changeSelectedImage(controller.imageList[index]);
                },
                child: Obx(
                  () => Opacity(
                    opacity: controller.imageList[index] ==
                            controller.selectedImage.value
                        ? 0.3
                        : 1,
                    child: Image.memory(
                      data,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Image를 보여주는 method
  Widget _photoWidget(AssetEntity asset, int size,
      {required Widget Function(Uint8List) builder}) {
    return FutureBuilder(
      future: asset.thumbnailDataWithSize(
        ThumbnailSize(size, size),
      ),
      builder: (_, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.hasData) {
          return builder(snapshot.data!);
        } else
          return Container(
            color: Colors.grey,
          );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: Get.back,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ImageData(IconsPath.closeImage),
          ),
        ),
        title: Text(
          'New Post',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: controller.gotoImageFilter,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ImageData(
                IconsPath.nextImage,
                width: 70,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _imagePreview(),
            _header(),
            const SizedBox(height: 5.0),
            _imageSelectList(),
          ],
        ),
      ),
    );
  }
}



// 본 원래 코드
// class Upload extends StatefulWidget {
//   const Upload({Key? key}) : super(key: key);

//   @override
//   State<Upload> createState() => _UploadState();
// }

// class _UploadState extends State<Upload> {
//   List<AssetPathEntity> albums = [];
//   var headerTitle = '';
//   List<AssetEntity> imageList = [];
//   AssetEntity? selectedImage;

//   @override
//   void initState() {
//     super.initState();

//     // async method
//     _loadPhotos();
//   }

//   // PhotoManager Package를 이용해 image를 가져오는 method
//   void _loadPhotos() async {
//     PermissionState result = await PhotoManager.requestPermissionExtend();

//     if (result.isAuth) {
//       albums = await PhotoManager.getAssetPathList(
//         type: RequestType.image,
//         filterOption: FilterOptionGroup(
//           imageOption: const FilterOption(
//             sizeConstraint: SizeConstraint(minHeight: 100, minWidth: 100),
//           ),
//           orders: [
//             const OrderOption(type: OrderOptionType.createDate, asc: false),
//           ],
//         ),
//       );

//       // async method
//       _loadData();
//     } else {}
//   }

//   // 그냥 중간다리 역할 하는 method
//   void _loadData() async {
//     headerTitle = albums.first.name;

//     await _pagingPhotos();

//     _update();
//   }

//   // Image들을 가져와 배열에 저장하는 method
//   Future<void> _pagingPhotos() async {
//     List<AssetEntity> photos =
//         await albums.first.getAssetListPaged(page: 0, size: 30);
//     imageList.addAll(photos);

//     selectedImage = imageList.first;
//   }

//   // build()를 부르는 method
//   void _update() {
//     setState(() {});
//   }

//   // ImagePreview 입니다.
//   Widget _imagePreview() {
//     var width = MediaQuery.of(context).size.width;

//     return Container(
//       width: width,
//       height: width,
//       color: Colors.grey,
//       child: selectedImage == null
//           ? Container()
//           : _photoWidget(
//               selectedImage!,
//               width.toInt(),
//               builder: (data) {
//                 return Image.memory(
//                   data,
//                   fit: BoxFit.cover,
//                 );
//               },
//             ),
//     );
//   }

//   // Header 부분 입니다.
//   Widget _header() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // 갤러리 부분
//           GestureDetector(
//             onTap: () {
//               showModalBottomSheet(
//                 context: context,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 isScrollControlled: albums.length > 10 ? true : false,
//                 constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height -
//                       MediaQuery.of(context).padding.top,
//                 ),
//                 builder: (_) => Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Center(
//                         child: Container(
//                           width: 40,
//                           height: 5,
//                           margin: const EdgeInsets.only(top: 7),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.black54),
//                         ),
//                       ),
//                       Expanded(
//                         child: SingleChildScrollView(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: List.generate(
//                               albums.length,
//                               (index) => Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 20,
//                                   vertical: 15,
//                                 ),
//                                 child: Text('albums[index].name'),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: Row(
//                 children: [
//                   Text(headerTitle,
//                       style: TextStyle(color: Colors.black, fontSize: 18.0)),
//                   Icon(Icons.arrow_drop_down),
//                 ],
//               ),
//             ),
//           ),

//           Row(
//             children: [
//               // 여러 항목 선택 부분
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF808080),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Row(
//                   children: [
//                     ImageData(IconsPath.imageSelectIcon),
//                     const SizedBox(width: 7),
//                     const Text(
//                       '여러 항목 선택',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14.0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 10.0),

//               // 카메라 부분
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                     shape: BoxShape.circle, color: const Color(0xFF808080)),
//                 child: ImageData(IconsPath.cameraIcon),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // Image을 보여주기 위해 GridView를 설정한다.
//   Widget _imageSelectList() {
//     return GridView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 4,
//         mainAxisSpacing: 1,
//         crossAxisSpacing: 1,
//         childAspectRatio: 1,
//       ),
//       itemCount: imageList.length,
//       itemBuilder: (context, index) {
//         return _photoWidget(
//           imageList[index],
//           200,
//           builder: (data) {
//             return GestureDetector(
//               onTap: () {
//                 selectedImage = imageList[index];
//                 _update();
//               },
//               child: Opacity(
//                 opacity: imageList[index] == selectedImage ? 0.3 : 1,
//                 child: Image.memory(
//                   data,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // Image를 보여주는 method
//   Widget _photoWidget(AssetEntity asset, int size,
//       {required Widget Function(Uint8List) builder}) {
//     return FutureBuilder(
//       future: asset.thumbnailDataWithSize(
//         ThumbnailSize(size, size),
//       ),
//       builder: (_, AsyncSnapshot<Uint8List?> snapshot) {
//         if (snapshot.hasData) {
//           return builder(snapshot.data!);
//         } else
//           return Container(
//             color: Colors.red,
//           );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: GestureDetector(
//           onTap: Get.back,
//           child: Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: ImageData(IconsPath.closeImage),
//           ),
//         ),
//         title: Text(
//           'New Post',
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Colors.black,
//           ),
//         ),
//         actions: [
//           GestureDetector(
//             onTap: () {},
//             child: Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: ImageData(
//                 IconsPath.nextImage,
//                 width: 70,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _imagePreview(),
//             _header(),
//             const SizedBox(height: 5.0),
//             _imageSelectList(),
//           ],
//         ),
//       ),
//     );
//   }
// }