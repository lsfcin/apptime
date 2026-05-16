// Research-backed smartphone insight entries (50 entries, PT-BR + EN)
part 'insights_sleep_dopamine.dart';
part 'insights_attention_productivity.dart';
part 'insights_exercise_social.dart';
part 'insights_neuro_wellbeing.dart';
part 'insights_data_1.dart';
part 'insights_data_2.dart';

class InsightEntry {
  final String text;
  final String textEn;
  final String url;
  const InsightEntry(this.text, this.textEn, this.url);
}

/// 50 insights about smartphone use based on peer-reviewed research.
/// Each entry has PT-BR (text) and EN (textEn) versions.
const List<InsightEntry> kInsights = [..._kInsights1, ..._kInsights2];
