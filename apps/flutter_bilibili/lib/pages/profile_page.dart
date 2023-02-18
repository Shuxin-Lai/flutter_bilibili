import 'package:flutter/material.dart';
import 'package:flutter_bilibili/layouts/back_layout.dart';
import 'package:flutter_bilibili/router/router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final location = router.location;
    return BackLayout(
        child: ElevatedButton(
      onPressed: () {},
      child: Text('Profile'),
    ));
  }
}
