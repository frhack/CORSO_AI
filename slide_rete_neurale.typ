#set page(width: 25.4cm, height: 14.29cm, margin: (x: 1cm, y: 0.8cm))
#set text(font: "New Computer Modern", size: 10.5pt, lang: "it")

#import "@preview/cetz:0.3.2"

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")
#let arancio = rgb("#e67e22")
#let grigio = rgb("#7f8c8d")

#align(center)[
  #text(size: 18pt, weight: "bold")[La Rete Neurale]
]

#v(0.2cm)

#grid(
  columns: (1.15fr, 1fr),
  gutter: 0.5cm,
  [
    #align(center)[
      #cetz.canvas(length: 0.9cm, {
        import cetz.draw: *

        // Posizioni strati
        let layer-x = (0, 3.5, 7, 10.5)
        let r = 0.4

        // Input layer: 3 neuroni
        let input-y = (3, 1.5, 0)
        for y in input-y {
          circle((layer-x.at(0), y), radius: r, fill: verde.lighten(85%), stroke: 1.5pt + verde)
        }
        content((layer-x.at(0), 3), text(size: 9pt)[$x_1$])
        content((layer-x.at(0), 1.5), text(size: 9pt)[$x_2$])
        content((layer-x.at(0), 0), text(size: 9pt)[$x_3$])

        // Hidden layer 1: 4 neuroni
        let h1-y = (3.5, 2.1, 0.9, -0.5)
        for y in h1-y {
          circle((layer-x.at(1), y), radius: r, fill: blu.lighten(85%), stroke: 1.5pt + blu)
        }

        // Hidden layer 2: 4 neuroni
        let h2-y = (3.5, 2.1, 0.9, -0.5)
        for y in h2-y {
          circle((layer-x.at(2), y), radius: r, fill: viola.lighten(85%), stroke: 1.5pt + viola)
        }

        // Output layer: 2 neuroni
        let out-y = (2.2, 0.8)
        for y in out-y {
          circle((layer-x.at(3), y), radius: r, fill: rosso.lighten(80%), stroke: 1.5pt + rosso)
        }
        content((layer-x.at(3), 2.2), text(size: 9pt)[$y_1$])
        content((layer-x.at(3), 0.8), text(size: 9pt)[$y_2$])

        // Connessioni input → hidden1
        for iy in input-y {
          for hy in h1-y {
            line(
              (layer-x.at(0) + r + 0.05, iy),
              (layer-x.at(1) - r - 0.05, hy),
              stroke: 0.6pt + verde.lighten(40%)
            )
          }
        }

        // Connessioni hidden1 → hidden2
        for hy1 in h1-y {
          for hy2 in h2-y {
            line(
              (layer-x.at(1) + r + 0.05, hy1),
              (layer-x.at(2) - r - 0.05, hy2),
              stroke: 0.6pt + blu.lighten(40%)
            )
          }
        }

        // Connessioni hidden2 → output
        for hy in h2-y {
          for oy in out-y {
            line(
              (layer-x.at(2) + r + 0.05, hy),
              (layer-x.at(3) - r - 0.05, oy),
              stroke: 0.6pt + viola.lighten(40%)
            )
          }
        }

        // Etichette strati (sotto)
        content((layer-x.at(0), -1.5), text(size: 8pt, fill: verde, weight: "bold")[Input])
        content((layer-x.at(1), -1.5), text(size: 8pt, fill: blu, weight: "bold")[Strato\ nascosto 1])
        content((layer-x.at(2), -1.5), text(size: 8pt, fill: viola, weight: "bold")[Strato\ nascosto 2])
        content((layer-x.at(3), -1.5), text(size: 8pt, fill: rosso, weight: "bold")[Output])

        // Freccia direzione segnale
        line((0.5, -2.5), (10, -2.5), stroke: 1pt + grigio, mark: (end: "stealth", fill: grigio, scale: 0.6))
        content((5.25, -3.0), text(size: 8pt, fill: grigio)[direzione del segnale])
      })
    ]
  ],
  [
    #v(0.1cm)
    #text(size: 10pt)[*Come leggere lo schema:*]
    #v(0.15cm)

    #box(stroke: 1pt + verde, radius: 4pt, fill: verde.lighten(93%), inset: 8pt, width: 100%)[
      #text(size: 9.5pt)[
        #text(fill: verde, weight: "bold")[Cerchi] = neuroni, organizzati in *strati* verticali
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1pt + blu, radius: 4pt, fill: blu.lighten(93%), inset: 8pt, width: 100%)[
      #text(size: 9.5pt)[
        #text(fill: blu, weight: "bold")[Linee] = connessioni, ognuna con un *peso* $w$
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1pt + viola, radius: 4pt, fill: viola.lighten(93%), inset: 8pt, width: 100%)[
      #text(size: 9.5pt)[
        #text(fill: viola, weight: "bold")[Ogni neurone] calcola $y = sigma(bold(x) dot bold(w) + b)$
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1pt + arancio, radius: 4pt, fill: arancio.lighten(93%), inset: 8pt, width: 100%)[
      #text(size: 9.5pt)[
        #text(fill: arancio.darken(10%), weight: "bold")[Il segnale] scorre da sinistra a destra, strato per strato
      ]
    ]

    #v(0.2cm)

    #align(center)[
      #box(stroke: 1.5pt + grigio, radius: 5pt, fill: luma(248), inset: 10pt)[
        #text(size: 9.5pt)[
          *Strati nascosti* = elaborazione intermedia \
          Più strati → problemi più complessi (es. XOR)
        ]
      ]
    ]
  ],
)
