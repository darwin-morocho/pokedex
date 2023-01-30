import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'result.dart';

///
/// define a custom http client to process all
/// http requests
class Http {
  final String baseUrl;
  final Client client;

  Http({
    required this.baseUrl,
    required this.client,
  });

  Future<HttpResult<T>> request<T>(
    String path, {
    String method = 'GET',
    Map<String, String> queryParameters = const {},
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
    T Function(int statuCode, dynamic responseBody)? parser,
  }) async {
    int? statusCode;
    dynamic responseBody;
    try {
      late Uri url;
      if (path.startsWith('http://') || path.startsWith('https://')) {
        url = Uri.parse(path);
      } else {
        if (!path.startsWith('/')) {
          path = '/$path';
        }
        url = Uri.parse('$baseUrl$path');
      }
      url = url.replace(
        queryParameters: queryParameters,
      );
      headers = {
        ...headers,
        'Content-Type': 'application/json; charset=utf-8',
      };

      final request = Request(method, url);
      request.headers.addAll(headers);

      if (method != 'GET' && method != 'get') {
        request.body = jsonEncode(body);
      }

      final streamedResponse = await client.send(request);
      final response = await Response.fromStream(streamedResponse);

      statusCode = response.statusCode;

      responseBody = () {
        try {
          return jsonDecode(response.body);
        } catch (_) {
          return response.body;
        }
      }();

      if (statusCode >= 200 && statusCode <= 299) {
        return HttpSuccess(
          statusCode,
          parser != null ? parser(statusCode, responseBody) : responseBody,
        );
      }

      return HttpFailure(
        statusCode,
        data: responseBody,
      );
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
      return HttpFailure(
        statusCode,
        data: responseBody,
        exception: e,
        stackTrace: s,
      );
    }
  }
}
