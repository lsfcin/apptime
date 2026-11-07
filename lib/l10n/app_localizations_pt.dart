// Portuguese localizations: all AppLocalizations string overrides for the PT-BR locale
import 'app_localizations_pt_base.dart';
class AppLocalizationsPt extends AppLocalizationsPtBase {
  const AppLocalizationsPt(super.locale);

  @override String get navToday => 'Hoje';
  @override String get navAnalysis => 'Análise';
  @override String get navSettings => 'Ajustes';

  @override String get cancel => 'Cancelar';
  @override String get noData => 'Sem dados ainda.';
  @override String get collectingData => 'Coletando dados — volte mais tarde.';

  @override String get permFloatingWindow => 'Janela flutuante';
  @override String get permUsageStats => 'Estatísticas de uso';
  @override String get monitoringActive => 'Ativo — contador mostrando uso em tempo real.';
  @override String get monitoringInactive => 'Inativo. Toque em Iniciar.';
  @override String get monitoringNoPerms => 'Conceda as permissões acima para iniciar.';
  @override String get monitoringDesc =>
      'O visor exibe o tempo de hoje no app aberto.';
  @override String get actionStart => 'Iniciar';
  @override String get actionStop => 'Parar';

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
  @override String get sectionMonitoring => 'Monitoramento';
  @override String get sectionOverlay => 'Visor flutuante';
  @override String get showOverlay => 'Exibir visor de uso';
  @override String get showOverlaySub => 'Mostra o contador flutuante ao usar apps. O monitoramento (coleta de dados) continua independentemente.';
  @override String get overlayStyle => 'Estilo do visor';
  @override String get overlayStylePill => 'Pílula';
  @override String get overlayStyleBlock => 'Bloco';
  @override String get overlayFeedback => 'Comparação com seu habitual';
  @override String get overlayStylePillSub => 'Na barra de status, ao lado da câmera';
  @override String get overlayStyleBlockSub => 'Abaixo da barra de status, letra grande e fundo opaco';
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
  @override String get overlayThermometer => 'Termômetro: as últimas 2 h vs o seu ritmo';
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
  @override String get perAppControlTitle => 'Definições por app';
  @override String get monitorLauncherTitle => 'Monitorar tela inicial';
  @override String get monitorLauncherSub => 'Mostrar o visor ao voltar para a tela inicial';
  @override String get sectionLanguage => 'Idioma';
  @override String get languageSystem => 'Sistema';
  @override String get languagePtBr => 'Português (Brasil)';
  @override String get languageEn => 'English';

  @override String get noAppsMsg =>
      'Nenhum app registrado nos últimos 7 dias.\n'
      'Inicie o monitoramento e use o celular normalmente.';
  @override String get trendIdealLabel => '2h ideal';
  @override String get trendCriticalLabel => '4h crítico';
  @override String get analysisTitle => 'Análise';
  @override String get tab7d => '7 dias';
  @override String get tab30d => '30 dias';
  @override String get statTotalUsage => 'Uso total';
  @override String get statUnlocks => 'Desbloqueios';
  @override String get dailyUsageLabel => 'Uso diário';
  @override String get passive => 'Passivo';
  @override String get active => 'Ativo';
  @override String get prevWeekLabel => 'semana anterior';

  @override String get blockDopamineTitle => 'Dreno de dopamina';
  @override String blockDopamineText(String app, int opens) =>
      'O app "$app" foi seu maior gatilho: $opens aberturas em 7 dias. '
      'Apps de scroll infinito são projetados como "caça-níqueis" — '
      'recompensa intermitente que cria ciclos compulsivos difíceis de quebrar.';
  @override String get blockDopamineNoData => 'Nenhum dado ainda.';
  @override String get blockEngagementTitle => 'Balanço de engajamento';
  @override String blockEngagementText(int pct) =>
      'Seu uso foi $pct% passivo no período. '
      'O consumo passivo de feed (sem interagir) está ligado a ruminação '
      'e sintomas de depressão, enquanto o uso ativo (mensagens reais) '
      'pode ter efeito protetor na saúde mental.';
  @override String get blockEngagementNoData => 'Sem dados ainda.';
  @override String get blockEngagementClassification =>
      'Passivo: redes sociais, vídeo, notícias.\nAtivo: todos os demais.';
  @override String get blockTrendTitle => 'Tendência semanal';
  @override String blockTrendReduced(int pct) =>
      'Você reduziu seu uso em $pct% vs. a semana anterior. '
      'Manter essa tendência por 21 dias é o marco científico '
      'para a reformulação de hábitos neurais.';
  @override String blockTrendIncreased(int pct) =>
      'Seu uso aumentou $pct% vs. a semana anterior. '
      'Tente identificar os gatilhos que levaram ao aumento.';
  @override String get yesterdayPatternOther => 'outros';
  @override String get blockLastDaysPatternTitle => 'Padrão dos últimos 7 dias';
  @override String get blockLastDaysPatternText =>
      'Barras horizontais empilhadas — cada linha é uma hora, agrupada por dia. '
      'Toque no ícone de zoom para alternar entre visão de 2,5 dias e semana completa.';


  @override String blockSummaryTitle(String period) => 'Visão geral — $period';
  @override String get block30dChartTitle => 'Tendência de uso — 30 dias';
  @override String get block30dChartText =>
      'Tempo de tela total por dia (linha branca grossa) com tendência linear (cinza tracejado). '
      'Os 3 apps mais usados aparecem como linhas coloridas finas. '
      'Limiares: 2h recomendado (APA/Common Sense Media) e '
      '4h crítico — Twenge et al. (2018), "Increases in Depressive Symptoms", '
      'Clinical Psychological Science.';

  // Today and per app
  @override String get todayLead => 'Hoje até agora';
  @override String todayWarmup(int day) => 'Dia $day de 7 · sem comparação ainda';
  @override String get usualBarely => 'Quase sem uso nos últimos 30 dias';
  @override String usualCalm(String usual) => 'Seu dia normal: $usual';
  @override String usualNear(String usual) => 'Perto do seu dia normal ($usual)';
  @override String usualPast(String over, String usual) => '$over acima do seu dia normal ($usual)';
  @override String paceCalm(String recent, String pace) => 'Últimas 2 h: $recent · seu ritmo: $pace';
  @override String paceAbove(String recent, String pace) => 'Últimas 2 h: $recent, acima do seu ritmo ($pace)';
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
