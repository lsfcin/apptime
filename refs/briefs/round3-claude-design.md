# AppTime — round 3: as telas do app (brief para Claude Design)

Desenhe **todas as telas do app Android AppTime** numa canvas, cada uma como artboard de celular
360×800 dp, textos em **português do Brasil**. As capturas anexas (`1-ajustes-*`, `2-monit-*`,
`3a/3b/3c-analise-*`, `4-insights-*`) mostram o app de hoje: use-as para saber **o que existe**,
não como ele deve parecer — a estrutura muda (abaixo) e o visual também.

## O app
AppTime reduz o vício em celular por **consciência, sem bloquear nada**. Um visor flutuante
(overlay) mostra o tempo de hoje no app aberto, comparado com **o habitual da própria pessoa**:
a média diária dos 30 dias anteriores. Mensagens curtas (≤15 palavras, 6–7 s) saem em três
situações — sessão ≥20 min, app acima do habitual, celular acima do habitual — cada uma no máximo
uma vez por dia. Tudo local: sem rede, sem conta, sem metas. O dia vira às 04:00.
Ninguém escolhe uma meta: a única referência é a média da própria pessoa.

O overlay e a mensagem **já foram desenhados** (rounds 1 e 2; estilos Pílula, Bloco e Side rail).
Neste round eles só aparecem dentro da prévia de Ajustes — não os redesenhe.

## Visual: Obsidian Mono (decidido)
- Fundo carvão `#0B0C0E`; superfícies sem borda `#14161B`; texto `#F3F4F6`, secundário `#7E8594`.
- O habitual em grafite. Âmbar `#E5A93C` **só bem acima** do habitual. Sem vermelho, sem verde
  neon, sem azul elétrico. Cor nunca sozinha: estado também em texto, forma ou luminância.
- Inter com algarismos tabulares (`tnum`); métrica principal 40 sp Light; rótulo de seção 11 sp
  caixa-alta; 24 dp entre seções; nenhum card com borda. Referência de tom: Oura.
- Tema claro e escuro, seguindo o sistema (frase enviada depois, 2026-11-03): versão clara do
  Obsidian Mono com as mesmas regras; âmbar mais escuro no claro, para contraste AA.
- Ícones reais dos apps (nunca círculos com letra).

## Rota (decidida)
Três abas embaixo: **Hoje** (abre aqui) · **Análise** · **Ajustes**. Tocar em qualquer app, em
qualquer tela, abre a **tela do app**. As abas Monit. e Insights deixam de existir.

### 0. Primeira configuração
Uma frase grande por tela; os botões aparecem depois de uma pausa curta. Passos: permissão de
sobreposição · acesso ao uso · início automático (MIUI) · sem hibernação. Todo passo que abre uma
tela do sistema mostra, como linha pequena de dica: *"Depois, abra o AppTime de novo."*
Desenhe a primeira tela, um passo de permissão e a tela de "pronto".

### 1. Hoje
- O total de hoje e como ele está frente ao habitual **até agora** — calmo, perto, acima.
- Os apps mais usados hoje, com ícone e tempo (nunca o próprio AppTime, nunca apps com 0 min).
  Tocar abre a tela do app.
- **Sem** desbloqueios e sessões aqui (moram em Análise). Sem metas.
- Aviso discreto no topo quando o acompanhamento parou ou falta uma permissão, com o motivo, a
  consequência e uma ação: *"O acompanhamento foi interrompido. O total de hoje pode estar
  incompleto."* — botão "Reativar".

### 2. Análise — 7 dias · 30 dias
(O dia está em Hoje; não há aba 1 dia.) Cards, nesta ordem sugerida:
- **Uso diário**: barras por dia com a linha do habitual (junta o antigo "Uso diário" e
  "Tendência semanal"). No 30 dias, o período mostra total e média — sem card de tendência à parte.
- **Sessões e desbloqueios**: quantas vezes desbloqueou e quanto duram as sessões (junta
  "Fragmentação do foco" e "Índice de impulsividade").
- **Apps mais abertos**: ranking por aberturas, sem faixas de limiar.
- **Uso noturno**: uso entre 22h e 6h, sem afirmar nada sobre sono.
Cortado: Custo de oportunidade, Alerta de phubbing, Balanço de engajamento, Padrão dos últimos 7
dias, faixas de pesquisa (`4–6h/dia`, `30–60/dia`), citações de estudos. Nenhum texto científico.

### 3. Ajustes, nesta ordem
1. **Prévia ao vivo do overlay** no topo, reagindo aos controles abaixo, e botão "Testar mensagem".
2. **Visor**: galeria dos estilos (Pílula · Bloco · Side rail); interruptor **número** (tempo de
   hoje no app); interruptor **comparação com o habitual**; tamanho; intensidade
   (nenhuma · cor/peso · contraste · cresce devagar).
3. **Apps**: a lista completa dos apps instalados, com busca. **Um interruptor por app**
   ("monitorar": desligado = sem visor e fora do total). Tocar na linha abre a tela do app.
   Esta é a única lista completa do app.
4. **Mensagens**: ligar/desligar.
5. **Idioma**: uma linha só.
6. **Privacidade e dados**: os dados ficam no aparelho; política; aviso legal; "Apagar todos os
   dados" com confirmação que avisa que o habitual recomeça do zero.
7. **Permissões**: só aparece quando falta alguma.
Cortado: botão Parar separado, "Mostrar borda", "Mostrar fundo", textos tipo "(5s)".

### 4. Tela do app (abre ao tocar num app)
- Uso desse app hoje e nos últimos dias frente ao habitual dele.
- Controles do visor nesse app: monitorar (o mesmo interruptor da lista), posição neste app (com
  "voltar ao padrão"), dica de claro/escuro `Automático · Sempre escuro · Sempre claro` (o overlay
  não enxerga os pixels da tela), comportamento em tela cheia e em paisagem.

## Estados que precisam de artboard
- **O habitual se formando**: dias 1–6 sem comparação (só o tempo; dizer quantos dias faltam);
  dias 7–29 "referência inicial"; a partir de 30 dias, o habitual completo. Em Hoje e na tela do app.
- **Acompanhamento parado / permissão revogada** (Hoje e Ajustes).
- **Sem dados ainda**, **dia de fato zerado** e **dados parciais** — três coisas diferentes,
  nenhuma deve parecer erro nem vitória.
- **Confirmação de apagar tudo.**
- **Lista de apps com busca sem resultado.**

## Erros de hoje que não podem voltar
Título "Visão geral — 30 dias" nas abas de 1 e 7 dias; "esta semana" no donut de 30 dias; rótulos
do eixo Y encavalados; cores de legenda repetidas; círculos com letra em vez de ícone; o AppTime
listando a si mesmo; apps com 0 min enchendo a lista; rótulos em inglês (`unlocks`, `session`).

## O que entregar
Cada tela e cada estado acima, seguindo o brief à risca. Rotule cada artboard
(ex.: `Hoje — dia 3 (habitual se formando)`).
