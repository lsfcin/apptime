// AppLocalizationsPtBase: GoalScreen and Data/Privacy string implementations for PT-BR
import 'package:flutter/material.dart';
import 'app_localizations.dart';

abstract class AppLocalizationsPtBase extends AppLocalizations {
  const AppLocalizationsPtBase(Locale locale) : super(locale);

  @override String get goalScreenTitle => 'Consciência do uso';
  @override String get goalLevelSectionTitle => 'Mensagens para consciência do uso';
  @override String get goalLevelSectionCaption =>
      'Escolha com que frequência você recebe mensagens personalizadas sobre '
      'seus padrões de uso. Nada é bloqueado — as mensagens são apenas para reflexão.';
  @override String get goalLevelNone => 'Desligado';
  @override String get goalLevelMinimal => 'Ocasional';
  @override String get goalLevelNormal => 'Regular';
  @override String get goalLevelExtensive => 'Frequente';
  @override String get goalRationaleNone =>
      'Sem mensagens — apenas o contador no visor. Ideal para observar seus '
      'padrões sem nenhuma interrupção.';
  @override String get goalRationaleMinimal =>
      'Limites tolerantes — mensagens aparecem só quando os limites são bem '
      'ultrapassados. Bom para se manter consciente com pouca interrupção.';
  @override String get goalRationaleNormal =>
      'Limites moderados — lembretes periódicos ao atingir os limites. '
      'Alinhado com recomendações de especialistas em saúde digital.';
  @override String get goalRationaleExtensive =>
      'Limites rigorosos — mensagens frequentes assim que os limites são atingidos. '
      'Recomendado para reduzir ativamente o tempo de tela.';
  @override String get goalOverrideGlobal => 'Global';
  @override String get goalSettingsTile => 'Consciência do uso';
  @override String get goalSettingsSub => 'Frequência de mensagens e limites por app';

  @override String get sectionData => 'Dados e privacidade';
  @override String get deleteAllDataTitle => 'Apagar todos os dados';
  @override String get deleteAllDataSub => 'Remove permanentemente todo o histórico de uso deste dispositivo';
  @override String get deleteAllDataConfirm => 'Apagar todo o histórico de uso? Esta ação não pode ser desfeita.';
  @override String get deleteAllDataDone => 'Todos os dados foram apagados.';
  @override String get privacyPolicyTitle => 'Política de privacidade';
  @override String get privacyPolicySub => 'Todos os dados ficam no dispositivo — sem rede, sem terceiros';
  @override String get disclaimerTitle => 'Aviso legal';
  @override String get disclaimerBody =>
      'O AppTime é para fins informativos e de produtividade. '
      'Não é um dispositivo ou tratamento médico. '
      'O conteúdo é baseado em pesquisas publicadas e não substitui orientação profissional.';
}
