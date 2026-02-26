import 'package:haptic_feedback/haptic_feedback.dart';

class HapticService {
  Future<void> success() async {
    if (await Haptics.canVibrate()) {
      await Haptics.vibrate(HapticsType.success);
    }
  }

  Future<void> error() async {
    if (await Haptics.canVibrate()) {
      await Haptics.vibrate(HapticsType.error);
    }
  }

  Future<void> selection() async {
    if (await Haptics.canVibrate()) {
      await Haptics.vibrate(HapticsType.selection);
    }
  }

  Future<void> light() async {
    if (await Haptics.canVibrate()) {
      await Haptics.vibrate(HapticsType.light);
    }
  }

  Future<void> warning() async {
    if (await Haptics.canVibrate()) {
      await Haptics.vibrate(HapticsType.warning);
    }
  }
}
