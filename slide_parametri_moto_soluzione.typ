#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "it")

#import "@preview/cetz:0.3.2"

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")
#let arancio = rgb("#e67e22")

#align(center)[
  #text(size: 20pt, weight: "bold")[A Caccia di Parametri — La Moto di Marco]
]

#v(0.3cm)

#grid(
  columns: (auto, 10cm),
  gutter: 0.8cm,
  [
    // === SCATTER PLOT ===
    #cetz.canvas(length: 0.75cm, {
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

      // Etichette assi
      content((10.5, -0.8), text(size: 9pt)[Ore di studio])
      content((-0.8, 10.5), anchor: "east", text(size: 9pt)[Voto])

      // Tacche asse x
      for x in range(1, 11) {
        line((x, -0.1), (x, 0.1), stroke: 0.8pt + luma(80))
        content((x, -0.5), text(size: 8pt)[#x])
      }

      // Tacche asse y
      for y in range(1, 11) {
        line((-0.1, y), (0.1, y), stroke: 0.8pt + luma(80))
        content((-0.5, y), text(size: 8pt)[#y])
      }

      // Linea target y = 9
      line((0, 9), (x-pred, 9),
        stroke: (dash: "dotted", paint: rosso.lighten(30%), thickness: 1pt))

      // Linea previsione x = 7.5
      line((x-pred, 0), (x-pred, 9),
        stroke: (dash: "dotted", paint: rosso.lighten(30%), thickness: 1pt))

      // Retta di regressione (parte solida, range dati)
      line((0, q), (5, m * 5 + q), stroke: 2.5pt + blu)

      // Retta di regressione (estensione tratteggiata)
      line((5, m * 5 + q), (x-pred, 9.0),
        stroke: (dash: "dashed", paint: blu, thickness: 2pt))

      // Residui (linee verticali errore)
      for (x, y) in dati {
        let y-line = m * x + q
        line((x, y), (x, y-line),
          stroke: (dash: "dashed", paint: arancio, thickness: 1.5pt))
      }

      // Dati di Marco (punti piccoli)
      for (x, y) in dati {
        circle((x, y), radius: 0.12, fill: verde, stroke: 1pt + verde.darken(20%))
      }

      // Punto previsione
      circle((x-pred, 9.0), radius: 0.15, fill: rosso, stroke: 1.5pt + rosso.darken(20%))

      // Etichette
      content((x-pred, -0.9), text(size: 9pt, fill: rosso, weight: "bold")[7.5])
      content((-0.8, 9), text(size: 9pt, fill: rosso, weight: "bold")[9])

      // Label punto previsione
      content((x-pred + 0.5, 9.6), anchor: "west",
        text(size: 8pt, fill: rosso, weight: "bold")[(7.5 , 9)])

      // Label retta
      content((6.5, m * 6.5 + q + 0.6), anchor: "west",
        text(size: 9pt, fill: blu, weight: "bold")[$y = 0.8 x + 3$])

      // Legenda errore
      line((7, 2), (7.5, 2), stroke: (dash: "dashed", paint: arancio, thickness: 1.5pt))
      content((7.8, 2), anchor: "west",
        text(size: 8pt, fill: arancio)[errore])
    })
  ],
  [
    // === DATI + MODELLO (colonna destra) ===

    // 1. I Dati
    #box(stroke: 1.5pt + verde, radius: 8pt, fill: verde.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 12pt, weight: "bold", fill: verde)[1. I Dati di Marco]

      #v(0.2cm)

      #table(
        columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr),
        stroke: 0.5pt + luma(200),
        fill: (x, y) => if y == 0 { verde.lighten(90%) },
        inset: 6pt,
        align: center,
        [], [*C1*], [*C2*], [*C3*], [*C4*], [*C5*],
        [*Ore* ($x$)], [1], [2], [3], [4], [5],
        [*Voto* ($y$)], [4.0], [5.0], [4.5], [6.0], [7.5],
      )
    ]

    #v(0.4cm)

    // 2. Il Modello
    #box(stroke: 1.5pt + viola, radius: 8pt, fill: viola.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 12pt, weight: "bold", fill: viola)[2. Il Modello (2 parametri)]

      #v(0.2cm)

      #align(center)[
        #text(size: 13pt)[$y = m x + q$]
      ]

      #v(0.2cm)

      #text(size: 10.5pt)[
        Interpolazione lineare sui dati:

        #h(0.5cm) $m = 0.8$ #h(0.5cm) (pendenza) \
        #h(0.5cm) $q = 3.0$ #h(0.5cm) (intercetta)
      ]

    ]
  ]
)

#v(0.4cm)

// 3. La Previsione (full width, sotto il grafico)
#align(center)[
  #box(stroke: 1.5pt + rosso, radius: 8pt, fill: rosso.lighten(95%), inset: 14pt)[
    #text(size: 12pt, weight: "bold", fill: rosso)[3. La Previsione] #h(1cm)
    Per ottenere $y = 9$: #h(0.5cm)
    $9 = 0.8 x + 3 quad arrow.r quad x = frac(9 - 3, 0.8) = bold(7.5 "ore")$
    #h(1cm)
    #box(stroke: 1pt + rosso.darken(10%), radius: 4pt, fill: rosso.lighten(85%), inset: (x: 8pt, y: 5pt))[
      #text(size: 9.5pt, fill: rosso.darken(40%))[In AI: l'*Inferenza*]
    ]
  ]
]
