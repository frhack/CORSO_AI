#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "it")

#import "@preview/cetz:0.3.2"

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")

#align(center)[
  #text(size: 20pt, weight: "bold")[Perché la Media?]
]

#v(0.3cm)

#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  // Parametri di layout (schema, non in scala)
  // y=0: pavimento, y=5: altezza occhi (175 cm), y=9: centro quadro (231 cm)
  let mu = 5
  let paint-cy = 9
  let sigma = 1.0
  let amp = 6
  let wall-x = 5
  let gauss-axis = 16

  // === PARETE ===
  rect((0, -0.3), (wall-x, 11.5), fill: luma(245), stroke: none)
  line((0, 0), (wall-x + 0.5, 0), stroke: 1.5pt + luma(150))

  // Gioconda sulla parete
  content((2.5, paint-cy), image("gioconda.jpg", height: 5cm))

  // === LINEE DI RIFERIMENTO ===
  // Livello occhi (tratteggiata viola, tutta la larghezza)
  line((-0.5, mu), (gauss-axis, mu),
    stroke: (dash: "dotted", paint: viola.lighten(30%), thickness: 0.7pt))

  // Centro quadro (tratteggiata blu, solo lato parete)
  line((-0.5, paint-cy), (wall-x + 0.3, paint-cy),
    stroke: (dash: "dotted", paint: blu.lighten(30%), thickness: 0.7pt))

  // === ETICHETTE ALTEZZE (margine sinistro) ===
  content((-1.8, mu), anchor: "east",
    text(size: 10pt, weight: "bold", fill: viola)[175 cm])
  content((-1.8, mu - 0.55), anchor: "east",
    text(size: 8pt, fill: luma(100))[altezza occhi])

  content((-1.8, paint-cy), anchor: "east",
    text(size: 10pt, weight: "bold", fill: blu)[231 cm])
  content((-1.8, paint-cy - 0.55), anchor: "east",
    text(size: 8pt, fill: luma(100))[centro quadro])

  // === QUOTA +56 cm ===
  line((wall-x + 0.5, mu), (wall-x + 0.5, paint-cy),
    stroke: 1.5pt + blu,
    mark: (start: "stealth", end: "stealth", fill: blu, scale: 0.5))
  content((wall-x + 1.4, (mu + paint-cy) / 2),
    text(size: 10pt, fill: blu, weight: "bold")[+56 cm])

  // === GAUSSIANA (ruotata 90°, apre verso sinistra) ===
  let n = 60
  let pts = range(n + 1).map(i => {
    let t = -3.0 + 6.0 * i / n
    let y = mu + sigma * t
    let x = gauss-axis - amp * calc.exp(-t * t / 2.0)
    (x, y)
  })

  // Area riempita
  let fill-pts = ((gauss-axis, mu - 3 * sigma),) + pts + ((gauss-axis, mu + 3 * sigma),)
  line(..fill-pts, close: true, fill: viola.lighten(90%), stroke: none)

  // Curva
  line(..pts, stroke: 2pt + viola)

  // Asse verticale della gaussiana
  line((gauss-axis, mu - 3.5 * sigma), (gauss-axis, mu + 3.5 * sigma),
    stroke: 1pt + luma(150))

  // Tacche altezza sull'asse
  for (label, y) in (("150", mu - 2.5), ("175", mu), ("200", mu + 2.5)) {
    line((gauss-axis - 0.15, y), (gauss-axis + 0.15, y), stroke: 0.8pt + luma(150))
    content((gauss-axis + 0.6, y), anchor: "west",
      text(size: 8pt, fill: luma(100))[#label])
  }
  content((gauss-axis + 0.6, mu + 3.8 * sigma), anchor: "west",
    text(size: 8pt, fill: luma(100))[cm])

  // Etichetta "N. visitatori"
  content((gauss-axis - amp / 2, mu - 3.5 * sigma - 0.7),
    text(size: 9pt, fill: viola)[← N. visitatori])

  // Punto al picco
  circle((gauss-axis - amp, mu), radius: 0.15, fill: rosso, stroke: 1.5pt + rosso)

  // === RETTA DI VISUALE IDEALE ===
  line((gauss-axis - amp, mu), (wall-x, paint-cy),
    stroke: (dash: "dashed", paint: rosso, thickness: 2pt),
    mark: (end: "stealth", fill: rosso, scale: 0.7))

  content(((gauss-axis - amp + wall-x) / 2 - 0.3, (mu + paint-cy) / 2 + 0.8),
    anchor: "east",
    text(size: 9pt, fill: rosso, weight: "bold")[visuale ideale])
})

#v(0.3cm)

#align(center)[
  #box(stroke: 1pt + gray, radius: 5pt, fill: luma(250), inset: 10pt)[
    #text(size: 11pt)[
      La media ($m = 175$ cm) è il valore con la *massima frequenza* di visitatori: il miglior compromesso per posizionare il quadro.
    ]
  ]
]
