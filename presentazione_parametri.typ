#set page(width: 25.4cm, height: 14.29cm, margin: (x: 1cm, y: 0.8cm))
#set text(font: "New Computer Modern", size: 10.5pt, lang: "it")

#import "@preview/cetz:0.3.2"

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")
#let arancio = rgb("#e67e22")

// ============================================================
// SLIDE 1 — A Caccia di Parametri (Gioconda, problema)
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[A Caccia di Parametri]
  #v(0.05cm)
  #text(size: 12pt, fill: luma(80))[Caso Studio: Posizionare la Gioconda al Louvre]
]

#v(0.2cm)

#grid(
  columns: (auto, 1fr),
  gutter: 1cm,
  [
    #image("gioconda.jpg", height: 8.5cm)
  ],
  [
    #box(stroke: 1pt + gray, radius: 5pt, fill: luma(250), inset: 10pt, width: 100%)[
      *Il problema*

      Il quadro più famoso del mondo deve essere appeso alla parete. A che altezza ($h$) posizioniamo il bordo inferiore?

      #v(0.1cm)

      *Vincolo*: il centro del dipinto deve trovarsi *56 cm sopra* l'altezza del visitatore medio.
    ]

    #v(0.3cm)

    #box(stroke: 1.5pt + verde, radius: 5pt, fill: verde.lighten(95%), inset: 10pt, width: 100%)[
      *I dati disponibili*

      - Database: *10 milioni* di ingressi anonimi all'anno
      - Variabile misurata: altezza dei visitatori
      - Popolazione eterogenea: turisti da tutto il mondo, scolaresche, famiglie...
    ]

    #v(0.3cm)

    #box(stroke: 1.5pt + rosso, radius: 5pt, fill: rosso.lighten(95%), inset: 10pt, width: 100%)[
      *La domanda*

      Come estraiamo *un singolo numero* da milioni di misurazioni per prendere una decisione concreta?
    ]
  ]
)

#pagebreak()

// ============================================================
// SLIDE 2 — Soluzione Gioconda
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[A Caccia di Parametri — La Soluzione]
]

#v(0.3cm)

#grid(
  columns: (7.2cm, 7.2cm, 7.2cm),
  gutter: 0.6cm,
  box(stroke: 1.5pt + verde, radius: 8pt, fill: verde.lighten(95%), inset: 10pt)[
    #text(size: 12pt, weight: "bold", fill: verde)[1. I Dati (Input)]

    #v(0.2cm)

    #text(size: 10pt)[
      *Database*: 10 milioni di ingressi anonimi all'anno.

      *Variabile*: altezza dei visitatori.
    ]

    #v(0.2cm)

    #box(stroke: 1pt + verde.darken(10%), radius: 4pt, fill: verde.lighten(85%), inset: 6pt)[
      #text(size: 9pt, fill: verde.darken(40%))[
        In AI questo è il nostro *Dataset di Addestramento*.
      ]
    ]
  ],
  box(stroke: 1.5pt + viola, radius: 8pt, fill: viola.lighten(95%), inset: 10pt)[
    #text(size: 12pt, weight: "bold", fill: viola)[2. Il Peso ($w$)]

    #v(0.2cm)

    #text(size: 10pt)[
      Calcoliamo la media delle altezze:
    ]

    #v(0.1cm)

    #align(center)[
      $ m = frac(1, N) sum_(i=1)^(N) x_i = 175 "cm" $
    ]

    #v(0.1cm)

    #text(size: 10pt)[
      Se i dati cambiano, il valore $m$ cambia.
    ]

    #v(0.2cm)

    #box(stroke: 1pt + viola.darken(10%), radius: 4pt, fill: viola.lighten(85%), inset: 6pt)[
      #text(size: 9pt, fill: viola.darken(40%))[
        In AI questo è il *Peso* ($w$): il valore numerico imparato dai dati.
      ]
    ]
  ],
  box(stroke: 1.5pt + blu, radius: 8pt, fill: blu.lighten(95%), inset: 10pt)[
    #text(size: 12pt, weight: "bold", fill: blu)[3. Il Modello]

    #v(0.2cm)

    #text(size: 10pt)[
      La formula: $h = m + 56$

      È la struttura fissa. Non cambia al variare dei visitatori, ma ospita il peso per produrre il risultato.
    ]

    #v(0.2cm)

    #box(stroke: 1pt + blu.darken(10%), radius: 4pt, fill: blu.lighten(85%), inset: 6pt)[
      #text(size: 9pt, fill: blu.darken(40%))[
        In AI questa è la *Funzione di Predizione*: l'architettura del modello.
      ]
    ]
  ],
)

#v(0.3cm)

#align(center)[
  #box(stroke: 1.5pt + rosso, radius: 8pt, fill: rosso.lighten(95%), inset: 10pt)[
    #text(size: 10.5pt)[
      Il *Modello* è la domanda che poniamo ai dati ($h = dots.h + 56$). \
      Il *Peso* è la risposta che i dati ci danno ($m = 175$) per agire nel mondo reale.
    ]
  ]
]

#pagebreak()

// ============================================================
// SLIDE 3 — Gaussiana
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[Perché la Media?]
]

#v(0.2cm)

#align(center)[
#cetz.canvas(length: 0.7cm, {
  import cetz.draw: *

  let mu = 5
  let paint-cy = 9
  let sigma = 1.0
  let amp = 6
  let wall-x = 5
  let gauss-axis = 16

  // === PARETE ===
  rect((0, -0.3), (wall-x, 11.5), fill: luma(245), stroke: none)
  line((0, 0), (wall-x + 0.5, 0), stroke: 1.5pt + luma(150))

  // Gioconda sulla parete
  content((2.5, paint-cy), image("gioconda.jpg", height: 3.5cm))

  // === LINEE DI RIFERIMENTO ===
  line((-0.5, mu), (gauss-axis, mu),
    stroke: (dash: "dotted", paint: viola.lighten(30%), thickness: 0.7pt))

  line((-0.5, paint-cy), (wall-x + 0.3, paint-cy),
    stroke: (dash: "dotted", paint: blu.lighten(30%), thickness: 0.7pt))

  // === ETICHETTE ALTEZZE ===
  content((-1.8, mu), anchor: "east",
    text(size: 9pt, weight: "bold", fill: viola)[175 cm])
  content((-1.8, mu - 0.55), anchor: "east",
    text(size: 7pt, fill: luma(100))[altezza media])

  content((-1.8, paint-cy), anchor: "east",
    text(size: 9pt, weight: "bold", fill: blu)[231 cm])
  content((-1.8, paint-cy - 0.55), anchor: "east",
    text(size: 7pt, fill: luma(100))[centro quadro])

  // === QUOTA +56 cm ===
  line((wall-x + 0.5, mu), (wall-x + 0.5, paint-cy),
    stroke: 1.5pt + blu,
    mark: (start: "stealth", end: "stealth", fill: blu, scale: 0.5))
  content((wall-x + 1.4, (mu + paint-cy) / 2),
    text(size: 9pt, fill: blu, weight: "bold")[+56 cm])

  // === GAUSSIANA ===
  let n = 60
  let pts = range(n + 1).map(i => {
    let t = -3.0 + 6.0 * i / n
    let y = mu + sigma * t
    let x = gauss-axis - amp * calc.exp(-t * t / 2.0)
    (x, y)
  })

  let fill-pts = ((gauss-axis, mu - 3 * sigma),) + pts + ((gauss-axis, mu + 3 * sigma),)
  line(..fill-pts, close: true, fill: viola.lighten(90%), stroke: none)

  line(..pts, stroke: 2pt + viola)

  line((gauss-axis, mu - 3.5 * sigma), (gauss-axis, mu + 3.5 * sigma),
    stroke: 1pt + luma(150))

  for (label, y) in (("150", mu - 2.5), ("175", mu), ("200", mu + 2.5)) {
    line((gauss-axis - 0.15, y), (gauss-axis + 0.15, y), stroke: 0.8pt + luma(150))
    content((gauss-axis + 0.6, y), anchor: "west",
      text(size: 7pt, fill: luma(100))[#label])
  }
  content((gauss-axis + 0.6, mu + 3.8 * sigma), anchor: "west",
    text(size: 7pt, fill: luma(100))[cm])

  content((gauss-axis - amp / 2, mu - 3.5 * sigma - 0.7),
    text(size: 8pt, fill: viola)[← N. visitatori])

  circle((gauss-axis - amp, mu), radius: 0.15, fill: rosso, stroke: 1.5pt + rosso)

  // === RETTA DI VISUALE IDEALE ===
  line((gauss-axis - amp, mu), (wall-x, paint-cy),
    stroke: (dash: "dashed", paint: rosso, thickness: 2pt),
    mark: (end: "stealth", fill: rosso, scale: 0.7))

  content(((gauss-axis - amp + wall-x) / 2 - 0.3, (mu + paint-cy) / 2 + 0.8),
    anchor: "east",
    text(size: 8pt, fill: rosso, weight: "bold")[visuale ideale])
})
]

#v(0.2cm)

#align(center)[
  #box(stroke: 1pt + gray, radius: 5pt, fill: luma(250), inset: 8pt)[
    #text(size: 10pt)[
      La media ($m = 175$ cm) è il valore con la *massima frequenza* di visitatori: il miglior compromesso per posizionare il quadro.
    ]
  ]
]

#pagebreak()

// ============================================================
// SLIDE 4 — La Moto di Marco (problema)
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[A Caccia di Parametri]
  #v(0.05cm)
  #text(size: 12pt, fill: luma(80))[Caso Studio: La Moto di Marco]
]

#v(0.3cm)

#grid(
  columns: (auto, 1fr),
  gutter: 1cm,
  [
    #image("moto.jpg", height: 5.5cm)
  ],
  [
    #box(stroke: 1pt + gray, radius: 5pt, fill: luma(250), inset: 8pt, width: 100%)[
      *La promessa*

      I genitori di Marco gli hanno promesso: #linebreak()
      _"Se prendi *9* in fisica, ti compriamo la moto."_
    ]

    #v(0.25cm)

    #box(stroke: 1.5pt + viola, radius: 5pt, fill: viola.lighten(95%), inset: 8pt, width: 100%)[
      *Il dilemma di Marco*

      - Non vuole studiare *un minuto di meno* → rischierebbe la moto
      - Non vuole studiare *un minuto di più* → efficienza!

      #v(0.1cm)

      Ha i voti dei compiti precedenti. Sa quante ore ha studiato per ciascuno.
    ]

    #v(0.25cm)

    #box(stroke: 1.5pt + rosso, radius: 5pt, fill: rosso.lighten(95%), inset: 8pt, width: 100%)[
      *La domanda*

      Quante ore deve studiare *esattamente* per prendere 9?
    ]
  ]
)

#pagebreak()

// ============================================================
// SLIDE 5 — Moto di Marco (soluzione)
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[A Caccia di Parametri — La Moto di Marco]
]

#v(0.2cm)

#grid(
  columns: (auto, 9cm),
  gutter: 0.8cm,
  [
    // === SCATTER PLOT ===
    #cetz.canvas(length: 0.6cm, {
      import cetz.draw: *

      let dati = ((1, 4.0), (2, 5.0), (3, 4.5), (4, 6.0), (5, 7.5))
      let m = 0.8
      let q = 3.0
      let x-pred = 7.5

      // Griglia
      for x in range(1, 11) {
        line((x, 0), (x, 10), stroke: 0.3pt + luma(225))
      }
      for y in range(1, 11) {
        line((0, y), (10.5, y), stroke: 0.3pt + luma(225))
      }

      // Assi
      line((-0.1, 0), (10.5, 0), stroke: 1.5pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.5))
      line((0, -0.1), (0, 10.5), stroke: 1.5pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.5))

      content((10.5, -0.8), text(size: 8pt)[Ore di studio])
      content((-0.8, 10.5), anchor: "east", text(size: 8pt)[Voto])

      // Tacche asse x
      for x in range(1, 11) {
        line((x, -0.1), (x, 0.1), stroke: 0.8pt + luma(80))
        content((x, -0.5), text(size: 7pt)[#x])
      }

      // Tacche asse y
      for y in range(1, 11) {
        line((-0.1, y), (0.1, y), stroke: 0.8pt + luma(80))
        content((-0.5, y), text(size: 7pt)[#y])
      }

      // Linea target y = 9
      line((0, 9), (x-pred, 9),
        stroke: (dash: "dotted", paint: rosso.lighten(30%), thickness: 1pt))

      // Linea previsione x = 7.5
      line((x-pred, 0), (x-pred, 9),
        stroke: (dash: "dotted", paint: rosso.lighten(30%), thickness: 1pt))

      // Retta solida
      line((0, q), (5, m * 5 + q), stroke: 2.5pt + blu)

      // Retta tratteggiata
      line((5, m * 5 + q), (x-pred, 9.0),
        stroke: (dash: "dashed", paint: blu, thickness: 2pt))

      // Residui
      for (x, y) in dati {
        let y-line = m * x + q
        line((x, y), (x, y-line),
          stroke: (dash: "dashed", paint: arancio, thickness: 1.5pt))
      }

      // Punti
      for (x, y) in dati {
        circle((x, y), radius: 0.12, fill: verde, stroke: 1pt + verde.darken(20%))
      }

      // Punto previsione
      circle((x-pred, 9.0), radius: 0.15, fill: rosso, stroke: 1.5pt + rosso.darken(20%))

      content((x-pred, -0.9), text(size: 8pt, fill: rosso, weight: "bold")[7.5])
      content((-0.8, 9), text(size: 8pt, fill: rosso, weight: "bold")[9])

      content((x-pred + 0.5, 9.6), anchor: "west",
        text(size: 7pt, fill: rosso, weight: "bold")[(7.5 , 9)])

      content((6.5, m * 6.5 + q + 0.6), anchor: "west",
        text(size: 8pt, fill: blu, weight: "bold")[$y = 0.8 x + 3$])

      // Legenda errore
      line((7, 2), (7.5, 2), stroke: (dash: "dashed", paint: arancio, thickness: 1.5pt))
      content((7.8, 2), anchor: "west",
        text(size: 7pt, fill: arancio)[errore])
    })
  ],
  [
    // === DATI + MODELLO ===

    #box(stroke: 1.5pt + verde, radius: 8pt, fill: verde.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: verde)[1. I Dati di Marco]

      #v(0.15cm)

      #table(
        columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr),
        stroke: 0.5pt + luma(200),
        fill: (x, y) => if y == 0 { verde.lighten(90%) },
        inset: 5pt,
        align: center,
        [], [*C1*], [*C2*], [*C3*], [*C4*], [*C5*],
        [*Ore* ($x$)], [1], [2], [3], [4], [5],
        [*Voto* ($y$)], [4.0], [5.0], [4.5], [6.0], [7.5],
      )
    ]

    #v(0.3cm)

    #box(stroke: 1.5pt + viola, radius: 8pt, fill: viola.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: viola)[2. Il Modello (2 parametri)]

      #v(0.15cm)

      #align(center)[
        #text(size: 12pt)[$y = m x + q$]
      ]

      #v(0.15cm)

      #text(size: 10pt)[
        Interpolazione lineare sui dati:

        #h(0.5cm) $m = 0.8$ #h(0.5cm) (pendenza) \
        #h(0.5cm) $q = 3.0$ #h(0.5cm) (intercetta)
      ]
    ]
  ]
)

#v(0.2cm)

#align(center)[
  #box(stroke: 1.5pt + rosso, radius: 8pt, fill: rosso.lighten(95%), inset: 10pt)[
    #text(size: 11pt, weight: "bold", fill: rosso)[3. La Previsione] #h(0.8cm)
    Per ottenere $y = 9$: #h(0.3cm)
    $9 = 0.8 x + 3 quad arrow.r quad x = frac(9 - 3, 0.8) = bold(7.5 "ore")$
    #h(0.8cm)
    #box(stroke: 1pt + rosso.darken(10%), radius: 4pt, fill: rosso.lighten(85%), inset: (x: 6pt, y: 4pt))[
      #text(size: 9pt, fill: rosso.darken(40%))[In AI: l'*Inferenza*]
    ]
  ]
]

#pagebreak()

// ============================================================
// SLIDE 6 — Metodo analitico
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[Come Trovare $m$ e $q$]
  #v(0.05cm)
  #text(size: 12pt, fill: luma(80))[Metodo analitico (troppo difficile per Marco!)]
]

#v(0.15cm)

#grid(
  columns: (1fr, auto),
  gutter: 0.8cm,
  [
    // Step 1: Loss
    #box(stroke: 1.5pt + arancio, radius: 6pt, fill: arancio.lighten(93%), inset: 8pt, width: 100%)[
      #text(size: 10pt, weight: "bold", fill: arancio.darken(10%))[Passo 1 — Loss] #h(0.5cm)
      #text(size: 9.5pt)[Errore $e_i = y_i - (m x_i + q)$. Minimizziamo:]
      #v(0.05cm)
      #align(center)[
        $ L(m, q) = sum_(i=1)^(N) (y_i - m x_i - q)^2 $
      ]
    ]

    #v(0.1cm)

    // Step 2: Derivatives
    #box(stroke: 1.5pt + blu, radius: 6pt, fill: blu.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 10pt, weight: "bold", fill: blu)[Passo 2 — Derivate parziali = 0]
      #v(0.05cm)
      #align(center)[
        $ frac(partial L, partial q) = -2 sum_(i=1)^(N) (y_i - m x_i - q) = 0 #h(1.5cm) frac(partial L, partial m) = -2 sum_(i=1)^(N) x_i (y_i - m x_i - q) = 0 $
      ]
    ]

    #v(0.1cm)

    // Step 3: Solution
    #box(stroke: 1.5pt + viola, radius: 6pt, fill: viola.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 10pt, weight: "bold", fill: viola)[Passo 3 — Soluzione]
      #v(0.1cm)
      #align(center)[
        #box(stroke: 1pt + viola, radius: 4pt, fill: viola.lighten(88%), inset: 6pt)[
          $ m = frac(sum_(i=1)^(N) (x_i - overline(x))(y_i - overline(y)), sum_(i=1)^(N) (x_i - overline(x))^2) $
        ]
        #h(1cm)
        #box(stroke: 1pt + viola, radius: 4pt, fill: viola.lighten(88%), inset: 6pt)[
          $ q = overline(y) - m overline(x) $
        ]
      ]
    ]
  ],
  [
    // === SCATTER PLOT compatto ===
    #cetz.canvas(length: 0.5cm, {
      import cetz.draw: *

      let dati = ((1, 4.0), (2, 5.0), (3, 4.5), (4, 6.0), (5, 7.5))
      let m = 0.8
      let q = 3.0

      for x in range(1, 7) {
        line((x, 0), (x, 9), stroke: 0.3pt + luma(225))
      }
      for y in range(1, 10) {
        line((0, y), (6.5, y), stroke: 0.3pt + luma(225))
      }

      line((-0.1, 0), (6.5, 0), stroke: 1.2pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.4))
      line((0, -0.1), (0, 9.5), stroke: 1.2pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.4))

      content((6.5, -0.7), text(size: 6pt)[$x$])
      content((-0.6, 9.5), text(size: 6pt)[$y$])

      for x in range(1, 7) {
        line((x, -0.1), (x, 0.1), stroke: 0.6pt + luma(80))
        content((x, -0.45), text(size: 5pt)[#x])
      }
      for y in (3, 4, 5, 6, 7, 8) {
        line((-0.1, y), (0.1, y), stroke: 0.6pt + luma(80))
        content((-0.45, y), text(size: 5pt)[#y])
      }

      line((0, q), (6, m * 6 + q), stroke: 2pt + blu)

      for (i, (x, y)) in dati.enumerate() {
        let y-line = m * x + q
        line((x, y), (x, y-line),
          stroke: (dash: "dashed", paint: arancio, thickness: 1.5pt))
        content((x + 0.4, (y + y-line) / 2),
          text(size: 5pt, fill: arancio)[$e_#(i+1)$])
      }

      for (x, y) in dati {
        circle((x, y), radius: 0.1, fill: verde, stroke: 1pt + verde.darken(20%))
      }

      content((4.5, 8.5), anchor: "west",
        text(size: 6pt, fill: blu)[$y = 0.8x + 3$])
    })
  ]
)

#v(0.15cm)

#align(center)[
  #box(stroke: 1.5pt + verde, radius: 8pt, fill: verde.lighten(95%), inset: 10pt)[
    #text(size: 10.5pt, weight: "bold", fill: verde)[Con i dati di Marco] #h(0.5cm)
    $N = 5, quad overline(x) = 3, quad overline(y) = 5.4$
    #h(0.8cm) $arrow.r$ #h(0.3cm)
    #text(fill: viola, weight: "bold")[$m = 0.8$] #h(0.5cm)
    #text(fill: viola, weight: "bold")[$q = overline(y) - m overline(x) = 5.4 - 2.4 = 3.0$]
  ]
]

#pagebreak()

// ============================================================
// SLIDE 7 — Massima Verosimiglianza (ipotesi + grafico)
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[Come Trovare $m$ e $q$]
  #v(0.05cm)
  #text(size: 12pt, fill: luma(80))[Metodo 2 — Massima Verosimiglianza]
]

#v(0.15cm)

#grid(
  columns: (1fr, auto),
  gutter: 0.8cm,
  [
    #box(stroke: 1.5pt + verde, radius: 8pt, fill: verde.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 10.5pt, weight: "bold", fill: verde)[Ipotesi — Ogni voto è una gaussiana]

      #v(0.1cm)

      #text(size: 10pt)[
        Marco non prende sempre lo stesso voto studiando le stesse ore: c'è variabilità naturale. Modelliamo ogni voto come una variabile casuale gaussiana centrata sulla retta:
      ]

      #v(0.1cm)

      #align(center)[
        #text(size: 13pt)[
          $ y_i tilde cal(N)(m x_i + q, #h(0.15cm) sigma^2) $
        ]
      ]

      #v(0.1cm)

      #text(size: 10pt)[
        - Il *valore atteso* del voto è sulla retta: $m x_i + q$
        - La *varianza* $sigma^2$ misura quanto i voti fluttuano attorno alla retta
        - Ogni voto è la *realizzazione* di una gaussiana centrata sulla retta
      ]
    ]

    #v(0.2cm)

    #box(stroke: 1.5pt + arancio, radius: 8pt, fill: arancio.lighten(93%), inset: 10pt, width: 100%)[
      #text(size: 10.5pt, weight: "bold", fill: arancio.darken(10%))[La domanda chiave]

      #v(0.05cm)

      #text(size: 10pt)[
        Quali valori di $m$ e $q$ rendono *più probabile* aver osservato esattamente questi voti?
      ]
    ]
  ],
  [
    #cetz.canvas(length: 0.6cm, {
      import cetz.draw: *

      let dati = ((1, 4.0), (2, 5.0), (3, 4.5), (4, 6.0), (5, 7.5))
      let m = 0.8
      let q = 3.0
      let sig = 0.6
      let amp = 1.3

      for x in range(1, 8) {
        line((x, 0), (x, 9), stroke: 0.3pt + luma(225))
      }
      for y in range(1, 10) {
        line((0, y), (7.5, y), stroke: 0.3pt + luma(225))
      }

      line((-0.1, 0), (7.5, 0), stroke: 1.2pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.4))
      line((0, -0.1), (0, 9.5), stroke: 1.2pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.4))

      content((7.5, -0.7), text(size: 7pt)[$x$])
      content((-0.6, 9.5), text(size: 7pt)[$y$])

      for x in range(1, 8) {
        line((x, -0.1), (x, 0.1), stroke: 0.6pt + luma(80))
        content((x, -0.45), text(size: 6pt)[#x])
      }
      for y in (3, 4, 5, 6, 7, 8) {
        line((-0.1, y), (0.1, y), stroke: 0.6pt + luma(80))
        content((-0.45, y), text(size: 6pt)[#y])
      }

      line((0, q), (6.5, m * 6.5 + q), stroke: 2pt + blu)

      for (xi, yi) in dati {
        let y-hat = m * xi + q
        let n-pts = 40

        let pts = range(n-pts + 1).map(j => {
          let t = -2.5 + 5.0 * j / n-pts
          let y-val = y-hat + sig * t
          let x-val = xi + amp * calc.exp(-t * t / 2.0)
          (x-val, y-val)
        })

        let fill-pts = ((xi, y-hat - 2.5 * sig),) + pts + ((xi, y-hat + 2.5 * sig),)
        line(..fill-pts, close: true, fill: viola.lighten(90%), stroke: none)

        line(..pts, stroke: 1pt + viola)

        line((xi, y-hat - 2.5 * sig), (xi, y-hat + 2.5 * sig),
          stroke: 0.4pt + viola.lighten(40%))

        let gauss-val = amp * calc.exp(-(yi - y-hat) * (yi - y-hat) / (2.0 * sig * sig))
        line((xi, yi), (xi + gauss-val, yi),
          stroke: (dash: "dotted", paint: arancio, thickness: 1.2pt))
      }

      for (x, y) in dati {
        circle((x, y), radius: 0.12, fill: verde, stroke: 1pt + verde.darken(20%))
      }

      content((5, 8.8), anchor: "west",
        text(size: 7pt, fill: blu)[$y = m x + q$])

      content((4, 1.5),
        text(size: 6pt, fill: viola)[$cal(N)(m x_i + q, sigma^2)$])
    })
  ]
)

#pagebreak()

// ============================================================
// SLIDE 8 — Massima Verosimiglianza (derivazione matematica)
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[Massima Verosimiglianza — La Matematica]
]

#v(0.15cm)

// Likelihood
#box(stroke: 1.5pt + arancio, radius: 6pt, fill: arancio.lighten(93%), inset: 8pt, width: 100%)[
  #text(size: 10pt, weight: "bold", fill: arancio.darken(10%))[Passo 1 — Verosimiglianza (Likelihood)] #h(0.5cm)
  #text(size: 9.5pt)[I voti sono indipendenti, la probabilità congiunta è il *prodotto*:]

  #v(0.05cm)

  #align(center)[
    $ cal(L)(m, q) = product_(i=1)^N frac(1, sqrt(2 pi) sigma) exp lr(( -frac((y_i - m x_i - q)^2, 2 sigma^2) )) $
  ]
]

#v(0.1cm)

// Log-likelihood
#box(stroke: 1.5pt + blu, radius: 6pt, fill: blu.lighten(95%), inset: 8pt, width: 100%)[
  #text(size: 10pt, weight: "bold", fill: blu)[Passo 2 — Passaggio ai logaritmi] #h(0.5cm)
  #text(size: 9.5pt)[Il logaritmo trasforma il prodotto in somma:]

  #v(0.05cm)

  #align(center)[
    $ ln cal(L) = underbrace(-frac(N, 2) ln(2 pi sigma^2), "costante") - frac(1, 2 sigma^2) sum_(i=1)^N (y_i - m x_i - q)^2 $
  ]

  #v(0.05cm)

  #text(size: 9.5pt)[
    Massimizzare $ln cal(L)$ rispetto a $m$ e $q$ equivale a *minimizzare* il secondo termine.
  ]
]

#v(0.1cm)

// Conclusione
#box(stroke: 1.5pt + viola, radius: 6pt, fill: viola.lighten(95%), inset: 10pt, width: 100%)[
  #text(size: 10pt, weight: "bold", fill: viola)[Passo 3 — Conclusione]

  #v(0.1cm)

  #align(center)[
    Massimizzare $ln cal(L)$ #h(0.5cm)
    #text(size: 14pt)[$arrow.l.r$] #h(0.5cm)
    #text(weight: "bold")[Minimizzare] #h(0.5cm)
    #box(stroke: 1.5pt + viola, radius: 4pt, fill: viola.lighten(88%), inset: 6pt)[
      $ sum_(i=1)^N (y_i - m x_i - q)^2 = L(m, q) $
    ]
    #h(0.5cm) $arrow.r$ #h(0.2cm)
    #text(weight: "bold", fill: rosso)[Stessa Loss!]
  ]

  #v(0.1cm)

  #align(center)[
    #box(stroke: 1pt + rosso.darken(10%), radius: 4pt, fill: rosso.lighten(90%), inset: 6pt)[
      #text(size: 9.5pt, fill: rosso.darken(30%))[
        L'ipotesi di *errori gaussiani* giustifica il metodo dei *minimi quadrati*. Le due strade portano allo stesso risultato.
      ]
    ]
  ]
]

#pagebreak()

// ============================================================
// SLIDE 9 — Analogia delle Molle (intuizione)
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[Come Trovare $m$ e $q$]
  #v(0.05cm)
  #text(size: 12pt, fill: luma(80))[Metodo 3 — L'Analogia delle Molle]
]

#v(0.15cm)

#grid(
  columns: (1fr, auto),
  gutter: 0.8cm,
  [
    #box(stroke: 1.5pt + rosso, radius: 6pt, fill: rosso.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 10pt, weight: "bold", fill: rosso)[L'esperimento mentale]

      #v(0.1cm)

      #text(size: 9.5pt)[
        Colleghiamo ogni punto alla retta con una *molla verticale*. La retta è libera di ruotare ($m$) e traslare ($q$). Si ferma nella posizione di *equilibrio*: energia totale minima.
      ]
    ]

    #v(0.1cm)

    #box(stroke: 1.5pt + blu, radius: 6pt, fill: blu.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 10pt, weight: "bold", fill: blu)[La fisica: legge di Hooke]

      #v(0.05cm)

      #align(center)[
        $ E_i = frac(1, 2) k (Delta y_i)^2 = frac(1, 2) k (y_i - m x_i - q)^2 $
      ]

      #v(0.05cm)

      #text(size: 9.5pt)[Il *quadrato* non è una scelta arbitraria: viene dalla fisica!]
    ]

    #v(0.1cm)

    #box(stroke: 1.5pt + viola, radius: 6pt, fill: viola.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 10pt, weight: "bold", fill: viola)[Energia totale = Loss]

      #v(0.05cm)

      #align(center)[
        $ E_"tot" = frac(1, 2) k sum_(i=1)^N (y_i - m x_i - q)^2 #h(0.5cm) prop #h(0.5cm) L(m, q) $
      ]

      #v(0.05cm)

      #align(center)[
        #text(size: 10pt, weight: "bold", fill: viola)[Minima energia $arrow.l.r$ Minimi quadrati]
      ]
    ]
  ],
  [
    #cetz.canvas(length: 0.6cm, {
      import cetz.draw: *

      let dati = ((1, 4.0), (2, 5.0), (3, 4.5), (4, 6.0), (5, 7.5))
      let m = 0.8
      let q = 3.0

      for x in range(1, 7) {
        line((x, 0), (x, 9), stroke: 0.3pt + luma(225))
      }
      for y in range(1, 10) {
        line((0, y), (6.5, y), stroke: 0.3pt + luma(225))
      }

      line((-0.1, 0), (6.5, 0), stroke: 1.2pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.4))
      line((0, -0.1), (0, 9.5), stroke: 1.2pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.4))

      content((6.5, -0.7), text(size: 7pt)[$x$])
      content((-0.6, 9.5), text(size: 7pt)[$y$])

      for x in range(1, 7) {
        line((x, -0.1), (x, 0.1), stroke: 0.6pt + luma(80))
        content((x, -0.45), text(size: 6pt)[#x])
      }
      for y in (3, 4, 5, 6, 7, 8) {
        line((-0.1, y), (0.1, y), stroke: 0.6pt + luma(80))
        content((-0.45, y), text(size: 6pt)[#y])
      }

      line((0, q), (6, m * 6 + q), stroke: 2.5pt + blu)

      for (xi, yi) in dati {
        let y-hat = m * xi + q
        let dy = yi - y-hat
        let abs-dy = calc.abs(dy)

        if abs-dy > 0.05 {
          let n-zigs = 8
          let amp = 0.18
          let margin = abs-dy * 0.08
          let y-start = y-hat
          let y-end = yi
          let sign-dy = if dy > 0 { 1 } else { -1 }
          let y-zig-start = y-start + sign-dy * margin
          let y-zig-end = y-end - sign-dy * margin
          let zig-dy = y-zig-end - y-zig-start

          let pts = ((xi, y-start), (xi, y-zig-start))
          for i in range(n-zigs) {
            let t = (i + 0.5) / n-zigs
            let y-pt = y-zig-start + zig-dy * t
            let side = if calc.rem(i, 2) == 0 { amp } else { -amp }
            pts.push((xi + side, y-pt))
          }
          pts.push((xi, y-zig-end))
          pts.push((xi, y-end))

          line(..pts, stroke: 1.8pt + rosso)
        }
      }

      for (i, (xi, yi)) in dati.enumerate() {
        let y-hat = m * xi + q
        if calc.abs(yi - y-hat) > 0.05 {
          content((xi + 0.45, (yi + y-hat) / 2),
            text(size: 5pt, fill: rosso)[$E_#(i+1)$])
        }
      }

      for (x, y) in dati {
        circle((x, y), radius: 0.12, fill: verde, stroke: 1pt + verde.darken(20%))
      }

      for (xi, yi) in dati {
        let y-hat = m * xi + q
        circle((xi, y-hat), radius: 0.06, fill: blu, stroke: 0.8pt + blu.darken(20%))
      }

      content((4.5, 8.5), anchor: "west",
        text(size: 7pt, fill: blu)[$y = 0.8x + 3$])
    })
  ]
)

#pagebreak()

// ============================================================
// SLIDE 10 — L'Analogia delle Molle — Equilibrio
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[L'Analogia delle Molle — Equilibrio]
]

#v(0.15cm)

#grid(
  columns: (auto, 1fr),
  gutter: 0.8cm,
  [
    #grid(
      columns: (auto, auto),
      gutter: 0.4cm,
      [
        #align(center)[
          #text(size: 9pt, fill: rosso, weight: "bold")[Retta sbagliata: molle tese]
        ]
        #v(0.05cm)
        #cetz.canvas(length: 0.4cm, {
          import cetz.draw: *

          let dati = ((1, 4.0), (2, 5.0), (3, 4.5), (4, 6.0), (5, 7.5))
          let m-bad = 0.3
          let q-bad = 5.0

          for x in range(1, 7) { line((x, 0), (x, 9), stroke: 0.3pt + luma(225)) }
          for y in range(1, 10) { line((0, y), (6.5, y), stroke: 0.3pt + luma(225)) }

          line((-0.1, 0), (6.5, 0), stroke: 1pt + luma(80),
            mark: (end: "stealth", fill: luma(80), scale: 0.3))
          line((0, -0.1), (0, 9.5), stroke: 1pt + luma(80),
            mark: (end: "stealth", fill: luma(80), scale: 0.3))

          for x in range(1, 7) {
            line((x, -0.1), (x, 0.1), stroke: 0.5pt + luma(80))
            content((x, -0.45), text(size: 4pt)[#x])
          }
          for y in (3, 4, 5, 6, 7, 8) {
            line((-0.1, y), (0.1, y), stroke: 0.5pt + luma(80))
            content((-0.45, y), text(size: 4pt)[#y])
          }

          line((0, q-bad), (6, m-bad * 6 + q-bad), stroke: 2pt + luma(160))

          for (xi, yi) in dati {
            let y-hat = m-bad * xi + q-bad
            let dy = yi - y-hat
            let abs-dy = calc.abs(dy)
            if abs-dy > 0.05 {
              let n-zigs = 6
              let amp = 0.15
              let margin = abs-dy * 0.1
              let sign-dy = if dy > 0 { 1 } else { -1 }
              let y-zig-start = y-hat + sign-dy * margin
              let y-zig-end = yi - sign-dy * margin
              let zig-dy = y-zig-end - y-zig-start

              let pts = ((xi, y-hat), (xi, y-zig-start))
              for i in range(n-zigs) {
                let t = (i + 0.5) / n-zigs
                let y-pt = y-zig-start + zig-dy * t
                let side = if calc.rem(i, 2) == 0 { amp } else { -amp }
                pts.push((xi + side, y-pt))
              }
              pts.push((xi, y-zig-end))
              pts.push((xi, yi))
              line(..pts, stroke: 1.5pt + rosso)
            }
          }

          for (x, y) in dati {
            circle((x, y), radius: 0.1, fill: verde, stroke: 0.8pt + verde.darken(20%))
          }

          content((3.5, 8.5), anchor: "west",
            text(size: 5pt, fill: rosso, weight: "bold")[$E_"tot"$ grande])
        })
      ],
      [
        #align(center)[
          #text(size: 9pt, fill: verde, weight: "bold")[Retta ottimale: equilibrio]
        ]
        #v(0.05cm)
        #cetz.canvas(length: 0.4cm, {
          import cetz.draw: *

          let dati = ((1, 4.0), (2, 5.0), (3, 4.5), (4, 6.0), (5, 7.5))
          let m = 0.8
          let q = 3.0

          for x in range(1, 7) { line((x, 0), (x, 9), stroke: 0.3pt + luma(225)) }
          for y in range(1, 10) { line((0, y), (6.5, y), stroke: 0.3pt + luma(225)) }

          line((-0.1, 0), (6.5, 0), stroke: 1pt + luma(80),
            mark: (end: "stealth", fill: luma(80), scale: 0.3))
          line((0, -0.1), (0, 9.5), stroke: 1pt + luma(80),
            mark: (end: "stealth", fill: luma(80), scale: 0.3))

          for x in range(1, 7) {
            line((x, -0.1), (x, 0.1), stroke: 0.5pt + luma(80))
            content((x, -0.45), text(size: 4pt)[#x])
          }
          for y in (3, 4, 5, 6, 7, 8) {
            line((-0.1, y), (0.1, y), stroke: 0.5pt + luma(80))
            content((-0.45, y), text(size: 4pt)[#y])
          }

          line((0, q), (6, m * 6 + q), stroke: 2pt + blu)

          for (xi, yi) in dati {
            let y-hat = m * xi + q
            let dy = yi - y-hat
            let abs-dy = calc.abs(dy)
            if abs-dy > 0.05 {
              let n-zigs = 6
              let amp = 0.15
              let margin = abs-dy * 0.1
              let sign-dy = if dy > 0 { 1 } else { -1 }
              let y-zig-start = y-hat + sign-dy * margin
              let y-zig-end = yi - sign-dy * margin
              let zig-dy = y-zig-end - y-zig-start

              let pts = ((xi, y-hat), (xi, y-zig-start))
              for i in range(n-zigs) {
                let t = (i + 0.5) / n-zigs
                let y-pt = y-zig-start + zig-dy * t
                let side = if calc.rem(i, 2) == 0 { amp } else { -amp }
                pts.push((xi + side, y-pt))
              }
              pts.push((xi, y-zig-end))
              pts.push((xi, yi))
              line(..pts, stroke: 1.2pt + verde.darken(10%))
            }
          }

          for (x, y) in dati {
            circle((x, y), radius: 0.1, fill: verde, stroke: 0.8pt + verde.darken(20%))
          }

          content((3.5, 8.5), anchor: "west",
            text(size: 5pt, fill: verde, weight: "bold")[$E_"tot"$ minima])
        })
      ]
    )
  ],
  [
    #box(stroke: 1.5pt + blu, radius: 6pt, fill: blu.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 10pt, weight: "bold", fill: blu)[Condizioni di equilibrio]

      #v(0.05cm)

      #text(size: 9.5pt)[La retta si ferma quando la *forza netta* è nulla in entrambe le direzioni:]

      #v(0.1cm)

      #text(size: 9.5pt)[*Traslazione* (regola $q$): la somma delle forze si annulla]
      #v(0.05cm)
      #align(center)[$ sum_(i=1)^N (y_i - m x_i - q) = 0 $]

      #v(0.1cm)

      #text(size: 9.5pt)[*Rotazione* (regola $m$): la somma dei momenti si annulla]
      #v(0.05cm)
      #align(center)[$ sum_(i=1)^N x_i (y_i - m x_i - q) = 0 $]
    ]

    #v(0.15cm)

    #box(stroke: 1.5pt + viola, radius: 6pt, fill: viola.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 10pt, weight: "bold", fill: viola)[Soluzione]
      #v(0.1cm)
      #align(center)[
        #box(stroke: 1pt + viola, radius: 4pt, fill: viola.lighten(88%), inset: 6pt)[
          $ m = frac(sum_(i=1)^(N) (x_i - overline(x))(y_i - overline(y)), sum_(i=1)^(N) (x_i - overline(x))^2) $
        ]
        #h(0.8cm)
        #box(stroke: 1pt + viola, radius: 4pt, fill: viola.lighten(88%), inset: 6pt)[
          $ q = overline(y) - m overline(x) $
        ]
      ]
      #v(0.05cm)
      #align(center)[
        #text(size: 9.5pt, weight: "bold", fill: rosso)[Stesse formule dei metodi 1 e 2!]
      ]
    ]
  ]
)

#pagebreak()

// ============================================================
// SLIDE 11 — Discesa del Gradiente
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[Come Trovare $m$ e $q$]
  #v(0.05cm)
  #text(size: 12pt, fill: luma(80))[Metodo 4 — Discesa del Gradiente]
]

#v(0.1cm)

#grid(
  columns: (1fr, auto),
  gutter: 0.8cm,
  [
    #box(stroke: 1.5pt + arancio, radius: 6pt, fill: arancio.lighten(93%), inset: (x: 8pt, y: 6pt), width: 100%)[
      #text(size: 10pt, weight: "bold", fill: arancio.darken(10%))[L'idea — Scendere nella valle]
      #v(0.05cm)
      #text(size: 9pt)[
        Invece di risolvere equazioni, partiamo da valori qualsiasi di $m$ e $q$ e li miglioriamo *passo dopo passo*, scendendo lungo la superficie della Loss:
      ]
      #v(0.05cm)
      #align(center)[
        $ L(m, q) = sum_(i=1)^N (y_i - m x_i - q)^2 $
      ]
    ]

    #v(0.1cm)

    #box(stroke: 1.5pt + blu, radius: 6pt, fill: blu.lighten(95%), inset: (x: 8pt, y: 6pt), width: 100%)[
      #text(size: 10pt, weight: "bold", fill: blu)[Il gradiente indica la direzione di salita]
      #v(0.05cm)
      #align(center)[
        $ frac(partial L, partial m) = -2 sum_(i=1)^N x_i (y_i - m x_i - q) #h(1.2cm) frac(partial L, partial q) = -2 sum_(i=1)^N (y_i - m x_i - q) $
      ]
      #v(0.03cm)
      #text(size: 9pt)[
        Il gradiente punta in salita $arrow$ noi camminiamo in *direzione opposta*.
      ]
    ]

    #v(0.1cm)

    #box(stroke: 1.5pt + viola, radius: 6pt, fill: viola.lighten(95%), inset: (x: 8pt, y: 6pt), width: 100%)[
      #text(size: 10pt, weight: "bold", fill: viola)[Regola di aggiornamento]
      #v(0.05cm)
      #align(center)[
        #box(stroke: 1pt + viola, radius: 4pt, fill: viola.lighten(88%), inset: 5pt)[
          $ m arrow.l m - alpha frac(partial L, partial m) $
        ]
        #h(0.8cm)
        #box(stroke: 1pt + viola, radius: 4pt, fill: viola.lighten(88%), inset: 5pt)[
          $ q arrow.l q - alpha frac(partial L, partial q) $
        ]
      ]
      #v(0.03cm)
      #align(center)[
        #text(size: 8.5pt, fill: viola.darken(20%))[
          $alpha$ = *learning rate* (dimensione del passo) — Ripetere fino a convergenza
        ]
      ]
    ]
  ],
  [
    #cetz.canvas(length: 0.55cm, {
      import cetz.draw: *

      let cx = 4.8
      let cy = 4.8
      let theta = -0.26
      let cos-th = calc.cos(theta)
      let sin-th = calc.sin(theta)

      for x in range(1, 9) {
        line((x, 0), (x, 9), stroke: 0.3pt + luma(235))
      }
      for y in range(1, 10) {
        line((0, y), (8.5, y), stroke: 0.3pt + luma(235))
      }

      line((-0.1, 0), (8.5, 0), stroke: 1.2pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.4))
      line((0, -0.1), (0, 9.5), stroke: 1.2pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.4))

      content((8.5, -0.7), text(size: 8pt)[$m$])
      content((-0.6, 9.5), text(size: 8pt)[$q$])

      let levels = (3.5, 2.7, 2.0, 1.3, 0.6)
      let n-pts = 60

      for (idx, level) in levels.enumerate() {
        let a = level * 1.15
        let b = level * 0.55
        let lightness = 90 - idx * 5

        let pts = range(n-pts + 1).map(i => {
          let t = 2.0 * calc.pi * i / n-pts
          let lx = a * calc.cos(t)
          let ly = b * calc.sin(t)
          let rx = lx * cos-th - ly * sin-th
          let ry = lx * sin-th + ly * cos-th
          (cx + rx, cy + ry)
        })

        line(..pts, close: true,
          stroke: 0.8pt + blu.lighten(30%),
          fill: blu.lighten(lightness * 1%))
      }

      let gd-pts = (
        (1.0, 7.8),
        (2.0, 6.2),
        (2.8, 5.6),
        (3.4, 5.3),
        (3.8, 5.1),
        (4.2, 4.95),
        (4.5, 4.85),
        (4.7, 4.82),
      )

      for i in range(gd-pts.len() - 1) {
        let p1 = gd-pts.at(i)
        let p2 = gd-pts.at(i + 1)
        line(p1, p2, stroke: 2pt + rosso,
          mark: (end: "stealth", fill: rosso, scale: 0.3))
      }

      let start = gd-pts.at(0)
      circle(start, radius: 0.18, fill: rosso, stroke: 1.2pt + rosso.darken(20%))
      content((start.at(0) + 0.7, start.at(1) + 0.3),
        text(size: 6pt, fill: rosso, weight: "bold")[Partenza])

      circle((cx, cy), radius: 0.15, fill: verde, stroke: 1.2pt + verde.darken(20%))
      content((cx + 0.5, cy - 0.5),
        text(size: 7pt, fill: verde, weight: "bold")[Minimo])

      content((7.0, 1.8), anchor: "center",
        text(size: 6pt, fill: blu)[Curve di livello\ di $L(m, q)$])
    })
  ]
)

#pagebreak()

// ============================================================
// SLIDE 12 — Che Cifra È? (MNIST)
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[A Caccia di Parametri]
  #v(0.05cm)
  #text(size: 12pt, fill: luma(80))[Che Cifra È?]
]

#v(0.15cm)

#grid(
  columns: (auto, 1fr),
  gutter: 0.8cm,
  [
    #align(center)[
      #box(stroke: 2pt + luma(60), radius: 4pt)[
        #image("mnist_2.png", width: 4.5cm)
      ]
      #v(0.1cm)
      #text(size: 9pt, fill: luma(80))[Immagine 28 × 28 pixel]
      #v(0.03cm)
      #text(size: 8pt, fill: luma(120))[(784 numeri da 0 a 255)]
    ]
  ],
  [
    #box(stroke: 1.5pt + rosso, radius: 6pt, fill: rosso.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 10pt, weight: "bold", fill: rosso)[Il problema]
      #v(0.1cm)
      #text(size: 9.5pt)[
        Ogni immagine è una griglia di pixel, ciascuno con un valore di grigio. Servono *parametri* e un *modello matematico* capace di predire di che cifra si tratta.
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1.5pt + verde, radius: 6pt, fill: verde.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 10pt, weight: "bold", fill: verde.darken(10%))[L'obiettivo — Assegnare probabilità]
      #v(0.1cm)
      #text(size: 9.5pt)[
        Il modello deve associare all'immagine una *probabilità* per ciascuna delle 10 cifre:
      ]
      #v(0.1cm)

      #align(center)[
        #cetz.canvas(length: 0.33cm, {
          import cetz.draw: *

          let probs = (0.01, 0.02, 0.91, 0.02, 0.01, 0.01, 0.01, 0.00, 0.01, 0.00)
          let bar-h = 0.5
          let gap = 0.1
          let max-w = 20.0

          for (i, p) in probs.enumerate() {
            let y = (9 - i) * (bar-h + gap)
            let w = calc.max(p * max-w, 0.15)
            let is-winner = i == 2
            let bar-color = if is-winner { verde } else { blu.lighten(50%) }

            content((-0.5, y + bar-h / 2), anchor: "east",
              text(size: 7pt, weight: if is-winner { "bold" } else { "regular" },
                fill: if is-winner { verde.darken(20%) } else { luma(80) })[#i])

            rect((0, y), (w, y + bar-h), fill: bar-color, stroke: none)

            let pct = calc.round(p * 100)
            content((w + 0.3, y + bar-h / 2), anchor: "west",
              text(size: 6pt, weight: if is-winner { "bold" } else { "regular" },
                fill: if is-winner { verde.darken(20%) } else { luma(120) })[#pct%])
          }
        })
      ]
    ]
  ]
)

#pagebreak()

// ============================================================
// SLIDE 13 — Riconoscere cifre con vettori e cos similarity
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[Riconoscere Cifre con Vettori e Cosine Similarity]
]

#v(0.15cm)

#grid(
  columns: (1fr, 1fr),
  gutter: 0.8cm,
  [
    // --- COLONNA SINISTRA: i 3 passi ---

    #box(stroke: 1.5pt + blu, radius: 6pt, fill: blu.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 10pt, weight: "bold", fill: blu)[1. L'immagine è un vettore]
      #h(0.2cm)
      #text(size: 9pt)[Ogni immagine 28×28 viene *appiattita*: 784 pixel $arrow.r$ $bold(x) in bb(R)^(784)$]
    ]

    #v(0.1cm)

    #box(stroke: 1.5pt + viola, radius: 6pt, fill: viola.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 10pt, weight: "bold", fill: viola)[2. I parametri: le 10 cifre medie]
      #v(0.05cm)
      #text(size: 9pt)[
        Per ogni cifra $d in {0, dots, 9}$, calcoliamo la *media* di tutte le immagini di training di quella cifra:
      ]
      #v(0.05cm)
      #align(center)[
        $ bold(mu)_d = frac(1, N_d) sum_(i : y_i = d) bold(x)_i $
      ]
      #v(0.05cm)
      #align(center)[
        #image("mnist_means_strip.png", width: 100%)
      ]
      #v(0.05cm)
      #align(center)[
        #text(size: 8pt, fill: luma(100))[Le 10 cifre medie (parametri del modello): 10 × 784 = *7840 parametri*]
      ]
    ]

    #v(0.1cm)

    #box(stroke: 1.5pt + verde, radius: 6pt, fill: verde.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 10pt, weight: "bold", fill: verde.darken(10%))[3. Predizione:] #h(0.2cm)
      #text(size: 9pt)[calcoliamo $bold(x) tilde bold(mu)_d$ per ogni cifra e scegliamo la più alta:] #h(0.3cm)
      $hat(y) = op("argmax")_d (bold(x) tilde bold(mu)_d)$
    ]
  ],
  [
    // --- COLONNA DESTRA: esempio concreto ---

    #box(stroke: 1.5pt + arancio, radius: 6pt, fill: arancio.lighten(93%), inset: 8pt, width: 100%)[
      #text(size: 10pt, weight: "bold", fill: arancio.darken(10%))[Esempio — Immagine di test]

      #v(0.1cm)

      #grid(
        columns: (auto, 1fr),
        gutter: 0.5cm,
        [
          #align(center)[
            #box(stroke: 1.5pt + luma(60), radius: 3pt)[
              #image("mnist_test_example.png", width: 2cm)
            ]
          ]
        ],
        [
          #text(size: 9pt)[
            Confrontiamo con le 10 medie:
          ]
          #v(0.1cm)

          #cetz.canvas(length: 0.28cm, {
            import cetz.draw: *

            let sims = (0.491, 0.462, 0.593, 0.575, 0.329, 0.549, 0.564, 0.301, 0.520, 0.354)
            let bar-h = 0.5
            let gap = 0.12
            let max-w = 18.0

            for (i, s) in sims.enumerate() {
              let y = (9 - i) * (bar-h + gap)
              let w = s * max-w
              let is-winner = i == 2
              let bar-color = if is-winner { verde } else { blu.lighten(50%) }

              content((-0.5, y + bar-h / 2), anchor: "east",
                text(size: 7pt, weight: if is-winner { "bold" } else { "regular" },
                  fill: if is-winner { verde.darken(20%) } else { luma(80) })[#i])

              rect((0, y), (w, y + bar-h), fill: bar-color, stroke: none)

              let pct = calc.round(s * 100, digits: 1)
              content((w + 0.3, y + bar-h / 2), anchor: "west",
                text(size: 6pt, weight: if is-winner { "bold" } else { "regular" },
                  fill: if is-winner { verde.darken(20%) } else { luma(120) })[#pct%])
            }
          })
        ]
      )

      #v(0.05cm)

      #align(center)[
        #text(size: 9pt, weight: "bold", fill: verde.darken(10%))[Predizione: *2* #h(0.2cm) (cos similarity più alta: 59.3%)]
      ]
    ]

    #v(0.2cm)

    #box(stroke: 1.5pt + rosso, radius: 6pt, fill: rosso.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 10pt, weight: "bold", fill: rosso)[Risultato]
      #v(0.1cm)
      #align(center)[
        #text(size: 14pt, weight: "bold")[Accuratezza: 82.2%]
      ]
      #v(0.05cm)
      #text(size: 9pt)[
        8216 su 10000 immagini di test classificate correttamente, usando solo la *media* e la *cosine similarity* — nessuna rete neurale!
      ]
    ]
  ]
)

#pagebreak()

// ============================================================
// SLIDE 14 — Riepilogo: 3 problemi a confronto
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[Riepilogo — A Caccia di Parametri]
]

#v(0.3cm)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 0.6cm,

  // --- GIOCONDA ---
  [
    #align(center)[
      #box(stroke: 1.5pt + luma(60), radius: 4pt)[
        #image("gioconda.jpg", height: 3.5cm)
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1.5pt + verde, radius: 6pt, fill: verde.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 9pt, weight: "bold", fill: verde)[Dati]
      #v(0.05cm)
      #text(size: 8.5pt)[10 milioni di altezze dei visitatori]
    ]

    #v(0.1cm)

    #box(stroke: 1.5pt + viola, radius: 6pt, fill: viola.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 9pt, weight: "bold", fill: viola)[Parametri]
      #v(0.05cm)
      #align(center)[#text(size: 12pt, weight: "bold")[1]]
      #v(0.05cm)
      #text(size: 8.5pt)[La media $m$ delle altezze]
    ]

    #v(0.1cm)

    #box(stroke: 1.5pt + blu, radius: 6pt, fill: blu.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 9pt, weight: "bold", fill: blu)[Modello]
      #v(0.05cm)
      #align(center)[$ h = m + 56 $]
    ]
  ],

  // --- MOTO ---
  [
    #align(center)[
      #box(stroke: 1.5pt + luma(60), radius: 4pt)[
        #image("moto.jpg", height: 3.5cm)
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1.5pt + verde, radius: 6pt, fill: verde.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 9pt, weight: "bold", fill: verde)[Dati]
      #v(0.05cm)
      #text(size: 8.5pt)[5 coppie (ore studio, voto)]
    ]

    #v(0.1cm)

    #box(stroke: 1.5pt + viola, radius: 6pt, fill: viola.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 9pt, weight: "bold", fill: viola)[Parametri]
      #v(0.05cm)
      #align(center)[#text(size: 12pt, weight: "bold")[2]]
      #v(0.05cm)
      #text(size: 8.5pt)[Pendenza $m$ e intercetta $q$]
    ]

    #v(0.1cm)

    #box(stroke: 1.5pt + blu, radius: 6pt, fill: blu.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 9pt, weight: "bold", fill: blu)[Modello]
      #v(0.05cm)
      #align(center)[$ y = m x + q $]
    ]
  ],

  // --- MNIST ---
  [
    #align(center)[
      #box(stroke: 1.5pt + luma(60), radius: 4pt)[
        #image("mnist_2.png", height: 3.5cm)
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1.5pt + verde, radius: 6pt, fill: verde.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 9pt, weight: "bold", fill: verde)[Dati]
      #v(0.05cm)
      #text(size: 8.5pt)[60 000 immagini 28×28]
    ]

    #v(0.1cm)

    #box(stroke: 1.5pt + viola, radius: 6pt, fill: viola.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 9pt, weight: "bold", fill: viola)[Parametri]
      #v(0.05cm)
      #align(center)[#text(size: 12pt, weight: "bold")[7 840]]
      #v(0.05cm)
      #text(size: 8.5pt)[10 cifre medie × 784 pixel]
    ]

    #v(0.1cm)

    #box(stroke: 1.5pt + blu, radius: 6pt, fill: blu.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 9pt, weight: "bold", fill: blu)[Modello]
      #v(0.05cm)
      #align(center)[$ hat(y) = op("argmax")_d (bold(x) tilde bold(mu)_d) $]
    ]
  ]
)
