// services/order_service.dart
import 'package:hiddify/features/panel/xboard/models/order_model.dart';

import 'package:hiddify/features/panel/xboard/services/http_service/http_service.dart';

class OrderService {
  final HttpService _httpService = HttpService();

  Future<List<Order>> fetchUserOrders(String accessToken) async {
    final result = await _httpService.getRequest(
      "/api/v1/user/order/fetch",
      headers: {'Authorization': accessToken},
    );

    if (result["status"] == "success") {
      final ordersJson = result["data"] as List;
      return ordersJson
          .map((json) => Order.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Failed to fetch user orders: ${result['message']}");
    }
  }

  Future<Map<String, dynamic>> getOrderDetails(
      String tradeNo, String accessToken) async {
    return await _httpService.getRequest(
      "/api/v1/user/order/detail?trade_no=$tradeNo",
      headers: {'Authorization': accessToken},
    );
  }

  Future<Map<String, dynamic>> cancelOrder(
      String tradeNo, String accessToken) async {
    return await _httpService.postRequest(
      "/api/v1/user/order/cancel",
      {"trade_no": tradeNo},
      headers: {'Authorization': accessToken},
    );
  }

  Future<Map<String, dynamic>> createOrder(
      String accessToken, int planId, String period) async {
    // 构造请求体
    final Map<String, dynamic> requestBody = {
      "plan_id": planId,
      "period": period,
    };
  
    // 发送 POST 请求
    final result = await _httpService.postRequest(
      "/api/v1/user/order/save",
      requestBody,
      headers: {
        "Authorization": accessToken,
        "Content-Type": "application/json", // 确保设置正确的 Content-Type
      },
    );
  
    // 检查响应是否成功
    if (result.containsKey("data")) {
      return {
        "orderId": result["data"],
      };
    } else {
      throw Exception("Order creation failed: ${result['message'] ?? 'Unknown error'}");
    }
  }

}
