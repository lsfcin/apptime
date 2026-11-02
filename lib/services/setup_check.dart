// SetupCheck: which of the six system settings AppTime needs are on, and how to open each
import 'service_channel.dart';
import 'storage_service.dart';

/// In the order the setup flow asks for them.
enum SetupItem { overlay, usage, notifications, autostart, battery, hibernation }

class SetupCheck {
  const SetupCheck({
    required this.state,
    required this.autostartScreen,
    required this.autostartConfirmed,
  });

  /// Null only for autostart when the device hides its state.
  final Map<SetupItem, bool?> state;

  /// "miui", "other", or null when the device has no autostart switch.
  final String? autostartScreen;
  final bool autostartConfirmed;

  factory SetupCheck.fromStatus({
    required bool overlay,
    required bool usage,
    required Map<Object?, Object?> background,
    required bool autostartConfirmed,
  }) {
    final screen = background['autostartScreen'] as String?;
    return SetupCheck(
      autostartScreen: screen,
      autostartConfirmed: autostartConfirmed,
      state: {
        SetupItem.overlay: overlay,
        SetupItem.usage: usage,
        SetupItem.notifications: background['notificationsOn'] as bool? ?? false,
        if (screen != null) SetupItem.autostart: background['autostartAllowed'] as bool?,
        SetupItem.battery: background['batteryExempt'] as bool? ?? false,
        SetupItem.hibernation: background['hibernationExempt'] as bool? ?? true,
      },
    );
  }

  static Future<SetupCheck> load(StorageService storage) async {
    final results = await Future.wait([
      ServiceChannel.hasOverlayPermission(),
      ServiceChannel.hasUsagePermission(),
      ServiceChannel.getBackgroundStatus(),
    ]);
    return SetupCheck.fromStatus(
      overlay: results[0] as bool,
      usage: results[1] as bool,
      background: results[2] as Map<Object?, Object?>,
      autostartConfirmed: storage.autostartConfirmed,
    );
  }

  /// Items this device has, in flow order.
  List<SetupItem> get items => SetupItem.values.where(state.containsKey).toList();

  /// True, false, or — for an unreadable autostart — the user's own confirmation.
  bool isOn(SetupItem item) => state[item] ?? autostartConfirmed;

  /// The user only confirmed it; nothing verified it.
  bool isConfirmedOnly(SetupItem item) => state.containsKey(item) && state[item] == null;

  List<SetupItem> get missing => items.where((i) => !isOn(i)).toList();

  /// What stops the timer: the two permissions, and autostart once known to be off.
  bool get broken =>
      !isOn(SetupItem.overlay) || !isOn(SetupItem.usage) || state[SetupItem.autostart] == false;

  static Future<void> open(SetupItem item) => switch (item) {
        SetupItem.overlay => ServiceChannel.requestOverlayPermission(),
        SetupItem.usage => ServiceChannel.requestUsagePermission(),
        SetupItem.notifications => ServiceChannel.requestNotifications(),
        SetupItem.autostart => ServiceChannel.openAutostartSettings(),
        SetupItem.battery => ServiceChannel.requestIgnoreBatteryOptimizations(),
        SetupItem.hibernation => ServiceChannel.openHibernationSettings(),
      };

  /// Without these the timer cannot run: the flow offers no "Depois".
  static bool isRequired(SetupItem item) => item == SetupItem.overlay || item == SetupItem.usage;
}
