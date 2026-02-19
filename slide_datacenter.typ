#set page(width: 25.4cm, height: 14.29cm, margin: (x: 0.8cm, y: 0.6cm))
#set text(font: "New Computer Modern", size: 10.5pt, lang: "it")

#let verde = rgb("#27ae60")
#let blu = rgb("#3498db")
#let rosso = rgb("#e74c3c")
#let viola = rgb("#9b59b6")
#let arancio = rgb("#e67e22")
#let grigio = rgb("#7f8c8d")
#let scuro = rgb("#2c3e50")

// ============================================================
// SLIDE 1: Contesto + Tabella
// ============================================================
#align(center)[
  #text(size: 18pt, weight: "bold")[Datacenter AI: la Scala dell'Infrastruttura]
]

#v(0.2cm)

#grid(
  columns: (1fr, 1.6fr),
  gutter: 0.4cm,
  [
    #box(stroke: 1.5pt + blu, radius: 5pt, fill: blu.lighten(93%), inset: 10pt, width: 100%)[
      #text(size: 10.5pt, weight: "bold", fill: blu)[Contesto globale]
      #v(0.1cm)
      #text(size: 9pt)[
        - Consumo datacenter 2024: *415 TWh* (1,5% elettricità mondiale)
        - Previsione 2030: *945 TWh* #sym.approx consumo annuo del Giappone
        - Spesa USA: da 13,8 a *41,2 mld \$/anno* in 3 anni (*+200%*)
      ]
    ]

    #v(0.15cm)

    #box(stroke: 1.5pt + arancio, radius: 5pt, fill: arancio.lighten(93%), inset: 10pt, width: 100%)[
      #text(size: 10.5pt, weight: "bold", fill: arancio.darken(10%))[Ordine di grandezza]
      #v(0.1cm)
      #text(size: 9pt)[
        - Un datacenter AI tipico consuma quanto *100.000 abitazioni*; i più grandi quanto *2 milioni*
        - Meta Hyperion #sym.approx *4× Central Park*
        - Stargate (completato) #sym.approx *1× Central Park*
        - Prima dell'AI: 1–3 ettari in edificio urbano; oggi: *centinaia/migliaia di ettari* in aree rurali
      ]
    ]

    #v(0.15cm)

    #text(size: 7pt, fill: grigio)[
      Fonti: IEA – Energy and AI (2025) | Epoch AI (nov. 2025) | Neowin, Fortune, Wikipedia (2025–26) | Distilled/Cleanview (ott. 2025) | Microsoft Blog (sett. 2025)
    ]
  ],
  [
    #text(size: 10.5pt, weight: "bold", fill: viola)[Mega-datacenter AI recenti]
    #v(0.1cm)
    #table(
      columns: (auto, auto, auto, auto, auto, auto),
      inset: 5.5pt,
      align: (left, left, right, right, right, left),
      stroke: 0.4pt + luma(180),
      fill: (col, row) => if row == 0 { viola.lighten(85%) } else if calc.odd(row) { luma(248) } else { white },
      text(size: 8pt, weight: "bold")[Datacenter],
      text(size: 8pt, weight: "bold")[Azienda],
      text(size: 8pt, weight: "bold")[Superficie],
      text(size: 8pt, weight: "bold")[Potenza],
      text(size: 8pt, weight: "bold")[Investimento],
      text(size: 8pt, weight: "bold")[Stato],

      text(size: 8pt)[Stargate\ (Abilene, TX)],
      text(size: 8pt)[OpenAI /\ Oracle /\ SoftBank],
      text(size: 8pt)[350 ha],
      text(size: 8pt)[200 MW →\ 1,2 GW],
      text(size: 8pt)[\$100 mld],
      text(size: 8pt)[Operativo\ fine 2025],

      text(size: 8pt)[Fairwater\ (Wisconsin)],
      text(size: 8pt)[Microsoft],
      text(size: 8pt)[127 ha],
      text(size: 8pt)[>350 MW],
      text(size: 8pt)[~\$3 mld],
      text(size: 8pt)[Operativo\ inizio 2026],

      text(size: 8pt)[Project Rainier\ (Indiana)],
      text(size: 8pt)[Amazon\ (Anthropic)],
      text(size: 8pt)[485 ha],
      text(size: 8pt)[525 MW →\ 2,2 GW],
      text(size: 8pt)[\$11 mld],
      text(size: 8pt)[7/30 edifici\ operativi],

      text(size: 8pt)[Hyperion\ (Louisiana)],
      text(size: 8pt)[Meta],
      text(size: 8pt)[1.100 ha],
      text(size: 8pt)[1.500 MW],
      text(size: 8pt)[\$10 mld],
      text(size: 8pt)[In costruzione\ entro 2030],

      text(size: 8pt)[Colossus\ (Memphis, TN)],
      text(size: 8pt)[xAI\ (Elon Musk)],
      text(size: 8pt)[39 ha],
      text(size: 8pt)[250–400 MW\ → 1 GW],
      text(size: 8pt)[n.d.],
      text(size: 8pt)[Operativo\ sett. 2024],
    )
  ],
)
