#set page(width: 25.4cm, height: 14.29cm, margin: (x: 1cm, y: 0.8cm))
#set text(font: "New Computer Modern", size: 10.5pt, lang: "it")

#import "@preview/cetz:0.3.2"

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")
#let arancio = rgb("#e67e22")

#align(center)[
  #text(size: 11pt)[*Regola d'uso della congiunzione avversativa:* devi usare "ma" o "però" ma non entrambi]
  #v(0.1cm)
  #text(size: 16pt, weight: "bold")[Ma / Però: $x_1$ ⊕ $x_2$  #h(0.3cm) #text(fill: rosso)[(XOR)]]
  #v(0.05cm)
  #text(size: 10pt)[$x_1$ = usa "ma", $x_2$ = usa "però"]
]

#v(0.25cm)

#grid(
  columns: (1fr, 1fr),
  gutter: 0.5cm,
  [
    #align(center)[
      #cetz.canvas(length: 0.85cm, {
        import cetz.draw: *

        let neuron-x = 4
        let act-x = 7.2
        let output-x = 10
        let r = 0.4
        let box-left = neuron-x - 1.8
        let box-right = act-x + 1.4
        let box-top = 2.6
        let box-bot = -1.6

        // Input
        circle((0, 1.5), radius: r, fill: verde.lighten(85%), stroke: 1.5pt + verde)
        content((0, 1.5), $x_1$)
        circle((0, -0.5), radius: r, fill: verde.lighten(85%), stroke: 1.5pt + verde)
        content((0, -0.5), $x_2$)

        // Grande box neurone
        rect(
          (box-left, box-bot),
          (box-right, box-top),
          fill: blu.lighten(92%),
          stroke: 2pt + blu,
          radius: 8pt
        )

        // Parte sinistra: pesi e somma
        circle((neuron-x - 0.8, 1.5), radius: 0.35, fill: viola.lighten(85%), stroke: 1pt + viola)
        content((neuron-x - 0.8, 1.5), text(size: 9pt)[$w_1$])

        circle((neuron-x + 0.8, 1.5), radius: 0.35, fill: viola.lighten(85%), stroke: 1pt + viola)
        content((neuron-x + 0.8, 1.5), text(size: 9pt)[$w_2$])

        circle((neuron-x, 0.5), radius: 0.35, fill: viola.lighten(85%), stroke: 1pt + viola)
        content((neuron-x, 0.5), text(size: 9pt)[$b$])

        line((neuron-x - 1.5, -0.2), (neuron-x + 1.5, -0.2), stroke: 0.5pt + gray)
        content((neuron-x, -0.9), text(size: 9pt)[$z = x_1 w_1 + x_2 w_2 + b$])

        // Barra verticale separatrice
        line((act-x - 0.5, box-bot + 0.3), (act-x - 0.5, box-top - 0.3),
          stroke: 1.5pt + blu.lighten(30%))

        // Parte destra: funzione di attivazione
        content((act-x + 0.4, 1.2), text(size: 12pt, fill: arancio, weight: "bold")[$sigma$])
        content((act-x + 0.4, 0.2), text(size: 8pt, fill: arancio)[$sigma(z)$])
        content((act-x + 0.4, -0.7), text(size: 7pt, fill: luma(120))[attivazione])

        // Frecce input → neurone
        line((r + 0.1, 1.5), (box-left - 0.1, 0.5), stroke: 1.2pt + verde, mark: (end: "stealth", fill: verde, scale: 0.5))
        line((r + 0.1, -0.5), (box-left - 0.1, 0.5), stroke: 1.2pt + verde, mark: (end: "stealth", fill: verde, scale: 0.5))

        // Output y
        circle((output-x, 0.5), radius: r, fill: rosso.lighten(80%), stroke: 2pt + rosso)
        content((output-x, 0.5), $y$)

        line((box-right + 0.1, 0.5), (output-x - r - 0.1, 0.5), stroke: 1.5pt + blu, mark: (end: "stealth", fill: blu, scale: 0.5))
      })
    ]
  ],
  [
    #box(stroke: 1.5pt + arancio, radius: 6pt, fill: arancio.lighten(93%), inset: 10pt, width: 100%)[
      #text(size: 10.5pt, weight: "bold", fill: arancio.darken(10%))[Funzione di attivazione $sigma$]
      #v(0.1cm)
      #text(size: 10pt)[
        Dopo la somma pesata, il neurone applica una *funzione non lineare*:
        $ y = sigma(z) = cases(1 quad "se" z > 0, 0 quad "altrimenti") $
      ]
    ]

    #v(0.2cm)

    #align(center)[
      #table(
        columns: (auto, auto, auto),
        inset: 7pt,
        align: center,
        stroke: 0.5pt + gray,
        fill: (col, row) => if row == 0 { blu.lighten(80%) } else { white },
        [*$x_1$*], [*$x_2$*], [*$y$ atteso*],
        [0], [0], [0],
        [0], [1], [1],
        [1], [0], [1],
        [1], [1], [0],
      )
    ]

    #v(0.2cm)

    #align(center)[
      #box(stroke: 2pt + viola, radius: 5pt, fill: viola.lighten(92%), inset: 12pt)[
        #text(weight: "bold")[Pesi:] #h(0.5cm) $w_1 = ? , quad w_2 = ? , quad b = ?$
      ]
    ]
  ],
)
