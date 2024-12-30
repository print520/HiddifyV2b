// services/http_service.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hiddify/features/panel/xboard/services/http_service/domain_service.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static String baseUrl = ''; // 替换为你的实际基础 URL
  // 初始化服务并设置动态域名
  static Future<void> initialize() async {
    baseUrl = await DomainService.fetchValidDomain();
  }

  // 通用的 GET 请求方法
  Future<Map<String, dynamic>> getRequest(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 20)); // 设置超时时间

      if (kDebugMode) {
        print("GET $url response: ${response.body}");
      }

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
            "GET request failed: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('GET request error: $e');
      }
      rethrow;
    }
  }

  // 通用的 POST 请求方法
  Future<Map<String, dynamic>> postRequest(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              if (headers != null) ...headers, // 合并自定义头部
            },
            body: json.encode(body), // 将请求体序列化为 JSON
          )
          .timeout(const Duration(seconds: 20)); // 设置超时时间

      if (kDebugMode) {
        print("POST $url request body: ${json.encode(body)}");
        print("POST $url response: ${response.body}");
      }

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
            "POST request failed: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('POST request error: $e');
      }
      rethrow;
    }
  }

  // POST 请求方法，不包含 headers
  Future<Map<String, dynamic>> postRequestWithoutHeaders(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    return await postRequest(
      endpoint,
      body,
      headers: {}, // 不设置默认头部
    );
  }
}
