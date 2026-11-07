// Portuguese localizations: all AppLocalizations string overrides for the PT-BR locale
import 'app_localizations_pt_base.dart';
class AppLocalizationsPt extends AppLocalizationsPtBase {
  const AppLocalizationsPt(super.locale);

  @override String get navToday => 'Hoje';
  @override String get navHabits => 'Hábitos';
  @override String get navSettings => 'Ajustes';

  @override String get cancel => 'Cancelar';

  @override String get permFloatingWindow => 'Janela flutuante';
  @override String get permUsageStats => 'Estatísticas de uso';
  @override String get monitoringInactive => 'O visor está parado.';
  @override String get actionStart => 'Iniciar';

  static const _enable = 'Na próxima tela de configuração que vai abrir, habilite o AppTime.';
  @override List<String> get setupWelcome =>
      ['O AppTime mostra seu tempo de hoje em cada app.', 'Sem bloquear nada. Só para você ver.'];
  @override List<String> get setupOverlay => ['O tempo aparece ao lado da câmera.', _enable];
  @override List<String> get setupUsage =>
      ['Para contar, o AppTime vê qual app está aberto.', 'Nada sai do seu celular.', _enable];
  @override List<String> get setupNotifications =>
      ['Uma notificação discreta mostra que o AppTime está ligado.', 'Toque em Permitir.'];
  @override List<String> get setupAutostart =>
      ['Sem isso, o AppTime não volta quando o celular reinicia.', 'Na lista, ache o AppTime e ligue a chave.'];
  @override List<String> get setupBattery => [
        'A economia de bateria pode fechar o AppTime.',
        'Ele gasta pouco: menos de 1% por dia.',
        'Toque em Permitir.',
      ];
  @override List<String> get setupHibernation => [
        'Sem uso, o Android pode tirar as permissões do AppTime.',
        'Na próxima tela de configuração que vai abrir, desligue “Pausar atividade do app”.',
      ];
  @override String get setupAutostartTip => 'Dica: toque na lupa e digite AppTime.';
  @override String get setupReopen => 'Depois, abra o AppTime de novo.';
  @override String get setupRetryEnable => 'De novo, na tela de configuração, habilite o AppTime.';
  @override String get setupRetryAutostart => 'De novo, na lista, ache o AppTime e ligue a chave.';
  @override String get setupRetryHibernation =>
      'De novo, na tela de configuração, desligue “Pausar atividade do app”.';
  @override String get setupAskAutostart => 'Você ligou o AppTime na lista?';
  @override String get setupYesDone => 'Sim, liguei';
  @override String get setupNotYet => 'Ainda não';
  @override String get setupDone => 'Pronto.';
  @override String get onboardStart => 'Começar';
  @override String get setupConfigure => 'Abrir configurações do Android';
  @override String get setupOpenList => 'Abrir lista';
  @override String get continueAction => 'Continuar';
  @override String get setupLater => 'Depois';
  @override String setupProgress(int step, int total) => '$step de $total';
  @override String get setupBanner => 'O contador do AppTime está desligado.';
  @override String get setupRelaunch => 'Religar';
  @override String get setupBannerAutostart => 'Se o celular reiniciar, o contador pode não voltar sozinho.';
  @override String get sectionSetup => 'Funcionamento';
  @override String get setupLabelNotifications => 'Notificações';
  @override String get setupLabelAutostart => 'Início automático';
  @override String get setupLabelBattery => 'Sem economia de bateria';
  @override String get setupLabelHibernation => 'Sem pausa por falta de uso';
  @override String get setupOn => 'Concluído';
  @override String get setupOff => 'Pendente';
  @override String get setupConfirmed => 'Você confirmou';
  @override String get setupAdjust => 'Ajustar';

  @override String get settingsTitle => 'Ajustes';
  @override String get sectionOverlay => 'Visor flutuante';
  @override String get showOverlay => 'Exibir visor de uso';
  @override String get showOverlaySub => 'Mostra o contador flutuante ao usar apps. O monitoramento (coleta de dados) continua independentemente.';
  @override String get overlayStyle => 'Estilo do visor';
  @override String get overlayStylePill => 'Pílula';
  @override String get overlayStyleBlock => 'Bloco';
  @override String get overlayFeedback => 'Comparação com seu habitual';
  @override String get overlayStylePillSub => 'Na barra de status, ao lado da câmera';
  @override String get overlayStyleBlockSub => 'Abaixo da barra de status, letra grande e fundo opaco';
  @override String get overlayStyleTab => 'Aba';
  @override String get overlayStyleTabSub => 'Presa embaixo da barra de status, no centro, letra grande';
  @override String get overlayFeedbackFill => 'Ponto que enche';
  @override String get overlayFeedbackFillSub => 'Um ponto ao lado do tempo vai enchendo até o seu habitual';
  @override String get overlayFeedbackBar => 'Barra';
  @override String get overlayFeedbackBarSub => 'Uma linha embaixo do tempo vai enchendo até o seu habitual';
  @override String get overlayFeedbackOutline => 'Contorno';
  @override String get overlayFeedbackOutlineSub => 'A borda se desenha em volta do tempo e fecha no seu habitual';
  @override String get overlayFeedbackNone => 'Nenhuma';
  @override String get overlayFeedbackNoneSub => 'Só o tempo, sem comparar com o seu habitual';
  @override String get overlayAmber => 'Cores de alerta';
  @override String get overlayAmberSub => 'Desligado: o tempo fica numa cor só; as formas continuam';
  @override String get chipAuto => 'Fundo da pílula: automático';
  @override String get chipLight => 'Fundo da pílula: claro';
  @override String get chipDark => 'Fundo da pílula: escuro';
  @override String get overlayThermometer => 'Termômetro: suas últimas 2 h';
  @override String get overlayThermometerVertical => 'Termômetro vertical';
  @override String get overlayThermometerVerticalSub => 'O líquido sobe e ferve quando hoje passa de ontem até esta hora';
  @override String get overlayThermometerEcg => 'ECG';
  @override String get overlayThermometerEcgSub => 'Uma linha que corre mais rápido e mais alta quando você usa mais';
  @override String get overlayThermometerMao => 'Mão única';
  @override String get overlayThermometerMaoSub => 'Um ▼ que sobe e desce: use menos';
  @override String get overlayThermometerNone => 'Desligado';
  @override String get overlayThermometerNoneSub => 'Sem termômetro';
  @override String fontSize(int size) => 'Tamanho da fonte: ${size}sp';
  @override String get sectionBehavior => 'Comportamento';
  @override String get monitorLauncherTitle => 'Monitorar tela inicial';
  @override String get monitorLauncherSub => 'Mostrar o visor ao voltar para a tela inicial';
  @override String get sectionLanguage => 'Idioma';
  @override String get languageSystem => 'Sistema';
  @override String get languagePtBr => 'Português (Brasil)';
  @override String get languageEn => 'English';

  @override String get noAppsMsg =>
      'Nenhum app registrado nos últimos 7 dias.\n'
      'Inicie o monitoramento e use o celular normalmente.';
  @override String get habitsTitle => 'Hábitos';
  @override String get tab7d => '7 dias';
  @override String get tab30d => '30 dias';
  @override String get periodLead => 'Média por dia';
  @override String periodBelow(String diff, String before, int days) => '$diff abaixo dos $days dias anteriores ($before)';
  @override String periodAbove(String diff, String before, int days) => '$diff acima dos $days dias anteriores ($before)';
  @override String periodSame(String before, int days) => 'Igual aos $days dias anteriores ($before)';
  @override String periodNoBefore(int days) => 'Ainda não há $days dias anteriores para comparar';
  @override String periodLine(int days) => 'linha: os $days dias anteriores';
  @override String periodLinePartial(int measured, int days) => 'linha: $measured dos $days dias anteriores';
  @override String get periodNoHistory => 'Sem histórico para comparar';
  @override String get nightTitle => 'À noite';
  @override String nightText(String avg) => '$avg por noite, entre 22h e 6h';
  @override String get peakLead => 'Hora de maior uso';
  @override String get hourHalf => 'meia hora';
  @override String peakHour(int hour) => '${hour}h';
  @override String peakSentence(String peakMs, double ratio) =>
      '$peakMs em média nessa hora, ${ratio.toStringAsFixed(1).replaceAll('.', ',')}× uma hora comum';
  @override String peakWarmup(int day) => 'Dia $day de 7 · sem horário de pico ainda';
  @override String get peakFlat => 'Seu uso se espalha pelo dia; nenhuma hora se destaca';
  @override String peakHarmMorning(String hour) => 'Uso alto às $hour pode atrasar o começo do que você planejou para o dia.';
  @override String peakHarmAfternoon(String hour) => 'Uso alto às $hour pode picotar em pedaços curtos o tempo de trabalho ou estudo.';
  @override String peakHarmNight(String hour) => 'Uso alto às $hour pode empurrar o sono e o que você planejou para a noite.';
  @override String get weekdayAll => 'Todos';
  @override List<String> get weekdaysShort => const ['seg', 'ter', 'qua', 'qui', 'sex', 'sáb', 'dom'];
  @override String tryThis(String what) => 'Experimente: $what';
  @override String grayscaleTry(String from, String to) => 'tela em escala de cinza das $from às $to';
  @override String grayscaleSteps(String from, String to) =>
      'Ajustes › Bem-estar digital › Modo hora de dormir: ligue a escala de cinza e agende das $from às $to. '
      'O caminho muda um pouco de um celular para outro.';
  @override String get grayscaleEvidence =>
      'Num estudo com 161 estudantes, os 73 que usaram a tela em escala de cinza por 8 a 10 dias '
      'passaram cerca de 38 minutos a menos por dia no celular (Holte & Ferraro, 2020).';
  @override String get grayscaleLimits =>
      'Limites: estudo curto, só com estudantes e sem sorteio dos grupos; a escala de cinza valia o dia '
      'todo, não só no horário de pico.';
  @override String get stepsTitle => 'Como fazer';
  @override String get evidenceTitle => 'O que se sabe';
  @override String get improvingTitle => 'Está melhorando?';
  @override String periodNear(String before, int days) => 'Perto dos $days dias anteriores ($before)';
  @override String get entryTitle => 'Como seu uso começa';
  @override String entrySentence(String app, int percent, int days) => '$app abre $percent% dos seus desbloqueios ($days dias)';
  @override String get entryHarm => 'Se você pega o celular para outra coisa e acaba nele, o caminho pode estar automático.';
  @override String entryTry(String app) => 'tirar $app da tela inicial';
  @override String entrySteps(String app) =>
      'Segure o ícone de $app na tela inicial e toque em Remover (não desinstala): ele continua na gaveta '
      'de apps e na busca. Teste por uma semana, se essas aberturas parecem indesejadas.';
  @override String get entryEvidence =>
      'Num estudo com sorteio (70 estudantes, 2 semanas), quem fez 10 mudanças nos ajustes, entre elas tirar '
      'apps da tela inicial, usou o celular cerca de 57 minutos a menos por dia; quem só monitorou, 11 '
      '(Olson et al., 2022).';
  @override String get entryLimits =>
      'Limites: o efeito é do pacote de 10 mudanças, não desta sozinha; estudo pequeno, numa só universidade.';




  // Today and per app
  @override String get todayLead => 'Hoje até agora';
  @override String todayWarmup(int day) => 'Dia $day de 7 · sem comparação ainda';
  @override String get usualBarely => 'Quase sem uso nos últimos 30 dias';
  @override String usualBelow(String under, String usual, {bool inApp = false}) =>
      'Sua média${inApp ? ' neste app' : ''} é $usual por dia. Hoje, $under a menos até agora.';
  @override String usualNear(String usual, {bool inApp = false}) =>
      'Perto da sua média${inApp ? ' neste app' : ''}, $usual por dia.';
  @override String usualPast(String over, String usual, {bool inApp = false}) =>
      'Sua média${inApp ? ' neste app' : ''} é $usual por dia. Hoje, $over a mais até agora.';
  @override String usualPastRow(String over, String usual) => '$over acima da média ($usual por dia)';
  @override String recentUse(String recent) => 'Últimas 2 h: $recent de uso do celular';
  @override String recentNonstop(String recent) => 'Últimas 2 h: $recent de uso do celular, quase sem pausa';
  @override String get todayAppsTitle => 'O que puxou o dia';
  @override String get todayNoApps => 'Nenhum app passou de 1 minuto hoje.';
  @override String get appOverlayTitle => 'Visor neste app';
  @override String get appsTitle => 'Apps';
  @override String get appsSub => 'Quais apps contam e mostram o visor';
  @override String get appMonitor => 'Monitorar este app';
  @override String get appMonitorSub => 'Desligado, não conta no total nem mostra o visor';
  @override String get pillBackground => 'Fundo da pílula';
  @override String appsShowAll(int quiet) => 'Mostrar todos ($quiet com menos de 1 min)';
}
