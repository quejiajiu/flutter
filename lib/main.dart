import 'package:flutter/material.dart';
import 'home.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: double.infinity,
          child: _loginBox(),
        ),
      ),
    );
  }

  TextEditingController userController = TextEditingController();
  //手机号的控制器
  TextEditingController phoneController = TextEditingController();
  //密码的控制器
  TextEditingController passController = TextEditingController();
  // 背景
  var bklogo = new Container(
    height: 360,
    decoration: BoxDecoration(
      image: new DecorationImage(
        image: new AssetImage('images/ico_index_bg.png'),
        // centerSlice: new Rect.fromLTRB(0, 0, 1440, 200),
        fit: BoxFit.cover,
      ),
    ),
    child: Column(
      children: [
        Center(
          child: Container(
            height: 80,
            width: 80,
            margin: const EdgeInsets.only(top: 100, bottom: 20),
            decoration: BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('images/lake.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Center(
          child: new Text(
            '欢迎使用THA站点版',
            style: new TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 4.0,
            ),
          ),
        )
      ],
    ),
  );
  // 输入区
  Widget creatInp() {
    //账号的控制器

    getCookie() async {
      final prefs = await SharedPreferences.getInstance();
      var cookie = prefs.getString('cookies');
      if (cookie != null) {
        var cookies = json.decode(cookie);
        userController.text = cookies['userCode'];
        phoneController.text = cookies['phone'];
        passController.text = cookies['passWord'];
      }
    }

    getCookie();

    _login() {
      if (userController.text.length == 0 ||
          phoneController.text.length == 0 ||
          passController.text.length == 0) {
        return null;
      } else {
        return () {
          loginFn(
              userController.text, phoneController.text, passController.text);
          // Navigator.of(context).push(
          //   new MaterialPageRoute(
          //     builder: (context) {
          //       return new Home();
          //     },
          //   ),
          // );
        };
      }
    }

    var check = false;
    var box = new Column(
      children: [
        new Container(
          height: 240,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: const Color(0x40000000),
                offset: new Offset(0.0, 8),
                blurRadius: 20.0,
              ),
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: userController,
                keyboardType: TextInputType.text,
                style: new TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.panorama_fish_eye,
                    color: Colors.grey,
                    size: 32.0,
                  ), //输入框内右侧图标
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 32.0,
                  ), //输入框内左侧图标
                  labelText: '请输入账号',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                autofocus: false,
              ),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                style: new TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.panorama_fish_eye,
                    color: Colors.grey,
                    size: 32.0,
                  ), //输入框内右侧图标
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.grey,
                    size: 32.0,
                  ), //输入框内左侧图标
                  labelText: '请输入手机号',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                autofocus: false,
                onChanged: (val) {},
              ),
              TextField(
                controller: passController,
                keyboardType: TextInputType.text,
                style: new TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.panorama_fish_eye_rounded,
                    color: Colors.grey,
                    size: 32.0,
                  ), //输入框内右侧图标
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.grey,
                    size: 32.0,
                  ), //输入框内左侧图标
                  labelText: '请输入密码',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                obscureText: true,
                autofocus: false,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 25, right: 25, bottom: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: check,
                    activeColor: Colors.blue,
                    onChanged: (bool val) {
                      // val 是布尔值
                      this.setState(() {
                        check = !check;
                      });
                    },
                  ),
                  Text('记住密码'),
                ],
              ),
              Text(
                '忘记密码',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ],
          ),
        ),
        MaterialButton(
          minWidth: MediaQuery.of(context).size.width - 40,
          height: 50.0,
          color: Colors.red,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black87,
          onPressed: _login(),
          child: Text('登录'),
        ),
      ],
    );
    return box;
  }

  void loginFn(userCode, phone, passWord) {
    var parameter = {};
    // parameter['passWord'] = '123456';
    // parameter['phone'] = '0123456789';
    // parameter['userCode'] = '1111110003';
    parameter['passWord'] = passWord;
    parameter['phone'] = phone;
    parameter['userCode'] = userCode;
    var params = {};
    params['parameter'] = parameter;

    void userInfo(data) async {
      if (data != null && data.data != null) {
        var userInfo = data.data['data'];
        if (userInfo != null) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('userInfo', json.encode(userInfo));
          prefs.setString('cookies', json.encode(parameter));
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) {
                return new Home();
              },
            ),
          );
        }
      }
    }

    void saveToken(token) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      LoginModel.getUserInfo().then((value) => userInfo(value));
    }

    void useValue(data) {
      if (data != null && data.data != null) {
        var token = data.data['data'];
        if (token.isNotEmpty) {
          saveToken(token);
        }
      }
    }

    LoginModel.phoneLogin(params).then((value) => useValue(value));
  }

  Widget _loginBox() {
    return Stack(
      // alignment: Alignment.center,
      // fit: StackFit.expand, //未定位widget占满Stack整个空间
      children: <Widget>[
        bklogo,
        Positioned(
          left: 0,
          top: 250,
          width: MediaQuery.of(context).size.width,
          child: creatInp(),
        ),
      ],
    );
  }
}
