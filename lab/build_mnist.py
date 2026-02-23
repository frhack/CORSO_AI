#!/usr/bin/env python3
"""Build the MNIST demo: pre-compile mnist_net.dx → JS and embed in HTML template.

Usage:
    python3 dx_01/demo/build_mnist.py

Produces:
    dx_01/demo/mnist_live.html — self-contained HTML file with:
      - Pre-compiled neural network JS (from mnist_net.dx)
      - dx_compiler.js for live recompilation in the browser
      - Base64-encoded MNIST data (balanced subset)
      - Epoch-based training loop with loss curve, accuracy, drawing canvas
"""

import base64
import struct
import os
import sys

DEMO_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(os.path.dirname(DEMO_DIR), '..', 'dx_00', 'data')

TRAIN_N = 10000
TEST_N = 2000


def read_idx_images(path, max_n=None):
    """Read IDX image file → (n, raw_bytes)."""
    with open(path, 'rb') as f:
        magic, n, rows, cols = struct.unpack('>IIII', f.read(16))
        if max_n:
            n = min(n, max_n)
        data = f.read(n * rows * cols)
    return n, data[:n * rows * cols]


def read_idx_labels(path, max_n=None):
    """Read IDX label file → (n, raw_bytes)."""
    with open(path, 'rb') as f:
        magic, n = struct.unpack('>II', f.read(8))
        if max_n:
            n = min(n, max_n)
        data = f.read(n)
    return n, data[:n]


def main():
    # Pre-compile mnist_net.dx → JS
    net_dx = os.path.join(DEMO_DIR, 'mnist_net.dx')
    sys.path.insert(0, os.path.join(DEMO_DIR, '..', '..'))
    from dx_01.dx.__main__ import _emit_for_target, _compile_to_ir

    with open(net_dx) as f:
        source = f.read()
    module = _compile_to_ir(source)
    net_js = _emit_for_target(module, 'js')

    # Read dx_compiler.js
    compiler_js_path = os.path.join(DEMO_DIR, 'dx_compiler.js')
    with open(compiler_js_path) as f:
        compiler_js = f.read()

    # Read MNIST data
    train_n, train_img = read_idx_images(
        os.path.join(DATA_DIR, 'train-images-idx3-ubyte'), TRAIN_N)
    _, train_lbl = read_idx_labels(
        os.path.join(DATA_DIR, 'train-labels-idx1-ubyte'), TRAIN_N)
    test_n, test_img = read_idx_images(
        os.path.join(DATA_DIR, 't10k-images-idx3-ubyte'), TEST_N)
    _, test_lbl = read_idx_labels(
        os.path.join(DATA_DIR, 't10k-labels-idx1-ubyte'), TEST_N)

    train_img_b64 = base64.b64encode(train_img).decode('ascii')
    train_lbl_b64 = base64.b64encode(train_lbl).decode('ascii')
    test_img_b64 = base64.b64encode(test_img).decode('ascii')
    test_lbl_b64 = base64.b64encode(test_lbl).decode('ascii')

    html = HTML_TEMPLATE.replace('__NET_JS__', net_js)
    html = html.replace('__COMPILER_JS__', compiler_js)
    html = html.replace('__TRAIN_IMAGES_B64__', train_img_b64)
    html = html.replace('__TRAIN_LABELS_B64__', train_lbl_b64)
    html = html.replace('__TEST_IMAGES_B64__', test_img_b64)
    html = html.replace('__TEST_LABELS_B64__', test_lbl_b64)
    html = html.replace('__TRAIN_N__', str(train_n))
    html = html.replace('__TEST_N__', str(test_n))

    out_path = os.path.join(DEMO_DIR, 'mnist_live.html')
    with open(out_path, 'w') as f:
        f.write(html)
    size_mb = len(html) / (1024 * 1024)
    print(f'Written {out_path} ({size_mb:.1f} MB)')
    print(f'  Train: {train_n} images, Test: {test_n} images')


HTML_TEMPLATE = r'''<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>dx — MNIST live demo</title>
<style>
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    background: #0d1117; color: #c9d1d9;
    min-height: 100vh;
}
.controls { display: flex; gap: 8px; align-items: center; }
button {
    background: #238636; color: #fff; border: none; border-radius: 6px;
    padding: 7px 20px; font-size: 13px; font-weight: 600; cursor: pointer;
    transition: background 0.15s;
}
button:hover { background: #2ea043; }
button:disabled { background: #21262d; color: #8b949e; cursor: not-allowed; }
button.btn-clear {
    background: #21262d; color: #c9d1d9; border: 1px solid #30363d;
    padding: 5px 14px; font-size: 12px;
}
button.btn-clear:hover { background: #30363d; }
select {
    background: #21262d; color: #c9d1d9; border: 1px solid #30363d;
    border-radius: 6px; padding: 6px 10px; font-size: 12px; cursor: pointer;
}
main {
    display: grid; grid-template-columns: 480px 1fr;
    height: 100vh;
}
@media (max-width: 960px) {
    main { grid-template-columns: 1fr; }
    .code-panel { max-height: 35vh; }
}
.code-panel {
    border-right: 1px solid #21262d; overflow: auto; padding: 0;
    background: #0d1117;
}
.editor-wrap {
    position: relative; width: 100%; height: 100%;
    overflow: hidden;
}
.editor-wrap pre, .editor-wrap textarea {
    font-family: 'SF Mono', 'JetBrains Mono', 'Fira Code', 'Cascadia Code', 'Menlo', 'Consolas', monospace;
    font-size: 13px; line-height: 1.5; padding: 12px 16px;
    tab-size: 4; margin: 0; border: none; outline: none;
    white-space: pre; overflow: auto;
    position: absolute; top: 0; left: 0; width: 100%; height: 100%;
}
.editor-highlight {
    background: #0d1117; color: #c9d1d9; pointer-events: none; z-index: 0;
}
.editor-textarea {
    background: transparent; color: transparent; caret-color: #c9d1d9;
    z-index: 1; resize: none; -webkit-text-fill-color: transparent;
}
.kw { color: #ff7b72; }
.ty { color: #79c0ff; }
.fn { color: #d2a8ff; }
.num { color: #79c0ff; }
.str { color: #a5d6ff; }
.cm { color: #8b949e; font-style: italic; }
.pr { color: #ffa657; font-weight: 600; }
.op { color: #ff7b72; }
.viz-panel {
    padding: 16px; display: flex; flex-direction: column; gap: 12px;
    overflow: auto;
}
.stats-bar {
    display: flex; gap: 24px; padding: 8px 0; flex-wrap: wrap;
}
.stat .label { font-size: 11px; color: #8b949e; text-transform: uppercase; letter-spacing: 1px; }
.stat .value { font-size: 22px; font-weight: 700; color: #58a6ff; font-variant-numeric: tabular-nums; }
.draw-infer-row {
    display: grid; grid-template-columns: auto 1fr; gap: 16px; align-items: start;
}
.card {
    background: #161b22; border: 1px solid #21262d; border-radius: 8px;
    padding: 12px; display: flex; flex-direction: column; gap: 8px;
}
.card-title {
    font-size: 11px; color: #8b949e; text-transform: uppercase;
    letter-spacing: 1px;
}
.draw-canvas {
    border-radius: 4px; background: #000;
    cursor: crosshair; touch-action: none;
    width: 280px; min-width: 280px; max-width: 280px;
    height: 280px; min-height: 280px; max-height: 280px;
}
.card-loss canvas { width: 100%; aspect-ratio: 3/1; display: block; background: #0d1117; border-radius: 4px; }
.prob-bars { display: flex; flex-direction: column; gap: 4px; width: 100%; }
.prob-row {
    display: flex; align-items: center; gap: 8px;
    font-family: 'SF Mono', 'JetBrains Mono', monospace; font-size: 13px;
}
.prob-digit { color: #8b949e; min-width: 16px; text-align: center; font-weight: 700; }
.prob-bar-bg {
    flex: 1; height: 22px; background: #21262d; border-radius: 4px;
    position: relative; overflow: hidden;
}
.prob-bar-fill {
    height: 100%; background: #30363d; border-radius: 4px;
    transition: width 0.15s, background 0.15s;
    min-width: 0;
}
.prob-bar-fill.predicted { background: #238636; }
.prob-bar-fill.predicted.wrong { background: #da3633; }
.prob-pct {
    min-width: 44px; text-align: right; color: #8b949e; font-size: 12px;
}
.predicted-digit {
    font-size: 64px; font-weight: 800; color: #238636;
    text-align: center; line-height: 1; min-height: 80px;
    display: flex; align-items: center; justify-content: center;
    font-family: 'SF Mono', 'JetBrains Mono', monospace;
}
.console-out {
    font-family: 'SF Mono', 'JetBrains Mono', monospace;
    font-size: 11px; line-height: 1.5; color: #8b949e;
    max-height: 100px; overflow-y: auto; white-space: pre;
    padding: 8px; background: #0d1117; border-radius: 4px;
    border: 1px solid #21262d;
}
.js-toggle {
    font-size: 11px; color: #58a6ff; cursor: pointer; user-select: none;
    padding: 4px 0;
}
.js-toggle:hover { text-decoration: underline; }
.js-output {
    font-family: 'SF Mono', 'JetBrains Mono', monospace;
    font-size: 11px; line-height: 1.4; color: #7ee787;
    max-height: 200px; overflow-y: auto; white-space: pre;
    padding: 8px; background: #0d1117; border-radius: 4px;
    border: 1px solid #21262d; display: none;
}
</style>
</head>
<body>

<main>
    <section class="code-panel">
        <div class="editor-wrap">
            <pre class="editor-highlight" id="editor-highlight"></pre>
            <textarea class="editor-textarea" id="source-editor" spellcheck="false"></textarea>
        </div>
    </section>

    <section class="viz-panel">
        <div class="controls">
            <button id="btn-train">Train</button>
            <button id="btn-stop" disabled>Stop</button>
            <select id="speed">
                <option value="10">10 samples/frame</option>
                <option value="50" selected>50 samples/frame</option>
                <option value="200">200 samples/frame</option>
                <option value="500">500 samples/frame</option>
            </select>
        </div>

        <div class="stats-bar">
            <div class="stat">
                <div class="label">Epoch</div>
                <div class="value" id="stat-epoch">0</div>
            </div>
            <div class="stat">
                <div class="label">Loss</div>
                <div class="value" id="stat-loss">&mdash;</div>
            </div>
            <div class="stat">
                <div class="label">Accuracy</div>
                <div class="value" id="stat-acc">&mdash;</div>
            </div>
            <div class="stat">
                <div class="label">Samples</div>
                <div class="value" id="stat-samples">0</div>
            </div>
            <div class="stat">
                <div class="label">Params</div>
                <div class="value" id="stat-params">&mdash;</div>
            </div>
            <div class="stat">
                <div class="label">Status</div>
                <div class="value" id="stat-status" style="color:#8b949e">Ready</div>
            </div>
        </div>

        <div class="draw-infer-row">
            <div class="card" style="align-items:start;width:304px;">
                <div class="card-title">Draw a digit</div>
                <canvas id="cv-draw" width="280" height="280" style="width:280px;height:280px;border-radius:4px;background:#000;cursor:crosshair;touch-action:none;display:block;"></canvas>
                <div style="display:flex;gap:8px;">
                    <button class="btn-clear" id="btn-predict">Predict</button>
                    <button class="btn-clear" id="btn-clear">Clear</button>
                </div>
                <div class="card-title" style="margin-top:8px;">I drew:</div>
                <div id="digit-selector" style="display:flex;gap:4px;flex-wrap:wrap;"></div>
            </div>
            <div class="card" style="flex:1">
                <div class="card-title">Prediction</div>
                <div class="predicted-digit" id="predicted-digit">&mdash;</div>
                <div class="prob-bars" id="prob-bars"></div>
            </div>
        </div>

        <div class="card card-loss">
            <div class="card-title">Loss Curve</div>
            <canvas id="cv-loss"></canvas>
        </div>

        <div class="card">
            <div class="card-title">Console</div>
            <div class="js-toggle" id="js-toggle">&#9654; Show generated JS</div>
            <div class="js-output" id="js-output"></div>
            <div class="console-out" id="console-out"></div>
        </div>
    </section>
</main>

<script>
// ================================================================
// DX SOURCE CODE
// ================================================================
const DX_SOURCE = `-- MNIST neural network in dx
-- Two-layer FC: 784 -> 128 -> 10

type Net
    w1 : Tensor[128 784]  -- weights: 128 x 784
    b1 : Vec[128]          -- bias per hidden unit
    w2 : Tensor[10 128]   -- weights: 10 x 128
    b2 : Vec[10]           -- bias per class

fun Net'apply(x: Vec[784]) -> Vec[10]
    relu(me'w1 o x + me'b1)
    softmax(me'w2 o it + me'b2)

net : Net(0.02)
data : mnist()
lr : 0.01

for epoch in 0..30
    for (x y) in data
        pred : net(x)
        loss : -log(pred[y])
        g : d loss d net
        net : net - lr * g
    print("epoch {epoch} done")`;

// ================================================================
// SYNTAX HIGHLIGHTING
// ================================================================
function highlightDx(code) {
    let h = code.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    return h.split('\n').map(line => {
        const cmIdx = line.indexOf('--');
        let cp = cmIdx >= 0 ? line.slice(0, cmIdx) : line;
        let cm = cmIdx >= 0 ? '<span class="cm">' + line.slice(cmIdx) + '</span>' : '';
        cp = cp.replace(/("(?:[^"\\]|\\.)*?")/g, '<span class="str">$1</span>');
        cp = cp.replace(/\b(type|fun|for|if|in|print|return)\b/g, '<span class="kw">$1</span>');
        cp = cp.replace(/\b(Net|Vec|Tensor|Float|Int|String)\b/g, '<span class="ty">$1</span>');
        cp = cp.replace(/\b(it|me)\b/g, '<span class="pr">$1</span>');
        cp = cp.replace(/\b(relu|softmax|sigmoid|gelu)\b/g, '<span class="fn">$1</span>');
        cp = cp.replace(/ o /g, ' <span class="op">o</span> ');
        cp = cp.replace(/\b(\d+\.?\d*)\b/g, '<span class="num">$1</span>');
        return cp + cm;
    }).join('\n');
}

function syncHighlight() {
    const ta = document.getElementById('source-editor');
    const pre = document.getElementById('editor-highlight');
    pre.innerHTML = highlightDx(ta.value) + '\n';
}

function syncScroll() {
    const ta = document.getElementById('source-editor');
    const pre = document.getElementById('editor-highlight');
    pre.scrollTop = ta.scrollTop;
    pre.scrollLeft = ta.scrollLeft;
}

// ================================================================
// PRE-COMPILED NEURAL NETWORK
// ================================================================
__NET_JS__

// ================================================================
// MNIST DATA (base64)
// ================================================================
const N_TRAIN = __TRAIN_N__;
const N_TEST = __TEST_N__;
const B64_TRAIN_IMG = "__TRAIN_IMAGES_B64__";
const B64_TRAIN_LBL = "__TRAIN_LABELS_B64__";
const B64_TEST_IMG = "__TEST_IMAGES_B64__";
const B64_TEST_LBL = "__TEST_LABELS_B64__";

function decodeMnist(b64img, b64lbl, n) {
    const raw = Uint8Array.from(atob(b64img), c => c.charCodeAt(0));
    const labels = Uint8Array.from(atob(b64lbl), c => c.charCodeAt(0));
    const images = new Float32Array(n * 784);
    for (let i = 0; i < raw.length; i++) images[i] = raw[i] / 255.0;
    return { images, labels, n };
}

// ================================================================
// DEMO STATE
// ================================================================
let net, grad, cache, predBuf, dPred;
let epoch, sampleIdx, epochLosses, running, consoleLines;
let N_PARAMS, LR = 0.01;
let trainData, testData;
let shuffled;
let totalLoss, correct, totalSamples = 0;
let trueLabel = null;
let MAX_EPOCH = 30;

// ================================================================
// DRAWING CANVAS
// ================================================================
let drawing = false;
let lastX, lastY;

function setupDrawCanvas() {
    const cv = document.getElementById('cv-draw');
    const ctx = cv.getContext('2d');
    ctx.fillStyle = '#000';
    ctx.fillRect(0, 0, 280, 280);
    ctx.lineCap = 'round';
    ctx.lineJoin = 'round';
    ctx.strokeStyle = '#fff';
    ctx.lineWidth = 20;

    function getPos(e) {
        const rect = cv.getBoundingClientRect();
        const scaleX = 280 / rect.width;
        const scaleY = 280 / rect.height;
        if (e.touches) {
            return [
                (e.touches[0].clientX - rect.left) * scaleX,
                (e.touches[0].clientY - rect.top) * scaleY
            ];
        }
        return [
            (e.clientX - rect.left) * scaleX,
            (e.clientY - rect.top) * scaleY
        ];
    }

    function startDraw(e) {
        e.preventDefault();
        drawing = true;
        [lastX, lastY] = getPos(e);
    }

    function moveDraw(e) {
        if (!drawing) return;
        e.preventDefault();
        const [x, y] = getPos(e);
        ctx.beginPath();
        ctx.moveTo(lastX, lastY);
        ctx.lineTo(x, y);
        ctx.stroke();
        lastX = x; lastY = y;
    }

    function endDraw(e) {
        if (!drawing) return;
        drawing = false;
        runInference();
    }

    cv.addEventListener('mousedown', startDraw);
    cv.addEventListener('mousemove', moveDraw);
    cv.addEventListener('mouseup', endDraw);
    cv.addEventListener('mouseleave', endDraw);
    cv.addEventListener('touchstart', startDraw, { passive: false });
    cv.addEventListener('touchmove', moveDraw, { passive: false });
    cv.addEventListener('touchend', endDraw);

    document.getElementById('btn-predict').addEventListener('click', () => {
        runInference();
    });

    document.getElementById('btn-clear').addEventListener('click', () => {
        ctx.fillStyle = '#000';
        ctx.fillRect(0, 0, 280, 280);
        ctx.strokeStyle = '#fff';
        ctx.lineWidth = 20;
        ctx.lineCap = 'round';
        ctx.lineJoin = 'round';
        clearPrediction();
    });
}

function downsampleCanvas() {
    const cv = document.getElementById('cv-draw');
    const ctx = cv.getContext('2d');
    const W = 280;
    const imgData = ctx.getImageData(0, 0, W, W);
    const pixels = imgData.data;

    // 1. Find bounding box
    let minR = W, maxR = 0, minC = W, maxC = 0;
    let found = false;
    for (let r = 0; r < W; r++) {
        for (let c = 0; c < W; c++) {
            if (pixels[(r * W + c) * 4] > 10) {
                if (r < minR) minR = r;
                if (r > maxR) maxR = r;
                if (c < minC) minC = c;
                if (c > maxC) maxC = c;
                found = true;
            }
        }
    }
    if (!found) return new Float32Array(784);

    // 2. Crop
    const bw = maxR - minR + 1;
    const bh = maxC - minC + 1;

    // 3. Fit into 20x20 (MNIST convention), work at 10x resolution
    const fitPx = 200;
    const scale = fitPx / Math.max(bw, bh);
    const newW = Math.max(1, Math.round(bh * scale));
    const newH = Math.max(1, Math.round(bw * scale));

    const cropCv = document.createElement('canvas');
    cropCv.width = bh; cropCv.height = bw;
    const cropCtx = cropCv.getContext('2d');
    cropCtx.putImageData(ctx.getImageData(minC, minR, bh, bw), 0, 0);

    const resCv = document.createElement('canvas');
    resCv.width = newW; resCv.height = newH;
    const resCtx = resCv.getContext('2d');
    resCtx.imageSmoothingEnabled = true;
    resCtx.imageSmoothingQuality = 'high';
    resCtx.drawImage(cropCv, 0, 0, newW, newH);
    const resized = resCtx.getImageData(0, 0, newW, newH).data;

    // 4. Center of mass
    let massX = 0, massY = 0, totalMass = 0;
    for (let r = 0; r < newH; r++) {
        for (let c = 0; c < newW; c++) {
            const v = resized[(r * newW + c) * 4];
            massX += c * v;
            massY += r * v;
            totalMass += v;
        }
    }
    const comX = totalMass > 0 ? massX / totalMass : newW / 2;
    const comY = totalMass > 0 ? massY / totalMass : newH / 2;

    // 5. Place into 280x280 centered on (140,140) by center of mass
    const placeCv = document.createElement('canvas');
    placeCv.width = W; placeCv.height = W;
    const placeCtx = placeCv.getContext('2d');
    const offX = Math.round(140 - comX);
    const offY = Math.round(140 - comY);
    placeCtx.drawImage(resCv, offX, offY);

    // 6. Downsample 280->28 by averaging 10x10 blocks
    const placed = placeCtx.getImageData(0, 0, W, W).data;
    const out = new Float32Array(784);
    for (let row = 0; row < 28; row++) {
        for (let col = 0; col < 28; col++) {
            let sum = 0;
            for (let dy = 0; dy < 10; dy++) {
                for (let dx = 0; dx < 10; dx++) {
                    sum += placed[((row * 10 + dy) * W + (col * 10 + dx)) * 4];
                }
            }
            out[row * 28 + col] = sum / (100 * 255.0);
        }
    }
    return out;
}

function runInference() {
    if (typeof NetForward !== 'function') return;
    const input = downsampleCanvas();
    const inferPred = new Float32Array(10);
    const inferCache = createNetCache();
    NetForward(net, input, inferPred, inferCache);
    updateProbBars(inferPred);
}

function clearPrediction() {
    document.getElementById('predicted-digit').textContent = '\u2014';
    document.getElementById('predicted-digit').style.color = '#8b949e';
    const bars = document.querySelectorAll('.prob-bar-fill');
    bars.forEach(b => { b.style.width = '0%'; b.classList.remove('predicted'); b.classList.remove('wrong'); });
    document.querySelectorAll('.prob-pct').forEach(p => { p.textContent = ''; });
    trueLabel = null;
    const sel = document.getElementById('digit-selector');
    if (sel) sel.querySelectorAll('button').forEach(b => { b.style.background = '#21262d'; b.style.color = '#8b949e'; });
}

function updateProbBars(probs) {
    let maxIdx = 0;
    for (let i = 1; i < 10; i++) if (probs[i] > probs[maxIdx]) maxIdx = i;

    const wrong = trueLabel !== null && maxIdx !== trueLabel;
    const color = wrong ? '#da3633' : '#238636';
    document.getElementById('predicted-digit').textContent = maxIdx;
    document.getElementById('predicted-digit').style.color = color;

    for (let i = 0; i < 10; i++) {
        const pct = (probs[i] * 100).toFixed(1);
        const fill = document.getElementById('bar-' + i);
        const pctEl = document.getElementById('pct-' + i);
        fill.style.width = (probs[i] * 100) + '%';
        pctEl.textContent = pct + '%';
        if (i === maxIdx) {
            fill.classList.add('predicted');
            if (wrong) fill.classList.add('wrong'); else fill.classList.remove('wrong');
        } else {
            fill.classList.remove('predicted');
            fill.classList.remove('wrong');
        }
    }
}

// ================================================================
// PROBABILITY BARS INIT
// ================================================================
function initProbBars() {
    const container = document.getElementById('prob-bars');
    container.innerHTML = '';
    for (let i = 0; i < 10; i++) {
        const row = document.createElement('div');
        row.className = 'prob-row';
        row.innerHTML =
            `<span class="prob-digit">${i}</span>` +
            `<div class="prob-bar-bg"><div class="prob-bar-fill" id="bar-${i}"></div></div>` +
            `<span class="prob-pct" id="pct-${i}"></span>`;
        container.appendChild(row);
    }
}

function initDigitSelector() {
    const sel = document.getElementById('digit-selector');
    for (let i = 0; i < 10; i++) {
        const btn = document.createElement('button');
        btn.textContent = i;
        btn.style.cssText = 'width:28px;height:28px;padding:0;font-size:13px;font-weight:700;border-radius:4px;cursor:pointer;background:#21262d;color:#8b949e;border:1px solid #30363d;';
        btn.addEventListener('click', () => {
            trueLabel = i;
            sel.querySelectorAll('button').forEach(b => { b.style.background = '#21262d'; b.style.color = '#8b949e'; });
            btn.style.background = '#388bfd'; btn.style.color = '#fff';
            runInference();
        });
        sel.appendChild(btn);
    }
}

// ================================================================
// LOSS CURVE
// ================================================================
function setupCanvas(canvas) {
    const dpr = window.devicePixelRatio || 1;
    const rect = canvas.getBoundingClientRect();
    canvas.width = Math.round(rect.width * dpr);
    canvas.height = Math.round(rect.height * dpr);
    const ctx = canvas.getContext('2d');
    ctx.scale(dpr, dpr);
    return { ctx, w: rect.width, h: rect.height };
}

function drawLossCurve() {
    const cvEl = document.getElementById('cv-loss');
    const { ctx, w, h } = setupCanvas(cvEl);
    const pad = { top: 16, right: 16, bottom: 28, left: 44 };
    const pw = w - pad.left - pad.right;
    const ph = h - pad.top - pad.bottom;

    ctx.clearRect(0, 0, w, h);

    if (epochLosses.length < 2) {
        ctx.fillStyle = '#8b949e';
        ctx.font = '12px -apple-system, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('Waiting for training...', w / 2, h / 2);
        return;
    }

    const maxLoss = Math.max(...epochLosses) * 1.05;

    ctx.strokeStyle = '#21262d';
    ctx.lineWidth = 1;
    for (let i = 0; i <= 4; i++) {
        const y = pad.top + (ph * i / 4);
        ctx.beginPath(); ctx.moveTo(pad.left, y); ctx.lineTo(pad.left + pw, y); ctx.stroke();
    }

    ctx.beginPath();
    for (let i = 0; i < epochLosses.length; i++) {
        const x = pad.left + (i / (epochLosses.length - 1)) * pw;
        const y = pad.top + (1 - epochLosses[i] / maxLoss) * ph;
        if (i === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
    }
    ctx.strokeStyle = '#22c55e';
    ctx.lineWidth = 2;
    ctx.stroke();

    const lastX_ = pad.left + pw;
    ctx.lineTo(lastX_, pad.top + ph);
    ctx.lineTo(pad.left, pad.top + ph);
    ctx.closePath();
    const grd = ctx.createLinearGradient(0, pad.top, 0, pad.top + ph);
    grd.addColorStop(0, 'rgba(34, 197, 94, 0.2)');
    grd.addColorStop(1, 'rgba(34, 197, 94, 0.0)');
    ctx.fillStyle = grd;
    ctx.fill();

    ctx.fillStyle = '#8b949e';
    ctx.font = '10px -apple-system, sans-serif';
    ctx.textAlign = 'right';
    for (let i = 0; i <= 4; i++) {
        const val = maxLoss * (1 - i / 4);
        ctx.fillText(val.toFixed(2), pad.left - 6, pad.top + ph * i / 4 + 3);
    }
    ctx.textAlign = 'center';
    ctx.fillText('epoch', w / 2, h - 4);
    ctx.textAlign = 'left';
    ctx.fillText('0', pad.left, h - 10);
    ctx.textAlign = 'right';
    ctx.fillText(epoch.toString(), pad.left + pw, h - 10);
}

// ================================================================
// STATS
// ================================================================
function updateStats() {
    document.getElementById('stat-epoch').textContent = epoch;
    document.getElementById('stat-samples').textContent = totalSamples.toLocaleString();
    if (epochLosses.length > 0) {
        document.getElementById('stat-loss').textContent = epochLosses[epochLosses.length - 1].toFixed(4);
    }
}

function logLine(text) {
    consoleLines.push(text);
    if (consoleLines.length > 50) consoleLines.shift();
    document.getElementById('console-out').textContent = consoleLines.join('\n');
    const el = document.getElementById('console-out');
    el.scrollTop = el.scrollHeight;
}

// ================================================================
// TRAINING
// ================================================================
function shuffleArray(arr) {
    for (let i = arr.length - 1; i > 0; i--) {
        const j = Math.random() * (i + 1) | 0;
        const tmp = arr[i]; arr[i] = arr[j]; arr[j] = tmp;
    }
}

function initTrainingState() {
    RngSeed(42);
    net = createNet(0.02);
    grad = createNetGrad();
    cache = createNetCache();
    predBuf = new Float32Array(10);
    dPred = new Float32Array(10);
    epoch = 0; sampleIdx = 0; epochLosses = []; consoleLines = [];
    totalLoss = 0; correct = 0; totalSamples = 0;

    N_PARAMS = net._buf.length;
    document.getElementById('stat-params').textContent = N_PARAMS.toLocaleString();

    shuffled = new Array(N_TRAIN);
    for (let i = 0; i < N_TRAIN; i++) shuffled[i] = i;
    shuffleArray(shuffled);
}

function computeTestAccuracy() {
    let c = 0;
    const p = new Float32Array(10);
    const tc = createNetCache();
    for (let i = 0; i < N_TEST; i++) {
        const x = testData.images.subarray(i * 784, (i + 1) * 784);
        const y = testData.labels[i] | 0;
        NetForward(net, x, p, tc);
        let maxK = 0;
        for (let k = 1; k < 10; k++) if (p[k] > p[maxK]) maxK = k;
        if (maxK === y) c++;
    }
    return c / N_TEST;
}

function animate() {
    if (!running) return;
    const samplesPerFrame = parseInt(document.getElementById('speed').value);

    for (let i = 0; i < samplesPerFrame && sampleIdx < N_TRAIN; i++, sampleIdx++) {
        const idx = shuffled[sampleIdx];
        const x = trainData.images.subarray(idx * 784, (idx + 1) * 784);
        const y = trainData.labels[idx] | 0;
        NetForward(net, x, predBuf, cache);
        const loss = -Math.log(Math.max(predBuf[y], 1e-10));
        // Correct gradient: cross-entropy backward through softmax
        CrossEntropyBackward(predBuf, y, dPred, 10);
        grad._buf.fill(0);
        NetBackward(net, x, cache, dPred, grad, null);
        for (let k = 0; k < N_PARAMS; k++) net._buf[k] -= LR * grad._buf[k];
        totalLoss += loss;
        let maxK = 0;
        for (let k = 1; k < 10; k++) if (predBuf[k] > predBuf[maxK]) maxK = k;
        if (maxK === y) correct++;
        totalSamples++;
    }

    // End of epoch
    if (sampleIdx >= N_TRAIN) {
        const avgLoss = totalLoss / N_TRAIN;
        const trainAcc = correct / N_TRAIN;
        epochLosses.push(avgLoss);

        const testAcc = computeTestAccuracy();
        logLine(`epoch ${epoch}  loss ${avgLoss.toFixed(4)}  train_acc ${(trainAcc * 100).toFixed(1)}%  test_acc ${(testAcc * 100).toFixed(1)}%`);
        document.getElementById('stat-acc').textContent = (testAcc * 100).toFixed(1) + '%';

        epoch++;
        sampleIdx = 0;
        totalLoss = 0;
        correct = 0;
        shuffleArray(shuffled);
    }

    drawLossCurve();
    updateStats();

    if (!running || epoch >= MAX_EPOCH) {
        running = false;
        document.getElementById('btn-train').textContent = 'Train';
        document.getElementById('btn-train').disabled = false;
        document.getElementById('btn-stop').disabled = true;
        if (epoch >= MAX_EPOCH) {
            document.getElementById('stat-status').textContent = 'Done';
            document.getElementById('stat-status').style.color = '#22c55e';
            logLine('\nTraining complete. Draw a digit to test!');
        } else {
            document.getElementById('stat-status').textContent = 'Stopped';
            document.getElementById('stat-status').style.color = '#f97316';
        }
    } else {
        document.getElementById('stat-status').textContent = 'Training';
        document.getElementById('stat-status').style.color = '#eab308';
        requestAnimationFrame(animate);
    }
}

// ================================================================
// COMPILE + START
// ================================================================
function extractNetDef(source) {
    // Extract type + fun blocks only (skip training loop code)
    const lines = source.split('\n');
    let end = lines.length, foundFun = false;
    for (let i = 0; i < lines.length; i++) {
        const tr = lines[i].trim();
        if (tr.startsWith('fun ')) { foundFun = true; continue; }
        if (foundFun && tr !== '' && !lines[i].startsWith('    ') && !lines[i].startsWith('\t') && !tr.startsWith('--')) {
            end = i; break;
        }
    }
    return lines.slice(0, end).join('\n').trim();
}

function compileAndStart() {
    const fullSource = document.getElementById('source-editor').value;
    const netDef = extractNetDef(fullSource);
    logLine('Compiling dx \u2192 JS...');
    const t0 = performance.now();

    let jsCode;
    try {
        jsCode = dx_compile_js(netDef);
    } catch (e) {
        logLine('Compilation error: ' + e.message);
        document.getElementById('stat-status').textContent = 'Error';
        document.getElementById('stat-status').style.color = '#f85149';
        document.getElementById('btn-train').textContent = 'Train';
        document.getElementById('btn-train').disabled = false;
        return;
    }

    const dt = (performance.now() - t0).toFixed(0);
    logLine(`Compiled in ${dt}ms`);
    document.getElementById('js-output').textContent = jsCode;

    // Extract type name for function naming
    const typeMatch = netDef.match(/^type\s+(\w+)/m);
    const tn = typeMatch ? typeMatch[1] : 'Net';

    // Wrap in IIFE to avoid class redeclaration conflicts
    const exports = [
        'create' + tn, 'create' + tn + 'Cache', 'create' + tn + 'Grad',
        tn + 'Forward', tn + 'Backward', 'RngSeed', 'CrossEntropyBackward'
    ].map(f => 'window.' + f + '=' + f + ';').join('');
    const wrapped = '(function(){' + jsCode + '\n' + exports + '})();';

    try {
        const s = document.createElement('script');
        s.textContent = wrapped;
        document.head.appendChild(s);
    } catch (e) {
        logLine('JS eval error: ' + e.message);
        document.getElementById('stat-status').textContent = 'Error';
        document.getElementById('stat-status').style.color = '#f85149';
        document.getElementById('btn-train').textContent = 'Train';
        document.getElementById('btn-train').disabled = false;
        return;
    }

    logLine(`Model: ${createNet(0.02)._buf.length} params, lr=${LR}`);
    logLine(`Training on ${N_TRAIN} samples\n`);

    trainData = decodeMnist(B64_TRAIN_IMG, B64_TRAIN_LBL, N_TRAIN);
    testData = decodeMnist(B64_TEST_IMG, B64_TEST_LBL, N_TEST);

    initTrainingState();
    running = true;
    document.getElementById('btn-train').textContent = 'Training...';
    document.getElementById('btn-train').disabled = true;
    document.getElementById('btn-stop').disabled = false;
    document.getElementById('stat-status').textContent = 'Training';
    document.getElementById('stat-status').style.color = '#eab308';
    requestAnimationFrame(animate);
}

// ================================================================
// INIT
// ================================================================
function init() {
    initProbBars();
    initDigitSelector();
    setupDrawCanvas();

    // Decode data upfront
    trainData = decodeMnist(B64_TRAIN_IMG, B64_TRAIN_LBL, N_TRAIN);
    testData = decodeMnist(B64_TEST_IMG, B64_TEST_LBL, N_TEST);

    // Pre-init network
    RngSeed(42);
    net = createNet(0.02);
    cache = createNetCache();
    grad = createNetGrad();
    predBuf = new Float32Array(10);
    dPred = new Float32Array(10);
    epoch = 0; sampleIdx = 0; epochLosses = []; consoleLines = [];
    totalLoss = 0; correct = 0; totalSamples = 0;
    N_PARAMS = net._buf.length;
    document.getElementById('stat-params').textContent = N_PARAMS.toLocaleString();
    shuffled = new Array(N_TRAIN);
    for (let i = 0; i < N_TRAIN; i++) shuffled[i] = i;

    // Render source code
    const ta = document.getElementById('source-editor');
    ta.value = DX_SOURCE;
    syncHighlight();
    ta.addEventListener('input', syncHighlight);
    ta.addEventListener('scroll', syncScroll);
    ta.addEventListener('keydown', (e) => {
        if (e.key === 'Tab') {
            e.preventDefault();
            const start = ta.selectionStart;
            const end = ta.selectionEnd;
            ta.value = ta.value.substring(0, start) + '    ' + ta.value.substring(end);
            ta.selectionStart = ta.selectionEnd = start + 4;
            syncHighlight();
        }
    });

    // JS toggle
    document.getElementById('js-toggle').addEventListener('click', () => {
        const el = document.getElementById('js-output');
        const toggle = document.getElementById('js-toggle');
        if (el.style.display === 'none' || !el.style.display) {
            el.style.display = 'block';
            toggle.innerHTML = '&#9660; Hide generated JS';
        } else {
            el.style.display = 'none';
            toggle.innerHTML = '&#9654; Show generated JS';
        }
    });

    document.getElementById('stat-status').textContent = 'Ready';
    document.getElementById('stat-status').style.color = '#8b949e';

    // Train button
    document.getElementById('btn-train').addEventListener('click', () => {
        if (running) return;
        document.getElementById('stat-loss').textContent = '\u2014';
        document.getElementById('stat-acc').textContent = '\u2014';
        document.getElementById('stat-epoch').textContent = '0';
        document.getElementById('stat-status').textContent = 'Compiling...';
        document.getElementById('stat-status').style.color = '#d2a8ff';
        document.getElementById('console-out').textContent = '';
        consoleLines = [];
        clearPrediction();
        setTimeout(compileAndStart, 20);
    });

    // Stop button
    document.getElementById('btn-stop').addEventListener('click', () => {
        running = false;
        document.getElementById('btn-train').textContent = 'Train';
        document.getElementById('btn-train').disabled = false;
        document.getElementById('btn-stop').disabled = true;
        document.getElementById('stat-status').textContent = 'Stopped';
        document.getElementById('stat-status').style.color = '#f97316';
    });

    // Resize
    window.addEventListener('resize', () => {
        if (epochLosses && epochLosses.length > 0) drawLossCurve();
    });
}

document.addEventListener('DOMContentLoaded', init);
</script>

<!-- Bootstrap compiler for live recompilation -->
<script>
(function(){
__COMPILER_JS__
window.dx_compile_js = dx_compile_js;
})();
</script>
</body>
</html>
'''

if __name__ == '__main__':
    main()
