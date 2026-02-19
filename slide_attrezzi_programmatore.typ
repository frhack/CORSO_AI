#set page(width: 25.4cm, height: 14.29cm, margin: (x: 1cm, y: 0.8cm))
#set text(font: "New Computer Modern", size: 10.5pt, lang: "it")

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")
#let arancio = rgb("#e67e22")
#let grigio = rgb("#7f8c8d")
#let giallo = rgb("#f1c40f")

#align(center)[
  #text(size: 18pt, weight: "bold")[La Cassetta degli Attrezzi del Programmatore]
]

#v(0.25cm)

#grid(
  columns: (1fr, 1fr),
  gutter: 0.6cm,
  [
    #image("cassetta_attrezzi.png", width: 100%)
  ],
  [
    #v(0.1cm)
    #grid(
      columns: (1fr, 1fr),
      gutter: 0.35cm,
      row-gutter: 0.3cm,
      box(stroke: 1.5pt + verde, radius: 6pt, fill: verde.lighten(95%), inset: 8pt)[
        #text(size: 10pt, weight: "bold", fill: verde.darken(10%))[Condizioni (`if`)]
        #v(0.05cm)
        #box(fill: luma(240), radius: 3pt, inset: 5pt, width: 100%)[
          #raw(lang: "python", "if eta >= 18:\n  print(\"ok\")")
        ]
      ],
      box(stroke: 1.5pt + arancio, radius: 6pt, fill: arancio.lighten(93%), inset: 8pt)[
        #text(size: 10pt, weight: "bold", fill: arancio.darken(10%))[Cicli (`for`)]
        #v(0.05cm)
        #box(fill: luma(240), radius: 3pt, inset: 5pt, width: 100%)[
          #raw(lang: "python", "for i in range(10):\n  print(i)")
        ]
      ],
      box(stroke: 1.5pt + blu, radius: 6pt, fill: blu.lighten(95%), inset: 8pt)[
        #text(size: 10pt, weight: "bold", fill: blu)[Variabili]
        #v(0.05cm)
        #box(fill: luma(240), radius: 3pt, inset: 5pt, width: 100%)[
          #raw(lang: "python", "x = 42\nnome = \"Alice\"")
        ]
      ],
      box(stroke: 1.5pt + rosso, radius: 6pt, fill: rosso.lighten(95%), inset: 8pt)[
        #text(size: 10pt, weight: "bold", fill: rosso)[Funzioni]
        #v(0.05cm)
        #box(fill: luma(240), radius: 3pt, inset: 5pt, width: 100%)[
          #raw(lang: "python", "def area(b, h):\n  return b*h/2")
        ]
      ],
      box(stroke: 1.5pt + viola, radius: 6pt, fill: viola.lighten(95%), inset: 8pt)[
        #text(size: 10pt, weight: "bold", fill: viola)[Strutture Dati]
        #v(0.05cm)
        #box(fill: luma(240), radius: 3pt, inset: 5pt, width: 100%)[
          #raw(lang: "python", "voti = [8, 7, 9]\nd = {\"a\": 1}")
        ]
      ],
      box(stroke: 1.5pt + grigio, radius: 6pt, fill: luma(248), inset: 8pt)[
        #text(size: 10pt, weight: "bold", fill: grigio.darken(10%))[Input / Output]
        #v(0.05cm)
        #box(fill: luma(240), radius: 3pt, inset: 5pt, width: 100%)[
          #raw(lang: "python", "n = input(\"?\")\nprint(n)")
        ]
      ],
    )

  ],
)
