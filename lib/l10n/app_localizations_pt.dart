// Portuguese localizations: all AppLocalizations string overrides for the PT-BR locale
import 'app_localizations_pt_base.dart';
class AppLocalizationsPt extends AppLocalizationsPtBase {
  const AppLocalizationsPt(super.locale);

  @override String get navAnalysis => 'Análise';
  @override String get navInsights => 'Insights';
  @override String get navMonitoring => 'Monit.';
  @override String get navSettings => 'Ajustes';

  @override String get cancel => 'Cancelar';
  @override String get save => 'Salvar';
  @override String get noData => 'Sem dados ainda.';
  @override String get collectingData => 'Coletando dados — volte mais tarde.';

  @override String get permFloatingWindow => 'Janela flutuante';
  @override String get permUsageStats => 'Estatísticas de uso';
  @override String get insightOfDay => 'Insight do dia';
  @override String get insightViewSource => 'Ver fonte';
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
  @override String get setupReopen => 'Se cair na tela inicial, abra o AppTime de novo.';
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
  @override String get showBorder => 'Mostrar borda';
  @override String get showBackground => 'Mostrar fundo';
  @override String fontSize(int size) => 'Tamanho da fonte: ${size}sp';
  @override String get sectionBehavior => 'Comportamento';
  @override String get perAppControlTitle => 'Definições por app';
  @override String get perAppUsageCaption => 'O uso exibido é o total dos últimos 7 dias';
  @override String get levelChipOff => 'desl.';
  @override String get levelChipDefault => 'padrão';
  @override String get levelChipMin => 'mín.';
  @override String get levelChipMax => 'máx.';
  @override String get levelMenuNotMonitored => 'não monitorado';
  @override String get levelMenuDefault => 'padrão (config. geral)';
  @override String get levelMenuMinimal => 'ocasional';
  @override String get levelMenuNormal => 'regular';
  @override String get levelMenuExtensive => 'frequente';
  @override String get perAppControlSub => 'Configurar monitoramento individualmente por app';
  @override String get monitorLauncherTitle => 'Monitorar tela inicial';
  @override String get monitorLauncherSub => 'Mostrar o visor ao voltar para a tela inicial';
  @override String get sectionLanguage => 'Idioma';
  @override String get languageSystem => 'Sistema';
  @override String get languagePtBr => 'Português (Brasil)';
  @override String get languageEn => 'English';

  @override String get perAppTitle => 'Controle por app';
  @override String get noAppsMsg =>
      'Nenhum app registrado nos últimos 7 dias.\n'
      'Inicie o monitoramento e use o celular normalmente.';
  @override String get trendIdealLabel => '2h ideal';
  @override String get trendCriticalLabel => '4h crítico';
  @override String get analysisTitle => 'Análise';
  @override String get tab1d => '1 dia';
  @override String get tab7d => '7 dias';
  @override String get tab30d => '30 dias';
  @override String get dayBoundaryNote =>
      'O "dia" começa às 4h da manhã — uso entre 0h e 4h é contado no dia anterior.';
  @override String get statTotalUsage => 'Uso total';
  @override String get statUnlocks => 'Desbloqueios';
  @override String get statYesterday => 'ontem';
  @override String get statTotalTime => 'Tempo total';
  @override String get noSessions => 'Nenhuma sessão registrada ainda.';
  @override String get dailyUsageLabel => 'Uso diário';
  @override String get passive => 'Passivo';
  @override String get active => 'Ativo';
  @override String get prevWeekLabel => 'semana anterior';
  @override String pagesLabel(int n) => '$n páginas';
  @override String kmLabel(int n) => '${n}km';
  @override String sleepCyclesLabel(int n) => '$n ciclos';

  @override String get blockSleepTitle => 'Higiene do sono';
  @override String blockSleepText(int pct) =>
      'Seu uso entre 22h e 6h representa $pct% do tempo total. '
      'A luz azul nesse período pode atrasar a secreção de melatonina '
      'em até 30 minutos, prejudicando a fase REM do sono.';
  @override String get blockImpulsivityTitle => 'Índice de impulsividade';
  @override String blockImpulsivityText(int unlocks) =>
      'Você desbloqueou o celular $unlocks vezes hoje. '
      'A frequência de desbloqueios é um preditor mais forte de ansiedade '
      'e baixa qualidade de sono do que o tempo total de tela.';
  @override String get blockFocusTitle => 'Fragmentação do foco';
  @override String blockFocusText(int pct) =>
      '$pct% das suas sessões duraram menos de 60 segundos. '
      'Esse "hábito de checar" fragmenta a atenção e impede o estado de '
      'foco profundo (Flow). Usuários com alta fragmentação levam até 20% '
      'mais tempo para completar tarefas complexas.';
  @override String get blockOpportunityTitle => 'Custo de oportunidade';
  @override String get blockOpportunityText =>
      'Cada hora de uso passivo é uma hora que poderia ser '
      'dedicada a sono reparador, exercício ou conexão presencial.';
  @override String get blockPhubbingTitle => 'Alerta de phubbing';
  @override String blockPhubbingText(int unlocks) =>
      'Você desbloqueou o celular $unlocks vezes nos horários de '
      'almoço e jantar. O phubbing — ignorar quem está presente para '
      'olhar o celular — enfraquece laços sociais e aumenta sentimentos '
      'de solidão a longo prazo.';
  @override String get blockDopamineTitle => 'Dreno de dopamina';
  @override String blockDopamineText(String app, int opens) =>
      'O app "$app" foi seu maior gatilho: $opens aberturas em 7 dias. '
      'Apps de scroll infinito são projetados como "caça-níqueis" — '
      'recompensa intermitente que cria ciclos compulsivos difíceis de quebrar.';
  @override String get blockDopamineNoData => 'Nenhum dado ainda.';
  @override String get blockEngagementTitle => 'Balanço de engajamento';
  @override String blockEngagementText(int pct) =>
      'Seu uso foi $pct% passivo esta semana. '
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
  @override String get blockTrend30Title => 'Tendência 30 dias';
  @override String get blockTrend30Text =>
      'Manter uma tendência de queda por 21 dias consecutivos é '
      'o marco científico para a reformulação de circuitos de hábito '
      'e fortalecimento do córtex pré-frontal.';
  @override String get blockWeekPatternTitle => 'Padrão semanal';
  @override String get blockWeekPatternText =>
      'Uso médio por hora para cada dia da semana (últimas 4 semanas). '
      'Cada barra horizontal representa 60 minutos; a parte preenchida '
      'indica o tempo usado, empilhado por app.';
  @override String get weekdayOtherLabel => 'outros';
  @override String get blockYesterdayPatternTitle => 'Padrão de ontem';
  @override String get blockYesterdayPatternText =>
      'Barras horizontais empilhadas por app — cada linha é uma hora do dia de ontem.';
  @override String get yesterdayPatternOther => 'outros';
  @override String get blockLastDaysPatternTitle => 'Padrão dos últimos 7 dias';
  @override String get blockLastDaysPatternText =>
      'Barras horizontais empilhadas — cada linha é uma hora, agrupada por dia. '
      'Toque no ícone de zoom para alternar entre visão de 2,5 dias e semana completa.';
  @override String get statLast7Days => 'Relativo aos últimos 7 dias';

  @override String get insightsTitle => 'Insights';
  @override String get tabAlerts => 'Alertas';
  @override String get tabSolutions => 'Soluções';

  @override String get block30dSummaryTitle => 'Visão geral — 30 dias';
  @override String get block30dChartTitle => 'Tendência de uso — 30 dias';
  @override String get block30dChartText =>
      'Tempo de tela total por dia (linha branca grossa) com tendência linear (cinza tracejado). '
      'Os 3 apps mais usados aparecem como linhas coloridas finas. '
      'Limiares: 2h recomendado (APA/Common Sense Media) e '
      '4h crítico — Twenge et al. (2018), "Increases in Depressive Symptoms", '
      'Clinical Psychological Science.';

}
