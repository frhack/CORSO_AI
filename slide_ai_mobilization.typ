#set page(width: 25.4cm, height: 14.29cm, margin: (x: 1cm, y: 0.8cm))
#set text(font: "New Computer Modern", size: 10.5pt, lang: "it")

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")
#let arancio = rgb("#e67e22")
#let grigio = rgb("#7f8c8d")
#let scuro = rgb("#2c3e50")

#align(center)[
  #text(size: 17pt, weight: "bold")[La Grande Mobilitazione dell'AI]
  #v(0.05cm)
  #text(size: 8.5pt, fill: grigio)[Fonte: Suro Capital — _"AI: The Great Mobilization"_, 2025 · surocap.com]
]

#v(0.15cm)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 0.4cm,

  // --- Colonna 1: investimenti ---
  [
    #box(stroke: 1.5pt + blu, radius: 5pt, fill: blu.lighten(93%), inset: 8pt, width: 100%)[
      #align(center)[
        #text(size: 9pt, weight: "bold", fill: blu)[INVESTIMENTI IN DATA CENTER]
        #v(0.1cm)
        #text(size: 28pt, weight: "bold", fill: scuro)[\$7T]
        #v(0.05cm)
        #text(size: 9pt)[previsti entro il *2032* per infrastruttura AI globale]
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1pt + viola, radius: 4pt, fill: viola.lighten(93%), inset: 7pt, width: 100%)[
      #text(size: 9pt, weight: "bold", fill: viola)[Confronto storico (aggiustati per inflazione):]
      #v(0.05cm)
      #text(size: 8.5pt)[
        #table(
          columns: (1fr, auto),
          inset: 3pt,
          align: (left, right),
          stroke: none,
          [Spesa USA nella WWII], [*\$4.1T*],
          [Piano Marshall], [*\$1.3T*],
          [New Deal], [*\$1.0T*],
          [Interstate Highway], [*\$500B*],
          [Programma Apollo], [*\$280B*],
          [Progetto Manhattan], [*\$28B*],
        )
      ]
    ]
  ],

  // --- Colonna 2: impatto ---
  [
    #box(stroke: 1.5pt + verde, radius: 5pt, fill: verde.lighten(93%), inset: 8pt, width: 100%)[
      #align(center)[
        #text(size: 9pt, weight: "bold", fill: verde)[IMPATTO SUL PIL GLOBALE]
        #v(0.1cm)
        #text(size: 28pt, weight: "bold", fill: scuro)[+15%]
        #v(0.05cm)
        #text(size: 9pt)[potenziale boost alla crescita del PIL mondiale]
        #v(0.05cm)
        #text(size: 8pt, fill: grigio)[PIL mondiale attuale: ~\$105T/anno]
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1pt + arancio, radius: 4pt, fill: arancio.lighten(93%), inset: 7pt, width: 100%)[
      #text(size: 9pt, weight: "bold", fill: arancio.darken(10%))[Progetto Stargate]
      #v(0.05cm)
      #text(size: 8.5pt)[
        Impegno infrastrutturale multi-sito per AI su scala nazionale (USA). Nuovi data center annunciati in diversi stati.
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1pt + grigio, radius: 4pt, fill: luma(248), inset: 7pt, width: 100%)[
      #text(size: 9pt, weight: "bold", fill: scuro)[Competizione geopolitica]
      #v(0.05cm)
      #text(size: 8.5pt)[
        Corsa globale per la supremazia AI: implicazioni su reti elettriche, immobiliare e sicurezza nazionale.
      ]
    ]
  ],

  // --- Colonna 3: energia ---
  [
    #box(stroke: 1.5pt + rosso, radius: 5pt, fill: rosso.lighten(93%), inset: 8pt, width: 100%)[
      #align(center)[
        #text(size: 9pt, weight: "bold", fill: rosso)[CRISI ENERGETICA]
        #v(0.1cm)
        #text(size: 20pt, weight: "bold", fill: scuro)[13 GW]
        #v(0.05cm)
        #text(size: 9pt)[picco di domanda elettrica (NYC)]
        #v(0.05cm)
        #text(size: 8pt, fill: grigio)[I data center USA consumano una quota crescente dell'elettricità totale]
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1pt + blu, radius: 4pt, fill: blu.lighten(93%), inset: 7pt, width: 100%)[
      #text(size: 9pt, weight: "bold", fill: blu)[Soluzioni energetiche]
      #v(0.05cm)
      #text(size: 8.5pt)[
        - *Nucleare:* Francia come modello (flotta estesa)
        - *Rinnovabili:* mix solare/eolico + nucleare
        - *Nuove centrali* dedicate ai data center
      ]
    ]

    #v(0.15cm)

    #align(center)[
      #box(stroke: 1.5pt + scuro, radius: 5pt, fill: scuro.lighten(90%), inset: 7pt)[
        #text(size: 8.5pt, weight: "bold", fill: scuro)[
          Una mobilitazione paragonabile ai più grandi progetti infrastrutturali della storia
        ]
      ]
    ]
  ],
)
