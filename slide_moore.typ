#set page(width: 25.4cm, height: 14.29cm, margin: (x: 1cm, y: 0.8cm))
#set text(font: "New Computer Modern", size: 10.5pt, lang: "it")

#import "@preview/cetz:0.3.2"

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")
#let arancio = rgb("#e67e22")
#let grigio = rgb("#7f8c8d")

// ============================================================
// SLIDE 1 — Legge di Moore: la scala del transistor
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[Legge di Moore — La Scala del Transistor]
  #v(0.05cm)
  #text(size: 12pt, fill: luma(80))[Quanto è piccolo un transistor moderno?]
]

#v(0.15cm)

#grid(
  columns: (1fr, 1fr),
  gutter: 0.8cm,
  [
    #box(stroke: 1.5pt + blu, radius: 6pt, fill: blu.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: blu)[Le dimensioni]
      #v(0.1cm)

      #grid(
        columns: (auto, 1fr),
        gutter: 0.3cm,
        row-gutter: 0.15cm,
        text(size: 10pt, weight: "bold")[Transistor:],
        text(size: 10pt)[~50 nm],
        text(size: 10pt, weight: "bold")[Atomo di Si:],
        text(size: 10pt)[~0.23 nm],
      )

      #v(0.1cm)

      #align(center)[
        #box(stroke: 1pt + blu, radius: 4pt, fill: blu.lighten(88%), inset: 8pt)[
          #text(size: 11pt)[Un transistor $approx$ #text(weight: "bold")[meno di 300 atomi] di silicio]
        ]
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1.5pt + viola, radius: 6pt, fill: viola.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: viola)[Per confronto...]
      #v(0.05cm)
      #text(size: 10pt)[
        Un singolo transistor moderno ha le dimensioni di un *virus di medie dimensioni* (50–100 nm).
      ]
      #v(0.1cm)
      #align(center)[
        #grid(
          columns: (auto, auto, auto, auto, auto),
          gutter: 0.3cm,
          align: center,
          text(size: 8pt, fill: luma(100))[atomo Si \ 0.23 nm],
          text(size: 14pt)[$arrow.r$],
          text(size: 8pt, fill: viola, weight: "bold")[transistor \ ~50 nm],
          text(size: 14pt)[$arrow.r$],
          text(size: 8pt, fill: luma(100))[virus \ 50–100 nm],
        )
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1.5pt + arancio, radius: 6pt, fill: arancio.lighten(93%), inset: 8pt, width: 100%)[
      #text(size: 10pt, weight: "bold", fill: arancio.darken(10%))[Oggi (2026)] #h(0.3cm)
      #text(size: 10pt)[Un chip AI top di gamma: *80–150 miliardi* di transistor.]
    ]
  ],
  [
    #image("moore_law_chart.png", width: 100%)
  ]
)

#pagebreak()

// ============================================================
// SLIDE 2 — Proiezioni al 2030: packaging 3D
// ============================================================

#align(center)[
  #text(size: 18pt, weight: "bold")[Verso il 2030 — L'Era del Packaging 3D]
  #v(0.05cm)
  #text(size: 12pt, fill: luma(80))[Oltre i limiti del silicio planare]
]

#v(0.15cm)

#grid(
  columns: (1fr, auto),
  gutter: 0.8cm,
  [
    #box(stroke: 1.5pt + rosso, radius: 6pt, fill: rosso.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: rosso)[La vetta tecnologica del silicio]
      #v(0.05cm)
      #text(size: 9.5pt)[
        Con transistor di ~50 nm (meno di 300 atomi), ci avviciniamo ai *limiti fisici* della miniaturizzazione planare. La prossima frontiera non è più rimpicciolire, ma *impilare*.
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1.5pt + blu, radius: 6pt, fill: blu.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: blu)[L'obiettivo: 1 trilione di transistor]
      #v(0.05cm)
      #text(size: 9.5pt)[
        Sia *Intel* che *TSMC* hanno pianificato di raggiungere entro il 2030:
      ]
      #v(0.1cm)
      #align(center)[
        #box(stroke: 1.5pt + blu, radius: 4pt, fill: blu.lighten(85%), inset: 8pt)[
          #text(size: 14pt, weight: "bold")[1 000 000 000 000 transistor]
          #h(0.3cm) #text(size: 11pt)[(1 trilione)]
        ]
      ]
      #v(0.05cm)
      #text(size: 9.5pt)[in un *singolo package*.]
    ]

    #v(0.15cm)

    #box(stroke: 1.5pt + verde, radius: 6pt, fill: verde.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: verde.darken(10%))[Packaging 3D — La nuova strategia]
      #v(0.05cm)
      #text(size: 9.5pt)[
        La densità aumenterà *non solo* rimpicciolendo i componenti, ma *impilandoli* verticalmente. I chip vengono sovrapposti e collegati con *TSV* (Through-Silicon Via): connessioni verticali che attraversano il silicio.
      ]
    ]
  ],
  [
    #align(center)[
      #image("chip_3d_packaging.png", width: 8.5cm)

      #v(0.15cm)

      #box(stroke: 1pt + grigio, radius: 4pt, fill: luma(248), inset: 8pt)[
        #text(size: 9pt)[
          #grid(
            columns: (auto, auto),
            gutter: 0.15cm,
            row-gutter: 0.15cm,
            text(weight: "bold", fill: arancio)[2026:],
            text[80–150 miliardi],
            text(weight: "bold", fill: rosso)[2030:],
            text(weight: "bold")[1 trilione ($times$7)],
          )
        ]
      ]
    ]
  ]
)
