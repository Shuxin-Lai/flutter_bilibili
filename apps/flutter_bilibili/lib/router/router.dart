import 'package:flutter_bilibili/pages/demo_page.dart';
import 'package:flutter_bilibili/pages/home_page.dart';
import 'package:flutter_bilibili/pages/message_page.dart';
import 'package:flutter_bilibili/pages/profile_page.dart';
import 'package:go_router/go_router.dart';

typedef RouterFn = void Function({
  String? name,
  String? path,
  MyRoute? route,
  Map<String, dynamic>? query,
  Map<String, String>? params,
});

class MyRoute extends GoRoute {
  MyRoute({
    required path,
    required name,
    GoRouterWidgetBuilder? builder,
    GoRouterPageBuilder? pageBuilder,
    GoRouterRedirect? redirect,
    this.appTitle = '',
  }) : super(
          path: path,
          name: name,
          builder: builder,
          pageBuilder: pageBuilder,
          redirect: redirect,
        );

  final String appTitle;
}

final homeRoute = MyRoute(
  path: '/',
  name: 'home',
  appTitle: 'Home',
  builder: (context, state) => const HomePage(),
);
final profileRoute = MyRoute(
  path: '/profile',
  name: 'profile',
  appTitle: 'Profile',
  builder: (context, state) {
    return const ProfilePage();
  },
);
final messagePage = MyRoute(
  path: '/message',
  name: 'message',
  appTitle: 'Message',
  builder: (context, state) {
    return const MessagePage();
  },
);
final demoRoute = MyRoute(
  path: '/demo/:id',
  name: 'demo',
  appTitle: 'Demo',
  builder: (context, state) {
    return const DemoPage();
  },
);

// GoRouter configuration
final router = GoRouter(
  routes: [
    homeRoute,
    profileRoute,
    messagePage,
    demoRoute,
  ],
);

RouterFn _g(String methodName) {
  assert(['go', 'push', 'replace'].contains(methodName));
  return ({path, name, route, params, query}) {
    assert(name != null || path != null || route != null);
    final queryParams = query ?? {};
    final ps = params ?? {};
    if (route != null || name != null) {
      if (methodName == 'go') {
        return router.goNamed(
          route != null ? route.name! : name!,
          queryParams: queryParams,
          params: ps,
        );
      } else if (methodName == 'push') {
        return router.pushNamed(
          route != null ? route.name! : name!,
          queryParams: queryParams,
          params: ps,
        );
      }

      return router.pushReplacementNamed(
        route != null ? route.name! : name!,
        queryParams: queryParams,
        params: ps,
      );
    }

    if (path != null) {
      if (methodName == 'push') {
        return router
            .push(Uri(path: path, queryParameters: queryParams).toString());
      }

      return router
          .go(Uri(path: path, queryParameters: queryParams).toString());
    }
  };
}

final routerGo = _g('go');
final routerPush = _g('push');
final routerReplace = _g('push');
void routerPop() {
  if (router.canPop()) {
    router.pop();
  }
}
