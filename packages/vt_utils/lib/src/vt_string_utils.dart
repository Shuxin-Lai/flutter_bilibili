class VtStringUtils {
  static bool isString(dynamic s) {
    return s is String;
  }

  static bool isNotString(dynamic s) {
    return isString(s) == false;
  }

  static bool isEmpty(String? s) {
    return s == null || s.isEmpty;
  }

  static bool isNotEmpty(String? s) {
    return isEmpty(s) == false;
  }

  static bool isStrictEmpty(String? s) {
    if (isEmpty(s)) {
      return true;
    }

    return isEmpty(s!.trim());
  }

  static bool isStrictNotEmpty(String? s) {
    return isStrictEmpty(s) == false;
  }
}
