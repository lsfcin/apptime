// Portuguese analytics block strings (block*, goal*, data/privacy section)
part of 'app_localizations_pt.dart';

mixin _PtAnalyticsMixin on AppLocalizations {
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

  @override String get block30dSummaryTitle => 'Visão geral — 30 dias';
  @override String get block30dChartTitle => 'Tendência de uso — 30 dias';
  @override String get block30dChartText =>
      'Tempo de tela total por dia (linha branca grossa) com tendência linear (cinza tracejado). '
      'Os 3 apps mais usados aparecem como linhas coloridas finas. '
      'Limiares: 2h recomendado (APA/Common Sense Media) e '
      '4h crítico — Twenge et al. (2018), "Increases in Depressive Symptoms", '
      'Clinical Psychological Science.';

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
