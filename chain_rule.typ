#set document(title: "Chain Rule e Ottimizzazione dei Calcoli")
#set page(paper: "a4", margin: 2cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "it")
#set heading(numbering: "1.1")
#set math.equation(numbering: "(1)")

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  text(size: 18pt, weight: "bold", it)
  v(0.5em)
}

#show heading.where(level: 2): it => {
  v(1em)
  text(size: 14pt, weight: "bold", it)
  v(0.3em)
}

#show heading.where(level: 3): it => {
  v(0.8em)
  text(size: 12pt, weight: "bold", it)
  v(0.2em)
}

// Titolo
#align(center)[
  #text(size: 24pt, weight: "bold")[Chain Rule e Ottimizzazione dei Calcoli]
  #v(1em)
  #text(size: 12pt)[Lezione per Liceo Scientifico (4°-5° anno)]
]

#v(2em)

= Prerequisiti

- Derivate di funzioni elementari (potenze, esponenziali, logaritmi, trigonometriche)
- Composizione di funzioni: $(f compose g)(x) = f(g(x))$
- Regola della catena (chain rule): se $h(x) = f(g(x))$, allora $h'(x) = f'(g(x)) dot g'(x)$

#line(length: 100%)

= Il Problema: Funzioni Composte Multiple

== Situazione

Immaginiamo di avere una funzione composta da *molti strati*:

#align(center)[
  $x arrow g_1(x) arrow g_2(dot) arrow g_3(dot) arrow dots arrow g_n (dot) arrow y$
]

*Esempio concreto con 3 funzioni*:

$ y = f(x) = e^(sin(x^2 + 1)) $

Possiamo scomporla come composizione:
- $g_1(x) = x^2 + 1$ (funzione quadratica)
- $g_2(u) = sin(u)$ (funzione seno)
- $g_3(v) = e^v$ (funzione esponenziale)
- $y = g_3(g_2(g_1(x)))$

#line(length: 100%)

= Obiettivo Didattico

Vogliamo calcolare *in un punto $x_0$*:
1. Il *valore* della funzione: $y = f(x_0)$
2. La *derivata* della funzione: $y' = f'(x_0)$

#rect(fill: luma(240), inset: 10pt, width: 100%)[
  *Domanda chiave*: Come possiamo essere *efficienti* ed evitare calcoli ridondanti?
]

#line(length: 100%)

= Approccio Naive (Inefficiente)

== Calcolo del valore $y = f(x_0)$

Calcoliamo dall'interno verso l'esterno con $x_0 = 0.5$:

#table(
  columns: (auto, auto, auto),
  inset: 8pt,
  align: left,
  [*Step*], [*Calcolo*], [*Risultato*],
  [1], [$u_1 = g_1(0.5) = (0.5)^2 + 1$], [$1.25$],
  [2], [$u_2 = g_2(1.25) = sin(1.25)$], [$0.9490$],
  [3], [$y = g_3(0.9490) = e^(0.9490)$], [$2.5832$],
)

== Calcolo della derivata $f'(x_0)$ - Approccio Naive

=== Passo 1: Derivare la formula analitica

Prima troviamo la formula generale di $f'(x)$ usando la chain rule.

Abbiamo: $f(x) = e^(sin(x^2 + 1))$

Scomponiamo:
- $g_1(x) = x^2 + 1$
- $g_2(u) = sin(u)$
- $g_3(v) = e^v$

*Derivate delle singole funzioni*:
- $g_1'(x) = 2x$
- $g_2'(u) = cos(u)$
- $g_3'(v) = e^v$

*Applicazione della chain rule*:

$ f'(x) = g_3'(g_2(g_1(x))) dot g_2'(g_1(x)) dot g_1'(x) $

Sostituiamo le derivate:

$ f'(x) = e^(sin(x^2 + 1)) dot cos(x^2 + 1) dot 2x $

*Forma finale (NON si semplifica ulteriormente!)*:

$ f'(x) = 2x dot cos(x^2 + 1) dot e^(sin(x^2 + 1)) $

#rect(fill: rgb("#fff3cd"), inset: 10pt, width: 100%)[
  *Nota*: La derivata contiene *tutte e tre le funzioni* ($x^2$, sin, $e$) - non c'è semplificazione!
]

=== Passo 2: Valutare numericamente in $x_0 = 0.5$

Sostituiamo $x = 0.5$:

$ f'(0.5) = 2 dot 0.5 dot cos(0.5^2 + 1) dot e^(sin(0.5^2 + 1)) $

$ f'(0.5) = 1.0 dot cos(1.25) dot e^(sin(1.25)) $

Calcoliamo ogni componente:
- $x^2 + 1 = 0.25 + 1 = 1.25$ #text(fill: red)[← *RICALCOLATO* (già fatto prima!)]
- $sin(1.25) approx 0.9490$ #text(fill: red)[← *RICALCOLATO* (già fatto prima!)]
- $cos(1.25) approx 0.3153$
- $e^(sin(1.25)) = e^(0.9490) approx 2.5832$ #text(fill: red)[← *RICALCOLATO* (era già $y$!)]

Quindi:

$ f'(0.5) = 1.0 dot 0.3153 dot 2.5832 approx 0.8145 $

#rect(fill: rgb("#f8d7da"), inset: 10pt, width: 100%)[
  *Problema*: Abbiamo *RICALCOLATO* i valori intermedi che avevamo già ottenuto:
  - $x^2 + 1 = 1.25$ (già calcolato per $y$)
  - $sin(1.25) = 0.9490$ (già calcolato per $y$)
  - $e^(sin(1.25)) = 2.5832$ (questo *È* $y$ che avevamo già calcolato!)
]

#line(length: 100%)

= Approccio Ottimizzato: Memorizzare i Valori Intermedi

== Idea Chiave

#rect(fill: rgb("#d4edda"), inset: 10pt, width: 100%)[
  *Quando calcoliamo $y$, salviamo tutti i valori intermedi in memoria.*

  Poi, quando calcoliamo $f'(x)$, *riusiamo questi valori* invece di ricalcolarli!
]

== Passo 1: Calcolo di $y$ (salvando i valori intermedi)

Calcoliamo la funzione normalmente e *salviamo* tutti i valori intermedi:

#table(
  columns: (auto, auto, auto, auto),
  inset: 8pt,
  align: left,
  [*Layer*], [*Calcolo*], [*Risultato*], [*Azione*],
  [Input], [$x$], [$0.5$], [SALVA $x$],
  [1], [$u_1 = g_1(x) = x^2 + 1$], [$1.25$], [SALVA $u_1$],
  [2], [$u_2 = g_2(u_1) = sin(1.25)$], [$0.9490$], [SALVA $u_2$],
  [3], [$y = g_3(u_2) = e^(0.9490)$], [$2.5832$], [SALVA $y$],
)

*Valori salvati in memoria*: $x = 0.5$, $u_1 = 1.25$, $u_2 = 0.9490$, $y = 2.5832$

== Passo 2: Calcolo di $f'(x)$ (riusando i valori salvati)

Ora calcoliamo la derivata usando la *chain rule*:

$ f'(x) = g_1'(x) dot g_2'(u_1) dot g_3'(u_2) $

*L'ottimizzazione*: Invece di ricalcolare $u_1$ e $u_2$, li prendiamo dalla memoria!

#table(
  columns: (auto, auto, auto, auto),
  inset: 8pt,
  align: left,
  [*Layer*], [*Derivata*], [*Usa valore salvato*], [*Risultato*],
  [1], [$g_1'(x) = 2x$], [$x = 0.5$], [$1.0$],
  [2], [$g_2'(u_1) = cos(u_1)$], [$u_1 = 1.25$], [$0.3153$],
  [3], [$g_3'(u_2) = e^(u_2)$], [$u_2 = 0.9490$], [$2.5832$],
)

*Chain rule*: $f'(0.5) = 1.0 times 0.3153 times 2.5832 = 0.8145$

#line(length: 100%)

= Confronto: Naive vs Ottimizzato

#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  [
    == Approccio Naive

    *Operazioni totali*:
    - Calcolo di $y$: 3 funzioni
    - Calcolo di $y'$: 3 derivate + *RICALCOLO* di $g_1$, $g_2$
    - *Totale: 8 valutazioni*
  ],
  [
    == Approccio Ottimizzato

    *Operazioni totali*:
    - Calcolo $y$ (salvando valori): 3 funzioni
    - Calcolo $y'$ (riusando valori): 3 derivate
    - *Totale: 6 operazioni*
  ]
)

#rect(fill: rgb("#cce5ff"), inset: 10pt, width: 100%)[
  *Risparmio*: 25% in questo esempio semplice

  *Con funzioni più complesse* (10-100 layer): il risparmio diventa *50%+*!
]

#line(length: 100%)

= Calcolo Unificato: Funzione e Derivata in Parallelo

== Schema del Flusso di Calcolo

#import "@preview/cetz:0.3.2"

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    // Colori
    let func-fill = rgb("#e8f4ea")
    let deriv-fill = rgb("#fff3cd")
    let arrow-color = rgb("#555555")

    // Dimensioni
    let box-width = 2.0
    let box-height = 0.8
    let h-gap = 4.0  // distanza orizzontale tra colonne
    let v-gap = 1.6  // distanza verticale tra righe

    // Posizioni x delle colonne
    let left-x = 0
    let right-x = left-x + h-gap

    // Titoli colonne
    content((left-x + box-width/2, 0.8), text(weight: "bold", size: 10pt)[FUNZIONE])
    content((left-x + box-width/2, 0.3), text(size: 8pt, fill: luma(100))[(output salvati)])
    content((right-x + box-width/2, 0.8), text(weight: "bold", size: 10pt)[DERIVATA])
    content((right-x + box-width/2, 0.3), text(size: 8pt, fill: luma(100))[(riusa gli output)])

    // Funzione per disegnare un box
    let draw-box(x, y, label, fill-color) = {
      rect(
        (x, y),
        (x + box-width, y - box-height),
        fill: fill-color,
        stroke: 0.5pt + black,
        radius: 3pt
      )
      content((x + box-width/2, y - box-height/2), label)
    }

    // Funzione per freccia verticale (colonna sinistra)
    let v-arrow(y1, y2) = {
      line(
        (left-x + box-width/2, y1 - box-height - 0.1),
        (left-x + box-width/2, y2 + 0.1),
        stroke: 1pt + arrow-color,
        mark: (end: "stealth", fill: arrow-color, scale: 0.5)
      )
    }

    // Funzione per freccia obliqua (da sinistra-alto a destra-basso)
    let diag-arrow(y-from, y-to) = {
      line(
        (left-x + box-width + 0.1, y-from - box-height/2),
        (right-x - 0.1, y-to - box-height/2),
        stroke: 1pt + rgb("#cc6600"),
        mark: (end: "stealth", fill: rgb("#cc6600"), scale: 0.5)
      )
    }

    // Riga 0: solo x (nessuna derivata)
    let y0 = -0.5
    draw-box(left-x, y0, $x$, func-fill)

    // Freccia verticale
    v-arrow(y0, y0 - v-gap)

    // Riga 1: g₁(·) | g₁'(x)
    let y1 = y0 - v-gap
    draw-box(left-x, y1, $g_1(dot)$, func-fill)
    draw-box(right-x, y1, $g_1'(x)$, deriv-fill)
    // Freccia obliqua da x (riga sopra) a g₁'
    diag-arrow(y0, y1)

    // Freccia verticale
    v-arrow(y1, y1 - v-gap)

    // Riga 2: g₂(·) | g₂'(·)
    let y2 = y1 - v-gap
    draw-box(left-x, y2, $g_2(dot)$, func-fill)
    draw-box(right-x, y2, $g_2'(dot)$, deriv-fill)
    // Freccia obliqua da g₁ (riga sopra) a g₂'
    diag-arrow(y1, y2)

    // Freccia verticale
    v-arrow(y2, y2 - v-gap)

    // Riga 3: g₃(·) | g₃'(·)
    let y3 = y2 - v-gap
    draw-box(left-x, y3, $g_3(dot)$, func-fill)
    draw-box(right-x, y3, $g_3'(dot)$, deriv-fill)
    // Freccia obliqua da g₂ (riga sopra) a g₃'
    diag-arrow(y2, y3)

    // Freccia verticale
    v-arrow(y3, y3 - v-gap)

    // Riga 4: y | 1 (dy/dy = 1)
    let y4 = y3 - v-gap
    draw-box(left-x, y4, $y$, func-fill)
    draw-box(right-x, y4, $1$, deriv-fill)
    // Freccia obliqua da g₃ (riga sopra) a 1
    diag-arrow(y3, y4)
  }),
  caption: [Schema del flusso di calcolo (esempio con 3 funzioni)]
)

=== Schema Generale (n funzioni)

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    // Colori
    let func-fill = rgb("#e8f4ea")
    let deriv-fill = rgb("#fff3cd")
    let arrow-color = rgb("#555555")

    // Dimensioni
    let box-width = 2.0
    let box-height = 0.8
    let h-gap = 4.0
    let v-gap = 1.6

    // Posizioni x delle colonne
    let left-x = 0
    let right-x = left-x + h-gap

    // Titoli colonne
    content((left-x + box-width/2, 0.8), text(weight: "bold", size: 10pt)[FUNZIONE])
    content((right-x + box-width/2, 0.8), text(weight: "bold", size: 10pt)[DERIVATA])

    // Funzione per disegnare un box
    let draw-box(x, y, label, fill-color) = {
      rect(
        (x, y),
        (x + box-width, y - box-height),
        fill: fill-color,
        stroke: 0.5pt + black,
        radius: 3pt
      )
      content((x + box-width/2, y - box-height/2), label)
    }

    // Funzione per freccia verticale
    let v-arrow(y1, y2) = {
      line(
        (left-x + box-width/2, y1 - box-height - 0.1),
        (left-x + box-width/2, y2 + 0.1),
        stroke: 1pt + arrow-color,
        mark: (end: "stealth", fill: arrow-color, scale: 0.5)
      )
    }

    // Funzione per freccia obliqua
    let diag-arrow(y-from, y-to) = {
      line(
        (left-x + box-width + 0.1, y-from - box-height/2),
        (right-x - 0.1, y-to - box-height/2),
        stroke: 1pt + rgb("#cc6600"),
        mark: (end: "stealth", fill: rgb("#cc6600"), scale: 0.5)
      )
    }

    // Riga 0: x
    let y0 = -0.5
    draw-box(left-x, y0, $x$, func-fill)
    v-arrow(y0, y0 - v-gap)

    // Riga 1: g₁ | g₁'
    let y1 = y0 - v-gap
    draw-box(left-x, y1, $g_1(dot)$, func-fill)
    draw-box(right-x, y1, $g_1'(x)$, deriv-fill)
    diag-arrow(y0, y1)
    v-arrow(y1, y1 - v-gap)

    // Riga 2: g₂ | g₂'
    let y2 = y1 - v-gap
    draw-box(left-x, y2, $g_2(dot)$, func-fill)
    draw-box(right-x, y2, $g_2'(dot)$, deriv-fill)
    diag-arrow(y1, y2)
    v-arrow(y2, y2 - v-gap)

    // Riga 3: ... | ...
    let y3 = y2 - v-gap
    content((left-x + box-width/2, y3 - box-height/2), text(size: 14pt)[⋮])
    content((right-x + box-width/2, y3 - box-height/2), text(size: 14pt)[⋮])

    // Freccia verticale tratteggiata (distanza = un box invisibile in mezzo)
    let y4 = y3 - v-gap
    line(
      (left-x + box-width/2, y2 - box-height - 0.1),
      (left-x + box-width/2, y4 + 0.1),
      stroke: (dash: "dashed", paint: arrow-color, thickness: 1pt),
      mark: (end: "stealth", fill: arrow-color, scale: 0.5)
    )

    // Riga 4: gₙ | gₙ'
    draw-box(left-x, y4, $g_n (dot)$, func-fill)
    draw-box(right-x, y4, $g_n'(dot)$, deriv-fill)
    // Freccia obliqua tratteggiata (parallela alle altre: da y3 a y4, Δy = v-gap)
    line(
      (left-x + box-width + 0.1, y3 - box-height/2),
      (right-x - 0.1, y4 - box-height/2),
      stroke: (dash: "dashed", paint: rgb("#cc6600"), thickness: 1pt),
      mark: (end: "stealth", fill: rgb("#cc6600"), scale: 0.5)
    )
    v-arrow(y4, y4 - v-gap)

    // Riga 5: y | 1
    let y5 = y4 - v-gap
    draw-box(left-x, y5, $y$, func-fill)
    draw-box(right-x, y5, $1$, deriv-fill)
    diag-arrow(y4, y5)
  }),
  caption: [Schema generale per composizione di $n$ funzioni: $y = g_n (g_(n-1)( dots g_2(g_1(x)) dots ))$]
)

== Tabella Riassuntiva

#table(
  columns: (auto, auto, auto, 1fr, auto, auto),
  inset: 8pt,
  align: (center, left, center, center, left, center),
  fill: (col, row) => if row == 0 { luma(230) } else { white },
  [*Input*], [*Funzione*], [*Output*], [$arrow.r$], [*Derivata (usa output a sinistra)*], [*Valore*],
  [$x_0$], [$x$], [*0.5*], [$arrow.r$], [$g_1'(x) = 2x$], [1.0],
  [0.5], [$g_1(x) = x^2 + 1$], [*1.25*], [$arrow.r$], [$g_2'(u_1) = cos(u_1)$], [0.3153],
  [1.25], [$g_2(u_1) = sin(u_1)$], [*0.9490*], [$arrow.r$], [$g_3'(u_2) = e^(u_2)$], [2.5832],
  [0.9490], [$g_3(u_2) = e^(u_2)$], [*2.5832*], [], [(nessuna)], [],
)

*Risultati*:
- $f(0.5) = y = 2.5832$
- $f'(0.5) = 1.0 times 0.3153 times 2.5832 = 0.8145$

== Cosa mostra questo schema?

1. *Frecce verticali ($arrow.b$)*: L'output di ogni funzione diventa l'input della funzione successiva
2. *Frecce orizzontali ($arrow.r$)*: L'output della funzione (colonna sinistra) è usato come input per calcolare la *derivata successiva* (colonna destra)
3. *Sfalsamento*: La derivata $g_(i+1)'(dot)$ usa l'output di $g_i (dot)$ → sono sulla stessa riga!
4. *Nessun ricalcolo*: Le derivate "pescano" i valori già calcolati dalla colonna di sinistra
5. *Ultima riga*: L'ultima funzione ($g_3$) non ha derivata corrispondente a destra

#pagebreak()

= Esempio con Funzione Più Complessa (6 Layer)

== Funzione

$ y = f(x) = cos(sqrt(e^(sin(ln(x^2))))) $

Composizione di 6 funzioni:
- $g_1(x) = x^2$
- $g_2(u) = ln(u)$
- $g_3(v) = sin(v)$
- $g_4(w) = e^w$
- $g_5(z) = sqrt(z)$
- $g_6(t) = cos(t)$

== Tabella di Calcolo Dettagliata

#table(
  columns: (auto, auto, auto, 1fr, auto, auto),
  inset: 6pt,
  align: (center, left, center, center, left, center),
  fill: (col, row) => if row == 0 { luma(230) } else { white },
  [*Input*], [*Funzione*], [*Output*], [$arrow.r$], [*Derivata (usa output a sinistra)*], [*Valore*],
  [$x_0$], [$x$], [*1.5*], [$arrow.r$], [$g_1'(x) = 2x$], [3.0000],
  [1.5], [$g_1(x) = x^2$], [*2.2500*], [$arrow.r$], [$g_2'(u_1) = 1/u_1$], [0.4444],
  [2.2500], [$g_2(u_1) = ln(u_1)$], [*0.8109*], [$arrow.r$], [$g_3'(u_2) = cos(u_2)$], [0.6890],
  [0.8109], [$g_3(u_2) = sin(u_2)$], [*0.7247*], [$arrow.r$], [$g_4'(u_3) = e^(u_3)$], [2.0640],
  [0.7247], [$g_4(u_3) = e^(u_3)$], [*2.0640*], [$arrow.r$], [$g_5'(u_4) = 1/(2sqrt(u_4))$], [0.3480],
  [2.0640], [$g_5(u_4) = sqrt(u_4)$], [*1.4367*], [$arrow.r$], [$g_6'(u_5) = -sin(u_5)$], [-0.9911],
  [1.4367], [$g_6(u_5) = cos(u_5)$], [*0.1330*], [], [(nessuna)], [],
)

== Risultati

*Valore della funzione*:
$ f(1.5) = 0.1330 $

*Derivata* (prodotto di tutte le derivate):
$ f'(1.5) = 3.0 times 0.4444 times 0.6890 times 2.0640 times 0.3480 times (-0.9911) $
$ f'(1.5) = -0.6156 $

== Osservazioni

1. *6 funzioni, 6 valori salvati*: $u_1, u_2, u_3, u_4, u_5, y$
2. *6 derivate calcolate*: ognuna usa il valore della riga corrispondente
3. *Nessun ricalcolo*: ogni valore nella colonna FUNZIONE è usato esattamente una volta per la derivata
4. *Segno negativo*: la derivata di cos è $-sin$, quindi $f'(1.5) < 0$

== Confronto con Approccio Naive

#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  [
    *Approccio Naive*:
    - Calcolo $y$: 6 funzioni
    - Calcolo $y'$: ricalcolo 5 valori + 6 derivate
    - *Totale: 17 operazioni*
  ],
  [
    *Approccio Ottimizzato*:
    - Calcolo $y$ (con memorizzazione): 6 funzioni
    - Calcolo $y'$ (riusando valori): 6 derivate
    - *Totale: 12 operazioni*
  ]
)

#rect(fill: rgb("#d4edda"), inset: 10pt, width: 100%)[
  *Risparmio: 30%* (e aumenta con più layer!)
]

#line(length: 100%)

= Collegamento con le Reti Neurali

== Perché è importante per il Deep Learning?

Nelle reti neurali:
- Ogni *layer* è una funzione: $z = W dot x + b$ seguito da attivazione $sigma(z)$
- Una rete con 100 layer ha *100 composizioni* di funzioni
- Durante il *training*, dobbiamo calcolare:
  1. *Predizione*: calcolare l'output $y$ (passando attraverso tutti i layer)
  2. *Gradienti*: calcolare le derivate per aggiornare i pesi

#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  [
    #rect(fill: rgb("#f8d7da"), inset: 10pt)[
      *Senza memorizzazione*: dovremmo ricalcolare l'output di ogni layer → impossibile!
    ]
  ],
  [
    #rect(fill: rgb("#d4edda"), inset: 10pt)[
      *Con memorizzazione*: calcoliamo ogni layer una volta, salviamo, riusiamo → efficiente!
    ]
  ]
)

== Analogia Diretta

#table(
  columns: (1fr, 1fr),
  inset: 10pt,
  align: left,
  fill: (col, row) => if row == 0 { luma(230) } else { white },
  [*Matematica (Chain Rule)*], [*Deep Learning (Backpropagation)*],
  [Funzioni $g_1, g_2, g_3$], [Layer della rete (Dense, Conv, etc.)],
  [Valori intermedi $u_1, u_2$], [Attivazioni di ogni layer],
  [Calcolo di $y$], [Forward propagation],
  [Calcolo di $f'(x)$ con chain rule], [Backpropagation (calcolo gradienti)],
  [Memorizzazione valori intermedi], [Cache delle attivazioni],
)

#line(length: 100%)

= Implementazione Python

== Codice Didattico

#rect(fill: luma(250), inset: 10pt, width: 100%)[
```python
import numpy as np

# Definizione delle funzioni e delle loro derivate
def g1(x):
    return x**2 + 1

def g1_prime(x):
    return 2 * x

def g2(u):
    return np.sin(u)

def g2_prime(u):
    return np.cos(u)

def g3(v):
    return np.exp(v)

def g3_prime(v):
    return np.exp(v)

# FORWARD PASS - Calcolo di y e salvataggio valori intermedi
def forward_pass(x):
    cache = {}  # Dizionario per salvare i valori
    cache['x'] = x
    cache['u1'] = g1(x)
    cache['u2'] = g2(cache['u1'])
    cache['y'] = g3(cache['u2'])
    return cache['y'], cache

# Calcolo della derivata usando i valori salvati
def compute_derivative(cache):
    g1_p = g1_prime(cache['x'])    # Usa x salvato!
    g2_p = g2_prime(cache['u1'])   # Usa u1 salvato!
    g3_p = g3_prime(cache['u2'])   # Usa u2 salvato!
    return g1_p * g2_p * g3_p

# ESEMPIO
x0 = 0.5
y, cache = forward_pass(x0)
dy_dx = compute_derivative(cache)

print(f"f({x0}) = {y:.4f}")
print(f"f'({x0}) = {dy_dx:.4f}")
```
]

#line(length: 100%)

= Esercizi Proposti

== Esercizio 1: Calcolo Manuale

Data la funzione: $y = cos(e^x)$ con $x = 0$

1. Scomponi in $g_1(x) = e^x$ e $g_2(u) = cos(u)$
2. Calcola la funzione (trova $y$)
3. Calcola la derivata (trova $y'$)
4. Verifica che non stai ricalcolando valori

== Esercizio 2: Implementazione Python

Implementa il calcolo per:

$ y = sqrt(x^3 + 2x) $

Valuta in $x = 2$.

== Esercizio 3: Funzione a 4 Layer

Data la funzione:

$ y = ln(sin(sqrt(x^2 + 1))) $

1. Identifica i 4 layer ($g_1, g_2, g_3, g_4$)
2. Costruisci la tabella del calcolo per $x = 1$
3. Calcola $y'(1)$

#line(length: 100%)

= Domande di Verifica

1. *Perché salvare i valori intermedi durante il calcolo della funzione?*
   - Risposta: Per evitare di ricalcolarli durante il calcolo della derivata

2. *Cosa succederebbe se non salvassimo nulla?*
   - Risposta: Dovremmo ricalcolare $g_1(x)$, $g_2(g_1(x))$, ecc. ogni volta → molto inefficiente

3. *Quante volte valutiamo ogni funzione con l'approccio ottimizzato?*
   - Risposta: Esattamente 1 volta

4. *Perché questo è cruciale per le reti neurali?*
   - Risposta: Le reti hanno centinaia di layer → senza ottimizzazione, training impossibile

#line(length: 100%)

= Conclusione

#rect(fill: rgb("#e7f3ff"), inset: 15pt, width: 100%)[
  *Concetto chiave*: La chain rule + memorizzazione dei valori intermedi = algoritmo efficiente!

  *Strategia vincente*:
  1. *Calcola la funzione*: Passa attraverso tutti i layer, *memorizza ogni risultato intermedio*
  2. *Calcola la derivata*: Applica la chain rule, *riusa i valori già calcolati*

  *Perché funziona*:
  - Le derivate $g_1'(x)$, $g_2'(u_1)$, $g_3'(u_2)$ hanno bisogno degli stessi valori che abbiamo già calcolato!
  - $g_3'(u_2)$ richiede $u_2$ → già in memoria ✓
  - $g_2'(u_1)$ richiede $u_1$ → già in memoria ✓
  - $g_1'(x)$ richiede $x$ → già in memoria ✓

  *Impatto*:
  - Evita ricalcoli ridondanti (50%+ risparmio con molti layer)
  - Rende possibile il training di reti profonde
  - Fondamento della backpropagation
]

#align(center)[
  #text(size: 14pt, weight: "bold")[Machine Learning = Matematica + Ottimizzazione Algoritmica]
]

#line(length: 100%)

= Risorse Extra

== Video Consigliati
- 3Blue1Brown: "Backpropagation calculus" (visualizzazione eccellente)
- StatQuest: "Backpropagation Step by Step"

== Letture
- "Deep Learning" (Goodfellow et al.) - Chapter 6: Backpropagation
- "Neural Networks and Deep Learning" (Nielsen) - Online free book

== Tool Interattivi
- TensorFlow Playground: visualizza forward/backward in tempo reale
- Desmos: grafica le funzioni composte passo per passo
