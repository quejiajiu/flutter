import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeAppBar extends StatefulWidget {
  State<StatefulWidget> createState() {
    return new Appbars();
  }
}

class Appbars extends State {
  var userInfo;
  String siteType = '';
  String userName = '';
  void getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    var obj = prefs.getString('userInfo');
    Map<String, dynamic> userInfo = json.decode(obj);
    setState(() {
      userName = userInfo['userName'];
      siteType = userInfo['siteType'];
    });
  }

  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    //横向布局
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: InkWell(
              onTap: () {
                print('点击了');
              },
              child: Container(
                height: 40,
                padding: EdgeInsets.only(right: 10),
                alignment: Alignment.centerLeft,
                child: new Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: new CircleAvatar(
                        backgroundImage: new NetworkImage(
                            'http://b-ssl.duitang.com/uploads/item/201805/13/20180513224039_tgfwu.png'),
                        radius: 100.0,
                      ),
                    ),
                    new Text(
                      userName,
                      style: new TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 30,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.yellow[300],
                      ),
                      child: new Text(
                        siteType,
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.centerRight,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(''),
                  ),
                  new Icon(Icons.arrow_left, color: Colors.white, size: 20),
                  new Text(
                    '  2020-11-11  ',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  new Icon(Icons.arrow_right, color: Colors.white, size: 20),
                ]),
          ),
        ),
      ],
    );
  }
}
