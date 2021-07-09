import 'package:dio/dio.dart';

class RequesterOptions {
  final String? baseUrl;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? queryParameters;

  RequesterOptions({this.baseUrl, this.headers, this.queryParameters});
}

class Requester {
  static Future<Response> get({required String url, RequesterOptions? options}) async {
    try {
      final response = await Dio(BaseOptions(
              headers: options?.headers,
              queryParameters: options?.queryParameters,
              baseUrl: options?.baseUrl ?? ''))
          .get(url);

      return response;
    } on DioError catch (e) {
      if (e.response?.data != null) {
        throw e;
      } else {
        throw e;
      }
    }
  }
}
