#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "it")

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")

#align(center)[
  #text(size: 20pt, weight: "bold")[A Caccia di Parametri]
  #v(0.1cm)
  #text(size: 14pt, fill: luma(80))[Caso Studio: Posizionare la Gioconda al Louvre]
]

#v(0.5cm)

#grid(
  columns: (auto, 12cm),
  gutter: 1cm,
  [
    #image("gioconda.jpg", height: 10cm)
  ],
  [
    #v(0.5cm)

    #box(stroke: 1pt + gray, radius: 5pt, fill: luma(250), inset: 12pt, width: 100%)[
      #text(size: 11pt)[
        *Il problema*

        Il quadro più famoso del mondo deve essere appeso alla parete. A che altezza ($h$) posizioniamo il bordo inferiore?

        #v(0.2cm)

        *Vincolo*: il centro del dipinto deve trovarsi *56 cm sopra* l'altezza degli occhi del visitatore medio.
      ]
    ]

    #v(0.5cm)

    #box(stroke: 1.5pt + verde, radius: 5pt, fill: verde.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt)[
        *I dati disponibili*

        - Database: *10 milioni* di ingressi anonimi all'anno
        - Variabile misurata: altezza dei visitatori
        - Popolazione eterogenea: turisti da tutto il mondo, scolaresche, famiglie...
      ]
    ]

    #v(0.5cm)

    #box(stroke: 1.5pt + rosso, radius: 5pt, fill: rosso.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt)[
        *La domanda*

        Come estraiamo *un singolo numero* da milioni di misurazioni per prendere una decisione concreta?
      ]
    ]
  ]
)
