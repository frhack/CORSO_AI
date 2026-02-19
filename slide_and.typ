#set page(width: 25.4cm, height: 14.29cm, margin: (x: 1cm, y: 0.8cm))
#set text(font: "New Computer Modern", size: 10.5pt, lang: "it")

#import "@preview/cetz:0.3.2"

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")

#align(center)[
  #text(size: 11pt)[*Posso uscire a giocare:* ho finito i compiti e ho riordinato la camera]
  #v(0.1cm)
  #text(size: 16pt, weight: "bold")[Uscire a Giocare: $x_1$ ∧ $x_2$]
  #v(0.05cm)
  #text(size: 10pt)[$x_1$ = compiti finiti, $x_2$ = camera riordinata]
]

#v(0.25cm)

// Prima riga: neurone + tabella
#grid(
  columns: (1fr, 1fr),
  gutter: 0.5cm,
  [
    #align(center)[
      #cetz.canvas(length: 0.85cm, {
        import cetz.draw: *

        let neuron-x = 4
        let output-x = 8
        let r = 0.4

        circle((0, 1.5), radius: r, fill: verde.lighten(85%), stroke: 1.5pt + verde)
        content((0, 1.5), $x_1$)

        circle((0, -0.5), radius: r, fill: verde.lighten(85%), stroke: 1.5pt + verde)
        content((0, -0.5), $x_2$)

        rect(
          (neuron-x - 1.8, -1.4),
          (neuron-x + 1.8, 2.4),
          fill: blu.lighten(92%),
          stroke: 2pt + blu,
          radius: 8pt
        )

        circle((neuron-x - 0.8, 1.5), radius: 0.35, fill: viola.lighten(85%), stroke: 1pt + viola)
        content((neuron-x - 0.8, 1.5), text(size: 9pt)[$w_1$])

        circle((neuron-x + 0.8, 1.5), radius: 0.35, fill: viola.lighten(85%), stroke: 1pt + viola)
        content((neuron-x + 0.8, 1.5), text(size: 9pt)[$w_2$])

        circle((neuron-x, 0.7), radius: 0.35, fill: viola.lighten(85%), stroke: 1pt + viola)
        content((neuron-x, 0.7), text(size: 9pt)[$b$])

        line((neuron-x - 1.5, 0), (neuron-x + 1.5, 0), stroke: 0.5pt + gray)
        content((neuron-x, -0.6), text(size: 10pt)[$x_1 w_1 + x_2 w_2 + b$])

        line((r + 0.1, 1.5), (neuron-x - 1.8 - 0.1, 0.5), stroke: 1.2pt + verde, mark: (end: "stealth", fill: verde, scale: 0.5))
        line((r + 0.1, -0.5), (neuron-x - 1.8 - 0.1, 0.5), stroke: 1.2pt + verde, mark: (end: "stealth", fill: verde, scale: 0.5))

        circle((output-x, 0.5), radius: r, fill: rosso.lighten(80%), stroke: 2pt + rosso)
        content((output-x, 0.5), $y$)

        line((neuron-x + 1.8 + 0.1, 0.5), (output-x - r - 0.1, 0.5), stroke: 1.5pt + blu, mark: (end: "stealth", fill: blu, scale: 0.5))
      })
    ]
  ],
  [
    #align(center)[
      #table(
        columns: (auto, auto, auto, auto, auto),
        inset: 7pt,
        align: center,
        stroke: 0.5pt + gray,
        fill: (col, row) => if row == 0 { blu.lighten(80%) } else if col == 3 { viola.lighten(90%) } else { white },
        [*$x_1$*], [*$x_2$*], [*Calcolo*], [*Valore*], [*y*],
        [0], [0], [$0 dot 1 + 0 dot 1 - 1.5$], [*−1.5* < 0], [0 ✗],
        [0], [1], [$0 dot 1 + 1 dot 1 - 1.5$], [*−0.5* < 0], [0 ✗],
        [1], [0], [$1 dot 1 + 0 dot 1 - 1.5$], [*−0.5* < 0], [0 ✗],
        [1], [1], [$1 dot 1 + 1 dot 1 - 1.5$], [*+0.5* > 0], [1 ✓],
      )
    ]
  ],
)

#v(0.3cm)

// Seconda riga: regola decisione + pesi
#grid(
  columns: (1fr, 1fr),
  gutter: 0.5cm,
  [
    #align(center)[
      #box(stroke: 1pt + blu, radius: 5pt, fill: blu.lighten(92%), inset: 10pt)[
        *Regola di decisione:* #v(0.1cm)
        $y = cases(1 quad "se" quad x_1 w_1 + x_2 w_2 + b > 0, 0 quad "altrimenti")$
      ]
    ]
  ],
  [
    #align(center)[
      #box(stroke: 2pt + viola, radius: 5pt, fill: viola.lighten(92%), inset: 12pt)[
        #text(weight: "bold")[Pesi:] #h(0.5cm) $w_1 = +1 , quad w_2 = +1 , quad b = -1.5$
      ]
    ]
  ],
)
