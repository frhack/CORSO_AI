#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "it")

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")

#align(center)[
  #text(size: 20pt, weight: "bold")[La Legge di Moore e gli Inverni dell'AI]
]

#v(0.5cm)

#grid(
  columns: (11cm, 11cm),
  gutter: 1cm,
  [
    #box(stroke: 1.5pt + blu, radius: 8pt, fill: blu.lighten(95%), inset: 15pt, width: 100%)[
      #text(size: 13pt, weight: "bold", fill: blu)[La Legge di Moore (1965)]

      #v(0.3cm)

      #text(size: 10pt)[
        _"Il numero di transistor in un circuito integrato raddoppia circa ogni 2 anni"_ — Gordon Moore
      ]

      #v(0.3cm)

      #table(
        columns: (auto, auto, auto),
        stroke: 0.5pt + luma(200),
        fill: (x, y) => if y == 0 { blu.lighten(90%) },
        inset: 8pt,
        align: (left, left, right),
        [*Anno*], [*Chip*], [*Transistor*],
        [1971], [Intel 4004], [2.300],
        [1993], [Pentium], [3.100.000],
        [2012], [Ivy Bridge], [1.400.000.000],
        [2024], [Apple M4], [28.000.000.000],
      )

      #v(0.3cm)

      #text(size: 10pt)[
        *Conseguenza*: potenza di calcolo esponenziale a costi decrescenti — il motore che ha reso possibile il Deep Learning.
      ]
    ]
  ],
  [
    #box(stroke: 1.5pt + luma(150), radius: 8pt, fill: luma(248), inset: 15pt, width: 100%)[
      #text(size: 13pt, weight: "bold", fill: luma(80))[Gli Inverni dell'AI]

      #v(0.3cm)

      #text(size: 10pt)[
        *Primo inverno (1974–1980)*

        Le promesse dell'AI degli anni Sessanta non si avverano. I governi tagliano drasticamente i fondi di ricerca.
      ]

      #v(0.4cm)

      #text(size: 10pt)[
        *Secondo inverno (1987–1993)*

        I sistemi esperti si rivelano fragili e costosi da mantenere. Nuova ondata di disillusione.
      ]

      #v(0.4cm)

      #box(stroke: 1pt + viola, radius: 5pt, fill: viola.lighten(95%), inset: 10pt)[
        #text(size: 10pt)[
          *Causa comune*: idee brillanti, ma hardware e dati insufficienti.

          #v(0.2cm)

          *La svolta (2012)*: GPU potenti + Big Data + algoritmi migliori rendono finalmente possibile il Deep Learning.
        ]
      ]
    ]
  ],
)
