import 'package:flutter/material.dart';
import 'package:flutter_bilibili/router/router.dart';
import 'package:go_router/go_router.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final location = router.location;
    return Scaffold(
      appBar: AppBar(title: Text(location.toString())),
      body: Column(
        children: [
          Container(
            child: Text('demo: $location'),
          ),
          TextField(
            controller: _controller,
          ),
          ElevatedButton(
              onPressed: () {
                routerGo(path: '/');
              },
              child: const Text("home"))
        ],
      ),
    );
  }
}
