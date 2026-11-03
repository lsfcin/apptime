# AppTime — termômetro: variações de visual (brief para Claude Design)

Desenhe **variações de um sinal novo, o termômetro**, dentro do visor flutuante (overlay) do app
Android AppTime e na tela Hoje. Textos em **português do Brasil**. As capturas anexas
(`pill-*`, `block-*`, claro e escuro, quatro feedbacks cada) mostram o visor de hoje no celular:
desenhe **por cima delas**, no mesmo tamanho e no mesmo lugar.

## O app, em uma frase
AppTime reduz o vício em celular por consciência, sem bloquear nada. A única referência é a própria
pessoa: não há metas.

## O que o visor já mostra
- **Número**: tempo de hoje no app que está na frente (`12m`, `1h44`).
- **Progresso**: o dia (desde 04:00) contra o habitual diário desse app — barra sob o número,
  ponto que enche, ou contorno. Âmbar quando passa do habitual.
Cada um pode ser desligado; o visor precisa funcionar com qualquer combinação.

## O termômetro (novo)
Uso **desse app nas últimas 24 horas contra as 24 horas antes delas**. Sobe e desce o dia todo:
responde "estou melhor ou pior agora", enquanto o progresso só avisa quando o dia estoura.
Nunca pula na virada da hora. Rótulo, onde houver texto: **"Uso nas últimas 24 horas"**.
Três estados: **calmo** (igual ou menos que antes) · **piorando** · **muito pior**.
Só queremos menos: o sinal nunca convida a subir.

## Os três visores
- **Pílula**: na barra de status, ao lado dos ícones, 14 sp, sem fundo, halo escuro. Cabe em 52 dp
  de largura; não aceita toque.
- **Bloco**: abaixo da barra, fundo preto 96%, 17 sp negrito; pode ser arrastado.
- **Aba** (ainda não existe, sem captura): presa a uma borda da tela, como uma aba de navegador
  virada. Pendurada na barra de status (cantos de baixo arredondados, os de cima colados à barra)
  ou na lateral (cantos do lado da tela arredondados, o lado da borda reto). Desliza pela borda.
- **Hoje** (tela do app): o termômetro do **celular inteiro** ao lado de "hoje até agora".

## Sementes do Lucas (comece por elas)
1. **Cor**: calmo × ruim. Calmo é branco / tinta automática, não lavanda.
2. **Símbolo de mão única**: ▼ "use menos", ou uma marca calma de "ok". **Nunca ▲.**
3. **Termômetro vertical**: uma linha vertical alta com um tracinho horizontal fino que corre por
   ela, em escala logarítmica com o meio baixo.
4. **Ruído**: uma linha reta quando calmo, que começa a oscilar ao piorar, tipo ECG quando muito pior.
Depois, **variações livres** suas.

## Regras
- Sem vermelho, sem verde neon, sem azul elétrico. Âmbar `#E5A93C` como hoje; âmbar e laranja
  diferem também em luminância.
- **Cor nunca sozinha**: estado também em forma, movimento ou texto.
- Não pode confundir com o progresso: quem olha precisa saber qual sinal é qual.
- No claro a pílula some: texto branco em fundo branco (veja `pill-none-light`). O halo escuro
  em volta da fonte está **rejeitado**. Proponha tinta que funcione nos dois fundos, sem halo, e um
  tom de âmbar com bom contraste (AA) também no branco.

## O que entregar
Para cada semente e cada variação livre: pílula, Bloco e Aba, cada um em **3 estados**, **claro e
escuro**, em **3 combinações** (só termômetro · número + termômetro · número + progresso +
termômetro). Uma artboard de Hoje para as duas ou três melhores. Rotule cada artboard
(ex.: `ECG — Bloco — piorando — escuro — número+termômetro`). No fim, em poucas linhas: qual você
escolheria e por quê.
