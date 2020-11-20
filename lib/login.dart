import 'utils/https.dart';

class LoginModel {
  // 手机号码登录
  static phoneLogin(params) async {
    Map<String, String> _map = Map();
    _map['noToken'] = '';
    var response =
        await HttpRequest.post('/customer/customerLogin', params, header: _map);
    return response;
  }

  // 获取用户信息
  static getUserInfo() async {
    var response = await HttpRequest.post('/customer/getCustomerInfo', {});
    return response;
  }
}
