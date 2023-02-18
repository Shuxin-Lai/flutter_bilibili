import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bilibili/layouts/back_layout.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackLayout(
        title: 'Message Page',
        child: Container(
          child: Text('message'),
        ));
  }
}
