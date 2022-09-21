import  'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key,required this.body});
  final String body;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(body),
    );
  }
}