// Alertas cards 11-20
part of 'insight_content.dart';

final _kAlertasB = <InsightEntry>[
  InsightEntry(
    icon: Icons.phone_android_outlined,
    title: 'Frequência vs. Sono',
    titleEn: 'Frequency vs. Sleep',
    body: 'Checar o celular mais de 400 vezes por semana aumenta o risco de '
        'baixa qualidade de sono em 61% — um preditor mais forte do que o tempo total.',
    bodyEn: 'Checking your phone more than 400 times per week increases the risk '
        'of poor sleep quality by 61% — a stronger predictor than total screen time.',
    reference: 'Mental Health Journal — Estudo de uso objetivo, 2025',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=smartphone+check+frequency+sleep+quality',
    analysisFn: (d) => d.hasData
        ? 'você desbloqueou ~${d.weeklyUnlocks} vezes na semana passada${d.weeklyUnlocks > 400 ? " — acima do limiar de risco (400×)" : ""}'
        : 'registre uma semana completa para comparar com o limiar de risco',
    analysisFnEn: (d) => d.hasData
        ? 'you unlocked ~${d.weeklyUnlocks} times last week${d.weeklyUnlocks > 400 ? " — above the risk threshold (400×)" : ""}'
        : 'record a full week to compare with the risk threshold',
  ),
  InsightEntry(
    icon: Icons.bolt_outlined,
    title: 'Estresse do micro-uso',
    titleEn: 'Micro-Use Stress',
    body: 'Sessões de uso menores que 10 segundos são tipicamente "checagens '
        'por tédio" que fragmentam a atenção e aumentam os níveis basais de estresse.',
    bodyEn: 'Usage sessions shorter than 10 seconds are typically "boredom checks" '
        'that fragment attention and raise baseline stress levels.',
    reference: 'ARDUOUS User Interaction Analysis',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=micro+session+smartphone+stress',
    analysisFn: (d) => d.hasData
        ? '${d.microSessions} sessões abaixo de 1 min na semana passada — cada uma é uma checagem por tédio'
        : 'use o app por alguns dias para ver quantas checagens breves você faz',
    analysisFnEn: (d) => d.hasData
        ? '${d.microSessions} sessions under 1 min last week — each one is a boredom check'
        : 'use the app for a few days to see how many brief checks you make',
  ),
  InsightEntry(
    icon: Icons.sentiment_dissatisfied_outlined,
    title: 'Dreno emocional',
    titleEn: 'Emotional Drain',
    body: 'Rolar feeds passivamente sem interagir está fortemente ligado ao '
        'aumento de sintomas de depressão, ansiedade e inveja social.',
    bodyEn: 'Passively scrolling feeds without interacting is strongly linked to '
        'increased symptoms of depression, anxiety, and social envy.',
    reference: 'Mobile Sensing Technology — Mental Health Study',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=passive+scrolling+depression+anxiety',
    analysisFn: (d) => d.hasData
        ? 'você passou ${d.passiveMin} min em apps passivos (social, vídeo) na semana passada'
        : 'registre uso por uma semana para ver quanto tempo vai para consumo passivo',
    analysisFnEn: (d) => d.hasData
        ? 'you spent ${d.passiveMin} min on passive apps (social, video) last week'
        : 'record use for a week to see how much time goes to passive consumption',
  ),
  InsightEntry(
    icon: Icons.compare_arrows_outlined,
    title: 'O mito do multitarefa',
    titleEn: 'The Multitasking Myth',
    body: 'Apenas 2,5% da população consegue fazer multitarefa com eficiência; '
        'para os outros 97,5%, a taxa de erros aumenta 50% ao usar o celular durante o trabalho.',
    bodyEn: 'Only 2.5% of the population can multitask efficiently; '
        'for the other 97.5%, error rate increases by 50% when using a phone while working.',
    reference: 'Watson & Strayer (2010) — Supertasker Profiles',
    url: 'https://doi.org/10.1177/1071181310541514',
    analysisFn: (d) => d.hasData
        ? 'você alternou contexto ~${d.workUnlocks} vezes no horário de trabalho na semana passada'
        : 'registre uso em dias úteis para ver seu padrão de multitarefa',
    analysisFnEn: (d) => d.hasData
        ? 'you switched context ~${d.workUnlocks} times during work hours last week'
        : 'record use on weekdays to see your multitasking pattern',
  ),
  InsightEntry(
    icon: Icons.dynamic_feed_outlined,
    title: 'Doomscrolling',
    titleEn: 'Doomscrolling',
    body: 'Consumir notícias negativas sem fim ativa a amígdala, mantendo o '
        'corpo em estado constante de "luta ou fuga".',
    bodyEn: 'Endlessly consuming negative news activates the amygdala, keeping '
        'the body in a constant "fight or flight" state.',
    reference: 'Emerson Health — Digital Wellness Guidelines',
    url: 'https://www.emersonhospital.org/services/behavioral-health/digital-wellness',
    analysisFn: (d) => d.hasData
        ? '${d.passiveMin} min em apps de social, vídeo e notícias na semana passada'
        : 'registre uso para ver quanto do seu tempo vai para consumo de conteúdo',
    analysisFnEn: (d) => d.hasData
        ? '${d.passiveMin} min on social, video, and news apps last week'
        : 'record use to see how much of your time goes to content consumption',
  ),
  InsightEntry(
    icon: Icons.flight_outlined,
    title: 'Fuga maladaptativa',
    titleEn: 'Maladaptive Escape',
    body: 'Usar o smartphone para "matar o tempo" ou evitar emoções negativas '
        'frequentemente agrava a fadiga digital e o esgotamento mental a longo prazo.',
    bodyEn: 'Using your smartphone to "kill time" or avoid negative emotions '
        'frequently worsens digital fatigue and mental exhaustion in the long run.',
    reference: 'Cognitive Load Theory and Digital Fatigue Research',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=smartphone+escapism+mental+fatigue',
    analysisFn: (d) => d.hasData
        ? 'você usou o celular ${d.weeklyMin} min total na semana passada — quanto foi intenção vs. fuga?'
        : 'registre uso por uma semana para avaliar padrões de fuga',
    analysisFnEn: (d) => d.hasData
        ? 'you used your phone for ${d.weeklyMin} min total last week — how much was intention vs. escape?'
        : 'record use for a week to evaluate escape patterns',
  ),
  InsightEntry(
    icon: Icons.arrow_downward_outlined,
    title: 'Pressão no pescoço',
    titleEn: 'Neck Pressure',
    body: 'Inclinar a cabeça 60 graus para olhar o celular exerce 27 kg de '
        'força sobre a coluna cervical.',
    bodyEn: 'Tilting your head 60 degrees to look at your phone places 27 kg of '
        'force on the cervical spine.',
    reference: '"Text Neck" Biomechanical Model Research',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=text+neck+cervical+spine+biomechanics',
    analysisFn: (d) => d.hasData
        ? 'você passou ${d.avgDailyMin} min/dia olhando para baixo — ${(d.avgDailyMin / 60).toStringAsFixed(1)}h de carga cervical diária'
        : 'registre uso para quantificar a carga mecânica diária no seu pescoço',
    analysisFnEn: (d) => d.hasData
        ? 'you spent ${d.avgDailyMin} min/day looking down — ${(d.avgDailyMin / 60).toStringAsFixed(1)}h of daily cervical load'
        : 'record use to quantify your daily mechanical load on your neck',
  ),
  InsightEntry(
    icon: Icons.visibility_outlined,
    title: 'Fadiga visual digital',
    titleEn: 'Digital Eye Strain',
    body: 'O uso prolongado de tela reduz a taxa de piscar em até 50%, causando '
        'olhos secos, visão turva e dores de cabeça persistentes.',
    bodyEn: 'Prolonged screen use reduces blink rate by up to 50%, causing '
        'dry eyes, blurred vision, and persistent headaches.',
    reference: 'Computer Vision Syndrome (CVS) — 20-20-20 Rule Research',
    url: 'https://www.aoa.org/healthy-eyes/eye-and-vision-conditions/computer-vision-syndrome',
    analysisFn: (d) => d.hasData
        ? '${d.weeklyMin} min na tela na semana passada — seus olhos ficaram muito tempo sem descanso'
        : 'registre uso para calcular sua carga visual semanal',
    analysisFnEn: (d) => d.hasData
        ? '${d.weeklyMin} min on screen last week — your eyes spent a long time without rest'
        : 'record use to calculate your weekly visual load',
  ),
  InsightEntry(
    icon: Icons.healing_outlined,
    title: 'Risco de dor crônica',
    titleEn: 'Chronic Pain Risk',
    body: 'Usuários excessivos de smartphone têm risco seis vezes maior de '
        'desenvolver dores crônicas no pescoço e ombros.',
    bodyEn: 'Excessive smartphone users have a six-fold higher risk of '
        'developing chronic neck and shoulder pain.',
    reference: 'Longitudinal Population-Based Cohort Study (Gustafsson et al.)',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=smartphone+chronic+neck+pain+Gustafsson',
    analysisFn: (d) => d.hasData
        ? '${d.avgDailyMin} min/dia — uso diário consistente acumula risco crônico ao longo do tempo'
        : 'registre uso diário para ver sua exposição acumulada',
    analysisFnEn: (d) => d.hasData
        ? '${d.avgDailyMin} min/day — consistent daily use accumulates chronic risk over time'
        : 'record daily use to see your cumulative exposure',
  ),
  InsightEntry(
    icon: Icons.group_outlined,
    title: 'A presença silenciosa',
    titleEn: 'The Silent Presence',
    body: 'Mesmo um celular virado para baixo sobre a mesa reduz a profundidade '
        'da conversa e a conexão emocional entre as pessoas presentes.',
    bodyEn: 'Even a phone face-down on the table reduces the depth of conversation '
        'and emotional connection between people present.',
    reference: 'Sherry Turkle — Reclaiming Conversation Research',
    url: 'https://www.penguinrandomhouse.com/books/312845/reclaiming-conversation-by-sherry-turkle/',
    analysisFn: (d) => d.hasData
        ? 'você pegou o celular ${d.mealUnlocks} vezes nos horários de refeição (12–14h, 19–21h) na semana passada'
        : 'registre uso para ver quantas refeições foram interrompidas pelo celular',
    analysisFnEn: (d) => d.hasData
        ? 'you picked up your phone ${d.mealUnlocks} times during meal hours (12–2pm, 7–9pm) last week'
        : 'record use to see how many meals were interrupted by the phone',
  ),
];
