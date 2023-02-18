import 'package:flutter/material.dart';
import 'package:flutter_bilibili/router/router.dart';

class BackLayout extends StatelessWidget {
  const BackLayout({
    super.key,
    required this.child,
    this.title = '',
    this.actions,
  });
  final Widget child;
  final String title;
  final List<Widget>? actions;

  List<Widget> get _actions => actions ?? [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: child,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.backgroundColor,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            routerPop();
          },
        ),
        title: Text(
          title,
        ),
        actions: _actions,
      ),
    );
  }
}
