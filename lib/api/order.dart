import '../utils/https.dart';

class LoginModel {
// 获取实时订单量
  static getOrderCount(params) async {
    var response = await HttpRequest.post('/order/getOrderCount', params);
    return response;
  }
}
