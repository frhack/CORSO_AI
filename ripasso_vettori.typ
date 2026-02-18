#set page(width: 25.4cm, height: 14.29cm, margin: (x: 1cm, y: 0.8cm))
#set text(font: "New Computer Modern", size: 10.5pt, lang: "it")

#import "@preview/cetz:0.3.2"

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")
#let arancio = rgb("#e67e22")
#let grigio = rgb("#7f8c8d")

// ============================================================
// SLIDE 1 — Operazioni fondamentali: ADD e SCALE
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[Ripasso Vettori]
  #v(0.05cm)
  #text(size: 12pt, fill: luma(80))[Le due operazioni fondamentali: *Somma* e *Scalatura*]
]

#v(0.1cm)

#grid(
  columns: (1fr, 1fr),
  gutter: 0.8cm,

  // --- COLONNA SINISTRA: ADD ---
  [
    #box(stroke: 1.5pt + blu, radius: 8pt, fill: blu.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 13pt, weight: "bold", fill: blu)[ADD — Somma di vettori]
      #v(0.1cm)
      Dati $bold(a) = vec(delim: "[",a_1, a_2)$ e $bold(b) = vec(delim: "[",b_1, b_2)$: #h(1fr) $bold(a) + bold(b) = vec(delim: "[",a_1 + b_1, a_2 + b_2)$

      #text(size: 9.5pt, fill: luma(60))[Si sommano le componenti una per una. Vale in qualsiasi dimensione.]
    ]

    #v(0.05cm)

    #align(center)[
      #cetz.canvas(length: 0.5cm, {
        import cetz.draw: *

        for i in range(0, 7) {
          line((i, 0), (i, 5), stroke: 0.3pt + luma(220))
        }
        for j in range(0, 6) {
          line((0, j), (6, j), stroke: 0.3pt + luma(220))
        }

        line((0, 0), (6, 0), stroke: 0.6pt + luma(150), mark: (end: "stealth", fill: luma(150), size: 0.25))
        line((0, 0), (0, 5), stroke: 0.6pt + luma(150), mark: (end: "stealth", fill: luma(150), size: 0.25))

        // vettore a (blu) — dall'origine
        line((0, 0), (3, 1), stroke: 1.2pt + rgb("#3498db"), mark: (end: "stealth", fill: rgb("#3498db"), size: 0.3))
        content((1.5, 0.1), text(fill: rgb("#3498db"), weight: "bold", size: 10pt)[$bold(a)$], anchor: "north")

        // vettore b (verde) — dall'origine
        line((0, 0), (2, 3), stroke: 1.2pt + rgb("#27ae60"), mark: (end: "stealth", fill: rgb("#27ae60"), size: 0.3))
        content((-0.15, 1.8), text(fill: rgb("#27ae60"), weight: "bold", size: 10pt)[$bold(b)$], anchor: "east")

        // vettore b traslato (verde tratteggiato) — punta-coda dalla punta di a
        line((3, 1), (5, 4), stroke: (paint: rgb("#27ae60"), thickness: 1pt, dash: "dashed"), mark: (end: "stealth", fill: rgb("#27ae60"), size: 0.25))

        // vettore somma (rosso) — dall'origine alla punta
        line((0, 0), (5, 4), stroke: 1.6pt + rgb("#e74c3c"), mark: (end: "stealth", fill: rgb("#e74c3c"), size: 0.3))
        content((2.2, 2.6), text(fill: rgb("#e74c3c"), weight: "bold", size: 10pt)[$bold(a) + bold(b)$], anchor: "east")
      })
    ]

    #text(size: 9pt, weight: "bold")[Sommare $bold(b)$ ad $bold(a)$: spostare la punta di $bold(a)$ nella direzione e verso di $bold(b)$, per la sua lunghezza.]

    #text(size: 9pt, weight: "bold")[Sottrarre $bold(b)$ ad $bold(a)$: spostare la punta di $bold(a)$ nella direzione e verso opposto di $bold(b)$, per la sua lunghezza.]

    #v(0.1cm)

    #align(center)[
      #text(size: 9.5pt)[
        _Es.:_ #h(0.2cm)
        $bold(a) = vec(delim: "[",3, 1)$ #h(0.15cm) $bold(b) = vec(delim: "[",2, 3)$ #h(0.4cm)
        $bold(a) + bold(b) = vec(delim: "[",5, 4)$
      ]
    ]
  ],

  // --- COLONNA DESTRA: SCALE ---
  [
    #box(stroke: 1.5pt + viola, radius: 8pt, fill: viola.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 13pt, weight: "bold", fill: viola)[SCALE — Scalatura (prodotto per scalare)]
      #v(0.1cm)
      Dato $bold(a) = vec(delim: "[",a_1, a_2)$ e uno scalare $lambda in bb(R)$: #h(1fr) $lambda bold(a) = vec(delim: "[",lambda a_1, lambda a_2)$

      #text(size: 9.5pt, fill: luma(60))[Si moltiplica ogni componente per lo stesso numero. Cambia lunghezza (e verso se $lambda < 0$).]
    ]

    #v(0.05cm)

    #align(center)[
      #cetz.canvas(length: 0.5cm, {
        import cetz.draw: *

        for i in range(-3, 7) {
          line((i, -2), (i, 4), stroke: 0.3pt + luma(220))
        }
        for j in range(-2, 5) {
          line((-3, j), (6, j), stroke: 0.3pt + luma(220))
        }

        line((-3, 0), (6, 0), stroke: 0.6pt + luma(150), mark: (end: "stealth", fill: luma(150), size: 0.25))
        line((0, -2), (0, 4), stroke: 0.6pt + luma(150), mark: (end: "stealth", fill: luma(150), size: 0.25))

        // vettore a originale (viola)
        line((0, 0), (2, 1.5), stroke: 1.2pt + rgb("#9b59b6"), mark: (end: "stealth", fill: rgb("#9b59b6"), size: 0.3))
        content((1.2, 0.2), text(fill: rgb("#9b59b6"), weight: "bold", size: 10pt)[$bold(a)$], anchor: "north")

        // 2a (arancio)
        line((0, 0), (4, 3), stroke: 1.2pt + rgb("#e67e22"), mark: (end: "stealth", fill: rgb("#e67e22"), size: 0.3))
        content((4.3, 3.0), text(fill: rgb("#e67e22"), weight: "bold", size: 10pt)[$2 bold(a)$], anchor: "west")

        // 0.5a (verde)
        line((0, 0), (1, 0.75), stroke: 1.2pt + rgb("#27ae60"), mark: (end: "stealth", fill: rgb("#27ae60"), size: 0.3))
        content((1.3, 0.75), text(fill: rgb("#27ae60"), weight: "bold", size: 9pt)[$1/2 bold(a)$], anchor: "west")

        // -1a (rosso)
        line((0, 0), (-2, -1.5), stroke: 1.2pt + rgb("#e74c3c"), mark: (end: "stealth", fill: rgb("#e74c3c"), size: 0.3))
        content((-2.3, -1.5), text(fill: rgb("#e74c3c"), weight: "bold", size: 10pt)[$-bold(a)$], anchor: "east")
      })
    ]

    #text(size: 9pt)[Stessa direzione, lunghezza diversa. Se $lambda < 0$ il verso si inverte.]

    #v(0.1cm)

    #align(center)[
      #text(size: 9.5pt)[
        _Es.:_ #h(0.2cm)
        $bold(a) = vec(delim: "[",3, 1)$ #h(0.4cm)
        $2 bold(a) = vec(delim: "[",6, 2)$ #h(0.4cm)
        $-bold(a) = vec(delim: "[",-3, -1)$
      ]
    ]
  ]
)

#v(0.1cm)

#align(center)[
  #text(size: 11pt, weight: "bold")[ADD e SCALE \ scegliendo opportunamente un insieme di vettori, ci permettono di costruire qualsiasi altro vettore dello spazio.]
]

#pagebreak()

// ============================================================
// SLIDE 2 — Prodotto Scalare / Dot Product
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[Prodotto Scalare / Dot Product]
  #v(0.05cm)
  #text(size: 12pt, fill: luma(80))[Un'operazione tra due vettori che restituisce *uno scalare*]
]

#v(0.15cm)

#grid(
  columns: (1fr, 1fr),
  gutter: 0.8cm,

  // --- COLONNA SINISTRA: Formula e significato geometrico ---
  [
    #box(stroke: 1.5pt + blu, radius: 8pt, fill: blu.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 13pt, weight: "bold", fill: blu)[Formula — moltiplicazione componenti]
      #v(0.1cm)
      Dati $bold(a) = vec(delim: "[",a_1, a_2)$ e $bold(b) = vec(delim: "[",b_1, b_2)$: #h(1fr) $bold(a) dot bold(b) = a_1 b_1 + a_2 b_2$

      #v(0.1cm)

      In $n$ dimensioni: #h(1fr) $bold(a) dot bold(b) = sum_(i=1)^(n) a_i b_i$

      #v(0.05cm)
      #text(size: 9.5pt, fill: luma(60))[Si moltiplicano le componenti corrispondenti e si sommano. Il risultato è uno *scalare*, non un vettore.]
    ]

    #v(0.15cm)

    #box(stroke: 1.5pt + verde, radius: 8pt, fill: verde.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 13pt, weight: "bold", fill: verde)[Significato geometrico]
      #v(0.1cm)

      $ bold(a) dot bold(b) = ||bold(a)|| dot.c ||bold(b)|| dot.c cos theta $

      #v(0.05cm)

      #align(center)[
        #cetz.canvas(length: 0.5cm, {
          import cetz.draw: *

          // vettore a
          line((0, 0), (6, 0), stroke: 1.2pt + rgb("#3498db"), mark: (end: "stealth", fill: rgb("#3498db"), size: 0.3))
          content((6.3, 0), text(fill: rgb("#3498db"), weight: "bold", size: 10pt)[$bold(a)$], anchor: "west")

          // vettore b
          line((0, 0), (4, 3), stroke: 1.2pt + rgb("#27ae60"), mark: (end: "stealth", fill: rgb("#27ae60"), size: 0.3))
          content((4.3, 3), text(fill: rgb("#27ae60"), weight: "bold", size: 10pt)[$bold(b)$], anchor: "west")

          // proiezione tratteggiata
          line((4, 3), (4, 0), stroke: (paint: luma(120), thickness: 0.8pt, dash: "dashed"))

          // proiezione evidenziata
          line((0, 0), (4, 0), stroke: 2pt + rgb("#e67e22"))
          content((2, -0.5), text(fill: rgb("#e67e22"), weight: "bold", size: 9pt)[proiezione di $bold(b)$ su $bold(a)$], anchor: "north")

          // arco angolo
          arc((0, 0), start: 0deg, stop: 36.87deg, radius: 1.5, stroke: 0.8pt + rgb("#e74c3c"))
          content((1.8, 0.55), text(fill: rgb("#e74c3c"), size: 10pt)[$theta$])
        })
      ]

      #v(0.05cm)
      #text(size: 9.5pt, fill: luma(60))[Prodotto della proiezione di $bold(a)$ su $bold(b)$ per $||bold(b)||$. Se $theta = 90°$ (perpendicolari) $arrow.r bold(a) dot bold(b) = 0$.]
    ]
  ],

  // --- COLONNA DESTRA: Significato fisico e media pesata ---
  [
    #box(stroke: 1.5pt + rosso, radius: 8pt, fill: rosso.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 13pt, weight: "bold", fill: rosso)[Significato fisico — Lavoro]
      #v(0.1cm)

      #align(center)[
        #cetz.canvas(length: 0.5cm, {
          import cetz.draw: *

          // blocco
          rect((2.5, -0.4), (3.5, 0.4), stroke: 1pt + luma(80), fill: luma(230))

          // forza F
          line((3.5, 0), (6.5, 2), stroke: 1.2pt + rgb("#e74c3c"), mark: (end: "stealth", fill: rgb("#e74c3c"), size: 0.3))
          content((6.8, 2), text(fill: rgb("#e74c3c"), weight: "bold", size: 10pt)[$bold(F)$], anchor: "west")

          // proiezione tratteggiata di F su s
          line((6.5, 2), (6.5, 0), stroke: (paint: luma(120), thickness: 0.8pt, dash: "dashed"))

          // componente proiettata F_s (arancio, evidenziata)
          line((3.5, 0), (6.5, 0), stroke: 2pt + rgb("#e67e22"))
          content((5, -0.5), text(fill: rgb("#e67e22"), weight: "bold", size: 8pt)[$F cos theta$], anchor: "north")

          // spostamento s
          line((3.5, 0), (8, 0), stroke: 1.2pt + rgb("#3498db"), mark: (end: "stealth", fill: rgb("#3498db"), size: 0.3))
          content((8.3, 0), text(fill: rgb("#3498db"), weight: "bold", size: 10pt)[$bold(s)$], anchor: "west")

          // angolo
          arc((3.5, 0), start: 0deg, stop: 33.69deg, radius: 1.5, stroke: 0.8pt + rgb("#e67e22"))
          content((5.2, 0.55), text(fill: rgb("#e67e22"), size: 9pt)[$theta$])
        })
      ]

      #v(0.1cm)

      $ W = bold(F) dot bold(s) = ||bold(F)|| dot.c ||bold(s)|| dot.c cos theta $

      #v(0.05cm)
      #text(size: 9.5pt, fill: luma(60))[Solo la componente della forza *nella direzione dello spostamento* compie lavoro.]
    ]

    #v(0.15cm)

    #box(stroke: 1.5pt + viola, radius: 8pt, fill: viola.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 13pt, weight: "bold", fill: viola)[Media pesata]
      #v(0.1cm)

      Dati i voti $bold(v) = vec(delim: "[",v_1, v_2, v_3)$ e i pesi $bold(w) = vec(delim: "[",w_1, w_2, w_3)$ con $sum w_i = 1$:

      $ "media pesata" = bold(v) dot bold(w) = v_1 w_1 + v_2 w_2 + v_3 w_3 $

      #v(0.05cm)
      #text(size: 9.5pt, fill: luma(60))[
        _Es.:_ voti $vec(delim: "[",8, 6, 7)$ con pesi $vec(delim: "[",0.5, 0.3, 0.2)$: #h(0.3cm) $8 dot.c 0.5 + 6 dot.c 0.3 + 7 dot.c 0.2 = 7.2$
      ]
    ]
  ]
)

#pagebreak()

// ============================================================
// SLIDE 3 — Cosine Similarity
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[Cosine Similarity]
  #v(0.05cm)
  #text(size: 12pt, fill: luma(80))[Misura quanto due vettori sono *collineari*: un numero da $-1$ a $+1$]
]

#v(0.1cm)

// --- RIGA 1: Triangoli simili + Formula ---
#grid(
  columns: (1fr, 1fr),
  gutter: 0.8cm,

  // --- SINISTRA: Formula + Casistiche ---
  [
    #box(stroke: 1.5pt + viola, radius: 8pt, fill: viola.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 12pt, weight: "bold", fill: viola)[Formula]
      #v(0.05cm)

      $ bold(a) tilde bold(b) = (bold(a) dot bold(b)) / (||bold(a)|| dot.c ||bold(b)||) = cos(theta) $

      #text(size: 9pt, fill: luma(60))[Dot product *normalizzato* per le lunghezze: elimina la scala, misura solo la direzione.]
    ]

    #v(0.1cm)

    #box(stroke: 1.5pt + verde, radius: 8pt, fill: verde.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 12pt, weight: "bold", fill: verde)[Casistiche]
      #v(0.05cm)
      #text(size: 10pt)[
        #grid(
          columns: (auto, 1fr),
          gutter: 0.2cm,
          row-gutter: 0.1cm,
          align: (right, left),
          text(fill: verde)[$bold(a) tilde bold(b) = 1$], [stessa direzione ($bold(b) = k bold(a)$, $k > 0$)],
          text(fill: grigio)[$bold(a) tilde bold(b) = 0$], [perpendicolari (nessuna relazione)],
          text(fill: rosso)[$bold(a) tilde bold(b) = -1$], [verso opposto ($bold(b) = k bold(a)$, $k < 0$)],
        )
      ]
    ]
  ],

  // --- DESTRA: Triangoli simili ---
  box(stroke: 1.5pt + blu, radius: 8pt, fill: blu.lighten(95%), inset: 8pt, width: 100%)[
    #text(size: 12pt, weight: "bold", fill: blu)[Come per i triangoli simili...]
    #v(0.05cm)

    Se due vettori hanno cos similarity massima ($bold(a) tilde bold(b) = 1$) allora:

    #v(0.05cm)

    #align(center)[
      #cetz.canvas(length: 0.3cm, {
        import cetz.draw: *

        // triangolo piccolo scaleno
        line((0, 0), (4, 0), stroke: 1.2pt + rgb("#3498db"))
        line((4, 0), (3, 2.5), stroke: 1.2pt + rgb("#3498db"))
        line((0, 0), (3, 2.5), stroke: 1.2pt + rgb("#3498db"))
        content((2, -0.5), text(fill: rgb("#3498db"), size: 8pt)[$a$])
        content((3.9, 1.5), text(fill: rgb("#3498db"), size: 8pt)[$b$])
        content((1.1, 1.5), text(fill: rgb("#3498db"), size: 8pt)[$c$])

        // triangolo grande scaleno (×k)
        line((7, 0), (13, 0), stroke: 1.2pt + rgb("#27ae60"))
        line((13, 0), (11.5, 3.75), stroke: 1.2pt + rgb("#27ae60"))
        line((7, 0), (11.5, 3.75), stroke: 1.2pt + rgb("#27ae60"))
        content((10, -0.5), text(fill: rgb("#27ae60"), size: 8pt)[$k a$])
        content((12.7, 2.2), text(fill: rgb("#27ae60"), size: 8pt)[$k b$])
        content((8.7, 2.2), text(fill: rgb("#27ae60"), size: 8pt)[$k c$])
      })
    ]

    Le componenti corrispondenti sono proporzionali con rapporto $k$: #h(0.3cm) $b_i = k a_i$
  ]
)

#v(0.1cm)

// --- RIGA 2: Esempio studenti ---
#box(stroke: 1.5pt + arancio, radius: 8pt, fill: arancio.lighten(95%), inset: 10pt, width: 100%)[
  #grid(
    columns: (auto, 1fr),
    gutter: 1cm,
    align: horizon,

    [
      #text(size: 12pt, weight: "bold", fill: arancio)[Esempio — Voti di 4 studenti]
      #v(0.05cm)
      #text(size: 9.5pt)[Voti in 4 materie STEM. Quali studenti hanno un profilo *simile*?]
    ],

    align(center)[
      #table(
        columns: (auto, auto, auto, auto, auto),
        align: center,
        stroke: 0.5pt + luma(180),
        fill: (x, y) => if y == 0 { arancio.lighten(85%) } else { none },
        table.header([], [*Mat*], [*Fis*], [*Inf*], [*Sci*]),
        [*Alice*], [6], [5], [4], [6],
        [*Bruno*], [9], [7.5], [6], [9],
        [*Carla*], [8], [5], [9], [7],
        [*Dario*], [5], [7], [8], [4],
      )
    ]
  )
]

#pagebreak()

// ============================================================
// SLIDE 4 — Trasformazioni lineari e affini
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[Trasformazioni Lineari e Affini]
  #v(0.05cm)
  #text(size: 12pt, fill: luma(80))[Funzioni che trasformano vettori in vettori]
]

#v(0.1cm)

#grid(
  columns: (1fr, 1fr),
  gutter: 0.8cm,

  // --- COLONNA SINISTRA ---
  [
    #box(stroke: 1.5pt + blu, radius: 8pt, fill: blu.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 12pt, weight: "bold", fill: blu)[Definizioni]
      #v(0.05cm)

      *Lineare:* #h(0.3cm) $f(alpha bold(x) + beta bold(y)) = alpha f(bold(x)) + beta f(bold(y))$

      #text(size: 9pt, fill: luma(60))[Rispetta ADD e SCALE.]

      #v(0.05cm)

      *Affine:* #h(0.3cm) $f(bold(x)) = A bold(x) + bold(b)$

      #text(size: 9pt, fill: luma(60))[Lineare + traslazione.]

      #v(0.05cm)
      #text(size: 10pt)[
        *Esempi lineari:* rotazione, riflessione, scalatura, proiezione, shear

        *Esempi affini:* traslazione, rototraslazione, qualsiasi lineare + traslazione
      ]
    ]

    #v(0.1cm)

    #box(stroke: 1.5pt + viola, radius: 8pt, fill: viola.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 12pt, weight: "bold", fill: viola)[Matrici]
      #v(0.05cm)

      Fissata una base, ogni trasformazione lineare corrisponde a *una e una sola matrice* (e viceversa).

      $ f(bold(x)) = A bold(x) #h(1cm) A in bb(R)^(m times n) $

      #text(size: 9pt, fill: luma(60))[Trasformazioni lineari $arrow.l.r$ matrici (isomorfismo).]
    ]
  ],

  // --- COLONNA DESTRA ---
  [
    #box(stroke: 1.5pt + rosso, radius: 8pt, fill: rosso.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 12pt, weight: "bold", fill: rosso)[Proprietà]
      #v(0.05cm)

      #text(size: 10pt)[
        Sia lineari che affini:
        - Mandano *rette in rette*
        - Conservano il *parallelismo*

        #v(0.05cm)

        Solo lineari:
        - Mandano sempre l'*origine in origine*: $f(bold(0)) = bold(0)$
      ]
    ]

    #v(0.1cm)

    #box(stroke: 1.5pt + arancio, radius: 8pt, fill: arancio.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 12pt, weight: "bold", fill: arancio)[Chiusura]
      #v(0.05cm)
      #text(size: 10pt)[
        *Somma* di trasformazioni lineari/affini $arrow.r$ lineare/affine

        *Composizione* di trasformazioni lineari/affini $arrow.r$ lineare/affine
      ]
    ]

    #v(0.1cm)

    #align(center)[
      #cetz.canvas(length: 0.35cm, {
        import cetz.draw: *

        // griglia originale
        for i in range(0, 5) {
          line((i, 0), (i, 4), stroke: 0.4pt + rgb("#3498db").lighten(50%))
        }
        for j in range(0, 5) {
          line((0, j), (4, j), stroke: 0.4pt + rgb("#3498db").lighten(50%))
        }
        content((2, -0.5), text(size: 8pt, fill: luma(100))[originale])

        // freccia
        content((5.5, 2), text(size: 10pt)[$arrow.r.long$])
        content((5.5, 2.6), text(size: 7pt, fill: luma(100))[$A bold(x)$])

        // griglia trasformata (shear)
        for i in range(0, 5) {
          line((7 + i, 0), (7 + i + 1.6, 4), stroke: 0.4pt + rgb("#27ae60").lighten(50%))
        }
        for j in range(0, 5) {
          line((7 + j * 0.4, j), (7 + 4 + j * 0.4, j), stroke: 0.4pt + rgb("#27ae60").lighten(50%))
        }
        content((9.5, -0.5), text(size: 8pt, fill: luma(100))[trasformata])
      })
    ]

    #align(center)[
      #text(size: 8pt, fill: luma(100))[Rette $arrow.r$ rette, parallele $arrow.r$ parallele]
    ]
  ]
)

