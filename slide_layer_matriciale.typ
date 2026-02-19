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
// Macro: grafica matriciale
// ============================================================
#let grafica-matrice(scala) = {
  cetz.canvas(length: scala, {
    import cetz.draw: *

    let x-col = 0
    let cell = 0.85
    let rows-x = 3
    let top-y = 3.2

    for i in range(rows-x) {
      let y = top-y - i * cell
      rect((x-col, y - cell), (x-col + cell, y), fill: verde.lighten(88%), stroke: 0.8pt + verde)
    }
    content((x-col + cell / 2, top-y - 0 * cell - cell / 2), text(size: 10pt)[$x_1$])
    content((x-col + cell / 2, top-y - 1 * cell - cell / 2), text(size: 10pt)[$x_2$])
    content((x-col + cell / 2, top-y - 2 * cell - cell / 2), text(size: 10pt)[$x_3$])
    content((x-col + cell / 2, top-y + 0.6), text(size: 10pt, fill: verde, weight: "bold")[$bold(x)$])
    content((x-col + cell / 2, top-y + 1.2), text(size: 8pt, fill: grigio)[3 × 1])

    content((x-col + cell + 0.7, top-y - 1 * cell), text(size: 14pt, weight: "bold")[×])

    let w-col = x-col + cell + 1.4
    let cols-w = 3
    let rows-w = 4

    for i in range(rows-w) {
      for j in range(cols-w) {
        let x = w-col + j * cell
        let y = top-y - i * cell + 0.45
        rect((x, y - cell), (x + cell, y), fill: viola.lighten(88%), stroke: 0.8pt + viola)
        content((x + cell / 2, y - cell / 2), text(size: 8pt)[$w_(#{ str(i + 1) }#{ str(j + 1) })$])
      }
    }
    content((w-col + cols-w * cell / 2, top-y + 0.6 + 0.45), text(size: 10pt, fill: viola, weight: "bold")[$bold(W)$])
    content((w-col + cols-w * cell / 2, top-y + 1.2 + 0.45), text(size: 8pt, fill: grigio)[4 × 3])

    content((w-col + cols-w * cell + 0.55, top-y - 1 * cell), text(size: 14pt, weight: "bold")[+])

    let b-col = w-col + cols-w * cell + 1.1
    let rows-b = 4
    for i in range(rows-b) {
      let y = top-y - i * cell + 0.45
      rect((b-col, y - cell), (b-col + cell, y), fill: arancio.lighten(88%), stroke: 0.8pt + arancio)
    }
    content((b-col + cell / 2, top-y - 0 * cell - cell / 2 + 0.45), text(size: 10pt)[$b_1$])
    content((b-col + cell / 2, top-y - 1 * cell - cell / 2 + 0.45), text(size: 10pt)[$b_2$])
    content((b-col + cell / 2, top-y - 2 * cell - cell / 2 + 0.45), text(size: 10pt)[$b_3$])
    content((b-col + cell / 2, top-y - 3 * cell - cell / 2 + 0.45), text(size: 10pt)[$b_4$])
    content((b-col + cell / 2, top-y + 0.6 + 0.45), text(size: 10pt, fill: arancio, weight: "bold")[$bold(b)$])
    content((b-col + cell / 2, top-y + 1.2 + 0.45), text(size: 8pt, fill: grigio)[4 × 1])

    let arrow-x = b-col + cell + 0.3
    line((arrow-x, top-y - 1 * cell), (arrow-x + 0.8, top-y - 1 * cell),
      stroke: 1.2pt + grigio, mark: (end: "stealth", fill: grigio, scale: 0.5))
    content((arrow-x + 1.35, top-y - 1 * cell), text(size: 14pt, fill: arancio, weight: "bold")[$sigma$])
    line((arrow-x + 1.7, top-y - 1 * cell), (arrow-x + 2.5, top-y - 1 * cell),
      stroke: 1.2pt + grigio, mark: (end: "stealth", fill: grigio, scale: 0.5))

    let y-col = arrow-x + 2.7
    for i in range(rows-b) {
      let y = top-y - i * cell + 0.45
      rect((y-col, y - cell), (y-col + cell, y), fill: rosso.lighten(85%), stroke: 0.8pt + rosso)
    }
    content((y-col + cell / 2, top-y - 0 * cell - cell / 2 + 0.45), text(size: 10pt)[$y_1$])
    content((y-col + cell / 2, top-y - 1 * cell - cell / 2 + 0.45), text(size: 10pt)[$y_2$])
    content((y-col + cell / 2, top-y - 2 * cell - cell / 2 + 0.45), text(size: 10pt)[$y_3$])
    content((y-col + cell / 2, top-y - 3 * cell - cell / 2 + 0.45), text(size: 10pt)[$y_4$])
    content((y-col + cell / 2, top-y + 0.6 + 0.45), text(size: 10pt, fill: rosso, weight: "bold")[$bold(y)$])
    content((y-col + cell / 2, top-y + 1.2 + 0.45), text(size: 8pt, fill: grigio)[4 × 1])

    let bot-y = top-y - rows-w * cell - 0.6 + 0.45
    content((5.5, bot-y), text(size: 9pt, fill: grigio)[ogni #text(weight: "bold")[riga] di $bold(W)$ contiene i pesi di *un neurone*])
  })
}

// ============================================================
// SLIDE 1: grafica grande + primi 3 box
// ============================================================
#align(center)[
  #text(size: 18pt, weight: "bold")[Ogni Strato è un'operazione Matriciale]
]

#v(0.2cm)

#grid(
  columns: (1.2fr, 0.8fr),
  gutter: 0.4cm,
  [
    #align(center)[
      #grafica-matrice(0.85cm)
    ]
  ],
  [
    #v(0.3cm)

    #box(stroke: 1.5pt + blu, radius: 5pt, fill: blu.lighten(93%), inset: 10pt, width: 100%)[
      #text(size: 10pt, weight: "bold", fill: blu)[Uno strato = una moltiplicazione]
      #v(0.1cm)
      #align(center)[
        #text(size: 14pt)[$ bold(y) = sigma(bold(W) dot bold(x) + bold(b)) $]
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1pt + viola, radius: 4pt, fill: viola.lighten(93%), inset: 8pt, width: 100%)[
      #text(size: 9pt)[
        #text(fill: viola, weight: "bold")[Dimensioni] ($n$ input, $m$ neuroni): \
        #h(0.3cm) $bold(x)$: $n times 1$ #h(0.3cm) $bold(W)$: $m times n$ #h(0.3cm) $bold(b)$: $m times 1$ #h(0.3cm) $bold(y)$: $m times 1$
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1pt + arancio, radius: 4pt, fill: arancio.lighten(93%), inset: 8pt, width: 100%)[
      #text(size: 9.5pt)[
        #text(fill: arancio.darken(10%), weight: "bold")[Rete completa =] strati in sequenza:
        #align(center)[
          $bold(y) = sigma_3 (bold(W)_3 dot sigma_2 (bold(W)_2 dot sigma_1 (bold(W)_1 dot bold(x) + bold(b)_1) + bold(b)_2) + bold(b)_3)$
        ]
      ]
    ]

    #v(0.15cm)

    #align(center)[
      #text(size: 8.5pt, fill: grigio)[Calcoli di uno strato *in parallelo* #sym.arrow.r GPU]
    ]
  ],
)

// ============================================================
// SLIDE 2: grafica piccola + 4° box (funzioni e composizione)
// ============================================================
#pagebreak()

#align(center)[
  #text(size: 18pt, weight: "bold")[Ogni Strato è un'operazione Matriciale]
]

#v(0.2cm)

#grid(
  columns: (1fr, 1fr),
  gutter: 0.5cm,
  [
    #align(center)[
      #grafica-matrice(0.6cm)
    ]
  ],
  [
    #v(0.5cm)

    #box(stroke: 1.5pt + rosso, radius: 5pt, fill: rosso.lighten(93%), inset: 10pt, width: 100%)[
      #text(size: 10.5pt)[
        #text(fill: rosso, weight: "bold")[Ogni strato è una funzione:] #h(0.3cm)
        $f_i : RR^(d_(i-1)) -> RR^(d_i)$
        #v(0.1cm)
        #align(center)[
          #text(size: 12pt)[$f_i (bold(x)) = sigma_i (bold(W)_i dot bold(x) + bold(b)_i)$]
        ]
        #v(0.2cm)
        #text(weight: "bold")[La rete è una composizione di funzioni:]
        #v(0.1cm)
        #align(center)[
          #text(size: 12pt)[$F = f_n compose f_(n-1) compose dots.c compose f_1$]
        ]
        #v(0.15cm)
        #align(center)[
          #text(size: 14pt)[$bold(y) = (f_n compose f_(n-1) compose dots.c compose f_1)(bold(x))$]
        ]
      ]
    ]
  ],
)
