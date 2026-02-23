// dx runtime prelude

class _dx_app {
    constructor(obj) {
        for (const [k, v] of Object.entries(obj)) {
            this[k] = v;
        }
    }
    size() { return Object.keys(this).length; }
    keys() { return Object.keys(this); }
    values() { return Object.values(this); }
}

class _dx_rel {
    constructor(pairs) {
        this._pairs = [...pairs];
    }
    get(key) {
        return this._pairs.filter(([k]) => k === key).map(([, v]) => v);
    }
    has(key) {
        return this._pairs.some(([k]) => k === key);
    }
    get size() { return this._pairs.length; }
    get keys() {
        return [...new Set(this._pairs.map(([k]) => k))];
    }
    get values() {
        return this._pairs.map(([, v]) => v);
    }
    get pairs() {
        return [...this._pairs];
    }
}

function _dx_set(...args) {
    return new Set(args);
}

class _dx_named {
    constructor(name, val) {
        this._dx_name = name;
        this._dx_val = val;
    }
    valueOf() { return this._dx_val; }
    toString() { return String(this._dx_val); }
    [Symbol.iterator]() { return this._dx_val[Symbol.iterator](); }
}

function _dx_choose(coll, k) {
    const arr = [...coll];
    const result = [];
    function _go(start, combo) {
        if (combo.length === k) { result.push([...combo]); return; }
        for (let i = start; i < arr.length; i++) {
            combo.push(arr[i]);
            _go(i + 1, combo);
            combo.pop();
        }
    }
    _go(0, []);
    return result;
}

function _dx_fold(seq, init, fn) {
    if (fn === undefined) {
        fn = init;
        let it = seq[Symbol.iterator]();
        let acc = it.next().value;
        for (const x of it) {
            acc = fn(acc, x);
        }
        return acc;
    }
    let acc = init;
    for (const x of seq) {
        acc = fn(acc, x);
    }
    return acc;
}

function _dx_add(a, b) {
    if (Array.isArray(a)) return a.concat(b);
    return a + b;
}

function _dx_eq(a, b) {
    if (a === b) return true;
    if (typeof a === 'object' && a !== null && typeof a.equals === 'function') return a.equals(b);
    return false;
}

function _dx_contains(item, coll) {
    if (coll instanceof Set) return coll.has(item);
    if (Array.isArray(coll)) {
        if (typeof item === 'object' && item !== null && typeof item.equals === 'function') {
            return coll.some(x => item.equals(x));
        }
        return coll.includes(item);
    }
    if (typeof coll === 'string') return coll.includes(item);
    if (coll instanceof _dx_app) return Object.prototype.hasOwnProperty.call(coll, item);
    if (coll instanceof _dx_rel) return coll.has(item);
    return false;
}

function _dx_range(start, end) {
    return Array.from({length: end - start}, (_, i) => start + i);
}

function _dx_cmp_to_key(cmpFn) {
    return (a, b) => cmpFn(a, b);
}

function _dx_repr(v) {
    if (v === true) return 'True';
    if (v === false) return 'False';
    if (v === null || v === undefined) return 'None';
    if (typeof v === 'object' && v !== null && typeof v.toString === 'function'
        && v.toString !== Object.prototype.toString && !Array.isArray(v)) {
        return v.toString();
    }
    return v;
}

class _dx_list extends Array {
    static of(...args) { let l = new _dx_list(); l.push(...args); return l; }
    put(val) { this.push(val); }
    get() { return this.shift(); }
    prepend(val) { this.unshift(val); }
    peek() { return this[0]; }
    head() { return this[0]; }
    tail() { let t = new _dx_list(); for(let i=1;i<this.length;i++) t.push(this[i]); return t; }
    empty() { return this.length === 0; }
}

class _dx_stack {
    constructor(arr) { this._d = [...(arr||[])]; }
    put(val) { this._d.push(val); }
    get() { return this._d.pop(); }
    peek() { return this._d[this._d.length-1]; }
    empty() { return this._d.length === 0; }
    get length() { return this._d.length; }
    includes(v) { return this._d.includes(v); }
    [Symbol.iterator]() { return this._d[Symbol.iterator](); }
}

class _dx_queue {
    constructor(arr) { this._d = [...(arr||[])]; }
    put(val) { this._d.push(val); }
    get() { return this._d.shift(); }
    peek() { return this._d[0]; }
    empty() { return this._d.length === 0; }
    get length() { return this._d.length; }
    includes(v) { return this._d.includes(v); }
    [Symbol.iterator]() { return this._d[Symbol.iterator](); }
}

class _DxDual {
    constructor(val, d) { this.val = +val; this.d = +(d || 0); }
    add(o) { o = o instanceof _DxDual ? o : new _DxDual(o); return new _DxDual(this.val + o.val, this.d + o.d); }
    sub(o) { o = o instanceof _DxDual ? o : new _DxDual(o); return new _DxDual(this.val - o.val, this.d - o.d); }
    mul(o) { o = o instanceof _DxDual ? o : new _DxDual(o); return new _DxDual(this.val * o.val, this.d * o.val + this.val * o.d); }
    div(o) { o = o instanceof _DxDual ? o : new _DxDual(o); return new _DxDual(this.val / o.val, (this.d * o.val - this.val * o.d) / (o.val * o.val)); }
    pow(n) { let nv = n instanceof _DxDual ? n.val : n; return new _DxDual(this.val ** nv, nv * this.val ** (nv - 1) * this.d); }
    neg() { return new _DxDual(-this.val, -this.d); }
}
function _dx_dual_add(a, b) { return a instanceof _DxDual ? a.add(b) : (b instanceof _DxDual ? b.add(a) : a + b); }
function _dx_dual_sub(a, b) { return a instanceof _DxDual ? a.sub(b) : (b instanceof _DxDual ? new _DxDual(a).sub(b) : a - b); }
function _dx_dual_mul(a, b) { return a instanceof _DxDual ? a.mul(b) : (b instanceof _DxDual ? b.mul(a) : a * b); }
function _dx_dual_div(a, b) { return a instanceof _DxDual ? a.div(b) : (b instanceof _DxDual ? new _DxDual(a).div(b) : a / b); }
function _dx_dual_pow(a, n) { return a instanceof _DxDual ? a.pow(n) : a ** (n instanceof _DxDual ? n.val : n); }
function _dx_grad_fwd(f, x) { const r = f(new _DxDual(x, 1)); return r instanceof _DxDual ? r.d : 0; }

class _DxVar {
    constructor(val) { this.val = +val; this.grad = 0; this._bw = () => {}; this._ch = []; }
    add(o) { o = o instanceof _DxVar ? o : new _DxVar(o); const out = new _DxVar(this.val + o.val); out._ch = [this, o]; const s = this; out._bw = () => { s.grad += out.grad; o.grad += out.grad; }; return out; }
    sub(o) { o = o instanceof _DxVar ? o : new _DxVar(o); const out = new _DxVar(this.val - o.val); out._ch = [this, o]; const s = this; out._bw = () => { s.grad += out.grad; o.grad -= out.grad; }; return out; }
    mul(o) { o = o instanceof _DxVar ? o : new _DxVar(o); const out = new _DxVar(this.val * o.val); out._ch = [this, o]; const s = this; out._bw = () => { s.grad += o.val * out.grad; o.grad += s.val * out.grad; }; return out; }
    div(o) { o = o instanceof _DxVar ? o : new _DxVar(o); const out = new _DxVar(this.val / o.val); out._ch = [this, o]; const s = this; out._bw = () => { s.grad += out.grad / o.val; o.grad -= out.grad * s.val / (o.val * o.val); }; return out; }
    pow(n) { const nv = n instanceof _DxVar ? n.val : n; const out = new _DxVar(this.val ** nv); out._ch = [this]; const s = this; out._bw = () => { s.grad += nv * s.val ** (nv - 1) * out.grad; }; return out; }
    neg() { const out = new _DxVar(-this.val); out._ch = [this]; const s = this; out._bw = () => { s.grad -= out.grad; }; return out; }
}
function _dx_grad_rev(f, x) {
    const vars = x.map(v => new _DxVar(v));
    const loss = f(vars);
    loss.grad = 1.0;
    const visited = new Set(), order = [];
    function _topo(v) { if (!visited.has(v)) { visited.add(v); for (const c of v._ch) _topo(c); order.push(v); } }
    _topo(loss);
    for (let i = order.length - 1; i >= 0; i--) order[i]._bw();
    return vars.map(v => v.grad);
}


// --- dx vector runtime ---
let _rx = 123456789, _ry = 362436069, _rz = 521288629, _rw = 88675123;
function RngSeed(s) { s=s|0; _rx=s; _ry=Math.imul(s,48271)|0; if(!_ry) _ry=362436069; _rz=Math.imul(_ry,48271)|0; if(!_rz) _rz=521288629; _rw=Math.imul(_rz,48271)|0; if(!_rw) _rw=88675123; }
function RngNext() { let t=_rx^((_rx<<11)|0); _rx=_ry; _ry=_rz; _rz=_rw; _rw=(_rw^(_rw>>>19)^(t^(t>>>8)))|0; return _rw; }
function RngFloat() { return (RngNext()>>>0)/4294967296.0; }
function RngNormal() { let u1,u2; do{u1=RngFloat();}while(u1===0.0); u2=RngFloat(); return Math.sqrt(-2.0*Math.log(u1))*Math.cos(6.2831853*u2); }
function Matmul(W, x, out, M, N) { for(let i=0;i<M;i++){let s=0;for(let j=0;j<N;j++) s+=W[i*N+j]*x[j]; out[i]=s;} }
function MatmulTranspose(W, x, out, M, N) { out.fill(0); for(let i=0;i<M;i++) for(let j=0;j<N;j++) out[j]+=W[i*N+j]*x[i]; }
function OuterProductAdd(a, b, out, M, N) { for(let i=0;i<M;i++) for(let j=0;j<N;j++) out[i*N+j]+=a[i]*b[j]; }
function Matmul2d(A, B, C, M, K, P) { for(let i=0;i<M;i++) for(let j=0;j<P;j++){let s=0;for(let k=0;k<K;k++) s+=A[i*K+k]*B[k*P+j]; C[i*P+j]=s;} }
function Matmul2dTransB(A, B, C, M, K, P) { for(let i=0;i<M;i++) for(let j=0;j<P;j++){let s=0;for(let k=0;k<K;k++) s+=A[i*K+k]*B[j*K+k]; C[i*P+j]=s;} }
function Matmul2dTransA(A, B, C, M, K, P) { C.fill(0); for(let i=0;i<M;i++) for(let j=0;j<K;j++) for(let p=0;p<P;p++) C[j*P+p]+=A[i*K+j]*B[i*P+p]; }
function VecAdd(a, b, out, N) { for(let i=0;i<N;i++) out[i]=a[i]+b[i]; }
function VecSub(a, b, out, N) { for(let i=0;i<N;i++) out[i]=a[i]-b[i]; }
function BroadcastAdd(A, b, out, M, N) { for(let i=0;i<M;i++) for(let j=0;j<N;j++) out[i*N+j]=A[i*N+j]+b[j]; }
function DotProduct(a, b, N) { let s=0; for(let i=0;i<N;i++) s+=a[i]*b[i]; return s; }
function ReluForward(x, out, N) { for(let i=0;i<N;i++) out[i]=x[i]>0?x[i]:0; }
function ReluBackward(cached, dOut, dIn, N) { for(let i=0;i<N;i++) dIn[i]=cached[i]>0?dOut[i]:0; }
function SoftmaxForward(x, out, N) { let mx=x[0]; for(let i=1;i<N;i++) if(x[i]>mx) mx=x[i]; let s=0; for(let i=0;i<N;i++){out[i]=Math.exp(x[i]-mx);s+=out[i];} for(let i=0;i<N;i++) out[i]/=s; }
function SoftmaxBackward(out, dOut, dIn, N) { let dot=0; for(let j=0;j<N;j++) dot+=dOut[j]*out[j]; for(let i=0;i<N;i++) dIn[i]=out[i]*(dOut[i]-dot); }
function SigmoidForward(x, out, N) { for(let i=0;i<N;i++) out[i]=1/(1+Math.exp(-x[i])); }
function SigmoidBackward(cached, dOut, dIn, N) { for(let i=0;i<N;i++) dIn[i]=dOut[i]*cached[i]*(1-cached[i]); }
function MseForward(pred, target, N) { let s=0; for(let i=0;i<N;i++){const d=pred[i]-target[i];s+=d*d;} return s/N; }
function MseBackward(pred, target, dPred, N) { for(let i=0;i<N;i++) dPred[i]=2*(pred[i]-target[i])/N; }
function CrossEntropyForward(pred, label, N) { let p=pred[label]; if(p<1e-7) p=1e-7; return -Math.log(p); }
function CrossEntropyBackward(pred, label, dPred, N) { dPred.fill(0); let p=pred[label]; if(p<1e-7) p=1e-7; dPred[label]=-1/p; }
function SgdStep(params, grads, n, lr) { for(let i=0;i<n;i++) params[i]-=lr*grads[i]; }
function Argmax(x, N) { let best=0; for(let i=1;i<N;i++) if(x[i]>x[best]) best=i; return best; }

// two-layerFullyConnectedNetwork: 784 → 128 → 10
class Net {
    constructor(w1, b1, w2, b2) {
        this.w1 = w1;
        this.b1 = b1;
        this.w2 = w2;
        this.b2 = b2;
    }
    equals(other) { return other instanceof Net && _dx_eq(this.w1, other.w1) && _dx_eq(this.b1, other.b1) && _dx_eq(this.w2, other.w2) && _dx_eq(this.b2, other.b2); }
    toString() { return `Net(${_dx_repr(this.w1)}, ${_dx_repr(this.b1)}, ${_dx_repr(this.w2)}, ${_dx_repr(this.b2)})`; }
    [Symbol.for('nodejs.util.inspect.custom')]() { return this.toString(); }
}

function apply(x) {
    let _it;
    _it = relu(_dx_add(_dx_matmul(this.w1, x), this.b1));
    _it = softmax(_dx_add(_dx_matmul(this.w2, _it), this.b2));
}

function createNetCache() {
    return {
        w1Proj: new Float32Array(128),
        sum: new Float32Array(128),
        reluOut: new Float32Array(128),
        w2Proj: new Float32Array(10),
        sum_1: new Float32Array(10),
        softmaxOut: new Float32Array(10),
    };
}

function createNetGrad() {
    const _buf = new Float32Array(101770);
    return {
        _buf,
        d_w1: _buf.subarray(0, 100352),
        d_b1: _buf.subarray(100352, 100480),
        d_w2: _buf.subarray(100480, 101760),
        d_b2: _buf.subarray(101760, 101770),
    };
}

function createNet(scale) {
    const _buf = new Float32Array(101770);
    for (let i = 0; i < 101770; i++) _buf[i] = RngNormal() * scale;
    return {
        _buf,
        w1: _buf.subarray(0, 100352),
        b1: _buf.subarray(100352, 100480),
        w2: _buf.subarray(100480, 101760),
        b2: _buf.subarray(101760, 101770),
    };
}

function NetForward(me, x, output, cache) {
    Matmul(me.w1, x, cache.w1Proj, 128, 784);
    VecAdd(cache.w1Proj, me.b1, cache.sum, 128);
    ReluForward(cache.sum, cache.reluOut, 128);
    Matmul(me.w2, cache.reluOut, cache.w2Proj, 10, 128);
    VecAdd(cache.w2Proj, me.b2, cache.sum_1, 10);
    SoftmaxForward(cache.sum_1, cache.softmaxOut, 10);
    output.set(cache.softmaxOut);
}

function NetBackward(me, x, c, d_output, g, d_input) {
    const d_softmaxOut = new Float32Array(10);
    d_softmaxOut.set(d_output);
    const d_sum_1 = new Float32Array(10);
    SoftmaxBackward(c.softmaxOut, d_softmaxOut, d_sum_1, 10);
    const d_w2Proj = new Float32Array(10);
    for (let _i=0; _i<10; _i++) d_w2Proj[_i] += d_sum_1[_i];
    for (let _i=0; _i<10; _i++) g.d_b2[_i] += d_sum_1[_i];
    OuterProductAdd(d_w2Proj, c.reluOut, g.d_w2, 10, 128);
    const d_reluOut = new Float32Array(128);
    MatmulTranspose(me.w2, d_w2Proj, d_reluOut, 10, 128);
    const d_sum = new Float32Array(128);
    ReluBackward(c.reluOut, d_reluOut, d_sum, 128);
    const d_w1Proj = new Float32Array(128);
    for (let _i=0; _i<128; _i++) d_w1Proj[_i] += d_sum[_i];
    for (let _i=0; _i<128; _i++) g.d_b1[_i] += d_sum[_i];
    OuterProductAdd(d_w1Proj, x, g.d_w1, 128, 784);
    const d_x = new Float32Array(784);
    MatmulTranspose(me.w1, d_w1Proj, d_x, 128, 784);
    if (d_input) { for (let _i=0; _i<d_input.length; _i++) d_input[_i] = d_x[_i]; }
}

