import 'package:flutter/material.dart';
import 'package:flutter_bilibili/router/router.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final location = router.location;
    return Scaffold(
      appBar: AppBar(title: Text(location.toString())),
      body: Column(
        children: [
          Container(
            child: Text('home'),
          ),
          TextField(
            controller: _controller,
          ),
          ElevatedButton(
              onPressed: () {
                routerPush(name: 'demo', params: {'id': _controller.text});
              },
              child: const Text("demo"))
        ],
      ),
    );
  }
}
