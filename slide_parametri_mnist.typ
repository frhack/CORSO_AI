#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "it")

#import "@preview/cetz:0.3.2"

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")
#let arancio = rgb("#e67e22")

#align(center)[
  #text(size: 20pt, weight: "bold")[A Caccia di Parametri]
  #v(0.1cm)
  #text(size: 14pt, fill: luma(80))[Che Cifra È?]
]

#v(0.3cm)

#grid(
  columns: (auto, 13cm),
  gutter: 1cm,
  [
    // === Immagine MNIST reale ===
    #align(center)[
      #box(stroke: 2pt + luma(60), radius: 4pt)[
        #image("mnist_2.png", width: 6cm)
      ]
      #v(0.2cm)
      #text(size: 10pt, fill: luma(80))[Immagine 28 × 28 pixel]
      #v(0.05cm)
      #text(size: 9pt, fill: luma(120))[(784 numeri da 0 a 255)]
    ]
  ],
  [
    // === SPIEGAZIONE ===
    #box(stroke: 1.5pt + rosso, radius: 8pt, fill: rosso.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: rosso)[Il problema]
      #v(0.15cm)
      #text(size: 10.5pt)[
        Ogni immagine è una griglia di pixel, ciascuno con un valore di grigio. Servono *parametri* e un *modello matematico* capace di predire di che cifra si tratta.
      ]
    ]

    #v(0.3cm)

    #box(stroke: 1.5pt + verde, radius: 8pt, fill: verde.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: verde.darken(10%))[L'obiettivo — Assegnare probabilità]
      #v(0.15cm)
      #text(size: 10.5pt)[
        Il modello deve associare all'immagine una *probabilità* per ciascuna delle 10 cifre:
      ]
      #v(0.2cm)

      #align(center)[
        #cetz.canvas(length: 0.4cm, {
          import cetz.draw: *

          let probs = (0.01, 0.02, 0.91, 0.02, 0.01, 0.01, 0.01, 0.00, 0.01, 0.00)
          let bar-h = 0.5
          let gap = 0.1
          let max-w = 18.0

          for (i, p) in probs.enumerate() {
            let y = (9 - i) * (bar-h + gap)
            let w = calc.max(p * max-w, 0.15)
            let is-winner = i == 2
            let bar-color = if is-winner { verde } else { blu.lighten(50%) }

            // Etichetta cifra
            content((-0.5, y + bar-h / 2), anchor: "east",
              text(size: 8pt, weight: if is-winner { "bold" } else { "regular" },
                fill: if is-winner { verde.darken(20%) } else { luma(80) })[#i])

            // Barra
            rect((0, y), (w, y + bar-h), fill: bar-color, stroke: none)

            // Percentuale
            let pct = calc.round(p * 100)
            content((w + 0.3, y + bar-h / 2), anchor: "west",
              text(size: 7pt, weight: if is-winner { "bold" } else { "regular" },
                fill: if is-winner { verde.darken(20%) } else { luma(120) })[#pct%])
          }
        })
      ]
    ]
  ]
)
