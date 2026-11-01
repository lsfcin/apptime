// "Your usual": mean daily total over the 30 complete days before today, zero-use days included
import '../utils/index.dart';

/// Days in the rolling window behind "your usual".
const kUsualWindowDays = 30;

/// Stand-in for a day nothing was measured (before install, or the service was down).
const kUsualSeedMs = 60 * 60 * 1000;

/// The mean and how many of the window's days were measured rather than seeded.
typedef Usual = ({int meanMs, int realDays});

/// Mean of [dailyMs] over the [kUsualWindowDays] days before [today] (a 04:00-anchored date).
/// A day counts as measured when [deviceDailyMs] saw any phone use; a measured day with no use
/// of this app counts as zero, because not opening an app can be a choice. Unmeasured days
/// count as [kUsualSeedMs]. Pass [deviceDailyMs] as [dailyMs] for the whole phone.
Usual usualDaily({
  required DateTime today,
  required int Function(String date) dailyMs,
  required int Function(String date) deviceDailyMs,
}) {
  var totalMs = 0;
  var realDays = 0;
  for (var back = 1; back <= kUsualWindowDays; back++) {
    final date = fmtDate(today.subtract(Duration(days: back)));
    if (deviceDailyMs(date) > 0) {
      totalMs += dailyMs(date);
      realDays++;
    } else {
      totalMs += kUsualSeedMs;
    }
  }
  return (meanMs: totalMs ~/ kUsualWindowDays, realDays: realDays);
}

/// Where today's total sits against the usual: calm until 80% of the mean (or 2 minutes before
/// it, whichever comes first), near up to the mean, past above it. No use at all is always calm.
enum UsualState { calm, near, past }

const _kNearFraction = 0.8;
const _kNearSlackMs = 2 * 60 * 1000;
const _kLowMeanMs = 5 * 60 * 1000;
const _kLowMeanGraceMs = 60 * 1000;

UsualState usualState({required int todayMs, required int meanMs}) {
  if (todayMs <= 0) return UsualState.calm;
  final pastAt = meanMs < _kLowMeanMs ? meanMs + _kLowMeanGraceMs : meanMs;
  if (todayMs > pastAt) return UsualState.past;
  final byFraction = (meanMs * _kNearFraction).round();
  final bySlack = meanMs - _kNearSlackMs;
  if (todayMs >= (byFraction < bySlack ? byFraction : bySlack)) return UsualState.near;
  return UsualState.calm;
}
