#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "it")

#import "@preview/cetz:0.3.2"

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")
#let arancio = rgb("#e67e22")

#align(center)[
  #text(size: 20pt, weight: "bold")[L'Analogia delle Molle — Equilibrio]
]

#v(0.3cm)

#grid(
  columns: (auto, 13cm),
  gutter: 1cm,
  [
    // === Due grafici ===
    #grid(
      columns: (auto, auto),
      gutter: 0.6cm,
      [
        #align(center)[
          #text(size: 10pt, fill: rosso, weight: "bold")[Retta sbagliata: molle tese]
        ]
        #v(0.1cm)
        #cetz.canvas(length: 0.45cm, {
          import cetz.draw: *

          let dati = ((1, 4.0), (2, 5.0), (3, 4.5), (4, 6.0), (5, 7.5))
          let m-bad = 0.3
          let q-bad = 5.0

          for x in range(1, 7) { line((x, 0), (x, 9), stroke: 0.3pt + luma(225)) }
          for y in range(1, 10) { line((0, y), (6.5, y), stroke: 0.3pt + luma(225)) }

          line((-0.1, 0), (6.5, 0), stroke: 1pt + luma(80),
            mark: (end: "stealth", fill: luma(80), scale: 0.3))
          line((0, -0.1), (0, 9.5), stroke: 1pt + luma(80),
            mark: (end: "stealth", fill: luma(80), scale: 0.3))

          for x in range(1, 7) {
            line((x, -0.1), (x, 0.1), stroke: 0.5pt + luma(80))
            content((x, -0.45), text(size: 5pt)[#x])
          }
          for y in (3, 4, 5, 6, 7, 8) {
            line((-0.1, y), (0.1, y), stroke: 0.5pt + luma(80))
            content((-0.45, y), text(size: 5pt)[#y])
          }

          line((0, q-bad), (6, m-bad * 6 + q-bad), stroke: 2pt + luma(160))

          for (xi, yi) in dati {
            let y-hat = m-bad * xi + q-bad
            let dy = yi - y-hat
            let abs-dy = calc.abs(dy)
            if abs-dy > 0.05 {
              let n-zigs = 6
              let amp = 0.15
              let margin = abs-dy * 0.1
              let sign-dy = if dy > 0 { 1 } else { -1 }
              let y-zig-start = y-hat + sign-dy * margin
              let y-zig-end = yi - sign-dy * margin
              let zig-dy = y-zig-end - y-zig-start

              let pts = ((xi, y-hat), (xi, y-zig-start))
              for i in range(n-zigs) {
                let t = (i + 0.5) / n-zigs
                let y-pt = y-zig-start + zig-dy * t
                let side = if calc.rem(i, 2) == 0 { amp } else { -amp }
                pts.push((xi + side, y-pt))
              }
              pts.push((xi, y-zig-end))
              pts.push((xi, yi))
              line(..pts, stroke: 1.5pt + rosso)
            }
          }

          for (x, y) in dati {
            circle((x, y), radius: 0.1, fill: verde, stroke: 0.8pt + verde.darken(20%))
          }

          content((3.5, 8.5), anchor: "west",
            text(size: 6pt, fill: rosso, weight: "bold")[$E_"tot"$ grande])
        })
      ],
      [
        #align(center)[
          #text(size: 10pt, fill: verde, weight: "bold")[Retta ottimale: equilibrio]
        ]
        #v(0.1cm)
        #cetz.canvas(length: 0.45cm, {
          import cetz.draw: *

          let dati = ((1, 4.0), (2, 5.0), (3, 4.5), (4, 6.0), (5, 7.5))
          let m = 0.8
          let q = 3.0

          for x in range(1, 7) { line((x, 0), (x, 9), stroke: 0.3pt + luma(225)) }
          for y in range(1, 10) { line((0, y), (6.5, y), stroke: 0.3pt + luma(225)) }

          line((-0.1, 0), (6.5, 0), stroke: 1pt + luma(80),
            mark: (end: "stealth", fill: luma(80), scale: 0.3))
          line((0, -0.1), (0, 9.5), stroke: 1pt + luma(80),
            mark: (end: "stealth", fill: luma(80), scale: 0.3))

          for x in range(1, 7) {
            line((x, -0.1), (x, 0.1), stroke: 0.5pt + luma(80))
            content((x, -0.45), text(size: 5pt)[#x])
          }
          for y in (3, 4, 5, 6, 7, 8) {
            line((-0.1, y), (0.1, y), stroke: 0.5pt + luma(80))
            content((-0.45, y), text(size: 5pt)[#y])
          }

          line((0, q), (6, m * 6 + q), stroke: 2pt + blu)

          for (xi, yi) in dati {
            let y-hat = m * xi + q
            let dy = yi - y-hat
            let abs-dy = calc.abs(dy)
            if abs-dy > 0.05 {
              let n-zigs = 6
              let amp = 0.15
              let margin = abs-dy * 0.1
              let sign-dy = if dy > 0 { 1 } else { -1 }
              let y-zig-start = y-hat + sign-dy * margin
              let y-zig-end = yi - sign-dy * margin
              let zig-dy = y-zig-end - y-zig-start

              let pts = ((xi, y-hat), (xi, y-zig-start))
              for i in range(n-zigs) {
                let t = (i + 0.5) / n-zigs
                let y-pt = y-zig-start + zig-dy * t
                let side = if calc.rem(i, 2) == 0 { amp } else { -amp }
                pts.push((xi + side, y-pt))
              }
              pts.push((xi, y-zig-end))
              pts.push((xi, yi))
              line(..pts, stroke: 1.2pt + verde.darken(10%))
            }
          }

          for (x, y) in dati {
            circle((x, y), radius: 0.1, fill: verde, stroke: 0.8pt + verde.darken(20%))
          }

          content((3.5, 8.5), anchor: "west",
            text(size: 6pt, fill: verde, weight: "bold")[$E_"tot"$ minima])
        })
      ]
    )
  ],
  [
    // === Condizioni di equilibrio e soluzione ===

    #box(stroke: 1.5pt + blu, radius: 8pt, fill: blu.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: blu)[Condizioni di equilibrio]

      #v(0.15cm)

      #text(size: 10.5pt)[
        La retta si ferma quando la *forza netta* è nulla in entrambe le direzioni:
      ]

      #v(0.2cm)

      #text(size: 10.5pt)[*Traslazione* (regola $q$): la somma delle forze si annulla]
      #v(0.1cm)
      #align(center)[
        $ sum_(i=1)^N (y_i - m x_i - q) = 0 $
      ]

      #v(0.2cm)

      #text(size: 10.5pt)[*Rotazione* (regola $m$): la somma dei momenti si annulla]
      #v(0.1cm)
      #align(center)[
        $ sum_(i=1)^N x_i (y_i - m x_i - q) = 0 $
      ]
    ]

    #v(0.3cm)

    #box(stroke: 1.5pt + viola, radius: 8pt, fill: viola.lighten(95%), inset: 12pt, width: 100%)[
      #text(size: 11pt, weight: "bold", fill: viola)[Soluzione]

      #v(0.15cm)

      #align(center)[
        #box(stroke: 1pt + viola, radius: 4pt, fill: viola.lighten(88%), inset: 8pt)[
          $ m = frac(sum_(i=1)^(N) (x_i - overline(x))(y_i - overline(y)), sum_(i=1)^(N) (x_i - overline(x))^2) $
        ]
        #h(1cm)
        #box(stroke: 1pt + viola, radius: 4pt, fill: viola.lighten(88%), inset: 8pt)[
          $ q = overline(y) - m overline(x) $
        ]
      ]

      #v(0.15cm)

      #align(center)[
        #text(size: 10.5pt, weight: "bold", fill: rosso)[Stesse formule dei metodi 1 e 2!]
      ]
    ]
  ]
)
