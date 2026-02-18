#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "it")

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")

#align(center)[
  #text(size: 20pt, weight: "bold")[Il Momento ChatGPT e l'Allarme di Hinton]
]

#v(0.5cm)

#grid(
  columns: (11.5cm, 11.5cm),
  gutter: 1cm,
  [
    #box(stroke: 1.5pt + verde, radius: 8pt, fill: verde.lighten(95%), inset: 15pt, width: 100%)[
      #text(size: 13pt, weight: "bold", fill: verde)[Il fenomeno ChatGPT]

      #v(0.3cm)

      #text(size: 11pt)[
        *30 Novembre 2022*: OpenAI lancia ChatGPT.

        #v(0.2cm)

        - *1 milione* di utenti in 5 giorni
        - *100 milioni* di utenti in 2 mesi
        - L'app con la crescita più rapida della storia

        #v(0.2cm)

        L'AI generativa entra nella vita quotidiana.

        #v(0.2cm)

        *2023*: esplosione di modelli — GPT-4, Claude, Gemini, LLaMA, Midjourney...
      ]
    ]
  ],
  [
    #box(stroke: 1.5pt + rosso, radius: 8pt, fill: rosso.lighten(95%), inset: 15pt, width: 100%)[
      #text(size: 13pt, weight: "bold", fill: rosso)[L'allarme di Hinton]

      #v(0.3cm)

      #text(size: 11pt)[
        *Maggio 2023*: Hinton si dimette da Google dopo 10 anni.

        #v(0.2cm)

        #box(stroke: 1pt + luma(200), radius: 5pt, fill: luma(250), inset: 10pt, width: 100%)[
          _"Voglio poter parlare dei pericoli dell'AI senza preoccuparmi dell'impatto su Google."_
        ]

        #v(0.2cm)

        Le sue preoccupazioni:
        - Disinformazione su larga scala
        - Perdita massiccia di posti di lavoro
        - Rischi esistenziali a lungo termine

        #v(0.2cm)

        *Il paradosso*: il padre del Deep Learning è diventato il suo più autorevole critico.
      ]
    ]
  ],
)

#v(0.5cm)

#align(center)[
  #box(stroke: 1pt + gray, radius: 5pt, fill: luma(250), inset: 12pt)[
    #text(size: 12pt)[
      Siamo in un momento di svolta storica: l'AI non è più futuro, ma presente quotidiano.
    ]
  ]
]
