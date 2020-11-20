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
        base_url = 'xx';
        break;
      case Flavor.DEVELOPMENT:
      default:
        base_url = 'xx';
    }
  }

  static String get baseUrl {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return 'xx';
      case Flavor.DEVELOPMENT:
      default:
        return 'xx';
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
