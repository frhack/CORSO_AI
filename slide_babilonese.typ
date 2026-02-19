#set page(width: 25.4cm, height: 14.29cm, margin: (x: 1cm, y: 0.8cm))
#set text(font: "New Computer Modern", size: 10.5pt, lang: "it")

#let blu = rgb("#3498db")
#let verde = rgb("#27ae60")
#let viola = rgb("#9b59b6")
#let scuro = rgb("#2c3e50")
#let grigio = rgb("#7f8c8d")
#let rosso = rgb("#e74c3c")

#align(center)[
  #text(size: 18pt, weight: "bold")[Algoritmo Babilonese per la Radice Quadrata]
  #v(0.05cm)
  #text(size: 11pt, fill: grigio)[Un metodo vecchio di 4000 anni, ancora usato oggi]
]

#v(0.15cm)

#grid(
  columns: (1fr, 1.2fr),
  gutter: 0.6cm,
  [
    #box(stroke: 1.5pt + viola, radius: 6pt, fill: viola.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: viola)[La formula]
      #v(0.1cm)
      #align(center)[
        #text(size: 9.5pt)[Per calcolare $sqrt(S)$, si parte da una stima $x_0$ e si itera:]
        #v(0.15cm)
        #box(stroke: 1.5pt + viola, radius: 4pt, fill: viola.lighten(88%), inset: 8pt)[
          #text(size: 16pt)[$x_(n+1) = frac(x_n + S / x_n, 2)$]
        ]
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1.5pt + blu, radius: 6pt, fill: blu.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: blu)[Convergenza]
      #v(0.05cm)
      #text(size: 9.5pt)[
        Bastano *5–6 iterazioni* per raggiungere la precisione massima di un calcolatore (15 cifre decimali).
      ]
    ]
  ],
  [
    #align(center)[
      #image("babilonese.png", width: 100%)
    ]
  ],
)

#v(0.15cm)

#grid(
  columns: (1fr, 1.2fr),
  gutter: 0.6cm,
  [
    #box(stroke: 1.5pt + verde, radius: 6pt, fill: verde.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: verde.darken(10%))[Perché funziona?]
      #v(0.05cm)
      #text(size: 9.5pt)[
        Si crea una serie di rettangoli di area $S$, e ad ogni step la differenza tra i lati diminuisce.
      ]
    ]
  ],
  [
    #align(left + horizon)[
      #rotate(-3deg)[
        #text(font: "Caveat", size: 13pt, fill: luma(100))[
          Ho una mirabile \
          dimostrazione algebrica \
          ma non rientra nel \
          margine della slide
        ]
      ]
    ]
  ],
)

#place(right + bottom, dx: -0.5cm, dy: -0.3cm)[
  #rotate(2deg)[
    #text(font: "Caveat", size: 22pt, weight: "bold", fill: rosso)[
      ...però non è un vero programma, \
      non usa strutture dati!
    ]
  ]
]
