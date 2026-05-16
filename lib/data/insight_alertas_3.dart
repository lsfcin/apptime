// Alertas cards 21-26
part of 'insight_content.dart';

final _kAlertasC = <InsightEntry>[
  InsightEntry(
    icon: Icons.person_remove_outlined,
    title: 'Solidão digital',
    titleEn: 'Digital Loneliness',
    body: 'O "phubbing" — ignorar outros pelo celular — desperta sentimentos de '
        'exclusão e ostracismo em parceiros e amigos, danificando a confiança a longo prazo.',
    bodyEn: '"Phubbing" — ignoring others because of your phone — triggers feelings of '
        'exclusion and ostracism in partners and friends, damaging trust in the long run.',
    reference: 'Seppala (2017) — Phubbing and Relationship Satisfaction Study',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=phubbing+relationship+satisfaction+ostracism',
    analysisFn: (d) => d.hasData
        ? '${d.mealUnlocks} desbloqueios nos horários de refeição na semana passada — cada um foi um momento de phubbing'
        : 'registre uso para quantificar momentos de interrupção de conexão social',
    analysisFnEn: (d) => d.hasData
        ? '${d.mealUnlocks} unlocks during meal hours last week — each one was a moment of phubbing'
        : 'record use to quantify moments of interrupted social connection',
  ),
  InsightEntry(
    icon: Icons.favorite_border_outlined,
    title: 'Declínio da empatia',
    titleEn: 'Empathy Decline',
    body: 'Estudantes universitários que cresceram com uso intenso de tecnologia '
        'demonstram 40% menos empatia do que gerações anteriores.',
    bodyEn: 'University students who grew up with heavy technology use show '
        '40% less empathy than previous generations.',
    reference: 'Sherry Turkle & University of Michigan — Empathy Meta-Analysis',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=technology+empathy+decline+college+students',
    analysisFn: (d) => d.hasData
        ? '${(d.weeklyMin / 60).toStringAsFixed(0)}h de tela na semana passada reduz o tempo de conexão face a face'
        : 'registre uso para ver quanto tempo o celular substitui interação humana',
    analysisFnEn: (d) => d.hasData
        ? '${(d.weeklyMin / 60).toStringAsFixed(0)}h of screen time last week reduces time for face-to-face connection'
        : 'record use to see how much time the phone replaces human interaction',
  ),
  InsightEntry(
    icon: Icons.psychology_alt_outlined,
    title: 'Brain-rot: atrofia cognitiva digital',
    titleEn: 'Brain-Rot: Digital Cognitive Atrophy',
    body: 'O consumo crônico de conteúdo curto e hipnótico (Reels, Shorts, TikTok) '
        'reduz a capacidade de tolerar tédio, ler textos longos e manter foco — '
        'um fenômeno chamado de "brain-rot" ou erosão cognitiva digital. '
        'Estudos mostram que após semanas de scroll intenso, o tempo médio de '
        'atenção voluntária cai para menos de 8 segundos.',
    bodyEn: 'Chronic consumption of short, hypnotic content (Reels, Shorts, TikTok) '
        'reduces the ability to tolerate boredom, read long texts, and sustain focus — '
        'a phenomenon called "brain-rot" or digital cognitive erosion. '
        'Studies show that after weeks of intense scrolling, the average voluntary '
        'attention span drops to under 8 seconds.',
    reference: 'Loh & Kanai (2016), "How Has the Internet Reshaped Human Cognition?", The Neuroscientist',
    url: 'https://doi.org/10.1177/1073858415595005',
    analysisFn: (d) => d.hasData
        ? '${d.microSessions} sessões abaixo de 1 min na semana — cada uma é um treino do cérebro para rejeitar conteúdo mais longo'
        : 'registre uso por alguns dias para ver sua proporção de sessões ultra-curtas',
    analysisFnEn: (d) => d.hasData
        ? '${d.microSessions} sessions under 1 min this week — each one trains the brain to reject longer content'
        : 'record use for a few days to see your proportion of ultra-short sessions',
  ),
  InsightEntry(
    icon: Icons.auto_graph_outlined,
    title: 'Conteúdo curto destrói a memória',
    titleEn: 'Short Content Destroys Memory',
    body: 'O consumo de vídeos de 15–60 segundos prejudica a consolidação da '
        'memória de trabalho: o cérebro não tem tempo suficiente para processar '
        'e arquivar o que vê, resultando em uma corrente de informações que não '
        'deixa rastro cognitivo — informação sem aprendizado.',
    bodyEn: 'Consuming 15–60 second videos impairs working memory consolidation: '
        'the brain does not have enough time to process and archive what it sees, '
        'resulting in a stream of information that leaves no cognitive trace — '
        'information without learning.',
    reference: 'Uncapher & Wagner (2018), "Minds and Brains of Media Multitaskers", PNAS',
    url: 'https://doi.org/10.1073/pnas.1611612115',
    analysisFn: (d) => d.hasData
        ? '${d.passiveMin} min em apps de vídeo/social na semana passada — quanto desse conteúdo você ainda lembra?'
        : 'registre uso para ver quanto tempo vai para consumo de conteúdo descartável',
    analysisFnEn: (d) => d.hasData
        ? '${d.passiveMin} min on video/social apps last week — how much of that content do you still remember?'
        : 'record use to see how much time goes to disposable content consumption',
  ),
  InsightEntry(
    icon: Icons.science_outlined,
    title: 'Celular = droga de design',
    titleEn: 'Phone = Designed Drug',
    body: 'Neuroimagens mostram que o uso compulsivo de smartphone ativa o '
        'núcleo accumbens da mesma forma que cocaína ou álcool. '
        'A diferença: o smartphone é legal, socialmente aceito e está no bolso '
        '24h por dia. Essa combinação o torna, segundo pesquisadores, '
        'potencialmente mais difícil de controlar do que substâncias ilegais.',
    bodyEn: 'Neuroimaging shows that compulsive smartphone use activates the '
        'nucleus accumbens in the same way as cocaine or alcohol. '
        'The difference: the smartphone is legal, socially accepted, and in your '
        'pocket 24h a day. This combination makes it, according to researchers, '
        'potentially harder to control than illegal substances.',
    reference: 'He et al. (2017), "Altered Small-World Brain Networks in Internet Addiction", Scientific Reports',
    url: 'https://doi.org/10.1038/srep41587',
    analysisFn: (d) => d.hasData
        ? '${d.weeklyUnlocks} desbloqueios na semana passada — cada um é uma busca pelo próximo pico de dopamina'
        : 'registre uma semana de uso para ver com que frequência você busca essa recompensa',
    analysisFnEn: (d) => d.hasData
        ? '${d.weeklyUnlocks} unlocks last week — each one is a search for the next dopamine peak'
        : 'record a week of use to see how often you seek that reward',
  ),
  InsightEntry(
    icon: Icons.warning_amber_outlined,
    title: 'Tolerância e abstinência digital',
    titleEn: 'Digital Tolerance and Withdrawal',
    body: 'Usuários compulsivos de smartphone desenvolvem tolerância — precisam '
        'de doses crescentes (mais tempo de tela) para obter o mesmo prazer — '
        'e abstinência — ansiedade, irritabilidade e foco prejudicado quando o '
        'celular não está disponível. Esses são os critérios clínicos de dependência '
        'reconhecidos pela OMS para substâncias.',
    bodyEn: 'Compulsive smartphone users develop tolerance — needing increasing '
        'doses (more screen time) to get the same pleasure — and withdrawal — '
        'anxiety, irritability, and impaired focus when the phone is unavailable. '
        'These are the WHO\'s clinical criteria for substance dependence.',
    reference: 'Billieux et al. (2015), "Problematic Smartphone Use: Who and Why?", Current Addiction Reports',
    url: 'https://doi.org/10.1007/s40429-015-0054-y',
    analysisFn: (d) => d.hasData
        ? 'você usou ${d.avgDailyMin} min/dia esta semana — note se o padrão aumentou nos últimos meses'
        : 'registre uso por algumas semanas para identificar tendência de aumento de tolerância',
    analysisFnEn: (d) => d.hasData
        ? 'you used ${d.avgDailyMin} min/day this week — notice if the pattern has increased over recent months'
        : 'record use for several weeks to identify a trend of increasing tolerance',
  ),
];
];
