#!/usr/bin/env python3
"""Build demo/logic.html with dx compiler modules embedded for Pyodide."""

import json
import os

DEMO_DIR = os.path.dirname(os.path.abspath(__file__))
DX_DIR = os.path.join(os.path.dirname(DEMO_DIR), "dx")

MODULES = [
    "__init__.py",
    "lexer.py",
    "ast_nodes.py",
    "parser.py",
    "typechecker.py",
    "ir.py",
    "ir_lower.py",
    "ir_passes.py",
    "emit_js.py",
]


def read_module(name: str) -> str:
    path = os.path.join(DX_DIR, name)
    with open(path, "r") as f:
        return f.read()


def build_modules_js() -> str:
    """Build JS object literal with module contents."""
    entries = []
    for name in MODULES:
        content = read_module(name)
        entries.append(f"    {json.dumps(name)}: {json.dumps(content)}")
    return "const DX_MODULES = {\n" + ",\n".join(entries) + "\n};"


HTML_TEMPLATE = r"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>dx — logic gates demo</title>
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
select {
    background: #21262d; color: #c9d1d9; border: 1px solid #30363d;
    border-radius: 6px; padding: 6px 10px; font-size: 12px; cursor: pointer;
}
main {
    display: grid; grid-template-columns: 520px 1fr;
    height: 100vh;
}
@media (max-width: 900px) {
    main { grid-template-columns: 1fr; }
    .code-panel { max-height: 40vh; }
}
.code-panel {
    border-right: 1px solid #21262d; overflow: auto; padding: 0;
    background: #0d1117;
}
.editor-wrap {
    position: relative; width: 100%; height: calc(100% - 40px);
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
    display: flex; gap: 32px; padding: 8px 0;
}
.stat .label { font-size: 11px; color: #8b949e; text-transform: uppercase; letter-spacing: 1px; }
.stat .value { font-size: 22px; font-weight: 700; color: #58a6ff; font-variant-numeric: tabular-nums; }
.canvas-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.card {
    background: #161b22; border: 1px solid #21262d; border-radius: 8px;
    padding: 12px; display: flex; flex-direction: column; gap: 8px;
}
.card-title {
    font-size: 11px; color: #8b949e; text-transform: uppercase;
    letter-spacing: 1px;
}
canvas { border-radius: 4px; width: 75%; aspect-ratio: 1; display: block; background: #0d1117; }
.card-loss canvas { aspect-ratio: 4/3; }
.predictions {
    display: grid; grid-template-columns: 1fr 1fr; gap: 6px 24px;
    font-family: 'SF Mono', 'JetBrains Mono', monospace; font-size: 13px;
}
.pred-row { display: flex; align-items: center; gap: 8px; }
.pred-input { color: #8b949e; min-width: 70px; }
.pred-value { font-weight: 700; min-width: 55px; transition: color 0.3s; }
.pred-exp { color: #8b949e; font-size: 11px; }
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
            <button id="btn-train" disabled>Loading compiler...</button>
            <button id="btn-stop" disabled>Stop</button>
            <select id="speed">
                <option value="5">5 ep/frame</option>
                <option value="20" selected>20 ep/frame</option>
                <option value="100">100 ep/frame</option>
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
                <div class="label">Params</div>
                <div class="value" id="stat-params">&mdash;</div>
            </div>
            <div class="stat">
                <div class="label">Status</div>
                <div class="value" id="stat-status" style="color:#8b949e">Loading...</div>
            </div>
        </div>

        <div class="canvas-row">
            <div class="card">
                <div class="card-title">Decision Boundary</div>
                <canvas id="cv-boundary"></canvas>
            </div>
            <div class="card card-loss">
                <div class="card-title">Loss Curve</div>
                <canvas id="cv-loss"></canvas>
            </div>
        </div>

        <div class="card">
            <div class="card-title">3D Output Surface <span style="font-size:9px;color:#8b949e;text-transform:none;letter-spacing:0">(drag to rotate)</span></div>
            <canvas id="cv-3d" style="width:100%;aspect-ratio:2/1;cursor:grab"></canvas>
        </div>

        <div class="card">
            <div class="card-title">Predictions</div>
            <div class="predictions" id="predictions">
                <div class="pred-row"><span class="pred-input">0, 0</span><span class="pred-value" id="p00">&mdash;</span><span class="pred-exp" id="e00">(exp: 0)</span></div>
                <div class="pred-row"><span class="pred-input">0, 1</span><span class="pred-value" id="p01">&mdash;</span><span class="pred-exp" id="e01">(exp: 0)</span></div>
                <div class="pred-row"><span class="pred-input">1, 0</span><span class="pred-value" id="p10">&mdash;</span><span class="pred-exp" id="e10">(exp: 1)</span></div>
                <div class="pred-row"><span class="pred-input">1, 1</span><span class="pred-value" id="p11">&mdash;</span><span class="pred-exp" id="e11">(exp: 0)</span></div>
            </div>
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
const DX_SOURCE = `type Net
    w1 : Tensor[8 2]
    b1 : Vec[8]
    w2 : Tensor[1 8]
    b2 : Vec[1]

fun Net'apply(x: Vec[2]) -> Vec[1]
    sigmoid(w1 o x + b1)
    sigmoid(w2 o it + b2)

net : Net(nn'init_normal(1.0))
lr : 0.5

X : [ [0 0]
      [0 1]
      [1 0]
      [1 1] ]

Y : [ [0]
      [0]
      [1]
      [0] ]

for epoch in 0..10000
    total_loss : 0.0
    for (x y) in X'zip(Y)
        pred : net(x)
        diff : pred - y
        loss : diff . diff
        grads : d loss / d net'params
        net'params : net'params - lr * grads
        total_loss : total_loss + loss
    if epoch % 2000 = 0
        print("epoch {epoch}  loss {total_loss}")

for (x y) in X'zip(Y)
    pred : net(x)
    print("{pred}")`;

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
        cp = cp.replace(/\b(type|fun|for|if|in|print|arena|let|return)\b/g, '<span class="kw">$1</span>');
        cp = cp.replace(/\b(Net|Vec|Tensor|Float|Int|String)\b/g, '<span class="ty">$1</span>');
        cp = cp.replace(/\b(it|me)\b/g, '<span class="pr">$1</span>');
        cp = cp.replace(/\b(nn|mse|sigmoid|relu|softmax|gelu)\b/g, '<span class="fn">$1</span>');
        cp = cp.replace(/\bd\s+(\w+)\s*\/\s*d\s+(\w+)/g, '<span class="op">d</span> $1 / <span class="op">d</span> $2');
        cp = cp.replace(/ \. /g, ' \u00b7 ');
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
// EMBEDDED DX COMPILER MODULES
// ================================================================
%%DX_MODULES%%

// ================================================================
// PYODIDE SETUP
// ================================================================
let pyodide = null;

async function initPyodide() {
    pyodide = await loadPyodide();
    pyodide.FS.mkdir('/dx');
    for (const [name, code] of Object.entries(DX_MODULES))
        pyodide.FS.writeFile('/dx/' + name, code);
    pyodide.runPython('import sys; sys.path.insert(0, "/")');
}

// ================================================================
// COMPILE DX -> JS via Pyodide
// ================================================================
function compileDx(source) {
    pyodide.globals.set('__dx_source', source);
    return pyodide.runPython(`
from dx.parser import parse
from dx.ir_lower import IRLower
from dx.ir_passes import run_all_passes
from dx.emit_js import emit_js

program = parse(__dx_source)
lowerer = IRLower(program)
module = lowerer.lower()
module = run_all_passes(module, lowerer)
emit_js(module, lowerer)
`);
}

// ================================================================
// TRAINING DATA (dynamic — parsed from source)
// ================================================================
const INPUTS = [[0,0],[0,1],[1,0],[1,1]];
let expected = [0, 0, 1, 0];
let TRAIN = buildTrain();

function buildTrain() {
    return INPUTS.map((xy, i) => ({
        x: new Float32Array(xy),
        y: new Float32Array([expected[i]])
    }));
}

function parseYFromSource(source) {
    const yIdx = source.search(/\bY\s*:/);
    if (yIdx < 0) return;
    const rest = source.slice(yIdx);
    let depth = 0, start = -1, end = -1;
    for (let i = 0; i < rest.length; i++) {
        if (rest[i] === '[') { if (start < 0) start = i; depth++; }
        else if (rest[i] === ']') { depth--; if (depth === 0) { end = i; break; } }
    }
    if (end < 0) return;
    const inner = rest.slice(start, end + 1);
    const nums = [...inner.matchAll(/\[\s*(\d+\.?\d*)\s*\]/g)];
    if (nums.length >= 4) {
        expected = nums.slice(0, 4).map(m => Number(m[1]));
        TRAIN = buildTrain();
    }
}

function getDataPoints() {
    return INPUTS.map((xy, i) => [xy[0], xy[1], expected[i]]);
}

// ================================================================
// DEMO STATE
// ================================================================
let net, grad, cache, predCache, pred, dPred;
let epoch, losses, running, consoleLines;
let N_PARAMS, LR;

function initState() {
    net = createNet(); grad = createNetGrad(); cache = createNetCache();
    predCache = createNetCache();
    pred = new Float32Array(1); dPred = new Float32Array(1);
    epoch = 0; losses = []; consoleLines = [];
    RngSeed(42);
    NetInit(net, 1.0);
}

function trainOneEpoch() {
    let totalLoss = 0;
    for (const { x, y } of TRAIN) {
        NetForward(net, x, pred, cache);
        const loss = SseForward(pred, y, 1);
        SseBackward(pred, y, dPred, 1);
        grad._buf.fill(0);
        NetBackward(net, x, cache, dPred, grad, null);
        SgdStep(net._buf, grad._buf, N_PARAMS, LR);
        totalLoss += loss;
    }
    return totalLoss;
}

function predict(a, b) {
    const inp = new Float32Array([a, b]);
    const out = new Float32Array(1);
    NetForward(net, inp, out, predCache);
    return out[0];
}

// ================================================================
// VISUALIZATION
// ================================================================
const GRID = 80;
const offCv = document.createElement('canvas');
offCv.width = GRID; offCv.height = GRID;
const offCtx = offCv.getContext('2d');

function setupCanvas(canvas) {
    const dpr = window.devicePixelRatio || 1;
    const rect = canvas.getBoundingClientRect();
    canvas.width = Math.round(rect.width * dpr);
    canvas.height = Math.round(rect.height * dpr);
    const ctx = canvas.getContext('2d');
    ctx.scale(dpr, dpr);
    return { ctx, w: rect.width, h: rect.height };
}

function drawBoundary() {
    const cvEl = document.getElementById('cv-boundary');
    const { ctx, w, h } = setupCanvas(cvEl);
    const imgData = offCtx.createImageData(GRID, GRID);
    const inp = new Float32Array(2);
    const out = new Float32Array(1);
    const c = createNetCache();
    const vals = new Float32Array(GRID * GRID);

    for (let gy = 0; gy < GRID; gy++) {
        for (let gx = 0; gx < GRID; gx++) {
            inp[0] = gx / (GRID - 1);
            inp[1] = 1 - gy / (GRID - 1);
            NetForward(net, inp, out, c);
            vals[gy * GRID + gx] = out[0];
            const v = Math.max(0, Math.min(1, out[0]));
            const idx = (gy * GRID + gx) * 4;
            imgData.data[idx]     = Math.round(59  + v * 180);
            imgData.data[idx + 1] = Math.round(130 - v * 62);
            imgData.data[idx + 2] = Math.round(246 - v * 178);
            imgData.data[idx + 3] = 255;
        }
    }
    offCtx.putImageData(imgData, 0, 0);
    const margin = 24;
    ctx.fillStyle = '#0d1117';
    ctx.fillRect(0, 0, w, h);
    ctx.imageSmoothingEnabled = true;
    ctx.imageSmoothingQuality = 'high';
    ctx.drawImage(offCv, margin, margin, w - 2 * margin, h - 2 * margin);

    const toX = x1 => margin + x1 * (w - 2 * margin);
    const toY = x2 => (h - margin) - x2 * (h - 2 * margin);

    // Decision boundary contour (output = 0.5, marching squares)
    ctx.strokeStyle = 'rgba(255, 255, 255, 0.7)';
    ctx.lineWidth = 1.5;
    ctx.setLineDash([6, 4]);
    ctx.beginPath();
    for (let gy = 0; gy < GRID - 1; gy++) {
        for (let gx = 0; gx < GRID - 1; gx++) {
            const v00 = vals[gy * GRID + gx];
            const v10 = vals[gy * GRID + gx + 1];
            const v01 = vals[(gy+1) * GRID + gx];
            const v11 = vals[(gy+1) * GRID + gx + 1];
            const pts = [];
            if ((v00 - 0.5) * (v10 - 0.5) < 0) {
                const t = (0.5 - v00) / (v10 - v00);
                pts.push([(gx + t) / (GRID-1), 1 - gy / (GRID-1)]);
            }
            if ((v10 - 0.5) * (v11 - 0.5) < 0) {
                const t = (0.5 - v10) / (v11 - v10);
                pts.push([(gx+1) / (GRID-1), 1 - (gy + t) / (GRID-1)]);
            }
            if ((v01 - 0.5) * (v11 - 0.5) < 0) {
                const t = (0.5 - v01) / (v11 - v01);
                pts.push([(gx + t) / (GRID-1), 1 - (gy+1) / (GRID-1)]);
            }
            if ((v00 - 0.5) * (v01 - 0.5) < 0) {
                const t = (0.5 - v00) / (v01 - v00);
                pts.push([gx / (GRID-1), 1 - (gy + t) / (GRID-1)]);
            }
            if (pts.length >= 2) {
                ctx.moveTo(toX(pts[0][0]), toY(pts[0][1]));
                ctx.lineTo(toX(pts[1][0]), toY(pts[1][1]));
            }
        }
    }
    ctx.stroke();
    ctx.setLineDash([]);

    const dp = getDataPoints();
    for (const [a, b, label] of dp) {
        const px = toX(a);
        const py = toY(b);
        ctx.beginPath();
        ctx.arc(px, py, 11, 0, Math.PI * 2);
        ctx.fillStyle = 'rgba(0,0,0,0.4)';
        ctx.fill();
        ctx.beginPath();
        ctx.arc(px, py, 9, 0, Math.PI * 2);
        ctx.fillStyle = label ? '#ef4444' : '#3b82f6';
        ctx.fill();
        ctx.strokeStyle = '#fff';
        ctx.lineWidth = 2.5;
        ctx.stroke();
        ctx.fillStyle = '#fff';
        ctx.font = 'bold 10px -apple-system, sans-serif';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(label.toString(), px, py);
    }

    ctx.fillStyle = '#8b949e';
    ctx.font = '10px -apple-system, sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText('x\u2081', w / 2, h - 4);
    ctx.save();
    ctx.translate(10, h / 2);
    ctx.rotate(-Math.PI / 2);
    ctx.fillText('x\u2082', 0, 0);
    ctx.restore();
}

// ================================================================
// 3D OUTPUT SURFACE
// ================================================================
const GRID3D = 30;
let az3d = 2.3, el3d = 0.55;
let drag3d = false, mx3d = 0, my3d = 0;

function draw3D() {
    const cvEl = document.getElementById('cv-3d');
    if (!cvEl || typeof createNetCache !== 'function' || !net) return;
    const { ctx, w, h } = setupCanvas(cvEl);
    ctx.clearRect(0, 0, w, h);

    const inp = new Float32Array(2);
    const out = new Float32Array(1);
    const c3 = createNetCache();
    const G = GRID3D;

    const cosA = Math.cos(az3d), sinA = Math.sin(az3d);
    const cosE = Math.cos(el3d), sinE = Math.sin(el3d);
    const scale = Math.min(w, h) * 0.7;

    function proj(x, y, z) {
        const rx = x * cosA - y * sinA;
        const ry = x * sinA + y * cosA;
        const ry2 = ry * cosE - z * sinE;
        const rz = ry * sinE + z * cosE;
        return [w / 2 + rx * scale, h / 2 - ry2 * scale, rz];
    }

    const vals = new Float32Array((G + 1) * (G + 1));
    for (let j = 0; j <= G; j++) {
        for (let i = 0; i <= G; i++) {
            inp[0] = i / G; inp[1] = j / G;
            NetForward(net, inp, out, c3);
            vals[j * (G + 1) + i] = out[0];
        }
    }

    const quads = [];
    for (let j = 0; j < G; j++) {
        for (let i = 0; i < G; i++) {
            const idx = [j*(G+1)+i, j*(G+1)+i+1, (j+1)*(G+1)+i+1, (j+1)*(G+1)+i];
            const corners = idx.map(k => {
                const gi = k % (G + 1), gj = Math.floor(k / (G + 1));
                return proj(gi / G - 0.5, gj / G - 0.5, vals[k] * 0.8 - 0.4);
            });
            const avgZ = (corners[0][2] + corners[1][2] + corners[2][2] + corners[3][2]) / 4;
            const avgV = (vals[idx[0]] + vals[idx[1]] + vals[idx[2]] + vals[idx[3]]) / 4;
            quads.push({ corners, avgZ, avgV, type: 's' });
        }
    }

    const PG = 6;
    for (let j = 0; j < PG; j++) {
        for (let i = 0; i < PG; i++) {
            const x0 = i / PG - 0.5, x1 = (i + 1) / PG - 0.5;
            const y0 = j / PG - 0.5, y1 = (j + 1) / PG - 0.5;
            const zp = 0.5 * 0.8 - 0.4;
            const corners = [[x0,y0,zp],[x1,y0,zp],[x1,y1,zp],[x0,y1,zp]].map(([x,y,z]) => proj(x,y,z));
            const avgZ = (corners[0][2] + corners[1][2] + corners[2][2] + corners[3][2]) / 4;
            quads.push({ corners, avgZ, avgV: 0.5, type: 'p' });
        }
    }

    quads.sort((a, b) => a.avgZ - b.avgZ);

    for (const q of quads) {
        ctx.beginPath();
        ctx.moveTo(q.corners[0][0], q.corners[0][1]);
        for (let k = 1; k < 4; k++) ctx.lineTo(q.corners[k][0], q.corners[k][1]);
        ctx.closePath();
        if (q.type === 'p') {
            ctx.fillStyle = 'rgba(255, 255, 255, 0.05)';
            ctx.fill();
            ctx.strokeStyle = 'rgba(255, 255, 255, 0.15)';
            ctx.lineWidth = 0.5;
            ctx.stroke();
        } else {
            const r = Math.round(59 + q.avgV * 180);
            const g = Math.round(130 - q.avgV * 62);
            const b = Math.round(246 - q.avgV * 178);
            ctx.fillStyle = `rgb(${r},${g},${b})`;
            ctx.fill();
            ctx.strokeStyle = 'rgba(0,0,0,0.12)';
            ctx.lineWidth = 0.3;
            ctx.stroke();
        }
    }

    const o = proj(-0.5, -0.5, -0.4);
    const ax = proj(0.55, -0.5, -0.4);
    const ay = proj(-0.5, 0.55, -0.4);
    const az = proj(-0.5, -0.5, 0.5);
    ctx.strokeStyle = 'rgba(255,255,255,0.2)';
    ctx.lineWidth = 1;
    ctx.beginPath(); ctx.moveTo(o[0], o[1]); ctx.lineTo(ax[0], ax[1]); ctx.stroke();
    ctx.beginPath(); ctx.moveTo(o[0], o[1]); ctx.lineTo(ay[0], ay[1]); ctx.stroke();
    ctx.beginPath(); ctx.moveTo(o[0], o[1]); ctx.lineTo(az[0], az[1]); ctx.stroke();
    ctx.fillStyle = '#8b949e';
    ctx.font = '11px -apple-system, sans-serif';
    ctx.fillText('x\u2081', ax[0] + 4, ax[1] + 2);
    ctx.fillText('x\u2082', ay[0] + 4, ay[1] + 2);
    ctx.fillText('out', az[0] + 4, az[1] - 2);

    const dp = getDataPoints();
    for (const [a, b, label] of dp) {
        inp[0] = a; inp[1] = b;
        NetForward(net, inp, out, c3);
        const p = proj(a - 0.5, b - 0.5, out[0] * 0.8 - 0.4);
        ctx.beginPath();
        ctx.arc(p[0], p[1], 7, 0, Math.PI * 2);
        ctx.fillStyle = label ? '#ef4444' : '#3b82f6';
        ctx.fill();
        ctx.strokeStyle = '#fff';
        ctx.lineWidth = 2;
        ctx.stroke();
        ctx.fillStyle = '#fff';
        ctx.font = 'bold 9px -apple-system, sans-serif';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(label.toString(), p[0], p[1]);
    }
}

function drawLossCurve() {
    const cvEl = document.getElementById('cv-loss');
    const { ctx, w, h } = setupCanvas(cvEl);
    const pad = { top: 16, right: 16, bottom: 28, left: 44 };
    const pw = w - pad.left - pad.right;
    const ph = h - pad.top - pad.bottom;

    ctx.clearRect(0, 0, w, h);

    if (losses.length < 2) {
        ctx.fillStyle = '#8b949e';
        ctx.font = '12px -apple-system, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('Waiting for training...', w / 2, h / 2);
        return;
    }

    const maxLoss = Math.max(...losses) * 1.05;

    ctx.strokeStyle = '#21262d';
    ctx.lineWidth = 1;
    for (let i = 0; i <= 4; i++) {
        const y = pad.top + (ph * i / 4);
        ctx.beginPath(); ctx.moveTo(pad.left, y); ctx.lineTo(pad.left + pw, y); ctx.stroke();
    }

    ctx.beginPath();
    for (let i = 0; i < losses.length; i++) {
        const x = pad.left + (i / (losses.length - 1)) * pw;
        const y = pad.top + (1 - losses[i] / maxLoss) * ph;
        if (i === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
    }
    ctx.strokeStyle = '#22c55e';
    ctx.lineWidth = 2;
    ctx.stroke();

    const lastX = pad.left + pw;
    ctx.lineTo(lastX, pad.top + ph);
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

function updatePredictions() {
    const ids = ['p00', 'p01', 'p10', 'p11'];
    for (let i = 0; i < 4; i++) {
        const [a, b] = INPUTS[i];
        const val = predict(a, b);
        const el = document.getElementById(ids[i]);
        const err = Math.abs(val - expected[i]);
        el.textContent = val.toFixed(4);
        el.style.color = err < 0.1 ? '#22c55e' : err < 0.3 ? '#eab308' : '#8b949e';
    }
}

function updateExpectedLabels() {
    const ids = ['e00', 'e01', 'e10', 'e11'];
    ids.forEach((id, i) => {
        document.getElementById(id).textContent = `(exp: ${expected[i]})`;
    });
}

function updateStats(loss) {
    document.getElementById('stat-epoch').textContent = epoch;
    if (loss !== undefined) {
        document.getElementById('stat-loss').textContent = loss.toFixed(4);
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
// ANIMATION LOOP
// ================================================================
let MAX_EPOCH = 10000;
let LOG_INTERVAL = 2000;

function parseSourceParams(source) {
    const mEpoch = source.match(/for\s+\w+\s+in\s+\d+\.\.(\d+)/);
    if (mEpoch) MAX_EPOCH = parseInt(mEpoch[1]);
    const mLog = source.match(/if\s+\w+\s+%\s+(\d+)/);
    if (mLog) LOG_INTERVAL = parseInt(mLog[1]);
}

function animate() {
    if (!running) return;
    const speed = parseInt(document.getElementById('speed').value);
    let lastLoss = 0;

    for (let i = 0; i < speed && epoch < MAX_EPOCH; i++) {
        lastLoss = trainOneEpoch();
        if (epoch % 10 === 0) losses.push(lastLoss);
        if (epoch % LOG_INTERVAL === 0) {
            logLine(`epoch ${epoch}  loss ${lastLoss.toFixed(4)}`);
        }
        epoch++;
    }

    drawBoundary();
    draw3D();
    drawLossCurve();
    updatePredictions();
    updateStats(lastLoss);

    if (!running || epoch >= MAX_EPOCH) {
        running = false;
        document.getElementById('btn-train').textContent = 'Train';
        document.getElementById('btn-train').disabled = false;
        document.getElementById('btn-stop').disabled = true;
        document.getElementById('stat-status').textContent = epoch >= MAX_EPOCH ? 'Done' : 'Stopped';
        document.getElementById('stat-status').style.color = epoch >= MAX_EPOCH ? '#22c55e' : '#f97316';
        logLine(`\nPredictions:`);
        const dp = getDataPoints();
        for (const [a, b, exp] of dp) {
            logLine(`  f(${a}, ${b}) = ${predict(a, b).toFixed(4)}  (expected ${exp})`);
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
function compileAndStart() {
    const source = document.getElementById('source-editor').value;
    parseSourceParams(source);
    parseYFromSource(source);
    updateExpectedLabels();

    logLine('Compiling dx \u2192 JS via Pyodide...');
    const t0 = performance.now();

    let jsCode;
    try {
        jsCode = compileDx(source);
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

    // Strip main() and "use strict", convert let/const to var so
    // re-compilation works (re-declaring let/const is a SyntaxError)
    const lib = jsCode
        .replace(/"use strict";\s*\n?/, '')
        .replace(/\nmain\(\);\s*$/, '')
        .replace(/^let /gm, 'var ')
        .replace(/^const /gm, 'var ');

    try {
        (0, eval)(lib);
    } catch (e) {
        logLine('JS eval error: ' + e.message);
        document.getElementById('stat-status').textContent = 'Error';
        document.getElementById('stat-status').style.color = '#f85149';
        document.getElementById('btn-train').textContent = 'Train';
        document.getElementById('btn-train').disabled = false;
        return;
    }

    const tmpNet = createNet();
    N_PARAMS = tmpNet._buf.length;
    document.getElementById('stat-params').textContent = N_PARAMS;

    // Extract LR from dx source (not from JS — JS may use a variable)
    const src = document.getElementById('source-editor').value;
    const lrMatch = src.match(/\blr\s*:\s*([\d.]+(?:e[+-]?\d+)?)/i);
    LR = lrMatch ? parseFloat(lrMatch[1]) : 0.5;

    logLine(`Model: ${N_PARAMS} params, lr=${LR}`);
    logLine(`Y = [${expected.join(', ')}]\n`);

    initState();
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
async function init() {
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

    try {
        await initPyodide();
    } catch (e) {
        document.getElementById('btn-train').textContent = 'Error loading Pyodide';
        document.getElementById('stat-status').textContent = 'Error';
        document.getElementById('stat-status').style.color = '#f85149';
        console.error('Pyodide init failed:', e);
        return;
    }

    document.getElementById('btn-train').textContent = 'Train';
    document.getElementById('btn-train').disabled = false;
    document.getElementById('stat-status').textContent = 'Ready';
    document.getElementById('stat-status').style.color = '#8b949e';

    document.getElementById('btn-train').addEventListener('click', () => {
        if (running) return;
        document.getElementById('stat-loss').textContent = '\u2014';
        document.getElementById('stat-epoch').textContent = '0';
        document.getElementById('stat-status').textContent = 'Compiling...';
        document.getElementById('stat-status').style.color = '#d2a8ff';
        document.getElementById('console-out').textContent = '';
        consoleLines = [];
        const ids = ['p00', 'p01', 'p10', 'p11'];
        ids.forEach(id => {
            const el = document.getElementById(id);
            el.textContent = '\u2014';
            el.style.color = '#8b949e';
        });
        setTimeout(compileAndStart, 20);
    });

    document.getElementById('btn-stop').addEventListener('click', () => {
        running = false;
        document.getElementById('btn-train').textContent = 'Train';
        document.getElementById('btn-train').disabled = false;
        document.getElementById('btn-stop').disabled = true;
        document.getElementById('stat-status').textContent = 'Stopped';
        document.getElementById('stat-status').style.color = '#f97316';
    });

    const cv3d = document.getElementById('cv-3d');
    cv3d.addEventListener('mousedown', (e) => {
        drag3d = true; mx3d = e.clientX; my3d = e.clientY;
        cv3d.style.cursor = 'grabbing';
    });
    window.addEventListener('mousemove', (e) => {
        if (!drag3d) return;
        az3d += (e.clientX - mx3d) * 0.01;
        el3d = Math.max(-1.2, Math.min(1.2, el3d + (e.clientY - my3d) * 0.01));
        mx3d = e.clientX; my3d = e.clientY;
        if (!running) draw3D();
    });
    window.addEventListener('mouseup', () => {
        drag3d = false;
        cv3d.style.cursor = 'grab';
    });

    window.addEventListener('resize', () => {
        if (typeof createNetCache === 'function' && net) {
            drawBoundary();
            draw3D();
            drawLossCurve();
        }
    });
}

document.addEventListener('DOMContentLoaded', init);
</script>
<script src="https://cdn.jsdelivr.net/pyodide/v0.27.0/full/pyodide.js"></script>

</body>
</html>"""


def main():
    modules_js = build_modules_js()

    html = HTML_TEMPLATE.replace("%%DX_MODULES%%", modules_js)
    out_path = os.path.join(DEMO_DIR, "logic.html")
    with open(out_path, "w") as f:
        f.write(html)
    print(f"Generated {out_path}")
    size_kb = os.path.getsize(out_path) / 1024
    print(f"Size: {size_kb:.1f} KB")


if __name__ == "__main__":
    main()
