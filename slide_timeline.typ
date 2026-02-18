#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "it")

#import "@preview/cetz:0.3.2"

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")
#let grigio = rgb("#7f8c8d")

#align(center)[
  #text(size: 20pt, weight: "bold")[La Storia dell'AI — Momenti Chiave]
]

#v(0.5cm)

#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  let sp = 1.3  // spaziatura verticale tra le voci

  // Dati timeline: (y, anno, descrizione, colore)
  let data = (
    (0,        "1950",     "Turing pubblica \"Computing Machinery and Intelligence\"",            verde),
    (-sp,      "1956",     "Conferenza di Dartmouth — nasce il termine \"AI\"",                   verde),
    (-2*sp,    "1965",     "Legge di Moore: il numero di transistor raddoppia ogni ~2 anni",      blu),
    (-3.2*sp,  "1974–93",  "Inverni dell'AI — promesse eccessive, hardware inadeguato",           grigio),
    (-4.4*sp,  "2012",     "AlexNet vince ImageNet — rivoluzione Deep Learning",                  viola),
    (-5.4*sp,  "2016",     "AlphaGo (DeepMind) batte il campione mondiale di Go",                viola),
    (-6.6*sp,  "Nov 2022", "Lancio di ChatGPT — 100 milioni di utenti in 2 mesi",               rosso),
    (-7.6*sp,  "Mag 2023", "Hinton lascia Google per avvertire sui rischi dell'AI",              rosso),
    (-8.6*sp,  "Ott 2024", "Nobel per la Fisica a Geoffrey Hinton e John Hopfield",             rosso),
  )

  let y-top = 0.5
  let y-bot = -8.6 * sp - 0.5

  // Linea verticale della timeline
  line((0, y-top), (0, y-bot), stroke: 2pt + luma(210))

  // Sfondo inverno AI
  rect((-2.8, -2.7 * sp), (17, -3.7 * sp), fill: luma(242), stroke: none)

  // Voci della timeline
  for (y, anno, desc, color) in data {
    // Punto colorato sulla linea
    circle((0, y), radius: 0.18, fill: color, stroke: 1.5pt + color)
    // Anno (a sinistra)
    content((-0.4, y), anchor: "east",
      text(weight: "bold", fill: color, size: 11pt)[#anno])
    // Descrizione (a destra)
    content((0.5, y), anchor: "west",
      text(size: 10.5pt)[#desc])
  }
})
