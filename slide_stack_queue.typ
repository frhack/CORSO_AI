#set page(width: 25.4cm, height: 14.29cm, margin: (x: 1cm, y: 0.8cm))
#set text(font: "New Computer Modern", size: 10.5pt, lang: "it")

#import "@preview/cetz:0.3.2"

#let blu = rgb("#3498db")
#let verde = rgb("#27ae60")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")
#let arancio = rgb("#e67e22")
#let grigio = rgb("#7f8c8d")
#let scuro = rgb("#2c3e50")

#align(center)[
  #text(size: 18pt, weight: "bold")[Strutture Dati: Stack e Queue]
  #v(0.05cm)
  #text(size: 11pt, fill: grigio)[Due modi fondamentali di organizzare i dati]
]

#v(0.3cm)

#grid(
  columns: (1fr, 1fr),
  gutter: 1cm,

  // === QUEUE ===
  [
    #align(center)[
      #text(size: 14pt, weight: "bold", fill: blu)[Queue (Coda)]
      #v(0.05cm)
      #text(size: 10pt, fill: grigio)[FIFO — First In, First Out]
    ]

    #v(0.2cm)

    #align(center)[
      #cetz.canvas(length: 0.9cm, {
        import cetz.draw: *

        let elementi = ("A", "B", "C", "D", "E")
        let w = 1.2
        let h = 0.8

        // Elementi nella coda
        for (i, el) in elementi.enumerate() {
          let x = i * w
          rect((x, 0), (x + w, h), stroke: 1.5pt + blu, fill: blu.lighten(85%), radius: 3pt)
          content((x + w/2, h/2), text(size: 12pt, weight: "bold")[#el])
        }

        // Freccia uscita a sinistra
        line((-0.3, h/2), (-1.0, h/2), stroke: 2pt + verde, mark: (end: ">", fill: verde))
        content((-0.65, h/2 + 0.45), text(size: 8pt, weight: "bold", fill: verde)[ESCE])

        // Freccia entrata a destra
        let rx = elementi.len() * w
        line((rx + 1.0, h/2), (rx + 0.3, h/2), stroke: 2pt + rosso, mark: (end: ">", fill: rosso))
        content((rx + 0.65, h/2 + 0.45), text(size: 8pt, weight: "bold", fill: rosso)[ENTRA])

        // Nuovo elemento F che entra
        rect((rx + 1.1, 0), (rx + 1.1 + w, h), stroke: 1.5pt + rosso, fill: rosso.lighten(85%), radius: 3pt)
        content((rx + 1.1 + w/2, h/2), text(size: 12pt, weight: "bold", fill: rosso)[F])
      })
    ]

    #v(0.3cm)

    #box(stroke: 1.5pt + blu, radius: 6pt, fill: blu.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 10pt)[
        Come una *fila al supermercato*: il primo che arriva è il primo ad essere servito. Si aggiunge *in fondo* e si toglie *dalla testa*.
      ]
    ]
  ],

  // === STACK ===
  [
    #align(center)[
      #text(size: 14pt, weight: "bold", fill: viola)[Stack (Pila)]
      #v(0.05cm)
      #text(size: 10pt, fill: grigio)[LIFO — Last In, First Out]
    ]

    #v(0.2cm)

    #align(center)[
      #cetz.canvas(length: 0.9cm, {
        import cetz.draw: *

        let elementi = ("A", "B", "C", "D", "E")
        let w = 1.4
        let h = 0.7

        // Elementi impilati
        for (i, el) in elementi.enumerate() {
          let y = i * h
          rect((0, y), (w, y + h), stroke: 1.5pt + viola, fill: viola.lighten(85%), radius: 3pt)
          content((w/2, y + h/2), text(size: 12pt, weight: "bold")[#el])
        }

        // Nuovo elemento F che entra in cima
        let top-y = elementi.len() * h
        rect((0, top-y + 0.3), (w, top-y + 0.3 + h), stroke: 1.5pt + rosso, fill: rosso.lighten(85%), radius: 3pt)
        content((w/2, top-y + 0.3 + h/2), text(size: 12pt, weight: "bold", fill: rosso)[F])

        // Freccia entrata dall'alto
        line((w/2, top-y + 0.3 + h + 0.8), (w/2, top-y + 0.3 + h + 0.15), stroke: 2pt + rosso, mark: (end: ">", fill: rosso))
        content((w/2 + 1.0, top-y + 0.3 + h + 0.5), text(size: 8pt, weight: "bold", fill: rosso)[ENTRA])

        // Freccia uscita dall'alto
        line((w + 0.5, top-y + 0.3 + h/2), (w + 1.3, top-y + 0.3 + h/2), stroke: 2pt + verde, mark: (end: ">", fill: verde))
        content((w + 0.9, top-y + 0.3 + h/2 + 0.4), text(size: 8pt, weight: "bold", fill: verde)[ESCE])
      })
    ]

    #v(0.3cm)

    #box(stroke: 1.5pt + viola, radius: 6pt, fill: viola.lighten(95%), inset: 10pt, width: 100%)[
      #text(size: 10pt)[
        Come una *pila di piatti*: l'ultimo piatto appoggiato è il primo che togli. Si aggiunge e si toglie sempre *dalla cima*.
      ]
    ]
  ],
)
