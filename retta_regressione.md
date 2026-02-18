# Regressione Lineare: Un'Analogia Fisica con Elastici

## Destinatari
Studenti del Liceo Scientifico (3°-5° anno)

## Prerequisiti
- Equazione della retta: y = mx + q
- Forza elastica: F = k·Δx (Legge di Hooke)
- Equilibrio dei corpi rigidi:
  - ΣF = 0 (somma delle forze nulla → no traslazione)
  - ΣM = 0 (somma dei momenti nulla → no rotazione)

---

## Introduzione: Il Problema della Retta di Regressione

**Situazione**: Abbiamo n punti sperimentali (x₁, y₁), (x₂, y₂), ..., (xₙ, yₙ) ottenuti da misurazioni.

**Obiettivo**: Trovare la retta **y = mx + q** che "meglio approssima" questi punti.

**Domanda**: Cosa significa "meglio"? Come troviamo i parametri m (pendenza) e q (intercetta)?

---

## L'Analogia Fisica: Retta ed Elastici

### Setup Immaginario

Immaginiamo di avere:
- Una **retta rigida** di equazione y = mx + q
- Degli **elastici verticali** che collegano ogni punto sperimentale (xᵢ, yᵢ) alla retta
- Ogni elastico ha costante elastica k (uguale per tutti, per semplicità)

### Configurazione

```
        Punto sperimentale (x₃, y₃)
              ●
              |  ← Elastico (forza verso il basso se y₃ > retta)
              |
    ─────────●──────────  ← Retta y = mx + q
              ↑
              Punto sulla retta: (x₃, mx₃ + q)


        ●  (x₁, y₁)
        |
    ────●───────────


    ────────●───────
            |
            ●  (x₂, y₂)
```

### Forze Applicate

Per ogni punto i-esimo:
- **Distanza verticale** dalla retta: dᵢ = yᵢ - (mxᵢ + q)
  - Se dᵢ > 0: il punto è sopra la retta → elastico tira verso il basso
  - Se dᵢ < 0: il punto è sotto la retta → elastico tira verso l'alto

- **Forza dell'elastico** (Legge di Hooke): Fᵢ = k · dᵢ = k · [yᵢ - (mxᵢ + q)]
  - Forza diretta verticalmente (positiva = verso l'alto)

---

## Condizione 1: Equilibrio Traslazionale (ΣF = 0)

### Interpretazione Fisica

La retta non deve **traslare verticalmente** → la somma di tutte le forze verticali deve essere zero.

### Equazione Matematica

$$\sum_{i=1}^{n} F_i = 0$$

$$\sum_{i=1}^{n} k \cdot [y_i - (mx_i + q)] = 0$$

Semplificando (k ≠ 0):

$$\sum_{i=1}^{n} [y_i - mx_i - q] = 0$$

$$\sum_{i=1}^{n} y_i - m\sum_{i=1}^{n} x_i - nq = 0$$

### Risoluzione per q

$$nq = \sum_{i=1}^{n} y_i - m\sum_{i=1}^{n} x_i$$

$$q = \frac{1}{n}\sum_{i=1}^{n} y_i - m \cdot \frac{1}{n}\sum_{i=1}^{n} x_i$$

Usando le medie:
- $\bar{x} = \frac{1}{n}\sum_{i=1}^{n} x_i$ (media delle x)
- $\bar{y} = \frac{1}{n}\sum_{i=1}^{n} y_i$ (media delle y)

Otteniamo:

$$\boxed{q = \bar{y} - m\bar{x}}$$

**Interpretazione**: La retta passa per il punto medio $(\bar{x}, \bar{y})$ dei dati!

---

## Condizione 2: Equilibrio Rotazionale (ΣM = 0)

### Interpretazione Fisica

La retta non deve **ruotare** → la somma di tutti i momenti deve essere zero.

Scegliamo come **polo** (punto rispetto a cui calcoliamo i momenti) il punto medio $(\bar{x}, 0)$ (proiezione sulla x).

### Momento di ogni Forza

Per il punto i-esimo:
- **Braccio**: distanza orizzontale dal polo = xᵢ - $\bar{x}$
- **Forza**: Fᵢ = k · [yᵢ - (mxᵢ + q)]
- **Momento**: Mᵢ = Fᵢ · (xᵢ - $\bar{x}$) = k · [yᵢ - (mxᵢ + q)] · (xᵢ - $\bar{x}$)

### Equazione Matematica

$$\sum_{i=1}^{n} M_i = 0$$

$$\sum_{i=1}^{n} k \cdot [y_i - (mx_i + q)] \cdot (x_i - \bar{x}) = 0$$

Semplificando (k ≠ 0):

$$\sum_{i=1}^{n} [y_i - mx_i - q] \cdot (x_i - \bar{x}) = 0$$

Espandiamo:

$$\sum_{i=1}^{n} [y_i(x_i - \bar{x}) - mx_i(x_i - \bar{x}) - q(x_i - \bar{x})] = 0$$

Nota: $\sum_{i=1}^{n} (x_i - \bar{x}) = 0$ (proprietà della media)

Quindi il termine con q scompare:

$$\sum_{i=1}^{n} y_i(x_i - \bar{x}) - m\sum_{i=1}^{n} x_i(x_i - \bar{x}) = 0$$

### Risoluzione per m

$$m\sum_{i=1}^{n} x_i(x_i - \bar{x}) = \sum_{i=1}^{n} y_i(x_i - \bar{x})$$

$$m = \frac{\sum_{i=1}^{n} y_i(x_i - \bar{x})}{\sum_{i=1}^{n} x_i(x_i - \bar{x})}$$

Possiamo riscrivere usando:
- Numeratore: $\sum_{i=1}^{n} (x_i - \bar{x})(y_i - \bar{y})$ (covarianza non normalizzata)
- Denominatore: $\sum_{i=1}^{n} (x_i - \bar{x})^2$ (varianza non normalizzata di x)

$$\boxed{m = \frac{\sum_{i=1}^{n} (x_i - \bar{x})(y_i - \bar{y})}{\sum_{i=1}^{n} (x_i - \bar{x})^2}}$$

**Interpretazione**: La pendenza è il rapporto tra covarianza e varianza!

---

## Formule Finali della Regressione Lineare

### Pendenza (m)

$$m = \frac{\sum_{i=1}^{n} (x_i - \bar{x})(y_i - \bar{y})}{\sum_{i=1}^{n} (x_i - \bar{x})^2}$$

Alternativamente:

$$m = \frac{n\sum_{i=1}^{n} x_iy_i - \sum_{i=1}^{n} x_i \sum_{i=1}^{n} y_i}{n\sum_{i=1}^{n} x_i^2 - (\sum_{i=1}^{n} x_i)^2}$$

### Intercetta (q)

$$q = \bar{y} - m\bar{x}$$

Dove:
- $\bar{x} = \frac{1}{n}\sum_{i=1}^{n} x_i$
- $\bar{y} = \frac{1}{n}\sum_{i=1}^{n} y_i$

---

## Esempio Numerico

### Dati Sperimentali

| i | xᵢ | yᵢ |
|---|----|----|
| 1 | 1  | 2  |
| 2 | 2  | 4  |
| 3 | 3  | 5  |
| 4 | 4  | 4  |
| 5 | 5  | 5  |

### Passo 1: Calcolare le Medie

$$\bar{x} = \frac{1 + 2 + 3 + 4 + 5}{5} = \frac{15}{5} = 3$$

$$\bar{y} = \frac{2 + 4 + 5 + 4 + 5}{5} = \frac{20}{5} = 4$$

### Passo 2: Calcolare le Deviazioni e i Prodotti

| i | xᵢ | yᵢ | xᵢ - $\bar{x}$ | yᵢ - $\bar{y}$ | (xᵢ - $\bar{x}$)(yᵢ - $\bar{y}$) | (xᵢ - $\bar{x}$)² |
|---|----|----|----------------|----------------|----------------------------------|-------------------|
| 1 | 1  | 2  | -2             | -2             | 4                                | 4                 |
| 2 | 2  | 4  | -1             | 0              | 0                                | 1                 |
| 3 | 3  | 5  | 0              | 1              | 0                                | 0                 |
| 4 | 4  | 4  | 1              | 0              | 0                                | 1                 |
| 5 | 5  | 5  | 2              | 1              | 2                                | 4                 |
|**Σ**|   |    |                |                | **6**                            | **10**            |

### Passo 3: Calcolare m

$$m = \frac{\sum (x_i - \bar{x})(y_i - \bar{y})}{\sum (x_i - \bar{x})^2} = \frac{6}{10} = 0.6$$

### Passo 4: Calcolare q

$$q = \bar{y} - m\bar{x} = 4 - 0.6 \times 3 = 4 - 1.8 = 2.2$$

### Risultato Finale

$$\boxed{y = 0.6x + 2.2}$$

---

## Collegamento con i Minimi Quadrati

### L'Energia Elastica

L'analogia con gli elastici non è solo didattica: corrisponde a **minimizzare l'energia elastica totale** del sistema.

L'energia potenziale elastica totale è:

$$E = \frac{1}{2}k \sum_{i=1}^{n} d_i^2 = \frac{1}{2}k \sum_{i=1}^{n} [y_i - (mx_i + q)]^2$$

Minimizzare l'energia è equivalente a:

$$\min_{m,q} \sum_{i=1}^{n} [y_i - (mx_i + q)]^2$$

Questo è esattamente il **metodo dei minimi quadrati**!

### Derivazione Analitica (per confronto)

Derivando rispetto a m e q e ponendo le derivate = 0:

$$\frac{\partial E}{\partial q} = 0 \Rightarrow \text{Condizione 1 (ΣF = 0)}$$

$$\frac{\partial E}{\partial m} = 0 \Rightarrow \text{Condizione 2 (ΣM = 0)}$$

Le due condizioni di equilibrio meccanico corrispondono alle condizioni matematiche di minimo!

---

## Attività Didattiche Suggerite

### 1. Dimostrazione alla Lavagna

- Disegnare 5-6 punti sparsi
- Disegnare una retta "a occhio"
- Disegnare gli elastici verticali
- Discutere: "Questa retta è in equilibrio?"
- Far calcolare agli studenti le forze e i momenti

### 2. Laboratorio con Foglio di Calcolo

- Creare tabella con dati sperimentali
- Calcolare medie, deviazioni, prodotti
- Applicare le formule per m e q
- Graficare punti e retta di regressione
- Verificare che passa per $(\bar{x}, \bar{y})$

### 3. Esperimento Fisico (Avanzato)

- Usare una bacchetta rigida su un piano
- Attaccare elastici verticali a pesi posizionati
- Trovare la posizione di equilibrio
- Misurare pendenza e intercetta
- Confrontare con calcolo teorico

### 4. Notebook Python

Implementare:
```python
import numpy as np
import matplotlib.pyplot as plt

# Dati
x = np.array([1, 2, 3, 4, 5])
y = np.array([2, 4, 5, 4, 5])

# Medie
x_mean = np.mean(x)
y_mean = np.mean(y)

# Pendenza
m = np.sum((x - x_mean) * (y - y_mean)) / np.sum((x - x_mean)**2)

# Intercetta
q = y_mean - m * x_mean

# Retta di regressione
y_pred = m * x + q

# Grafico
plt.scatter(x, y, label='Dati')
plt.plot(x, y_pred, 'r-', label=f'y = {m:.2f}x + {q:.2f}')
plt.axhline(y_mean, color='g', linestyle='--', alpha=0.5, label='Media y')
plt.axvline(x_mean, color='b', linestyle='--', alpha=0.5, label='Media x')
plt.plot(x_mean, y_mean, 'ko', markersize=10, label='Punto medio')
plt.legend()
plt.grid()
plt.title('Regressione Lineare')
plt.show()
```

---

## Domande di Verifica

1. Perché la condizione ΣF = 0 garantisce che la retta passi per il punto medio?
2. Cosa rappresenta fisicamente il momento di una forza elastica?
3. Se tutti i punti fossero perfettamente allineati, cosa succederebbe alle forze elastiche?
4. Cosa succede alla pendenza m se scambiamo x e y?
5. Come cambia la regressione se aggiungiamo un punto molto lontano dagli altri (outlier)?

---

## Estensioni Avanzate

### 1. Regressione Pesata
Elastici con costanti k diverse → alcuni punti "contano di più"

### 2. Regressione Polinomiale
Retta curva (parabola) invece di retta → equilibrio più complesso

### 3. Regressione Multipla
Retta in 3D → equilibrio di forze e momenti in più direzioni

### 4. Incertezze Sperimentali
Ogni punto ha una barra d'errore → elastici con k inversamente proporzionale all'errore

---

## Conclusione

L'analogia con gli elastici trasforma la regressione lineare da un concetto astratto matematico a un problema di **meccanica intuitiva**:

- **ΣF = 0** → La retta passa per il centro di massa dei punti
- **ΣM = 0** → La retta è orientata nella direzione di minima energia

Questo approccio:
✅ Usa concetti fisici familiari (Hooke, equilibrio)
✅ Giustifica le formule invece di darle "dall'alto"
✅ Mostra il collegamento tra fisica e statistica
✅ Rende la matematica tangibile e visuale

**Machine Learning = Fisica + Matematica + Dati**
