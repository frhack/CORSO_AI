#!/usr/bin/env python3
"""Build demo/vacanze_live.html with dx compiler modules embedded for Pyodide."""

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
<html lang="it">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>dx — Preferenze Vacanziere (cosine similarity)</title>
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
main {
    display: grid; grid-template-columns: 480px 1fr;
    height: 100vh;
}
@media (max-width: 900px) {
    main { grid-template-columns: 1fr; }
    .code-panel { max-height: 40vh; }
}
.code-panel {
    border-right: 1px solid #21262d; overflow: auto; padding: 0;
    background: #0d1117; display: flex; flex-direction: column;
}
.panel-header {
    font-size: 12px; color: #8b949e; text-transform: uppercase;
    letter-spacing: 1px; padding: 12px 16px 8px;
    border-bottom: 1px solid #21262d; background: #161b22;
    display: flex; align-items: center; gap: 10px;
}
.panel-header .title { flex: 1; }
.badge {
    display: inline-block; padding: 2px 8px; border-radius: 10px;
    font-size: 10px; font-weight: 600; letter-spacing: 0.5px;
}
.badge-live { background: #1f6feb33; color: #58a6ff; }
.editor-wrap {
    position: relative; width: 100%; flex: 1;
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
.set { color: #ffa657; }
.viz-panel {
    padding: 16px; display: flex; flex-direction: column; gap: 12px;
    overflow: auto;
}
.stats-bar {
    display: flex; gap: 32px; padding: 8px 0;
}
.stat .label { font-size: 11px; color: #8b949e; text-transform: uppercase; letter-spacing: 1px; }
.stat .value { font-size: 18px; font-weight: 700; color: #58a6ff; font-variant-numeric: tabular-nums; }
.card {
    background: #161b22; border: 1px solid #21262d; border-radius: 8px;
    padding: 12px; display: flex; flex-direction: column; gap: 8px;
}
.card-title {
    font-size: 11px; color: #8b949e; text-transform: uppercase;
    letter-spacing: 1px;
}
.heatmap-wrap {
    position: relative; width: 100%; overflow: auto;
}
#cv-heatmap { display: block; }
.tooltip {
    position: fixed; background: #161b22; border: 1px solid #30363d;
    border-radius: 6px; padding: 8px 12px; font-size: 12px;
    pointer-events: none; z-index: 100; display: none;
    font-family: 'SF Mono', 'JetBrains Mono', monospace;
    box-shadow: 0 4px 12px rgba(0,0,0,0.4);
}
.tooltip .t-names { color: #58a6ff; font-weight: 600; }
.tooltip .t-val { color: #7ee787; font-size: 14px; }
.tooltip .t-prefs { color: #8b949e; font-size: 11px; margin-top: 4px; }
.console-out {
    font-family: 'SF Mono', 'JetBrains Mono', monospace;
    font-size: 11px; line-height: 1.5; color: #8b949e;
    max-height: 250px; overflow-y: auto; white-space: pre;
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
.legend {
    display: flex; align-items: center; gap: 8px; font-size: 11px; color: #8b949e;
    margin-top: 4px;
}
.legend-bar {
    width: 120px; height: 10px; border-radius: 3px;
    background: linear-gradient(to right, #1a1e2e, #1e3a5f, #3b82f6, #f59e0b, #ef4444);
}
.ranking-list {
    display: grid; grid-template-columns: 1fr 1fr; gap: 4px 20px;
    font-family: 'SF Mono', 'JetBrains Mono', monospace; font-size: 12px;
    max-height: 200px; overflow-y: auto;
}
.rank-row { display: flex; gap: 8px; padding: 2px 0; }
.rank-pos { color: #8b949e; min-width: 24px; }
.rank-names { color: #c9d1d9; flex: 1; }
.rank-val { font-weight: 600; min-width: 48px; text-align: right; }
</style>
</head>
<body>

<div class="tooltip" id="tooltip">
    <div class="t-names" id="tip-names"></div>
    <div class="t-val" id="tip-val"></div>
    <div class="t-prefs" id="tip-prefs"></div>
</div>

<main>
    <section class="code-panel">
        <div class="panel-header">
            <span class="title">vacanze_set.dx</span>
            <span class="badge badge-live">LIVE</span>
        </div>
        <div class="editor-wrap">
            <pre class="editor-highlight" id="editor-highlight"></pre>
            <textarea class="editor-textarea" id="source-editor" spellcheck="false"></textarea>
        </div>
    </section>

    <section class="viz-panel">
        <div class="controls">
            <button id="btn-run" disabled>Caricamento compilatore...</button>
        </div>

        <div class="stats-bar">
            <div class="stat">
                <div class="label">Persone</div>
                <div class="value" id="stat-persons">&mdash;</div>
            </div>
            <div class="stat">
                <div class="label">Coppie</div>
                <div class="value" id="stat-pairs">&mdash;</div>
            </div>
            <div class="stat">
                <div class="label">Tempo</div>
                <div class="value" id="stat-time">&mdash;</div>
            </div>
            <div class="stat">
                <div class="label">Stato</div>
                <div class="value" id="stat-status" style="color:#8b949e">Caricamento...</div>
            </div>
        </div>

        <div class="card">
            <div class="card-title">Matrice di Similarit&agrave; (cosine similarity)</div>
            <div class="legend">
                <span>0.0</span>
                <div class="legend-bar"></div>
                <span>1.0</span>
            </div>
            <div class="heatmap-wrap">
                <canvas id="cv-heatmap"></canvas>
            </div>
        </div>

        <div class="card">
            <div class="card-title">Classifica Coppie Pi&ugrave; Simili</div>
            <div class="ranking-list" id="ranking"></div>
        </div>

        <div class="card">
            <div class="card-title">Console</div>
            <div class="js-toggle" id="js-toggle">&#9654; Mostra JS generato</div>
            <div class="js-output" id="js-output"></div>
            <div class="console-out" id="console-out"></div>
        </div>
    </section>
</main>

<script>
// ================================================================
// DX SOURCE
// ================================================================
const DX_SOURCE = `-- Cosine Similarity demo: preferenze vacanziere (versione set + choose)
-- Ogni persona esprime preferenza da 1 a 10 per: [mare, montagna, citta, campagna]

mario : [9 2 3 1]
luigi : [8 3 2 2]
peach : [2 1 9 3]
toad : [3 9 1 8]
yoshi : [7 4 5 2]
bowser : [1 8 2 9]
daisy : [9 1 8 1]
rosalina : [3 2 9 7]
wario : [5 5 5 5]
waluigi : [1 9 3 7]
birdo : [8 2 7 1]
kamek : [2 7 1 9]
shyguy : [4 6 3 8]
boo : [1 3 8 6]
koopa : [6 8 2 4]
toadette : [7 3 6 3]
pauline : [3 1 10 2]
nabbit : [5 7 4 6]
spike : [2 9 1 7]
chunky : [10 1 1 1]

persons : {mario, luigi, peach, toad, yoshi, bowser, daisy, rosalina, wario, waluigi, birdo, kamek, shyguy, boo, koopa, toadette, pauline, nabbit, spike, chunky}

print("=== Preferenze Vacanziere (cosine similarity) ===")
print("  [mare, montagna, citta, campagna]")

for (person1, person2) in persons'choose(2)
  sim : person1 ~ person2
  print("{person1''name} ~ {person2''name} = {sim}")`;

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
        cp = cp.replace(/\b(type|fun|for|if|in|print|let|return)\b/g, '<span class="kw">$1</span>');
        cp = cp.replace(/\b(Vec|Tensor|Float|Int|String|Set)\b/g, '<span class="ty">$1</span>');
        cp = cp.replace(/\b(it|me)\b/g, '<span class="pr">$1</span>');
        cp = cp.replace(/\b(nn|mse|sigmoid|relu|softmax|gelu)\b/g, '<span class="fn">$1</span>');
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
// STATE
// ================================================================
let consoleLines = [];
let simData = [];     // [{name1, name2, sim}, ...]
let personNames = []; // ordered names from output

function logLine(text) {
    consoleLines.push(text);
    if (consoleLines.length > 500) consoleLines.shift();
    const el = document.getElementById('console-out');
    el.textContent = consoleLines.join('\n');
    el.scrollTop = el.scrollHeight;
}

// ================================================================
// HEATMAP VISUALIZATION
// ================================================================
const COLORS = [
    [26, 30, 46],     // 0.0 - dark blue
    [30, 58, 95],     // 0.25
    [59, 130, 246],   // 0.5 - blue
    [245, 158, 11],   // 0.75 - amber
    [239, 68, 68],    // 1.0 - red
];

function simColor(v) {
    v = Math.max(0, Math.min(1, v));
    const t = v * (COLORS.length - 1);
    const i = Math.min(Math.floor(t), COLORS.length - 2);
    const f = t - i;
    const c0 = COLORS[i], c1 = COLORS[i + 1];
    return [
        Math.round(c0[0] + (c1[0] - c0[0]) * f),
        Math.round(c0[1] + (c1[1] - c0[1]) * f),
        Math.round(c0[2] + (c1[2] - c0[2]) * f),
    ];
}

function drawHeatmap() {
    if (personNames.length === 0) return;

    const N = personNames.length;
    const cellSize = Math.max(22, Math.min(36, Math.floor(600 / N)));
    const labelW = 72;
    const labelH = 72;
    const w = labelW + N * cellSize;
    const h = labelH + N * cellSize;

    const cv = document.getElementById('cv-heatmap');
    const dpr = window.devicePixelRatio || 1;
    cv.width = Math.round(w * dpr);
    cv.height = Math.round(h * dpr);
    cv.style.width = w + 'px';
    cv.style.height = h + 'px';
    const ctx = cv.getContext('2d');
    ctx.scale(dpr, dpr);

    // Build similarity matrix
    const matrix = Array.from({ length: N }, () => new Float32Array(N));
    for (let i = 0; i < N; i++) matrix[i][i] = 1.0;
    for (const { name1, name2, sim } of simData) {
        const i = personNames.indexOf(name1);
        const j = personNames.indexOf(name2);
        if (i >= 0 && j >= 0) {
            matrix[i][j] = sim;
            matrix[j][i] = sim;
        }
    }

    // Clear
    ctx.fillStyle = '#0d1117';
    ctx.fillRect(0, 0, w, h);

    // Draw cells
    for (let row = 0; row < N; row++) {
        for (let col = 0; col < N; col++) {
            const v = matrix[row][col];
            const [r, g, b] = simColor(v);
            const x = labelW + col * cellSize;
            const y = labelH + row * cellSize;
            ctx.fillStyle = `rgb(${r},${g},${b})`;
            ctx.fillRect(x + 0.5, y + 0.5, cellSize - 1, cellSize - 1);

            // Show value in cell if cells are big enough
            if (cellSize >= 30) {
                ctx.fillStyle = v > 0.6 ? '#000' : '#fff';
                ctx.font = `${Math.max(8, cellSize / 4)}px -apple-system, sans-serif`;
                ctx.textAlign = 'center';
                ctx.textBaseline = 'middle';
                ctx.fillText(v.toFixed(2), x + cellSize / 2, y + cellSize / 2);
            }
        }
    }

    // Row labels (left)
    ctx.fillStyle = '#c9d1d9';
    ctx.font = '11px -apple-system, sans-serif';
    ctx.textAlign = 'right';
    ctx.textBaseline = 'middle';
    for (let i = 0; i < N; i++) {
        ctx.fillText(personNames[i], labelW - 6, labelH + i * cellSize + cellSize / 2);
    }

    // Column labels (top, rotated)
    ctx.textAlign = 'left';
    for (let i = 0; i < N; i++) {
        ctx.save();
        ctx.translate(labelW + i * cellSize + cellSize / 2, labelH - 6);
        ctx.rotate(-Math.PI / 3);
        ctx.fillText(personNames[i], 0, 0);
        ctx.restore();
    }

    // Store matrix for tooltip
    cv._matrix = matrix;
    cv._cellSize = cellSize;
    cv._labelW = labelW;
    cv._labelH = labelH;
    cv._N = N;
}

// ================================================================
// TOOLTIP
// ================================================================
function setupTooltip() {
    const cv = document.getElementById('cv-heatmap');
    const tip = document.getElementById('tooltip');

    // Parse preferences from source
    function getPrefs() {
        const src = document.getElementById('source-editor').value;
        const prefs = {};
        const cats = ['mare', 'montagna', 'citta', 'campagna'];
        for (const line of src.split('\n')) {
            const m = line.match(/^(\w+)\s*:\s*\[([^\]]+)\]/);
            if (m) {
                const vals = m[2].trim().split(/\s+/).map(Number);
                prefs[m[1]] = vals;
            }
        }
        return { prefs, cats };
    }

    cv.addEventListener('mousemove', (e) => {
        if (!cv._matrix) return;
        const rect = cv.getBoundingClientRect();
        const mx = e.clientX - rect.left;
        const my = e.clientY - rect.top;
        const col = Math.floor((mx - cv._labelW) / cv._cellSize);
        const row = Math.floor((my - cv._labelH) / cv._cellSize);

        if (col >= 0 && col < cv._N && row >= 0 && row < cv._N) {
            const n1 = personNames[row];
            const n2 = personNames[col];
            const val = cv._matrix[row][col];
            const { prefs, cats } = getPrefs();

            document.getElementById('tip-names').textContent = `${n1} ~ ${n2}`;
            document.getElementById('tip-val').textContent = `cosine similarity = ${val.toFixed(4)}`;

            let prefText = '';
            if (prefs[n1]) prefText += `${n1}: [${prefs[n1].join(', ')}]\n`;
            if (prefs[n2]) prefText += `${n2}: [${prefs[n2].join(', ')}]`;
            if (prefs[n1] && cats.length) {
                prefText += `\n(${cats.join(', ')})`;
            }
            document.getElementById('tip-prefs').textContent = prefText;

            tip.style.display = 'block';
            tip.style.left = (e.clientX + 14) + 'px';
            tip.style.top = (e.clientY + 14) + 'px';
        } else {
            tip.style.display = 'none';
        }
    });

    cv.addEventListener('mouseleave', () => {
        tip.style.display = 'none';
    });
}

// ================================================================
// RANKING
// ================================================================
function drawRanking() {
    const sorted = [...simData].sort((a, b) => b.sim - a.sim);
    const el = document.getElementById('ranking');
    const top = sorted.slice(0, 20);
    const bottom = sorted.slice(-10).reverse();

    let html = '<div style="grid-column:1/-1;color:#7ee787;font-size:11px;font-weight:600;margin-bottom:2px">TOP 20 - Pi\u00f9 simili</div>';
    top.forEach((d, i) => {
        const [r, g, b] = simColor(d.sim);
        html += `<div class="rank-row">
            <span class="rank-pos">${i + 1}.</span>
            <span class="rank-names">${d.name1} ~ ${d.name2}</span>
            <span class="rank-val" style="color:rgb(${r},${g},${b})">${d.sim.toFixed(4)}</span>
        </div>`;
    });

    html += '<div style="grid-column:1/-1;color:#f85149;font-size:11px;font-weight:600;margin:8px 0 2px">BOTTOM 10 - Pi\u00f9 diversi</div>';
    bottom.forEach((d, i) => {
        const [r, g, b] = simColor(d.sim);
        html += `<div class="rank-row">
            <span class="rank-pos">${sorted.length - bottom.length + bottom.length - i}.</span>
            <span class="rank-names">${d.name1} ~ ${d.name2}</span>
            <span class="rank-val" style="color:rgb(${r},${g},${b})">${d.sim.toFixed(4)}</span>
        </div>`;
    });

    el.innerHTML = html;
}

// ================================================================
// COMPILE + RUN
// ================================================================
function compileAndRun() {
    const source = document.getElementById('source-editor').value;
    consoleLines = [];
    simData = [];
    personNames = [];

    logLine('Compilazione dx \u2192 JS via Pyodide...');
    const t0 = performance.now();

    let jsCode;
    try {
        jsCode = compileDx(source);
    } catch (e) {
        logLine('Errore di compilazione: ' + e.message);
        document.getElementById('stat-status').textContent = 'Errore';
        document.getElementById('stat-status').style.color = '#f85149';
        document.getElementById('btn-run').textContent = 'Esegui';
        document.getElementById('btn-run').disabled = false;
        return;
    }

    const dtCompile = (performance.now() - t0).toFixed(0);
    logLine(`Compilato in ${dtCompile}ms`);

    // Show generated JS
    document.getElementById('js-output').textContent = jsCode;

    // Capture console.log output
    const origLog = console.log;
    const captured = [];
    console.log = function(...args) {
        const line = args.join(' ');
        captured.push(line);
        origLog.apply(console, args);
    };

    const t1 = performance.now();
    try {
        // Execute the generated JS (includes main())
        (0, eval)(jsCode);
    } catch (e) {
        console.log = origLog;
        logLine('Errore di esecuzione JS: ' + e.message);
        document.getElementById('stat-status').textContent = 'Errore';
        document.getElementById('stat-status').style.color = '#f85149';
        document.getElementById('btn-run').textContent = 'Esegui';
        document.getElementById('btn-run').disabled = false;
        return;
    }
    console.log = origLog;

    const dtRun = (performance.now() - t1).toFixed(0);
    logLine(`Eseguito in ${dtRun}ms`);
    logLine('');

    // Parse captured output
    const nameSet = new Set();
    for (const line of captured) {
        logLine(line);
        // Parse "name1 ~ name2 = 0.1234"
        const m = line.match(/^(\w+)\s*~\s*(\w+)\s*=\s*([\d.]+)/);
        if (m) {
            const name1 = m[1], name2 = m[2], sim = parseFloat(m[3]);
            simData.push({ name1, name2, sim });
            nameSet.add(name1);
            nameSet.add(name2);
        }
    }

    // Extract person order from source (set literal)
    const setMatch = source.match(/\{([^}]+)\}/);
    if (setMatch) {
        personNames = setMatch[1].split(',').map(s => s.trim()).filter(Boolean);
    } else {
        personNames = [...nameSet];
    }

    // Update stats
    document.getElementById('stat-persons').textContent = personNames.length;
    document.getElementById('stat-pairs').textContent = simData.length;
    document.getElementById('stat-time').textContent = `${dtCompile}+${dtRun}ms`;
    document.getElementById('stat-status').textContent = 'Completato';
    document.getElementById('stat-status').style.color = '#22c55e';

    // Draw visualizations
    drawHeatmap();
    drawRanking();

    document.getElementById('btn-run').textContent = 'Esegui';
    document.getElementById('btn-run').disabled = false;
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

    // JS toggle
    document.getElementById('js-toggle').addEventListener('click', () => {
        const el = document.getElementById('js-output');
        const toggle = document.getElementById('js-toggle');
        if (el.style.display === 'none' || !el.style.display) {
            el.style.display = 'block';
            toggle.innerHTML = '&#9660; Nascondi JS generato';
        } else {
            el.style.display = 'none';
            toggle.innerHTML = '&#9654; Mostra JS generato';
        }
    });

    setupTooltip();

    // Load Pyodide
    try {
        await initPyodide();
    } catch (e) {
        document.getElementById('btn-run').textContent = 'Errore caricamento Pyodide';
        document.getElementById('stat-status').textContent = 'Errore';
        document.getElementById('stat-status').style.color = '#f85149';
        console.error('Pyodide init failed:', e);
        return;
    }

    document.getElementById('btn-run').textContent = 'Esegui';
    document.getElementById('btn-run').disabled = false;
    document.getElementById('stat-status').textContent = 'Pronto';
    document.getElementById('stat-status').style.color = '#8b949e';

    // Run button
    document.getElementById('btn-run').addEventListener('click', () => {
        document.getElementById('btn-run').textContent = 'Compilazione...';
        document.getElementById('btn-run').disabled = true;
        document.getElementById('stat-status').textContent = 'Compilazione...';
        document.getElementById('stat-status').style.color = '#d2a8ff';
        document.getElementById('console-out').textContent = '';
        setTimeout(compileAndRun, 20);
    });

    // Resize
    window.addEventListener('resize', () => {
        if (personNames.length > 0) drawHeatmap();
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
    out_path = os.path.join(DEMO_DIR, "vacanze_live.html")
    with open(out_path, "w") as f:
        f.write(html)
    print(f"Generated {out_path}")
    size_kb = os.path.getsize(out_path) / 1024
    print(f"Size: {size_kb:.1f} KB")


if __name__ == "__main__":
    main()
