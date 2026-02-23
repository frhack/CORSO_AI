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

// firstStepTowardSelf-hosting: tokenize dx source code
function make_tok(tt, val, ln) {
    let _it;
    return new _dx_app({tt: tt, val: val, line: ln});
}

function tokenize(source) {
    let _it;
    let tokens = [];
    let i = 0;
    let line = 1;
    let kw = new _dx_app({});
    kw["fun"] = "FUN";
    kw["for"] = "FOR";
    kw["if"] = "IF";
    kw["else"] = "ELSE";
    kw["while"] = "WHILE";
    kw["return"] = "RETURN";
    kw["true"] = "TRUE";
    kw["false"] = "FALSE";
    kw["and"] = "AND";
    kw["or"] = "OR";
    kw["not"] = "NOT";
    kw["type"] = "TYPE";
    kw["in"] = "IN";
    kw["is"] = "IS";
    kw["has"] = "HAS";
    kw["pre"] = "PRE";
    kw["post"] = "POST";
    kw["on"] = "ON";
    kw["o"] = "MATMUL";
    let indent_stack = [0];
    while ((i < source.length)) {
        let ch = source[i];
        if ((ch === "\n")) {
            line = _dx_add(line, 1);
            i = _dx_add(i, 1);
            let indent = 0;
            let scanning = true;
            while (((i < source.length) && scanning)) {
                indent = 0;
                while (((i < source.length) && (source[i] === " "))) {
                    indent = _dx_add(indent, 1);
                    i = _dx_add(i, 1);
                }
                if ((i >= source.length)) {
                    scanning = false;
                } else if ((source[i] === "\n")) {
                    line = _dx_add(line, 1);
                    i = _dx_add(i, 1);
                } else {
                    scanning = false;
                }
            }
            if ((tokens.length > 0)) {
                let last_tt = tokens[(tokens.length - 1)].tt;
                if ((((last_tt !== "NEWLINE") && (last_tt !== "INDENT")) && (last_tt !== "DEDENT"))) {
                    _it = tokens.push(make_tok("NEWLINE", "NL", line));
                }
            }
            if ((i < source.length)) {
                let current = indent_stack[(indent_stack.length - 1)];
                if ((indent > current)) {
                    _it = indent_stack.push(indent);
                    _it = tokens.push(make_tok("INDENT", "", line));
                } else {
                    while ((indent < indent_stack[(indent_stack.length - 1)])) {
                        _it = indent_stack.pop();
                        _it = tokens.push(make_tok("DEDENT", "", line));
                    }
                }
            }
        } else if (((ch === " ") || (ch === "\t"))) {
            i = _dx_add(i, 1);
        } else if ((ch === "\"")) {
            i = _dx_add(i, 1);
            let val = "";
            while (((i < source.length) && (source[i] !== "\""))) {
                if (((source[i] === "\\") && (_dx_add(i, 1) < source.length))) {
                    let nc = source[_dx_add(i, 1)];
                    if ((nc === "n")) {
                        val = _dx_add(val, "\n");
                    } else if ((nc === "t")) {
                        val = _dx_add(val, "\t");
                    } else if ((nc === "\"")) {
                        val = _dx_add(val, "\"");
                    } else if ((nc === "\\")) {
                        val = _dx_add(val, "\\");
                    } else {
                        val = _dx_add(val, nc);
                    }
                    i = _dx_add(i, 2);
                } else {
                    val = _dx_add(val, source[i]);
                    i = _dx_add(i, 1);
                }
            }
            if ((i < source.length)) {
                i = _dx_add(i, 1);
            }
            _it = tokens.push(make_tok("STRING", val, line));
        } else if (/^\d+$/.test(ch)) {
            let start = i;
            while (((i < source.length) && /^\d+$/.test(source[i]))) {
                i = _dx_add(i, 1);
            }
            if (((i < source.length) && (source[i] === "."))) {
                i = _dx_add(i, 1);
                while (((i < source.length) && /^\d+$/.test(source[i]))) {
                    i = _dx_add(i, 1);
                }
                _it = tokens.push(make_tok("FLOAT", source.slice(start, i), line));
            } else {
                _it = tokens.push(make_tok("INT", source.slice(start, i), line));
            }
        } else if ((/^[a-zA-Z]+$/.test(ch) || (ch === "_"))) {
            start = i;
            while (((i < source.length) && (/^[a-zA-Z0-9]+$/.test(source[i]) || (source[i] === "_")))) {
                i = _dx_add(i, 1);
            }
            let word = source.slice(start, i);
            if ((((word === "d") && (i < source.length)) && (source[i] === " "))) {
                let save_i = i;
                i = _dx_add(i, 1);
                while (((i < source.length) && (source[i] === " "))) {
                    i = _dx_add(i, 1);
                }
                if (((i < source.length) && ((/^[a-zA-Z0-9]+$/.test(source[i]) || (source[i] === "_")) || (source[i] === "(")))) {
                    _it = tokens.push(make_tok("DERIV", "d", line));
                    i = _dx_add(save_i, 1);
                } else {
                    i = save_i;
                    _it = tokens.push(make_tok("IDENT", word, line));
                }
            } else if (_dx_contains(word, kw)) {
                _it = tokens.push(make_tok(kw[word], word, line));
            } else {
                _it = tokens.push(make_tok("IDENT", word, line));
            }
        } else if ((ch === "-")) {
            if (((_dx_add(i, 1) < source.length) && (source[_dx_add(i, 1)] === "-"))) {
                while (((i < source.length) && (source[i] !== "\n"))) {
                    i = _dx_add(i, 1);
                }
            } else if (((_dx_add(i, 1) < source.length) && (source[_dx_add(i, 1)] === ">"))) {
                _it = tokens.push(make_tok("ARROW", "->", line));
                i = _dx_add(i, 2);
            } else {
                _it = tokens.push(make_tok("MINUS", "-", line));
                i = _dx_add(i, 1);
            }
        } else if ((ch === "=")) {
            if (((_dx_add(i, 1) < source.length) && (source[_dx_add(i, 1)] === ">"))) {
                _it = tokens.push(make_tok("FAT_ARROW", "=>", line));
                i = _dx_add(i, 2);
            } else {
                _it = tokens.push(make_tok("EQ", "=", line));
                i = _dx_add(i, 1);
            }
        } else if ((ch === "<")) {
            if (((_dx_add(i, 1) < source.length) && (source[_dx_add(i, 1)] === ">"))) {
                _it = tokens.push(make_tok("NEQ", "<>", line));
                i = _dx_add(i, 2);
            } else if (((_dx_add(i, 1) < source.length) && (source[_dx_add(i, 1)] === "="))) {
                _it = tokens.push(make_tok("LE", "<=", line));
                i = _dx_add(i, 2);
            } else {
                _it = tokens.push(make_tok("LT", "<", line));
                i = _dx_add(i, 1);
            }
        } else if ((ch === ">")) {
            if (((_dx_add(i, 1) < source.length) && (source[_dx_add(i, 1)] === "="))) {
                _it = tokens.push(make_tok("GE", ">=", line));
                i = _dx_add(i, 2);
            } else {
                _it = tokens.push(make_tok("GT", ">", line));
                i = _dx_add(i, 1);
            }
        } else if ((ch === ":")) {
            _it = tokens.push(make_tok("COLON", ":", line));
            i = _dx_add(i, 1);
        } else if ((ch === "+")) {
            _it = tokens.push(make_tok("PLUS", "+", line));
            i = _dx_add(i, 1);
        } else if ((ch === "*")) {
            _it = tokens.push(make_tok("STAR", "*", line));
            i = _dx_add(i, 1);
        } else if ((ch === "/")) {
            _it = tokens.push(make_tok("SLASH", "/", line));
            i = _dx_add(i, 1);
        } else if ((ch === "%")) {
            _it = tokens.push(make_tok("PERCENT", "%", line));
            i = _dx_add(i, 1);
        } else if ((ch === "^")) {
            _it = tokens.push(make_tok("CARET", "^", line));
            i = _dx_add(i, 1);
        } else if ((ch === "(")) {
            _it = tokens.push(make_tok("LPAREN", "(", line));
            i = _dx_add(i, 1);
        } else if ((ch === ")")) {
            _it = tokens.push(make_tok("RPAREN", ")", line));
            i = _dx_add(i, 1);
        } else if ((ch === "[")) {
            _it = tokens.push(make_tok("LBRACKET", "[", line));
            i = _dx_add(i, 1);
        } else if ((ch === "]")) {
            _it = tokens.push(make_tok("RBRACKET", "]", line));
            i = _dx_add(i, 1);
        } else if ((ch === "{")) {
            _it = tokens.push(make_tok("LBRACE", "{", line));
            i = _dx_add(i, 1);
        } else if ((ch === "}")) {
            _it = tokens.push(make_tok("RBRACE", "}", line));
            i = _dx_add(i, 1);
        } else if ((ch === ",")) {
            _it = tokens.push(make_tok("COMMA", ",", line));
            i = _dx_add(i, 1);
        } else if ((ch === "'")) {
            _it = tokens.push(make_tok("APOST", "'", line));
            i = _dx_add(i, 1);
        } else if ((ch === ".")) {
            _it = tokens.push(make_tok("DOT", ".", line));
            i = _dx_add(i, 1);
        } else {
            i = _dx_add(i, 1);
        }
    }
    if ((tokens.length > 0)) {
        last_tt = tokens[(tokens.length - 1)].tt;
        if (((last_tt !== "NEWLINE") && (last_tt !== "DEDENT"))) {
            _it = tokens.push(make_tok("NEWLINE", "NL", line));
        }
    }
    while ((indent_stack.length > 1)) {
        _it = indent_stack.pop();
        _it = tokens.push(make_tok("DEDENT", "", line));
    }
    _it = tokens.push(make_tok("EOF", "", line));
    return tokens;
}

function ast_num(val) {
    let _it;
    return new _dx_app({kind: "Num", val: val});
}

function ast_str(val) {
    let _it;
    return new _dx_app({kind: "Str", val: val});
}

function ast_ident(name) {
    let _it;
    return new _dx_app({kind: "Ident", name: name});
}

function ast_bool(val) {
    let _it;
    return new _dx_app({kind: "Bool", val: val});
}

function ast_binop(op, left, right) {
    let _it;
    return new _dx_app({kind: "BinOp", op: op, left: left, right: right});
}

function ast_unary(op, operand) {
    let _it;
    return new _dx_app({kind: "Unary", op: op, operand: operand});
}

function ast_call(name, args) {
    let _it;
    return new _dx_app({kind: "Call", name: name, args: args});
}

function ast_assign(name, value) {
    let _it;
    return new _dx_app({kind: "Assign", name: name, value: value});
}

function ast_if(cond, body, else_body) {
    let _it;
    return new _dx_app({kind: "If", cond: cond, body: body, else_body: else_body});
}

function ast_method(obj, method, args) {
    let _it;
    return new _dx_app({kind: "Method", obj: obj, method: method, args: args});
}

function ast_index(obj, idx) {
    let _it;
    return new _dx_app({kind: "Index", obj: obj, idx: idx});
}

function ast_list(elements) {
    let _it;
    return new _dx_app({kind: "List", elements: elements});
}

function ast_while(cond, body) {
    let _it;
    return new _dx_app({kind: "While", cond: cond, body: body});
}

function ast_for(var_name, iter_expr, body) {
    let _it;
    return new _dx_app({kind: "For", var_name: var_name, iter_expr: iter_expr, body: body});
}

function ast_fundef(name, params, body) {
    let _it;
    return new _dx_app({kind: "FunDef", name: name, params: params, body: body});
}

function ast_return(value) {
    let _it;
    return new _dx_app({kind: "Return", value: value});
}

function ast_app(entries) {
    let _it;
    return new _dx_app({kind: "App", entries: entries});
}

function ast_app_entry(key, value) {
    let _it;
    return new _dx_app({key: key, value: value});
}

function ast_field(obj, name) {
    let _it;
    return new _dx_app({kind: "Field", obj: obj, name: name});
}

function ast_lambda(params, body) {
    let _it;
    return new _dx_app({kind: "Lambda", params: params, body: body});
}

function ast_deriv(expr, param) {
    let _it;
    return new _dx_app({kind: "Deriv", expr: expr, param: param});
}

function ast_index_assign(obj, idx, value) {
    let _it;
    return new _dx_app({kind: "IndexAssign", obj: obj, idx: idx, value: value});
}

function ast_typedef(name, fields) {
    let _it;
    return new _dx_app({kind: "TypeDef", name: name, fields: fields});
}

function ast_stack(elements) {
    let _it;
    return new _dx_app({kind: "Stack", elements: elements});
}

function ast_queue(elements) {
    let _it;
    return new _dx_app({kind: "Queue", elements: elements});
}

function ast_relationship(target, rel_kind, source, args) {
    let _it;
    return new _dx_app({kind: "Relationship", target: target, rel_kind: rel_kind, source: source, args: args});
}

function ast_hook(hook_kind, target_id, body) {
    let _it;
    return new _dx_app({kind: "Hook", hook_kind: hook_kind, target_id: target_id, body: body});
}

function make_parser(tokens) {
    let _it;
    return new _dx_app({tokens: tokens, pos: 0});
}

function peek(p) {
    let _it;
    if ((p.pos < p.tokens.length)) {
        return p.tokens[p.pos];
    }
    return p.tokens[(p.tokens.length - 1)];
}

function peek_type(p) {
    let _it;
    return peek(p).tt;
}

function advance(p) {
    let _it;
    let tok = peek(p);
    p["pos"] = _dx_add(p.pos, 1);
    return tok;
}

function eat(p, expected) {
    let _it;
    let tok = peek(p);
    if ((tok.tt !== expected)) {
        console.log(_dx_repr(_dx_add(_dx_add(_dx_add("Parse error: expected ", expected), " got "), tok.tt)));
        return tok;
    }
    p["pos"] = _dx_add(p.pos, 1);
    return tok;
}

function at(p, tt) {
    let _it;
    return (peek_type(p) === tt);
}

function skip_newlines(p) {
    let _it;
    while (at(p, "NEWLINE")) {
        _it = advance(p);
    }
}

function skip_whitespace(p) {
    let _it;
    while (((at(p, "NEWLINE") || at(p, "INDENT")) || at(p, "DEDENT"))) {
        _it = advance(p);
    }
}

function parse_block(p) {
    let _it;
    _it = eat(p, "INDENT");
    let stmts = [];
    while (((!at(p, "DEDENT")) && (!at(p, "EOF")))) {
        if (at(p, "NEWLINE")) {
            _it = advance(p);
        } else {
            _it = stmts.push(parse_statement(p));
        }
    }
    if (at(p, "DEDENT")) {
        _it = advance(p);
    }
    return stmts;
}

function parse_expr(p) {
    let _it;
    return parse_or(p);
}

function parse_or(p) {
    let _it;
    let left = parse_and(p);
    while (at(p, "OR")) {
        _it = advance(p);
        let right = parse_and(p);
        left = ast_binop("or", left, right);
    }
    return left;
}

function parse_and(p) {
    let _it;
    let left = parse_comparison(p);
    while (at(p, "AND")) {
        _it = advance(p);
        let right = parse_comparison(p);
        left = ast_binop("and", left, right);
    }
    return left;
}

function parse_comparison(p) {
    let _it;
    let left = parse_addition(p);
    let tt = peek_type(p);
    if ((((((((tt === "EQ") || (tt === "NEQ")) || (tt === "LT")) || (tt === "GT")) || (tt === "LE")) || (tt === "GE")) || (tt === "IN"))) {
        let op_tok = advance(p);
        let right = parse_addition(p);
        left = ast_binop(op_tok.val, left, right);
    }
    return left;
}

function parse_addition(p) {
    let _it;
    let left = parse_matmul(p);
    while ((at(p, "PLUS") || at(p, "MINUS"))) {
        let op_tok = advance(p);
        let right = parse_matmul(p);
        left = ast_binop(op_tok.val, left, right);
    }
    return left;
}

function parse_matmul(p) {
    let _it;
    let left = parse_multiplication(p);
    while (at(p, "MATMUL")) {
        let op_tok = advance(p);
        let right = parse_multiplication(p);
        left = ast_binop("o", left, right);
    }
    return left;
}

function parse_multiplication(p) {
    let _it;
    let left = parse_unary(p);
    while (((at(p, "STAR") || at(p, "SLASH")) || at(p, "PERCENT"))) {
        let op_tok = advance(p);
        let right = parse_unary(p);
        left = ast_binop(op_tok.val, left, right);
    }
    return left;
}

function parse_unary(p) {
    let _it;
    if (at(p, "MINUS")) {
        _it = advance(p);
        let operand = parse_unary(p);
        return ast_unary("-", operand);
    }
    if (at(p, "NOT")) {
        _it = advance(p);
        operand = parse_unary(p);
        return ast_unary("not", operand);
    }
    return parse_postfix(p);
}

function parse_postfix(p) {
    let _it;
    let node = parse_primary(p);
    while (((at(p, "LPAREN") || at(p, "LBRACKET")) || at(p, "APOST"))) {
        if (at(p, "LPAREN")) {
            if ((node.kind === "Ident")) {
                let args = parse_arglist(p);
                node = ast_call(node.name, args);
            } else {
                args = parse_arglist(p);
                node = ast_call("?", args);
            }
        } else if (at(p, "LBRACKET")) {
            _it = eat(p, "LBRACKET");
            let idx = parse_expr(p);
            _it = eat(p, "RBRACKET");
            node = ast_index(node, idx);
        } else if (at(p, "APOST")) {
            _it = eat(p, "APOST");
            let name = eat(p, "IDENT");
            if (at(p, "LPAREN")) {
                args = parse_arglist(p);
                node = ast_method(node, name.val, args);
            } else {
                node = ast_field(node, name.val);
            }
        }
    }
    return node;
}

function parse_arglist(p) {
    let _it;
    _it = eat(p, "LPAREN");
    let args = [];
    while (((!at(p, "RPAREN")) && (!at(p, "EOF")))) {
        _it = args.push(parse_expr(p));
        if (at(p, "COMMA")) {
            _it = advance(p);
        }
    }
    _it = eat(p, "RPAREN");
    return args;
}

function parse_primary(p) {
    let _it;
    let tt = peek_type(p);
    if ((tt === "INT")) {
        let tok = advance(p);
        return ast_num(tok.val);
    }
    if ((tt === "FLOAT")) {
        tok = advance(p);
        return ast_num(tok.val);
    }
    if ((tt === "STRING")) {
        tok = advance(p);
        return ast_str(tok.val);
    }
    if ((tt === "IDENT")) {
        tok = advance(p);
        if ((((tok.val === "Stack") || (tok.val === "Queue")) && at(p, "LBRACKET"))) {
            _it = eat(p, "LBRACKET");
            let elements = [];
            while (((!at(p, "RBRACKET")) && (!at(p, "EOF")))) {
                _it = elements.push(parse_expr(p));
                if (at(p, "COMMA")) {
                    _it = advance(p);
                }
            }
            _it = eat(p, "RBRACKET");
            if ((tok.val === "Stack")) {
                return ast_stack(elements);
            }
            return ast_queue(elements);
        }
        return ast_ident(tok.val);
    }
    if ((tt === "TRUE")) {
        _it = advance(p);
        return ast_bool("true");
    }
    if ((tt === "FALSE")) {
        _it = advance(p);
        return ast_bool("false");
    }
    if ((tt === "LPAREN")) {
        let saved = p.pos;
        _it = eat(p, "LPAREN");
        let params = [];
        let ok = true;
        if (at(p, "RPAREN")) {
            ok = true;
        } else if (at(p, "IDENT")) {
            _it = params.push(advance(p).val);
            while ((at(p, "COMMA") && ok)) {
                _it = advance(p);
                if (at(p, "IDENT")) {
                    _it = params.push(advance(p).val);
                } else {
                    ok = false;
                }
            }
        } else {
            ok = false;
        }
        if ((ok && at(p, "RPAREN"))) {
            _it = advance(p);
            if (at(p, "FAT_ARROW")) {
                _it = advance(p);
                let body = parse_expr(p);
                return ast_lambda(params, body);
            }
        }
        p["pos"] = saved;
        _it = eat(p, "LPAREN");
        let node = parse_expr(p);
        _it = eat(p, "RPAREN");
        return node;
    }
    if ((tt === "LBRACKET")) {
        _it = eat(p, "LBRACKET");
        let bracket_depth = 0;
        while (((at(p, "NEWLINE") || at(p, "INDENT")) || at(p, "DEDENT"))) {
            if (at(p, "INDENT")) {
                bracket_depth = _dx_add(bracket_depth, 1);
            }
            if (at(p, "DEDENT")) {
                bracket_depth = (bracket_depth - 1);
            }
            _it = advance(p);
        }
        elements = [];
        while (((!at(p, "RBRACKET")) && (!at(p, "EOF")))) {
            _it = elements.push(parse_expr(p));
            while (((at(p, "NEWLINE") || at(p, "INDENT")) || at(p, "DEDENT"))) {
                if (at(p, "INDENT")) {
                    bracket_depth = _dx_add(bracket_depth, 1);
                }
                if (at(p, "DEDENT")) {
                    bracket_depth = (bracket_depth - 1);
                }
                _it = advance(p);
            }
            if (at(p, "COMMA")) {
                _it = advance(p);
                while (((at(p, "NEWLINE") || at(p, "INDENT")) || at(p, "DEDENT"))) {
                    if (at(p, "INDENT")) {
                        bracket_depth = _dx_add(bracket_depth, 1);
                    }
                    if (at(p, "DEDENT")) {
                        bracket_depth = (bracket_depth - 1);
                    }
                    _it = advance(p);
                }
            }
        }
        _it = eat(p, "RBRACKET");
        while ((bracket_depth > 0)) {
            if (at(p, "NEWLINE")) {
                _it = advance(p);
            } else if (at(p, "DEDENT")) {
                _it = advance(p);
                bracket_depth = (bracket_depth - 1);
            } else {
                bracket_depth = 0;
            }
        }
        return ast_list(elements);
    }
    if ((tt === "LBRACE")) {
        _it = eat(p, "LBRACE");
        let brace_depth = 0;
        while (((at(p, "NEWLINE") || at(p, "INDENT")) || at(p, "DEDENT"))) {
            if (at(p, "INDENT")) {
                brace_depth = _dx_add(brace_depth, 1);
            }
            if (at(p, "DEDENT")) {
                brace_depth = (brace_depth - 1);
            }
            _it = advance(p);
        }
        let entries = [];
        while (((!at(p, "RBRACE")) && (!at(p, "EOF")))) {
            let key = eat(p, "IDENT").val;
            _it = eat(p, "EQ");
            let value = parse_expr(p);
            _it = entries.push(ast_app_entry(key, value));
            while (((at(p, "NEWLINE") || at(p, "INDENT")) || at(p, "DEDENT"))) {
                if (at(p, "INDENT")) {
                    brace_depth = _dx_add(brace_depth, 1);
                }
                if (at(p, "DEDENT")) {
                    brace_depth = (brace_depth - 1);
                }
                _it = advance(p);
            }
            if (at(p, "COMMA")) {
                _it = advance(p);
                while (((at(p, "NEWLINE") || at(p, "INDENT")) || at(p, "DEDENT"))) {
                    if (at(p, "INDENT")) {
                        brace_depth = _dx_add(brace_depth, 1);
                    }
                    if (at(p, "DEDENT")) {
                        brace_depth = (brace_depth - 1);
                    }
                    _it = advance(p);
                }
            }
        }
        _it = eat(p, "RBRACE");
        while ((brace_depth > 0)) {
            if (at(p, "NEWLINE")) {
                _it = advance(p);
            } else if (at(p, "DEDENT")) {
                _it = advance(p);
                brace_depth = (brace_depth - 1);
            } else {
                brace_depth = 0;
            }
        }
        return ast_app(entries);
    }
    if ((tt === "DERIV")) {
        _it = advance(p);
        let expr = parse_postfix(p);
        _it = eat(p, "DERIV");
        let param = eat(p, "IDENT").val;
        return ast_deriv(expr, param);
    }
    tok = advance(p);
    return ast_ident(_dx_add("ERROR:", tok.tt));
}

function parse_if_stmt(p) {
    let _it;
    _it = eat(p, "IF");
    let cond = parse_expr(p);
    _it = skip_newlines(p);
    let body = parse_block(p);
    let else_body = [];
    if (at(p, "ELSE")) {
        _it = advance(p);
        _it = skip_newlines(p);
        if (at(p, "IF")) {
            else_body = [parse_if_stmt(p)];
        } else {
            else_body = parse_block(p);
        }
    }
    return ast_if(cond, body, else_body);
}

function parse_while_stmt(p) {
    let _it;
    _it = eat(p, "WHILE");
    let cond = parse_expr(p);
    _it = skip_newlines(p);
    let body = parse_block(p);
    return ast_while(cond, body);
}

function parse_for_stmt(p) {
    let _it;
    _it = eat(p, "FOR");
    let var_name = eat(p, "IDENT").val;
    _it = eat(p, "IN");
    let iter_expr = parse_expr(p);
    _it = skip_newlines(p);
    let body = parse_block(p);
    return ast_for(var_name, iter_expr, body);
}

function parse_type_ann(p) {
    let _it;
    let tname = eat(p, "IDENT").val;
    let dims = [];
    if (at(p, "LBRACKET")) {
        _it = advance(p);
        while (((!at(p, "RBRACKET")) && (!at(p, "EOF")))) {
            _it = dims.push((eat(p, "INT").val * 1));
        }
        _it = eat(p, "RBRACKET");
    }
    return new _dx_app({name: tname, dims: dims});
}

function parse_fundef_stmt(p) {
    let _it;
    _it = eat(p, "FUN");
    let name = eat(p, "IDENT").val;
    let type_name = "";
    let method_name = name;
    if (at(p, "APOST")) {
        _it = advance(p);
        type_name = name;
        method_name = eat(p, "IDENT").val;
        name = method_name;
    }
    let params = [];
    let param_types = [];
    if (at(p, "LPAREN")) {
        _it = eat(p, "LPAREN");
        while (((!at(p, "RPAREN")) && (!at(p, "EOF")))) {
            let pname = eat(p, "IDENT").val;
            _it = params.push(pname);
            if (at(p, "COLON")) {
                _it = advance(p);
                _it = param_types.push(parse_type_ann(p));
            } else {
                _it = param_types.push(new _dx_app({name: "", dims: []}));
            }
            if (at(p, "COMMA")) {
                _it = advance(p);
            }
        }
        _it = eat(p, "RPAREN");
    }
    let ret_type = new _dx_app({});
    if (at(p, "ARROW")) {
        _it = advance(p);
        ret_type = parse_type_ann(p);
    }
    _it = skip_newlines(p);
    let body = parse_block(p);
    return new _dx_app({kind: "FunDef", name: name, type_name: type_name, method_name: method_name, params: params, param_types: param_types, return_type: ret_type, body: body});
}

function parse_return_stmt(p) {
    let _it;
    _it = eat(p, "RETURN");
    if (((at(p, "NEWLINE") || at(p, "EOF")) || at(p, "DEDENT"))) {
        return ast_return(ast_num("0"));
    }
    let value = parse_expr(p);
    return ast_return(value);
}

function parse_typedef(p) {
    let _it;
    _it = eat(p, "TYPE");
    let name = eat(p, "IDENT").val;
    _it = skip_newlines(p);
    _it = eat(p, "INDENT");
    let fields = [];
    while (((!at(p, "DEDENT")) && (!at(p, "EOF")))) {
        if (at(p, "NEWLINE")) {
            _it = advance(p);
        } else {
            let fname = eat(p, "IDENT").val;
            _it = eat(p, "COLON");
            let ftype = eat(p, "IDENT").val;
            let fdims = [];
            if (at(p, "LBRACKET")) {
                _it = advance(p);
                while (((!at(p, "RBRACKET")) && (!at(p, "EOF")))) {
                    _it = fdims.push((eat(p, "INT").val * 1));
                }
                _it = eat(p, "RBRACKET");
            }
            _it = fields.push(new _dx_app({name: fname, type_name: ftype, dims: fdims}));
        }
    }
    if (at(p, "DEDENT")) {
        _it = advance(p);
    }
    return ast_typedef(name, fields);
}

function parse_relationship(p) {
    let _it;
    let target = eat(p, "IDENT").val;
    let rel_kind = "";
    if (at(p, "IS")) {
        _it = eat(p, "IS");
        if ((at(p, "IDENT") && (peek(p).val === "a"))) {
            _it = advance(p);
            rel_kind = "is_a";
        } else {
            rel_kind = "is";
        }
    } else if (at(p, "HAS")) {
        _it = eat(p, "HAS");
        if ((at(p, "IDENT") && (peek(p).val === "a"))) {
            _it = advance(p);
        }
        rel_kind = "has_a";
    }
    let source = eat(p, "IDENT").val;
    let args = [];
    if (at(p, "LPAREN")) {
        args = parse_arglist(p);
    }
    return ast_relationship(target, rel_kind, source, args);
}

function parse_hook(p) {
    let _it;
    let hook_kind = advance(p).val;
    let target_id = "";
    if (at(p, "IDENT")) {
        target_id = eat(p, "IDENT").val;
    }
    _it = skip_newlines(p);
    let body = parse_block(p);
    return ast_hook(hook_kind, target_id, body);
}

function parse_statement(p) {
    let _it;
    if (at(p, "IF")) {
        return parse_if_stmt(p);
    }
    if (at(p, "WHILE")) {
        return parse_while_stmt(p);
    }
    if (at(p, "FOR")) {
        return parse_for_stmt(p);
    }
    if (at(p, "FUN")) {
        return parse_fundef_stmt(p);
    }
    if (at(p, "RETURN")) {
        return parse_return_stmt(p);
    }
    if (((at(p, "PRE") || at(p, "POST")) || at(p, "ON"))) {
        return parse_hook(p);
    }
    if (at(p, "TYPE")) {
        return parse_typedef(p);
    }
    if (at(p, "IDENT")) {
        if (((_dx_add(p.pos, 1) < p.tokens.length) && ((p.tokens[_dx_add(p.pos, 1)].tt === "IS") || (p.tokens[_dx_add(p.pos, 1)].tt === "HAS")))) {
            return parse_relationship(p);
        }
    }
    if (at(p, "IDENT")) {
        let tok = peek(p);
        if (((_dx_add(p.pos, 1) < p.tokens.length) && (p.tokens[_dx_add(p.pos, 1)].tt === "COLON"))) {
            _it = advance(p);
            _it = eat(p, "COLON");
            let value = parse_expr(p);
            return ast_assign(tok.val, value);
        }
    }
    let expr = parse_expr(p);
    if (at(p, "COLON")) {
        _it = eat(p, "COLON");
        value = parse_expr(p);
        if ((expr.kind === "Index")) {
            return ast_index_assign(expr.obj, expr.idx, value);
        }
        return ast_assign("?", value);
    }
    return expr;
}

function parse_program(p) {
    let _it;
    let stmts = [];
    while ((!at(p, "EOF"))) {
        if (at(p, "NEWLINE")) {
            _it = advance(p);
        } else if (at(p, "DEDENT")) {
            _it = advance(p);
        } else {
            _it = stmts.push(parse_statement(p));
        }
    }
    return stmts;
}

function ast_to_str(node) {
    let _it;
    if ((node.kind === "Num")) {
        return node.val;
    }
    if ((node.kind === "Str")) {
        return _dx_add(_dx_add("\"", node.val), "\"");
    }
    if ((node.kind === "Ident")) {
        return node.name;
    }
    if ((node.kind === "Bool")) {
        return node.val;
    }
    if ((node.kind === "BinOp")) {
        return _dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("(", ast_to_str(node.left)), " "), node.op), " "), ast_to_str(node.right)), ")");
    }
    if ((node.kind === "Unary")) {
        return _dx_add(_dx_add(_dx_add(_dx_add("(", node.op), " "), ast_to_str(node.operand)), ")");
    }
    if ((node.kind === "Call")) {
        let args_str = node.args.map(((a) => ast_to_str(a)));
        return _dx_add(_dx_add(_dx_add(node.name, "("), args_str.join(", ")), ")");
    }
    if ((node.kind === "Method")) {
        args_str = node.args.map(((a) => ast_to_str(a)));
        return _dx_add(_dx_add(_dx_add(_dx_add(_dx_add(ast_to_str(node.obj), "'"), node.method), "("), args_str.join(", ")), ")");
    }
    if ((node.kind === "Index")) {
        return _dx_add(_dx_add(_dx_add(ast_to_str(node.obj), "["), ast_to_str(node.idx)), "]");
    }
    if ((node.kind === "Assign")) {
        return _dx_add(_dx_add(node.name, " : "), ast_to_str(node.value));
    }
    if ((node.kind === "List")) {
        let elems = node.elements.map(((e) => ast_to_str(e)));
        return _dx_add(_dx_add("[", elems.join(", ")), "]");
    }
    if ((node.kind === "Field")) {
        return _dx_add(_dx_add(ast_to_str(node.obj), "'"), node.name);
    }
    if ((node.kind === "App")) {
        let pairs = node.entries.map(((e) => _dx_add(_dx_add(e.key, " = "), ast_to_str(e.value))));
        return _dx_add(_dx_add("{", pairs.join(", ")), "}");
    }
    if ((node.kind === "Lambda")) {
        let params_str = node.params.join(", ");
        return _dx_add(_dx_add(_dx_add("(", params_str), ") => "), ast_to_str(node.body));
    }
    if ((node.kind === "IndexAssign")) {
        return _dx_add(_dx_add(_dx_add(_dx_add(ast_to_str(node.obj), "["), ast_to_str(node.idx)), "] : "), ast_to_str(node.value));
    }
    if ((node.kind === "Relationship")) {
        return _dx_add(_dx_add(_dx_add(_dx_add(node.target, " "), node.rel_kind), " "), node.source);
    }
    if ((node.kind === "Hook")) {
        return _dx_add(_dx_add(node.hook_kind, " "), node.target_id);
    }
    if ((node.kind === "TypeDef")) {
        return _dx_add("type ", node.name);
    }
    if ((node.kind === "Stack")) {
        elems = node.elements.map(((e) => ast_to_str(e)));
        return _dx_add(_dx_add("Stack[", elems.join(", ")), "]");
    }
    if ((node.kind === "Queue")) {
        elems = node.elements.map(((e) => ast_to_str(e)));
        return _dx_add(_dx_add("Queue[", elems.join(", ")), "]");
    }
    return "?";
}

// dxPhase1: derivation expansion written in dx
function deep_copy(node) {
    let _it;
    let kind = node.kind;
    if ((kind === "Num")) {
        return new _dx_app({kind: "Num", val: node.val});
    }
    if ((kind === "Str")) {
        return new _dx_app({kind: "Str", val: node.val});
    }
    if ((kind === "Ident")) {
        return new _dx_app({kind: "Ident", name: node.name});
    }
    if ((kind === "Bool")) {
        return new _dx_app({kind: "Bool", val: node.val});
    }
    if ((kind === "BinOp")) {
        return new _dx_app({kind: "BinOp", op: node.op, left: deep_copy(node.left), right: deep_copy(node.right)});
    }
    if ((kind === "Unary")) {
        return new _dx_app({kind: "Unary", op: node.op, operand: deep_copy(node.operand)});
    }
    if ((kind === "Call")) {
        return new _dx_app({kind: "Call", name: node.name, args: deep_copy_list(node.args)});
    }
    if ((kind === "Assign")) {
        return new _dx_app({kind: "Assign", name: node.name, value: deep_copy(node.value)});
    }
    if ((kind === "If")) {
        return new _dx_app({kind: "If", cond: deep_copy(node.cond), body: deep_copy_list(node.body), else_body: deep_copy_list(node.else_body)});
    }
    if ((kind === "Method")) {
        return new _dx_app({kind: "Method", obj: deep_copy(node.obj), method: node.method, args: deep_copy_list(node.args)});
    }
    if ((kind === "Index")) {
        return new _dx_app({kind: "Index", obj: deep_copy(node.obj), idx: deep_copy(node.idx)});
    }
    if ((kind === "List")) {
        return new _dx_app({kind: "List", elements: deep_copy_list(node.elements)});
    }
    if ((kind === "While")) {
        return new _dx_app({kind: "While", cond: deep_copy(node.cond), body: deep_copy_list(node.body)});
    }
    if ((kind === "For")) {
        return new _dx_app({kind: "For", var_name: node.var_name, iter_expr: deep_copy(node.iter_expr), body: deep_copy_list(node.body)});
    }
    if ((kind === "FunDef")) {
        let new_params = [];
        for (const pm of node.params) {
            _it = new_params.push(pm);
        }
        return new _dx_app({kind: "FunDef", name: node.name, params: new_params, body: deep_copy_list(node.body)});
    }
    if ((kind === "Return")) {
        return new _dx_app({kind: "Return", value: deep_copy(node.value)});
    }
    if ((kind === "App")) {
        let new_entries = [];
        for (const e of node.entries) {
            _it = new_entries.push(new _dx_app({key: e.key, value: deep_copy(e.value)}));
        }
        return new _dx_app({kind: "App", entries: new_entries});
    }
    if ((kind === "Field")) {
        return new _dx_app({kind: "Field", obj: deep_copy(node.obj), name: node.name});
    }
    if ((kind === "Lambda")) {
        new_params = [];
        for (const pm of node.params) {
            _it = new_params.push(pm);
        }
        return new _dx_app({kind: "Lambda", params: new_params, body: deep_copy(node.body)});
    }
    if ((kind === "IndexAssign")) {
        return new _dx_app({kind: "IndexAssign", obj: deep_copy(node.obj), idx: deep_copy(node.idx), value: deep_copy(node.value)});
    }
    if ((kind === "Relationship")) {
        let new_args = deep_copy_list(node.args);
        return new _dx_app({kind: "Relationship", target: node.target, rel_kind: node.rel_kind, source: node.source, args: new_args});
    }
    if ((kind === "Hook")) {
        return new _dx_app({kind: "Hook", hook_kind: node.hook_kind, target_id: node.target_id, body: deep_copy_list(node.body)});
    }
    if ((kind === "TypeDef")) {
        let new_fields = [];
        for (const f of node.fields) {
            _it = new_fields.push(new _dx_app({name: f.name, type_name: f.type_name}));
        }
        return new _dx_app({kind: "TypeDef", name: node.name, fields: new_fields});
    }
    if ((kind === "Stack")) {
        return new _dx_app({kind: "Stack", elements: deep_copy_list(node.elements)});
    }
    if ((kind === "Queue")) {
        return new _dx_app({kind: "Queue", elements: deep_copy_list(node.elements)});
    }
    return node;
}

function deep_copy_list(stmts) {
    let _it;
    let result = [];
    for (const s of stmts) {
        _it = result.push(deep_copy(s));
    }
    return result;
}

function substitute(node, pmap) {
    let _it;
    let kind = node.kind;
    if ((kind === "Ident")) {
        if (_dx_contains(node.name, pmap)) {
            return deep_copy(pmap[node.name]);
        }
        return node;
    }
    if ((kind === "Num")) {
        return node;
    }
    if ((kind === "Str")) {
        return node;
    }
    if ((kind === "Bool")) {
        return node;
    }
    if ((kind === "BinOp")) {
        node["left"] = substitute(node.left, pmap);
        node["right"] = substitute(node.right, pmap);
        return node;
    }
    if ((kind === "Unary")) {
        node["operand"] = substitute(node.operand, pmap);
        return node;
    }
    if ((kind === "Call")) {
        if (_dx_contains(node.name, pmap)) {
            let replacement = pmap[node.name];
            if ((replacement.kind === "Ident")) {
                node["name"] = replacement.name;
            }
        }
        node["args"] = substitute_list(node.args, pmap);
        return node;
    }
    if ((kind === "Assign")) {
        node["value"] = substitute(node.value, pmap);
        return node;
    }
    if ((kind === "If")) {
        node["cond"] = substitute(node.cond, pmap);
        node["body"] = substitute_list(node.body, pmap);
        node["else_body"] = substitute_list(node.else_body, pmap);
        return node;
    }
    if ((kind === "Method")) {
        node["obj"] = substitute(node.obj, pmap);
        node["args"] = substitute_list(node.args, pmap);
        return node;
    }
    if ((kind === "Index")) {
        node["obj"] = substitute(node.obj, pmap);
        node["idx"] = substitute(node.idx, pmap);
        return node;
    }
    if ((kind === "List")) {
        node["elements"] = substitute_list(node.elements, pmap);
        return node;
    }
    if ((kind === "While")) {
        node["cond"] = substitute(node.cond, pmap);
        node["body"] = substitute_list(node.body, pmap);
        return node;
    }
    if ((kind === "For")) {
        node["iter_expr"] = substitute(node.iter_expr, pmap);
        node["body"] = substitute_list(node.body, pmap);
        return node;
    }
    if ((kind === "FunDef")) {
        node["body"] = substitute_list(node.body, pmap);
        return node;
    }
    if ((kind === "Return")) {
        node["value"] = substitute(node.value, pmap);
        return node;
    }
    if ((kind === "App")) {
        let new_entries = [];
        for (const e of node.entries) {
            _it = new_entries.push(new _dx_app({key: e.key, value: substitute(e.value, pmap)}));
        }
        node["entries"] = new_entries;
        return node;
    }
    if ((kind === "Field")) {
        node["obj"] = substitute(node.obj, pmap);
        return node;
    }
    if ((kind === "Lambda")) {
        let inner_map = new _dx_app({});
        for (const k of pmap) {
            let shadowed = false;
            for (const lp of node.params) {
                if ((lp === k)) {
                    shadowed = true;
                }
            }
            if ((!shadowed)) {
                inner_map[k] = pmap[k];
            }
        }
        node["body"] = substitute(node.body, inner_map);
        return node;
    }
    if ((kind === "IndexAssign")) {
        node["obj"] = substitute(node.obj, pmap);
        node["idx"] = substitute(node.idx, pmap);
        node["value"] = substitute(node.value, pmap);
        return node;
    }
    return node;
}

function substitute_list(stmts, pmap) {
    let _it;
    let result = [];
    for (const s of stmts) {
        _it = result.push(substitute(s, pmap));
    }
    return result;
}

function insert_before_returns(body, stmts) {
    let _it;
    let inserted = false;
    let i = 0;
    while ((i < body.length)) {
        let stmt = body[i];
        if ((stmt.kind === "Return")) {
            let j = 0;
            while ((j < stmts.length)) {
                _it = body.insert(_dx_add(i, j), deep_copy(stmts[j]));
                j = _dx_add(j, 1);
            }
            i = _dx_add(_dx_add(i, stmts.length), 1);
            inserted = true;
        } else {
            if ((stmt.kind === "If")) {
                let r1 = insert_before_returns(stmt.body, stmts);
                let r2 = insert_before_returns(stmt.else_body, stmts);
                if ((r1 || r2)) {
                    inserted = true;
                }
            }
            if ((stmt.kind === "While")) {
                let r = insert_before_returns(stmt.body, stmts);
                if (r) {
                    inserted = true;
                }
            }
            if ((stmt.kind === "For")) {
                r = insert_before_returns(stmt.body, stmts);
                if (r) {
                    inserted = true;
                }
            }
            i = _dx_add(i, 1);
        }
    }
    if ((!inserted)) {
        for (const s of stmts) {
            _it = body.push(deep_copy(s));
        }
    }
    return inserted;
}

function apply_hooks(body, hooks) {
    let _it;
    for (const hook of hooks) {
        if ((hook.target_id === "")) {
            if ((hook.hook_kind === "pre")) {
                let j = 0;
                for (const s of hook.body) {
                    _it = body.insert(j, deep_copy(s));
                    j = _dx_add(j, 1);
                }
            } else if ((hook.hook_kind === "post")) {
                _it = insert_before_returns(body, hook.body);
            }
        }
    }
}

function expand_is(rel, hooks, functions, out_stmts) {
    let _it;
    if (((hooks.length > 0) && _dx_contains(rel.source, functions))) {
        let source = functions[rel.source];
        _it = apply_hooks(source.body, hooks);
    }
    let i = 0;
    while ((i < out_stmts.length)) {
        if (((out_stmts[i].kind === "Relationship") && (out_stmts[i].target === rel.target))) {
            out_stmts[i] = new _dx_app({kind: "Assign", name: rel.target, value: new _dx_app({kind: "Ident", name: rel.source})});
            return 0;
        }
        i = _dx_add(i, 1);
    }
    return 0;
}

function expand_is_a(rel, hooks, functions, out_stmts) {
    let _it;
    if ((!_dx_contains(rel.source, functions))) {
        return 0;
    }
    let source = functions[rel.source];
    let new_body = deep_copy_list(source.body);
    let new_params = [];
    for (const pm of source.params) {
        _it = new_params.push(pm);
    }
    if ((rel.args.length > 0)) {
        let pmap = new _dx_app({});
        let pi = 0;
        while (((pi < source.params.length) && (pi < rel.args.length))) {
            pmap[source.params[pi]] = rel.args[pi];
            pi = _dx_add(pi, 1);
        }
        new_body = substitute_list(new_body, pmap);
        let remaining = [];
        let ri = 0;
        while ((ri < source.params.length)) {
            if ((ri >= rel.args.length)) {
                _it = remaining.push(source.params[ri]);
            }
            ri = _dx_add(ri, 1);
        }
        new_params = remaining;
    }
    _it = apply_hooks(new_body, hooks);
    let new_fun = new _dx_app({kind: "FunDef", name: rel.target, params: new_params, body: new_body});
    functions[rel.target] = new_fun;
    let i = 0;
    while ((i < out_stmts.length)) {
        if (((out_stmts[i].kind === "Relationship") && (out_stmts[i].target === rel.target))) {
            out_stmts[i] = new_fun;
            return 0;
        }
        i = _dx_add(i, 1);
    }
    return 0;
}

function expand_has_a(rel, hooks, corr_params, functions, out_stmts) {
    let _it;
    if ((!_dx_contains(rel.source, functions))) {
        return 0;
    }
    let source = functions[rel.source];
    let new_body = deep_copy_list(source.body);
    let remaining_source = [];
    for (const pm of source.params) {
        _it = remaining_source.push(pm);
    }
    if ((rel.args.length > 0)) {
        let pmap = new _dx_app({});
        let pi = 0;
        while (((pi < source.params.length) && (pi < rel.args.length))) {
            pmap[source.params[pi]] = rel.args[pi];
            pi = _dx_add(pi, 1);
        }
        new_body = substitute_list(new_body, pmap);
        remaining_source = [];
        let ri = 0;
        while ((ri < source.params.length)) {
            if ((ri >= rel.args.length)) {
                _it = remaining_source.push(source.params[ri]);
            }
            ri = _dx_add(ri, 1);
        }
    }
    let combined = [];
    for (const cp of corr_params) {
        _it = combined.push(cp);
    }
    for (const rp of remaining_source) {
        _it = combined.push(rp);
    }
    _it = apply_hooks(new_body, hooks);
    let new_fun = new _dx_app({kind: "FunDef", name: rel.target, params: combined, body: new_body});
    functions[rel.target] = new_fun;
    let i = 0;
    while ((i < out_stmts.length)) {
        if (((out_stmts[i].kind === "Relationship") && (out_stmts[i].target === rel.target))) {
            out_stmts[i] = new_fun;
            return 0;
        }
        i = _dx_add(i, 1);
    }
    return 0;
}

function phase1(stmts) {
    let _it;
    let functions = new _dx_app({});
    let relationships = [];
    let out_stmts = [];
    for (const stmt of stmts) {
        if ((stmt.kind === "FunDef")) {
            functions[stmt.name] = stmt;
            _it = out_stmts.push(stmt);
        } else if ((stmt.kind === "Relationship")) {
            _it = relationships.push(stmt);
            _it = out_stmts.push(stmt);
        } else {
            _it = out_stmts.push(stmt);
        }
    }
    let consumed = new _dx_app({});
    let derivations = [];
    for (const rel of relationships) {
        let hooks = [];
        let corr_params = [];
        if (_dx_contains(rel.target, functions)) {
            let corr_fun = functions[rel.target];
            for (const s of corr_fun.body) {
                if ((s.kind === "Hook")) {
                    _it = hooks.push(s);
                }
            }
            if ((rel.rel_kind === "has_a")) {
                for (const cp of corr_fun.params) {
                    _it = corr_params.push(cp);
                }
            }
            consumed[rel.target] = true;
        }
        _it = derivations.push(new _dx_app({rel: rel, hooks: hooks, corr_params: corr_params}));
    }
    let filtered = [];
    for (const stmt of out_stmts) {
        if (((stmt.kind === "FunDef") && _dx_contains(stmt.name, consumed))) {
            filtered = filtered;
        } else {
            _it = filtered.push(stmt);
        }
    }
    out_stmts = filtered;
    for (const deriv of derivations) {
        let rel = deriv.rel;
        if ((rel.rel_kind === "is")) {
            _it = expand_is(rel, deriv.hooks, functions, out_stmts);
        } else if ((rel.rel_kind === "is_a")) {
            _it = expand_is_a(rel, deriv.hooks, functions, out_stmts);
        } else if ((rel.rel_kind === "has_a")) {
            _it = expand_has_a(rel, deriv.hooks, deriv.corr_params, functions, out_stmts);
        }
    }
    return out_stmts;
}

// dxLower: AST → IR lowering written in dx
function normalize_binop(op) {
    let _it;
    if ((op === "+")) {
        return "add";
    }
    if ((op === "-")) {
        return "sub";
    }
    if ((op === "*")) {
        return "mul";
    }
    if ((op === "/")) {
        return "div";
    }
    if ((op === "%")) {
        return "mod";
    }
    if ((op === "^")) {
        return "pow";
    }
    if ((op === "=")) {
        return "eq";
    }
    if ((op === "<>")) {
        return "neq";
    }
    if ((op === "<")) {
        return "lt";
    }
    if ((op === ">")) {
        return "gt";
    }
    if ((op === "<=")) {
        return "le";
    }
    if ((op === ">=")) {
        return "ge";
    }
    if ((op === "and")) {
        return "and";
    }
    if ((op === "or")) {
        return "or";
    }
    if ((op === "in")) {
        return "in";
    }
    if ((op === "o")) {
        return "matmul";
    }
    return op;
}

function normalize_unaryop(op) {
    let _it;
    if ((op === "-")) {
        return "neg";
    }
    if ((op === "not")) {
        return "not";
    }
    return op;
}

function lower_expr(node) {
    let _it;
    let kind = node.kind;
    if ((kind === "Num")) {
        return new _dx_app({kind: "IRNum", value: node.val});
    }
    if ((kind === "Str")) {
        return new _dx_app({kind: "IRStr", value: node.val});
    }
    if ((kind === "Ident")) {
        if ((node.name === "me")) {
            return new _dx_app({kind: "IRSelf"});
        }
        return new _dx_app({kind: "IRVar", name: node.name});
    }
    if ((kind === "Bool")) {
        return new _dx_app({kind: "IRBool", value: node.val});
    }
    if ((kind === "BinOp")) {
        return new _dx_app({kind: "IRBinOp", op: normalize_binop(node.op), left: lower_expr(node.left), right: lower_expr(node.right)});
    }
    if ((kind === "Unary")) {
        return new _dx_app({kind: "IRUnaryOp", op: normalize_unaryop(node.op), operand: lower_expr(node.operand)});
    }
    if ((kind === "Call")) {
        let new_args = node.args.map(((a) => lower_expr(a)));
        return new _dx_app({kind: "IRCall", func: new _dx_app({kind: "IRVar", name: node.name}), args: new_args});
    }
    if ((kind === "Method")) {
        new_args = node.args.map(((a) => lower_expr(a)));
        return new _dx_app({kind: "IRMethodCall", obj: lower_expr(node.obj), method: node.method, args: new_args});
    }
    if ((kind === "Index")) {
        return new _dx_app({kind: "IRIndex", obj: lower_expr(node.obj), index: lower_expr(node.idx)});
    }
    if ((kind === "List")) {
        return new _dx_app({kind: "IRVec", elements: node.elements.map(((e) => lower_expr(e)))});
    }
    if ((kind === "App")) {
        let new_entries = [];
        for (const e of node.entries) {
            _it = new_entries.push(new _dx_app({key: e.key, value: lower_expr(e.value)}));
        }
        return new _dx_app({kind: "IRApp", entries: new_entries});
    }
    if ((kind === "Field")) {
        return new _dx_app({kind: "IRFieldGet", obj: lower_expr(node.obj), field_name: node.name});
    }
    if ((kind === "Lambda")) {
        return new _dx_app({kind: "IRLambda", params: node.params, body: lower_expr(node.body)});
    }
    if ((kind === "Deriv")) {
        return new _dx_app({kind: "IRDeriv", expr: lower_expr(node.expr), param: node.param});
    }
    if ((kind === "Stack")) {
        return new _dx_app({kind: "IRStack", elements: node.elements.map(((e) => lower_expr(e)))});
    }
    if ((kind === "Queue")) {
        return new _dx_app({kind: "IRQueue", elements: node.elements.map(((e) => lower_expr(e)))});
    }
    return node;
}

function lower_fundef(node) {
    let _it;
    let body = lower(node.body);
    let nkeys = Object.keys(node).length;
    if ((nkeys > 4)) {
        return new _dx_app({kind: "IRFuncDef", name: node.method_name, type_name: node.type_name, params: node.params, param_types: node.param_types, return_type: node.return_type, body: body});
    }
    return new _dx_app({kind: "IRFuncDef", name: node.name, type_name: "", params: node.params, param_types: [], return_type: new _dx_app({}), body: body});
}

function lower_stmt(node) {
    let _it;
    let kind = node.kind;
    if ((kind === "Assign")) {
        return new _dx_app({kind: "IRAssign", target: new _dx_app({kind: "IRVar", name: node.name}), value: lower_expr(node.value)});
    }
    if ((kind === "FunDef")) {
        return lower_fundef(node);
    }
    if ((kind === "If")) {
        return new _dx_app({kind: "IRIf", condition: lower_expr(node.cond), body: lower(node.body), else_body: lower(node.else_body)});
    }
    if ((kind === "While")) {
        return new _dx_app({kind: "IRWhile", condition: lower_expr(node.cond), body: lower(node.body)});
    }
    if ((kind === "For")) {
        return new _dx_app({kind: "IRFor", var: node.var_name, iterable: lower_expr(node.iter_expr), body: lower(node.body)});
    }
    if ((kind === "Return")) {
        return new _dx_app({kind: "IRReturn", value: lower_expr(node.value)});
    }
    if ((kind === "IndexAssign")) {
        return new _dx_app({kind: "IRAssign", target: new _dx_app({kind: "IRIndex", obj: lower_expr(node.obj), index: lower_expr(node.idx)}), value: lower_expr(node.value)});
    }
    if ((kind === "TypeDef")) {
        let new_fields = [];
        for (const f of node.fields) {
            let dims = [];
            if ((Object.keys(f).length > 2)) {
                dims = f.dims;
            }
            _it = new_fields.push(new _dx_app({name: f.name, type_name: f.type_name, dims: dims}));
        }
        return new _dx_app({kind: "IRTypeDef", name: node.name, fields: new_fields});
    }
    if ((kind === "Relationship")) {
        return new _dx_app({kind: "IRComment", text: _dx_add(_dx_add(_dx_add(_dx_add(node.target, " "), node.rel_kind), " "), node.source)});
    }
    if (((kind === "Call") && (node.name === "print"))) {
        let new_args = node.args.map(((a) => lower_expr(a)));
        return new _dx_app({kind: "IRPrint", args: new_args});
    }
    return new _dx_app({kind: "IRExprStmt", expr: lower_expr(node)});
}

function lower(stmts) {
    let _it;
    let result = [];
    for (const s of stmts) {
        if ((s.kind === "Hook")) {
            for (const h of s.body) {
                _it = result.push(lower_stmt(h));
            }
        } else {
            _it = result.push(lower_stmt(s));
        }
    }
    return result;
}

// thisIsTheBootstrapPath: dx compiling itself to JS (runs in browser/node)
function js_prelude() {
    let _it;
    let r = "// dx runtime prelude\n\n";
    r = _dx_add(r, "class _dx_app {\n");
    r = _dx_add(r, "    constructor(obj) {\n");
    r = _dx_add(r, "        for (const [k, v] of Object.entries(obj)) { this[k] = v; }\n");
    r = _dx_add(r, "    }\n");
    r = _dx_add(r, "    size() { return Object.keys(this).length; }\n");
    r = _dx_add(r, "    keys() { return Object.keys(this); }\n");
    r = _dx_add(r, "    values() { return Object.values(this); }\n");
    r = _dx_add(r, "}\n\n");
    r = _dx_add(r, "function _dx_fold(seq, init, fn) {\n");
    r = _dx_add(r, "    if (fn === undefined) {\n");
    r = _dx_add(r, "        fn = init; let it = seq[Symbol.iterator]();\n");
    r = _dx_add(r, "        let acc = it.next().value;\n");
    r = _dx_add(r, "        for (const x of it) { acc = fn(acc, x); }\n");
    r = _dx_add(r, "        return acc;\n");
    r = _dx_add(r, "    }\n");
    r = _dx_add(r, "    let acc = init;\n");
    r = _dx_add(r, "    for (const x of seq) { acc = fn(acc, x); }\n");
    r = _dx_add(r, "    return acc;\n");
    r = _dx_add(r, "}\n\n");
    r = _dx_add(r, "function _dx_eq(a, b) {\n");
    r = _dx_add(r, "    if (a === b) return true;\n");
    r = _dx_add(r, "    if (typeof a === 'object' && a !== null && typeof a.equals === 'function') return a.equals(b);\n");
    r = _dx_add(r, "    return false;\n");
    r = _dx_add(r, "}\n\n");
    r = _dx_add(r, "function _dx_add(a, b) {\n");
    r = _dx_add(r, "    if (Array.isArray(a)) return a.concat(b);\n");
    r = _dx_add(r, "    return a + b;\n");
    r = _dx_add(r, "}\n\n");
    r = _dx_add(r, "function _dx_contains(item, coll) {\n");
    r = _dx_add(r, "    if (coll instanceof Set) return coll.has(item);\n");
    r = _dx_add(r, "    if (Array.isArray(coll)) {\n");
    r = _dx_add(r, "        if (typeof item === 'object' && item !== null && typeof item.equals === 'function') return coll.some(x => item.equals(x));\n");
    r = _dx_add(r, "        return coll.includes(item);\n");
    r = _dx_add(r, "    }\n");
    r = _dx_add(r, "    if (typeof coll === 'string') return coll.includes(item);\n");
    r = _dx_add(r, "    if (coll && typeof coll === 'object') {\n");
    r = _dx_add(r, "        if (typeof item === 'object' && item !== null && typeof item.toString === 'function' && item.toString !== Object.prototype.toString) return Object.prototype.hasOwnProperty.call(coll, item.toString());\n");
    r = _dx_add(r, "        return Object.prototype.hasOwnProperty.call(coll, item);\n");
    r = _dx_add(r, "    }\n");
    r = _dx_add(r, "    return false;\n");
    r = _dx_add(r, "}\n\n");
    r = _dx_add(r, "class _dx_stack {\n");
    r = _dx_add(r, "    constructor(a) { this._d = [...(a || [])]; }\n");
    r = _dx_add(r, "    put(v) { this._d.push(v); }\n");
    r = _dx_add(r, "    get() { return this._d.pop(); }\n");
    r = _dx_add(r, "    peek() { return this._d[this._d.length - 1]; }\n");
    r = _dx_add(r, "    empty() { return this._d.length === 0; }\n");
    r = _dx_add(r, "    get length() { return this._d.length; }\n");
    r = _dx_add(r, "}\n\n");
    r = _dx_add(r, "class _dx_queue {\n");
    r = _dx_add(r, "    constructor(a) { this._d = [...(a || [])]; }\n");
    r = _dx_add(r, "    put(v) { this._d.push(v); }\n");
    r = _dx_add(r, "    get() { return this._d.shift(); }\n");
    r = _dx_add(r, "    peek() { return this._d[0]; }\n");
    r = _dx_add(r, "    empty() { return this._d.length === 0; }\n");
    r = _dx_add(r, "    get length() { return this._d.length; }\n");
    r = _dx_add(r, "}\n\n");
    r = _dx_add(r, "function _dx_range(start, end) {\n");
    r = _dx_add(r, "    return Array.from({length: end - start}, (_, i) => start + i);\n");
    r = _dx_add(r, "}\n\n");
    r = _dx_add(r, "function _dx_repr(v) {\n");
    r = _dx_add(r, "    if (v === true) return 'True';\n");
    r = _dx_add(r, "    if (v === false) return 'False';\n");
    r = _dx_add(r, "    if (v === null || v === undefined) return 'None';\n");
    r = _dx_add(r, "    if (Array.isArray(v)) return '[' + v.map(_dx_repr).join(', ') + ']';\n");
    r = _dx_add(r, "    return v;\n");
    r = _dx_add(r, "}\n\n");
    r = _dx_add(r, "function _dx_matmul(a, b) {\n");
    r = _dx_add(r, "    if (a instanceof Float32Array && b instanceof Float32Array) {\n");
    r = _dx_add(r, "        let s = 0; for (let i = 0; i < a.length; i++) s += a[i] * b[i]; return s;\n");
    r = _dx_add(r, "    }\n");
    r = _dx_add(r, "    return a * b;\n");
    r = _dx_add(r, "}\n\n");
    r = _dx_add(r, "let _rng_s = 42;\n");
    r = _dx_add(r, "function RngSeed(s) { _rng_s = s; }\n");
    r = _dx_add(r, "function RngFloat() { _rng_s = (_rng_s * 1103515245 + 12345) & 0x7fffffff; return _rng_s / 0x7fffffff; }\n");
    r = _dx_add(r, "function RngNormal() { let u1 = RngFloat() || 1e-10, u2 = RngFloat(); return Math.sqrt(-2*Math.log(u1))*Math.cos(6.2831853*u2); }\n\n");
    r = _dx_add(r, "function Matmul(W, x, out, M, N) { for(let i=0;i<M;i++){let s=0;for(let j=0;j<N;j++) s+=W[i*N+j]*x[j]; out[i]=s;} }\n");
    r = _dx_add(r, "function MatmulTranspose(W, x, out, M, N) { for(let i=0;i<N;i++){let s=0;for(let j=0;j<M;j++) s+=W[j*N+i]*x[j]; out[i]=s;} }\n");
    r = _dx_add(r, "function OuterProductAdd(a, b, out, M, N) { for(let i=0;i<M;i++) for(let j=0;j<N;j++) out[i*N+j]+=a[i]*b[j]; }\n");
    r = _dx_add(r, "function Matmul2d(A, B, C, M, K, P) { for(let i=0;i<M;i++) for(let j=0;j<P;j++){let s=0;for(let k=0;k<K;k++) s+=A[i*K+k]*B[k*P+j]; C[i*P+j]=s;} }\n");
    r = _dx_add(r, "function Matmul2dTransB(A, B, C, M, K, P) { for(let i=0;i<M;i++) for(let j=0;j<K;j++){let s=0;for(let k=0;k<P;k++) s+=A[i*P+k]*B[j*P+k]; C[i*K+j]=s;} }\n");
    r = _dx_add(r, "function Matmul2dTransA(A, B, C, M, K, P) { for(let i=0;i<K;i++) for(let j=0;j<P;j++){let s=0;for(let k=0;k<M;k++) s+=A[k*K+i]*B[k*P+j]; C[i*P+j]=s;} }\n");
    r = _dx_add(r, "function VecAdd(a, b, out, N) { for(let i=0;i<N;i++) out[i]=a[i]+b[i]; }\n");
    r = _dx_add(r, "function VecSub(a, b, out, N) { for(let i=0;i<N;i++) out[i]=a[i]-b[i]; }\n");
    r = _dx_add(r, "function BroadcastAdd(A, b, out, M, N) { for(let i=0;i<M;i++) for(let j=0;j<N;j++) out[i*N+j]=A[i*N+j]+b[j]; }\n");
    r = _dx_add(r, "function DotProduct(a, b, N) { let s=0; for(let i=0;i<N;i++) s+=a[i]*b[i]; return s; }\n");
    r = _dx_add(r, "function ReluForward(x, out, N) { for(let i=0;i<N;i++) out[i]=x[i]>0?x[i]:0; }\n");
    r = _dx_add(r, "function ReluBackward(cached, d_out, d_x, N) { for(let i=0;i<N;i++) d_x[i]+=(cached[i]>0?1:0)*d_out[i]; }\n");
    r = _dx_add(r, "function SoftmaxForward(x, out, N) { let m=-Infinity; for(let i=0;i<N;i++) if(x[i]>m) m=x[i]; let s=0; for(let i=0;i<N;i++){out[i]=Math.exp(x[i]-m); s+=out[i];} for(let i=0;i<N;i++) out[i]/=s; }\n");
    r = _dx_add(r, "function SoftmaxBackward(out, d_out, d_x, N) { let dot=0; for(let i=0;i<N;i++) dot+=out[i]*d_out[i]; for(let i=0;i<N;i++) d_x[i]+=out[i]*(d_out[i]-dot); }\n");
    r = _dx_add(r, "function SigmoidForward(x, out, N) { for(let i=0;i<N;i++) out[i]=1/(1+Math.exp(-x[i])); }\n");
    r = _dx_add(r, "function SigmoidBackward(out, d_out, d_x, N) { for(let i=0;i<N;i++) d_x[i]+=out[i]*(1-out[i])*d_out[i]; }\n");
    r = _dx_add(r, "function MSE(pred, target, N) { let s=0; for(let i=0;i<N;i++){let d=pred[i]-target[i]; s+=d*d;} return s/N; }\n");
    r = _dx_add(r, "function CrossEntropy(pred, target, N) { let s=0; for(let i=0;i<N;i++) s-=target[i]*Math.log(pred[i]+1e-12); return s; }\n");
    r = _dx_add(r, "function CrossEntropyForward(pred, label, N) { let p=pred[label]; if(p<1e-7) p=1e-7; return -Math.log(p); }\n");
    r = _dx_add(r, "function CrossEntropyBackward(pred, label, dPred, N) { dPred.fill(0); let p=pred[label]; if(p<1e-7) p=1e-7; dPred[label]=-1/p; }\n");
    r = _dx_add(r, "function MseForward(pred, target, N) { let s=0; for(let i=0;i<N;i++){const d=pred[i]-target[i];s+=d*d;} return s/N; }\n");
    r = _dx_add(r, "function MseBackward(pred, target, dPred, N) { for(let i=0;i<N;i++) dPred[i]=2*(pred[i]-target[i])/N; }\n");
    r = _dx_add(r, "function SgdStep(param, grad, lr, N) { for(let i=0;i<N;i++) param[i]-=lr*grad[i]; }\n");
    r = _dx_add(r, "function Argmax(v, N) { let mi=0; for(let i=1;i<N;i++) if(v[i]>v[mi]) mi=i; return mi; }\n\n");
    return r;
}

function js_indent(level) {
    let _it;
    let s = "";
    let i = 0;
    while ((i < (level * 4))) {
        s = _dx_add(s, " ");
        i = _dx_add(i, 1);
    }
    return s;
}

function js_escape_str(s) {
    let _it;
    let result = "";
    let i = 0;
    while ((i < s.length)) {
        let ch = s[i];
        if ((ch === "\\")) {
            result = _dx_add(result, "\\\\");
        } else if ((ch === "\"")) {
            result = _dx_add(result, "\\\"");
        } else if ((ch === "\n")) {
            result = _dx_add(result, "\\n");
        } else if ((ch === "\t")) {
            result = _dx_add(result, "\\t");
        } else {
            result = _dx_add(result, ch);
        }
        i = _dx_add(i, 1);
    }
    return result;
}

function js_declare(name, declared) {
    let _it;
    if (_dx_contains(name, declared)) {
        return name;
    }
    declared[name] = true;
    return _dx_add("let ", name);
}

function emit_js_expr(node, type_names) {
    let _it;
    let kind = node.kind;
    if ((kind === "IRNum")) {
        return node.value;
    }
    if ((kind === "IRStr")) {
        return _dx_add(_dx_add("\"", js_escape_str(node.value)), "\"");
    }
    if ((kind === "IRBool")) {
        if ((node.value === "true")) {
            return "true";
        }
        return "false";
    }
    if ((kind === "IRVar")) {
        return node.name;
    }
    if ((kind === "IRBinOp")) {
        let left = emit_js_expr(node.left, type_names);
        let right = emit_js_expr(node.right, type_names);
        let op = node.op;
        if ((op === "add")) {
            return _dx_add(_dx_add(_dx_add(_dx_add("_dx_add(", left), ", "), right), ")");
        }
        if ((op === "sub")) {
            return _dx_add(_dx_add(_dx_add(_dx_add("(", left), " - "), right), ")");
        }
        if ((op === "mul")) {
            return _dx_add(_dx_add(_dx_add(_dx_add("(", left), " * "), right), ")");
        }
        if ((op === "div")) {
            return _dx_add(_dx_add(_dx_add(_dx_add("(", left), " / "), right), ")");
        }
        if ((op === "mod")) {
            return _dx_add(_dx_add(_dx_add(_dx_add("(", left), " % "), right), ")");
        }
        if ((op === "pow")) {
            return _dx_add(_dx_add(_dx_add(_dx_add("(", left), " ** "), right), ")");
        }
        if ((op === "eq")) {
            return _dx_add(_dx_add(_dx_add(_dx_add("_dx_eq(", left), ", "), right), ")");
        }
        if ((op === "neq")) {
            return _dx_add(_dx_add(_dx_add(_dx_add("(!_dx_eq(", left), ", "), right), "))");
        }
        if ((op === "lt")) {
            return _dx_add(_dx_add(_dx_add(_dx_add("(", left), " < "), right), ")");
        }
        if ((op === "gt")) {
            return _dx_add(_dx_add(_dx_add(_dx_add("(", left), " > "), right), ")");
        }
        if ((op === "le")) {
            return _dx_add(_dx_add(_dx_add(_dx_add("(", left), " <= "), right), ")");
        }
        if ((op === "ge")) {
            return _dx_add(_dx_add(_dx_add(_dx_add("(", left), " >= "), right), ")");
        }
        if ((op === "and")) {
            return _dx_add(_dx_add(_dx_add(_dx_add("(", left), " && "), right), ")");
        }
        if ((op === "or")) {
            return _dx_add(_dx_add(_dx_add(_dx_add("(", left), " || "), right), ")");
        }
        if ((op === "in")) {
            return _dx_add(_dx_add(_dx_add(_dx_add("_dx_contains(", left), ", "), right), ")");
        }
        if ((op === "matmul")) {
            return _dx_add(_dx_add(_dx_add(_dx_add("_dx_matmul(", left), ", "), right), ")");
        }
        return _dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("(", left), " "), op), " "), right), ")");
    }
    if ((kind === "IRUnaryOp")) {
        let operand = emit_js_expr(node.operand, type_names);
        if ((node.op === "neg")) {
            return _dx_add(_dx_add("(-", operand), ")");
        }
        if ((node.op === "not")) {
            return _dx_add(_dx_add("(!", operand), ")");
        }
        return operand;
    }
    if ((kind === "IRCall")) {
        let args_str = node.args.map(((a) => emit_js_expr(a, type_names)));
        let fname = emit_js_expr(node.func, type_names);
        if (_dx_contains(fname, type_names)) {
            return _dx_add(_dx_add(_dx_add(_dx_add("new ", fname), "("), args_str.join(", ")), ")");
        }
        return _dx_add(_dx_add(_dx_add(fname, "("), args_str.join(", ")), ")");
    }
    if ((kind === "IRMethodCall")) {
        return emit_js_method(node, type_names);
    }
    if ((kind === "IRVec")) {
        let elems = node.elements.map(((e) => emit_js_expr(e, type_names)));
        return _dx_add(_dx_add("[", elems.join(", ")), "]");
    }
    if ((kind === "IRIndex")) {
        let obj = emit_js_expr(node.obj, type_names);
        let idx = emit_js_expr(node.index, type_names);
        return _dx_add(_dx_add(_dx_add(obj, "["), idx), "]");
    }
    if ((kind === "IRFieldGet")) {
        obj = emit_js_expr(node.obj, type_names);
        return _dx_add(_dx_add(obj, "."), node.field_name);
    }
    if ((kind === "IRApp")) {
        let pairs = node.entries.map(((e) => _dx_add(_dx_add(e.key, ": "), emit_js_expr(e.value, type_names))));
        return _dx_add(_dx_add("new _dx_app({", pairs.join(", ")), "})");
    }
    if ((kind === "IRLambda")) {
        let params_str = node.params.join(", ");
        return _dx_add(_dx_add(_dx_add(_dx_add("((", params_str), ") => "), emit_js_expr(node.body, type_names)), ")");
    }
    if ((kind === "IRDeriv")) {
        let pm = node.param;
        let ex = emit_js_expr(node.expr, type_names);
        return _dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("(function(){var _l=console.log;console.log=function(){};var _h=1e-8,_s=", pm), ";"), pm), "=_s+_h;var _p="), ex), ";"), pm), "=_s-_h;var _m="), ex), ";"), pm), "=_s;console.log=_l;return(_p-_m)/(2*_h);})()");
    }
    if ((kind === "IRStack")) {
        elems = node.elements.map(((e) => emit_js_expr(e, type_names)));
        return _dx_add(_dx_add("new _dx_stack([", elems.join(", ")), "])");
    }
    if ((kind === "IRQueue")) {
        elems = node.elements.map(((e) => emit_js_expr(e, type_names)));
        return _dx_add(_dx_add("new _dx_queue([", elems.join(", ")), "])");
    }
    return "null";
}

function emit_js_method(node, type_names) {
    let _it;
    let obj = emit_js_expr(node.obj, type_names);
    let m = node.method;
    let args = node.args.map(((a) => emit_js_expr(a, type_names)));
    if ((m === "size")) {
        return _dx_add(obj, ".length");
    }
    if ((m === "contains")) {
        if ((args.length > 0)) {
            return _dx_add(_dx_add(_dx_add(_dx_add("_dx_contains(", args[0]), ", "), obj), ")");
        }
        return _dx_add(obj, ".includes()");
    }
    if ((m === "push")) {
        return _dx_add(_dx_add(_dx_add(obj, ".push("), args.join(", ")), ")");
    }
    if ((m === "pop")) {
        return _dx_add(obj, ".pop()");
    }
    if ((m === "keys")) {
        return _dx_add(_dx_add("Object.keys(", obj), ")");
    }
    if ((m === "values")) {
        return _dx_add(_dx_add("Object.values(", obj), ")");
    }
    if ((m === "slice")) {
        if ((args.length === 2)) {
            return _dx_add(_dx_add(_dx_add(_dx_add(_dx_add(obj, ".slice("), args[0]), ", "), args[1]), ")");
        }
        if ((args.length === 1)) {
            return _dx_add(_dx_add(_dx_add(obj, ".slice("), args[0]), ")");
        }
        return _dx_add(obj, ".slice()");
    }
    if ((m === "startsWith")) {
        return _dx_add(_dx_add(_dx_add(obj, ".startsWith("), args.join(", ")), ")");
    }
    if ((m === "endsWith")) {
        return _dx_add(_dx_add(_dx_add(obj, ".endsWith("), args.join(", ")), ")");
    }
    if ((m === "indexOf")) {
        return _dx_add(_dx_add(_dx_add(obj, ".indexOf("), args.join(", ")), ")");
    }
    if ((m === "trim")) {
        return _dx_add(obj, ".trim()");
    }
    if ((m === "upper")) {
        return _dx_add(obj, ".toUpperCase()");
    }
    if ((m === "lower")) {
        return _dx_add(obj, ".toLowerCase()");
    }
    if ((m === "replace")) {
        if ((args.length === 2)) {
            return _dx_add(_dx_add(_dx_add(_dx_add(_dx_add(obj, ".replaceAll("), args[0]), ", "), args[1]), ")");
        }
        return _dx_add(_dx_add(_dx_add(obj, ".replace("), args.join(", ")), ")");
    }
    if ((m === "chars")) {
        return _dx_add(_dx_add("[...", obj), "]");
    }
    if ((m === "join")) {
        if ((args.length > 0)) {
            return _dx_add(_dx_add(_dx_add(args[0], ".join("), obj), ")");
        }
        return _dx_add(_dx_add("[].join(", obj), ")");
    }
    if ((m === "isDigit")) {
        return _dx_add(_dx_add("/^\\d+$/.test(", obj), ")");
    }
    if ((m === "isAlpha")) {
        return _dx_add(_dx_add("/^[a-zA-Z]+$/.test(", obj), ")");
    }
    if ((m === "isAlnum")) {
        return _dx_add(_dx_add("/^[a-zA-Z0-9]+$/.test(", obj), ")");
    }
    if ((m === "map")) {
        return _dx_add(_dx_add(_dx_add(obj, ".map("), args[0]), ")");
    }
    if ((m === "filter")) {
        return _dx_add(_dx_add(_dx_add(obj, ".filter("), args[0]), ")");
    }
    if ((m === "fold")) {
        if ((args.length === 2)) {
            return _dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("_dx_fold(", obj), ", "), args[0]), ", "), args[1]), ")");
        }
        return _dx_add(_dx_add(_dx_add(_dx_add("_dx_fold(", obj), ", "), args[0]), ")");
    }
    if ((m === "any")) {
        return _dx_add(_dx_add(_dx_add(obj, ".some("), args[0]), ")");
    }
    if ((m === "all")) {
        return _dx_add(_dx_add(_dx_add(obj, ".every("), args[0]), ")");
    }
    if ((m === "first")) {
        return _dx_add(obj, "[0]");
    }
    if ((m === "last")) {
        return _dx_add(_dx_add(_dx_add(obj, "["), obj), ".length - 1]");
    }
    if ((m === "rev")) {
        return _dx_add(_dx_add("[...", obj), "].reverse()");
    }
    if ((m === "sort")) {
        if ((args.length > 0)) {
            return _dx_add(_dx_add(_dx_add(_dx_add("[...", obj), "].sort("), args[0]), ")");
        }
        return _dx_add(_dx_add("[...", obj), "].sort()");
    }
    if ((m === "take")) {
        return _dx_add(_dx_add(_dx_add(obj, ".slice(0, "), args[0]), ")");
    }
    if ((m === "drop")) {
        return _dx_add(_dx_add(_dx_add(obj, ".slice("), args[0]), ")");
    }
    if ((m === "count")) {
        if ((args.length > 0)) {
            return _dx_add(_dx_add(_dx_add(obj, ".filter("), args[0]), ").length");
        }
        return _dx_add(obj, ".length");
    }
    if ((m === "unique")) {
        return _dx_add(_dx_add("[...new Set(", obj), ")]");
    }
    if ((m === "flatten")) {
        return _dx_add(obj, ".flat()");
    }
    return _dx_add(_dx_add(_dx_add(_dx_add(_dx_add(obj, "."), m), "("), args.join(", ")), ")");
}

function emit_js_stmt(node, level, lines, declared, type_names) {
    let _it;
    let kind = node.kind;
    let ind = js_indent(level);
    if ((kind === "IRAssign")) {
        let val = emit_js_expr(node.value, type_names);
        if ((node.target.kind === "IRVar")) {
            let decl = js_declare(node.target.name, declared);
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(ind, decl), " = "), val), ";"));
        } else if ((node.target.kind === "IRIndex")) {
            let tgt = emit_js_expr(node.target, type_names);
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(ind, tgt), " = "), val), ";"));
        } else {
            tgt = emit_js_expr(node.target, type_names);
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(ind, tgt), " = "), val), ";"));
        }
        return 0;
    }
    if ((kind === "IRIf")) {
        let cond = emit_js_expr(node.condition, type_names);
        _it = lines.push(_dx_add(_dx_add(_dx_add(ind, "if ("), cond), ") {"));
        _it = emit_js_block(node.body, _dx_add(level, 1), lines, declared, type_names);
        if ((node.else_body.length > 0)) {
            if (((node.else_body.length === 1) && (node.else_body[0].kind === "IRIf"))) {
                let elif_node = node.else_body[0];
                let cond2 = emit_js_expr(elif_node.condition, type_names);
                _it = lines.push(_dx_add(_dx_add(_dx_add(ind, "} else if ("), cond2), ") {"));
                _it = emit_js_block(elif_node.body, _dx_add(level, 1), lines, declared, type_names);
                if ((elif_node.else_body.length > 0)) {
                    _it = lines.push(_dx_add(ind, "} else {"));
                    _it = emit_js_block(elif_node.else_body, _dx_add(level, 1), lines, declared, type_names);
                }
                _it = lines.push(_dx_add(ind, "}"));
            } else {
                _it = lines.push(_dx_add(ind, "} else {"));
                _it = emit_js_block(node.else_body, _dx_add(level, 1), lines, declared, type_names);
                _it = lines.push(_dx_add(ind, "}"));
            }
        } else {
            _it = lines.push(_dx_add(ind, "}"));
        }
        return 0;
    }
    if ((kind === "IRWhile")) {
        cond = emit_js_expr(node.condition, type_names);
        _it = lines.push(_dx_add(_dx_add(_dx_add(ind, "while ("), cond), ") {"));
        _it = emit_js_block(node.body, _dx_add(level, 1), lines, declared, type_names);
        _it = lines.push(_dx_add(ind, "}"));
        return 0;
    }
    if ((kind === "IRFor")) {
        let iterable = emit_js_expr(node.iterable, type_names);
        let vr = node.var;
        declared[vr] = true;
        _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(ind, "for (const "), vr), " of "), iterable), ") {"));
        _it = emit_js_block(node.body, _dx_add(level, 1), lines, declared, type_names);
        _it = lines.push(_dx_add(ind, "}"));
        return 0;
    }
    if ((kind === "IRFuncDef")) {
        return 0;
    }
    if ((kind === "IRTypeDef")) {
        return 0;
    }
    if ((kind === "IRReturn")) {
        _it = lines.push(_dx_add(_dx_add(_dx_add(ind, "return "), emit_js_expr(node.value, type_names)), ";"));
        return 0;
    }
    if ((kind === "IRPrint")) {
        let args_str = node.args.map(((a) => _dx_add(_dx_add("_dx_repr(", emit_js_expr(a, type_names)), ")")));
        _it = lines.push(_dx_add(_dx_add(_dx_add(ind, "console.log("), args_str.join(", ")), ");"));
        return 0;
    }
    if ((kind === "IRComment")) {
        _it = lines.push(_dx_add(_dx_add(ind, "// "), node.text));
        return 0;
    }
    if ((kind === "IRExprStmt")) {
        let code = emit_js_expr(node.expr, type_names);
        decl = js_declare("_it", declared);
        _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(ind, decl), " = "), code), ";"));
        return 0;
    }
    return 0;
}

function emit_js_block(stmts, level, lines, declared, type_names) {
    let _it;
    for (const s of stmts) {
        _it = emit_js_stmt(s, level, lines, declared, type_names);
    }
    return 0;
}

function emit_js_func(node, lines, declared, type_names) {
    let _it;
    let params_str = node.params.join(", ");
    _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add("function ", node.name), "("), params_str), ") {"));
    let func_declared = new _dx_app({});
    for (const p of node.params) {
        func_declared[p] = true;
    }
    func_declared["_it"] = true;
    _it = lines.push("    let _it;");
    _it = emit_js_block(node.body, 1, lines, func_declared, type_names);
    _it = lines.push("}");
    _it = lines.push("");
    declared[node.name] = true;
    return 0;
}

function emit_js_typedef(node, lines, type_names) {
    let _it;
    let name = node.name;
    type_names[name] = true;
    let fields = node.fields;
    let param_names = fields.map(((f) => f.name));
    let params_str = param_names.join(", ");
    _it = lines.push(_dx_add(_dx_add("class ", name), " {"));
    _it = lines.push(_dx_add(_dx_add("    constructor(", params_str), ") {"));
    for (const f of fields) {
        _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add("        this.", f.name), " = "), f.name), ";"));
    }
    _it = lines.push("    }");
    _it = lines.push("    equals(o) {");
    _it = lines.push(_dx_add(_dx_add("        if (!(o instanceof ", name), ")) return false;"));
    for (const f of fields) {
        _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add("        if (!_dx_eq(this.", f.name), ", o."), f.name), ")) return false;"));
    }
    _it = lines.push("        return true;");
    _it = lines.push("    }");
    let parts = fields.map(((f) => _dx_add(_dx_add("' + _dx_repr(this.", f.name), ") + '")));
    let inner = parts.join(", ");
    _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add("    toString() { return '", name), "("), inner), ")'; }"));
    _it = lines.push("}");
    _it = lines.push("");
    return 0;
}

// input: IRFuncDef (method) + type_defs (dict of IRTypeDef by name)
// output: list of op dicts consumed by Forward/Backward generation.
function tape_field_type(type_defs, type_name, field_name) {
    let _it;
    if ((!_dx_contains(type_name, Object.keys(type_defs)))) {
        return new _dx_app({type_name: "", dims: []});
    }
    let td = type_defs[type_name];
    for (const f of td.fields) {
        if ((f.name === field_name)) {
            return new _dx_app({type_name: f.type_name, dims: f.dims});
        }
    }
    return new _dx_app({type_name: "", dims: []});
}

function tape_field_size(finfo) {
    let _it;
    if ((finfo.dims.length === 1)) {
        return finfo.dims[0];
    }
    if ((finfo.dims.length === 2)) {
        return (finfo.dims[0] * finfo.dims[1]);
    }
    return 0;
}

function tape_is_vec(finfo) {
    let _it;
    let tn = finfo.type_name;
    return (((tn === "Vec") || (tn === "Tensor")) && (finfo.dims.length > 0));
}

function build_tape(func_ir, type_defs) {
    let _it;
    if ((func_ir.type_name === "")) {
        return [];
    }
    if ((!_dx_contains(func_ir.type_name, Object.keys(type_defs)))) {
        return [];
    }
    let tape = [];
    let env = new _dx_app({});
    let aliases = new _dx_app({});
    let it_var = "";
    let it_type = new _dx_app({type_name: "", dims: []});
    let counter = 0;
    let owner = func_ir.type_name;
    let i = 0;
    while ((i < func_ir.params.length)) {
        let pname = func_ir.params[i];
        if ((i < func_ir.param_types.length)) {
            let pt = func_ir.param_types[i];
            if ((pt.name !== "")) {
                env[pname] = new _dx_app({type_name: pt.name, dims: pt.dims});
            }
        }
        i = _dx_add(i, 1);
    }
    for (const stmt of func_ir.body) {
        if ((stmt.kind === "IRExprStmt")) {
            let result = tape_texpr(stmt.expr, tape, env, aliases, type_defs, owner, it_var, it_type, counter);
            it_var = result.var;
            it_type = result.dtype;
            counter = result.counter;
        }
        if ((stmt.kind === "IRAssign")) {
            if ((stmt.target.kind === "IRVar")) {
                result = tape_texpr(stmt.value, tape, env, aliases, type_defs, owner, it_var, it_type, counter);
                env[stmt.target.name] = result.dtype;
                aliases[stmt.target.name] = result.var;
                counter = result.counter;
            }
        }
    }
    return tape;
}

function tape_texpr(node, tape, env, aliases, type_defs, owner, it_var, it_type, counter) {
    let _it;
    let kind = node.kind;
    if ((kind === "IRNum")) {
        return new _dx_app({var: _dx_add(node.value, ""), dtype: new _dx_app({type_name: "Float", dims: []}), counter: counter});
    }
    if ((kind === "IRVar")) {
        let name = node.name;
        if ((((name === "_it") || (name === "it")) && (it_var !== ""))) {
            return new _dx_app({var: it_var, dtype: it_type, counter: counter});
        }
        if (_dx_contains(name, Object.keys(aliases))) {
            let dt = env[name];
            if ((!_dx_contains(name, Object.keys(env)))) {
                dt = new _dx_app({type_name: "", dims: []});
            }
            return new _dx_app({var: aliases[name], dtype: dt, counter: counter});
        }
        dt = new _dx_app({type_name: "", dims: []});
        if (_dx_contains(name, Object.keys(env))) {
            dt = env[name];
        }
        return new _dx_app({var: name, dtype: dt, counter: counter});
    }
    if ((kind === "IRSelf")) {
        return new _dx_app({var: "me", dtype: new _dx_app({type_name: owner, dims: []}), counter: counter});
    }
    if ((kind === "IRFieldGet")) {
        let obj_r = tape_texpr(node.obj, tape, env, aliases, type_defs, owner, it_var, it_type, counter);
        if ((obj_r.var === "me")) {
            let finfo = tape_field_type(type_defs, owner, node.field_name);
            return new _dx_app({var: _dx_add("me->", node.field_name), dtype: finfo, counter: obj_r.counter});
        }
        return new _dx_app({var: _dx_add(_dx_add(obj_r.var, "."), node.field_name), dtype: new _dx_app({type_name: "", dims: []}), counter: obj_r.counter});
    }
    if ((kind === "IRBinOp")) {
        return tape_texpr_binop(node, tape, env, aliases, type_defs, owner, it_var, it_type, counter);
    }
    if ((kind === "IRCall")) {
        return tape_texpr_call(node, tape, env, aliases, type_defs, owner, it_var, it_type, counter);
    }
    if ((kind === "IRUnaryOp")) {
        if ((node.op === "neg")) {
            let xr = tape_texpr(node.operand, tape, env, aliases, type_defs, owner, it_var, it_type, counter);
            if (tape_is_vec(xr.dtype)) {
                let n = tape_field_size(xr.dtype);
                let out = _dx_add("neg_", xr.counter);
                _it = tape.push(new _dx_app({op: "negate", out: out, n: n, x: xr.var, N: n}));
                return new _dx_app({var: out, dtype: xr.dtype, counter: _dx_add(xr.counter, 1)});
            }
            return new _dx_app({var: _dx_add(_dx_add("(-", xr.var), ")"), dtype: xr.dtype, counter: xr.counter});
        }
    }
    return new _dx_app({var: "??", dtype: new _dx_app({type_name: "", dims: []}), counter: counter});
}

function tape_texpr_binop(node, tape, env, aliases, type_defs, owner, it_var, it_type, counter) {
    let _it;
    let op = node.op;
    if ((op === "matmul")) {
        let mlr = tape_texpr(node.left, tape, env, aliases, type_defs, owner, it_var, it_type, counter);
        let mrr = tape_texpr(node.right, tape, env, aliases, type_defs, owner, it_var, it_type, mlr.counter);
        let mlt = mlr.dtype;
        let mrt = mrr.dtype;
        let mcnt = mrr.counter;
        if (((((mlt.type_name === "Tensor") && (mlt.dims.length === 2)) && (mrt.type_name === "Tensor")) && (mrt.dims.length === 2))) {
            let mM = mlt.dims[0];
            let mK = mlt.dims[1];
            let mP = mrt.dims[1];
            let mout = _dx_add("mmOut_", mcnt);
            _it = tape.push(new _dx_app({op: "matmul_2d", out: mout, n: (mM * mP), A: mlr.var, B: mrr.var, M: mM, K: mK, P: mP}));
            return new _dx_app({var: mout, dtype: new _dx_app({type_name: "Tensor", dims: [mM, mP]}), counter: _dx_add(mcnt, 1)});
        }
        if ((((mlt.type_name === "Tensor") && (mlt.dims.length === 2)) && (mrt.type_name === "Vec"))) {
            mM = mlt.dims[0];
            let mN = mlt.dims[1];
            let pf = "";
            let lv = mlr.var;
            if ((lv.slice(0, 4) === "me->")) {
                pf = lv.slice(4, lv.length);
            }
            let hint = "wProj";
            if ((pf !== "")) {
                hint = _dx_add(pf, "Proj");
            }
            mout = _dx_add(_dx_add(hint, "_"), mcnt);
            _it = tape.push(new _dx_app({op: "matmul", out: mout, n: mM, W: mlr.var, x: mrr.var, M: mM, N: mN}));
            return new _dx_app({var: mout, dtype: new _dx_app({type_name: "Vec", dims: [mM]}), counter: _dx_add(mcnt, 1)});
        }
        if (((mlt.type_name === "Vec") && (mrt.type_name === "Vec"))) {
            let mn = tape_field_size(mlt);
            mout = _dx_add("dotOut_", mcnt);
            _it = tape.push(new _dx_app({op: "dot_product", out: mout, n: 1, a: mlr.var, b: mrr.var, N: mn}));
            return new _dx_app({var: mout, dtype: new _dx_app({type_name: "Float", dims: []}), counter: _dx_add(mcnt, 1)});
        }
        return new _dx_app({var: _dx_add(_dx_add(_dx_add(_dx_add("(", mlr.var), " o "), mrr.var), ")"), dtype: new _dx_app({type_name: "", dims: []}), counter: mcnt});
    }
    let lr = tape_texpr(node.left, tape, env, aliases, type_defs, owner, it_var, it_type, counter);
    let rr = tape_texpr(node.right, tape, env, aliases, type_defs, owner, it_var, it_type, lr.counter);
    let lt = lr.dtype;
    let rt = rr.dtype;
    let cnt = rr.counter;
    if ((op === "add")) {
        if ((((lt.type_name === "Tensor") && (lt.dims.length === 2)) && (rt.type_name === "Vec"))) {
            let M = lt.dims[0];
            let N = lt.dims[1];
            let out = _dx_add("plusBias_", cnt);
            _it = tape.push(new _dx_app({op: "broadcast_add", out: out, n: (M * N), A: lr.var, b: rr.var, M: M, N: N}));
            return new _dx_app({var: out, dtype: lt, counter: _dx_add(cnt, 1)});
        }
        if ((tape_is_vec(lt) && tape_is_vec(rt))) {
            let n = tape_field_size(lt);
            out = _dx_add("sum_", cnt);
            _it = tape.push(new _dx_app({op: "vec_add", out: out, n: n, a: lr.var, b: rr.var, N: n}));
            return new _dx_app({var: out, dtype: lt, counter: _dx_add(cnt, 1)});
        }
        return new _dx_app({var: _dx_add(_dx_add(_dx_add(_dx_add("(", lr.var), " + "), rr.var), ")"), dtype: lt, counter: cnt});
    }
    if ((op === "sub")) {
        if ((tape_is_vec(lt) && tape_is_vec(rt))) {
            n = tape_field_size(lt);
            out = _dx_add("diff_", cnt);
            _it = tape.push(new _dx_app({op: "vec_sub", out: out, n: n, a: lr.var, b: rr.var, N: n}));
            return new _dx_app({var: out, dtype: lt, counter: _dx_add(cnt, 1)});
        }
        return new _dx_app({var: _dx_add(_dx_add(_dx_add(_dx_add("(", lr.var), " - "), rr.var), ")"), dtype: lt, counter: cnt});
    }
    return new _dx_app({var: _dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("(", lr.var), " "), op), " "), rr.var), ")"), dtype: new _dx_app({type_name: "", dims: []}), counter: cnt});
}

function tape_texpr_call(node, tape, env, aliases, type_defs, owner, it_var, it_type, counter) {
    let _it;
    if ((node.func.kind === "IRVar")) {
        let fname = node.func.name;
        if ((((((fname === "relu") || (fname === "softmax")) || (fname === "sigmoid")) || (fname === "gelu")) || (fname === "log"))) {
            let ar = tape_texpr(node.args[0], tape, env, aliases, type_defs, owner, it_var, it_type, counter);
            let n = tape_field_size(ar.dtype);
            let out = _dx_add(_dx_add(fname, "Out_"), ar.counter);
            _it = tape.push(new _dx_app({op: fname, out: out, n: n, x: ar.var, N: n}));
            return new _dx_app({var: out, dtype: ar.dtype, counter: _dx_add(ar.counter, 1)});
        }
    }
    return new _dx_app({var: "??", dtype: new _dx_app({type_name: "", dims: []}), counter: counter});
}

function fwd_ref(v, tape_outs, param_name) {
    let _it;
    if ((v.slice(0, 4) === "me->")) {
        return _dx_add("me.", v.slice(4, v.length));
    }
    if (_dx_contains(v, tape_outs)) {
        return _dx_add("cache.", v);
    }
    return v;
}

function emit_tape_forward(name, tape, func_ir, type_defs, lines) {
    let _it;
    let param_name = "x";
    if ((func_ir.params.length > 0)) {
        param_name = func_ir.params[0];
    }
    let tape_outs = [];
    for (const entry of tape) {
        _it = tape_outs.push(entry.out);
    }
    _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add("function ", name), "Forward(me, "), param_name), ", output, cache) {"));
    for (const entry of tape) {
        let op = entry.op;
        if ((op === "matmul")) {
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    Matmul(", fwd_ref(entry.W, tape_outs, param_name)), ", "), fwd_ref(entry.x, tape_outs, param_name)), ", cache."), entry.out), ", "), entry.M), ", "), entry.N), ");"));
        }
        if ((op === "matmul_2d")) {
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    Matmul2d(", fwd_ref(entry.A, tape_outs, param_name)), ", "), fwd_ref(entry.B, tape_outs, param_name)), ", cache."), entry.out), ", "), entry.M), ", "), entry.K), ", "), entry.P), ");"));
        }
        if ((op === "vec_add")) {
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    VecAdd(", fwd_ref(entry.a, tape_outs, param_name)), ", "), fwd_ref(entry.b, tape_outs, param_name)), ", cache."), entry.out), ", "), entry.N), ");"));
        }
        if ((op === "broadcast_add")) {
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    BroadcastAdd(", fwd_ref(entry.A, tape_outs, param_name)), ", "), fwd_ref(entry.b, tape_outs, param_name)), ", cache."), entry.out), ", "), entry.M), ", "), entry.N), ");"));
        }
        if ((op === "relu")) {
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    ReluForward(", fwd_ref(entry.x, tape_outs, param_name)), ", cache."), entry.out), ", "), entry.N), ");"));
        }
        if ((op === "softmax")) {
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    SoftmaxForward(", fwd_ref(entry.x, tape_outs, param_name)), ", cache."), entry.out), ", "), entry.N), ");"));
        }
        if ((op === "sigmoid")) {
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    SigmoidForward(", fwd_ref(entry.x, tape_outs, param_name)), ", cache."), entry.out), ", "), entry.N), ");"));
        }
        if ((op === "dot_product")) {
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    cache.", entry.out), " = DotProduct("), fwd_ref(entry.a, tape_outs, param_name)), ", "), fwd_ref(entry.b, tape_outs, param_name)), ", "), entry.N), ");"));
        }
    }
    if ((tape.length > 0)) {
        let last = tape[(tape.length - 1)];
        _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add("    for (let i = 0; i < ", last.n), "; i++) output[i] = cache."), last.out), "[i];"));
    }
    _it = lines.push("}");
    _it = lines.push("");
    return 0;
}

function bwd_dref(v, tape_outs) {
    let _it;
    if ((v.slice(0, 4) === "me->")) {
        return _dx_add("g.d_", v.slice(4, v.length));
    }
    return _dx_add("d_", v);
}

function bwd_cref(v, tape_outs, param_name) {
    let _it;
    if ((v.slice(0, 4) === "me->")) {
        return _dx_add("me.", v.slice(4, v.length));
    }
    if (_dx_contains(v, tape_outs)) {
        return _dx_add("c.", v);
    }
    return v;
}

function emit_tape_backward(name, tape, func_ir, type_defs, lines) {
    let _it;
    let param_name = "x";
    if ((func_ir.params.length > 0)) {
        param_name = func_ir.params[0];
    }
    let tape_outs = [];
    for (const entry of tape) {
        _it = tape_outs.push(entry.out);
    }
    _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add("function ", name), "Backward(me, "), param_name), ", c, d_output, g, d_input) {"));
    for (const entry of tape) {
        _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add("    const d_", entry.out), " = new Float32Array("), entry.n), ");"));
    }
    if ((tape.length > 0)) {
        let first = tape[0];
        if ((first.op === "matmul")) {
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add("    const d_", param_name), " = new Float32Array("), first.N), ");"));
        }
    }
    if ((tape.length > 0)) {
        let last = tape[(tape.length - 1)];
        _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add("    for (let i = 0; i < ", last.n), "; i++) d_"), last.out), "[i] = d_output[i];"));
    }
    let i = (tape.length - 1);
    while ((i >= 0)) {
        let entry = tape[i];
        let op = entry.op;
        if ((op === "softmax")) {
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    SoftmaxBackward(c.", entry.out), ", d_"), entry.out), ", "), bwd_dref(entry.x, tape_outs)), ", "), entry.N), ");"));
        }
        if ((op === "sigmoid")) {
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    SigmoidBackward(c.", entry.out), ", d_"), entry.out), ", "), bwd_dref(entry.x, tape_outs)), ", "), entry.N), ");"));
        }
        if ((op === "relu")) {
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    ReluBackward(c.", entry.out), ", d_"), entry.out), ", "), bwd_dref(entry.x, tape_outs)), ", "), entry.N), ");"));
        }
        if ((op === "vec_add")) {
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    for (let _i=0;_i<", entry.N), ";_i++) { "), bwd_dref(entry.a, tape_outs)), "[_i] += d_"), entry.out), "[_i]; "), bwd_dref(entry.b, tape_outs)), "[_i] += d_"), entry.out), "[_i]; }"));
        }
        if ((op === "broadcast_add")) {
            let a_is_param = (entry.A.slice(0, 4) === "me->");
            let b_is_param = (entry.b.slice(0, 4) === "me->");
            if (a_is_param) {
                let afield = entry.A.slice(4, entry.A.length);
                _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    for (let _i=0;_i<", (entry.M * entry.N)), ";_i++) g.d_"), afield), "[_i] += d_"), entry.out), "[_i];"));
            } else {
                _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    for (let _i=0;_i<", (entry.M * entry.N)), ";_i++) d_"), entry.A), "[_i] += d_"), entry.out), "[_i];"));
            }
            if (b_is_param) {
                let bfield = entry.b.slice(4, entry.b.length);
                _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    for (let _r=0;_r<", entry.M), ";_r++) for(let _j=0;_j<"), entry.N), ";_j++) g.d_"), bfield), "[_j] += d_"), entry.out), "[_r*"), entry.N), "+_j];"));
            } else {
                _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    for (let _r=0;_r<", entry.M), ";_r++) for(let _j=0;_j<"), entry.N), ";_j++) d_"), entry.b), "[_j] += d_"), entry.out), "[_r*"), entry.N), "+_j];"));
            }
        }
        if ((op === "matmul")) {
            let wfield = entry.W.slice(4, entry.W.length);
            let x_ref = bwd_cref(entry.x, tape_outs, param_name);
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    MatmulTranspose(me.", wfield), ", d_"), entry.out), ", "), bwd_dref(entry.x, tape_outs)), ", "), entry.M), ", "), entry.N), ");"));
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    OuterProductAdd(d_", entry.out), ", "), x_ref), ", g.d_"), wfield), ", "), entry.M), ", "), entry.N), ");"));
        }
        if ((op === "matmul_2d")) {
            a_is_param = (entry.A.slice(0, 4) === "me->");
            b_is_param = (entry.B.slice(0, 4) === "me->");
            if (a_is_param) {
                afield = entry.A.slice(4, entry.A.length);
                _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    Matmul2dTransB(d_", entry.out), ", "), bwd_cref(entry.B, tape_outs, param_name)), ", g.d_"), afield), ", "), entry.M), ", "), entry.K), ", "), entry.P), ");"));
            }
            if (b_is_param) {
                bfield = entry.B.slice(4, entry.B.length);
                _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("    Matmul2dTransA(", bwd_cref(entry.A, tape_outs, param_name)), ", d_"), entry.out), ", g.d_"), bfield), ", "), entry.M), ", "), entry.K), ", "), entry.P), ");"));
            }
        }
        i = (i - 1);
    }
    if ((tape.length > 0)) {
        first = tape[0];
        if ((first.op === "matmul")) {
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add("    if (d_input) { for (let _i=0;_i<", first.N), ";_i++) d_input[_i] = "), bwd_dref(first.x, tape_outs)), "[_i]; }"));
        } else {
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add("    if (d_input) { for (let _i=0;_i<", first.n), ";_i++) d_input[_i] = d_"), first.out), "[_i]; }"));
        }
    }
    _it = lines.push("}");
    _it = lines.push("");
    return 0;
}

function emit_tape_cache_factory(name, tape, lines) {
    let _it;
    _it = lines.push(_dx_add(_dx_add("function create", name), "Cache() {"));
    _it = lines.push("    return {");
    for (const entry of tape) {
        _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add("        ", entry.out), ": new Float32Array("), entry.n), "),"));
    }
    _it = lines.push("    };");
    _it = lines.push("}");
    _it = lines.push("");
    return 0;
}

function emit_tape_grad_factory(name, type_defs, owner, lines) {
    let _it;
    let td = type_defs[owner];
    let total = 0;
    for (const f of td.fields) {
        if ((f.dims.length > 0)) {
            let sz = 1;
            for (const dim of f.dims) {
                sz = (sz * dim);
            }
            total = _dx_add(total, sz);
        }
    }
    _it = lines.push(_dx_add(_dx_add("function create", name), "Grad() {"));
    _it = lines.push(_dx_add(_dx_add("    const _buf = new Float32Array(", total), ");"));
    let off = 0;
    _it = lines.push("    return {");
    _it = lines.push("        _buf,");
    for (const f of td.fields) {
        if ((f.dims.length > 0)) {
            let sz = 1;
            for (const dim of f.dims) {
                sz = (sz * dim);
            }
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("        d_", f.name), ": _buf.subarray("), off), ", "), _dx_add(off, sz)), "),"));
            off = _dx_add(off, sz);
        }
    }
    _it = lines.push("    };");
    _it = lines.push("}");
    _it = lines.push("");
    return 0;
}

function emit_tape_create(name, type_defs, owner, lines) {
    let _it;
    let td = type_defs[owner];
    let total = 0;
    for (const f of td.fields) {
        if ((f.dims.length > 0)) {
            let sz = 1;
            for (const dim of f.dims) {
                sz = (sz * dim);
            }
            total = _dx_add(total, sz);
        }
    }
    _it = lines.push(_dx_add(_dx_add("function create", name), "(scale) {"));
    _it = lines.push("    scale = scale || 0.01;");
    _it = lines.push(_dx_add(_dx_add("    const _buf = new Float32Array(", total), ");"));
    _it = lines.push(_dx_add(_dx_add("    for (let i = 0; i < ", total), "; i++) _buf[i] = RngNormal() * scale;"));
    _it = lines.push("    return {");
    _it = lines.push("        _buf,");
    let off = 0;
    for (const f of td.fields) {
        if ((f.dims.length > 0)) {
            let sz = 1;
            for (const dim of f.dims) {
                sz = (sz * dim);
            }
            _it = lines.push(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add(_dx_add("        ", f.name), ": _buf.subarray("), off), ", "), _dx_add(off, sz)), "),"));
            off = _dx_add(off, sz);
        }
    }
    _it = lines.push("    };");
    _it = lines.push("}");
    _it = lines.push("");
    return 0;
}

// ===MainEntry: emit_js ===
function emit_js(stmts) {
    let _it;
    let lines = [];
    _it = lines.push(js_prelude());
    let declared = new _dx_app({});
    let type_names = new _dx_app({});
    let type_defs = new _dx_app({});
    for (const s of stmts) {
        if ((s.kind === "IRTypeDef")) {
            _it = emit_js_typedef(s, lines, type_names);
            type_defs[s.name] = s;
        }
    }
    let tape_method_names = [];
    let tape_method_tapes = [];
    let tape_method_irs = [];
    for (const s of stmts) {
        if ((((s.kind === "IRFuncDef") && _dx_contains("type_name", Object.keys(s))) && (s.type_name !== ""))) {
            let tape = build_tape(s, type_defs);
            if ((tape.length > 0)) {
                _it = tape_method_names.push(s.name);
                _it = tape_method_tapes.push(tape);
                _it = tape_method_irs.push(s);
            }
        }
    }
    let idx = 0;
    while ((idx < tape_method_names.length)) {
        let tname = tape_method_irs[idx].type_name;
        let tape = tape_method_tapes[idx];
        let func_ir = tape_method_irs[idx];
        _it = emit_tape_forward(tname, tape, func_ir, type_defs, lines);
        _it = emit_tape_backward(tname, tape, func_ir, type_defs, lines);
        _it = emit_tape_cache_factory(tname, tape, lines);
        _it = emit_tape_grad_factory(tname, type_defs, tname, lines);
        _it = emit_tape_create(tname, type_defs, tname, lines);
        idx = _dx_add(idx, 1);
    }
    for (const s of stmts) {
        if ((s.kind === "IRFuncDef")) {
            let is_tape_method = false;
            for (const tn of tape_method_names) {
                if ((tn === s.name)) {
                    is_tape_method = true;
                }
            }
            if ((!is_tape_method)) {
                _it = emit_js_func(s, lines, declared, type_names);
            }
        }
    }
    for (const s of stmts) {
        if (((s.kind !== "IRFuncDef") && (s.kind !== "IRTypeDef"))) {
            _it = emit_js_stmt(s, 0, lines, declared, type_names);
        }
    }
    return lines.join("\n");
}

function dx_compile_js(source) {
    let _it;
    let tokens = tokenize(source);
    let p = make_parser(tokens);
    let stmts = parse_program(p);
    stmts = phase1(stmts);
    stmts = lower(stmts);
    return emit_js(stmts);
}

