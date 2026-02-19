#set page(width: 25.4cm, height: 14.29cm, margin: (x: 1cm, y: 0.8cm))
#set text(font: "New Computer Modern", size: 10.5pt, lang: "it")

#align(center)[
  #text(size: 18pt, weight: "bold")[Plasticità Sinaptica]
]

#v(0.3cm)

#grid(
  columns: (1fr, 10cm),
  gutter: 0.8cm,
  [
    #image("Blausen_0657_MultipolarNeuron.png", width: 100%)
  ],
  [
    #v(0.3cm)
    #box(stroke: 1pt + gray, radius: 5pt, fill: luma(250), inset: 10pt)[
      #text(size: 10pt)[
        *Integrazione del segnale*

        Nel soma, ogni input eccitatorio o inibitorio viene pesato in base alla sua intensità, frequenza e posizione anatomica per determinare l'attivazione del neurone.
      ]
    ]

    #v(0.3cm)

    #box(stroke: 1pt + gray, radius: 5pt, fill: luma(250), inset: 10pt)[
      #text(size: 10pt)[
        *Plasticità delle connessioni*

        La plasticità sinaptica modula nel tempo l'efficacia delle connessioni attraverso meccanismi di potenziamento e depressione.
      ]
    ]
  ]
)

#v(0.3cm)

#align(center)[
  #text(size: 12pt)[
    *Uso ripetuto* → *Potenziamento* #h(1.5cm) *Disuso* → *Depressione*
  ]
]
