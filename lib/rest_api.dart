import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'extensions.dart';

const String applicationJSON = "application/json; charset=UTF-8";

enum RestApiMethod { GET, POST, PUT, DELETE }

abstract class RestApi {
  final String serverUrl;
  RestApi(this.serverUrl);

  Map<String, String> createHeaders(RestApiMethod method, {String extra}) =>
      {HttpHeaders.contentTypeHeader: applicationJSON};

  Future<RestApiResult> get(String serviceUrl, {String extra}) =>
      _get(serviceUrl, RestApiMethod.GET, extra: extra);

  Future<RestApiResult> delete(String serviceUrl, {String extra}) =>
      _get(serviceUrl, RestApiMethod.DELETE, extra: extra);

  Future<RestApiResult> post(String serviceUrl, dynamic body, {String extra}) =>
      _post(serviceUrl, RestApiMethod.POST, body, extra: extra);

  Future<RestApiResult> pur(String serviceUrl, dynamic body, {String extra}) =>
      _post(serviceUrl, RestApiMethod.PUT, body, extra: extra);

  Future<RestApiResult> _get(String serviceUrl, RestApiMethod method,
      {String extra}) async {
    final url = "$serverUrl/$serviceUrl";
    final st = Stopwatch()..start();
    try {
      print("$method $url");

      final res = method == RestApiMethod.GET
          ? await http.get(
              url,
              headers: createHeaders(method, extra: extra),
            )
          : method == RestApiMethod.DELETE
              ? await http.delete(
                  url,
                  headers: createHeaders(method, extra: extra),
                )
              : throw UnsupportedError("method not supported");
      st.stop();
      final response =
          RestApiResult(url, method, res.statusCode, st.elapsedMilliseconds)
            ..body = res.body;
      if (!response.success) response.exception = res.reasonPhrase;
      print(response);
      return response;
    } catch (e) {
      final response = RestApiResult(url, method, 500, st.elapsedMilliseconds)
        ..exception = e.toString();
      print(response);
      return response;
    }
  }

  Future<RestApiResult> _post(
      String serviceUrl, RestApiMethod method, dynamic body,
      {String extra}) async {
    final url = "$serverUrl/$serviceUrl";
    final st = Stopwatch()..start();
    try {
      final json = jsonEncode(body);
      print("$method $url $json");

      final res = method == RestApiMethod.POST
          ? await http.post(
              url,
              body: json,
              headers: createHeaders(method, extra: extra),
            )
          : method == RestApiMethod.PUT
              ? await http.put(
                  url,
                  body: json,
                  headers: createHeaders(method, extra: extra),
                )
              : throw UnsupportedError("rest method not supported");

      st.stop();
      final response =
          RestApiResult(url, method, res.statusCode, st.elapsedMilliseconds)
            ..body = res.body;
      if (!response.success) response.exception = res.reasonPhrase;
      print(response);
      return response;
    } catch (e) {
      st.stop();
      final response = RestApiResult(url, method, 500, st.elapsedMilliseconds)
        ..exception = e.toString();
      print(response);
      return response;
    }
  }
}

class RestApiResult {
  bool get success => statusCode == 200 || statusCode == 201;
  int statusCode;
  String body;
  String exception;
  RestApiMethod method;
  String url;
  int milliseconds;
  String get error => body.isNullOrEmpty ? exception : body;

  RestApiResult(this.url, this.method, this.statusCode, this.milliseconds);

  @override
  String toString() => "$method [$statusCode] [$error] ${milliseconds}ms";
}
