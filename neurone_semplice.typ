#set page(width: 25.4cm, height: 14.29cm, margin: (x: 1cm, y: 0.8cm))
#set text(font: "New Computer Modern", size: 10.5pt, lang: "it")

#import "@preview/cetz:0.3.2"

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")
#let arancio = rgb("#e67e22")

#align(center)[
  #text(size: 18pt, weight: "bold")[Il Neurone Artificiale]
  #h(1cm)
  #box(stroke: 1.5pt + arancio, radius: 4pt, fill: arancio.lighten(90%), inset: (x: 8pt, y: 4pt))[
    #text(size: 10pt, fill: arancio.darken(10%), weight: "bold")[Attenzione: versione incompleta]
  ]
]

#v(0.4cm)

#align(center)[
  #cetz.canvas(length: 1.1cm, {
    import cetz.draw: *

    let input-x = 0
    let neuron-x = 5
    let output-x = 9.5
    let r-input = 0.4
    let r-output = 0.55

    // ===== STIMOLI (Input) =====
    let inputs = ((0, 2.5, $x_1$), (0, 1.5, $x_2$), (0, 0.5, $dots.v$), (0, -0.5, $x_n$))

    for (x, y, label) in inputs {
      if label == $dots.v$ {
        content((x, y), text(size: 16pt)[⋮])
      } else {
        circle((x, y), radius: r-input, fill: verde.lighten(85%), stroke: 1.5pt + verde)
        content((x, y), text(size: 11pt)[#label])
      }
    }

    content((0, 3.4), text(fill: verde, weight: "bold", size: 11pt)[STIMOLI])

    // ===== NEURONE (corpo centrale) =====
    rect(
      (neuron-x - 2.2, -0.6),
      (neuron-x + 2.2, 3.6),
      fill: blu.lighten(92%),
      stroke: 2pt + blu,
      radius: 8pt
    )

    content((neuron-x, 3.0), text(size: 10pt, fill: viola, weight: "bold")[MEMORIA])

    let r-w = 0.4
    circle((neuron-x - 1.3, 2.1), radius: r-w, fill: viola.lighten(85%), stroke: 1pt + viola)
    content((neuron-x - 1.3, 2.1), text(size: 10pt)[$w_1$])

    circle((neuron-x - 0.2, 2.1), radius: r-w, fill: viola.lighten(85%), stroke: 1pt + viola)
    content((neuron-x - 0.2, 2.1), text(size: 10pt)[$w_2$])

    content((neuron-x + 0.7, 2.1), text(size: 11pt)[...])

    circle((neuron-x + 1.3, 2.1), radius: r-w, fill: viola.lighten(85%), stroke: 1pt + viola)
    content((neuron-x + 1.3, 2.1), text(size: 10pt)[$w_n$])

    line((neuron-x - 1.5, 1.2), (neuron-x + 1.5, 1.2), stroke: 0.5pt + gray)
    content((neuron-x, 0.3), text(size: 16pt, weight: "bold")[$bold(x) dot bold(w)$])

    // ===== Frecce: Stimoli -> Neurone =====
    for (x, y, label) in inputs {
      if label != $dots.v$ {
        line(
          (x + r-input + 0.1, y),
          (neuron-x - 2.2 - 0.1, 1),
          stroke: 1.2pt + verde,
          mark: (end: "stealth", fill: verde, scale: 0.6)
        )
      }
    }

    // ===== OUTPUT (Reazione) =====
    circle((output-x, 1), radius: r-output, fill: rosso.lighten(80%), stroke: 2pt + rosso)
    content((output-x, 1), text(size: 12pt)[$y$])

    line(
      (neuron-x + 2.2 + 0.1, 1),
      (output-x - r-output - 0.1, 1),
      stroke: 1.5pt + blu,
      mark: (end: "stealth", fill: blu, scale: 0.6)
    )

    content((output-x + 2.2, 1), text(fill: rosso, weight: "bold", size: 11pt)[REAZIONE])
  })
]

#v(0.4cm)

#align(center)[
  #text(size: 13pt)[
    $y = x_1 w_1 + x_2 w_2 + ... + x_n w_n$
  ]
  #h(1.5cm)
  #box(stroke: 1pt + gray, radius: 5pt, fill: luma(250), inset: 12pt)[
    #text(size: 15pt)[
      $y = bold(x) dot bold(w)$
    ]
  ]
]
