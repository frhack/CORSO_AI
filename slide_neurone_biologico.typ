#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "it")

#align(center)[
  #text(size: 20pt, weight: "bold")[Il Neurone Biologico]
]

#v(0.5cm)

#grid(
  columns: (auto, 8cm),
  gutter: 1cm,
  [
    #image("Blausen_0657_MultipolarNeuron.png", width: 12cm)
  ],
  [
    #v(2cm)
    #box(stroke: 1pt + gray, radius: 5pt, fill: luma(250), inset: 12pt)[
      #text(size: 10pt)[
        *Nota:* Il soma (cell body) opera un'integrazione dinamica dei segnali: ogni input (eccitatorio o inibitorio) viene pesato in base alla sua intensità, frequenza e posizione anatomica per determinare l'attivazione del neurone.
      ]
    ]
  ]
)

#v(0.5cm)

#align(center)[
  #text(size: 12pt)[
    *Dendriti* (input) #h(1cm) → #h(1cm) *Soma* (elaborazione) #h(1cm) → #h(1cm) *Assone* (output)
  ]
]
