#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "it")

#align(center)[
  #text(size: 20pt, weight: "bold")[Plasticità Sinaptica]
]

#v(0.5cm)

#grid(
  columns: (auto, 9cm),
  gutter: 1cm,
  [
    #image("Blausen_0657_MultipolarNeuron.png", width: 12cm)
  ],
  [
    #v(0.5cm)
    #box(stroke: 1pt + gray, radius: 5pt, fill: luma(250), inset: 12pt)[
      #text(size: 10pt)[
        *Integrazione del segnale*

        Nel soma, ogni input eccitatorio o inibitorio viene pesato in base alla sua intensità, frequenza e posizione anatomica per determinare l'attivazione del neurone.
      ]
    ]

    #v(0.5cm)

    #box(stroke: 1pt + gray, radius: 5pt, fill: luma(250), inset: 12pt)[
      #text(size: 10pt)[
        *Plasticità delle connessioni*

        La plasticità sinaptica modula nel tempo l'efficacia delle connessioni attraverso meccanismi di potenziamento e depressione.
      ]
    ]
  ]
)

#v(0.5cm)

#align(center)[
  #text(size: 12pt)[
    *Uso ripetuto* → *Potenziamento* #h(1.5cm) *Disuso* → *Depressione*
  ]
]
