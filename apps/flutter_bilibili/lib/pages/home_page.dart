import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bilibili/models/tab_item.dart';
import 'package:flutter_bilibili/providers/tab_provider.dart';
import 'package:flutter_bilibili/router/router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TabProvider>(context);
    return DefaultTabController(
      length: provider.tabList.length,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                _buildAppBar(context),
                _buildTabBar(context),
              ];
            },
            body: _buildMainContent(context),
            // slivers: [
            //   _buildAppBar(context),
            //   _buildTabBar(context),
            //   _buildMainContent(context),
            // ],
          ),
        ),
        // appBar: _buildAppBar(context),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final provider = Provider.of<TabProvider>(context);
    return TabBarView(
      children: provider.tabList.map((e) => _buildTabView(e)).toList(),
    );
  }

  Widget _buildTabView(TabItem e) {
    final child = GridView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return Container(
          height: 50,
          color: Colors.primaries[(index + e.id) % Colors.primaries.length],
          child: Text(e.title),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
    );
    return Refresh(child: child);
  }

  Widget _buildTabBar(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<TabProvider>(
      context,
      listen: false,
    );
    return SliverAppBar(
      elevation: 0.2,
      primary: false,
      pinned: true,
      snap: false,
      backgroundColor: theme.backgroundColor,
      titleSpacing: 0,
      title: TabBar(
        indicatorColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        isScrollable: true,
        enableFeedback: false,
        tabs: provider.tabList.map((e) => Text(e.title)).toList(),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      primary: false,
      backgroundColor: theme.backgroundColor,
      elevation: 0.2,
      leading: UserAvatar(
        onTap: () {
          routerPush(name: 'profile');
        },
      ),
      title: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: const TextField(
          maxLines: 1,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            onPressed: () {
              routerPush(name: 'message');
            },
            icon: const Icon(
              Icons.email,
              color: Colors.black87,
            ))
      ],
      floating: true,
      snap: true,
    );
  }
}

class Refresh extends StatefulWidget {
  final Widget child;
  const Refresh({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<Refresh> createState() => _RefreshState();
}

class _RefreshState extends State<Refresh> with SingleTickerProviderStateMixin {
  static const _indicatorSize = 100.0;
  late AnimationController _spoonController;

  @override
  void initState() {
    _spoonController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _spoonController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      offsetToArmed: _indicatorSize,
      onRefresh: () => Future.delayed(const Duration(seconds: 2)),
      autoRebuild: false,
      child: widget.child,
      onStateChanged: (change) {
        if (change.didChange(to: IndicatorState.loading)) {
          _spoonController.repeat(reverse: true);
        } else if (change.didChange(from: IndicatorState.loading)) {
          _spoonController.stop();
        } else if (change.didChange(to: IndicatorState.idle)) {
          _spoonController.value = 0.0;
        }
      },
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? _) {
                return SizedBox(
                  height: controller.value * _indicatorSize,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            ),
            AnimatedBuilder(
              builder: (context, _) {
                return Transform.translate(
                  offset: Offset(0.0, controller.value * _indicatorSize),
                  child: child,
                );
              },
              animation: controller,
            ),
          ],
        );
      },
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      enableFeedback: false,
      onPressed: () {
        if (onTap != null) {
          onTap!();
        }
      },
      icon: const CircleAvatar(
        child: Icon(Icons.person),
      ),
    );
  }
}
