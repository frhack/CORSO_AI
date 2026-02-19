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
  #text(size: 18pt, weight: "bold")[Funzioni di Attivazione]
  #v(0.05cm)
  #text(size: 10pt, fill: grigio)[Introducono la *non linearità* che rende le reti neurali potenti]
]

#v(0.2cm)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  gutter: 0.4cm,
  [
    #align(center)[
      #box(stroke: 1.5pt + blu, radius: 5pt, fill: blu.lighten(93%), inset: 8pt, width: 100%)[
        #align(center)[
          #text(size: 10pt, weight: "bold", fill: blu)[Step (gradino)]
          #v(0.1cm)
          #cetz.canvas(length: 0.55cm, {
            import cetz.draw: *
            // Assi
            line((-2.5, 0), (2.5, 0), stroke: 0.5pt + grigio, mark: (end: "stealth", fill: grigio, scale: 0.3))
            line((0, -0.5), (0, 2.2), stroke: 0.5pt + grigio, mark: (end: "stealth", fill: grigio, scale: 0.3))
            content((2.5, -0.3), text(size: 6pt, fill: grigio)[$z$])
            // Funzione
            line((-2.5, 0), (0, 0), stroke: 2pt + blu)
            line((0, 1.8), (2.5, 1.8), stroke: 2pt + blu)
            circle((0, 0), radius: 0.1, fill: blu, stroke: blu)
            circle((0, 1.8), radius: 0.1, fill: white, stroke: 1.5pt + blu)
            // Labels
            content((-1.8, -0.4), text(size: 6pt, fill: grigio)[0])
            content((1.8, 2.2), text(size: 6pt, fill: grigio)[1])
          })
          #v(0.1cm)
          #text(size: 9pt)[
            $ sigma(z) = cases(1 "se" z > 0, 0 "altrimenti") $
          ]
        ]
      ]
    ]
  ],
  [
    #align(center)[
      #box(stroke: 1.5pt + arancio, radius: 5pt, fill: arancio.lighten(93%), inset: 8pt, width: 100%)[
        #align(center)[
          #text(size: 10pt, weight: "bold", fill: arancio.darken(10%))[Sigmoid]
          #v(0.1cm)
          #cetz.canvas(length: 0.55cm, {
            import cetz.draw: *
            // Assi
            line((-2.5, 0), (2.5, 0), stroke: 0.5pt + grigio, mark: (end: "stealth", fill: grigio, scale: 0.3))
            line((0, -0.5), (0, 2.2), stroke: 0.5pt + grigio, mark: (end: "stealth", fill: grigio, scale: 0.3))
            content((2.5, -0.3), text(size: 6pt, fill: grigio)[$z$])
            // Funzione sigmoid approssimata
            line((-2.5, 0.05), (-2.0, 0.07), (-1.5, 0.13), (-1.0, 0.25), (-0.5, 0.45), (0, 0.9), (0.5, 1.35), (1.0, 1.55), (1.5, 1.67), (2.0, 1.73), (2.5, 1.75), stroke: 2pt + arancio)
            // Linee tratteggiate
            line((-2.5, 1.8), (2.5, 1.8), stroke: (dash: "dashed", paint: grigio.lighten(40%), thickness: 0.5pt))
            content((-1.8, -0.4), text(size: 6pt, fill: grigio)[0])
            content((1.8, 2.2), text(size: 6pt, fill: grigio)[1])
          })
          #v(0.1cm)
          #text(size: 9pt)[
            $ sigma(z) = 1 / (1 + e^(-z)) $
          ]
        ]
      ]
    ]
  ],
  [
    #align(center)[
      #box(stroke: 1.5pt + verde, radius: 5pt, fill: verde.lighten(93%), inset: 8pt, width: 100%)[
        #align(center)[
          #text(size: 10pt, weight: "bold", fill: verde)[Tanh]
          #v(0.1cm)
          #cetz.canvas(length: 0.55cm, {
            import cetz.draw: *
            // Assi
            line((-2.5, 0.9), (2.5, 0.9), stroke: 0.5pt + grigio, mark: (end: "stealth", fill: grigio, scale: 0.3))
            line((0, -0.5), (0, 2.2), stroke: 0.5pt + grigio, mark: (end: "stealth", fill: grigio, scale: 0.3))
            content((2.5, 0.6), text(size: 6pt, fill: grigio)[$z$])
            // Funzione tanh approssimata (range -1 to 1, mapped to -0.0 to 1.8)
            line((-2.5, 0.03), (-2.0, 0.04), (-1.5, 0.08), (-1.0, 0.21), (-0.5, 0.48), (0, 0.9), (0.5, 1.32), (1.0, 1.59), (1.5, 1.72), (2.0, 1.76), (2.5, 1.77), stroke: 2pt + verde)
            // Linee tratteggiate
            line((-2.5, 1.8), (2.5, 1.8), stroke: (dash: "dashed", paint: grigio.lighten(40%), thickness: 0.5pt))
            line((-2.5, 0.0), (2.5, 0.0), stroke: (dash: "dashed", paint: grigio.lighten(40%), thickness: 0.5pt))
            content((-1.8, -0.4), text(size: 6pt, fill: grigio)[-1])
            content((1.8, 2.2), text(size: 6pt, fill: grigio)[+1])
          })
          #v(0.1cm)
          #text(size: 9pt)[
            $ tanh(z) = (e^z - e^(-z)) / (e^z + e^(-z)) $
          ]
        ]
      ]
    ]
  ],
  [
    #align(center)[
      #box(stroke: 1.5pt + rosso, radius: 5pt, fill: rosso.lighten(93%), inset: 8pt, width: 100%)[
        #align(center)[
          #text(size: 10pt, weight: "bold", fill: rosso)[ReLU]
          #v(0.1cm)
          #cetz.canvas(length: 0.55cm, {
            import cetz.draw: *
            // Assi
            line((-2.5, 0), (2.5, 0), stroke: 0.5pt + grigio, mark: (end: "stealth", fill: grigio, scale: 0.3))
            line((0, -0.5), (0, 2.2), stroke: 0.5pt + grigio, mark: (end: "stealth", fill: grigio, scale: 0.3))
            content((2.5, -0.3), text(size: 6pt, fill: grigio)[$z$])
            // Funzione ReLU
            line((-2.5, 0), (0, 0), stroke: 2pt + rosso)
            line((0, 0), (2.0, 1.8), stroke: 2pt + rosso)
            circle((0, 0), radius: 0.1, fill: rosso, stroke: rosso)
          })
          #v(0.1cm)
          #text(size: 9pt)[
            $ "ReLU"(z) = max(0, z) $
          ]
        ]
      ]
    ]
  ],
)

#v(0.25cm)

#box(stroke: 1pt + viola, radius: 4pt, fill: viola.lighten(93%), inset: 8pt, width: 100%)[
  #text(size: 9.5pt)[
    #text(fill: viola, weight: "bold")[Perché servono?] Senza funzioni di attivazione, la composizione di più strati lineari/affini collassa in un'unica trasformazione affine $bold(A) bold(x) + bold(c)$. La non linearità rende la rete capace di rappresentare funzioni molto più complesse e, in condizioni opportune, di approssimare *qualsiasi funzione* (*approssimatore universale*).
  ]
]
