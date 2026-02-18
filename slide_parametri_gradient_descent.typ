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
  #text(size: 14pt, fill: luma(80))[Metodo 4 — Discesa del Gradiente]
]

#v(0.3cm)

#grid(
  columns: (12cm, auto),
  gutter: 1cm,
  [
    #box(stroke: 1.5pt + arancio, radius: 8pt, fill: arancio.lighten(93%), inset: 12pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: arancio.darken(10%))[L'idea — Scendere nella valle]
      #v(0.15cm)
      #text(size: 10.5pt)[
        Invece di risolvere equazioni, partiamo da valori qualsiasi di $m$ e $q$ e li miglioriamo *passo dopo passo*, scendendo lungo la superficie della Loss:
      ]
      #v(0.1cm)
      #align(center)[
        $ L(m, q) = sum_(i=1)^N (y_i - m x_i - q)^2 $
      ]
    ]

    #v(0.3cm)

    #box(stroke: 1.5pt + blu, radius: 8pt, fill: blu.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: blu)[Il gradiente indica la direzione di salita]
      #v(0.15cm)
      #align(center)[
        $ frac(partial L, partial m) = -2 sum_(i=1)^N x_i (y_i - m x_i - q) $
      ]
      #v(0.05cm)
      #align(center)[
        $ frac(partial L, partial q) = -2 sum_(i=1)^N (y_i - m x_i - q) $
      ]
      #v(0.1cm)
      #text(size: 10.5pt)[
        Il gradiente punta in salita $arrow$ noi camminiamo in *direzione opposta*.
      ]
    ]

    #v(0.3cm)

    #box(stroke: 1.5pt + viola, radius: 8pt, fill: viola.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: viola)[Regola di aggiornamento]
      #v(0.15cm)
      #align(center)[
        #box(stroke: 1pt + viola, radius: 4pt, fill: viola.lighten(88%), inset: 8pt)[
          $ m arrow.l m - alpha frac(partial L, partial m) $
        ]
        #h(1cm)
        #box(stroke: 1pt + viola, radius: 4pt, fill: viola.lighten(88%), inset: 8pt)[
          $ q arrow.l q - alpha frac(partial L, partial q) $
        ]
      ]
      #v(0.1cm)
      #align(center)[
        #text(size: 10pt, fill: viola.darken(20%))[
          $alpha$ = *learning rate* (dimensione del passo) — Ripetere fino a convergenza
        ]
      ]
    ]
  ],
  [
    // === CONTOUR PLOT con percorso gradient descent ===
    #cetz.canvas(length: 0.75cm, {
      import cetz.draw: *

      let cx = 4.8
      let cy = 4.8
      let theta = -0.26  // ~-15° in radianti
      let cos-th = calc.cos(theta)
      let sin-th = calc.sin(theta)

      // Griglia
      for x in range(1, 9) {
        line((x, 0), (x, 9), stroke: 0.3pt + luma(235))
      }
      for y in range(1, 10) {
        line((0, y), (8.5, y), stroke: 0.3pt + luma(235))
      }

      // Assi
      line((-0.1, 0), (8.5, 0), stroke: 1.2pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.4))
      line((0, -0.1), (0, 9.5), stroke: 1.2pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.4))

      content((8.5, -0.7), text(size: 9pt)[$m$])
      content((-0.6, 9.5), text(size: 9pt)[$q$])

      // Ellissi di livello (dal più esterno al più interno)
      let levels = (3.5, 2.7, 2.0, 1.3, 0.6)
      let n-pts = 60

      for (idx, level) in levels.enumerate() {
        let a = level * 1.15   // semiasse maggiore
        let b = level * 0.55   // semiasse minore
        let lightness = 90 - idx * 5

        let pts = range(n-pts + 1).map(i => {
          let t = 2.0 * calc.pi * i / n-pts
          let lx = a * calc.cos(t)
          let ly = b * calc.sin(t)
          let rx = lx * cos-th - ly * sin-th
          let ry = lx * sin-th + ly * cos-th
          (cx + rx, cy + ry)
        })

        line(..pts, close: true,
          stroke: 0.8pt + blu.lighten(30%),
          fill: blu.lighten(lightness * 1%))
      }

      // Percorso gradient descent
      let gd-pts = (
        (1.0, 7.8),
        (2.0, 6.2),
        (2.8, 5.6),
        (3.4, 5.3),
        (3.8, 5.1),
        (4.2, 4.95),
        (4.5, 4.85),
        (4.7, 4.82),
      )

      // Frecce del percorso
      for i in range(gd-pts.len() - 1) {
        let p1 = gd-pts.at(i)
        let p2 = gd-pts.at(i + 1)
        line(p1, p2, stroke: 2pt + rosso,
          mark: (end: "stealth", fill: rosso, scale: 0.3))
      }

      // Punto di partenza
      let start = gd-pts.at(0)
      circle(start, radius: 0.18, fill: rosso, stroke: 1.2pt + rosso.darken(20%))
      content((start.at(0) + 0.7, start.at(1) + 0.3),
        text(size: 7pt, fill: rosso, weight: "bold")[Partenza])

      // Punto minimo
      circle((cx, cy), radius: 0.15, fill: verde, stroke: 1.2pt + verde.darken(20%))
      content((cx + 0.5, cy - 0.5),
        text(size: 8pt, fill: verde, weight: "bold")[Minimo])

      // Etichetta curve
      content((7.0, 1.8), anchor: "center",
        text(size: 7pt, fill: blu)[Curve di livello\ di $L(m, q)$])
    })
  ]
)
