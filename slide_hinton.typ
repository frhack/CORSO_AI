#set page(width: 25.4cm, height: 14.29cm, margin: (x: 1cm, y: 0.8cm))
#set text(font: "New Computer Modern", size: 10.5pt, lang: "it")

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")

#align(center)[
  #text(size: 18pt, weight: "bold")[Geoffrey Hinton — Il Padrino del Deep Learning]
]

#v(0.2cm)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 0.5cm,
  [
    #align(center)[
      #image("hinton_child.jpg", height: 4.8cm)
    ]
    #v(0.15cm)
    #box(stroke: 1pt + verde, radius: 5pt, fill: verde.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 9.5pt)[
        *Curiosità*

        Discendente di *George Boole*, il matematico che inventò l'algebra booleana.
      ]
    ]
  ],
  [
    #align(center)[
      #image("hinton_young.jpg", height: 4.8cm)
    ]
    #v(0.15cm)
    #box(stroke: 1pt + blu, radius: 5pt, fill: blu.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 9.5pt)[
        *Il pioniere*

        Negli anni Ottanta sviluppa la *backpropagation* e le Boltzmann machines. Crede nelle reti neurali quando quasi nessuno ci crede.
      ]
    ]
  ],
  [
    #align(center)[
      #image("hinton_nobel_price.png", height: 4.8cm)
    ]
    #v(0.15cm)
    #box(stroke: 1pt + rosso, radius: 5pt, fill: rosso.lighten(95%), inset: 8pt, width: 100%)[
      #text(size: 9.5pt)[
        *Il Nobel*

        *Premio Nobel per la Fisica 2024*, con John Hopfield, per le scoperte fondamentali sulle reti neurali artificiali.
      ]
    ]
  ],
)

