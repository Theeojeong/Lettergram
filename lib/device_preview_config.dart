import 'package:device_preview/device_preview.dart';

/// Returns the device list with a preferred iPhone "Pro Max" device first.
/// Tries iPhone 15 Pro Max, then 14, then 13. Falls back to the default list.
List<DeviceInfo> preferredDevices() {
  final all = Devices.all;

  DeviceInfo? findByParts(List<String> parts) {
    for (final d in all) {
      final name = d.name.toLowerCase();
      final ok = parts.every((p) => name.contains(p));
      if (ok) return d;
    }
    return null;
  }

  final candidates = const [
    ['iphone', '15', 'pro', 'max'],
    ['iphone', '14', 'pro', 'max'],
    ['iphone', '13', 'pro', 'max'],
  ];

  DeviceInfo? target;
  for (final parts in candidates) {
    target = findByParts(parts);
    if (target != null) break;
  }

  if (target == null) return all;

  final rest = all.where((d) => d.identifier != target!.identifier).toList();
  return [target!, ...rest];
}

