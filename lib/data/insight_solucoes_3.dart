// Soluções cards 20-22
part of 'insight_content.dart';

final _kSolucoesC = <InsightEntry>[
  InsightEntry(
    icon: Icons.self_improvement_outlined,
    title: 'Tédio como exercício cognitivo',
    titleEn: 'Boredom as Cognitive Exercise',
    body: 'Tolerar o tédio sem recorrer ao celular é, literalmente, um treino '
        'cerebral: ativa a rede de modo padrão (default mode network), '
        'responsável pela criatividade, autopercepção e consolidação de memórias. '
        'O scroll infinito suprime essa rede, empobrecendo o pensamento espontâneo.',
    bodyEn: 'Tolerating boredom without reaching for your phone is literally a '
        'brain workout: it activates the default mode network, responsible for '
        'creativity, self-awareness, and memory consolidation. '
        'Infinite scrolling suppresses this network, impoverishing spontaneous thinking.',
    reference: 'Smallwood & Schooler (2015), "The Science of Mind Wandering", Annual Review of Psychology',
    url: 'https://doi.org/10.1146/annurev-psych-010814-015331',
    analysisFn: (d) => d.hasData
        ? '${d.microSessions} vezes que você buscou o celular ao sentir tédio esta semana — experimente esperar 2 minutos antes de pegar'
        : 'registre uso para identificar quantas aberturas são respostas automáticas ao tédio',
    analysisFnEn: (d) => d.hasData
        ? '${d.microSessions} times you reached for your phone when bored this week — try waiting 2 minutes before picking it up'
        : 'record use to identify how many openings are automatic responses to boredom',
  ),
  InsightEntry(
    icon: Icons.spa_outlined,
    title: 'Protocolos de dependência aplicados ao celular',
    titleEn: 'Addiction Protocols Applied to the Phone',
    body: 'Técnicas validadas para dependência química funcionam para smartphones: '
        'identificar gatilhos situacionais, criar fricção para o comportamento-alvo '
        'e substituir por comportamento incompatível (caminhar, respirar, ler). '
        'A estrutura é a mesma — só o objeto da dependência muda.',
    bodyEn: 'Validated techniques for chemical dependency work for smartphones: '
        'identify situational triggers, create friction for the target behavior, '
        'and substitute with an incompatible behavior (walk, breathe, read). '
        'The framework is the same — only the object of dependency changes.',
    reference: 'Throuvala et al. (2019), "Motivational and Self-Control Mechanisms", Journal of Behavioral Addictions',
    url: 'https://doi.org/10.1556/2006.8.2019.43',
    analysisFn: (d) => d.hasData
        ? 'você tem ${d.weeklyUnlocks} desbloqueios semanais — identifique os 3 principais gatilhos e crie atrito para cada um'
        : 'registre uso por uma semana para mapear seus principais gatilhos de abertura',
    analysisFnEn: (d) => d.hasData
        ? 'you have ${d.weeklyUnlocks} weekly unlocks — identify the top 3 triggers and create friction for each'
        : 'record use for a week to map your main opening triggers',
  ),
  InsightEntry(
    icon: Icons.group_work_outlined,
    title: 'Responsabilidade social como âncora',
    titleEn: 'Social Accountability as Anchor',
    body: 'Em programas de recuperação de dependência, o suporte social é '
        'o preditor mais forte de sucesso a longo prazo. Aplicado ao uso digital: '
        'compartilhar metas de uso com um parceiro, amigo ou grupo aumenta '
        'significativamente a adesão e reduz recaídas.',
    bodyEn: 'In addiction recovery programs, social support is the strongest '
        'long-term predictor of success. Applied to digital use: '
        'sharing usage goals with a partner, friend, or group significantly '
        'increases adherence and reduces relapses.',
    reference: 'Kelly et al. (2020), "Mechanisms of Behavior Change in AA", Addiction',
    url: 'https://doi.org/10.1111/add.14906',
    analysisFn: (d) => d.hasData
        ? 'sua meta atual: se um amigo soubesse seus ${d.avgDailyMin} min/dia, isso mudaria seu comportamento?'
        : 'registre uso por uma semana e compartilhe os dados com alguém de confiança',
    analysisFnEn: (d) => d.hasData
        ? 'your current average: if a friend knew your ${d.avgDailyMin} min/day, would it change your behavior?'
        : 'record use for a week and share the data with someone you trust',
  ),
];
];
