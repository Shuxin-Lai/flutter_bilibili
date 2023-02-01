// ignore_for_file: avoid_print, prefer_conditional_assignment, unnecessary_null_comparison

class LogUtil {
  LogUtil(this.prefix) {}

  static LogUtil? _instance;

  final String? prefix;

  _getPrefix(String type) {
    return '${prefix ?? ''} $type';
  }

  log(Object object) {
    print('${_getPrefix('log')}: $object');
  }

  warn(Object object) {
    print('${_getPrefix('warn')}: $object');
  }

  error(Object object) {
    print('${_getPrefix('error')}: $object');
  }

  static LogUtil getInstance() {
    if (_instance == null) {
      _instance = LogUtil('');
    }
    return _instance!;
  }
}
