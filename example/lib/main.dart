import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'basic.dart';
import 'custom_plugin.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      shortcutDevices: [
        Devices.ios.iPhoneSE,
        Devices.ios.iPhone13ProMax,
        Devices.ios.iPadAir4,
        Devices.ios.iPad12InchesGen4,
      ],
      tools: const [
        ...DevicePreview.defaultTools,
        CustomPlugin(),
      ],
      builder: (context) => const BasicApp(),
    ),
  );
}
