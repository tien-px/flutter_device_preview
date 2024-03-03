import 'package:collection/collection.dart';
import 'package:device_frame/device_frame.dart';
import 'package:device_preview/src/state/store.dart';
import 'package:device_preview/src/views/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tool_panel/tool_panel.dart';

/// The tool layout when the screen is small.
class DevicePreviewSmallLayout extends StatelessWidget {
  /// Create a new panel from the given tools grouped as [slivers].
  const DevicePreviewSmallLayout({
    Key? key,
    required this.shortcutDevices,
    required this.maxMenuHeight,
    required this.scaffoldKey,
    required this.onMenuVisibleChanged,
    required this.slivers,
  }) : super(key: key);

  /// The maximum modal menu height.
  final double maxMenuHeight;

  /// The key of the [Scaffold] that must be used to show the modal menu.
  final GlobalKey<ScaffoldState> scaffoldKey;

  /// Invoked each time the menu is shown or hidden.
  final ValueChanged<bool> onMenuVisibleChanged;

  /// The devices that can be quickly selected.
  final List<DeviceInfo> shortcutDevices;

  /// The sections containing the tools.
  ///
  /// They must be [Sliver]s.
  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    final toolbarTheme = context.select(
      (DevicePreviewStore store) => store.settings.toolbarTheme,
    );
    return Theme(
      data: toolbarTheme.asThemeData(),
      child: SafeArea(
        top: false,
        child: _BottomToolbar(
          shortcuts: shortcutDevices,
          showPanel: () async {
            onMenuVisibleChanged(true);
            final sheet = scaffoldKey.currentState?.showBottomSheet(
              (context) => ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: ToolPanel(
                  isModal: true,
                  slivers: slivers,
                ),
              ),
              constraints: BoxConstraints(
                maxHeight: maxMenuHeight,
              ),
              backgroundColor: Colors.transparent,
            );
            await sheet?.closed;
            onMenuVisibleChanged(false);
          },
        ),
      ),
    );
  }
}

class _BottomToolbar extends StatelessWidget {
  const _BottomToolbar({
    Key? key,
    required this.showPanel,
    required this.shortcuts,
  }) : super(key: key);

  final VoidCallback showPanel;
  final List<DeviceInfo> shortcuts;

  @override
  Widget build(BuildContext context) {
    final isEnabled = context.select((DevicePreviewStore store) => store.data.isEnabled);
    final devices = context.select((DevicePreviewStore store) => store.devices);
    final deviceIdentifier = context.select(
      (DevicePreviewStore store) => store.deviceInfo.identifier,
    );
    List<DeviceInfo> shortcutDevices = shortcuts
        .map((a) => devices.firstWhereOrNull((b) => b.identifier == a.identifier))
        .whereType<DeviceInfo>()
        .toList();

    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            IconButton(onPressed: isEnabled ? showPanel : null, icon: const Icon(Icons.tune)),
            const Text('Device Preview'),
            const SizedBox(width: 8.0),
            Expanded(
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: shortcutDevices.length,
                  itemBuilder: (context, index) {
                    final device = shortcutDevices[index];
                    final isSelected = device.identifier == deviceIdentifier;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: null,
                        child: Container(
                          width: 30,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.red : Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              width: 1.0,
                            ),
                          ),
                          child: Center(
                            child: IconButton(
                              icon: Text(
                                (index + 1).toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                final state = context.read<DevicePreviewStore>();
                                state.selectDevice(device.identifier);
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Switch(
              value: isEnabled,
              onChanged: (v) {
                final state = context.read<DevicePreviewStore>();
                state.data = state.data.copyWith(isEnabled: v);
              },
            ),
          ],
        ),
      ),
    );
  }
}
