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
  #text(size: 14pt, fill: luma(80))[Metodo 3 — L'Analogia delle Molle]
]

#v(0.3cm)

#grid(
  columns: (12cm, auto),
  gutter: 1cm,
  [
    #box(stroke: 1.5pt + rosso, radius: 8pt, fill: rosso.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: rosso)[L'esperimento mentale]

      #v(0.15cm)

      #text(size: 10.5pt)[
        Immaginiamo di collegare ogni punto alla retta con una *molla verticale*.

        La retta è libera di ruotare (cambiando $m$) e traslare (cambiando $q$).
      ]

      #v(0.15cm)

      #text(size: 10.5pt)[
        Dove si ferma? Nella posizione di *equilibrio*, dove l'energia totale è minima.
      ]
    ]

    #v(0.3cm)

    #box(stroke: 1.5pt + blu, radius: 8pt, fill: blu.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: blu)[La fisica: legge di Hooke]

      #v(0.15cm)

      #text(size: 10.5pt)[
        Ogni molla accumula *energia potenziale elastica* proporzionale al quadrato dell'allungamento:
      ]

      #v(0.15cm)

      #align(center)[
        #text(size: 13pt)[
          $ E_i = frac(1, 2) k (Delta y_i)^2 = frac(1, 2) k (y_i - m x_i - q)^2 $
        ]
      ]

      #v(0.15cm)

      #text(size: 10.5pt)[
        Il *quadrato* non è una scelta arbitraria: viene dalla fisica!
      ]
    ]

    #v(0.3cm)

    #box(stroke: 1.5pt + viola, radius: 8pt, fill: viola.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: viola)[Energia totale = Loss]

      #v(0.15cm)

      #align(center)[
        $ E_"tot" = frac(1, 2) k sum_(i=1)^N (y_i - m x_i - q)^2 #h(0.5cm) prop #h(0.5cm) L(m, q) $
      ]

      #v(0.1cm)

      #align(center)[
        #text(size: 10.5pt, weight: "bold", fill: viola)[
          Minima energia $arrow.l.r$ Minimi quadrati
        ]
      ]
    ]
  ],
  [
    // === SCATTER PLOT con molle ===
    #cetz.canvas(length: 0.75cm, {
      import cetz.draw: *

      let dati = ((1, 4.0), (2, 5.0), (3, 4.5), (4, 6.0), (5, 7.5))
      let m = 0.8
      let q = 3.0

      // Griglia
      for x in range(1, 7) {
        line((x, 0), (x, 9), stroke: 0.3pt + luma(225))
      }
      for y in range(1, 10) {
        line((0, y), (6.5, y), stroke: 0.3pt + luma(225))
      }

      // Assi
      line((-0.1, 0), (6.5, 0), stroke: 1.2pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.4))
      line((0, -0.1), (0, 9.5), stroke: 1.2pt + luma(80),
        mark: (end: "stealth", fill: luma(80), scale: 0.4))

      content((6.5, -0.7), text(size: 8pt)[$x$])
      content((-0.6, 9.5), text(size: 8pt)[$y$])

      for x in range(1, 7) {
        line((x, -0.1), (x, 0.1), stroke: 0.6pt + luma(80))
        content((x, -0.45), text(size: 7pt)[#x])
      }
      for y in (3, 4, 5, 6, 7, 8) {
        line((-0.1, y), (0.1, y), stroke: 0.6pt + luma(80))
        content((-0.45, y), text(size: 7pt)[#y])
      }

      // Retta
      line((0, q), (6, m * 6 + q), stroke: 2.5pt + blu)

      // Molle (zigzag) da ogni punto alla retta
      for (xi, yi) in dati {
        let y-hat = m * xi + q
        let dy = yi - y-hat
        let abs-dy = calc.abs(dy)

        if abs-dy > 0.05 {
          let n-zigs = 8
          let amp = 0.18
          let margin-frac = 0.08
          let y-start = y-hat
          let y-end = yi
          let margin = abs-dy * margin-frac
          let y-zig-start = y-start + (y-end - y-start) / abs-dy * margin
          let y-zig-end = y-end - (y-end - y-start) / abs-dy * margin
          let zig-dy = y-zig-end - y-zig-start

          // Start straight
          let pts = ((xi, y-start), (xi, y-zig-start))

          // Zigzag
          for i in range(n-zigs) {
            let t = (i + 0.5) / n-zigs
            let y-pt = y-zig-start + zig-dy * t
            let side = if calc.rem(i, 2) == 0 { amp } else { -amp }
            pts.push((xi + side, y-pt))
          }

          // End straight
          pts.push((xi, y-zig-end))
          pts.push((xi, y-end))

          line(..pts, stroke: 1.8pt + rosso)
        }
      }

      // Etichette energia
      for (i, (xi, yi)) in dati.enumerate() {
        let y-hat = m * xi + q
        let dy = yi - y-hat
        if calc.abs(dy) > 0.05 {
          let side = if dy > 0 { 0.4 } else { -0.4 }
          content((xi + 0.45, (yi + y-hat) / 2),
            text(size: 6pt, fill: rosso)[$E_#(i+1)$])
        }
      }

      // Punti dati
      for (x, y) in dati {
        circle((x, y), radius: 0.12, fill: verde, stroke: 1pt + verde.darken(20%))
      }

      // Punti sulla retta (ancoraggio molle)
      for (xi, yi) in dati {
        let y-hat = m * xi + q
        circle((xi, y-hat), radius: 0.06, fill: blu, stroke: 0.8pt + blu.darken(20%))
      }

      // Label
      content((4.5, 8.5), anchor: "west",
        text(size: 8pt, fill: blu)[$y = 0.8x + 3$])
    })
  ]
)
