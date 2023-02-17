import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class VtHttpBackendResponse<T> {
  int status;
  T? data;
  String message;

  VtHttpBackendResponse({
    required this.data,
    required this.message,
    required this.status,
  });
}

class VtHttpResponse<T> extends VtHttpBackendResponse<T> {
  bool isTimeout;
  bool isNetworkError;
  bool isError;
  bool isCancelled;
  String requestId;

  VtHttpResponse({
    required super.data,
    required super.message,
    required super.status,
    required this.requestId,
    this.isTimeout = false,
    this.isNetworkError = false,
    this.isError = false,
    this.isCancelled = false,
  });
}

class VtHttpOptions extends BaseOptions {
  VtHttpOptions({
    super.method,
    super.connectTimeout,
    super.receiveTimeout,
    super.sendTimeout,
    super.baseUrl = '',
    super.queryParameters,
    super.extra,
    super.headers,
    super.responseType = ResponseType.json,
    super.contentType,
    super.validateStatus,
    super.receiveDataWhenStatusError,
    super.followRedirects,
    super.maxRedirects,
    super.persistentConnection,
    super.requestEncoder,
    super.responseDecoder,
    super.listFormat,
  });
}

class VtHttp {
  final _tokens = <UniqueKey, CancelToken>{};
  final _duplicatedRequests = <String, CancelToken>{};

  late final Dio _dio;
  static final _defaultOptions = VtHttpOptions(
    method: 'get',
    connectTimeout: const Duration(milliseconds: 10 * 1000),
    receiveTimeout: const Duration(milliseconds: 60 * 1000),
  );

  late final VtHttpOptions _options;

  VtHttp([VtHttpOptions? options]) {
    _options = options ?? _defaultOptions;
    _dio = Dio(_options);
  }

  BaseOptions get options => _options;

  Future<VtHttpResponse<T>> request<T>(
    String method,
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool retryWhenTimeout = false,
    bool retryWhenNetworkError = false,
    bool cancellable = false,

    //
    bool autoFilterDuplicatedRequest = false,
    bool cancelLastOne = true,

    // key should be unique
    UniqueKey? key,
    int maxTimeoutRetry = 2,
    int maxNetworkErrorRetry = 2,
    Duration maxTimeoutDuration = const Duration(milliseconds: 3000),
    Duration maxTimeoutNetwork = const Duration(milliseconds: 10 * 000),
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    assert(cancellable && key != null);

    options ??= Options();
    options.method ??= method;

    var requestId = '${options.method}_$url';
    final response = VtHttpResponse<T>(
      data: null,
      message: '',
      status: 0,
      requestId: requestId,
    );

    try {
      CancelToken? cancelToken;
      if (cancellable) {
        cancelToken = CancelToken();
        _tokens[key!] = cancelToken;
      }

      if (autoFilterDuplicatedRequest) {
        requestId =
            '${options.method}_$url^${queryParameters.toString()}+${data.toString()}';

        final duplicatedRequestToken = _duplicatedRequests[requestId];
        if (duplicatedRequestToken != null) {
          if (cancelLastOne && !duplicatedRequestToken.isCancelled) {
            duplicatedRequestToken
                .cancel(ErrorDescription('duplicated request'));
            _duplicatedRequests.remove(requestId);
          }
        } else {
          _duplicatedRequests[requestId] = CancelToken();
        }
      }

      final res = await _dio.request<VtHttpBackendResponse<T>>(
        url,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (res.data != null) {
        response.data = res.data!.data;
        response.message = res.data!.message;
        response.status = res.data!.status;
      }
    } on DioError catch (e) {
      response.isError = true;

      if (e.response != null) {
        response.status = e.response!.statusCode!;
      }
      switch (e.type) {
        case DioErrorType.connectionTimeout:
          response.isTimeout = true;
          response.message = 'connect timeout';
          break;
        case DioErrorType.sendTimeout:
          response.isTimeout = true;
          response.message = 'send timeout';
          break;
        case DioErrorType.receiveTimeout:
          response.isTimeout = true;
          response.message = 'receive timeout';
          break;
        case DioErrorType.badCertificate:
          response.message = 'bad certificate';
          break;
        case DioErrorType.badResponse:
          response.message = 'bad response';
          break;
        case DioErrorType.cancel:
          response.isCancelled = true;
          response.message = 'request cancelled';
          break;
        case DioErrorType.connectionError:
          response.message = 'connection cancelled';
          break;
        case DioErrorType.unknown:
          response.message = 'unknown error';
          break;
      }
    } catch (err) {
      response.isError = true;
      if (kDebugMode) {
        response.message = err.toString();
      } else {
        response.message = 'temporarily issue, please try again later';
      }
    } finally {
      if (cancellable) {
        _tokens.remove(key);
      }

      if (autoFilterDuplicatedRequest &&
          _duplicatedRequests.containsKey(requestId)) {
        _duplicatedRequests.remove(requestId);
      }
    }

    return response;
  }

  Future<VtHttpResponse<T>> get<T>(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool retryWhenTimeout = false,
    bool retryWhenNetworkError = false,
    bool cancellable = false,

    //
    bool autoFilterDuplicatedRequest = false,
    bool cancelLastOne = true,

    // key should be unique
    UniqueKey? key,
    int maxTimeoutRetry = 2,
    int maxNetworkErrorRetry = 2,
    Duration maxTimeoutDuration = const Duration(milliseconds: 3000),
    Duration maxTimeoutNetwork = const Duration(milliseconds: 10 * 000),
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) {
    return request(
      'get',
      url,
      data: data,
      queryParameters: queryParameters,
      retryWhenTimeout: retryWhenTimeout,
      retryWhenNetworkError: retryWhenNetworkError,
      cancellable: cancellable,
      autoFilterDuplicatedRequest: autoFilterDuplicatedRequest,
      cancelLastOne: cancelLastOne,
      options: options,
    );
  }

  void cancel(UniqueKey key, [Object? reason]) {
    final token = _tokens[key];
    if (token != null && !token.isCancelled) {
      token.cancel(reason);
    }
  }
}
