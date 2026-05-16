// Alertas cards 1-10
part of 'insight_content.dart';

final _kAlertasA = <InsightEntry>[
  InsightEntry(
    icon: Icons.timer_outlined,
    title: 'A regra dos 23 minutos',
    titleEn: 'The 23-Minute Rule',
    body: 'Após uma única interrupção por notificação, o cérebro leva em média '
        '23 minutos e 15 segundos para retomar o foco profundo na tarefa original.',
    bodyEn: 'After a single notification interruption, the brain takes an average of '
        '23 minutes and 15 seconds to resume deep focus on the original task.',
    reference: 'Gloria Mark, UCI — Cost of Interrupted Work',
    url: 'https://www.ics.uci.edu/~gmark/chi08-mark.pdf',
    analysisFn: (d) => d.hasData
        ? 'você pegou o celular ~${d.workUnlocks} vezes entre 9h–18h na semana passada — cada uma custa 23 min de refoco'
        : 'registre uso por alguns dias para ver quantas interrupções você acumula no trabalho',
    analysisFnEn: (d) => d.hasData
        ? 'you picked up your phone ~${d.workUnlocks} times between 9am–6pm last week — each one costs 23 min of refocus'
        : 'record use for a few days to see how many work interruptions you accumulate',
  ),
  InsightEntry(
    icon: Icons.psychology_outlined,
    title: 'Queda temporária de QI',
    titleEn: 'Temporary IQ Drop',
    body: 'A multitarefa digital pode reduzir o QI funcional em 10 pontos — '
        'um impacto cognitivo maior do que perder uma noite inteira de sono.',
    bodyEn: 'Digital multitasking can reduce functional IQ by 10 points — '
        'a greater cognitive impact than losing an entire night of sleep.',
    reference: 'American Psychological Association — Multitasking Research',
    url: 'https://www.apa.org/research/action/multitask',
    analysisFn: (d) => d.hasData
        ? '${d.microSessions} das suas sessões na semana passada duraram menos de 1 min — puro custo de multitarefa'
        : 'use o app por alguns dias para ver quantas sessões breves você acumula',
    analysisFnEn: (d) => d.hasData
        ? '${d.microSessions} of your sessions last week lasted under 1 min — pure multitasking cost'
        : 'use the app for a few days to see how many brief sessions you accumulate',
  ),
  InsightEntry(
    icon: Icons.hourglass_empty_outlined,
    title: 'Erosão da atenção',
    titleEn: 'Attention Erosion',
    body: 'Nos últimos 20 anos, o tempo médio de atenção em uma tarefa digital '
        'caiu de 150 segundos para apenas 47 segundos.',
    bodyEn: 'Over the last 20 years, the average attention span on a digital task '
        'has fallen from 150 seconds to just 47 seconds.',
    reference: 'Dr. Gloria Mark (2023) — Attention Span Data',
    url: 'https://www.penguinrandomhouse.com/books/706203/attention-span-by-gloria-mark/',
    analysisFn: (d) => d.hasData
        ? 'você usou o celular em média ${d.avgDailyMin} min/dia na semana passada — cada sessão curta fragmenta mais a atenção'
        : 'registre alguns dias de uso para ver sua duração média de sessões',
    analysisFnEn: (d) => d.hasData
        ? 'you used your phone an average of ${d.avgDailyMin} min/day last week — each short session fragments attention further'
        : 'record a few days of use to see your average session duration',
  ),
  InsightEntry(
    icon: Icons.trending_down_outlined,
    title: 'Dreno de produtividade',
    titleEn: 'Productivity Drain',
    body: 'Alternar entre apps e trabalho pode consumir até 40% do seu tempo '
        'produtivo devido à carga cognitiva da reorientação mental.',
    bodyEn: 'Switching between apps and work can consume up to 40% of your '
        'productive time due to the cognitive load of mental reorientation.',
    reference: 'Rubinstein, Meyer & Evans (2001) — Task-Switching Study',
    url: 'https://doi.org/10.1037/0096-3445.130.2.211',
    analysisFn: (d) => d.hasData
        ? 'você desbloqueou o celular ~${d.workUnlocks} vezes no horário de trabalho (9h–18h) na semana passada'
        : 'use o app em dias úteis para ver quantas vezes o celular interrompe seu trabalho',
    analysisFnEn: (d) => d.hasData
        ? 'you unlocked your phone ~${d.workUnlocks} times during work hours (9am–6pm) last week'
        : 'use the app on weekdays to see how often the phone interrupts your work',
  ),
  InsightEntry(
    icon: Icons.bedtime_outlined,
    title: 'Atraso da melatonina',
    titleEn: 'Melatonin Delay',
    body: 'Usar telas antes de dormir pode atrasar a liberação de melatonina '
        'em até 30 minutos, prejudicando a capacidade de recuperação cerebral.',
    bodyEn: 'Using screens before sleep can delay melatonin release by up to '
        '30 minutes, impairing the brain\'s recovery capacity.',
    reference: 'Frontiers in Psychiatry — Digital Nudge Study, 2025',
    url: 'https://www.frontiersin.org/journals/psychiatry',
    analysisFn: (d) => d.hasData
        ? 'você ficou ${d.lateNightMin} min na tela após as 22h na semana passada'
        : 'registre uso noturno para ver quanto do seu sono está sendo afetado',
    analysisFnEn: (d) => d.hasData
        ? 'you spent ${d.lateNightMin} min on screen after 10pm last week'
        : 'track nighttime use to see how much of your sleep is being affected',
  ),
  InsightEntry(
    icon: Icons.alarm_outlined,
    title: 'Acordar estressado',
    titleEn: 'Waking Up Stressed',
    body: 'Checar o celular nos primeiros 5 minutos após acordar coloca o '
        'cérebro em estado de alto cortisol antes mesmo de sair da cama.',
    bodyEn: 'Checking your phone within the first 5 minutes of waking puts the '
        'brain in a high-cortisol state before you even get out of bed.',
    reference: 'Mindfulness and Digital Distraction Study',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=smartphone+cortisol+morning',
    analysisFn: (d) => d.hasData
        ? 'você desbloqueou ${d.earlyUnlocks} vezes antes das 8h na semana passada'
        : 'registre seu uso matinal para ver como você começa os dias',
    analysisFnEn: (d) => d.hasData
        ? 'you unlocked ${d.earlyUnlocks} times before 8am last week'
        : 'track your morning use to see how your days start',
  ),
  InsightEntry(
    icon: Icons.airline_seat_flat_outlined,
    title: 'Perda de sono REM',
    titleEn: 'REM Sleep Loss',
    body: 'Pessoas que usam redes sociais na cama perdem em média 16 minutos '
        'de sono por noite devido à superestimulação cognitiva e à luz azul.',
    bodyEn: 'People who use social media in bed lose an average of 16 minutes '
        'of sleep per night due to cognitive overstimulation and blue light.',
    reference: 'University of Wisconsin-Madison Attention Research',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=social+media+REM+sleep+loss',
    analysisFn: (d) => d.hasData
        ? '${d.lateNightMin} min do seu tempo de tela semanal aconteceu após as 22h'
        : 'use o app para rastrear quanto do seu uso cai no horário de sono',
    analysisFnEn: (d) => d.hasData
        ? '${d.lateNightMin} min of your weekly screen time happened after 10pm'
        : 'use the app to track how much of your usage falls during sleep time',
  ),
  InsightEntry(
    icon: Icons.schedule_outlined,
    title: 'Duração do sono',
    titleEn: 'Sleep Duration',
    body: 'Uso intenso do smartphone (mais de 63h por semana) está diretamente '
        'ligado a uma redução de 6,66 minutos no descanso noturno total.',
    bodyEn: 'Intense smartphone use (more than 63h per week) is directly '
        'linked to a 6.66-minute reduction in total nightly rest.',
    reference: 'Journal of Medical Internet Research, 2025',
    url: 'https://www.jmir.org',
    analysisFn: (d) => d.hasData
        ? 'sua média foi ${d.avgDailyMin} min/dia (${(d.weeklyMin / 60).toStringAsFixed(0)}h na semana) — acima de 63h/semana há risco clínico'
        : 'registre uso por uma semana para comparar com o limite de risco',
    analysisFnEn: (d) => d.hasData
        ? 'your average was ${d.avgDailyMin} min/day (${(d.weeklyMin / 60).toStringAsFixed(0)}h this week) — above 63h/week there is clinical risk'
        : 'record use for a week to compare with the risk threshold',
  ),
  InsightEntry(
    icon: Icons.autorenew_outlined,
    title: 'O ciclo da ansiedade',
    titleEn: 'The Anxiety Cycle',
    body: 'Checar notificações com frequência cria um ciclo de "recompensa '
        'intermitente" semelhante às caça-níqueis, condicionando o cérebro a '
        'buscar constantemente o próximo pico de dopamina.',
    bodyEn: 'Frequently checking notifications creates an "intermittent reward" '
        'cycle similar to slot machines, conditioning the brain to constantly '
        'seek the next dopamine spike.',
    reference: 'Psychology of Phone Addiction Research',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=smartphone+intermittent+reinforcement+dopamine',
    analysisFn: (d) => d.hasData
        ? 'você desbloqueou ${d.todayUnlocks}× hoje — média de ${d.weeklyUnlocks ~/ 7}/dia na semana passada'
        : 'registre uso hoje para ver quantas vezes você busca essa recompensa',
    analysisFnEn: (d) => d.hasData
        ? 'you unlocked ${d.todayUnlocks}× today — average of ${d.weeklyUnlocks ~/ 7}/day last week'
        : 'record use today to see how often you seek that reward',
  ),
  InsightEntry(
    icon: Icons.lock_open_outlined,
    title: 'O custo de desbloquear',
    titleEn: 'The Cost of Unlocking',
    body: 'Cada vez que você desbloqueia o celular sem um objetivo claro, '
        'reforça vias neurais impulsivas que dificultam a manutenção do foco '
        'em tarefas de longo prazo.',
    bodyEn: 'Each time you unlock your phone without a clear goal, you reinforce '
        'impulsive neural pathways that make it harder to maintain focus '
        'on long-term tasks.',
    reference: 'Longitudinal Investigation of Smartphone Interaction Patterns',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=smartphone+unlock+impulsive+neural',
    analysisFn: (d) => d.hasData
        ? '${d.weeklyUnlocks} desbloqueios na semana passada, ${d.microSessions} sessões abaixo de 1 min — provavelmente sem objetivo'
        : 'registre uso por alguns dias para ver quantos desbloqueios são impulsivos',
    analysisFnEn: (d) => d.hasData
        ? '${d.weeklyUnlocks} unlocks last week, ${d.microSessions} sessions under 1 min — probably without a goal'
        : 'record use for a few days to see how many unlocks are impulsive',
  ),
];
