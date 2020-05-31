import 'dart:convert';
import 'package:http/http.dart' as http;
import 'extensions.dart';

const String applicationJSON = "application/json; charset=UTF-8";
const String contentType = "content-type";

enum RestApiMethod { GET, POST, PUT, DELETE }

/// Abstract class to ease Rest api services writing
abstract class RestApi {
  /// The server main url
  final String serverUrl;
  RestApi(this.serverUrl);

  /// Set request headers
  Map<String, String> createHeaders(RestApiMethod method, {String extra}) =>
      {contentType: applicationJSON};

  /// GET request to serverlUrl/serviceUrl, extra parametes passed to createHeaders method
  Future<RestApiResponse> get(String serviceUrl, {String extra}) =>
      _request(serviceUrl, RestApiMethod.GET, extra: extra);

  /// DELETE request to serverlUrl/serviceUrl, extra parametes passed to createHeaders method
  Future<RestApiResponse> delete(String serviceUrl, {String extra}) =>
      _request(serviceUrl, RestApiMethod.DELETE, extra: extra);

  /// POST request to serverlUrl/serviceUrl, extra parametes passed to createHeaders method
  Future<RestApiResponse> post(String serviceUrl, dynamic body,
          {String extra}) =>
      _request(serviceUrl, RestApiMethod.POST, body: body, extra: extra);

  /// PUT request to serverlUrl/serviceUrl, extra parametes passed to createHeaders method
  Future<RestApiResponse> put(String serviceUrl, dynamic body,
          {String extra}) =>
      _request(serviceUrl, RestApiMethod.PUT, body: body, extra: extra);

  Function _getCall(RestApiMethod method) {
    switch (method) {
      case RestApiMethod.POST:
        return http.post;
      case RestApiMethod.DELETE:
        return http.delete;
      case RestApiMethod.GET:
        return http.get;
      case RestApiMethod.PUT:
        return http.put;
      default:
        throw UnsupportedError("rest method not supported");
    }
  }

  Future<RestApiResponse> _request(String serviceUrl, RestApiMethod method,
      {dynamic body, String extra}) async {
    final url = "$serverUrl/$serviceUrl";
    final st = Stopwatch()..start();
    final bool withBody = body != null;
    try {
      final call = _getCall(method);

      dynamic json = withBody ? jsonEncode(body) : null;

      print("$method $url ${json ?? ''}");

      final result = await (withBody
          ? call(url, body: json, headers: createHeaders(method, extra: extra))
          : call(url, headers: createHeaders(method, extra: extra)));

      st.stop();
      final response = RestApiResponse(
          url, method, result.statusCode, st.elapsedMilliseconds)
        ..body = result.body;
      if (!response.success) response.exception = result.reasonPhrase;
      print(response);
      return response;
    } catch (e) {
      st.stop();
      final response = RestApiResponse(url, method, 500, st.elapsedMilliseconds)
        ..exception = e.toString();
      print(response);
      return response;
    }
  }
}

/// Rest api response object
class RestApiResponse {
  /// True if statusCode == 200 || statusCode == 201
  bool get success => statusCode == 200 || statusCode == 201;

  /// Response status code
  int statusCode;

  /// Response body
  String body;

  /// Response exception - use error instead
  String exception;

  /// Request Rest Method
  RestApiMethod method;

  /// Request url
  String url;

  /// Elapsed milliseconds
  int milliseconds;

  /// Response error
  String get error => body.isNullOrEmpty ? exception : body;

  RestApiResponse(this.url, this.method, this.statusCode, this.milliseconds);

  @override
  String toString() => "$method [$statusCode] [$error] ${milliseconds}ms";
}
