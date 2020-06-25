import 'dart:typed_data';

import 'api.dart';
import '../extensions/string.dart';

/// Slim api response object
class SlimResponse {
  /// True if statusCode == 200 || statusCode == 201
  bool get success => statusCode == 200 || statusCode == 201;

  /// Response status code
  int statusCode;

  /// Response body
  String body;

  /// Response bytes
  Uint8List bytes;

  /// Response exception - use error instead
  String exception;

  /// Request Rest Method
  SlimApiMethod method;

  /// Request url
  String url;

  /// Elapsed milliseconds
  int milliseconds;

  /// Response error
  String get error => body.isNullOrEmpty ? exception : body;

  SlimResponse(this.url, this.method, this.statusCode, this.milliseconds);

  @override
  String toString() => "$method [$statusCode] [$error] ${milliseconds}ms";
}
