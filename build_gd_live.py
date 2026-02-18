#!/usr/bin/env python3
"""Build demo/gd_live.html — interactive gradient descent on scalar functions.

The DX source contains an actual GD loop (for step in 0..999999).
After compilation, the JS is post-processed to:
  1. make main() async
  2. inject `await __tick(step)` at the end of each loop iteration
  3. promote x and lr to globals (so the UI can read/write them)

The __tick() function returns a Promise that controls pacing:
  - Play mode  → resolves on requestAnimationFrame
  - Stop mode  → parks (never resolves until unparked)
  - Step mode  → resolves on button click
"""

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
<title>dx — Gradient Descent Interattivo</title>
<style>
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    background: #0d1117; color: #c9d1d9;
    min-height: 100vh;
}
button {
    background: #238636; color: #fff; border: none; border-radius: 6px;
    padding: 7px 16px; font-size: 13px; font-weight: 600; cursor: pointer;
    transition: background 0.15s;
}
button:hover { background: #2ea043; }
button:disabled { background: #21262d; color: #8b949e; cursor: not-allowed; }
button.secondary { background: #30363d; }
button.secondary:hover { background: #3d444d; }
button.danger { background: #da3633; }
button.danger:hover { background: #f85149; }
input[type="number"] {
    background: #0d1117; color: #c9d1d9; border: 1px solid #30363d;
    border-radius: 6px; padding: 5px 8px; font-size: 13px; width: 80px;
    font-family: 'SF Mono', 'JetBrains Mono', monospace;
}
input[type="range"] { accent-color: #238636; }
main {
    display: grid; grid-template-columns: 420px 1fr;
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
.viz-panel {
    padding: 16px; display: flex; flex-direction: column; gap: 12px;
    overflow: auto;
}
.controls {
    display: flex; gap: 8px; align-items: center; flex-wrap: wrap;
}
.control-group {
    display: flex; align-items: center; gap: 4px;
}
.control-group label {
    font-size: 11px; color: #8b949e; text-transform: uppercase;
    letter-spacing: 0.5px; white-space: nowrap;
}
.stats-bar {
    display: flex; gap: 24px; padding: 8px 0; flex-wrap: wrap;
}
.stat .label {
    font-size: 11px; color: #8b949e; text-transform: uppercase;
    letter-spacing: 1px;
}
.stat .value {
    font-size: 16px; font-weight: 700; color: #58a6ff;
    font-variant-numeric: tabular-nums;
    font-family: 'SF Mono', 'JetBrains Mono', monospace;
}
.card {
    background: #161b22; border: 1px solid #21262d; border-radius: 8px;
    padding: 12px; display: flex; flex-direction: column; gap: 8px;
}
.card-title {
    font-size: 11px; color: #8b949e; text-transform: uppercase;
    letter-spacing: 1px;
}
#cv-plot {
    width: 100%; height: 400px; display: block; border-radius: 4px;
    background: #0d1117;
}
.console-out {
    font-family: 'SF Mono', 'JetBrains Mono', monospace;
    font-size: 11px; line-height: 1.5; color: #8b949e;
    max-height: 150px; overflow-y: auto; white-space: pre;
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
        <div class="panel-header">
            <span class="title">gradient_descent.dx</span>
            <span class="badge badge-live">LIVE</span>
        </div>
        <div class="editor-wrap">
            <pre class="editor-highlight" id="editor-highlight"></pre>
            <textarea class="editor-textarea" id="source-editor" spellcheck="false"></textarea>
        </div>
    </section>

    <section class="viz-panel">
        <div class="controls">
            <span id="status-msg" style="font-size:12px;color:#8b949e;">Caricamento compilatore...</span>
            <button id="btn-step" class="secondary" disabled>Step</button>
            <button id="btn-reset" class="secondary" disabled>Reset</button>
            <button id="btn-fit" class="secondary" disabled>Adatta</button>
            <div class="control-group">
                <label>lr</label>
                <input type="number" id="input-lr" value="0.1" step="0.01" min="0.001">
            </div>
            <div class="control-group">
                <label>x&#8320;</label>
                <input type="number" id="input-x0" value="-1.5" step="0.1">
            </div>
        </div>

        <div class="stats-bar">
            <div class="stat">
                <div class="label">Step</div>
                <div class="value" id="stat-step">&mdash;</div>
            </div>
            <div class="stat">
                <div class="label">x</div>
                <div class="value" id="stat-x">&mdash;</div>
            </div>
            <div class="stat">
                <div class="label">f(x)</div>
                <div class="value" id="stat-fx">&mdash;</div>
            </div>
            <div class="stat">
                <div class="label">f'(x)</div>
                <div class="value" id="stat-grad">&mdash;</div>
            </div>
            <div class="stat">
                <div class="label">lr&middot;f'(x)</div>
                <div class="value" id="stat-stepsize">&mdash;</div>
            </div>
        </div>

        <div class="card">
            <div class="card-title">Grafico f(x)</div>
            <canvas id="cv-plot"></canvas>
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
// DX SOURCE — contains the actual GD loop
// ================================================================
const DX_SOURCE = `-- Gradient Descent interattivo
-- Modifica f(x) e premi Compila!

x : 6.5
lr : 0.95

for step in 0..999999
    y : (x - 1.0) * (x - 1.0)
    grad : d y / d x
    x : x - lr * grad`;

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
        cp = cp.replace(/\b(Vec|Tensor|Float|Int|String)\b/g, '<span class="ty">$1</span>');
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
// GLOBAL STATE
// ================================================================
var x = 0;
var lr = 0.1;

// __tick control state
var __tickResolve = null;  // stored Promise resolve
var __gen = 0;             // generation counter — incremented on each compile
var __trail = [];
var __consoleLines = [];
var __compiled = false;
var __loopRunning = false; // true once runGDLoop() has started
var f = undefined;         // f(x) — from compiler or extracted from source
var f_dual = undefined;    // dual-number version — from compiler if `fun f` exists

// ================================================================
// __tick(step, gen) — called inside the GD loop to control pacing
//
// gen is the generation the loop was started in. If __gen has
// changed (new compile), the loop is stale and must exit.
// Always parks — resolved by Step button.
// ================================================================
function __tick(step, gen) {
    if (gen !== __gen) throw new Error('__aborted');

    // Live lr from UI
    var uiLr = parseFloat(document.getElementById('input-lr').value);
    if (isFinite(uiLr) && uiLr > 0) lr = uiLr;

    // Trail: record current position
    if (typeof f === 'function') {
        var fxNow = f(x);
        __trail.push({ x: x, fx: fxNow });
        if (__trail.length > 300) __trail.shift();
    }

    refreshUI(step);
    return new Promise(function(r) { __tickResolve = r; });
}

// ================================================================
// UI REFRESH — called from __tick on draw frames
// ================================================================
function refreshUI(step) {
    updateStats(step);
    drawPlot();
    flushConsole();
}

function logLine(text) {
    __consoleLines.push(text);
    if (__consoleLines.length > 300) __consoleLines.shift();
    flushConsole();
}

function flushConsole() {
    var el = document.getElementById('console-out');
    el.textContent = __consoleLines.join('\n');
    el.scrollTop = el.scrollHeight;
}

// ================================================================
// EXTRACT f(x) from DX source when no `fun f` is defined
// ================================================================
function extractFFromSource(source) {
    // Find "d <var> / d x" to know which variable holds f(x)
    var diffMatch = source.match(/d\s+(\w+)\s*\/\s*d\s+x/);
    if (!diffMatch) return false;
    var varName = diffMatch[1];
    // Find "<varName> : <expr>"
    var assignRe = new RegExp('^\\s*' + varName + '\\s*:\\s*(.+)$', 'm');
    var assignMatch = source.match(assignRe);
    if (!assignMatch) return false;
    var expr = assignMatch[1].trim();
    // If it calls a function like f(x), f is already compiled
    if (/^\w+\(x\)$/.test(expr)) return false;
    try {
        var fn = new Function('x', 'return ' + expr + ';');
        fn(0); // test
        f = fn;
        return true;
    } catch(e) { return false; }
}

// ================================================================
// getGrad — exact via f_dual, fallback to numerical derivative
// ================================================================
function getGrad(xval) {
    if (typeof f_dual === 'function') {
        return f_dual({ val: xval, deriv: 1.0 }).deriv;
    }
    var h = 1e-7;
    return (f(xval + h) - f(xval - h)) / (2 * h);
}

// ================================================================
// STATS
// ================================================================
function updateStats(step) {
    if (typeof f !== 'function') return;
    var fx = f(x);
    var gradNow = getGrad(x);
    var stepSize = lr * gradNow;
    document.getElementById('stat-step').textContent = step;
    document.getElementById('stat-x').textContent = x.toFixed(6);
    document.getElementById('stat-fx').textContent = fx.toFixed(6);
    document.getElementById('stat-grad').textContent = gradNow.toFixed(6);
    document.getElementById('stat-stepsize').textContent = stepSize.toFixed(6);
}

// ================================================================
// PLOT
// ================================================================
var plotRange = { xMin: -4, xMax: 4, yMin: -1, yMax: 3 };

function computeXRange() {
    // Default range [-5, 8], expand only if x is outside
    var xMin = -5;
    var xMax = 8;
    if (x < xMin + 1) xMin = x - 1;
    if (x > xMax - 1) xMax = x + 1;
    return { xMin: xMin, xMax: xMax };
}

function sampleYRange(xMin, xMax) {
    var N = 300, yMin = Infinity, yMax = -Infinity;
    for (var i = 0; i <= N; i++) {
        var xv = xMin + (xMax - xMin) * i / N;
        try {
            var y = f(xv);
            if (isFinite(y)) { yMin = Math.min(yMin, y); yMax = Math.max(yMax, y); }
        } catch(e) {}
    }
    // Also include current ball position
    try {
        var yc = f(x);
        if (isFinite(yc)) { yMin = Math.min(yMin, yc); yMax = Math.max(yMax, yc); }
    } catch(e) {}
    var yPad = (yMax - yMin) * 0.15 || 1;
    return { yMin: yMin - yPad, yMax: yMax + yPad };
}

function autoRange() {
    var xr = computeXRange();
    var yr = sampleYRange(xr.xMin, xr.xMax);
    plotRange = { xMin: xr.xMin, xMax: xr.xMax, yMin: yr.yMin, yMax: yr.yMax };
}


function drawPlot() {
    if (typeof f !== 'function') return;

    var cvEl = document.getElementById('cv-plot');
    var dpr = window.devicePixelRatio || 1;
    var rect = cvEl.getBoundingClientRect();
    var w = rect.width, h = rect.height;
    cvEl.width = Math.round(w * dpr);
    cvEl.height = Math.round(h * dpr);
    var ctx = cvEl.getContext('2d');
    ctx.scale(dpr, dpr);

    var pad = { top: 20, right: 20, bottom: 36, left: 52 };
    var pw = w - pad.left - pad.right;
    var ph = h - pad.top - pad.bottom;

    var xMin = plotRange.xMin, xMax = plotRange.xMax;
    var yMin = plotRange.yMin, yMax = plotRange.yMax;

    function toSX(xv) { return pad.left + (xv - xMin) / (xMax - xMin) * pw; }
    function toSY(yv) { return pad.top + (1 - (yv - yMin) / (yMax - yMin)) * ph; }

    // Clear
    ctx.fillStyle = '#0d1117';
    ctx.fillRect(0, 0, w, h);

    // Grid
    ctx.strokeStyle = '#21262d';
    ctx.lineWidth = 1;
    ctx.font = '10px -apple-system, sans-serif';
    ctx.fillStyle = '#484f58';

    var ySteps = niceSteps(yMin, yMax, 6);
    for (var yi = 0; yi < ySteps.length; yi++) {
        var sy = toSY(ySteps[yi]);
        if (sy < pad.top || sy > pad.top + ph) continue;
        ctx.beginPath(); ctx.moveTo(pad.left, sy); ctx.lineTo(pad.left + pw, sy); ctx.stroke();
        ctx.textAlign = 'right'; ctx.textBaseline = 'middle';
        ctx.fillText(formatNum(ySteps[yi]), pad.left - 6, sy);
    }
    var xSteps = niceSteps(xMin, xMax, 8);
    for (var xi = 0; xi < xSteps.length; xi++) {
        var sx = toSX(xSteps[xi]);
        if (sx < pad.left || sx > pad.left + pw) continue;
        ctx.beginPath(); ctx.moveTo(sx, pad.top); ctx.lineTo(sx, pad.top + ph); ctx.stroke();
        ctx.textAlign = 'center'; ctx.textBaseline = 'top';
        ctx.fillText(formatNum(xSteps[xi]), sx, pad.top + ph + 6);
    }

    // Axes
    ctx.strokeStyle = '#30363d'; ctx.lineWidth = 1.5;
    if (yMin <= 0 && yMax >= 0) {
        var sy0 = toSY(0);
        ctx.beginPath(); ctx.moveTo(pad.left, sy0); ctx.lineTo(pad.left + pw, sy0); ctx.stroke();
    }
    if (xMin <= 0 && xMax >= 0) {
        var sx0 = toSX(0);
        ctx.beginPath(); ctx.moveTo(sx0, pad.top); ctx.lineTo(sx0, pad.top + ph); ctx.stroke();
    }

    // Clip
    ctx.save();
    ctx.beginPath(); ctx.rect(pad.left, pad.top, pw, ph); ctx.clip();

    // Curve f(x)
    ctx.strokeStyle = '#58a6ff'; ctx.lineWidth = 2.5;
    ctx.beginPath();
    var started = false, SAMPLES = 500;
    for (var i = 0; i <= SAMPLES; i++) {
        var xv = xMin + (xMax - xMin) * i / SAMPLES;
        try {
            var yv = f(xv);
            if (!isFinite(yv)) { started = false; continue; }
            if (!started) { ctx.moveTo(toSX(xv), toSY(yv)); started = true; }
            else ctx.lineTo(toSX(xv), toSY(yv));
        } catch(e) { started = false; }
    }
    ctx.stroke();

    // Trail (fading dots)
    for (var ti = 0; ti < __trail.length; ti++) {
        var tp = __trail[ti];
        var alpha = 0.08 + 0.45 * (ti / __trail.length);
        ctx.beginPath();
        ctx.arc(toSX(tp.x), toSY(tp.fx), 4, 0, Math.PI * 2);
        ctx.fillStyle = 'rgba(139, 148, 158, ' + alpha + ')';
        ctx.fill();
    }

    // Current ball + gradient arrow
    var fx = f(x);
    var gradNow = getGrad(x);
    var stepSize = lr * gradNow;
    var bx = toSX(x), by = toSY(fx);

    // Arrow: from ball, pointing in direction of -gradient (the step)
    var arrowTargetX = x - stepSize;
    var atx = toSX(arrowTargetX);
    var arrowLen = atx - bx;

    if (Math.abs(arrowLen) > 2) {
        var arrowColor = gradNow > 0 ? '#f85149' : '#58a6ff';
        ctx.strokeStyle = arrowColor; ctx.fillStyle = arrowColor; ctx.lineWidth = 2.5;
        var maxPx = pw * 0.4;
        var dtx = Math.abs(arrowLen) > maxPx ? bx + Math.sign(arrowLen) * maxPx : atx;
        ctx.beginPath(); ctx.moveTo(bx, by); ctx.lineTo(dtx, by); ctx.stroke();
        // Arrowhead
        var dir = Math.sign(dtx - bx);
        ctx.beginPath();
        ctx.moveTo(dtx, by);
        ctx.lineTo(dtx - dir * 8, by - 5);
        ctx.lineTo(dtx - dir * 8, by + 5);
        ctx.closePath(); ctx.fill();
        // Label
        ctx.font = '10px -apple-system, sans-serif';
        ctx.textAlign = 'center'; ctx.textBaseline = 'bottom';
        ctx.fillText(
            (gradNow > 0 ? '\u2190 ' : '\u2192 ') + Math.abs(stepSize).toFixed(4),
            (bx + dtx) / 2, by - 8
        );
    }

    // Ball
    ctx.shadowColor = '#f0883e'; ctx.shadowBlur = 12;
    ctx.beginPath(); ctx.arc(bx, by, 8, 0, Math.PI * 2);
    ctx.fillStyle = '#f0883e'; ctx.fill();
    ctx.shadowBlur = 0;
    ctx.strokeStyle = '#fff'; ctx.lineWidth = 2; ctx.stroke();

    ctx.restore(); // un-clip

    // Axis labels
    ctx.fillStyle = '#8b949e'; ctx.font = '11px -apple-system, sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText('x', pad.left + pw / 2, h - 2);
    ctx.save();
    ctx.translate(12, pad.top + ph / 2);
    ctx.rotate(-Math.PI / 2);
    ctx.fillText('f(x)', 0, 0);
    ctx.restore();
}

function niceSteps(lo, hi, target) {
    var range = hi - lo;
    if (range <= 0) return [lo];
    var rough = range / target;
    var mag = Math.pow(10, Math.floor(Math.log10(rough)));
    var norm = rough / mag, step;
    if (norm < 1.5) step = mag;
    else if (norm < 3.5) step = 2 * mag;
    else if (norm < 7.5) step = 5 * mag;
    else step = 10 * mag;
    var start = Math.ceil(lo / step) * step;
    var result = [];
    for (var v = start; v <= hi + step * 0.01; v += step) result.push(v);
    return result;
}

function formatNum(v) {
    if (Math.abs(v) < 0.001 && v !== 0) return v.toExponential(1);
    if (Math.abs(v) >= 1000) return v.toExponential(1);
    if (Number.isInteger(v)) return v.toString();
    return parseFloat(v.toPrecision(4)).toString();
}

// ================================================================
// POST-PROCESS compiled JS: extract f/f_dual, read defaults
// We DON'T inject __tick into the compiled loop. Instead, the GD
// loop runs from hand-written JS that calls f() and f_dual().
// ================================================================
function postProcessJS(jsCode) {
    var lib = jsCode
        .replace(/"use strict";\s*\n?/, '')
        .replace(/^(\s*)(let|const) /gm, '$1var ');

    // Extract initial x and lr from assignments inside main()
    var xMatch = lib.match(/^\s*x = ([\d.eE+-]+);/m);
    var lrMatch = lib.match(/^\s*lr = ([\d.eE+-]+);/m);
    var initX = xMatch ? parseFloat(xMatch[1]) : 2.5;
    var initLr = lrMatch ? parseFloat(lrMatch[1]) : 0.1;

    // Strip main() call at end — we only want the function definitions
    lib = lib.replace(/\nmain\(\);\s*$/, '');

    return { lib: lib, initX: initX, initLr: initLr };
}

// ================================================================
// COMPILE + START
// ================================================================
function abortCurrent() {
    __gen++;              // invalidate any running loop
    __loopRunning = false;
    // Unpark if suspended — the stale gen check in __tick will exit it
    if (__tickResolve) {
        var r = __tickResolve;
        __tickResolve = null;
        r();
    }
}

// ================================================================
// GD LOOP — runs in JS, calls compiled f() and f_dual()
// The loop parks at __tick BEFORE each GD update, so the user
// sees the current state and controls when the next step happens.
// ================================================================
async function runGDLoop(gen) {
    __loopRunning = true;
    for (var step = 0; step < 999999; step++) {
        // Park BEFORE the update — user sees state, then clicks Step/Play
        await __tick(step, gen);
        // GD update
        var val = f(x);
        var grad = getGrad(x);
        x = x - lr * grad;
        logLine('step ' + step + ': x=' + x.toFixed(4) +
                ', f(x)=' + val.toFixed(4) +
                ', grad=' + grad.toFixed(4));
    }
}

// Start the loop if not running yet. Called by onStep/onPlay.
function ensureLoopStarted() {
    if (__loopRunning) return;
    var gen = __gen;
    runGDLoop(gen).then(function() {
        logLine('Loop terminato.');
        __loopRunning = false;
    }).catch(function(e) {
        __loopRunning = false;
        if (e.message !== '__aborted') {
            logLine('Errore runtime: ' + e.message);
        }
    });
}

function compileAndStart() {
    abortCurrent();

    var source = document.getElementById('source-editor').value;
    __consoleLines = [];
    logLine('Compilazione dx \u2192 JS via Pyodide...');

    var t0 = performance.now();
    var jsCode;
    try {
        jsCode = compileDx(source);
    } catch (e) {
        logLine('Errore di compilazione: ' + e.message);
        __compiled = false;
        updateButtons();
        return;
    }

    var dt = (performance.now() - t0).toFixed(0);
    logLine('Compilato in ' + dt + 'ms');
    document.getElementById('js-output').textContent = jsCode;

    // Post-process: strip main() call, extract defaults
    var result = postProcessJS(jsCode);
    var lib = result.lib;

    // Clear previous f/f_dual before eval
    f = undefined; f_dual = undefined;

    // Eval — defines runtime helpers (and f/f_dual if `fun f` is in source)
    try {
        (0, eval)(lib);
    } catch (e) {
        logLine('Errore eval JS: ' + e.message);
        __compiled = false;
        updateButtons();
        return;
    }

    // If no `fun f` in source, extract f(x) from the DX expression
    if (typeof f !== 'function') {
        if (!extractFFromSource(source)) {
            logLine('Errore: impossibile estrarre f(x) dal sorgente');
            __compiled = false;
            updateButtons();
            return;
        }
        logLine('f(x) estratta dal sorgente (derivata numerica)');
    }

    __compiled = true;
    __loopRunning = false;

    // Sync UI inputs from DX source defaults
    document.getElementById('input-x0').value = result.initX;
    document.getElementById('input-lr').value = result.initLr;

    // Set globals
    x = result.initX;
    lr = result.initLr;
    __trail = [];

    // Initial draw — ball sits at x₀, loop NOT started yet
    autoRange();
    updateStats(0);
    drawPlot();
    updateButtons();

    logLine('Pronto! Usa Step o Play per avviare il gradient descent.');
    logLine('x\u2080 = ' + x + ', lr = ' + lr);
}

// ================================================================
// BUTTON STATE
// ================================================================
function updateButtons() {
    document.getElementById('btn-step').disabled = !__compiled;
    document.getElementById('btn-reset').disabled = !__compiled;
    document.getElementById('btn-fit').disabled = !__compiled;
}

// ================================================================
// BUTTON HANDLERS
// ================================================================
function onStep() {
    if (!__compiled) return;
    ensureLoopStarted();
    // Unpark one iteration
    if (__tickResolve) {
        var r = __tickResolve;
        __tickResolve = null;
        r();
    }
}

function onReset() {
    if (!__compiled) return;
    abortCurrent();
    setTimeout(function() {
        compileAndStart();
    }, 50);
}

// ================================================================
// INIT
// ================================================================
async function init() {
    var ta = document.getElementById('source-editor');
    ta.value = DX_SOURCE;
    syncHighlight();
    ta.addEventListener('input', syncHighlight);
    ta.addEventListener('scroll', syncScroll);
    ta.addEventListener('keydown', function(e) {
        if (e.key === 'Tab') {
            e.preventDefault();
            var start = ta.selectionStart, end = ta.selectionEnd;
            ta.value = ta.value.substring(0, start) + '    ' + ta.value.substring(end);
            ta.selectionStart = ta.selectionEnd = start + 4;
            syncHighlight();
        }
    });

    // JS toggle
    document.getElementById('js-toggle').addEventListener('click', function() {
        var el = document.getElementById('js-output');
        var toggle = document.getElementById('js-toggle');
        if (el.style.display === 'none' || !el.style.display) {
            el.style.display = 'block';
            toggle.innerHTML = '&#9660; Nascondi JS generato';
        } else {
            el.style.display = 'none';
            toggle.innerHTML = '&#9654; Mostra JS generato';
        }
    });

    // Load Pyodide
    try {
        await initPyodide();
    } catch (e) {
        document.getElementById('status-msg').textContent = 'Errore caricamento Pyodide';
        logLine('Errore: impossibile caricare Pyodide: ' + e.message);
        console.error('Pyodide init failed:', e);
        return;
    }

    document.getElementById('status-msg').textContent = '';

    // Shared compile trigger
    var __lastCompiledSource = '';
    function triggerCompile(force) {
        var src = ta.value;
        if (!force && src === __lastCompiledSource) return;
        __lastCompiledSource = src;
        abortCurrent();
        setTimeout(function() {
            compileAndStart();
        }, 20);
    }

    // Auto-compile on editor blur (only if source changed)
    ta.addEventListener('blur', function() {
        triggerCompile(false);
    });

    // Buttons
    document.getElementById('btn-step').addEventListener('click', onStep);
    document.getElementById('btn-reset').addEventListener('click', onReset);
    document.getElementById('btn-fit').addEventListener('click', function() {
        if (!__compiled) return;
        autoRange();
        drawPlot();
    });

    // Resize
    window.addEventListener('resize', function() {
        if (__compiled) drawPlot();
    });

    // Auto-compile on load
    triggerCompile(true);
}

document.addEventListener('DOMContentLoaded', init);
</script>
<script src="https://cdn.jsdelivr.net/pyodide/v0.27.0/full/pyodide.js"></script>

</body>
</html>"""


def main():
    modules_js = build_modules_js()
    html = HTML_TEMPLATE.replace("%%DX_MODULES%%", modules_js)
    out_path = os.path.join(DEMO_DIR, "gd_live.html")
    with open(out_path, "w") as f:
        f.write(html)
    print(f"Generated {out_path}")
    size_kb = os.path.getsize(out_path) / 1024
    print(f"Size: {size_kb:.1f} KB")


if __name__ == "__main__":
    main()
