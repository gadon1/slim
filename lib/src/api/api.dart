import 'dart:convert';
import 'package:http/http.dart' as http;
import 'response.dart';

const String applicationJSON = "application/json; charset=UTF-8";
const String contentType = "content-type";

enum SlimApiMethod { GET, POST, PUT, DELETE }

enum SlimApiLogLevel { NONE, CALLS, FULL }

/// Abstract class to ease Rest api services writing
abstract class SlimApi {
  /// The server main url
  final String serverUrl;

  /// Log level for printing results
  final SlimApiLogLevel logLevel;

  SlimApi(this.serverUrl, {this.logLevel = SlimApiLogLevel.CALLS});

  /// Set request headers
  Map<String, String> createHeaders(SlimApiMethod method, {String extra}) =>
      {contentType: applicationJSON};

  /// Set request query params
  Map<String, dynamic> createQuery(SlimApiMethod method, {String extra}) => {};

  /// GET request to serverlUrl/serviceUrl, extra parametes passed to createHeaders method
  Future<SlimResponse> get(String serviceUrl,
          {Map<String, dynamic> queryParams, String extra}) =>
      _request(serviceUrl, SlimApiMethod.GET,
          extra: extra, queryParams: queryParams);

  /// DELETE request to serverlUrl/serviceUrl, extra parametes passed to createHeaders method
  Future<SlimResponse> delete(String serviceUrl,
          {Map<String, dynamic> queryParams, String extra}) =>
      _request(serviceUrl, SlimApiMethod.DELETE,
          extra: extra, queryParams: queryParams);

  /// POST request to serverlUrl/serviceUrl, extra parametes passed to createHeaders method
  Future<SlimResponse> post(String serviceUrl, dynamic body,
          {Map<String, dynamic> queryParams, String extra}) =>
      _request(serviceUrl, SlimApiMethod.POST,
          body: body, extra: extra, queryParams: queryParams);

  /// PUT request to serverlUrl/serviceUrl, extra parametes passed to createHeaders method
  Future<SlimResponse> put(String serviceUrl, dynamic body,
          {Map<String, dynamic> queryParams, String extra}) =>
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

  String _urlBuilder(String serviceUrl, SlimApiMethod method,
      {Map<String, dynamic> queryParams, String extra}) {
    String url = "$serverUrl/$serviceUrl";
    Map<String, dynamic> _queryParams = createQuery(method, extra: extra);
    _queryParams.addAll(queryParams ?? {});
    String query = "";
    _queryParams.forEach((key, value) => query = "$query&$key=$value");
    if (url.contains('?')) return "$url$query";
    return query.isNotEmpty ? "$url?${query.substring(1)}" : url;
  }

  Future<SlimResponse> _request(
    String serviceUrl,
    SlimApiMethod method, {
    dynamic body,
    String extra,
    Map<String, dynamic> queryParams,
  }) async {
    final url =
        _urlBuilder(serviceUrl, method, extra: extra, queryParams: queryParams);
    final st = Stopwatch()..start();
    final bool withBody = body != null;
    try {
      final call = _getCall(method);

      dynamic json = withBody ? jsonEncode(body) : null;

      if (logLevel != SlimApiLogLevel.NONE) print("$method $url ${json ?? ''}");

      final http.Response result = await (withBody
          ? call(url, body: json, headers: createHeaders(method, extra: extra))
          : call(url, headers: createHeaders(method, extra: extra)));

      st.stop();
      final response =
          SlimResponse(url, method, result.statusCode, st.elapsedMilliseconds)
            ..body = result.body
            ..bytes = result.bodyBytes;
      if (!response.success) response.exception = result.reasonPhrase;
      if (logLevel == SlimApiLogLevel.FULL) print(response);
      return response;
    } catch (e) {
      st.stop();
      final response = SlimResponse(url, method, 500, st.elapsedMilliseconds)
        ..exception = e.toString();
      if (logLevel == SlimApiLogLevel.FULL) print(response);
      return response;
    }
  }
}
