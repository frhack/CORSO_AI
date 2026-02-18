#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern", size: 11pt)

#import "@preview/cetz:0.3.2"

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")

#align(center)[
  #text(size: 12pt)[*Obbligo fari accesi:* non è giorno o su strada extraurbana]
  #v(0.3cm)
  #text(size: 16pt, weight: "bold")[Fari Accesi: ¬$x_1$ ∨ $x_2$]
  #v(0.2cm)
  #text(size: 10pt)[$x_1$ = giorno, $x_2$ = strada extraurbana]
]

#v(0.6cm)

#align(center)[
  #cetz.canvas(length: 1cm, {
    import cetz.draw: *

    let neuron-x = 4
    let output-x = 7
    let r = 0.4

    // Input x1
    circle((0, 1.5), radius: r, fill: verde.lighten(85%), stroke: 1.5pt + verde)
    content((0, 1.5), $x_1$)

    // Input x2
    circle((0, -0.5), radius: r, fill: verde.lighten(85%), stroke: 1.5pt + verde)
    content((0, -0.5), $x_2$)

    // Neurone
    rect(
      (neuron-x - 1.5, -1.2),
      (neuron-x + 1.5, 2.2),
      fill: blu.lighten(92%),
      stroke: 2pt + blu,
      radius: 8pt
    )

    // Pesi e bias
    circle((neuron-x - 0.7, 1.4), radius: 0.35, fill: viola.lighten(85%), stroke: 1pt + viola)
    content((neuron-x - 0.7, 1.4), text(size: 9pt)[$w_1$])

    circle((neuron-x + 0.7, 1.4), radius: 0.35, fill: viola.lighten(85%), stroke: 1pt + viola)
    content((neuron-x + 0.7, 1.4), text(size: 9pt)[$w_2$])

    circle((neuron-x, 0.6), radius: 0.35, fill: viola.lighten(85%), stroke: 1pt + viola)
    content((neuron-x, 0.6), text(size: 9pt)[$b$])

    line((neuron-x - 1.2, 0), (neuron-x + 1.2, 0), stroke: 0.5pt + gray)
    content((neuron-x, -0.6), text(size: 11pt)[$x_1 w_1 + x_2 w_2 + b$])

    // Frecce
    line((r + 0.1, 1.5), (neuron-x - 1.5 - 0.1, 0.5), stroke: 1.2pt + verde, mark: (end: "stealth", fill: verde, scale: 0.5))
    line((r + 0.1, -0.5), (neuron-x - 1.5 - 0.1, 0.5), stroke: 1.2pt + verde, mark: (end: "stealth", fill: verde, scale: 0.5))

    // Output
    circle((output-x, 0.5), radius: r, fill: rosso.lighten(80%), stroke: 2pt + rosso)
    content((output-x, 0.5), $y$)

    line((neuron-x + 1.5 + 0.1, 0.5), (output-x - r - 0.1, 0.5), stroke: 1.5pt + blu, mark: (end: "stealth", fill: blu, scale: 0.5))
  })
]

#v(0.8cm)

#align(center)[
  #box(stroke: 1pt + blu, radius: 5pt, fill: blu.lighten(92%), inset: 10pt)[
    *Regola di decisione:* #h(1cm) $y = cases(1 quad "se" quad x_1 w_1 + x_2 w_2 + b quad > quad 0, 0 quad "altrimenti")$
  ]
]

#v(0.5cm)

#align(center)[
  #table(
    columns: (auto, auto, auto, auto, auto),
    inset: 8pt,
    align: center,
    stroke: 0.5pt + gray,
    fill: (col, row) => if row == 0 { blu.lighten(80%) } else if col == 3 { viola.lighten(90%) } else { white },
    [*$x_1$*], [*$x_2$*], [*Calcolo*], [*Valore*], [*y*],
    [0], [0], [$0 dot (-1) + 0 dot 1 + 0.5$], [*+0.5* > 0], [1 ✓],
    [0], [1], [$0 dot (-1) + 1 dot 1 + 0.5$], [*+1.5* > 0], [1 ✓],
    [1], [0], [$1 dot (-1) + 0 dot 1 + 0.5$], [*−0.5* < 0], [0 ✗],
    [1], [1], [$1 dot (-1) + 1 dot 1 + 0.5$], [*+0.5* > 0], [1 ✓],
  )
]

#v(0.5cm)

#align(center)[
  #box(stroke: 2pt + viola, radius: 5pt, fill: viola.lighten(92%), inset: 12pt)[
    #text(weight: "bold")[Pesi:] #h(0.5cm) $w_1 = -1 , quad w_2 = +1 , quad b = +0.5$
  ]
]
