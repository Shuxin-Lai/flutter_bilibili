class VtNumberUtil {
  static bool isNumber(dynamic v) {
    return v is num;
  }

  static bool isNotNumber(dynamic v) {
    return isNumber(v) == false;
  }

  static bool isNaN(dynamic v) {
    if (isNumber(v)) {
      return (v as num).isNaN;
    }

    return false;
  }
}
