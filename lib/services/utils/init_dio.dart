import "package:dio/dio.dart";

/// 初始化 Dio (可能使用代理)
Dio initDio() {
  final Dio dio = Dio(
      // BaseOptions(
      //   contentType: Headers.jsonContentType,
      //   validateStatus: (int? status) {
      //     // return status != null;
      //     return status != null && status >= 200 && status < 300;
      //   },
      // ),
      );
  return dio;
}
