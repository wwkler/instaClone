import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagePopup extends StatelessWidget {
  const MessagePopup({
    required this.title,
    required this.message,
    required this.okCallback,
    required this.cancelCallback,
    Key? key,
  }) : super(key: key);

  final String? title;
  final String? message;
  final Function()? okCallback;
  final Function()? cancelCallback;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: Container(
              color: Colors.white,
              width: Get.width * 0.7,
              padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
              child: Column(
                children: [
                  Text(
                    title!,
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    message!,
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: okCallback,
                        child: Text('종료'),
                      ),
                      const SizedBox(
                        width: 30.0,
                      ),
                      OutlinedButton(
                        onPressed: cancelCallback,
                        child: Text('취소'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
