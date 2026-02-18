# Chain Rule e Ottimizzazione dei Calcoli

## Destinatari
Studenti del Liceo Scientifico (4°-5° anno)

## Prerequisiti
- Derivate di funzioni elementari (potenze, esponenziali, logaritmi, trigonometriche)
- Composizione di funzioni: (f ∘ g)(x) = f(g(x))
- Regola della catena (chain rule): se h(x) = f(g(x)), allora h'(x) = f'(g(x)) · g'(x)

---

## Il Problema: Funzioni Composte Multiple

### Situazione

Immaginiamo di avere una funzione composta da **molti strati**:

```
x → g₁(x) → g₂(·) → g₃(·) → ... → gₙ(·) → y
```

**Esempio concreto con 4 funzioni**:

$$y = f(x) = e^{\sin(x^2 + 1)}$$

Possiamo scomporla come composizione:
- **g₁(x) = x² + 1** (funzione quadratica)
- **g₂(u) = sin(u)** (funzione seno)
- **g₃(v) = e^v** (funzione esponenziale)
- **y = g₃(g₂(g₁(x)))**

---

## Obiettivo Didattico

Vogliamo calcolare **in un punto x₀**:
1. Il **valore** della funzione: y = f(x₀)
2. La **derivata** della funzione: y' = f'(x₀)

**Domanda chiave**: Come possiamo essere **efficienti** ed evitare calcoli ridondanti?

---

## Approccio Naive (Inefficiente)

### Calcolo del valore y = f(x₀)

Calcoliamo dall'interno verso l'esterno:

```
x₀ = 2

Step 1: u₁ = g₁(2) = 2² + 1 = 5
Step 2: u₂ = g₂(5) = sin(5) ≈ -0.959
Step 3: y = g₃(-0.959) = ln(-0.959) → ERRORE! (ln di numero negativo)
```

**Nota**: Prendiamo un altro punto dove funziona meglio.

Ricominciamo con **x₀ = 0.5**:

```
x₀ = 0.5

Step 1: u₁ = g₁(0.5) = (0.5)² + 1 = 1.25
Step 2: u₂ = g₂(1.25) = sin(1.25) ≈ 0.9490
Step 3: y = g₃(0.9490) = e^0.9490 ≈ 2.5832
```

### Calcolo della derivata f'(x₀) - Approccio Naive

**Passo 1: Derivare la formula analitica**

Prima troviamo la formula generale di f'(x) usando la chain rule.

Abbiamo:
- $f(x) = e^{\sin(x^2 + 1)}$

Scomponiamo:
- $g_1(x) = x^2 + 1$
- $g_2(u) = \sin(u)$
- $g_3(v) = e^v$

**Derivate delle singole funzioni**:
- $g_1'(x) = 2x$
- $g_2'(u) = \cos(u)$
- $g_3'(v) = e^v$

**Applicazione della chain rule**:

$$f'(x) = g_3'(g_2(g_1(x))) \cdot g_2'(g_1(x)) \cdot g_1'(x)$$

Sostituiamo le derivate:

$$f'(x) = e^{\sin(x^2 + 1)} \cdot \cos(x^2 + 1) \cdot 2x$$

**Forma finale (NON si semplifica ulteriormente!)**:

$$f'(x) = 2x \cdot \cos(x^2 + 1) \cdot e^{\sin(x^2 + 1)}$$

Nota: La derivata contiene **tutte e tre le funzioni** (x², sin, e^) - non c'è semplificazione!

**Passo 2: Valutare numericamente in x₀ = 0.5**

Ora valutiamo questa formula in x₀ = 0.5.

**Usando la formula analitica** $f'(x) = 2x \cdot \cos(x^2 + 1) \cdot e^{\sin(x^2 + 1)}$:

Sostituiamo x = 0.5:

$$f'(0.5) = 2 \cdot 0.5 \cdot \cos(0.5^2 + 1) \cdot e^{\sin(0.5^2 + 1)}$$

$$f'(0.5) = 1.0 \cdot \cos(1.25) \cdot e^{\sin(1.25)}$$

Calcoliamo ogni componente:
- **x² + 1** = 0.25 + 1 = 1.25 ← **RICALCOLATO** (già fatto prima!)
- **sin(1.25)** ≈ 0.9490 ← **RICALCOLATO** (già fatto prima!)
- **cos(1.25)** ≈ 0.3153
- **e^(sin(1.25))** = e^0.9490 ≈ 2.5832 ← **RICALCOLATO** (era già y!)

Quindi:

$$f'(0.5) = 1.0 \cdot 0.3153 \cdot 2.5832 \approx 0.8145$$

**Oppure usando l'espansione step-by-step della chain rule**:

1. **g₁(0.5)** = 1.25 ← **RICALCOLATO**
2. **g₁'(0.5)** = 2 · 0.5 = 1.0
3. **g₂(1.25)** = sin(1.25) ≈ 0.9490 ← **RICALCOLATO**
4. **g₂'(1.25)** = cos(1.25) ≈ 0.3153
5. **g₃(0.9490)** = e^0.9490 ≈ 2.5832 ← **RICALCOLATO** (era y!)
6. **g₃'(0.9490)** = e^0.9490 ≈ 2.5832 (stessa cosa!)

**Derivata finale**:

$$f'(0.5) = g₃'(g₂(g₁(0.5))) \cdot g₂'(g₁(0.5)) \cdot g₁'(0.5)$$
$$f'(0.5) = 2.5832 \cdot 0.3153 \cdot 1.0 \approx 0.8145$$

**Problema in entrambi gli approcci**: Abbiamo **RICALCOLATO** i valori intermedi che avevamo già ottenuto:
- x² + 1 = 1.25 (già calcolato per y)
- sin(1.25) = 0.9490 (già calcolato per y)
- e^(sin(1.25)) = 2.5832 (questo **È** y che avevamo già calcolato!)

---

## Approccio Ottimizzato: Memorizzare i Valori Intermedi

### Idea Chiave

**Quando calcoliamo y, salviamo tutti i valori intermedi in memoria.**

Poi, quando calcoliamo f'(x), **riusiamo questi valori** invece di ricalcolarli!

---

### Passo 1: Calcolo di y (salvando i valori intermedi)

Calcoliamo la funzione normalmente e **salviamo** tutti i valori intermedi:

```python
# Input
x = 0.5

# Layer 1
u₁ = g₁(x) = x² + 1 = 1.25          # SALVA u₁

# Layer 2
u₂ = g₂(u₁) = sin(1.25) = 0.9490    # SALVA u₂

# Layer 3 (output)
y = g₃(u₂) = e^0.9490 = 2.5832      # SALVA y
```

**Valori salvati in memoria**:
- x = 0.5
- u₁ = 1.25
- u₂ = 0.9490
- y = 2.5832

---

### Passo 2: Calcolo di f'(x) (riusando i valori salvati)

Ora calcoliamo la derivata usando la **chain rule**:

$$f'(x) = g_3'(u_2) \cdot g_2'(u_1) \cdot g_1'(x)$$

**L'ottimizzazione**: Invece di ricalcolare u₁ e u₂, li prendiamo dalla memoria!

**Calcolo pratico**:

```python
# Derivata del layer 3: g₃'(u₂)
# g₃(v) = e^v → g₃'(v) = e^v
g3_prime = e^u₂ = e^0.9490 = 2.5832
# Usiamo u₂ salvato! Non serve ricalcolare sin(1.25)
# Inoltre: g₃'(u₂) = y! (per l'esponenziale, derivata = funzione stessa)

# Derivata del layer 2: g₂'(u₁)
# g₂(u) = sin(u) → g₂'(u) = cos(u)
g2_prime = cos(u₁) = cos(1.25) = 0.3153
# Usiamo u₁ salvato! Non serve ricalcolare x² + 1

# Derivata del layer 1: g₁'(x)
# g₁(x) = x² + 1 → g₁'(x) = 2x
g1_prime = 2x = 2 · 0.5 = 1.0
# Usiamo x originale!

# Chain rule: moltiplichiamo
f_prime = g3_prime · g2_prime · g1_prime
f_prime = 2.5832 · 0.3153 · 1.0 = 0.8145
```

**Risultato**: f'(0.5) ≈ 0.8145

---

## Confronto: Naive vs Ottimizzato

### Approccio Naive

**Operazioni totali**:
- Calcolo di y: 3 funzioni (g₁, g₂, g₃)
- Calcolo di y': 3 funzioni + 3 derivate + **RICALCOLO di g₁, g₂** (2 funzioni extra)
- **Totale: 8 valutazioni di funzioni**

### Approccio Ottimizzato

**Operazioni totali**:
- Calcolo y (salvando valori): 3 funzioni
- Calcolo y' (riusando valori salvati): 3 derivate
- **Totale: 3 funzioni + 3 derivate = 6 operazioni**

**Risparmio**: 25% in questo esempio semplice

**Con funzioni più complesse** (10-100 layer): il risparmio diventa **50%+**!

**Il trucco**: Non ricalcoliamo g₁(x), g₂(g₁(x)), ecc. - li abbiamo già in memoria!

---

## Calcolo Unificato: Funzione e Derivata in Parallelo

### Schema del Flusso di Calcolo

```
       FUNZIONE                      DERIVATA
       (output salvati)              (riusa gli output)
       ═══════════════               ══════════════════

        ┌───────┐                    ┌───────────┐
        │ id(x) │ ─────────────────→ │  g₁'(x)   │
        └───────┘                    └───────────┘
            │
            ↓
        ┌───────┐                    ┌───────────┐
        │ g₁(·) │ ─────────────────→ │  g₂'(·)   │
        └───────┘                    └───────────┘
            │
            ↓
        ┌───────┐                    ┌───────────┐
        │ g₂(·) │ ─────────────────→ │  g₃'(·)   │
        └───────┘                    └───────────┘
            │
            ↓
        ┌───────┐
        │ g₃(·) │
        └───────┘
            │
            ↓
            y


    ↓ = l'output della funzione sopra è l'input di quella sotto
    → = l'output della funzione (sinistra) è l'input della derivata (destra)
```

### Schema con Valori Numerici (x = 0.5)

```
       FUNZIONE                         DERIVATA
       ═══════════════                  ══════════════════

        ┌──────────────┐                ┌──────────────────┐
        │ id(x) = x    │ ─────────────→ │ g₁'(x) = 2x      │
        │    = 0.5     │                │       = 1.0      │
        └──────────────┘                └──────────────────┘
            │
            ↓
        ┌──────────────┐                ┌──────────────────┐
        │ g₁(x) = x²+1 │ ─────────────→ │ g₂'(u₁) = cos    │
        │    = 1.25    │                │       = 0.3153   │
        └──────────────┘                └──────────────────┘
            │
            ↓
        ┌──────────────┐                ┌──────────────────┐
        │ g₂(·) = sin  │ ─────────────→ │ g₃'(u₂) = exp    │
        │    = 0.9490  │                │       = 2.5832   │
        └──────────────┘                └──────────────────┘
            │
            ↓
        ┌──────────────┐
        │ g₃(·) = exp  │
        │    = 2.5832  │
        └──────────────┘
            │
            ↓
         y = 2.5832


RISULTATI:
    f(0.5)  = 2.5832
    f'(0.5) = 1.0 × 0.3153 × 2.5832 = 0.8145
```

### Cosa mostra questo schema?

1. **Frecce verticali (↓)**: L'output di ogni funzione diventa l'input della funzione successiva
2. **Frecce orizzontali (→)**: L'output della funzione (colonna sinistra) è usato come input per calcolare la **derivata successiva** (colonna destra)
3. **Sfalsamento**: La derivata gᵢ₊₁'(·) usa l'output di gᵢ(·) → sono sulla stessa riga!
4. **Nessun ricalcolo**: Le derivate "pescano" i valori già calcolati dalla colonna di sinistra
5. **Ultima riga**: L'ultima funzione (g₃ o g₆) non ha derivata corrispondente a destra

### Tabella Riassuntiva (x = 0.5)

| Step | Funzione | Output | → | Derivata (usa output a sinistra) | Valore |
|------|----------|--------|---|----------------------------------|--------|
| 0 | id(x) = x | **0.5** | → | g₁'(x) = 2x | 1.0 |
| 1 | g₁(x) = x² + 1 | **1.25** | → | g₂'(u₁) = cos(u₁) | 0.3153 |
| 2 | g₂(u₁) = sin(u₁) | **0.9490** | → | g₃'(u₂) = e^(u₂) | 2.5832 |
| 3 | g₃(u₂) = e^(u₂) | **2.5832** | | (nessuna) | |

**Risultati**:
- **f(0.5)** = y = **2.5832**
- **f'(0.5)** = 1.0 · 0.3153 · 2.5832 = **0.8145**

---

## Esempio con Funzione Più Complessa (6 Layer)

### Funzione

$$y = f(x) = \cos\left(\sqrt{e^{\sin(\ln(x^2))}}\right)$$

Composizione di 6 funzioni:
- g₁(x) = x²
- g₂(u) = ln(u)
- g₃(v) = sin(v)
- g₄(w) = e^w
- g₅(z) = √z
- g₆(t) = cos(t)

### Schema di Calcolo (x = 1.5)

```
       FUNZIONE                              DERIVATA
       ═══════════════                       ══════════════════

        ┌────────────────┐                   ┌─────────────────┐
        │ id(x) = x      │ ────────────────→ │ g₁'(x) = 2x     │
        │      = 1.5     │                   │       = 3.0     │
        └────────────────┘                   └─────────────────┘
            │
            ↓
        ┌────────────────┐                   ┌─────────────────┐
        │ g₁(x) = x²     │ ────────────────→ │ g₂'(u₁) = 1/u   │
        │      = 2.25    │                   │       = 0.4444  │
        └────────────────┘                   └─────────────────┘
            │
            ↓
        ┌────────────────┐                   ┌─────────────────┐
        │ g₂(·) = ln     │ ────────────────→ │ g₃'(u₂) = cos   │
        │      = 0.8109  │                   │       = 0.6890  │
        └────────────────┘                   └─────────────────┘
            │
            ↓
        ┌────────────────┐                   ┌─────────────────┐
        │ g₃(·) = sin    │ ────────────────→ │ g₄'(u₃) = exp   │
        │      = 0.7247  │                   │       = 2.0640  │
        └────────────────┘                   └─────────────────┘
            │
            ↓
        ┌────────────────┐                   ┌─────────────────┐
        │ g₄(·) = exp    │ ────────────────→ │ g₅'(u₄) = 1/(2√)│
        │      = 2.0640  │                   │       = 0.3480  │
        └────────────────┘                   └─────────────────┘
            │
            ↓
        ┌────────────────┐                   ┌─────────────────┐
        │ g₅(·) = √      │ ────────────────→ │ g₆'(u₅) = -sin  │
        │      = 1.4367  │                   │       = -0.9911 │
        └────────────────┘                   └─────────────────┘
            │
            ↓
        ┌────────────────┐
        │ g₆(·) = cos    │
        │      = 0.1330  │
        └────────────────┘
            │
            ↓
         y = 0.1330


    ↓ = l'output della funzione sopra è l'input di quella sotto
    → = l'output della funzione (sinistra) è l'input della derivata (destra)
```

### Tabella di Calcolo Dettagliata (x = 1.5)

| Step | Funzione | Output | → | Derivata (usa output a sinistra) | Valore |
|------|----------|--------|---|----------------------------------|--------|
| 0 | id(x) = x | **1.5** | → | g₁'(x) = 2x | 3.0000 |
| 1 | g₁(x) = x² | **2.2500** | → | g₂'(u₁) = 1/u₁ | 0.4444 |
| 2 | g₂(u₁) = ln(u₁) | **0.8109** | → | g₃'(u₂) = cos(u₂) | 0.6890 |
| 3 | g₃(u₂) = sin(u₂) | **0.7247** | → | g₄'(u₃) = e^(u₃) | 2.0640 |
| 4 | g₄(u₃) = e^(u₃) | **2.0640** | → | g₅'(u₄) = 1/(2√u₄) | 0.3480 |
| 5 | g₅(u₄) = √(u₄) | **1.4367** | → | g₆'(u₅) = -sin(u₅) | -0.9911 |
| 6 | g₆(u₅) = cos(u₅) | **0.1330** | | (nessuna) | |

### Risultati

**Valore della funzione**:
$$f(1.5) = 0.1330$$

**Derivata** (prodotto di tutte le derivate parziali):
$$f'(1.5) = 3.0 \times 0.4444 \times 0.6890 \times 2.0640 \times 0.3480 \times (-0.9911)$$
$$f'(1.5) = -0.6156$$

### Osservazioni

1. **6 funzioni, 6 valori salvati**: u₁, u₂, u₃, u₄, u₅, y
2. **6 derivate calcolate**: ognuna usa il valore della riga corrispondente
3. **Nessun ricalcolo**: ogni valore nella colonna FUNZIONE è usato esattamente una volta per la derivata
4. **Segno negativo**: la derivata di cos è -sin, quindi f'(1.5) < 0

### Confronto con Approccio Naive

**Approccio Naive**:
- Calcolo y: 6 funzioni
- Calcolo y': ricalcolo 5 valori intermedi + 6 derivate = 11 operazioni
- **Totale: 17 operazioni**

**Approccio Ottimizzato**:
- Calcolo y (con memorizzazione): 6 funzioni
- Calcolo y' (riusando valori): 6 derivate
- **Totale: 12 operazioni**

**Risparmio: 30%** (e aumenta con più layer!)

---

## Altro Esempio: Funzione a 4 Layer

$$y = e^{\sqrt{\sin(x^2 + 1)}}$$

Scomposizione:
- **g₁(x) = x² + 1**
- **g₂(u₁) = sin(u₁)**
- **g₃(u₂) = √u₂**
- **g₄(u₃) = e^(u₃)**

### Forward Pass

| Layer | Funzione | Input | Output | Valore (x=0.5) |
|-------|----------|-------|--------|----------------|
| 1 | g₁(x) = x² + 1 | x = 0.5 | u₁ | 1.25 |
| 2 | g₂(u₁) = sin(u₁) | u₁ = 1.25 | u₂ | 0.9490 |
| 3 | g₃(u₂) = √u₂ | u₂ = 0.9490 | u₃ | 0.9742 |
| 4 | g₄(u₃) = e^(u₃) | u₃ = 0.9742 | y | 2.6494 |

**y(0.5) = 2.6494**

### Calcolo della Derivata (riusando i valori salvati)

| Layer | Derivata | Usa valore salvato | Valore (x=0.5) |
|-------|----------|-------------------|----------------|
| 1 | g₁'(x) = 2x | x = 0.5 | 1.0 |
| 2 | g₂'(u₁) = cos(u₁) | u₁ = 1.25 | 0.3153 |
| 3 | g₃'(u₂) = 1/(2√u₂) | u₂ = 0.9490 | 0.5133 |
| 4 | g₄'(u₃) = e^(u₃) | u₃ = 0.9742 | 2.6494 |

**Chain rule finale**:

$$f'(x) = g_1'(x) \cdot g_2'(u_1) \cdot g_3'(u_2) \cdot g_4'(u_3)$$

$$f'(0.5) = 1.0 \cdot 0.3153 \cdot 0.5133 \cdot 2.6494 = 0.4291$$

**y'(0.5) = 0.4291**

---

## Collegamento con le Reti Neurali

### Perché è importante per il Deep Learning?

Nelle reti neurali:
- Ogni **layer** è una funzione: z = W·x + b seguito da attivazione σ(z)
- Una rete con 100 layer ha **100 composizioni** di funzioni
- Durante il **training**, dobbiamo calcolare:
  1. **Predizione**: calcolare l'output y (passando attraverso tutti i layer)
  2. **Gradienti**: calcolare le derivate per aggiornare i pesi

**Senza memorizzazione**: dovremmo ricalcolare l'output di ogni layer → impossibile!

**Con memorizzazione**: calcoliamo ogni layer una volta, salviamo, riusiamo → efficiente!

### Analogia Diretta

| Matematica (Chain Rule) | Deep Learning (Backpropagation) |
|-------------------------|----------------------------------|
| Funzioni g₁, g₂, g₃ | Layer della rete (Dense, Conv, etc.) |
| Valori intermedi u₁, u₂ | Attivazioni di ogni layer |
| Calcolo di y | Forward propagation |
| Calcolo di f'(x) con chain rule | Backpropagation (calcolo gradienti) |
| Memorizzazione valori intermedi | Cache delle attivazioni |

---

## Implementazione Python

### Codice Didattico

```python
import numpy as np

# Definizione delle funzioni e delle loro derivate
def g1(x):
    return x**2 + 1

def g1_prime(x):
    return 2 * x

def g2(u):
    return np.sin(u)

def g2_prime(u):
    return np.cos(u)

def g3(v):
    return np.log(v)

def g3_prime(v):
    return 1 / v

# FORWARD PASS - Calcolo di y e salvataggio valori intermedi
def forward_pass(x):
    """
    Calcola y = g3(g2(g1(x))) e salva i valori intermedi
    """
    cache = {}  # Dizionario per salvare i valori

    # Layer 1
    cache['x'] = x
    cache['u1'] = g1(x)

    # Layer 2
    cache['u2'] = g2(cache['u1'])

    # Layer 3 (output)
    cache['y'] = g3(cache['u2'])

    return cache['y'], cache

# BACKWARD PASS - Calcolo della derivata usando i valori salvati
def backward_pass(cache):
    """
    Calcola dy/dx usando la chain rule e i valori dalla cache
    """
    # Derivate locali (ogni layer)
    dy_du2 = g3_prime(cache['u2'])  # Usa u2 salvato!
    du2_du1 = g2_prime(cache['u1']) # Usa u1 salvato!
    du1_dx = g1_prime(cache['x'])   # Usa x salvato!

    # Chain rule: moltiplica tutte le derivate
    dy_dx = dy_du2 * du2_du1 * du1_dx

    return dy_dx

# ESEMPIO DI UTILIZZO
x0 = 0.5

print("="*50)
print("FORWARD PASS")
print("="*50)

y, cache = forward_pass(x0)

print(f"Input: x = {x0}")
print(f"u1 = g1(x) = {cache['u1']:.4f}")
print(f"u2 = g2(u1) = {cache['u2']:.4f}")
print(f"y = g3(u2) = {cache['y']:.4f}")

print("\n" + "="*50)
print("BACKWARD PASS")
print("="*50)

dy_dx = backward_pass(cache)

print(f"dy/du2 = g3'(u2) = {g3_prime(cache['u2']):.4f}")
print(f"du2/du1 = g2'(u1) = {g2_prime(cache['u1']):.4f}")
print(f"du1/dx = g1'(x) = {g1_prime(cache['x']):.4f}")
print(f"\nChain rule: dy/dx = {dy_dx:.4f}")

print("\n" + "="*50)
print("RIEPILOGO")
print("="*50)
print(f"f({x0}) = {y:.4f}")
print(f"f'({x0}) = {dy_dx:.4f}")
```

### Output del Programma

```
==================================================
FORWARD PASS
==================================================
Input: x = 0.5
u1 = g1(x) = 1.2500
u2 = g2(u1) = 0.9490
y = g3(u2) = -0.0524

==================================================
BACKWARD PASS
==================================================
dy/du2 = g3'(u2) = 1.0537
du2/du1 = g2'(u1) = 0.3153
du1/dx = g1'(x) = 1.0000

Chain rule: dy/dx = 0.3322

==================================================
RIEPILOGO
==================================================
f(0.5) = -0.0524
f'(0.5) = 0.3322
```

---

## Esercizi Proposti

### Esercizio 1: Calcolo Manuale

Data la funzione: $y = \cos(e^x)$ con x = 0

1. Scomponi in g₁(x) = e^x e g₂(u) = cos(u)
2. Calcola il forward pass (trova y)
3. Calcola il backward pass (trova y')
4. Verifica che non stai ricalcolando valori

### Esercizio 2: Implementazione Python

Implementa forward_pass e backward_pass per:

$$y = \sqrt{x^3 + 2x}$$

Valuta in x = 2.

### Esercizio 3: Rete a 6 Layer

Data la funzione:

$$y = \ln(\sin(\sqrt{x^2 + 1}))$$

1. Identifica i 4 layer (g₁, g₂, g₃, g₄)
2. Costruisci la tabella del forward pass per x = 1
3. Costruisci la tabella del backward pass
4. Calcola y'(1)

---

## Domande di Verifica

1. **Perché salvare i valori intermedi durante il forward pass?**
   - Risposta: Per evitare di ricalcolarli durante il backward pass

2. **Cosa succederebbe se non salvassimo nulla?**
   - Risposta: Dovremmo ricalcolare g₁(x), g₂(g₁(x)), ecc. ogni volta → molto inefficiente

3. **In che direzione calcoliamo la derivata?**
   - Risposta: Dall'output verso l'input (backward), usando la chain rule

4. **Quante volte valutiamo ogni funzione con l'approccio ottimizzato?**
   - Risposta: Esattamente 1 volta (forward pass)

5. **Perché questo è cruciale per le reti neurali?**
   - Risposta: Le reti hanno centinaia di layer → senza ottimizzazione, training impossibile

---

## Estensioni Avanzate

### 1. Funzioni Multivariate

Se y = f(x₁, x₂) (funzione di **più variabili**):
- Forward pass: calcola y
- Backward pass: calcola le **derivate parziali** ∂y/∂x₁ e ∂y/∂x₂ simultaneamente
- Esempio: y = x₁² + x₁·x₂ + x₂³
- **Nota**: Solo in questo caso servono le derivate parziali!

### 2. Automatic Differentiation

Librerie come PyTorch e TensorFlow implementano automaticamente:
- Calcolo della funzione con memorizzazione dei valori
- Calcolo delle derivate riusando i valori salvati
- Tutto trasparente al programmatore!

```python
import torch

x = torch.tensor(0.5, requires_grad=True)
y = torch.log(torch.sin(x**2 + 1))

y.backward()  # Calcola automaticamente dy/dx!

print(f"y = {y.item():.4f}")
print(f"dy/dx = {x.grad.item():.4f}")
```

### 3. Calcolo del Gradiente in Reti Neurali

Ogni layer ha parametri W, b:
- Forward: y = σ(W·x + b)
- Backward: calcola le **derivate parziali** ∂Loss/∂W e ∂Loss/∂b (qui servono perché Loss dipende da molte variabili: W₁, W₂, ..., b₁, b₂, ...)

La chain rule si applica attraverso TUTTI i layer!

---

## Conclusione

**Concetto chiave**: La chain rule + memorizzazione dei valori intermedi = algoritmo efficiente!

**Strategia vincente**:
1. **Calcola la funzione**: Passa attraverso tutti i layer, **memorizza ogni risultato intermedio**
2. **Calcola la derivata**: Applica la chain rule, **riusa i valori già calcolati**

**Perché funziona**:
- Le derivate g₁'(x), g₂'(u₁), g₃'(u₂) hanno bisogno degli stessi valori che abbiamo già calcolato!
- g₃'(u₂) richiede u₂ → già in memoria ✓
- g₂'(u₁) richiede u₁ → già in memoria ✓
- g₁'(x) richiede x → già in memoria ✓

**Impatto**:
✅ Evita ricalcoli ridondanti (50%+ risparmio con molti layer)
✅ Rende possibile il training di reti profonde
✅ Fondamento della backpropagation

**Machine Learning = Matematica + Ottimizzazione Algoritmica**

---

## Risorse Extra

### Video Consigliati
- 3Blue1Brown: "Backpropagation calculus" (visualizzazione eccellente)
- StatQuest: "Backpropagation Step by Step"

### Letture
- "Deep Learning" (Goodfellow et al.) - Chapter 6: Backpropagation
- "Neural Networks and Deep Learning" (Nielsen) - Online free book

### Tool Interattivi
- TensorFlow Playground: visualizza forward/backward in tempo reale
- Desmos: grafica le funzioni composte passo per passo
