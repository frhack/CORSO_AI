#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern")

#import "@preview/cetz:0.3.2"

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")

#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  // Parametri
  let input-x = 0
  let neuron-x = 4
  let sigma-x = 8
  let output-x = 10
  let r-input = 0.35
  let r-sigma = 0.6
  let r-output = 0.5

  // ===== STIMOLI (Input) =====
  let inputs = ((0, 2.5, $x_1$), (0, 1.5, $x_2$), (0, 0.5, $dots.v$), (0, -0.5, $x_n$))

  for (x, y, label) in inputs {
    if label == $dots.v$ {
      content((x, y), text(size: 14pt)[⋮])
    } else {
      circle((x, y), radius: r-input, fill: verde.lighten(85%), stroke: 1.5pt + verde)
      content((x, y), label)
    }
  }

  // Etichetta STIMOLI (sopra il vettore x)
  content((0, 3.3), text(fill: verde, weight: "bold", size: 10pt)[STIMOLI])

  // ===== NEURONE (corpo centrale) =====
  rect(
    (neuron-x - 1.8, -0.8),
    (neuron-x + 1.8, 3.3),
    fill: blu.lighten(92%),
    stroke: 2pt + blu,
    radius: 8pt
  )

  // Contenuto del neurone
  content((neuron-x, 2.7), text(size: 9pt, fill: viola, weight: "bold")[MEMORIA])

  // Cerchi per i pesi w
  let r-w = 0.35
  circle((neuron-x - 1.1, 1.9), radius: r-w, fill: viola.lighten(85%), stroke: 1pt + viola)
  content((neuron-x - 1.1, 1.9), text(size: 9pt)[$w_1$])

  circle((neuron-x - 0.2, 1.9), radius: r-w, fill: viola.lighten(85%), stroke: 1pt + viola)
  content((neuron-x - 0.2, 1.9), text(size: 9pt)[$w_2$])

  content((neuron-x + 0.5, 1.9), text(size: 10pt)[...])

  circle((neuron-x + 1.1, 1.9), radius: r-w, fill: viola.lighten(85%), stroke: 1pt + viola)
  content((neuron-x + 1.1, 1.9), text(size: 9pt)[$w_n$])

  // Cerchio per il bias b
  circle((neuron-x, 1.1), radius: r-w, fill: viola.lighten(85%), stroke: 1pt + viola)
  content((neuron-x, 1.1), text(size: 10pt)[$b$])

  line((neuron-x - 1.2, 0.5), (neuron-x + 1.2, 0.5), stroke: 0.5pt + gray)
  content((neuron-x, -0.1), text(size: 14pt, weight: "bold")[$bold(x) dot bold(w) + b$])

  // ===== Frecce: Stimoli -> Neurone =====
  for (x, y, label) in inputs {
    if label != $dots.v$ {
      line(
        (x + r-input + 0.1, y),
        (neuron-x - 1.8 - 0.1, 1),
        stroke: 1.2pt + verde,
        mark: (end: "stealth", fill: verde, scale: 0.6)
      )
    }
  }

  // ===== ATTIVAZIONE (sigma) =====
  circle((sigma-x, 1), radius: r-sigma, fill: rosso.lighten(85%), stroke: 2pt + rosso)
  content((sigma-x, 1), text(size: 16pt, weight: "bold")[$sigma$])

  // Freccia: Neurone -> Sigma
  line(
    (neuron-x + 1.8 + 0.1, 1),
    (sigma-x - r-sigma - 0.1, 1),
    stroke: 1.5pt + blu,
    mark: (end: "stealth", fill: blu, scale: 0.6)
  )

  // ===== OUTPUT (Reazione) =====
  circle((output-x, 1), radius: r-output, fill: rosso.lighten(80%), stroke: 2pt + rosso)
  content((output-x, 1), $y$)

  // Freccia: Sigma -> Output
  line(
    (sigma-x + r-sigma + 0.1, 1),
    (output-x - r-output - 0.1, 1),
    stroke: 1.5pt + rosso,
    mark: (end: "stealth", fill: rosso, scale: 0.6)
  )

  // Etichetta REAZIONE
  content((output-x + 2, 1), text(fill: rosso, weight: "bold", size: 10pt)[REAZIONE])
})

#v(0.8cm)

#align(center)[
  $y = sigma(x_1 w_1 + x_2 w_2 + ... + x_n w_n + b)$

  #v(0.3cm)

  #box(stroke: 1pt + gray, radius: 5pt, fill: luma(250), inset: 12pt)[
    #text(size: 12pt)[
      $y = sigma(bold(x) dot bold(w) + b)$
    ]
  ]
]
