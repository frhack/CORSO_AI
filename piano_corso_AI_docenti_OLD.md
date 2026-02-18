# Corso di Introduzione all'AI per Docenti STEM - Liceo Scientifico

## Informazioni Generali
- **Durata**: 4 ore totali
- **Struttura**: 2 incontri da 2 ore ciascuno
- **Target**: Docenti STEM di Liceo Scientifico
- **Obiettivo**: Fornire competenze pratiche e teoriche di base sull'AI, con focus su applicazioni didattiche

---

## PRIMO INCONTRO (2 ore)

---

### Argomento 1: Timeline dell'Intelligenza Artificiale

#### Contenuti

##### Slide 1.1: "La storia dell'AI - Momenti chiave"
**Durata**: 5-10 minuti

**Contenuto**:
- **1950** - Alan Turing pubblica "Computing Machinery and Intelligence" e propone il Test di Turing
- **1956** - Conferenza di Dartmouth: nasce ufficialmente il termine "Artificial Intelligence"
- **1997** - Deep Blue di IBM sconfigge Kasparov a scacchi
- **2012** - AlexNet vince ImageNet: inizia la rivoluzione del Deep Learning
- **2016** - AlphaGo di DeepMind batte Lee Sedol a Go
- **Novembre 2022** - Lancio di ChatGPT: l'AI diventa mainstream (100M utenti in 2 mesi)
- **2023** - Esplosione dell'AI generativa (GPT-4, Gemini, Claude, LLaMA, Midjourney)
- **2024** - EU AI Act: prima regolamentazione organica dell'AI
- **2025** - AI in classe: nuove linee guida ministeriali e competenze digitali

**Messaggio chiave**: Siamo in un momento di svolta storica, l'AI non è più futuro ma presente quotidiano

##### Artefatti Argomento 1
- **Infografica timeline** (PDF stampabile): "70 anni di AI in una pagina"
- **Linea del tempo interattiva**: Link a risorsa online esplorabile
- **Video**: Breve montaggio (2-3 min) con i momenti iconici (Deep Blue, AlphaGo, ChatGPT demo)

---

### Argomento 2: Fondamenti di AI e Machine Learning

#### Contenuti

##### Slide 2.1: "Cos'è l'Intelligenza Artificiale"
**Contenuto**:
- Definizione di AI
- AI debole vs AI forte
- AI vs Machine Learning vs Deep Learning (diagramma di Venn)
- Applicazioni nella vita quotidiana (smartphone, Netflix, GPS, ecc.)

##### Slide 2.2: "Tipi di apprendimento automatico"
**Contenuto**:
- Apprendimento supervisionato (con etichette)
- Apprendimento non supervisionato (senza etichette)
- Reinforcement learning (per ricompense)
- Esempi pratici per ogni tipo

##### Slide 2.3: "Il processo di training"
**Contenuto**:
- Dati → Modello → Predizioni
- Train set, validation set, test set
- Overfitting e underfitting
- Visualizzazione grafica del concetto

##### Slide 2.4: "AI nella didattica STEM"
**Contenuto**:
- Esempi in fisica (analisi dati esperimenti)
- Esempi in matematica (risoluzione problemi)
- Esempi in chimica (predizione molecole)
- Esempi in biologia (analisi immagini cellule)
- Opportunità e limiti
- Considerazioni etiche

##### Artefatti Argomento 2
- **Infografica**: "Mappa concettuale dell'AI" (PDF stampabile)
- **Glossario**: Termini chiave AI/ML per studenti
- **Scheda pratica**: "Quando usare (e non usare) l'AI in classe"

---

### Argomento 3: Primo Notebook Python - Classificazione Base

#### Contenuti

##### Notebook 3.1: `01_introduzione_classificazione.ipynb`
**Durata**: 75 minuti

**Obiettivi didattici**:
- Familiarizzare con Jupyter Notebook
- Comprendere il workflow di un problema di classificazione
- Visualizzare dati e risultati

**Struttura del notebook**:

**Parte 1: Setup ambiente** (5 min)
- Import librerie base: numpy, pandas, matplotlib, scikit-learn
- Verifica installazione
- Primo codice funzionante

**Parte 2: Caricamento e esplorazione dati** (15 min)
- Dataset: Iris (classico e comprensibile)
- Visualizzazione con scatter plot
- Statistica descrittiva
- Correlazioni tra features

**Parte 3: Primo modello di classificazione** (25 min)
- Split train/test
- K-Nearest Neighbors (algoritmo intuitivo e visuale)
- Training del modello
- Predizioni su test set

**Parte 4: Valutazione del modello** (20 min)
- Accuracy, confusion matrix
- Visualizzazione dei risultati
- Interpretazione degli errori
- Cosa significano i numeri?

**Parte 5: Esperimenti guidati** (10 min)
- Modificare il numero di vicini (k)
- Osservare l'impatto sulle performance
- Discussione: come scegliere i parametri?

**Esercizi pratici inclusi**:
- Modificare il valore di k e osservare i cambiamenti
- Provare a usare solo 2 features invece di 4
- Visualizzare i boundary decisionali (2D)

##### Artefatti Argomento 3
- **Cheat Sheet**: "Comandi Python essenziali per ML"
- **Template**: Notebook vuoto per replicare l'analisi con altri dataset
- **Dataset alternativi**: Link a repository con dataset educativi (UCI ML Repository)
- **Video tutorial**: Registrazione della sessione per consultazione successiva

---

## SECONDO INCONTRO (2 ore)

---

### Argomento 4: Reti Neurali e Deep Learning

#### Contenuti

##### Slide 4.1: "Dai neuroni biologici ai neuroni artificiali"
**Contenuto**:
- Analogia con il cervello (con cautela, senza esagerazioni)
- Struttura di un neurone artificiale
- Il percettrone: come funziona
- Input, pesi, bias, funzione di attivazione
- Funzioni di attivazione comuni (sigmoid, ReLU)

##### Slide 4.2: "Reti neurali multistrato"
**Contenuto**:
- Architettura: input layer, hidden layers, output layer
- Forward propagation (flusso dei dati)
- Backpropagation (concetto intuitivo, senza matematica pesante)
- Gradient descent: scendere la montagna verso l'errore minimo

##### Slide 4.3: "Deep Learning oggi"
**Contenuto**:
- Perché "deep"? (molti layer)
- CNN (Convolutional Neural Networks) per le immagini
- RNN e Transformer per il linguaggio
- Transfer Learning: usare modelli già addestrati

##### Slide 4.4: "Deep Learning in ambito STEM"
**Contenuto**:
- Riconoscimento di grafici e formule matematiche
- Analisi automatica di esperimenti scientifici
- Simulazioni fisiche accelerate dall'AI
- Caso studio: AlphaFold e la predizione delle proteine

##### Artefatti Argomento 4
- **Poster didattico**: "Anatomia di una rete neurale" (visualizzazione a layer)
- **Video consigliati**:
  - 3Blue1Brown - Neural Networks
  - Crash Course AI
  - Altri canali divulgativi
- **Caso studio completo**: "AlphaFold: da problema a Nobel" (PDF)
- **Simulatore interattivo**: Link a TensorFlow Playground

---

### Argomento 5: Deep Learning in Pratica - Riconoscimento Immagini

#### Contenuti

##### Notebook 5.1: `02_rete_neurale_mnist.ipynb`
**Durata**: 40 minuti

**Obiettivi didattici**:
- Costruire e addestrare una rete neurale da zero
- Lavorare con immagini
- Comprendere il training loop
- Vedere il miglioramento in tempo reale

**Struttura del notebook**:

**Parte 1: Dataset MNIST** (5 min)
- Cifre scritte a mano (28x28 pixel)
- Caricamento e visualizzazione
- Esplorazione del dataset

**Parte 2: Preprocessing** (5 min)
- Normalizzazione dei pixel (0-255 → 0-1)
- Perché normalizzare?
- Reshaping dei dati

**Parte 3: Costruzione della rete neurale** (10 min)
- Uso di Keras/TensorFlow (alto livello)
- Definizione architettura: Dense layers
- Scelta di loss function, optimizer, metrics
- Compilazione del modello

**Parte 4: Training** (10 min)
- Fit del modello
- Visualizzazione live delle curve di loss e accuracy
- Epochs e batch size: cosa significano?
- Osservare la rete che impara

**Parte 5: Valutazione e predizioni** (10 min)
- Accuracy sul test set
- Visualizzare predizioni corrette e sbagliate
- Confusion matrix
- Dove sbaglia la rete?

**Esercizi pratici inclusi**:
- Modificare il numero di neuroni nei layer
- Aggiungere/rimuovere layer nascosti
- Cambiare il numero di epochs
- Provare diversi optimizer

##### Artefatti Argomento 5
- **Guida**: "Architetture di reti neurali comuni"
- **Checklist debugging**: "La mia rete non impara: troubleshooting"
- **Notebook avanzato** (opzionale): CNN su MNIST per chi vuole approfondire

---

### Argomento 6: Large Language Models e Prompt Engineering

#### Contenuti

##### Slide 6.1: "Cosa sono i Large Language Models"
**Contenuto**:
- GPT, Claude, Gemini, LLaMA: panoramica
- Come funzionano (spiegazione high-level, no matematica)
- Cosa possono e non possono fare
- Dimensioni e capacità

##### Notebook 6.1: `03_llm_e_prompt_engineering.ipynb`
**Durata**: 40 minuti

**Obiettivi didattici**:
- Comprendere cosa sono i LLM
- Imparare tecniche di prompt engineering
- Esplorare applicazioni didattiche concrete
- Riconoscere limiti e rischi

**Struttura del notebook**:

**Parte 1: Setup e prima interazione** (10 min)
- Opzione A: API gratuite/demo (HuggingFace, OpenAI Playground)
- Opzione B: Modello locale con Ollama (privacy-first)
- Configurazione e primo prompt
- "Hello World" con un LLM

**Parte 2: Prompt Engineering - Le basi** (15 min)
- **Tecnica 1: Be Specific**
  - Prompt vago vs prompt preciso
  - Esempi pratici
- **Tecnica 2: Give Examples (Few-shot learning)**
  - Zero-shot vs Few-shot
  - Migliorare le risposte con esempi
- **Tecnica 3: Set Context and Role**
  - "Sei un tutor di fisica..."
  - Influenza del contesto
- **Tecnica 4: Chain-of-Thought**
  - Chiedere ragionamento passo-passo
  - Migliorare problem solving

**Parte 3: Applicazioni STEM** (10 min)
- Generazione di problemi di fisica (cinematica, dinamica)
- Spiegazione di concetti matematici a livelli diversi
- Correzione di esercizi con feedback costruttivo
- Generazione di codice Python per simulazioni
- Creazione di quiz e verifiche

**Parte 4: Limiti, allucinazioni e bias** (5 min)
- Quando l'AI "inventa" informazioni
- Esempi di allucinazioni comuni
- Bias nei modelli (culturali, di genere, ecc.)
- L'importanza della verifica umana
- Mai fidarsi ciecamente

##### Slide 6.2: "AI e Didattica: Opportunità"
**Contenuto**:
- Tutor virtuale personalizzato 24/7
- Generazione di materiali didattici
- Assistente per la valutazione e feedback
- Tool per studenti con BES/DSA
- Differenziazione e personalizzazione

##### Slide 6.3: "AI e Didattica: Responsabilità"
**Contenuto**:
- Plagio e uso scorretto
- Privacy e dati degli studenti
- Dipendenza dalla tecnologia
- Pensiero critico vs accettazione passiva
- Ruolo insostituibile del docente

**Esercizi pratici inclusi nel notebook**:
- Creare prompt per generare 5 problemi di cinematica con soluzione
- Chiedere spiegazione del teorema di Pitagora per 3 livelli diversi
- Prompt per correggere un esercizio di bilanciamento reazioni chimiche
- Generare un esperimento di laboratorio simulato

##### Artefatti Argomento 6
- **Raccolta prompt**: "50 prompt pronti per docenti STEM" (PDF)
- **Linee guida**: "Uso etico e responsabile dell'AI in classe"
- **Checklist**: "Come valutare l'output di un LLM"
- **Template prompt**: File con prompt riutilizzabili e personalizzabili

---

### Argomento 7: Conclusione e Prossimi Passi

#### Contenuti

##### Slide 7.1: "Riepilogo del corso"
**Contenuto**:
- Journey: Timeline → ML → Deep Learning → LLM
- Concetti chiave appresi
- Competenze acquisite

##### Slide 7.2: "Risorse per continuare"
**Contenuto**:
- **Corsi online**:
  - Coursera: Machine Learning (Andrew Ng)
  - Fast.ai: Practical Deep Learning
  - DeepLearning.AI
- **Libri consigliati**:
  - "Hands-On Machine Learning" (Géron)
  - "Deep Learning with Python" (Chollet)
- **Piattaforme per sperimentare**:
  - Google Colab (notebook gratuiti)
  - Kaggle (dataset e competizioni)
  - HuggingFace (modelli pre-addestrati)

##### Slide 7.3: "AI e futuro della didattica"
**Contenuto**:
- Competenze da sviluppare negli studenti:
  - Pensiero computazionale
  - AI literacy
  - Etica e responsabilità digitale
- AI come strumento, non sostituto
- Bilanciare tecnologia e umanità
- Il docente come guida critica

##### Slide 7.4: "Comunità e supporto"
**Contenuto**:
- Forum e community di docenti che usano AI
- Repository GitHub del corso
- Contatti per domande e follow-up
- Eventuale incontro di follow-up dopo 1 mese

##### Slide 7.5: "Q&A e Feedback"
**Contenuto**:
- Spazio per domande
- Questionario di gradimento
- Suggerimenti per migliorare il corso

##### Artefatti Argomento 7
- **Roadmap personalizzata**: "Il tuo percorso di apprendimento AI" (template)
- **Bibliografia completa**: Libri, paper, blog, podcast
- **Link utili**: Repository GitHub, community, newsletter
- **Mini-progetto opzionale**: "Applica l'AI alla tua disciplina" (template)

---

## MATERIALI TECNICI NECESSARI

### Per i docenti (partecipanti)
- **Laptop** con Python 3.8+ installato
- **Alternativa cloud**: Google Colab (solo browser, no installazione locale)
- **Librerie Python richieste**:
  ```
  numpy
  pandas
  matplotlib
  seaborn
  scikit-learn
  tensorflow / keras
  jupyter
  requests (per API calls)
  ```

### Setup consigliato pre-corso
- **2 settimane prima**: Email con istruzioni installazione Anaconda
- **1 settimana prima**: Test session online per verificare ambiente
- **Piano B**: Tutti su Google Colab (più semplice, sempre funziona)

### Per il formatore
- **Proiettore** / schermo condiviso
- **Microfono** (se aula grande)
- **Backup**: Tutti i notebook già eseguiti (in caso di problemi tecnici)
- **Hotspot mobile**: in caso di problemi WiFi

---

## VALUTAZIONE E FEEDBACK

### Durante il corso
- **Quiz interattivi** dopo ogni sezione teorica (Mentimeter/Kahoot)
- **Checkpoint pratici** nei notebook (celle con esercizi)
- **Sondaggi flash**: "Chiaro? Troppo veloce?"

### Post-corso
- **Questionario di gradimento** (Google Form, 5-10 min)
- **Mini-progetto opzionale**:
  - "Applica AI a un problema della tua disciplina"
  - Consegna facoltativa dopo 2 settimane
- **Follow-up**: Incontro online dopo 1 mese per condividere esperienze in classe

---

## NOTE ORGANIZZATIVE

### Tempistiche
- Ogni slide teorica: max 2-3 minuti
- Bilanciamento: 40% teoria, 60% pratica
- **Pause obbligatorie**: 10 min a metà di ogni incontro

### Flessibilità e adattamenti
- **Livello base**: Più tempo su fondamentali Python, meno dettagli tecnici
- **Livello avanzato**: Aggiungere notebook bonus (CNN, NLP)
- **Focus disciplinare**: Esempi specifici per fisica/matematica/biologia

### Accessibilità
- Slide con alto contrasto (leggibilità)
- Font minimum 24pt per proiezione
- Codice commentato in italiano
- Glossario sempre disponibile
- Registrazione degli incontri (se autorizzata)

---

## RISULTATI ATTESI

Al termine del corso, i docenti saranno in grado di:

1. ✅ Comprendere storia, concetti e terminologia dell'AI
2. ✅ Distinguere ML, Deep Learning, e LLM
3. ✅ Leggere, comprendere e modificare codice Python per ML
4. ✅ Addestrare modelli semplici (classificazione, reti neurali)
5. ✅ Utilizzare LLM tramite prompt engineering efficace
6. ✅ Applicare AI in contesti didattici STEM
7. ✅ Valutare criticamente strumenti AI (pro e contro)
8. ✅ Guidare gli studenti verso uso consapevole e etico dell'AI
9. ✅ Continuare l'apprendimento autonomo (hanno le basi)

---

## CONTATTI E SUPPORTO

- **Email formatore**: [da inserire]
- **Repository GitHub**: [da creare] - con tutti i materiali (slide, notebook, dataset)
- **Canale supporto**: Discord/Slack [opzionale] - per domande post-corso
- **Follow-up**: Meeting online 1 mese dopo il corso

---

## STRUTTURA DEL REPOSITORY GITHUB

```
corso-ai-docenti-stem/
├── README.md
├── slide/
│   ├── 01_timeline.pdf
│   ├── 02_fondamenti_ai_ml.pdf
│   ├── 04_reti_neurali_deep_learning.pdf
│   ├── 06_llm_prompt_engineering.pdf
│   └── 07_conclusioni.pdf
├── notebook/
│   ├── 01_introduzione_classificazione.ipynb
│   ├── 02_rete_neurale_mnist.ipynb
│   └── 03_llm_e_prompt_engineering.ipynb
├── artefatti/
│   ├── infografiche/
│   ├── cheat_sheets/
│   ├── prompt_collections/
│   └── linee_guida/
├── dataset/
│   └── (link a risorse esterne per non appesantire repo)
├── risorse_extra/
│   ├── bibliografia.md
│   ├── link_utili.md
│   └── video_consigliati.md
└── setup/
    ├── installazione_anaconda.md
    ├── setup_google_colab.md
    └── requirements.txt
```
