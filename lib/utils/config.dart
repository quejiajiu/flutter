import 'package:flutter/material.dart';

enum Flavor {
  DEVELOPMENT,
  RELEASE,
}

class Config {
  static Flavor appFlavor;
  String base_url;
  static int connectTimeout;
  Config() {
    connectTimeout = 6000;
    switch (appFlavor) {
      case Flavor.RELEASE:
        base_url = 'https://jtapi.jtexpress.co.th/jts-tha-service-reportapp';
        break;
      case Flavor.DEVELOPMENT:
      default:
        base_url = 'https://47.57.97.45/jts-tha-service-reportapp';
    }
  }

  static String get baseUrl {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return 'https://jtapi.jtexpress.co.th/jts-tha-service-reportapp';
      case Flavor.DEVELOPMENT:
      default:
        return 'https://47.57.97.45/jts-tha-service-reportapp';
    }
  }

  static Icon get helloIcon {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return new Icon(Icons.new_releases);
      case Flavor.DEVELOPMENT:
      default:
        return new Icon(Icons.developer_mode);
    }
  }
}
