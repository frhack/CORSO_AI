#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "it")

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")

#align(center)[
  #text(size: 20pt, weight: "bold")[A Caccia di Parametri — La Soluzione]
]

#v(0.5cm)

#grid(
  columns: (8.5cm, 8.5cm, 8.5cm),
  gutter: 0.8cm,
  box(stroke: 1.5pt + verde, radius: 8pt, fill: verde.lighten(95%), inset: 12pt)[
    #text(size: 13pt, weight: "bold", fill: verde)[1. I Dati (Input)]

    #v(0.3cm)

    #text(size: 10.5pt)[
      *Database*: 10 milioni di ingressi anonimi all'anno.

      *Variabile*: altezza dei visitatori.
    ]

    #v(0.3cm)

    #box(stroke: 1pt + verde.darken(10%), radius: 4pt, fill: verde.lighten(85%), inset: 8pt)[
      #text(size: 9.5pt, fill: verde.darken(40%))[
        In AI questo è il nostro *Dataset di Addestramento*.
      ]
    ]
  ],
  box(stroke: 1.5pt + viola, radius: 8pt, fill: viola.lighten(95%), inset: 12pt)[
    #text(size: 13pt, weight: "bold", fill: viola)[2. Il Peso ($w$)]

    #v(0.3cm)

    #text(size: 10.5pt)[
      Calcoliamo la media delle altezze:
    ]

    #v(0.2cm)

    #align(center)[
      $ m = frac(1, N) sum_(i=1)^(N) x_i = 175 "cm" $
    ]

    #v(0.2cm)

    #text(size: 10.5pt)[
      Se i dati cambiano (più turisti scandinavi, più scolaresche...), il valore $m$ cambia.
    ]

    #v(0.3cm)

    #box(stroke: 1pt + viola.darken(10%), radius: 4pt, fill: viola.lighten(85%), inset: 8pt)[
      #text(size: 9.5pt, fill: viola.darken(40%))[
        In AI questo è il *Peso* ($w$): il valore numerico imparato dai dati.
      ]
    ]
  ],
  box(stroke: 1.5pt + blu, radius: 8pt, fill: blu.lighten(95%), inset: 12pt)[
    #text(size: 13pt, weight: "bold", fill: blu)[3. Il Modello]

    #v(0.3cm)

    #text(size: 10.5pt)[
      La formula: $h = m + 56$

      È la struttura fissa. Non cambia al variare dei visitatori, ma ospita il peso per produrre il risultato.
    ]

    #v(0.3cm)

    #box(stroke: 1pt + blu.darken(10%), radius: 4pt, fill: blu.lighten(85%), inset: 8pt)[
      #text(size: 9.5pt, fill: blu.darken(40%))[
        In AI questa è la *Funzione di Predizione*: l'architettura del modello.
      ]
    ]
  ],
)

#v(0.5cm)

#align(center)[
  #box(stroke: 1.5pt + rosso, radius: 8pt, fill: rosso.lighten(95%), inset: 14pt)[
    #text(size: 11pt)[
      💡 Il *Modello* è la domanda che poniamo ai dati ($h = dots.h + 56$). \
      Il *Peso* è la risposta che i dati ci danno ($m = 175$) per agire nel mondo reale.
    ]
  ]
]
