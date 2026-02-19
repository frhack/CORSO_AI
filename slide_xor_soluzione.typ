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

// Prima riga: neurone + tabella con tentativo
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
      #text(size: 10pt, weight: "bold")[Tentativo: $w_1 = 1, w_2 = 1, b = -0.5$]
      #v(0.15cm)
      #table(
        columns: (auto, auto, auto, auto, auto, auto),
        inset: 7pt,
        align: center,
        stroke: 0.5pt + gray,
        fill: (col, row) => if row == 0 { blu.lighten(80%) } else if row == 4 { rosso.lighten(90%) } else if col == 3 { viola.lighten(90%) } else { white },
        [*$x_1$*], [*$x_2$*], [*Calcolo*], [*Valore*], [*y*], [*Atteso*],
        [0], [0], [$0 + 0 - 0.5$], [*−0.5* < 0], [0], [0 ✓],
        [0], [1], [$0 + 1 - 0.5$], [*+0.5* > 0], [1], [1 ✓],
        [1], [0], [$1 + 0 - 0.5$], [*+0.5* > 0], [1], [1 ✓],
        [1], [1], [$1 + 1 - 0.5$], [*+1.5* > 0], [1], [#text(fill: rosso, weight: "bold")[0 ✗]],
      )
    ]
  ],
)

#v(0.3cm)

// Seconda riga: conclusioni
#grid(
  columns: (1fr, 1fr),
  gutter: 0.5cm,
  [
    #align(center)[
      #box(stroke: 2pt + rosso, radius: 5pt, fill: rosso.lighten(93%), inset: 10pt)[
        #text(size: 11pt, weight: "bold", fill: rosso)[Un singolo neurone non basta!]
        #v(0.1cm)
        #text(size: 10pt)[
          Non esiste *nessuna* scelta di $w_1$, $w_2$, $b$ che risolva XOR. Il problema *non è linearmente separabile*.
        ]
      ]
    ]
  ],
  [
    #align(center)[
      #box(stroke: 1.5pt + arancio, radius: 5pt, fill: arancio.lighten(93%), inset: 10pt)[
        #text(size: 11pt, weight: "bold", fill: arancio.darken(10%))[Servono più neuroni]
        #v(0.1cm)
        #text(size: 10pt)[
          Per risolvere XOR servono *almeno 2 strati* di neuroni: nasce la *rete neurale*.
        ]
      ]
    ]
  ],
)
