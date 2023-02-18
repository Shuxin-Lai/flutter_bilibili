import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bilibili/models/tab_item.dart';
import 'package:flutter_bilibili/providers/tab_provider.dart';
import 'package:flutter_bilibili/router/router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = ScrollController();
  var _count = 10;
  var _isLoading = false;

  Future _loadMore() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(seconds: 4)).whenComplete(() {
      setState(() {
        _isLoading = false;
        _count = _count * 2;
      });
      print('loading more');
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.userScrollDirection != ScrollDirection.reverse) {
        return;
      }

      final maxOffset = _controller.position.maxScrollExtent;
      final offset = _controller.offset.abs();
      print('offset: ' + offset.toString());
      if (offset + 200 > maxOffset) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

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
    return LayoutBuilder(builder: ((p0, p1) {
      return ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: p1.maxHeight, maxHeight: p1.maxHeight),
        child: TabBarView(
          children: provider.tabList.map((e) => _buildTabView(e)).toList(),
        ),
      );
    }));
  }

  Widget _buildTabView(TabItem e) {
    return Refresh(
        child: CustomScrollView(
      controller: _controller,
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            height: 200,
            color: Colors.blueGrey,
            child: Text('banner'),
          ),
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                height: 50,
                color:
                    Colors.primaries[(index + e.id) % Colors.primaries.length],
                child: Text('${e.title}: $index'),
              );
            },
            childCount: _count,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
        ),
        SliverToBoxAdapter(
          child: _buildLoadMore(),
        ),
      ],
    ));
  }

  Widget _buildLoadMore() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: _isLoading
          ? const SizedBox(
              height: 80,
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              ))
          : const SizedBox(),
    );
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
