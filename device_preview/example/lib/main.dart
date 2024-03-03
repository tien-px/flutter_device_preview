import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'basic.dart';
import 'custom_plugin.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      shortcutDevices: const [
        "ios_phone_iphone-se",
        "ios_phone_iphone-13-pro-max",
        "ios_tablet_ipad-air-4",
        "ios_tablet_ipad-pad-pro-11inches",
      ],
      tools: const [
        ...DevicePreview.defaultTools,
        CustomPlugin(),
      ],
      builder: (context) => const BasicApp(),
    ),
  );
}
