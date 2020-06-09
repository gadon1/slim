import 'dart:convert';
import 'package:http/http.dart' as http;
import 'response.dart';

const String applicationJSON = "application/json; charset=UTF-8";
const String contentType = "content-type";

enum SlimApiMethod { GET, POST, PUT, DELETE }

/// Abstract class to ease Rest api services writing
abstract class SlimApi {
  /// The server main url
  final String serverUrl;
  SlimApi(this.serverUrl);

  /// Set request headers
  Map<String, String> createHeaders(SlimApiMethod method, {String extra}) =>
      {contentType: applicationJSON};

  /// GET request to serverlUrl/serviceUrl, extra parametes passed to createHeaders method
  Future<SlimResponse> get(String serviceUrl, {String extra}) =>
      _request(serviceUrl, SlimApiMethod.GET, extra: extra);

  /// DELETE request to serverlUrl/serviceUrl, extra parametes passed to createHeaders method
  Future<SlimResponse> delete(String serviceUrl, {String extra}) =>
      _request(serviceUrl, SlimApiMethod.DELETE, extra: extra);

  /// POST request to serverlUrl/serviceUrl, extra parametes passed to createHeaders method
  Future<SlimResponse> post(String serviceUrl, dynamic body, {String extra}) =>
      _request(serviceUrl, SlimApiMethod.POST, body: body, extra: extra);

  /// PUT request to serverlUrl/serviceUrl, extra parametes passed to createHeaders method
  Future<SlimResponse> put(String serviceUrl, dynamic body, {String extra}) =>
      _request(serviceUrl, SlimApiMethod.PUT, body: body, extra: extra);

  Function _getCall(SlimApiMethod method) {
    switch (method) {
      case SlimApiMethod.POST:
        return http.post;
      case SlimApiMethod.DELETE:
        return http.delete;
      case SlimApiMethod.GET:
        return http.get;
      case SlimApiMethod.PUT:
        return http.put;
      default:
        throw UnsupportedError("rest method not supported");
    }
  }

  Future<SlimResponse> _request(String serviceUrl, SlimApiMethod method,
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
      final response =
          SlimResponse(url, method, result.statusCode, st.elapsedMilliseconds)
            ..body = result.body;
      if (!response.success) response.exception = result.reasonPhrase;
      print(response);
      return response;
    } catch (e) {
      st.stop();
      final response = SlimResponse(url, method, 500, st.elapsedMilliseconds)
        ..exception = e.toString();
      print(response);
      return response;
    }
  }
}
