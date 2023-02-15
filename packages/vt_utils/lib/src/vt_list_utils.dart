typedef ListIteratorTypeGuard<T, S> = S Function(
    {T element, int index, List<T> list});

class VtListUtils {
  static isList(dynamic v) {
    return v is List;
  }

  static bool isNotList(dynamic v) {
    return isList(v) == false;
  }

  static bool isEmpty(List? v) {
    return v == null || v.isEmpty;
  }

  static bool isNotEmpty(List? v) {
    return isEmpty(v) == false;
  }

  static int findIndex<T>(
      List<T> list, ListIteratorTypeGuard<T, bool> predicate) {
    if (isEmpty(list)) {
      return -1;
    }

    for (var i = 0; i < list.length; i++) {
      final element = list[i];
      final predication = predicate(element: element, index: i, list: list);
      if (predication == true) {
        return i;
      }
    }

    return -1;
  }

  static T? find<T>(List<T> list, ListIteratorTypeGuard<T, bool> predicate) {
    if (isEmpty(list)) {
      return null;
    }

    for (var i = 0; i < list.length; i++) {
      final element = list[i];
      final predication = predicate(element: element, index: i, list: list);
      if (predication == true) {
        return element;
      }
    }

    return null;
  }

  static List<R> map<T, R>(List<T> list, ListIteratorTypeGuard<T, R> iteratee) {
    if (isEmpty(list)) {
      return [];
    }

    final res = <R>[];
    for (var i = 0; i < list.length; i++) {
      final element = list[i];

      res.add(iteratee(element: element, index: i, list: list));
    }

    return res;
  }

  static List<T> filter<T>(
      List<T> list, ListIteratorTypeGuard<T, bool> predicate) {
    if (isEmpty(list)) {
      return [];
    }

    final res = <T>[];
    for (var i = 0; i < list.length; i++) {
      final element = list[i];
      if (predicate(element: element, index: i, list: list) == true) {
        res.add(element);
      }
    }

    return res;
  }
}
