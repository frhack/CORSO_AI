#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "it")

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")
#let arancio = rgb("#e67e22")

#align(center)[
  #text(size: 20pt, weight: "bold")[Massima Verosimiglianza — La Matematica]
]

#v(0.3cm)

#block(width: 22cm)[

// Likelihood
#box(stroke: 1.5pt + arancio, radius: 8pt, fill: arancio.lighten(93%), inset: 12pt, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: arancio.darken(10%))[Passo 1 — Verosimiglianza (Likelihood)]

  #v(0.15cm)

  #text(size: 10.5pt)[
    I voti sono indipendenti, quindi la probabilità congiunta è il *prodotto* delle singole densità:
  ]

  #v(0.15cm)

  #align(center)[
    #text(size: 12pt)[
      $ cal(L)(m, q) = product_(i=1)^N frac(1, sqrt(2 pi) sigma) exp lr(( -frac((y_i - m x_i - q)^2, 2 sigma^2) )) $
    ]
  ]
]

#v(0.3cm)

// Log-likelihood
#box(stroke: 1.5pt + blu, radius: 8pt, fill: blu.lighten(95%), inset: 12pt, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: blu)[Passo 2 — Passaggio ai logaritmi]

  #v(0.15cm)

  #text(size: 10.5pt)[
    Il logaritmo trasforma il prodotto in somma e l'esponenziale sparisce:
  ]

  #v(0.15cm)

  #align(center)[
    #text(size: 12pt)[
      $ ln cal(L) = underbrace(-frac(N, 2) ln(2 pi sigma^2), "costante") - frac(1, 2 sigma^2) sum_(i=1)^N (y_i - m x_i - q)^2 $
    ]
  ]

  #v(0.15cm)

  #text(size: 10.5pt)[
    Massimizzare $ln cal(L)$ rispetto a $m$ e $q$ equivale a *minimizzare* il secondo termine.
  ]
]

#v(0.3cm)

// Conclusione
#box(stroke: 1.5pt + viola, radius: 8pt, fill: viola.lighten(95%), inset: 14pt, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: viola)[Passo 3 — Conclusione]

  #v(0.2cm)

  #align(center)[
    Massimizzare $ln cal(L)$ #h(0.5cm)
    #text(size: 14pt)[$arrow.l.r$] #h(0.5cm)
    #text(weight: "bold")[Minimizzare] #h(0.5cm)
    #box(stroke: 1.5pt + viola, radius: 4pt, fill: viola.lighten(88%), inset: 8pt)[
      #text(size: 12pt)[$ sum_(i=1)^N (y_i - m x_i - q)^2 = L(m, q) $]
    ]
    #h(0.5cm) $arrow.r$ #h(0.2cm)
    #text(weight: "bold", fill: rosso)[Stessa Loss!]
  ]

  #v(0.2cm)

  #align(center)[
    #box(stroke: 1pt + rosso.darken(10%), radius: 4pt, fill: rosso.lighten(90%), inset: 8pt)[
      #text(size: 10.5pt, fill: rosso.darken(30%))[
        L'ipotesi di *errori gaussiani* giustifica il metodo dei *minimi quadrati*. Le due strade portano allo stesso risultato.
      ]
    ]
  ]
]

]
