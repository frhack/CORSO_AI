import numpy as np
from sklearn.datasets import fetch_openml
from sklearn.metrics.pairwise import cosine_similarity

# Carica MNIST
X, y = fetch_openml("mnist_784", version=1, return_X_y=True, as_frame=False, parser="liac-arff")
y = y.astype(int)

# Split standard: 60k train, 10k test
X_train, X_test = X[:60000], X[60000:]
y_train, y_test = y[:60000], y[60000:]

# Calcola la media per ogni cifra
means = np.array([X_train[y_train == d].mean(axis=0) for d in range(10)])

# Classifica con cosine similarity
sims = cosine_similarity(X_test, means)  # (10000, 10)
y_pred = sims.argmax(axis=1)

# Accuratezza
acc = (y_pred == y_test).mean()
print(f"Accuratezza: {acc:.4f} ({(y_pred == y_test).sum()}/{len(y_test)})")
