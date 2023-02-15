import 'dart:async';

typedef Executor<T> = void Function(
    {void Function(T value) resolve, void Function(Object reason) reject});

class VtFutureUtils {
  static bool isFuture(dynamic v) {
    return v is Future;
  }

  static bool isNotFuture(dynamic v) {
    return isFuture(v) == false;
  }

  static Future<T> createFuture<T>(Executor executor) {
    final c = Completer<T>();
    return Future(() {
      try {
        executor(resolve: (value) {
          if (c.isCompleted == false) {
            c.complete(value);
          }
        }, reject: (reason) {
          if (c.isCompleted == false) {
            c.completeError(reason);
          }
        });
      } catch (err) {
        if (c.isCompleted == false) {
          c.completeError(err);
        }
      }

      return c.future;
    });
  }
}
