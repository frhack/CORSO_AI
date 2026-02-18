#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "it")

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")

#align(center)[
  #text(size: 20pt, weight: "bold")[Geoffrey Hinton — Il Padrino del Deep Learning]
]

#v(0.5cm)

#grid(
  columns: (8cm, 8cm, 8cm),
  gutter: 0.8cm,
  [
    #align(center)[
      #image("hinton_child.jpg", height: 5.5cm)
    ]
    #v(0.3cm)
    #box(stroke: 1pt + verde, radius: 5pt, fill: verde.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 10pt)[
        *Le radici*

        Pronipote di *George Boole*, il matematico che inventò l'algebra booleana — la logica è nel DNA di famiglia.
      ]
    ]
  ],
  [
    #align(center)[
      #image("hinton_young.jpg", height: 5.5cm)
    ]
    #v(0.3cm)
    #box(stroke: 1pt + blu, radius: 5pt, fill: blu.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 10pt)[
        *Il pioniere*

        Negli anni Ottanta sviluppa la *backpropagation* e le Boltzmann machines. Crede nelle reti neurali quando quasi nessuno ci crede.
      ]
    ]
  ],
  [
    #align(center)[
      #image("hinton_nobel_price.png", height: 5.5cm)
    ]
    #v(0.3cm)
    #box(stroke: 1pt + rosso, radius: 5pt, fill: rosso.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 10pt)[
        *Il Nobel*

        *Premio Nobel per la Fisica 2024*, con John Hopfield, per le scoperte fondamentali sulle reti neurali artificiali.
      ]
    ]
  ],
)

#v(0.5cm)

#align(center)[
  #text(size: 12pt)[
    *Bambino curioso* #h(1cm) → #h(1cm) *Ricercatore visionario* #h(1cm) → #h(1cm) *Premio Nobel*
  ]
]
