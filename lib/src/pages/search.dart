import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:instaclone/src/pages/search/search_focus.dart';
import 'package:quiver/iterables.dart';

// 검색 창 화면 입니다.
class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // 모든 데이터를 표현하는 공간에 사이즈를 정하는 배열
  List<List<int>> sizes = [[], [], []];

  // outterIndex에 따른 총 사이즈 크기를 저장하는 배열
  List<int> sizesSumValue = [0, 0, 0];

  // 모든 데이터를 포함하는 공간에 사이즈를 배치한다.
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 100; i++) {
      int size = 1;
      int sizesMinIndex = sizesSumValue.indexOf(
        min<int>(sizesSumValue)!,
      );

      if (sizesMinIndex != 1) {
        size = Random().nextInt(100) % 2 == 0 ? 1 : 2;
      }

      sizes[sizesMinIndex].add(size);
      sizesSumValue[sizesMinIndex] += size;
    }

    print(sizes);
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('search - didUpdateWidget() 호출');
  }

  // 검색 창 화면의 AppBar 입니다.
  Widget _appBar() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => SearchFocus()),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              margin: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFFefefef),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const SizedBox(width: 5.0),
                  Text(
                    '검색',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFF838383),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Icon(Icons.location_pin),
        ),
      ],
    );
  }

  // 검색 창 화면의 Body 입니다.
  Widget _body() {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          sizes.length,
          (index) => Column(
            children: List.generate(
              sizes[index].length,
              (innerIndex) => Container(
                width: 130,
                height: Get.width * 0.33 * sizes[index][innerIndex],
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 검색 창 화면의 appbar 입니다.
            _appBar(),

            const SizedBox(height: 30.0),

            // 여러 사진을 보여준다.
            Expanded(
              child: _body(),
            ),
          ],
        ),
      ),
    );
  }
}
