// Soluções cards 12-19
part of 'insight_content.dart';

final _kSolucoesB = <InsightEntry>[
  InsightEntry(
    icon: Icons.trending_up_outlined,
    title: 'Metas adaptativas',
    titleEn: 'Adaptive Goals',
    body: 'Reduzir o uso em incrementos semanais de 10% é mais eficaz para '
        'mudança permanente do que tentativas de cortes drásticos e repentinos.',
    bodyEn: 'Reducing use in weekly increments of 10% is more effective for '
        'permanent change than attempting drastic, sudden cuts.',
    reference: 'Rule-Based Adaptive Goals in Habit Formation',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=adaptive+goal+smartphone+habit+reduction',
    analysisFn: (d) => d.hasData
        ? 'você está em ${d.avgDailyMin} min/dia — uma meta de 10% a menos = ${(d.avgDailyMin * 0.9).round()} min/dia'
        : 'registre uso por uma semana para definir sua meta de redução de 10%',
    analysisFnEn: (d) => d.hasData
        ? 'you are at ${d.avgDailyMin} min/day — a 10% reduction goal = ${(d.avgDailyMin * 0.9).round()} min/day'
        : 'record use for a week to set your 10% reduction goal',
  ),
  InsightEntry(
    icon: Icons.access_time_outlined,
    title: 'Custo de oportunidade',
    titleEn: 'Opportunity Cost',
    body: 'Visualizar o tempo de tela como "horas perdidas" ajuda a priorizar '
        'hobbies do mundo real, exercícios e sono profundo.',
    bodyEn: 'Visualizing screen time as "lost hours" helps prioritize '
        'real-world hobbies, exercise, and deep sleep.',
    reference: 'PNAS Nexus (2025) — Blocking Mobile Internet Study',
    url: 'https://doi.org/10.1093/pnasnexus/pgae080',
    analysisFn: (d) => d.hasData
        ? '${(d.weeklyMin / 60).toStringAsFixed(0)}h de tela na semana passada — o equivalente a ${(d.weeklyMin / 60 * 30).round()} páginas lidas, ${(d.weeklyMin / 60 * 5).round()} km caminhados'
        : 'registre uso por uma semana para calcular o que você poderia ter feito',
    analysisFnEn: (d) => d.hasData
        ? '${(d.weeklyMin / 60).toStringAsFixed(0)}h of screen time last week — equivalent to ${(d.weeklyMin / 60 * 30).round()} pages read, ${(d.weeklyMin / 60 * 5).round()} km walked'
        : 'record use for a week to calculate what you could have done instead',
  ),
  InsightEntry(
    icon: Icons.park_outlined,
    title: 'Reinicialização pela natureza',
    titleEn: 'Nature Reset',
    body: 'Passar 3 dias na natureza sem celular pode aumentar a função '
        'cognitiva e a criatividade em até 50%.',
    bodyEn: 'Spending 3 days in nature without a phone can increase cognitive '
        'function and creativity by up to 50%.',
    reference: '"Three-Day Effect" and Attention Restoration Theory',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=nature+three+day+effect+attention+restoration',
    analysisFn: (d) => d.hasData
        ? '${(d.weeklyMin / 60).toStringAsFixed(0)}h de tela esta semana — seu córtex pré-frontal precisa de natureza para recuperar'
        : 'registre uso por uma semana para planejar seu próximo detox na natureza',
    analysisFnEn: (d) => d.hasData
        ? '${(d.weeklyMin / 60).toStringAsFixed(0)}h of screen time this week — your prefrontal cortex needs nature to recover'
        : 'record use for a week to plan your next nature detox',
  ),
  InsightEntry(
    icon: Icons.fitness_center_outlined,
    title: 'Fortalecimento pré-frontal',
    titleEn: 'Prefrontal Strengthening',
    body: 'Períodos diários de "jejum digital" ajudam a fortalecer o córtex '
        'pré-frontal, devolvendo o controle sobre decisões e reduzindo o vício.',
    bodyEn: 'Daily periods of "digital fasting" help strengthen the prefrontal cortex, '
        'restoring control over decisions and reducing addictive behavior.',
    reference: 'Mindfulness Practice for Behavioral Addiction Research',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=digital+fasting+prefrontal+cortex+addiction',
    analysisFn: (d) => d.hasData
        ? '${d.microSessions} impulsos de checagem na semana passada — o córtex pré-frontal pode retomar esse controle'
        : 'registre uso para medir o quanto o impulso digital domina suas escolhas',
    analysisFnEn: (d) => d.hasData
        ? '${d.microSessions} checking impulses last week — the prefrontal cortex can reclaim this control'
        : 'record use to measure how much the digital impulse dominates your choices',
  ),
  InsightEntry(
    icon: Icons.directions_walk_outlined,
    title: 'Recuperação ativa',
    titleEn: 'Active Recovery',
    body: 'Substituir 5 minutos de scroll por uma caminhada rápida rejuvenesce '
        'o cérebro e reduz a fadiga mental mais rápido que o entretenimento digital.',
    bodyEn: 'Replacing 5 minutes of scrolling with a brisk walk rejuvenates '
        'the brain and reduces mental fatigue faster than digital entertainment.',
    reference: 'CareerBuilder — Workplace Productivity Suggestion',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=walking+mental+fatigue+screen+replacement',
    analysisFn: (d) => d.hasData
        ? '${(d.weeklyMin / 60).toStringAsFixed(0)}h de tela esta semana — substituir 5 min de scroll por caminhada faz diferença real'
        : 'registre uso para identificar janelas onde uma caminhada substituiria o scroll',
    analysisFnEn: (d) => d.hasData
        ? '${(d.weeklyMin / 60).toStringAsFixed(0)}h of screen time this week — replacing 5 min of scrolling with walking makes a real difference'
        : 'record use to identify windows where a walk could replace scrolling',
  ),
  InsightEntry(
    icon: Icons.bar_chart_outlined,
    title: 'A lacuna da subestimação',
    titleEn: 'The Underestimation Gap',
    body: 'Usuários tipicamente subestimam seu uso real de smartphone em 20% '
        'a 50% — até que vejam dados objetivos de rastreamento.',
    bodyEn: 'Users typically underestimate their real smartphone use by 20% '
        'to 50% — until they see objective tracking data.',
    reference: 'Agreement Between Self-Reported and Objective Usage Study',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=smartphone+self+report+underestimate+objective',
    analysisFn: (d) => d.hasData
        ? 'o rastreador registra ${d.avgDailyMin} min/dia — acima do que a maioria das pessoas estima para si mesma'
        : 'use o app para obter os dados reais e comparar com o que você imagina usar',
    analysisFnEn: (d) => d.hasData
        ? 'the tracker records ${d.avgDailyMin} min/day — more than most people estimate for themselves'
        : 'use the app to get the real data and compare with what you imagine you use',
  ),
  InsightEntry(
    icon: Icons.filter_list_outlined,
    title: 'Auditoria do feed',
    titleEn: 'Feed Audit',
    body: 'Deixar de seguir contas que geram emoções negativas pode '
        'transformar o uso passivo em uma experiência mais neutra ou positiva.',
    bodyEn: 'Unfollowing accounts that generate negative emotions can '
        'transform passive use into a more neutral or positive experience.',
    reference: 'Digital Wellness Guidelines for Doomscrolling',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=unfollow+negative+content+social+media+wellbeing',
    analysisFn: (d) => d.hasData
        ? '${d.passiveMin} min em apps passivos esta semana — vale auditar o que esse feed está te entregando'
        : 'registre uso para ver quanto tempo vai para consumo passivo de conteúdo',
    analysisFnEn: (d) => d.hasData
        ? '${d.passiveMin} min on passive apps this week — worth auditing what that feed is delivering to you'
        : 'record use to see how much time goes to passive content consumption',
  ),
  InsightEntry(
    icon: Icons.menu_book_outlined,
    title: 'Leitura longa como antídoto',
    titleEn: 'Long Reading as Antidote',
    body: 'Ler 20 minutos de texto contínuo por dia — livro, artigo, ensaio — '
        'reconstrói o músculo da atenção sustentada e reverte parcialmente '
        'os efeitos do consumo fragmentado. É o oposto estrutural do scroll: '
        'exige atenção linear, memória de trabalho e síntese ativa.',
    bodyEn: 'Reading 20 minutes of continuous text per day — book, article, essay — '
        'rebuilds the sustained attention muscle and partially reverses the effects '
        'of fragmented consumption. It is the structural opposite of scrolling: '
        'it requires linear attention, working memory, and active synthesis.',
    reference: 'Wolf (2018), "Reader, Come Home: The Reading Brain in a Digital World", HarperCollins',
    url: 'https://pubmed.ncbi.nlm.nih.gov/?term=deep+reading+brain+attention+Wolf',
    analysisFn: (d) => d.hasData
        ? '${d.microSessions} checagens impulsivas na semana passada — cada sessão longa de leitura desfaz vários desses danos'
        : 'registre uso para medir a proporção de sessões fragmentadas vs. profundas',
    analysisFnEn: (d) => d.hasData
        ? '${d.microSessions} impulsive checks last week — each long reading session undoes several of those damages'
        : 'record use to measure the ratio of fragmented vs. deep sessions',
  ),
];
