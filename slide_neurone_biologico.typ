#set page(width: 25.4cm, height: 14.29cm, margin: (x: 1cm, y: 0.8cm))
#set text(font: "New Computer Modern", size: 10.5pt, lang: "it")

#align(center)[
  #text(size: 18pt, weight: "bold")[Il Neurone Biologico]
]

#v(0.3cm)

#grid(
  columns: (1fr, 9cm),
  gutter: 0.8cm,
  [
    #image("Blausen_0657_MultipolarNeuron.png", width: 100%)
  ],
  [
    #v(1.5cm)
    #box(stroke: 1pt + gray, radius: 5pt, fill: luma(250), inset: 12pt)[
      #text(size: 10pt)[
        *Nota:* Il soma (cell body) opera un'integrazione dinamica dei segnali: ogni input (eccitatorio o inibitorio) viene pesato in base alla sua intensità, frequenza e posizione anatomica per determinare l'attivazione del neurone.
      ]
    ]
  ]
)

#v(0.3cm)

#align(center)[
  #text(size: 12pt)[
    *Dendriti* (input) #h(1cm) → #h(1cm) *Soma* (elaborazione) #h(1cm) → #h(1cm) *Assone* (output)
  ]
]
