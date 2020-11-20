import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import './api/order.dart';
import 'dart:convert';
import 'appbar.dart';

// void main() => runApp(new Home());

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TopTabCreat();
  }
}

class TopTabCreat extends State<Home> with SingleTickerProviderStateMixin {
  TabController mController;
  List<Tab> tabs;

  @override
  void initState() {
    super.initState();
    tabs = <Tab>[
      Tab(
        text: "订单量",
      ),
      Tab(
        text: "营业收入",
      ),
      Tab(
        text: "收派签量",
      ),
    ];
    mController = TabController(
      initialIndex: 0,
      length: tabs.length,
      vsync: this,
    );
    getOrderCount();
  }

  orderFn(data) {
    //
  }
  void getOrderCount() async {
    final prefs = await SharedPreferences.getInstance();
    var info = prefs.getString('userInfo');
    var userInfo = json.decode(info);
    var parameter = {};
    var params = {};
    var strTime = DateTime.now().toString();
    parameter['name'] = userInfo['siteCode'];
    parameter['type'] = 1;
    parameter['time'] = strTime.substring(0, 10);
    params['parameter'] = parameter;
    LoginModel.getOrderCount(params).then((value) => orderFn(value));
  }

  @override
  void dispose() {
    super.dispose();
    mController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        elevation: 1,
        title: HomeAppBar(),
      ),
      body: Stack(children: <Widget>[
        Container(
          height: 200,
          child: Image.asset(("images/ico_index_bg.png"),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity),
        ),
        Column(children: [
          _main(),
        ])
      ]),
    );
  }

  Widget _main() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        // image: new DecorationImage(
        //   image: new AssetImage('images/ico_index_bg.png'),
        //   centerSlice: new Rect.fromLTRB(0, 0, 1440, 200),
        //   fit: BoxFit.fill,
        // ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _tabBar(),
          _tabBarView(),
        ],
      ),
      width: double.infinity,
    );
  }

  Widget _tabBar() {
    return Container(
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: TabBar(
        controller: mController,
        tabs: tabs,
        isScrollable: true,
        indicatorColor: Color(0xffff0000),
        indicatorWeight: 1,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.only(bottom: 5, top: 5),
        labelPadding: EdgeInsets.only(left: 20, right: 20),
        labelColor: Color(0xff333333),
        labelStyle: TextStyle(
          fontSize: 15.0,
        ),
      ),
    );
  }

  Widget _tabBarView() {
    return Container(
      child: TabBarView(
        controller: mController,
        children: [
          new Container(child: _order()),
          new Container(child: _order(name: '营业收入')),
          new Container(child: _order(name: '签派收量')),
        ],
      ),
      height: 200,
      padding: const EdgeInsets.only(top: 30),
      decoration: new BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: const Color(0x40000000),
            offset: new Offset(0.0, 8),
            blurRadius: 20.0,
          ),
        ],
      ),
    );
  }

  Widget _order({String name = '今日订单量'}) {
    var last = [];
    if (name != '营业收入') {
      last = [
        new Container(
          alignment: Alignment.center,
          height: 60,
          child: row,
        ),
        new Container(
          alignment: Alignment.topCenter,
          child: row1,
        )
      ];
    }

    return Column(children: [
      Text(
        '$name',
        style: new TextStyle(
          color: Colors.grey,
        ),
      ),
      Text(
        '29795',
        style: new TextStyle(
          color: Colors.redAccent,
          fontSize: 24.0,
          letterSpacing: 4.0,
        ),
      ),
      ...last
    ]);
  }

  Widget row = new Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      Text(
        "上日单量：2564",
        style: new TextStyle(
          color: Colors.grey,
        ),
      ),
      Row(
        children: [
          Text("环比：12%"),
          new SizedBox.fromSize(
              child: new Icon(Icons.countertops,
                  color: Colors.lightBlueAccent, size: 12.0)),
        ],
      ),
    ],
  );
  Widget row1 = new Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      Row(
        children: [
          new SizedBox.fromSize(
              child: new Icon(Icons.one_k,
                  color: Colors.lightBlueAccent, size: 12.0)),
          Text("SHOPPE"),
        ],
      ),
      Row(
        children: [
          new SizedBox.fromSize(
              child: new Icon(Icons.two_k,
                  color: Colors.lightBlueAccent, size: 12.0)),
          Text("SHOPPE"),
        ],
      ),
      Row(
        children: [
          new SizedBox.fromSize(
              child: new Icon(Icons.three_k,
                  color: Colors.lightBlueAccent, size: 12.0)),
          Text("SHOPPE"),
        ],
      ),
    ],
  );
}
