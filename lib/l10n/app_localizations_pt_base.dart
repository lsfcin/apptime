// AppLocalizationsPtBase: Data/Privacy string implementations for PT-BR
import 'app_localizations.dart';

abstract class AppLocalizationsPtBase extends AppLocalizations {
  const AppLocalizationsPtBase(super.locale);


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
