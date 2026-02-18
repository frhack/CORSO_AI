#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "it")

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")

#align(center)[
  #text(size: 20pt, weight: "bold")[A Caccia di Parametri]
  #v(0.1cm)
  #text(size: 14pt, fill: luma(80))[Caso Studio: La Moto di Marco]
]

#v(0.5cm)

#grid(
  columns: (auto, 12cm),
  gutter: 1cm,
  [
    #image("moto.jpg", height: 8cm)
  ],
  [
    #v(0.3cm)

    #box(stroke: 1pt + gray, radius: 5pt, fill: luma(250), inset: 12pt, width: 100%)[
      #text(size: 11pt)[
        *La promessa*

        I genitori di Marco gli hanno promesso: #linebreak()
        _"Se prendi *9* in fisica, ti compriamo la moto."_
      ]
    ]

    #v(0.5cm)

    #box(stroke: 1.5pt + viola, radius: 5pt, fill: viola.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt)[
        *Il dilemma di Marco*

        - Non vuole studiare *un minuto di meno* → rischierebbe la moto
        - Non vuole studiare *un minuto di più* → efficienza!

        #v(0.2cm)

        Ha i voti dei compiti precedenti. Sa quante ore ha studiato per ciascuno.
      ]
    ]

    #v(0.5cm)

    #box(stroke: 1.5pt + rosso, radius: 5pt, fill: rosso.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt)[
        *La domanda*

        Quante ore deve studiare *esattamente* per prendere 9?
      ]
    ]
  ]
)
