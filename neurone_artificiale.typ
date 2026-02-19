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
]

#v(0.3cm)

#align(center)[
  #cetz.canvas(length: 1.1cm, {
    import cetz.draw: *

    let input-x = 0
    let neuron-x = 5
    let act-x = 8.5
    let output-x = 11
    let r-input = 0.4
    let r-output = 0.55
    let box-left = neuron-x - 2.2
    let box-right = act-x + 1.4
    let box-top = 3.6
    let box-bot = -0.6

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

    // ===== Box neurone =====
    rect(
      (box-left, box-bot),
      (box-right, box-top),
      fill: blu.lighten(92%),
      stroke: 2pt + blu,
      radius: 8pt
    )

    // --- Parte sinistra: pesi, bias, somma ---
    content((neuron-x, 3.0), text(size: 10pt, fill: viola, weight: "bold")[MEMORIA])

    let r-w = 0.4
    circle((neuron-x - 1.3, 2.1), radius: r-w, fill: viola.lighten(85%), stroke: 1pt + viola)
    content((neuron-x - 1.3, 2.1), text(size: 10pt)[$w_1$])

    circle((neuron-x - 0.2, 2.1), radius: r-w, fill: viola.lighten(85%), stroke: 1pt + viola)
    content((neuron-x - 0.2, 2.1), text(size: 10pt)[$w_2$])

    content((neuron-x + 0.7, 2.1), text(size: 11pt)[...])

    circle((neuron-x + 1.3, 2.1), radius: r-w, fill: viola.lighten(85%), stroke: 1pt + viola)
    content((neuron-x + 1.3, 2.1), text(size: 10pt)[$w_n$])

    // Bias
    circle((neuron-x, 1.2), radius: r-w, fill: viola.lighten(85%), stroke: 1pt + viola)
    content((neuron-x, 1.2), text(size: 10pt)[$b$])

    line((neuron-x - 1.8, 0.4), (neuron-x + 1.8, 0.4), stroke: 0.5pt + gray)
    content((neuron-x, -0.15), text(size: 10pt)[$z = bold(x) dot bold(w) + b$])

    // --- Barra verticale separatrice ---
    line((act-x - 0.5, box-bot + 0.3), (act-x - 0.5, box-top - 0.3),
      stroke: 1.5pt + blu.lighten(30%))

    // --- Parte destra: attivazione ---
    content((act-x + 0.4, 2.2), text(size: 14pt, fill: arancio, weight: "bold")[$sigma$])
    content((act-x + 0.4, 1.2), text(size: 9pt, fill: arancio)[$sigma(z)$])
    content((act-x + 0.4, 0.2), text(size: 7pt, fill: luma(120))[attivazione])

    // ===== Frecce: Stimoli -> Neurone =====
    for (x, y, label) in inputs {
      if label != $dots.v$ {
        line(
          (x + r-input + 0.1, y),
          (box-left - 0.1, 1),
          stroke: 1.2pt + verde,
          mark: (end: "stealth", fill: verde, scale: 0.6)
        )
      }
    }

    // ===== OUTPUT (Reazione) =====
    circle((output-x, 1), radius: r-output, fill: rosso.lighten(80%), stroke: 2pt + rosso)
    content((output-x, 1), text(size: 12pt)[$y$])

    line(
      (box-right + 0.1, 1),
      (output-x - r-output - 0.1, 1),
      stroke: 1.5pt + blu,
      mark: (end: "stealth", fill: blu, scale: 0.6)
    )

    content((output-x + 2.2, 1), text(fill: rosso, weight: "bold", size: 11pt)[REAZIONE])
  })
]

#v(0.3cm)

#align(center)[
  #text(size: 13pt)[
    $z = x_1 w_1 + x_2 w_2 + ... + x_n w_n + b$
  ]
  #h(1.5cm)
  #box(stroke: 1pt + gray, radius: 5pt, fill: luma(250), inset: 12pt)[
    #text(size: 15pt)[
      $y = sigma(bold(x) dot bold(w) + b)$
    ]
  ]
]
