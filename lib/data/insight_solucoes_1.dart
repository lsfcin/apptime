// Soluções cards 1-11
part of 'insight_content.dart';

final _kSolucoesA = <InsightEntry>[
  InsightEntry(
    icon: Icons.hourglass_empty_outlined,
    title: 'A regra do atrito',
    titleEn: 'The Friction Rule',
    body: 'Introduzir apenas 10 segundos de atraso antes de abrir um app-alvo '
        'é suficiente para dissipar a maioria dos impulsos de consumo inconsciente.',
    bodyEn: 'Introducing just 10 seconds of delay before opening a target app '
        'is enough to dissipate most unconscious consumption impulses.',
    reference: '"One Sec" App — Psychological Mechanism Study, PNAS 2023',
    url: 'https://doi.org/10.1073/pnas.2213580120',
    analysisFn: (d) => d.hasData
        ? '${d.microSessions} sessões impulsivas (< 1 min) na semana passada — um atraso de 10s poderia ter evitado a maioria'
        : 'registre uso por alguns dias para ver quantas aberturas são impulsivas',
    analysisFnEn: (d) => d.hasData
        ? '${d.microSessions} impulsive sessions (< 1 min) last week — a 10s delay could have prevented most of them'
        : 'record use for a few days to see how many openings are impulsive',
  ),
  InsightEntry(
    icon: Icons.invert_colors_off_outlined,
    title: 'O poder do escala de cinza',
    titleEn: 'The Power of Grayscale',
    body: 'Mudar a tela para preto e branco reduz o uso diário em '
        'aproximadamente 20–40 minutos, tornando os apps menos visualmente recompensadores.',
    bodyEn: 'Switching the screen to black and white reduces daily use by '
        'approximately 20–40 minutes, making apps less visually rewarding.',
    reference: 'Holte & Ferraro (2020) — Grayscale Screen Time Research',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=grayscale+screen+time+reduction',
    analysisFn: (d) => d.hasData
        ? 'sua média é ${d.avgDailyMin} min/dia — escala de cinza poderia economizar 20–40 min diários'
        : 'registre uso por uma semana e compare após ativar escala de cinza',
    analysisFnEn: (d) => d.hasData
        ? 'your average is ${d.avgDailyMin} min/day — grayscale could save 20–40 min daily'
        : 'record use for a week and compare after activating grayscale',
  ),
  InsightEntry(
    icon: Icons.visibility_off_outlined,
    title: 'Fora da vista',
    titleEn: 'Out of Sight',
    body: 'Manter o celular em outro cômodo enquanto trabalha melhora '
        'significativamente a memória de trabalho e a capacidade cognitiva.',
    bodyEn: 'Keeping your phone in another room while working significantly '
        'improves working memory and cognitive capacity.',
    reference: 'Ward et al. (2017) — "Brain Drain" Study',
    url: 'https://doi.org/10.1086/691462',
    analysisFn: (d) => d.hasData
        ? '${d.workUnlocks} vezes que o celular interrompeu seu trabalho (9h–18h) na semana passada'
        : 'registre uso em dias úteis para medir o impacto do celular na sua concentração',
    analysisFnEn: (d) => d.hasData
        ? '${d.workUnlocks} times the phone interrupted your work (9am–6pm) last week'
        : 'record use on weekdays to measure the phone\'s impact on your concentration',
  ),
  InsightEntry(
    icon: Icons.center_focus_strong_outlined,
    title: 'Treinamento unitarefa',
    titleEn: 'Unitasking Training',
    body: 'Reconstruir o tempo de atenção exige treinar o cérebro para focar '
        'em um único app ou tarefa por 25 minutos sem interrupção.',
    bodyEn: 'Rebuilding attention span requires training the brain to focus '
        'on a single app or task for 25 minutes without interruption.',
    reference: 'Reclaiming Conversation — Unitasking Principles',
    url: 'https://www.penguinrandomhouse.com/books/312845/reclaiming-conversation-by-sherry-turkle/',
    analysisFn: (d) => d.hasData
        ? '${d.microSessions} sessões abaixo de 1 min na semana passada — seu músculo de foco precisa ser treinado'
        : 'registre uso para ver sua capacidade atual de manter o foco',
    analysisFnEn: (d) => d.hasData
        ? '${d.microSessions} sessions under 1 min last week — your focus muscle needs training'
        : 'record use to see your current ability to sustain focus',
  ),
  InsightEntry(
    icon: Icons.spa_outlined,
    title: 'Detox de tela',
    titleEn: 'Screen Detox',
    body: 'Reduzir o tempo de tela por apenas 3 semanas pode melhorar '
        'indicadores de saúde mental com tamanho de efeito comparável ao de antidepressivos.',
    bodyEn: 'Reducing screen time for just 3 weeks can improve mental health '
        'indicators with an effect size comparable to antidepressants.',
    reference: 'Georgetown University — Digital Detox Study (Kushlev et al., 2025)',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=screen+time+reduction+mental+health+Kushlev',
    analysisFn: (d) => d.hasData
        ? '${(d.weeklyMin / 60).toStringAsFixed(0)}h de tela na semana passada — 3 semanas de redução já geram ganhos clínicos'
        : 'registre uma semana de uso para planejar seu detox',
    analysisFnEn: (d) => d.hasData
        ? '${(d.weeklyMin / 60).toStringAsFixed(0)}h of screen time last week — 3 weeks of reduction already yields clinical gains'
        : 'record a week of use to plan your detox',
  ),
  InsightEntry(
    icon: Icons.remove_circle_outline_outlined,
    title: 'Remoção de gatilhos',
    titleEn: 'Trigger Removal',
    body: 'Esconder apps de redes sociais em pastas fora da tela inicial reduz '
        'os estímulos visuais que disparam comportamentos automáticos de "checagem".',
    bodyEn: 'Hiding social media apps in folders off the home screen reduces '
        'the visual cues that trigger automatic "checking" behaviors.',
    reference: 'Fogg Behavior Model and Multifaceted Nudges',
    url: 'https://behaviordesign.stanford.edu',
    analysisFn: (d) => d.hasData
        ? '${d.microSessions} checagens impulsivas na semana passada — remova os gatilhos visuais da tela inicial'
        : 'registre uso para identificar quais apps você abre por impulso',
    analysisFnEn: (d) => d.hasData
        ? '${d.microSessions} impulsive checks last week — remove visual triggers from your home screen'
        : 'record use to identify which apps you open by impulse',
  ),
  InsightEntry(
    icon: Icons.lock_outlined,
    title: 'Senhas manuais',
    titleEn: 'Manual Passcodes',
    body: 'Desabilitar desbloqueio biométrico em favor de senhas longas adiciona '
        'uma camada de "atrito deliberado" que reduz aberturas impulsivas.',
    bodyEn: 'Disabling biometric unlock in favor of long passcodes adds a layer '
        'of "deliberate friction" that reduces impulsive openings.',
    reference: 'Nudge-Based Intervention — Randomized Controlled Trial',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=PIN+password+smartphone+impulsive+use',
    analysisFn: (d) => d.hasData
        ? '${d.weeklyUnlocks} desbloqueios na semana passada — atrito adicional reduziria os impulsivos'
        : 'registre quantos desbloqueios você faz para avaliar o impacto do atrito',
    analysisFnEn: (d) => d.hasData
        ? '${d.weeklyUnlocks} unlocks last week — added friction would reduce the impulsive ones'
        : 'record how many unlocks you make to assess the impact of friction',
  ),
  InsightEntry(
    icon: Icons.hotel_outlined,
    title: 'A regra do quarto',
    titleEn: 'The Bedroom Rule',
    body: 'Carregar o celular fora do quarto melhora a qualidade do sono e '
        'previne o pico de cortisol associado ao scroll matinal.',
    bodyEn: 'Charging your phone outside the bedroom improves sleep quality and '
        'prevents the cortisol spike associated with morning scrolling.',
    reference: 'Digital Detox Benefits and Sleep Quality Research',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=smartphone+bedroom+sleep+quality',
    analysisFn: (d) => d.hasData
        ? '${d.lateNightMin} min na tela após as 22h na semana passada — o carregador deveria estar em outro cômodo'
        : 'registre seu uso noturno para medir o impacto do celular no quarto',
    analysisFnEn: (d) => d.hasData
        ? '${d.lateNightMin} min on screen after 10pm last week — the charger should be in another room'
        : 'record your nighttime use to measure the phone\'s impact in the bedroom',
  ),
  InsightEntry(
    icon: Icons.notifications_off_outlined,
    title: 'Notificações seletivas',
    titleEn: 'Selective Notifications',
    body: 'Manter apenas alertas de humano para humano (mensagens) enquanto '
        'desativa "pings" de apps reduz o estresse ambiental constante.',
    bodyEn: 'Keeping only human-to-human alerts (messages) while disabling '
        'app "pings" reduces constant ambient stress.',
    reference: 'Intervention for Reducing Non-Essential Notification Disruptions',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=notification+reduction+stress+intervention',
    analysisFn: (d) => d.hasData
        ? '${d.workUnlocks} interrupções no horário de trabalho na semana passada — quantas foram notificações?'
        : 'registre uso para ver o impacto das notificações na sua atenção',
    analysisFnEn: (d) => d.hasData
        ? '${d.workUnlocks} interruptions during work hours last week — how many were notifications?'
        : 'record use to see the impact of notifications on your attention',
  ),
  InsightEntry(
    icon: Icons.pause_circle_outlined,
    title: 'Pausa de atenção plena',
    titleEn: 'Mindful Pause',
    body: 'Antes de abrir um app, perguntar "Por que estou pegando isso?" '
        'muda o estado do Sistema 1 (automático) para o Sistema 2 (deliberado).',
    bodyEn: 'Before opening an app, asking "Why am I picking this up?" '
        'shifts the state from System 1 (automatic) to System 2 (deliberate).',
    reference: 'Pratt Institute — Digital Wellbeing Journey Guidelines',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=mindful+smartphone+use+system+2+thinking',
    analysisFn: (d) => d.hasData
        ? '${d.weeklyUnlocks} desbloqueios na semana passada — quantos foram conscientes?'
        : 'registre uso para descobrir a proporção de aberturas automáticas vs. intencionais',
    analysisFnEn: (d) => d.hasData
        ? '${d.weeklyUnlocks} unlocks last week — how many were conscious?'
        : 'record use to discover the proportion of automatic vs. intentional openings',
  ),
  InsightEntry(
    icon: Icons.remove_red_eye_outlined,
    title: 'A regra 20-20-20',
    titleEn: 'The 20-20-20 Rule',
    body: 'A cada 20 minutos de uso de tela, olhe para algo a 6 metros de '
        'distância por 20 segundos para relaxar os músculos oculares.',
    bodyEn: 'Every 20 minutes of screen use, look at something 6 meters away '
        'for 20 seconds to relax the eye muscles.',
    reference: 'Eye Care Practitioner — Clinical Guidelines for Digital Fatigue',
    url: 'https://www.aao.org/eye-health/tips-prevention/computer-usage',
    analysisFn: (d) => d.hasData
        ? '${d.avgDailyMin} min/dia na tela — isso significa ${d.avgDailyMin ~/ 20} pausas de 20s necessárias por dia'
        : 'registre uso para calcular quantas pausas visuais você deveria fazer',
    analysisFnEn: (d) => d.hasData
        ? '${d.avgDailyMin} min/day on screen — that means ${d.avgDailyMin ~/ 20} 20-second breaks needed per day'
        : 'record use to calculate how many visual breaks you should take',
  ),
];
