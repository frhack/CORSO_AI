#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "it")

#import "@preview/cetz:0.3.2"

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")
#let arancio = rgb("#e67e22")

#align(center)[
  #text(size: 20pt, weight: "bold")[Come Trovare $m$ e $q$]
  #v(0.1cm)
  #text(size: 14pt, fill: luma(80))[Metodo 2 — Massima Verosimiglianza]
]

#v(0.3cm)

#grid(
  columns: (14cm, auto),
  gutter: 1cm,
  [
    // Ipotesi
    #box(stroke: 1.5pt + verde, radius: 8pt, fill: verde.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: verde)[Ipotesi — Ogni voto è una gaussiana]

      #v(0.15cm)

      #text(size: 10.5pt)[
        Ogni voto $y_i$ è la realizzazione di una variabile casuale gaussiana centrata sulla retta:
      ]

      #v(0.1cm)

      #align(center)[
        #text(size: 13pt)[
          $ y_i tilde cal(N)(m x_i + q, #h(0.15cm) sigma^2) $
        ]
      ]
    ]

    #v(0.25cm)

    // Likelihood
    #box(stroke: 1.5pt + arancio, radius: 8pt, fill: arancio.lighten(93%), inset: 12pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: arancio.darken(10%))[Verosimiglianza (Likelihood)]

      #v(0.15cm)

      #text(size: 10.5pt)[
        La probabilità di osservare *tutti* i dati insieme:
      ]

      #v(0.1cm)

      #align(center)[
        $ cal(L)(m, q) = product_(i=1)^N frac(1, sqrt(2 pi) sigma) exp lr(( -frac((y_i - m x_i - q)^2, 2 sigma^2) )) $
      ]
    ]

    #v(0.25cm)

    // Log-likelihood
    #box(stroke: 1.5pt + blu, radius: 8pt, fill: blu.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: blu)[Passaggio ai logaritmi]

      #v(0.15cm)

      #text(size: 10.5pt)[
        Il logaritmo trasforma il prodotto in somma:
      ]

      #v(0.1cm)

      #align(center)[
        $ ln cal(L) = underbrace(-frac(N, 2) ln(2 pi sigma^2), "costante") - frac(1, 2 sigma^2) sum_(i=1)^N (y_i - m x_i - q)^2 $
      ]
    ]

    #v(0.25cm)

    // Conclusione
    #box(stroke: 1.5pt + viola, radius: 8pt, fill: viola.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: viola)[Conclusione]

      #v(0.1cm)

      #align(center)[
        #text(size: 10.5pt)[
          Massimizzare $ln cal(L)$ #h(0.3cm) $arrow.l.r$ #h(0.3cm) *Minimizzare* #h(0.2cm)
          #box(stroke: 1.5pt + viola, radius: 4pt, fill: viola.lighten(88%), inset: 6pt)[
            $ sum_(i=1)^N (y_i - m x_i - q)^2 = L(m, q) $
          ]
        ]
      ]

      #v(0.1cm)

      #align(center)[
        #text(size: 10.5pt, weight: "bold", fill: rosso)[Stesso risultato del metodo analitico!]
      ]
    ]
  ],
  [
    // === SCATTER PLOT con gaussiane ===
    #cetz.canvas(length: 0.55cm, {
      import cetz.draw: *

      let dati = ((1, 4.0), (2, 5.0), (3, 4.5), (4, 6.0), (5, 7.5))
      let m = 0.8
      let q = 3.0
      let sig = 0.6
      let amp = 1.0

      // Griglia
      for x in range(1, 8) {
        line((x, 0), (x, 9), stroke: 0.3pt + luma(225))
      }
      for y in range(1, 10) {
        line((0, y), (7.5, y), stroke: 0.3pt + luma(225))
      }

      // Assi
      line((-0.1, 0), (7.5, 0), stroke: 1.2pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.4))
      line((0, -0.1), (0, 9.5), stroke: 1.2pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.4))

      content((7.5, -0.7), text(size: 7pt)[$x$])
      content((-0.6, 9.5), text(size: 7pt)[$y$])

      // Tacche
      for x in range(1, 8) {
        line((x, -0.1), (x, 0.1), stroke: 0.6pt + luma(80))
        content((x, -0.45), text(size: 6pt)[#x])
      }
      for y in (3, 4, 5, 6, 7, 8) {
        line((-0.1, y), (0.1, y), stroke: 0.6pt + luma(80))
        content((-0.45, y), text(size: 6pt)[#y])
      }

      // Retta
      line((0, q), (6.5, m * 6.5 + q), stroke: 2pt + blu)

      // Gaussiane ad ogni punto
      for (xi, yi) in dati {
        let y-hat = m * xi + q
        let n-pts = 40

        let pts = range(n-pts + 1).map(j => {
          let t = -2.5 + 5.0 * j / n-pts
          let y-val = y-hat + sig * t
          let x-val = xi + amp * calc.exp(-t * t / 2.0)
          (x-val, y-val)
        })

        // Area riempita
        let fill-pts = ((xi, y-hat - 2.5 * sig),) + pts + ((xi, y-hat + 2.5 * sig),)
        line(..fill-pts, close: true, fill: viola.lighten(90%), stroke: none)

        // Curva gaussiana
        line(..pts, stroke: 1pt + viola)

        // Linea base verticale
        line((xi, y-hat - 2.5 * sig), (xi, y-hat + 2.5 * sig),
          stroke: 0.4pt + viola.lighten(40%))

        // Linea orizzontale dal punto alla curva (densità osservata)
        let gauss-val = amp * calc.exp(-(yi - y-hat) * (yi - y-hat) / (2.0 * sig * sig))
        line((xi, yi), (xi + gauss-val, yi),
          stroke: (dash: "dotted", paint: arancio, thickness: 1pt))
      }

      // Punti dati
      for (x, y) in dati {
        circle((x, y), radius: 0.1, fill: verde, stroke: 1pt + verde.darken(20%))
      }

      // Label retta
      content((5, 8.5), anchor: "west",
        text(size: 7pt, fill: blu)[$y = 0.8x + 3$])

      // Label gaussiana
      content((3.5, 1.5),
        text(size: 6pt, fill: viola)[$cal(N)(m x_i + q, sigma^2)$])
    })
  ]
)
