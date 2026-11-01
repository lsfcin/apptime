// Insight content registry — awareness cards (kAlertas) and solution cards (kSolucoes)
import 'package:flutter/material.dart';
import '../screens/insights/index.dart';

part 'insight_alertas_1.dart';
part 'insight_alertas_2.dart';
part 'insight_alertas_3.dart';
part 'insight_solucoes_1.dart';
part 'insight_solucoes_2.dart';
part 'insight_solucoes_3.dart';

class InsightCardEntry {
  const InsightCardEntry({
    required this.icon,
    required this.title,
    required this.body,
    required this.reference,
    required this.url,
    required this.analysisFn,
    this.titleEn,
    this.bodyEn,
    this.analysisFnEn,
  });

  final IconData icon;
  final String title;
  final String body;
  final String reference;
  final String url;
  final String Function(InsightData) analysisFn;
  final String? titleEn;
  final String? bodyEn;
  final String Function(InsightData)? analysisFnEn;
}

final kAlertas = <InsightCardEntry>[..._kAlertasA, ..._kAlertasB, ..._kAlertasC];
final kSolucoes = <InsightCardEntry>[..._kSolucoesA, ..._kSolucoesB, ..._kSolucoesC];
