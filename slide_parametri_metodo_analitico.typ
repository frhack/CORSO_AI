#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "it")

#import "@preview/cetz:0.3.2"

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")
#let arancio = rgb("#e67e22")

#align(center)[
  #text(size: 20pt, weight: "bold")[Come Trovare $m$ e $q$]
  #v(0.1cm)
  #text(size: 14pt, fill: luma(80))[Metodo analitico (troppo difficile per Marco!)]
]

#v(0.3cm)

#grid(
  columns: (14cm, auto),
  gutter: 1cm,
  [
    // === DERIVAZIONE ===

    // Step 1: Loss
    #box(stroke: 1.5pt + arancio, radius: 8pt, fill: arancio.lighten(93%), inset: 12pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: arancio.darken(10%))[Passo 1 — Definire l'errore totale (Loss)]

      #v(0.2cm)

      #text(size: 10.5pt)[
        Per ogni punto, l'errore è $e_i = y_i - (m x_i + q)$. Minimizziamo la somma dei quadrati:
      ]

      #v(0.2cm)

      #align(center)[
        #text(size: 13pt)[
          $ L(m, q) = sum_(i=1)^(N) (y_i - m x_i - q)^2 $
        ]
      ]
    ]

    #v(0.3cm)

    // Step 2: Derivatives
    #box(stroke: 1.5pt + blu, radius: 8pt, fill: blu.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: blu)[Passo 2 — Derivate parziali = 0]

      #v(0.2cm)

      #text(size: 10.5pt)[
        Al minimo, entrambe le derivate parziali si annullano:
      ]

      #v(0.2cm)

      #align(center)[
        $ frac(partial L, partial q) = -2 sum_(i=1)^(N) (y_i - m x_i - q) = 0 $
      ]

      #v(0.1cm)

      #align(center)[
        $ frac(partial L, partial m) = -2 sum_(i=1)^(N) x_i (y_i - m x_i - q) = 0 $
      ]
    ]

    #v(0.3cm)

    // Step 3: Solution
    #box(stroke: 1.5pt + viola, radius: 8pt, fill: viola.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: viola)[Passo 3 — Soluzione]

      #v(0.2cm)

      #v(0.2cm)

      #align(center)[
        #box(stroke: 1pt + viola, radius: 4pt, fill: viola.lighten(88%), inset: 8pt)[
          $ m = frac(sum_(i=1)^(N) (x_i - overline(x))(y_i - overline(y)), sum_(i=1)^(N) (x_i - overline(x))^2) $
        ]
        #h(1.5cm)
        #box(stroke: 1pt + viola, radius: 4pt, fill: viola.lighten(88%), inset: 8pt)[
          $ q = overline(y) - m overline(x) $
        ]
      ]
    ]
  ],
  [
    // === SCATTER PLOT compatto ===
    #cetz.canvas(length: 0.55cm, {
      import cetz.draw: *

      let dati = ((1, 4.0), (2, 5.0), (3, 4.5), (4, 6.0), (5, 7.5))
      let m = 0.8
      let q = 3.0

      // Griglia
      for x in range(1, 7) {
        line((x, 0), (x, 9), stroke: 0.3pt + luma(225))
      }
      for y in range(1, 10) {
        line((0, y), (6.5, y), stroke: 0.3pt + luma(225))
      }

      // Assi
      line((-0.1, 0), (6.5, 0), stroke: 1.2pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.4))
      line((0, -0.1), (0, 9.5), stroke: 1.2pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.4))

      content((6.5, -0.7), text(size: 7pt)[$x$])
      content((-0.6, 9.5), text(size: 7pt)[$y$])

      // Tacche
      for x in range(1, 7) {
        line((x, -0.1), (x, 0.1), stroke: 0.6pt + luma(80))
        content((x, -0.45), text(size: 6pt)[#x])
      }
      for y in (3, 4, 5, 6, 7, 8) {
        line((-0.1, y), (0.1, y), stroke: 0.6pt + luma(80))
        content((-0.45, y), text(size: 6pt)[#y])
      }

      // Retta
      line((0, q), (6, m * 6 + q), stroke: 2pt + blu)

      // Residui con etichette
      for (i, (x, y)) in dati.enumerate() {
        let y-line = m * x + q
        line((x, y), (x, y-line),
          stroke: (dash: "dashed", paint: arancio, thickness: 1.5pt))
        // Etichetta errore
        let side = if y > y-line { 0.3 } else { -0.3 }
        content((x + 0.4, (y + y-line) / 2),
          text(size: 6pt, fill: arancio)[$e_#(i+1)$])
      }

      // Punti
      for (x, y) in dati {
        circle((x, y), radius: 0.1, fill: verde, stroke: 1pt + verde.darken(20%))
      }

      // Label
      content((4.5, 8.5), anchor: "west",
        text(size: 7pt, fill: blu)[$y = 0.8x + 3$])
    })
  ]
)

#v(0.3cm)

// Calcolo numerico
#align(center)[
  #box(stroke: 1.5pt + verde, radius: 8pt, fill: verde.lighten(95%), inset: 12pt)[
    #text(size: 11pt, weight: "bold", fill: verde)[Con i dati di Marco] #h(0.5cm)
    $N = 5, quad overline(x) = 3, quad overline(y) = 5.4$
    #h(0.8cm) $arrow.r$ #h(0.3cm)
    #text(fill: viola, weight: "bold")[$m = 0.8$] #h(0.5cm)
    #text(fill: viola, weight: "bold")[$q = overline(y) - m overline(x) = 5.4 - 2.4 = 3.0$]
  ]
]
