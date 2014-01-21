/*!
 * jQuery JavaScript Library v1.8.3
 * http://jquery.com/
 *
 * Includes Sizzle.js
 * http://sizzlejs.com/
 *
 * Copyright 2012 jQuery Foundation and other contributors
 * Released under the MIT license
 * http://jquery.org/license
 *
 * Date: Tue Nov 13 2012 08:20:33 GMT-0500 (Eastern Standard Time)
 */
(function (a, b) {
    function G(a) {
        var b = F[a] = {};
        return p.each(a.split(s), function (a, c) {
            b[c] = !0
        }), b
    }

    function J(a, c, d) {
        if (d === b && a.nodeType === 1) {
            var e = "data-" + c.replace(I, "-$1").toLowerCase();
            d = a.getAttribute(e);
            if (typeof d == "string") {
                try {
                    d = d === "true" ? !0 : d === "false" ? !1 : d === "null" ? null : +d + "" === d ? +d : H.test(d) ? p.parseJSON(d) : d
                } catch (f) {
                }
                p.data(a, c, d)
            } else d = b
        }
        return d
    }

    function K(a) {
        var b;
        for (b in a) {
            if (b === "data" && p.isEmptyObject(a[b]))continue;
            if (b !== "toJSON")return!1
        }
        return!0
    }

    function ba() {
        return!1
    }

    function bb() {
        return!0
    }

    function bh(a) {
        return!a || !a.parentNode || a.parentNode.nodeType === 11
    }

    function bi(a, b) {
        do a = a[b]; while (a && a.nodeType !== 1);
        return a
    }

    function bj(a, b, c) {
        b = b || 0;
        if (p.isFunction(b))return p.grep(a, function (a, d) {
            var e = !!b.call(a, d, a);
            return e === c
        });
        if (b.nodeType)return p.grep(a, function (a, d) {
            return a === b === c
        });
        if (typeof b == "string") {
            var d = p.grep(a, function (a) {
                return a.nodeType === 1
            });
            if (be.test(b))return p.filter(b, d, !c);
            b = p.filter(b, d)
        }
        return p.grep(a, function (a, d) {
            return p.inArray(a, b) >= 0 === c
        })
    }

    function bk(a) {
        var b = bl.split("|"), c = a.createDocumentFragment();
        if (c.createElement)while (b.length)c.createElement(b.pop());
        return c
    }

    function bC(a, b) {
        return a.getElementsByTagName(b)[0] || a.appendChild(a.ownerDocument.createElement(b))
    }

    function bD(a, b) {
        if (b.nodeType !== 1 || !p.hasData(a))return;
        var c, d, e, f = p._data(a), g = p._data(b, f), h = f.events;
        if (h) {
            delete g.handle, g.events = {};
            for (c in h)for (d = 0, e = h[c].length; d < e; d++)p.event.add(b, c, h[c][d])
        }
        g.data && (g.data = p.extend({}, g.data))
    }

    function bE(a, b) {
        var c;
        if (b.nodeType !== 1)return;
        b.clearAttributes && b.clearAttributes(), b.mergeAttributes && b.mergeAttributes(a), c = b.nodeName.toLowerCase(), c === "object" ? (b.parentNode && (b.outerHTML = a.outerHTML), p.support.html5Clone && a.innerHTML && !p.trim(b.innerHTML) && (b.innerHTML = a.innerHTML)) : c === "input" && bv.test(a.type) ? (b.defaultChecked = b.checked = a.checked, b.value !== a.value && (b.value = a.value)) : c === "option" ? b.selected = a.defaultSelected : c === "input" || c === "textarea" ? b.defaultValue = a.defaultValue : c === "script" && b.text !== a.text && (b.text = a.text), b.removeAttribute(p.expando)
    }

    function bF(a) {
        return typeof a.getElementsByTagName != "undefined" ? a.getElementsByTagName("*") : typeof a.querySelectorAll != "undefined" ? a.querySelectorAll("*") : []
    }

    function bG(a) {
        bv.test(a.type) && (a.defaultChecked = a.checked)
    }

    function bY(a, b) {
        if (b in a)return b;
        var c = b.charAt(0).toUpperCase() + b.slice(1), d = b, e = bW.length;
        while (e--) {
            b = bW[e] + c;
            if (b in a)return b
        }
        return d
    }

    function bZ(a, b) {
        return a = b || a, p.css(a, "display") === "none" || !p.contains(a.ownerDocument, a)
    }

    function b$(a, b) {
        var c, d, e = [], f = 0, g = a.length;
        for (; f < g; f++) {
            c = a[f];
            if (!c.style)continue;
            e[f] = p._data(c, "olddisplay"), b ? (!e[f] && c.style.display === "none" && (c.style.display = ""), c.style.display === "" && bZ(c) && (e[f] = p._data(c, "olddisplay", cc(c.nodeName)))) : (d = bH(c, "display"), !e[f] && d !== "none" && p._data(c, "olddisplay", d))
        }
        for (f = 0; f < g; f++) {
            c = a[f];
            if (!c.style)continue;
            if (!b || c.style.display === "none" || c.style.display === "")c.style.display = b ? e[f] || "" : "none"
        }
        return a
    }

    function b_(a, b, c) {
        var d = bP.exec(b);
        return d ? Math.max(0, d[1] - (c || 0)) + (d[2] || "px") : b
    }

    function ca(a, b, c, d) {
        var e = c === (d ? "border" : "content") ? 4 : b === "width" ? 1 : 0, f = 0;
        for (; e < 4; e += 2)c === "margin" && (f += p.css(a, c + bV[e], !0)), d ? (c === "content" && (f -= parseFloat(bH(a, "padding" + bV[e])) || 0), c !== "margin" && (f -= parseFloat(bH(a, "border" + bV[e] + "Width")) || 0)) : (f += parseFloat(bH(a, "padding" + bV[e])) || 0, c !== "padding" && (f += parseFloat(bH(a, "border" + bV[e] + "Width")) || 0));
        return f
    }

    function cb(a, b, c) {
        var d = b === "width" ? a.offsetWidth : a.offsetHeight, e = !0, f = p.support.boxSizing && p.css(a, "boxSizing") === "border-box";
        if (d <= 0 || d == null) {
            d = bH(a, b);
            if (d < 0 || d == null)d = a.style[b];
            if (bQ.test(d))return d;
            e = f && (p.support.boxSizingReliable || d === a.style[b]), d = parseFloat(d) || 0
        }
        return d + ca(a, b, c || (f ? "border" : "content"), e) + "px"
    }

    function cc(a) {
        if (bS[a])return bS[a];
        var b = p("<" + a + ">").appendTo(e.body), c = b.css("display");
        b.remove();
        if (c === "none" || c === "") {
            bI = e.body.appendChild(bI || p.extend(e.createElement("iframe"), {frameBorder: 0, width: 0, height: 0}));
            if (!bJ || !bI.createElement)bJ = (bI.contentWindow || bI.contentDocument).document, bJ.write("<!doctype html><html><body>"), bJ.close();
            b = bJ.body.appendChild(bJ.createElement(a)), c = bH(b, "display"), e.body.removeChild(bI)
        }
        return bS[a] = c, c
    }

    function ci(a, b, c, d) {
        var e;
        if (p.isArray(b))p.each(b, function (b, e) {
            c || ce.test(a) ? d(a, e) : ci(a + "[" + (typeof e == "object" ? b : "") + "]", e, c, d)
        }); else if (!c && p.type(b) === "object")for (e in b)ci(a + "[" + e + "]", b[e], c, d); else d(a, b)
    }

    function cz(a) {
        return function (b, c) {
            typeof b != "string" && (c = b, b = "*");
            var d, e, f, g = b.toLowerCase().split(s), h = 0, i = g.length;
            if (p.isFunction(c))for (; h < i; h++)d = g[h], f = /^\+/.test(d), f && (d = d.substr(1) || "*"), e = a[d] = a[d] || [], e[f ? "unshift" : "push"](c)
        }
    }

    function cA(a, c, d, e, f, g) {
        f = f || c.dataTypes[0], g = g || {}, g[f] = !0;
        var h, i = a[f], j = 0, k = i ? i.length : 0, l = a === cv;
        for (; j < k && (l || !h); j++)h = i[j](c, d, e), typeof h == "string" && (!l || g[h] ? h = b : (c.dataTypes.unshift(h), h = cA(a, c, d, e, h, g)));
        return(l || !h) && !g["*"] && (h = cA(a, c, d, e, "*", g)), h
    }

    function cB(a, c) {
        var d, e, f = p.ajaxSettings.flatOptions || {};
        for (d in c)c[d] !== b && ((f[d] ? a : e || (e = {}))[d] = c[d]);
        e && p.extend(!0, a, e)
    }

    function cC(a, c, d) {
        var e, f, g, h, i = a.contents, j = a.dataTypes, k = a.responseFields;
        for (f in k)f in d && (c[k[f]] = d[f]);
        while (j[0] === "*")j.shift(), e === b && (e = a.mimeType || c.getResponseHeader("content-type"));
        if (e)for (f in i)if (i[f] && i[f].test(e)) {
            j.unshift(f);
            break
        }
        if (j[0]in d)g = j[0]; else {
            for (f in d) {
                if (!j[0] || a.converters[f + " " + j[0]]) {
                    g = f;
                    break
                }
                h || (h = f)
            }
            g = g || h
        }
        if (g)return g !== j[0] && j.unshift(g), d[g]
    }

    function cD(a, b) {
        var c, d, e, f, g = a.dataTypes.slice(), h = g[0], i = {}, j = 0;
        a.dataFilter && (b = a.dataFilter(b, a.dataType));
        if (g[1])for (c in a.converters)i[c.toLowerCase()] = a.converters[c];
        for (; e = g[++j];)if (e !== "*") {
            if (h !== "*" && h !== e) {
                c = i[h + " " + e] || i["* " + e];
                if (!c)for (d in i) {
                    f = d.split(" ");
                    if (f[1] === e) {
                        c = i[h + " " + f[0]] || i["* " + f[0]];
                        if (c) {
                            c === !0 ? c = i[d] : i[d] !== !0 && (e = f[0], g.splice(j--, 0, e));
                            break
                        }
                    }
                }
                if (c !== !0)if (c && a["throws"])b = c(b); else try {
                    b = c(b)
                } catch (k) {
                    return{state: "parsererror", error: c ? k : "No conversion from " + h + " to " + e}
                }
            }
            h = e
        }
        return{state: "success", data: b}
    }

    function cL() {
        try {
            return new a.XMLHttpRequest
        } catch (b) {
        }
    }

    function cM() {
        try {
            return new a.ActiveXObject("Microsoft.XMLHTTP")
        } catch (b) {
        }
    }

    function cU() {
        return setTimeout(function () {
            cN = b
        }, 0), cN = p.now()
    }

    function cV(a, b) {
        p.each(b, function (b, c) {
            var d = (cT[b] || []).concat(cT["*"]), e = 0, f = d.length;
            for (; e < f; e++)if (d[e].call(a, b, c))return
        })
    }

    function cW(a, b, c) {
        var d, e = 0, f = 0, g = cS.length, h = p.Deferred().always(function () {
            delete i.elem
        }), i = function () {
            var b = cN || cU(), c = Math.max(0, j.startTime + j.duration - b), d = c / j.duration || 0, e = 1 - d, f = 0, g = j.tweens.length;
            for (; f < g; f++)j.tweens[f].run(e);
            return h.notifyWith(a, [j, e, c]), e < 1 && g ? c : (h.resolveWith(a, [j]), !1)
        }, j = h.promise({elem: a, props: p.extend({}, b), opts: p.extend(!0, {specialEasing: {}}, c), originalProperties: b, originalOptions: c, startTime: cN || cU(), duration: c.duration, tweens: [], createTween: function (b, c, d) {
            var e = p.Tween(a, j.opts, b, c, j.opts.specialEasing[b] || j.opts.easing);
            return j.tweens.push(e), e
        }, stop: function (b) {
            var c = 0, d = b ? j.tweens.length : 0;
            for (; c < d; c++)j.tweens[c].run(1);
            return b ? h.resolveWith(a, [j, b]) : h.rejectWith(a, [j, b]), this
        }}), k = j.props;
        cX(k, j.opts.specialEasing);
        for (; e < g; e++) {
            d = cS[e].call(j, a, k, j.opts);
            if (d)return d
        }
        return cV(j, k), p.isFunction(j.opts.start) && j.opts.start.call(a, j), p.fx.timer(p.extend(i, {anim: j, queue: j.opts.queue, elem: a})), j.progress(j.opts.progress).done(j.opts.done, j.opts.complete).fail(j.opts.fail).always(j.opts.always)
    }

    function cX(a, b) {
        var c, d, e, f, g;
        for (c in a) {
            d = p.camelCase(c), e = b[d], f = a[c], p.isArray(f) && (e = f[1], f = a[c] = f[0]), c !== d && (a[d] = f, delete a[c]), g = p.cssHooks[d];
            if (g && "expand"in g) {
                f = g.expand(f), delete a[d];
                for (c in f)c in a || (a[c] = f[c], b[c] = e)
            } else b[d] = e
        }
    }

    function cY(a, b, c) {
        var d, e, f, g, h, i, j, k, l, m = this, n = a.style, o = {}, q = [], r = a.nodeType && bZ(a);
        c.queue || (k = p._queueHooks(a, "fx"), k.unqueued == null && (k.unqueued = 0, l = k.empty.fire, k.empty.fire = function () {
            k.unqueued || l()
        }), k.unqueued++, m.always(function () {
            m.always(function () {
                k.unqueued--, p.queue(a, "fx").length || k.empty.fire()
            })
        })), a.nodeType === 1 && ("height"in b || "width"in b) && (c.overflow = [n.overflow, n.overflowX, n.overflowY], p.css(a, "display") === "inline" && p.css(a, "float") === "none" && (!p.support.inlineBlockNeedsLayout || cc(a.nodeName) === "inline" ? n.display = "inline-block" : n.zoom = 1)), c.overflow && (n.overflow = "hidden", p.support.shrinkWrapBlocks || m.done(function () {
            n.overflow = c.overflow[0], n.overflowX = c.overflow[1], n.overflowY = c.overflow[2]
        }));
        for (d in b) {
            f = b[d];
            if (cP.exec(f)) {
                delete b[d], i = i || f === "toggle";
                if (f === (r ? "hide" : "show"))continue;
                q.push(d)
            }
        }
        g = q.length;
        if (g) {
            h = p._data(a, "fxshow") || p._data(a, "fxshow", {}), "hidden"in h && (r = h.hidden), i && (h.hidden = !r), r ? p(a).show() : m.done(function () {
                p(a).hide()
            }), m.done(function () {
                var b;
                p.removeData(a, "fxshow", !0);
                for (b in o)p.style(a, b, o[b])
            });
            for (d = 0; d < g; d++)e = q[d], j = m.createTween(e, r ? h[e] : 0), o[e] = h[e] || p.style(a, e), e in h || (h[e] = j.start, r && (j.end = j.start, j.start = e === "width" || e === "height" ? 1 : 0))
        }
    }

    function cZ(a, b, c, d, e) {
        return new cZ.prototype.init(a, b, c, d, e)
    }

    function c$(a, b) {
        var c, d = {height: a}, e = 0;
        b = b ? 1 : 0;
        for (; e < 4; e += 2 - b)c = bV[e], d["margin" + c] = d["padding" + c] = a;
        return b && (d.opacity = d.width = a), d
    }

    function da(a) {
        return p.isWindow(a) ? a : a.nodeType === 9 ? a.defaultView || a.parentWindow : !1
    }

    var c, d, e = a.document, f = a.location, g = a.navigator, h = a.jQuery, i = a.$, j = Array.prototype.push, k = Array.prototype.slice, l = Array.prototype.indexOf, m = Object.prototype.toString, n = Object.prototype.hasOwnProperty, o = String.prototype.trim, p = function (a, b) {
        return new p.fn.init(a, b, c)
    }, q = /[\-+]?(?:\d*\.|)\d+(?:[eE][\-+]?\d+|)/.source, r = /\S/, s = /\s+/, t = /^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, u = /^(?:[^#<]*(<[\w\W]+>)[^>]*$|#([\w\-]*)$)/, v = /^<(\w+)\s*\/?>(?:<\/\1>|)$/, w = /^[\],:{}\s]*$/, x = /(?:^|:|,)(?:\s*\[)+/g, y = /\\(?:["\\\/bfnrt]|u[\da-fA-F]{4})/g, z = /"[^"\\\r\n]*"|true|false|null|-?(?:\d\d*\.|)\d+(?:[eE][\-+]?\d+|)/g, A = /^-ms-/, B = /-([\da-z])/gi, C = function (a, b) {
        return(b + "").toUpperCase()
    }, D = function () {
        e.addEventListener ? (e.removeEventListener("DOMContentLoaded", D, !1), p.ready()) : e.readyState === "complete" && (e.detachEvent("onreadystatechange", D), p.ready())
    }, E = {};
    p.fn = p.prototype = {constructor: p, init: function (a, c, d) {
        var f, g, h, i;
        if (!a)return this;
        if (a.nodeType)return this.context = this[0] = a, this.length = 1, this;
        if (typeof a == "string") {
            a.charAt(0) === "<" && a.charAt(a.length - 1) === ">" && a.length >= 3 ? f = [null, a, null] : f = u.exec(a);
            if (f && (f[1] || !c)) {
                if (f[1])return c = c instanceof p ? c[0] : c, i = c && c.nodeType ? c.ownerDocument || c : e, a = p.parseHTML(f[1], i, !0), v.test(f[1]) && p.isPlainObject(c) && this.attr.call(a, c, !0), p.merge(this, a);
                g = e.getElementById(f[2]);
                if (g && g.parentNode) {
                    if (g.id !== f[2])return d.find(a);
                    this.length = 1, this[0] = g
                }
                return this.context = e, this.selector = a, this
            }
            return!c || c.jquery ? (c || d).find(a) : this.constructor(c).find(a)
        }
        return p.isFunction(a) ? d.ready(a) : (a.selector !== b && (this.selector = a.selector, this.context = a.context), p.makeArray(a, this))
    }, selector: "", jquery: "1.8.3", length: 0, size: function () {
        return this.length
    }, toArray: function () {
        return k.call(this)
    }, get: function (a) {
        return a == null ? this.toArray() : a < 0 ? this[this.length + a] : this[a]
    }, pushStack: function (a, b, c) {
        var d = p.merge(this.constructor(), a);
        return d.prevObject = this, d.context = this.context, b === "find" ? d.selector = this.selector + (this.selector ? " " : "") + c : b && (d.selector = this.selector + "." + b + "(" + c + ")"), d
    }, each: function (a, b) {
        return p.each(this, a, b)
    }, ready: function (a) {
        return p.ready.promise().done(a), this
    }, eq: function (a) {
        return a = +a, a === -1 ? this.slice(a) : this.slice(a, a + 1)
    }, first: function () {
        return this.eq(0)
    }, last: function () {
        return this.eq(-1)
    }, slice: function () {
        return this.pushStack(k.apply(this, arguments), "slice", k.call(arguments).join(","))
    }, map: function (a) {
        return this.pushStack(p.map(this, function (b, c) {
            return a.call(b, c, b)
        }))
    }, end: function () {
        return this.prevObject || this.constructor(null)
    }, push: j, sort: [].sort, splice: [].splice}, p.fn.init.prototype = p.fn, p.extend = p.fn.extend = function () {
        var a, c, d, e, f, g, h = arguments[0] || {}, i = 1, j = arguments.length, k = !1;
        typeof h == "boolean" && (k = h, h = arguments[1] || {}, i = 2), typeof h != "object" && !p.isFunction(h) && (h = {}), j === i && (h = this, --i);
        for (; i < j; i++)if ((a = arguments[i]) != null)for (c in a) {
            d = h[c], e = a[c];
            if (h === e)continue;
            k && e && (p.isPlainObject(e) || (f = p.isArray(e))) ? (f ? (f = !1, g = d && p.isArray(d) ? d : []) : g = d && p.isPlainObject(d) ? d : {}, h[c] = p.extend(k, g, e)) : e !== b && (h[c] = e)
        }
        return h
    }, p.extend({noConflict: function (b) {
        return a.$ === p && (a.$ = i), b && a.jQuery === p && (a.jQuery = h), p
    }, isReady: !1, readyWait: 1, holdReady: function (a) {
        a ? p.readyWait++ : p.ready(!0)
    }, ready: function (a) {
        if (a === !0 ? --p.readyWait : p.isReady)return;
        if (!e.body)return setTimeout(p.ready, 1);
        p.isReady = !0;
        if (a !== !0 && --p.readyWait > 0)return;
        d.resolveWith(e, [p]), p.fn.trigger && p(e).trigger("ready").off("ready")
    }, isFunction: function (a) {
        return p.type(a) === "function"
    }, isArray: Array.isArray || function (a) {
        return p.type(a) === "array"
    }, isWindow: function (a) {
        return a != null && a == a.window
    }, isNumeric: function (a) {
        return!isNaN(parseFloat(a)) && isFinite(a)
    }, type: function (a) {
        return a == null ? String(a) : E[m.call(a)] || "object"
    }, isPlainObject: function (a) {
        if (!a || p.type(a) !== "object" || a.nodeType || p.isWindow(a))return!1;
        try {
            if (a.constructor && !n.call(a, "constructor") && !n.call(a.constructor.prototype, "isPrototypeOf"))return!1
        } catch (c) {
            return!1
        }
        var d;
        for (d in a);
        return d === b || n.call(a, d)
    }, isEmptyObject: function (a) {
        var b;
        for (b in a)return!1;
        return!0
    }, error: function (a) {
        throw new Error(a)
    }, parseHTML: function (a, b, c) {
        var d;
        return!a || typeof a != "string" ? null : (typeof b == "boolean" && (c = b, b = 0), b = b || e, (d = v.exec(a)) ? [b.createElement(d[1])] : (d = p.buildFragment([a], b, c ? null : []), p.merge([], (d.cacheable ? p.clone(d.fragment) : d.fragment).childNodes)))
    }, parseJSON: function (b) {
        if (!b || typeof b != "string")return null;
        b = p.trim(b);
        if (a.JSON && a.JSON.parse)return a.JSON.parse(b);
        if (w.test(b.replace(y, "@").replace(z, "]").replace(x, "")))return(new Function("return " + b))();
        p.error("Invalid JSON: " + b)
    }, parseXML: function (c) {
        var d, e;
        if (!c || typeof c != "string")return null;
        try {
            a.DOMParser ? (e = new DOMParser, d = e.parseFromString(c, "text/xml")) : (d = new ActiveXObject("Microsoft.XMLDOM"), d.async = "false", d.loadXML(c))
        } catch (f) {
            d = b
        }
        return(!d || !d.documentElement || d.getElementsByTagName("parsererror").length) && p.error("Invalid XML: " + c), d
    }, noop: function () {
    }, globalEval: function (b) {
        b && r.test(b) && (a.execScript || function (b) {
            a.eval.call(a, b)
        })(b)
    }, camelCase: function (a) {
        return a.replace(A, "ms-").replace(B, C)
    }, nodeName: function (a, b) {
        return a.nodeName && a.nodeName.toLowerCase() === b.toLowerCase()
    }, each: function (a, c, d) {
        var e, f = 0, g = a.length, h = g === b || p.isFunction(a);
        if (d) {
            if (h) {
                for (e in a)if (c.apply(a[e], d) === !1)break
            } else for (; f < g;)if (c.apply(a[f++], d) === !1)break
        } else if (h) {
            for (e in a)if (c.call(a[e], e, a[e]) === !1)break
        } else for (; f < g;)if (c.call(a[f], f, a[f++]) === !1)break;
        return a
    }, trim: o && !o.call("﻿ ") ? function (a) {
        return a == null ? "" : o.call(a)
    } : function (a) {
        return a == null ? "" : (a + "").replace(t, "")
    }, makeArray: function (a, b) {
        var c, d = b || [];
        return a != null && (c = p.type(a), a.length == null || c === "string" || c === "function" || c === "regexp" || p.isWindow(a) ? j.call(d, a) : p.merge(d, a)), d
    }, inArray: function (a, b, c) {
        var d;
        if (b) {
            if (l)return l.call(b, a, c);
            d = b.length, c = c ? c < 0 ? Math.max(0, d + c) : c : 0;
            for (; c < d; c++)if (c in b && b[c] === a)return c
        }
        return-1
    }, merge: function (a, c) {
        var d = c.length, e = a.length, f = 0;
        if (typeof d == "number")for (; f < d; f++)a[e++] = c[f]; else while (c[f] !== b)a[e++] = c[f++];
        return a.length = e, a
    }, grep: function (a, b, c) {
        var d, e = [], f = 0, g = a.length;
        c = !!c;
        for (; f < g; f++)d = !!b(a[f], f), c !== d && e.push(a[f]);
        return e
    }, map: function (a, c, d) {
        var e, f, g = [], h = 0, i = a.length, j = a instanceof p || i !== b && typeof i == "number" && (i > 0 && a[0] && a[i - 1] || i === 0 || p.isArray(a));
        if (j)for (; h < i; h++)e = c(a[h], h, d), e != null && (g[g.length] = e); else for (f in a)e = c(a[f], f, d), e != null && (g[g.length] = e);
        return g.concat.apply([], g)
    }, guid: 1, proxy: function (a, c) {
        var d, e, f;
        return typeof c == "string" && (d = a[c], c = a, a = d), p.isFunction(a) ? (e = k.call(arguments, 2), f = function () {
            return a.apply(c, e.concat(k.call(arguments)))
        }, f.guid = a.guid = a.guid || p.guid++, f) : b
    }, access: function (a, c, d, e, f, g, h) {
        var i, j = d == null, k = 0, l = a.length;
        if (d && typeof d == "object") {
            for (k in d)p.access(a, c, k, d[k], 1, g, e);
            f = 1
        } else if (e !== b) {
            i = h === b && p.isFunction(e), j && (i ? (i = c, c = function (a, b, c) {
                return i.call(p(a), c)
            }) : (c.call(a, e), c = null));
            if (c)for (; k < l; k++)c(a[k], d, i ? e.call(a[k], k, c(a[k], d)) : e, h);
            f = 1
        }
        return f ? a : j ? c.call(a) : l ? c(a[0], d) : g
    }, now: function () {
        return(new Date).getTime()
    }}), p.ready.promise = function (b) {
        if (!d) {
            d = p.Deferred();
            if (e.readyState === "complete")setTimeout(p.ready, 1); else if (e.addEventListener)e.addEventListener("DOMContentLoaded", D, !1), a.addEventListener("load", p.ready, !1); else {
                e.attachEvent("onreadystatechange", D), a.attachEvent("onload", p.ready);
                var c = !1;
                try {
                    c = a.frameElement == null && e.documentElement
                } catch (f) {
                }
                c && c.doScroll && function g() {
                    if (!p.isReady) {
                        try {
                            c.doScroll("left")
                        } catch (a) {
                            return setTimeout(g, 50)
                        }
                        p.ready()
                    }
                }()
            }
        }
        return d.promise(b)
    }, p.each("Boolean Number String Function Array Date RegExp Object".split(" "), function (a, b) {
        E["[object " + b + "]"] = b.toLowerCase()
    }), c = p(e);
    var F = {};
    p.Callbacks = function (a) {
        a = typeof a == "string" ? F[a] || G(a) : p.extend({}, a);
        var c, d, e, f, g, h, i = [], j = !a.once && [], k = function (b) {
            c = a.memory && b, d = !0, h = f || 0, f = 0, g = i.length, e = !0;
            for (; i && h < g; h++)if (i[h].apply(b[0], b[1]) === !1 && a.stopOnFalse) {
                c = !1;
                break
            }
            e = !1, i && (j ? j.length && k(j.shift()) : c ? i = [] : l.disable())
        }, l = {add: function () {
            if (i) {
                var b = i.length;
                (function d(b) {
                    p.each(b, function (b, c) {
                        var e = p.type(c);
                        e === "function" ? (!a.unique || !l.has(c)) && i.push(c) : c && c.length && e !== "string" && d(c)
                    })
                })(arguments), e ? g = i.length : c && (f = b, k(c))
            }
            return this
        }, remove: function () {
            return i && p.each(arguments, function (a, b) {
                var c;
                while ((c = p.inArray(b, i, c)) > -1)i.splice(c, 1), e && (c <= g && g--, c <= h && h--)
            }), this
        }, has: function (a) {
            return p.inArray(a, i) > -1
        }, empty: function () {
            return i = [], this
        }, disable: function () {
            return i = j = c = b, this
        }, disabled: function () {
            return!i
        }, lock: function () {
            return j = b, c || l.disable(), this
        }, locked: function () {
            return!j
        }, fireWith: function (a, b) {
            return b = b || [], b = [a, b.slice ? b.slice() : b], i && (!d || j) && (e ? j.push(b) : k(b)), this
        }, fire: function () {
            return l.fireWith(this, arguments), this
        }, fired: function () {
            return!!d
        }};
        return l
    }, p.extend({Deferred: function (a) {
        var b = [
            ["resolve", "done", p.Callbacks("once memory"), "resolved"],
            ["reject", "fail", p.Callbacks("once memory"), "rejected"],
            ["notify", "progress", p.Callbacks("memory")]
        ], c = "pending", d = {state: function () {
            return c
        }, always: function () {
            return e.done(arguments).fail(arguments), this
        }, then: function () {
            var a = arguments;
            return p.Deferred(function (c) {
                p.each(b, function (b, d) {
                    var f = d[0], g = a[b];
                    e[d[1]](p.isFunction(g) ? function () {
                        var a = g.apply(this, arguments);
                        a && p.isFunction(a.promise) ? a.promise().done(c.resolve).fail(c.reject).progress(c.notify) : c[f + "With"](this === e ? c : this, [a])
                    } : c[f])
                }), a = null
            }).promise()
        }, promise: function (a) {
            return a != null ? p.extend(a, d) : d
        }}, e = {};
        return d.pipe = d.then, p.each(b, function (a, f) {
            var g = f[2], h = f[3];
            d[f[1]] = g.add, h && g.add(function () {
                c = h
            }, b[a ^ 1][2].disable, b[2][2].lock), e[f[0]] = g.fire, e[f[0] + "With"] = g.fireWith
        }), d.promise(e), a && a.call(e, e), e
    }, when: function (a) {
        var b = 0, c = k.call(arguments), d = c.length, e = d !== 1 || a && p.isFunction(a.promise) ? d : 0, f = e === 1 ? a : p.Deferred(), g = function (a, b, c) {
            return function (d) {
                b[a] = this, c[a] = arguments.length > 1 ? k.call(arguments) : d, c === h ? f.notifyWith(b, c) : --e || f.resolveWith(b, c)
            }
        }, h, i, j;
        if (d > 1) {
            h = new Array(d), i = new Array(d), j = new Array(d);
            for (; b < d; b++)c[b] && p.isFunction(c[b].promise) ? c[b].promise().done(g(b, j, c)).fail(f.reject).progress(g(b, i, h)) : --e
        }
        return e || f.resolveWith(j, c), f.promise()
    }}), p.support = function () {
        var b, c, d, f, g, h, i, j, k, l, m, n = e.createElement("div");
        n.setAttribute("className", "t"), n.innerHTML = "  <link/><table></table><a href='/a'>a</a><input type='checkbox'/>", c = n.getElementsByTagName("*"), d = n.getElementsByTagName("a")[0];
        if (!c || !d || !c.length)return{};
        f = e.createElement("select"), g = f.appendChild(e.createElement("option")), h = n.getElementsByTagName("input")[0], d.style.cssText = "top:1px;float:left;opacity:.5", b = {leadingWhitespace: n.firstChild.nodeType === 3, tbody: !n.getElementsByTagName("tbody").length, htmlSerialize: !!n.getElementsByTagName("link").length, style: /top/.test(d.getAttribute("style")), hrefNormalized: d.getAttribute("href") === "/a", opacity: /^0.5/.test(d.style.opacity), cssFloat: !!d.style.cssFloat, checkOn: h.value === "on", optSelected: g.selected, getSetAttribute: n.className !== "t", enctype: !!e.createElement("form").enctype, html5Clone: e.createElement("nav").cloneNode(!0).outerHTML !== "<:nav></:nav>", boxModel: e.compatMode === "CSS1Compat", submitBubbles: !0, changeBubbles: !0, focusinBubbles: !1, deleteExpando: !0, noCloneEvent: !0, inlineBlockNeedsLayout: !1, shrinkWrapBlocks: !1, reliableMarginRight: !0, boxSizingReliable: !0, pixelPosition: !1}, h.checked = !0, b.noCloneChecked = h.cloneNode(!0).checked, f.disabled = !0, b.optDisabled = !g.disabled;
        try {
            delete n.test
        } catch (o) {
            b.deleteExpando = !1
        }
        !n.addEventListener && n.attachEvent && n.fireEvent && (n.attachEvent("onclick", m = function () {
            b.noCloneEvent = !1
        }), n.cloneNode(!0).fireEvent("onclick"), n.detachEvent("onclick", m)), h = e.createElement("input"), h.value = "t", h.setAttribute("type", "radio"), b.radioValue = h.value === "t", h.setAttribute("checked", "checked"), h.setAttribute("name", "t"), n.appendChild(h), i = e.createDocumentFragment(), i.appendChild(n.lastChild), b.checkClone = i.cloneNode(!0).cloneNode(!0).lastChild.checked, b.appendChecked = h.checked, i.removeChild(h), i.appendChild(n);
        if (n.attachEvent)for (k in{submit: !0, change: !0, focusin: !0})j = "on" + k, l = j in n, l || (n.setAttribute(j, "return;"), l = typeof n[j] == "function"), b[k + "Bubbles"] = l;
        return p(function () {
            var c, d, f, g, h = "padding:0;margin:0;border:0;display:block;overflow:hidden;", i = e.getElementsByTagName("body")[0];
            if (!i)return;
            c = e.createElement("div"), c.style.cssText = "visibility:hidden;border:0;width:0;height:0;position:static;top:0;margin-top:1px", i.insertBefore(c, i.firstChild), d = e.createElement("div"), c.appendChild(d), d.innerHTML = "<table><tr><td></td><td>t</td></tr></table>", f = d.getElementsByTagName("td"), f[0].style.cssText = "padding:0;margin:0;border:0;display:none", l = f[0].offsetHeight === 0, f[0].style.display = "", f[1].style.display = "none", b.reliableHiddenOffsets = l && f[0].offsetHeight === 0, d.innerHTML = "", d.style.cssText = "box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;padding:1px;border:1px;display:block;width:4px;margin-top:1%;position:absolute;top:1%;", b.boxSizing = d.offsetWidth === 4, b.doesNotIncludeMarginInBodyOffset = i.offsetTop !== 1, a.getComputedStyle && (b.pixelPosition = (a.getComputedStyle(d, null) || {}).top !== "1%", b.boxSizingReliable = (a.getComputedStyle(d, null) || {width: "4px"}).width === "4px", g = e.createElement("div"), g.style.cssText = d.style.cssText = h, g.style.marginRight = g.style.width = "0", d.style.width = "1px", d.appendChild(g), b.reliableMarginRight = !parseFloat((a.getComputedStyle(g, null) || {}).marginRight)), typeof d.style.zoom != "undefined" && (d.innerHTML = "", d.style.cssText = h + "width:1px;padding:1px;display:inline;zoom:1", b.inlineBlockNeedsLayout = d.offsetWidth === 3, d.style.display = "block", d.style.overflow = "visible", d.innerHTML = "<div></div>", d.firstChild.style.width = "5px", b.shrinkWrapBlocks = d.offsetWidth !== 3, c.style.zoom = 1), i.removeChild(c), c = d = f = g = null
        }), i.removeChild(n), c = d = f = g = h = i = n = null, b
    }();
    var H = /(?:\{[\s\S]*\}|\[[\s\S]*\])$/, I = /([A-Z])/g;
    p.extend({cache: {}, deletedIds: [], uuid: 0, expando: "jQuery" + (p.fn.jquery + Math.random()).replace(/\D/g, ""), noData: {embed: !0, object: "clsid:D27CDB6E-AE6D-11cf-96B8-444553540000", applet: !0}, hasData: function (a) {
        return a = a.nodeType ? p.cache[a[p.expando]] : a[p.expando], !!a && !K(a)
    }, data: function (a, c, d, e) {
        if (!p.acceptData(a))return;
        var f, g, h = p.expando, i = typeof c == "string", j = a.nodeType, k = j ? p.cache : a, l = j ? a[h] : a[h] && h;
        if ((!l || !k[l] || !e && !k[l].data) && i && d === b)return;
        l || (j ? a[h] = l = p.deletedIds.pop() || p.guid++ : l = h), k[l] || (k[l] = {}, j || (k[l].toJSON = p.noop));
        if (typeof c == "object" || typeof c == "function")e ? k[l] = p.extend(k[l], c) : k[l].data = p.extend(k[l].data, c);
        return f = k[l], e || (f.data || (f.data = {}), f = f.data), d !== b && (f[p.camelCase(c)] = d), i ? (g = f[c], g == null && (g = f[p.camelCase(c)])) : g = f, g
    }, removeData: function (a, b, c) {
        if (!p.acceptData(a))return;
        var d, e, f, g = a.nodeType, h = g ? p.cache : a, i = g ? a[p.expando] : p.expando;
        if (!h[i])return;
        if (b) {
            d = c ? h[i] : h[i].data;
            if (d) {
                p.isArray(b) || (b in d ? b = [b] : (b = p.camelCase(b), b in d ? b = [b] : b = b.split(" ")));
                for (e = 0, f = b.length; e < f; e++)delete d[b[e]];
                if (!(c ? K : p.isEmptyObject)(d))return
            }
        }
        if (!c) {
            delete h[i].data;
            if (!K(h[i]))return
        }
        g ? p.cleanData([a], !0) : p.support.deleteExpando || h != h.window ? delete h[i] : h[i] = null
    }, _data: function (a, b, c) {
        return p.data(a, b, c, !0)
    }, acceptData: function (a) {
        var b = a.nodeName && p.noData[a.nodeName.toLowerCase()];
        return!b || b !== !0 && a.getAttribute("classid") === b
    }}), p.fn.extend({data: function (a, c) {
        var d, e, f, g, h, i = this[0], j = 0, k = null;
        if (a === b) {
            if (this.length) {
                k = p.data(i);
                if (i.nodeType === 1 && !p._data(i, "parsedAttrs")) {
                    f = i.attributes;
                    for (h = f.length; j < h; j++)g = f[j].name, g.indexOf("data-") || (g = p.camelCase(g.substring(5)), J(i, g, k[g]));
                    p._data(i, "parsedAttrs", !0)
                }
            }
            return k
        }
        return typeof a == "object" ? this.each(function () {
            p.data(this, a)
        }) : (d = a.split(".", 2), d[1] = d[1] ? "." + d[1] : "", e = d[1] + "!", p.access(this, function (c) {
            if (c === b)return k = this.triggerHandler("getData" + e, [d[0]]), k === b && i && (k = p.data(i, a), k = J(i, a, k)), k === b && d[1] ? this.data(d[0]) : k;
            d[1] = c, this.each(function () {
                var b = p(this);
                b.triggerHandler("setData" + e, d), p.data(this, a, c), b.triggerHandler("changeData" + e, d)
            })
        }, null, c, arguments.length > 1, null, !1))
    }, removeData: function (a) {
        return this.each(function () {
            p.removeData(this, a)
        })
    }}), p.extend({queue: function (a, b, c) {
        var d;
        if (a)return b = (b || "fx") + "queue", d = p._data(a, b), c && (!d || p.isArray(c) ? d = p._data(a, b, p.makeArray(c)) : d.push(c)), d || []
    }, dequeue: function (a, b) {
        b = b || "fx";
        var c = p.queue(a, b), d = c.length, e = c.shift(), f = p._queueHooks(a, b), g = function () {
            p.dequeue(a, b)
        };
        e === "inprogress" && (e = c.shift(), d--), e && (b === "fx" && c.unshift("inprogress"), delete f.stop, e.call(a, g, f)), !d && f && f.empty.fire()
    }, _queueHooks: function (a, b) {
        var c = b + "queueHooks";
        return p._data(a, c) || p._data(a, c, {empty: p.Callbacks("once memory").add(function () {
            p.removeData(a, b + "queue", !0), p.removeData(a, c, !0)
        })})
    }}), p.fn.extend({queue: function (a, c) {
        var d = 2;
        return typeof a != "string" && (c = a, a = "fx", d--), arguments.length < d ? p.queue(this[0], a) : c === b ? this : this.each(function () {
            var b = p.queue(this, a, c);
            p._queueHooks(this, a), a === "fx" && b[0] !== "inprogress" && p.dequeue(this, a)
        })
    }, dequeue: function (a) {
        return this.each(function () {
            p.dequeue(this, a)
        })
    }, delay: function (a, b) {
        return a = p.fx ? p.fx.speeds[a] || a : a, b = b || "fx", this.queue(b, function (b, c) {
            var d = setTimeout(b, a);
            c.stop = function () {
                clearTimeout(d)
            }
        })
    }, clearQueue: function (a) {
        return this.queue(a || "fx", [])
    }, promise: function (a, c) {
        var d, e = 1, f = p.Deferred(), g = this, h = this.length, i = function () {
            --e || f.resolveWith(g, [g])
        };
        typeof a != "string" && (c = a, a = b), a = a || "fx";
        while (h--)d = p._data(g[h], a + "queueHooks"), d && d.empty && (e++, d.empty.add(i));
        return i(), f.promise(c)
    }});
    var L, M, N, O = /[\t\r\n]/g, P = /\r/g, Q = /^(?:button|input)$/i, R = /^(?:button|input|object|select|textarea)$/i, S = /^a(?:rea|)$/i, T = /^(?:autofocus|autoplay|async|checked|controls|defer|disabled|hidden|loop|multiple|open|readonly|required|scoped|selected)$/i, U = p.support.getSetAttribute;
    p.fn.extend({attr: function (a, b) {
        return p.access(this, p.attr, a, b, arguments.length > 1)
    }, removeAttr: function (a) {
        return this.each(function () {
            p.removeAttr(this, a)
        })
    }, prop: function (a, b) {
        return p.access(this, p.prop, a, b, arguments.length > 1)
    }, removeProp: function (a) {
        return a = p.propFix[a] || a, this.each(function () {
            try {
                this[a] = b, delete this[a]
            } catch (c) {
            }
        })
    }, addClass: function (a) {
        var b, c, d, e, f, g, h;
        if (p.isFunction(a))return this.each(function (b) {
            p(this).addClass(a.call(this, b, this.className))
        });
        if (a && typeof a == "string") {
            b = a.split(s);
            for (c = 0, d = this.length; c < d; c++) {
                e = this[c];
                if (e.nodeType === 1)if (!e.className && b.length === 1)e.className = a; else {
                    f = " " + e.className + " ";
                    for (g = 0, h = b.length; g < h; g++)f.indexOf(" " + b[g] + " ") < 0 && (f += b[g] + " ");
                    e.className = p.trim(f)
                }
            }
        }
        return this
    }, removeClass: function (a) {
        var c, d, e, f, g, h, i;
        if (p.isFunction(a))return this.each(function (b) {
            p(this).removeClass(a.call(this, b, this.className))
        });
        if (a && typeof a == "string" || a === b) {
            c = (a || "").split(s);
            for (h = 0, i = this.length; h < i; h++) {
                e = this[h];
                if (e.nodeType === 1 && e.className) {
                    d = (" " + e.className + " ").replace(O, " ");
                    for (f = 0, g = c.length; f < g; f++)while (d.indexOf(" " + c[f] + " ") >= 0)d = d.replace(" " + c[f] + " ", " ");
                    e.className = a ? p.trim(d) : ""
                }
            }
        }
        return this
    }, toggleClass: function (a, b) {
        var c = typeof a, d = typeof b == "boolean";
        return p.isFunction(a) ? this.each(function (c) {
            p(this).toggleClass(a.call(this, c, this.className, b), b)
        }) : this.each(function () {
            if (c === "string") {
                var e, f = 0, g = p(this), h = b, i = a.split(s);
                while (e = i[f++])h = d ? h : !g.hasClass(e), g[h ? "addClass" : "removeClass"](e)
            } else if (c === "undefined" || c === "boolean")this.className && p._data(this, "__className__", this.className), this.className = this.className || a === !1 ? "" : p._data(this, "__className__") || ""
        })
    }, hasClass: function (a) {
        var b = " " + a + " ", c = 0, d = this.length;
        for (; c < d; c++)if (this[c].nodeType === 1 && (" " + this[c].className + " ").replace(O, " ").indexOf(b) >= 0)return!0;
        return!1
    }, val: function (a) {
        var c, d, e, f = this[0];
        if (!arguments.length) {
            if (f)return c = p.valHooks[f.type] || p.valHooks[f.nodeName.toLowerCase()], c && "get"in c && (d = c.get(f, "value")) !== b ? d : (d = f.value, typeof d == "string" ? d.replace(P, "") : d == null ? "" : d);
            return
        }
        return e = p.isFunction(a), this.each(function (d) {
            var f, g = p(this);
            if (this.nodeType !== 1)return;
            e ? f = a.call(this, d, g.val()) : f = a, f == null ? f = "" : typeof f == "number" ? f += "" : p.isArray(f) && (f = p.map(f, function (a) {
                return a == null ? "" : a + ""
            })), c = p.valHooks[this.type] || p.valHooks[this.nodeName.toLowerCase()];
            if (!c || !("set"in c) || c.set(this, f, "value") === b)this.value = f
        })
    }}), p.extend({valHooks: {option: {get: function (a) {
        var b = a.attributes.value;
        return!b || b.specified ? a.value : a.text
    }}, select: {get: function (a) {
        var b, c, d = a.options, e = a.selectedIndex, f = a.type === "select-one" || e < 0, g = f ? null : [], h = f ? e + 1 : d.length, i = e < 0 ? h : f ? e : 0;
        for (; i < h; i++) {
            c = d[i];
            if ((c.selected || i === e) && (p.support.optDisabled ? !c.disabled : c.getAttribute("disabled") === null) && (!c.parentNode.disabled || !p.nodeName(c.parentNode, "optgroup"))) {
                b = p(c).val();
                if (f)return b;
                g.push(b)
            }
        }
        return g
    }, set: function (a, b) {
        var c = p.makeArray(b);
        return p(a).find("option").each(function () {
            this.selected = p.inArray(p(this).val(), c) >= 0
        }), c.length || (a.selectedIndex = -1), c
    }}}, attrFn: {}, attr: function (a, c, d, e) {
        var f, g, h, i = a.nodeType;
        if (!a || i === 3 || i === 8 || i === 2)return;
        if (e && p.isFunction(p.fn[c]))return p(a)[c](d);
        if (typeof a.getAttribute == "undefined")return p.prop(a, c, d);
        h = i !== 1 || !p.isXMLDoc(a), h && (c = c.toLowerCase(), g = p.attrHooks[c] || (T.test(c) ? M : L));
        if (d !== b) {
            if (d === null) {
                p.removeAttr(a, c);
                return
            }
            return g && "set"in g && h && (f = g.set(a, d, c)) !== b ? f : (a.setAttribute(c, d + ""), d)
        }
        return g && "get"in g && h && (f = g.get(a, c)) !== null ? f : (f = a.getAttribute(c), f === null ? b : f)
    }, removeAttr: function (a, b) {
        var c, d, e, f, g = 0;
        if (b && a.nodeType === 1) {
            d = b.split(s);
            for (; g < d.length; g++)e = d[g], e && (c = p.propFix[e] || e, f = T.test(e), f || p.attr(a, e, ""), a.removeAttribute(U ? e : c), f && c in a && (a[c] = !1))
        }
    }, attrHooks: {type: {set: function (a, b) {
        if (Q.test(a.nodeName) && a.parentNode)p.error("type property can't be changed"); else if (!p.support.radioValue && b === "radio" && p.nodeName(a, "input")) {
            var c = a.value;
            return a.setAttribute("type", b), c && (a.value = c), b
        }
    }}, value: {get: function (a, b) {
        return L && p.nodeName(a, "button") ? L.get(a, b) : b in a ? a.value : null
    }, set: function (a, b, c) {
        if (L && p.nodeName(a, "button"))return L.set(a, b, c);
        a.value = b
    }}}, propFix: {tabindex: "tabIndex", readonly: "readOnly", "for": "htmlFor", "class": "className", maxlength: "maxLength", cellspacing: "cellSpacing", cellpadding: "cellPadding", rowspan: "rowSpan", colspan: "colSpan", usemap: "useMap", frameborder: "frameBorder", contenteditable: "contentEditable"}, prop: function (a, c, d) {
        var e, f, g, h = a.nodeType;
        if (!a || h === 3 || h === 8 || h === 2)return;
        return g = h !== 1 || !p.isXMLDoc(a), g && (c = p.propFix[c] || c, f = p.propHooks[c]), d !== b ? f && "set"in f && (e = f.set(a, d, c)) !== b ? e : a[c] = d : f && "get"in f && (e = f.get(a, c)) !== null ? e : a[c]
    }, propHooks: {tabIndex: {get: function (a) {
        var c = a.getAttributeNode("tabindex");
        return c && c.specified ? parseInt(c.value, 10) : R.test(a.nodeName) || S.test(a.nodeName) && a.href ? 0 : b
    }}}}), M = {get: function (a, c) {
        var d, e = p.prop(a, c);
        return e === !0 || typeof e != "boolean" && (d = a.getAttributeNode(c)) && d.nodeValue !== !1 ? c.toLowerCase() : b
    }, set: function (a, b, c) {
        var d;
        return b === !1 ? p.removeAttr(a, c) : (d = p.propFix[c] || c, d in a && (a[d] = !0), a.setAttribute(c, c.toLowerCase())), c
    }}, U || (N = {name: !0, id: !0, coords: !0}, L = p.valHooks.button = {get: function (a, c) {
        var d;
        return d = a.getAttributeNode(c), d && (N[c] ? d.value !== "" : d.specified) ? d.value : b
    }, set: function (a, b, c) {
        var d = a.getAttributeNode(c);
        return d || (d = e.createAttribute(c), a.setAttributeNode(d)), d.value = b + ""
    }}, p.each(["width", "height"], function (a, b) {
        p.attrHooks[b] = p.extend(p.attrHooks[b], {set: function (a, c) {
            if (c === "")return a.setAttribute(b, "auto"), c
        }})
    }), p.attrHooks.contenteditable = {get: L.get, set: function (a, b, c) {
        b === "" && (b = "false"), L.set(a, b, c)
    }}), p.support.hrefNormalized || p.each(["href"
        , "src", "width", "height"], function (a, c) {
        p.attrHooks[c] = p.extend(p.attrHooks[c], {get: function (a) {
            var d = a.getAttribute(c, 2);
            return d === null ? b : d
        }})
    }), p.support.style || (p.attrHooks.style = {get: function (a) {
        return a.style.cssText.toLowerCase() || b
    }, set: function (a, b) {
        return a.style.cssText = b + ""
    }}), p.support.optSelected || (p.propHooks.selected = p.extend(p.propHooks.selected, {get: function (a) {
        var b = a.parentNode;
        return b && (b.selectedIndex, b.parentNode && b.parentNode.selectedIndex), null
    }})), p.support.enctype || (p.propFix.enctype = "encoding"), p.support.checkOn || p.each(["radio", "checkbox"], function () {
        p.valHooks[this] = {get: function (a) {
            return a.getAttribute("value") === null ? "on" : a.value
        }}
    }), p.each(["radio", "checkbox"], function () {
        p.valHooks[this] = p.extend(p.valHooks[this], {set: function (a, b) {
            if (p.isArray(b))return a.checked = p.inArray(p(a).val(), b) >= 0
        }})
    });
    var V = /^(?:textarea|input|select)$/i, W = /^([^\.]*|)(?:\.(.+)|)$/, X = /(?:^|\s)hover(\.\S+|)\b/, Y = /^key/, Z = /^(?:mouse|contextmenu)|click/, $ = /^(?:focusinfocus|focusoutblur)$/, _ = function (a) {
        return p.event.special.hover ? a : a.replace(X, "mouseenter$1 mouseleave$1")
    };
    p.event = {add: function (a, c, d, e, f) {
        var g, h, i, j, k, l, m, n, o, q, r;
        if (a.nodeType === 3 || a.nodeType === 8 || !c || !d || !(g = p._data(a)))return;
        d.handler && (o = d, d = o.handler, f = o.selector), d.guid || (d.guid = p.guid++), i = g.events, i || (g.events = i = {}), h = g.handle, h || (g.handle = h = function (a) {
            return typeof p == "undefined" || !!a && p.event.triggered === a.type ? b : p.event.dispatch.apply(h.elem, arguments)
        }, h.elem = a), c = p.trim(_(c)).split(" ");
        for (j = 0; j < c.length; j++) {
            k = W.exec(c[j]) || [], l = k[1], m = (k[2] || "").split(".").sort(), r = p.event.special[l] || {}, l = (f ? r.delegateType : r.bindType) || l, r = p.event.special[l] || {}, n = p.extend({type: l, origType: k[1], data: e, handler: d, guid: d.guid, selector: f, needsContext: f && p.expr.match.needsContext.test(f), namespace: m.join(".")}, o), q = i[l];
            if (!q) {
                q = i[l] = [], q.delegateCount = 0;
                if (!r.setup || r.setup.call(a, e, m, h) === !1)a.addEventListener ? a.addEventListener(l, h, !1) : a.attachEvent && a.attachEvent("on" + l, h)
            }
            r.add && (r.add.call(a, n), n.handler.guid || (n.handler.guid = d.guid)), f ? q.splice(q.delegateCount++, 0, n) : q.push(n), p.event.global[l] = !0
        }
        a = null
    }, global: {}, remove: function (a, b, c, d, e) {
        var f, g, h, i, j, k, l, m, n, o, q, r = p.hasData(a) && p._data(a);
        if (!r || !(m = r.events))return;
        b = p.trim(_(b || "")).split(" ");
        for (f = 0; f < b.length; f++) {
            g = W.exec(b[f]) || [], h = i = g[1], j = g[2];
            if (!h) {
                for (h in m)p.event.remove(a, h + b[f], c, d, !0);
                continue
            }
            n = p.event.special[h] || {}, h = (d ? n.delegateType : n.bindType) || h, o = m[h] || [], k = o.length, j = j ? new RegExp("(^|\\.)" + j.split(".").sort().join("\\.(?:.*\\.|)") + "(\\.|$)") : null;
            for (l = 0; l < o.length; l++)q = o[l], (e || i === q.origType) && (!c || c.guid === q.guid) && (!j || j.test(q.namespace)) && (!d || d === q.selector || d === "**" && q.selector) && (o.splice(l--, 1), q.selector && o.delegateCount--, n.remove && n.remove.call(a, q));
            o.length === 0 && k !== o.length && ((!n.teardown || n.teardown.call(a, j, r.handle) === !1) && p.removeEvent(a, h, r.handle), delete m[h])
        }
        p.isEmptyObject(m) && (delete r.handle, p.removeData(a, "events", !0))
    }, customEvent: {getData: !0, setData: !0, changeData: !0}, trigger: function (c, d, f, g) {
        if (!f || f.nodeType !== 3 && f.nodeType !== 8) {
            var h, i, j, k, l, m, n, o, q, r, s = c.type || c, t = [];
            if ($.test(s + p.event.triggered))return;
            s.indexOf("!") >= 0 && (s = s.slice(0, -1), i = !0), s.indexOf(".") >= 0 && (t = s.split("."), s = t.shift(), t.sort());
            if ((!f || p.event.customEvent[s]) && !p.event.global[s])return;
            c = typeof c == "object" ? c[p.expando] ? c : new p.Event(s, c) : new p.Event(s), c.type = s, c.isTrigger = !0, c.exclusive = i, c.namespace = t.join("."), c.namespace_re = c.namespace ? new RegExp("(^|\\.)" + t.join("\\.(?:.*\\.|)") + "(\\.|$)") : null, m = s.indexOf(":") < 0 ? "on" + s : "";
            if (!f) {
                h = p.cache;
                for (j in h)h[j].events && h[j].events[s] && p.event.trigger(c, d, h[j].handle.elem, !0);
                return
            }
            c.result = b, c.target || (c.target = f), d = d != null ? p.makeArray(d) : [], d.unshift(c), n = p.event.special[s] || {};
            if (n.trigger && n.trigger.apply(f, d) === !1)return;
            q = [
                [f, n.bindType || s]
            ];
            if (!g && !n.noBubble && !p.isWindow(f)) {
                r = n.delegateType || s, k = $.test(r + s) ? f : f.parentNode;
                for (l = f; k; k = k.parentNode)q.push([k, r]), l = k;
                l === (f.ownerDocument || e) && q.push([l.defaultView || l.parentWindow || a, r])
            }
            for (j = 0; j < q.length && !c.isPropagationStopped(); j++)k = q[j][0], c.type = q[j][1], o = (p._data(k, "events") || {})[c.type] && p._data(k, "handle"), o && o.apply(k, d), o = m && k[m], o && p.acceptData(k) && o.apply && o.apply(k, d) === !1 && c.preventDefault();
            return c.type = s, !g && !c.isDefaultPrevented() && (!n._default || n._default.apply(f.ownerDocument, d) === !1) && (s !== "click" || !p.nodeName(f, "a")) && p.acceptData(f) && m && f[s] && (s !== "focus" && s !== "blur" || c.target.offsetWidth !== 0) && !p.isWindow(f) && (l = f[m], l && (f[m] = null), p.event.triggered = s, f[s](), p.event.triggered = b, l && (f[m] = l)), c.result
        }
        return
    }, dispatch: function (c) {
        c = p.event.fix(c || a.event);
        var d, e, f, g, h, i, j, l, m, n, o = (p._data(this, "events") || {})[c.type] || [], q = o.delegateCount, r = k.call(arguments), s = !c.exclusive && !c.namespace, t = p.event.special[c.type] || {}, u = [];
        r[0] = c, c.delegateTarget = this;
        if (t.preDispatch && t.preDispatch.call(this, c) === !1)return;
        if (q && (!c.button || c.type !== "click"))for (f = c.target; f != this; f = f.parentNode || this)if (f.disabled !== !0 || c.type !== "click") {
            h = {}, j = [];
            for (d = 0; d < q; d++)l = o[d], m = l.selector, h[m] === b && (h[m] = l.needsContext ? p(m, this).index(f) >= 0 : p.find(m, this, null, [f]).length), h[m] && j.push(l);
            j.length && u.push({elem: f, matches: j})
        }
        o.length > q && u.push({elem: this, matches: o.slice(q)});
        for (d = 0; d < u.length && !c.isPropagationStopped(); d++) {
            i = u[d], c.currentTarget = i.elem;
            for (e = 0; e < i.matches.length && !c.isImmediatePropagationStopped(); e++) {
                l = i.matches[e];
                if (s || !c.namespace && !l.namespace || c.namespace_re && c.namespace_re.test(l.namespace))c.data = l.data, c.handleObj = l, g = ((p.event.special[l.origType] || {}).handle || l.handler).apply(i.elem, r), g !== b && (c.result = g, g === !1 && (c.preventDefault(), c.stopPropagation()))
            }
        }
        return t.postDispatch && t.postDispatch.call(this, c), c.result
    }, props: "attrChange attrName relatedNode srcElement altKey bubbles cancelable ctrlKey currentTarget eventPhase metaKey relatedTarget shiftKey target timeStamp view which".split(" "), fixHooks: {}, keyHooks: {props: "char charCode key keyCode".split(" "), filter: function (a, b) {
        return a.which == null && (a.which = b.charCode != null ? b.charCode : b.keyCode), a
    }}, mouseHooks: {props: "button buttons clientX clientY fromElement offsetX offsetY pageX pageY screenX screenY toElement".split(" "), filter: function (a, c) {
        var d, f, g, h = c.button, i = c.fromElement;
        return a.pageX == null && c.clientX != null && (d = a.target.ownerDocument || e, f = d.documentElement, g = d.body, a.pageX = c.clientX + (f && f.scrollLeft || g && g.scrollLeft || 0) - (f && f.clientLeft || g && g.clientLeft || 0), a.pageY = c.clientY + (f && f.scrollTop || g && g.scrollTop || 0) - (f && f.clientTop || g && g.clientTop || 0)), !a.relatedTarget && i && (a.relatedTarget = i === a.target ? c.toElement : i), !a.which && h !== b && (a.which = h & 1 ? 1 : h & 2 ? 3 : h & 4 ? 2 : 0), a
    }}, fix: function (a) {
        if (a[p.expando])return a;
        var b, c, d = a, f = p.event.fixHooks[a.type] || {}, g = f.props ? this.props.concat(f.props) : this.props;
        a = p.Event(d);
        for (b = g.length; b;)c = g[--b], a[c] = d[c];
        return a.target || (a.target = d.srcElement || e), a.target.nodeType === 3 && (a.target = a.target.parentNode), a.metaKey = !!a.metaKey, f.filter ? f.filter(a, d) : a
    }, special: {load: {noBubble: !0}, focus: {delegateType: "focusin"}, blur: {delegateType: "focusout"}, beforeunload: {setup: function (a, b, c) {
        p.isWindow(this) && (this.onbeforeunload = c)
    }, teardown: function (a, b) {
        this.onbeforeunload === b && (this.onbeforeunload = null)
    }}}, simulate: function (a, b, c, d) {
        var e = p.extend(new p.Event, c, {type: a, isSimulated: !0, originalEvent: {}});
        d ? p.event.trigger(e, null, b) : p.event.dispatch.call(b, e), e.isDefaultPrevented() && c.preventDefault()
    }}, p.event.handle = p.event.dispatch, p.removeEvent = e.removeEventListener ? function (a, b, c) {
        a.removeEventListener && a.removeEventListener(b, c, !1)
    } : function (a, b, c) {
        var d = "on" + b;
        a.detachEvent && (typeof a[d] == "undefined" && (a[d] = null), a.detachEvent(d, c))
    }, p.Event = function (a, b) {
        if (!(this instanceof p.Event))return new p.Event(a, b);
        a && a.type ? (this.originalEvent = a, this.type = a.type, this.isDefaultPrevented = a.defaultPrevented || a.returnValue === !1 || a.getPreventDefault && a.getPreventDefault() ? bb : ba) : this.type = a, b && p.extend(this, b), this.timeStamp = a && a.timeStamp || p.now(), this[p.expando] = !0
    }, p.Event.prototype = {preventDefault: function () {
        this.isDefaultPrevented = bb;
        var a = this.originalEvent;
        if (!a)return;
        a.preventDefault ? a.preventDefault() : a.returnValue = !1
    }, stopPropagation: function () {
        this.isPropagationStopped = bb;
        var a = this.originalEvent;
        if (!a)return;
        a.stopPropagation && a.stopPropagation(), a.cancelBubble = !0
    }, stopImmediatePropagation: function () {
        this.isImmediatePropagationStopped = bb, this.stopPropagation()
    }, isDefaultPrevented: ba, isPropagationStopped: ba, isImmediatePropagationStopped: ba}, p.each({mouseenter: "mouseover", mouseleave: "mouseout"}, function (a, b) {
        p.event.special[a] = {delegateType: b, bindType: b, handle: function (a) {
            var c, d = this, e = a.relatedTarget, f = a.handleObj, g = f.selector;
            if (!e || e !== d && !p.contains(d, e))a.type = f.origType, c = f.handler.apply(this, arguments), a.type = b;
            return c
        }}
    }), p.support.submitBubbles || (p.event.special.submit = {setup: function () {
        if (p.nodeName(this, "form"))return!1;
        p.event.add(this, "click._submit keypress._submit", function (a) {
            var c = a.target, d = p.nodeName(c, "input") || p.nodeName(c, "button") ? c.form : b;
            d && !p._data(d, "_submit_attached") && (p.event.add(d, "submit._submit", function (a) {
                a._submit_bubble = !0
            }), p._data(d, "_submit_attached", !0))
        })
    }, postDispatch: function (a) {
        a._submit_bubble && (delete a._submit_bubble, this.parentNode && !a.isTrigger && p.event.simulate("submit", this.parentNode, a, !0))
    }, teardown: function () {
        if (p.nodeName(this, "form"))return!1;
        p.event.remove(this, "._submit")
    }}), p.support.changeBubbles || (p.event.special.change = {setup: function () {
        if (V.test(this.nodeName)) {
            if (this.type === "checkbox" || this.type === "radio")p.event.add(this, "propertychange._change", function (a) {
                a.originalEvent.propertyName === "checked" && (this._just_changed = !0)
            }), p.event.add(this, "click._change", function (a) {
                this._just_changed && !a.isTrigger && (this._just_changed = !1), p.event.simulate("change", this, a, !0)
            });
            return!1
        }
        p.event.add(this, "beforeactivate._change", function (a) {
            var b = a.target;
            V.test(b.nodeName) && !p._data(b, "_change_attached") && (p.event.add(b, "change._change", function (a) {
                this.parentNode && !a.isSimulated && !a.isTrigger && p.event.simulate("change", this.parentNode, a, !0)
            }), p._data(b, "_change_attached", !0))
        })
    }, handle: function (a) {
        var b = a.target;
        if (this !== b || a.isSimulated || a.isTrigger || b.type !== "radio" && b.type !== "checkbox")return a.handleObj.handler.apply(this, arguments)
    }, teardown: function () {
        return p.event.remove(this, "._change"), !V.test(this.nodeName)
    }}), p.support.focusinBubbles || p.each({focus: "focusin", blur: "focusout"}, function (a, b) {
        var c = 0, d = function (a) {
            p.event.simulate(b, a.target, p.event.fix(a), !0)
        };
        p.event.special[b] = {setup: function () {
            c++ === 0 && e.addEventListener(a, d, !0)
        }, teardown: function () {
            --c === 0 && e.removeEventListener(a, d, !0)
        }}
    }), p.fn.extend({on: function (a, c, d, e, f) {
        var g, h;
        if (typeof a == "object") {
            typeof c != "string" && (d = d || c, c = b);
            for (h in a)this.on(h, c, d, a[h], f);
            return this
        }
        d == null && e == null ? (e = c, d = c = b) : e == null && (typeof c == "string" ? (e = d, d = b) : (e = d, d = c, c = b));
        if (e === !1)e = ba; else if (!e)return this;
        return f === 1 && (g = e, e = function (a) {
            return p().off(a), g.apply(this, arguments)
        }, e.guid = g.guid || (g.guid = p.guid++)), this.each(function () {
            p.event.add(this, a, e, d, c)
        })
    }, one: function (a, b, c, d) {
        return this.on(a, b, c, d, 1)
    }, off: function (a, c, d) {
        var e, f;
        if (a && a.preventDefault && a.handleObj)return e = a.handleObj, p(a.delegateTarget).off(e.namespace ? e.origType + "." + e.namespace : e.origType, e.selector, e.handler), this;
        if (typeof a == "object") {
            for (f in a)this.off(f, c, a[f]);
            return this
        }
        if (c === !1 || typeof c == "function")d = c, c = b;
        return d === !1 && (d = ba), this.each(function () {
            p.event.remove(this, a, d, c)
        })
    }, bind: function (a, b, c) {
        return this.on(a, null, b, c)
    }, unbind: function (a, b) {
        return this.off(a, null, b)
    }, live: function (a, b, c) {
        return p(this.context).on(a, this.selector, b, c), this
    }, die: function (a, b) {
        return p(this.context).off(a, this.selector || "**", b), this
    }, delegate: function (a, b, c, d) {
        return this.on(b, a, c, d)
    }, undelegate: function (a, b, c) {
        return arguments.length === 1 ? this.off(a, "**") : this.off(b, a || "**", c)
    }, trigger: function (a, b) {
        return this.each(function () {
            p.event.trigger(a, b, this)
        })
    }, triggerHandler: function (a, b) {
        if (this[0])return p.event.trigger(a, b, this[0], !0)
    }, toggle: function (a) {
        var b = arguments, c = a.guid || p.guid++, d = 0, e = function (c) {
            var e = (p._data(this, "lastToggle" + a.guid) || 0) % d;
            return p._data(this, "lastToggle" + a.guid, e + 1), c.preventDefault(), b[e].apply(this, arguments) || !1
        };
        e.guid = c;
        while (d < b.length)b[d++].guid = c;
        return this.click(e)
    }, hover: function (a, b) {
        return this.mouseenter(a).mouseleave(b || a)
    }}), p.each("blur focus focusin focusout load resize scroll unload click dblclick mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave change select submit keydown keypress keyup error contextmenu".split(" "), function (a, b) {
        p.fn[b] = function (a, c) {
            return c == null && (c = a, a = null), arguments.length > 0 ? this.on(b, null, a, c) : this.trigger(b)
        }, Y.test(b) && (p.event.fixHooks[b] = p.event.keyHooks), Z.test(b) && (p.event.fixHooks[b] = p.event.mouseHooks)
    }), function (a, b) {
        function bc(a, b, c, d) {
            c = c || [], b = b || r;
            var e, f, i, j, k = b.nodeType;
            if (!a || typeof a != "string")return c;
            if (k !== 1 && k !== 9)return[];
            i = g(b);
            if (!i && !d)if (e = P.exec(a))if (j = e[1]) {
                if (k === 9) {
                    f = b.getElementById(j);
                    if (!f || !f.parentNode)return c;
                    if (f.id === j)return c.push(f), c
                } else if (b.ownerDocument && (f = b.ownerDocument.getElementById(j)) && h(b, f) && f.id === j)return c.push(f), c
            } else {
                if (e[2])return w.apply(c, x.call(b.getElementsByTagName(a), 0)), c;
                if ((j = e[3]) && _ && b.getElementsByClassName)return w.apply(c, x.call(b.getElementsByClassName(j), 0)), c
            }
            return bp(a.replace(L, "$1"), b, c, d, i)
        }

        function bd(a) {
            return function (b) {
                var c = b.nodeName.toLowerCase();
                return c === "input" && b.type === a
            }
        }

        function be(a) {
            return function (b) {
                var c = b.nodeName.toLowerCase();
                return(c === "input" || c === "button") && b.type === a
            }
        }

        function bf(a) {
            return z(function (b) {
                return b = +b, z(function (c, d) {
                    var e, f = a([], c.length, b), g = f.length;
                    while (g--)c[e = f[g]] && (c[e] = !(d[e] = c[e]))
                })
            })
        }

        function bg(a, b, c) {
            if (a === b)return c;
            var d = a.nextSibling;
            while (d) {
                if (d === b)return-1;
                d = d.nextSibling
            }
            return 1
        }

        function bh(a, b) {
            var c, d, f, g, h, i, j, k = C[o][a + " "];
            if (k)return b ? 0 : k.slice(0);
            h = a, i = [], j = e.preFilter;
            while (h) {
                if (!c || (d = M.exec(h)))d && (h = h.slice(d[0].length) || h), i.push(f = []);
                c = !1;
                if (d = N.exec(h))f.push(c = new q(d.shift())), h = h.slice(c.length), c.type = d[0].replace(L, " ");
                for (g in e.filter)(d = W[g].exec(h)) && (!j[g] || (d = j[g](d))) && (f.push(c = new q(d.shift())), h = h.slice(c.length), c.type = g, c.matches = d);
                if (!c)break
            }
            return b ? h.length : h ? bc.error(a) : C(a, i).slice(0)
        }

        function bi(a, b, d) {
            var e = b.dir, f = d && b.dir === "parentNode", g = u++;
            return b.first ? function (b, c, d) {
                while (b = b[e])if (f || b.nodeType === 1)return a(b, c, d)
            } : function (b, d, h) {
                if (!h) {
                    var i, j = t + " " + g + " ", k = j + c;
                    while (b = b[e])if (f || b.nodeType === 1) {
                        if ((i = b[o]) === k)return b.sizset;
                        if (typeof i == "string" && i.indexOf(j) === 0) {
                            if (b.sizset)return b
                        } else {
                            b[o] = k;
                            if (a(b, d, h))return b.sizset = !0, b;
                            b.sizset = !1
                        }
                    }
                } else while (b = b[e])if (f || b.nodeType === 1)if (a(b, d, h))return b
            }
        }

        function bj(a) {
            return a.length > 1 ? function (b, c, d) {
                var e = a.length;
                while (e--)if (!a[e](b, c, d))return!1;
                return!0
            } : a[0]
        }

        function bk(a, b, c, d, e) {
            var f, g = [], h = 0, i = a.length, j = b != null;
            for (; h < i; h++)if (f = a[h])if (!c || c(f, d, e))g.push(f), j && b.push(h);
            return g
        }

        function bl(a, b, c, d, e, f) {
            return d && !d[o] && (d = bl(d)), e && !e[o] && (e = bl(e, f)), z(function (f, g, h, i) {
                var j, k, l, m = [], n = [], o = g.length, p = f || bo(b || "*", h.nodeType ? [h] : h, []), q = a && (f || !b) ? bk(p, m, a, h, i) : p, r = c ? e || (f ? a : o || d) ? [] : g : q;
                c && c(q, r, h, i);
                if (d) {
                    j = bk(r, n), d(j, [], h, i), k = j.length;
                    while (k--)if (l = j[k])r[n[k]] = !(q[n[k]] = l)
                }
                if (f) {
                    if (e || a) {
                        if (e) {
                            j = [], k = r.length;
                            while (k--)(l = r[k]) && j.push(q[k] = l);
                            e(null, r = [], j, i)
                        }
                        k = r.length;
                        while (k--)(l = r[k]) && (j = e ? y.call(f, l) : m[k]) > -1 && (f[j] = !(g[j] = l))
                    }
                } else r = bk(r === g ? r.splice(o, r.length) : r), e ? e(null, g, r, i) : w.apply(g, r)
            })
        }

        function bm(a) {
            var b, c, d, f = a.length, g = e.relative[a[0].type], h = g || e.relative[" "], i = g ? 1 : 0, j = bi(function (a) {
                return a === b
            }, h, !0), k = bi(function (a) {
                return y.call(b, a) > -1
            }, h, !0), m = [function (a, c, d) {
                return!g && (d || c !== l) || ((b = c).nodeType ? j(a, c, d) : k(a, c, d))
            }];
            for (; i < f; i++)if (c = e.relative[a[i].type])m = [bi(bj(m), c)]; else {
                c = e.filter[a[i].type].apply(null, a[i].matches);
                if (c[o]) {
                    d = ++i;
                    for (; d < f; d++)if (e.relative[a[d].type])break;
                    return bl(i > 1 && bj(m), i > 1 && a.slice(0, i - 1).join("").replace(L, "$1"), c, i < d && bm(a.slice(i, d)), d < f && bm(a = a.slice(d)), d < f && a.join(""))
                }
                m.push(c)
            }
            return bj(m)
        }

        function bn(a, b) {
            var d = b.length > 0, f = a.length > 0, g = function (h, i, j, k, m) {
                var n, o, p, q = [], s = 0, u = "0", x = h && [], y = m != null, z = l, A = h || f && e.find.TAG("*", m && i.parentNode || i), B = t += z == null ? 1 : Math.E;
                y && (l = i !== r && i, c = g.el);
                for (; (n = A[u]) != null; u++) {
                    if (f && n) {
                        for (o = 0; p = a[o]; o++)if (p(n, i, j)) {
                            k.push(n);
                            break
                        }
                        y && (t = B, c = ++g.el)
                    }
                    d && ((n = !p && n) && s--, h && x.push(n))
                }
                s += u;
                if (d && u !== s) {
                    for (o = 0; p = b[o]; o++)p(x, q, i, j);
                    if (h) {
                        if (s > 0)while (u--)!x[u] && !q[u] && (q[u] = v.call(k));
                        q = bk(q)
                    }
                    w.apply(k, q), y && !h && q.length > 0 && s + b.length > 1 && bc.uniqueSort(k)
                }
                return y && (t = B, l = z), x
            };
            return g.el = 0, d ? z(g) : g
        }

        function bo(a, b, c) {
            var d = 0, e = b.length;
            for (; d < e; d++)bc(a, b[d], c);
            return c
        }

        function bp(a, b, c, d, f) {
            var g, h, j, k, l, m = bh(a), n = m.length;
            if (!d && m.length === 1) {
                h = m[0] = m[0].slice(0);
                if (h.length > 2 && (j = h[0]).type === "ID" && b.nodeType === 9 && !f && e.relative[h[1].type]) {
                    b = e.find.ID(j.matches[0].replace(V, ""), b, f)[0];
                    if (!b)return c;
                    a = a.slice(h.shift().length)
                }
                for (g = W.POS.test(a) ? -1 : h.length - 1; g >= 0; g--) {
                    j = h[g];
                    if (e.relative[k = j.type])break;
                    if (l = e.find[k])if (d = l(j.matches[0].replace(V, ""), R.test(h[0].type) && b.parentNode || b, f)) {
                        h.splice(g, 1), a = d.length && h.join("");
                        if (!a)return w.apply(c, x.call(d, 0)), c;
                        break
                    }
                }
            }
            return i(a, m)(d, b, f, c, R.test(a)), c
        }

        function bq() {
        }

        var c, d, e, f, g, h, i, j, k, l, m = !0, n = "undefined", o = ("sizcache" + Math.random()).replace(".", ""), q = String, r = a.document, s = r.documentElement, t = 0, u = 0, v = [].pop, w = [].push, x = [].slice, y = [].indexOf || function (a) {
            var b = 0, c = this.length;
            for (; b < c; b++)if (this[b] === a)return b;
            return-1
        }, z = function (a, b) {
            return a[o] = b == null || b, a
        }, A = function () {
            var a = {}, b = [];
            return z(function (c, d) {
                return b.push(c) > e.cacheLength && delete a[b.shift()], a[c + " "] = d
            }, a)
        }, B = A(), C = A(), D = A(), E = "[\\x20\\t\\r\\n\\f]", F = "(?:\\\\.|[-\\w]|[^\\x00-\\xa0])+", G = F.replace("w", "w#"), H = "([*^$|!~]?=)", I = "\\[" + E + "*(" + F + ")" + E + "*(?:" + H + E + "*(?:(['\"])((?:\\\\.|[^\\\\])*?)\\3|(" + G + ")|)|)" + E + "*\\]", J = ":(" + F + ")(?:\\((?:(['\"])((?:\\\\.|[^\\\\])*?)\\2|([^()[\\]]*|(?:(?:" + I + ")|[^:]|\\\\.)*|.*))\\)|)", K = ":(even|odd|eq|gt|lt|nth|first|last)(?:\\(" + E + "*((?:-\\d)?\\d*)" + E + "*\\)|)(?=[^-]|$)", L = new RegExp("^" + E + "+|((?:^|[^\\\\])(?:\\\\.)*)" + E + "+$", "g"), M = new RegExp("^" + E + "*," + E + "*"), N = new RegExp("^" + E + "*([\\x20\\t\\r\\n\\f>+~])" + E + "*"), O = new RegExp(J), P = /^(?:#([\w\-]+)|(\w+)|\.([\w\-]+))$/, Q = /^:not/, R = /[\x20\t\r\n\f]*[+~]/, S = /:not\($/, T = /h\d/i, U = /input|select|textarea|button/i, V = /\\(?!\\)/g, W = {ID: new RegExp("^#(" + F + ")"), CLASS: new RegExp("^\\.(" + F + ")"), NAME: new RegExp("^\\[name=['\"]?(" + F + ")['\"]?\\]"), TAG: new RegExp("^(" + F.replace("w", "w*") + ")"), ATTR: new RegExp("^" + I), PSEUDO: new RegExp("^" + J), POS: new RegExp(K, "i"), CHILD: new RegExp("^:(only|nth|first|last)-child(?:\\(" + E + "*(even|odd|(([+-]|)(\\d*)n|)" + E + "*(?:([+-]|)" + E + "*(\\d+)|))" + E + "*\\)|)", "i"), needsContext: new RegExp("^" + E + "*[>+~]|" + K, "i")}, X = function (a) {
            var b = r.createElement("div");
            try {
                return a(b)
            } catch (c) {
                return!1
            } finally {
                b = null
            }
        }, Y = X(function (a) {
            return a.appendChild(r.createComment("")), !a.getElementsByTagName("*").length
        }), Z = X(function (a) {
            return a.innerHTML = "<a href='#'></a>", a.firstChild && typeof a.firstChild.getAttribute !== n && a.firstChild.getAttribute("href") === "#"
        }), $ = X(function (a) {
            a.innerHTML = "<select></select>";
            var b = typeof a.lastChild.getAttribute("multiple");
            return b !== "boolean" && b !== "string"
        }), _ = X(function (a) {
            return a.innerHTML = "<div class='hidden e'></div><div class='hidden'></div>", !a.getElementsByClassName || !a.getElementsByClassName("e").length ? !1 : (a.lastChild.className = "e", a.getElementsByClassName("e").length === 2)
        }), ba = X(function (a) {
            a.id = o + 0, a.innerHTML = "<a name='" + o + "'></a><div name='" + o + "'></div>", s.insertBefore(a, s.firstChild);
            var b = r.getElementsByName && r.getElementsByName(o).length === 2 + r.getElementsByName(o + 0).length;
            return d = !r.getElementById(o), s.removeChild(a), b
        });
        try {
            x.call(s.childNodes, 0)[0].nodeType
        } catch (bb) {
            x = function (a) {
                var b, c = [];
                for (; b = this[a]; a++)c.push(b);
                return c
            }
        }
        bc.matches = function (a, b) {
            return bc(a, null, null, b)
        }, bc.matchesSelector = function (a, b) {
            return bc(b, null, null, [a]).length > 0
        }, f = bc.getText = function (a) {
            var b, c = "", d = 0, e = a.nodeType;
            if (e) {
                if (e === 1 || e === 9 || e === 11) {
                    if (typeof a.textContent == "string")return a.textContent;
                    for (a = a.firstChild; a; a = a.nextSibling)c += f(a)
                } else if (e === 3 || e === 4)return a.nodeValue
            } else for (; b = a[d]; d++)c += f(b);
            return c
        }, g = bc.isXML = function (a) {
            var b = a && (a.ownerDocument || a).documentElement;
            return b ? b.nodeName !== "HTML" : !1
        }, h = bc.contains = s.contains ? function (a, b) {
            var c = a.nodeType === 9 ? a.documentElement : a, d = b && b.parentNode;
            return a === d || !!(d && d.nodeType === 1 && c.contains && c.contains(d))
        } : s.compareDocumentPosition ? function (a, b) {
            return b && !!(a.compareDocumentPosition(b) & 16)
        } : function (a, b) {
            while (b = b.parentNode)if (b === a)return!0;
            return!1
        }, bc.attr = function (a, b) {
            var c, d = g(a);
            return d || (b = b.toLowerCase()), (c = e.attrHandle[b]) ? c(a) : d || $ ? a.getAttribute(b) : (c = a.getAttributeNode(b), c ? typeof a[b] == "boolean" ? a[b] ? b : null : c.specified ? c.value : null : null)
        }, e = bc.selectors = {cacheLength: 50, createPseudo: z, match: W, attrHandle: Z ? {} : {href: function (a) {
            return a.getAttribute("href", 2)
        }, type: function (a) {
            return a.getAttribute("type")
        }}, find: {ID: d ? function (a, b, c) {
            if (typeof b.getElementById !== n && !c) {
                var d = b.getElementById(a);
                return d && d.parentNode ? [d] : []
            }
        } : function (a, c, d) {
            if (typeof c.getElementById !== n && !d) {
                var e = c.getElementById(a);
                return e ? e.id === a || typeof e.getAttributeNode !== n && e.getAttributeNode("id").value === a ? [e] : b : []
            }
        }, TAG: Y ? function (a, b) {
            if (typeof b.getElementsByTagName !== n)return b.getElementsByTagName(a)
        } : function (a, b) {
            var c = b.getElementsByTagName(a);
            if (a === "*") {
                var d, e = [], f = 0;
                for (; d = c[f]; f++)d.nodeType === 1 && e.push(d);
                return e
            }
            return c
        }, NAME: ba && function (a, b) {
            if (typeof b.getElementsByName !== n)return b.getElementsByName(name)
        }, CLASS: _ && function (a, b, c) {
            if (typeof b.getElementsByClassName !== n && !c)return b.getElementsByClassName(a)
        }}, relative: {">": {dir: "parentNode", first: !0}, " ": {dir: "parentNode"}, "+": {dir: "previousSibling", first: !0}, "~": {dir: "previousSibling"}}, preFilter: {ATTR: function (a) {
            return a[1] = a[1].replace(V, ""), a[3] = (a[4] || a[5] || "").replace(V, ""), a[2] === "~=" && (a[3] = " " + a[3] + " "), a.slice(0, 4)
        }, CHILD: function (a) {
            return a[1] = a[1].toLowerCase(), a[1] === "nth" ? (a[2] || bc.error(a[0]), a[3] = +(a[3] ? a[4] + (a[5] || 1) : 2 * (a[2] === "even" || a[2] === "odd")), a[4] = +(a[6] + a[7] || a[2] === "odd")) : a[2] && bc.error(a[0]), a
        }, PSEUDO: function (a) {
            var b, c;
            if (W.CHILD.test(a[0]))return null;
            if (a[3])a[2] = a[3]; else if (b = a[4])O.test(b) && (c = bh(b, !0)) && (c = b.indexOf(")", b.length - c) - b.length) && (b = b.slice(0, c), a[0] = a[0].slice(0, c)), a[2] = b;
            return a.slice(0, 3)
        }}, filter: {ID: d ? function (a) {
            return a = a.replace(V, ""), function (b) {
                return b.getAttribute("id") === a
            }
        } : function (a) {
            return a = a.replace(V, ""), function (b) {
                var c = typeof b.getAttributeNode !== n && b.getAttributeNode("id");
                return c && c.value === a
            }
        }, TAG: function (a) {
            return a === "*" ? function () {
                return!0
            } : (a = a.replace(V, "").toLowerCase(), function (b) {
                return b.nodeName && b.nodeName.toLowerCase() === a
            })
        }, CLASS: function (a) {
            var b = B[o][a + " "];
            return b || (b = new RegExp("(^|" + E + ")" + a + "(" + E + "|$)")) && B(a, function (a) {
                return b.test(a.className || typeof a.getAttribute !== n && a.getAttribute("class") || "")
            })
        }, ATTR: function (a, b, c) {
            return function (d, e) {
                var f = bc.attr(d, a);
                return f == null ? b === "!=" : b ? (f += "", b === "=" ? f === c : b === "!=" ? f !== c : b === "^=" ? c && f.indexOf(c) === 0 : b === "*=" ? c && f.indexOf(c) > -1 : b === "$=" ? c && f.substr(f.length - c.length) === c : b === "~=" ? (" " + f + " ").indexOf(c) > -1 : b === "|=" ? f === c || f.substr(0, c.length + 1) === c + "-" : !1) : !0
            }
        }, CHILD: function (a, b, c, d) {
            return a === "nth" ? function (a) {
                var b, e, f = a.parentNode;
                if (c === 1 && d === 0)return!0;
                if (f) {
                    e = 0;
                    for (b = f.firstChild; b; b = b.nextSibling)if (b.nodeType === 1) {
                        e++;
                        if (a === b)break
                    }
                }
                return e -= d, e === c || e % c === 0 && e / c >= 0
            } : function (b) {
                var c = b;
                switch (a) {
                    case"only":
                    case"first":
                        while (c = c.previousSibling)if (c.nodeType === 1)return!1;
                        if (a === "first")return!0;
                        c = b;
                    case"last":
                        while (c = c.nextSibling)if (c.nodeType === 1)return!1;
                        return!0
                }
            }
        }, PSEUDO: function (a, b) {
            var c, d = e.pseudos[a] || e.setFilters[a.toLowerCase()] || bc.error("unsupported pseudo: " + a);
            return d[o] ? d(b) : d.length > 1 ? (c = [a, a, "", b], e.setFilters.hasOwnProperty(a.toLowerCase()) ? z(function (a, c) {
                var e, f = d(a, b), g = f.length;
                while (g--)e = y.call(a, f[g]), a[e] = !(c[e] = f[g])
            }) : function (a) {
                return d(a, 0, c)
            }) : d
        }}, pseudos: {not: z(function (a) {
            var b = [], c = [], d = i(a.replace(L, "$1"));
            return d[o] ? z(function (a, b, c, e) {
                var f, g = d(a, null, e, []), h = a.length;
                while (h--)if (f = g[h])a[h] = !(b[h] = f)
            }) : function (a, e, f) {
                return b[0] = a, d(b, null, f, c), !c.pop()
            }
        }), has: z(function (a) {
            return function (b) {
                return bc(a, b).length > 0
            }
        }), contains: z(function (a) {
            return function (b) {
                return(b.textContent || b.innerText || f(b)).indexOf(a) > -1
            }
        }), enabled: function (a) {
            return a.disabled === !1
        }, disabled: function (a) {
            return a.disabled === !0
        }, checked: function (a) {
            var b = a.nodeName.toLowerCase();
            return b === "input" && !!a.checked || b === "option" && !!a.selected
        }, selected: function (a) {
            return a.parentNode && a.parentNode.selectedIndex, a.selected === !0
        }, parent: function (a) {
            return!e.pseudos.empty(a)
        }, empty: function (a) {
            var b;
            a = a.firstChild;
            while (a) {
                if (a.nodeName > "@" || (b = a.nodeType) === 3 || b === 4)return!1;
                a = a.nextSibling
            }
            return!0
        }, header: function (a) {
            return T.test(a.nodeName)
        }, text: function (a) {
            var b, c;
            return a.nodeName.toLowerCase() === "input" && (b = a.type) === "text" && ((c = a.getAttribute("type")) == null || c.toLowerCase() === b)
        }, radio: bd("radio"), checkbox: bd("checkbox"), file: bd("file"), password: bd("password"), image: bd("image"), submit: be("submit"), reset: be("reset"), button: function (a) {
            var b = a.nodeName.toLowerCase();
            return b === "input" && a.type === "button" || b === "button"
        }, input: function (a) {
            return U.test(a.nodeName)
        }, focus: function (a) {
            var b = a.ownerDocument;
            return a === b.activeElement && (!b.hasFocus || b.hasFocus()) && !!(a.type || a.href || ~a.tabIndex)
        }, active: function (a) {
            return a === a.ownerDocument.activeElement
        }, first: bf(function () {
            return[0]
        }), last: bf(function (a, b) {
            return[b - 1]
        }), eq: bf(function (a, b, c) {
            return[c < 0 ? c + b : c]
        }), even: bf(function (a, b) {
            for (var c = 0; c < b; c += 2)a.push(c);
            return a
        }), odd: bf(function (a, b) {
            for (var c = 1; c < b; c += 2)a.push(c);
            return a
        }), lt: bf(function (a, b, c) {
            for (var d = c < 0 ? c + b : c; --d >= 0;)a.push(d);
            return a
        }), gt: bf(function (a, b, c) {
            for (var d = c < 0 ? c + b : c; ++d < b;)a.push(d);
            return a
        })}}, j = s.compareDocumentPosition ? function (a, b) {
            return a === b ? (k = !0, 0) : (!a.compareDocumentPosition || !b.compareDocumentPosition ? a.compareDocumentPosition : a.compareDocumentPosition(b) & 4) ? -1 : 1
        } : function (a, b) {
            if (a === b)return k = !0, 0;
            if (a.sourceIndex && b.sourceIndex)return a.sourceIndex - b.sourceIndex;
            var c, d, e = [], f = [], g = a.parentNode, h = b.parentNode, i = g;
            if (g === h)return bg(a, b);
            if (!g)return-1;
            if (!h)return 1;
            while (i)e.unshift(i), i = i.parentNode;
            i = h;
            while (i)f.unshift(i), i = i.parentNode;
            c = e.length, d = f.length;
            for (var j = 0; j < c && j < d; j++)if (e[j] !== f[j])return bg(e[j], f[j]);
            return j === c ? bg(a, f[j], -1) : bg(e[j], b, 1)
        }, [0, 0].sort(j), m = !k, bc.uniqueSort = function (a) {
            var b, c = [], d = 1, e = 0;
            k = m, a.sort(j);
            if (k) {
                for (; b = a[d]; d++)b === a[d - 1] && (e = c.push(d));
                while (e--)a.splice(c[e], 1)
            }
            return a
        }, bc.error = function (a) {
            throw new Error("Syntax error, unrecognized expression: " + a)
        }, i = bc.compile = function (a, b) {
            var c, d = [], e = [], f = D[o][a + " "];
            if (!f) {
                b || (b = bh(a)), c = b.length;
                while (c--)f = bm(b[c]), f[o] ? d.push(f) : e.push(f);
                f = D(a, bn(e, d))
            }
            return f
        }, r.querySelectorAll && function () {
            var a, b = bp, c = /'|\\/g, d = /\=[\x20\t\r\n\f]*([^'"\]]*)[\x20\t\r\n\f]*\]/g, e = [":focus"], f = [":active"], h = s.matchesSelector || s.mozMatchesSelector || s.webkitMatchesSelector || s.oMatchesSelector || s.msMatchesSelector;
            X(function (a) {
                a.innerHTML = "<select><option selected=''></option></select>", a.querySelectorAll("[selected]").length || e.push("\\[" + E + "*(?:checked|disabled|ismap|multiple|readonly|selected|value)"), a.querySelectorAll(":checked").length || e.push(":checked")
            }), X(function (a) {
                a.innerHTML = "<p test=''></p>", a.querySelectorAll("[test^='']").length && e.push("[*^$]=" + E + "*(?:\"\"|'')"), a.innerHTML = "<input type='hidden'/>", a.querySelectorAll(":enabled").length || e.push(":enabled", ":disabled")
            }), e = new RegExp(e.join("|")), bp = function (a, d, f, g, h) {
                if (!g && !h && !e.test(a)) {
                    var i, j, k = !0, l = o, m = d, n = d.nodeType === 9 && a;
                    if (d.nodeType === 1 && d.nodeName.toLowerCase() !== "object") {
                        i = bh(a), (k = d.getAttribute("id")) ? l = k.replace(c, "\\$&") : d.setAttribute("id", l), l = "[id='" + l + "'] ", j = i.length;
                        while (j--)i[j] = l + i[j].join("");
                        m = R.test(a) && d.parentNode || d, n = i.join(",")
                    }
                    if (n)try {
                        return w.apply(f, x.call(m.querySelectorAll(n), 0)), f
                    } catch (p) {
                    } finally {
                        k || d.removeAttribute("id")
                    }
                }
                return b(a, d, f, g, h)
            }, h && (X(function (b) {
                a = h.call(b, "div");
                try {
                    h.call(b, "[test!='']:sizzle"), f.push("!=", J)
                } catch (c) {
                }
            }), f = new RegExp(f.join("|")), bc.matchesSelector = function (b, c) {
                c = c.replace(d, "='$1']");
                if (!g(b) && !f.test(c) && !e.test(c))try {
                    var i = h.call(b, c);
                    if (i || a || b.document && b.document.nodeType !== 11)return i
                } catch (j) {
                }
                return bc(c, null, null, [b]).length > 0
            })
        }(), e.pseudos.nth = e.pseudos.eq, e.filters = bq.prototype = e.pseudos, e.setFilters = new bq, bc.attr = p.attr, p.find = bc, p.expr = bc.selectors, p.expr[":"] = p.expr.pseudos, p.unique = bc.uniqueSort, p.text = bc.getText, p.isXMLDoc = bc.isXML, p.contains = bc.contains
    }(a);
    var bc = /Until$/, bd = /^(?:parents|prev(?:Until|All))/, be = /^.[^:#\[\.,]*$/, bf = p.expr.match.needsContext, bg = {children: !0, contents: !0, next: !0, prev: !0};
    p.fn.extend({find: function (a) {
        var b, c, d, e, f, g, h = this;
        if (typeof a != "string")return p(a).filter(function () {
            for (b = 0, c = h.length; b < c; b++)if (p.contains(h[b], this))return!0
        });
        g = this.pushStack("", "find", a);
        for (b = 0, c = this.length; b < c; b++) {
            d = g.length, p.find(a, this[b], g);
            if (b > 0)for (e = d; e < g.length; e++)for (f = 0; f < d; f++)if (g[f] === g[e]) {
                g.splice(e--, 1);
                break
            }
        }
        return g
    }, has: function (a) {
        var b, c = p(a, this), d = c.length;
        return this.filter(function () {
            for (b = 0; b < d; b++)if (p.contains(this, c[b]))return!0
        })
    }, not: function (a) {
        return this.pushStack(bj(this, a, !1), "not", a)
    }, filter: function (a) {
        return this.pushStack(bj(this, a, !0), "filter", a)
    }, is: function (a) {
        return!!a && (typeof a == "string" ? bf.test(a) ? p(a, this.context).index(this[0]) >= 0 : p.filter(a, this).length > 0 : this.filter(a).length > 0)
    }, closest: function (a, b) {
        var c, d = 0, e = this.length, f = [], g = bf.test(a) || typeof a != "string" ? p(a, b || this.context) : 0;
        for (; d < e; d++) {
            c = this[d];
            while (c && c.ownerDocument && c !== b && c.nodeType !== 11) {
                if (g ? g.index(c) > -1 : p.find.matchesSelector(c, a)) {
                    f.push(c);
                    break
                }
                c = c.parentNode
            }
        }
        return f = f.length > 1 ? p.unique(f) : f, this.pushStack(f, "closest", a)
    }, index: function (a) {
        return a ? typeof a == "string" ? p.inArray(this[0], p(a)) : p.inArray(a.jquery ? a[0] : a, this) : this[0] && this[0].parentNode ? this.prevAll().length : -1
    }, add: function (a, b) {
        var c = typeof a == "string" ? p(a, b) : p.makeArray(a && a.nodeType ? [a] : a), d = p.merge(this.get(), c);
        return this.pushStack(bh(c[0]) || bh(d[0]) ? d : p.unique(d))
    }, addBack: function (a) {
        return this.add(a == null ? this.prevObject : this.prevObject.filter(a))
    }}), p.fn.andSelf = p.fn.addBack, p.each({parent: function (a) {
        var b = a.parentNode;
        return b && b.nodeType !== 11 ? b : null
    }, parents: function (a) {
        return p.dir(a, "parentNode")
    }, parentsUntil: function (a, b, c) {
        return p.dir(a, "parentNode", c)
    }, next: function (a) {
        return bi(a, "nextSibling")
    }, prev: function (a) {
        return bi(a, "previousSibling")
    }, nextAll: function (a) {
        return p.dir(a, "nextSibling")
    }, prevAll: function (a) {
        return p.dir(a, "previousSibling")
    }, nextUntil: function (a, b, c) {
        return p.dir(a, "nextSibling", c)
    }, prevUntil: function (a, b, c) {
        return p.dir(a, "previousSibling", c)
    }, siblings: function (a) {
        return p.sibling((a.parentNode || {}).firstChild, a)
    }, children: function (a) {
        return p.sibling(a.firstChild)
    }, contents: function (a) {
        return p.nodeName(a, "iframe") ? a.contentDocument || a.contentWindow.document : p.merge([], a.childNodes)
    }}, function (a, b) {
        p.fn[a] = function (c, d) {
            var e = p.map(this, b, c);
            return bc.test(a) || (d = c), d && typeof d == "string" && (e = p.filter(d, e)), e = this.length > 1 && !bg[a] ? p.unique(e) : e, this.length > 1 && bd.test(a) && (e = e.reverse()), this.pushStack(e, a, k.call(arguments).join(","))
        }
    }), p.extend({filter: function (a, b, c) {
        return c && (a = ":not(" + a + ")"), b.length === 1 ? p.find.matchesSelector(b[0], a) ? [b[0]] : [] : p.find.matches(a, b)
    }, dir: function (a, c, d) {
        var e = [], f = a[c];
        while (f && f.nodeType !== 9 && (d === b || f.nodeType !== 1 || !p(f).is(d)))f.nodeType === 1 && e.push(f), f = f[c];
        return e
    }, sibling: function (a, b) {
        var c = [];
        for (; a; a = a.nextSibling)a.nodeType === 1 && a !== b && c.push(a);
        return c
    }});
    var bl = "abbr|article|aside|audio|bdi|canvas|data|datalist|details|figcaption|figure|footer|header|hgroup|mark|meter|nav|output|progress|section|summary|time|video", bm = / jQuery\d+="(?:null|\d+)"/g, bn = /^\s+/, bo = /<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/gi, bp = /<([\w:]+)/, bq = /<tbody/i, br = /<|&#?\w+;/, bs = /<(?:script|style|link)/i, bt = /<(?:script|object|embed|option|style)/i, bu = new RegExp("<(?:" + bl + ")[\\s/>]", "i"), bv = /^(?:checkbox|radio)$/, bw = /checked\s*(?:[^=]|=\s*.checked.)/i, bx = /\/(java|ecma)script/i, by = /^\s*<!(?:\[CDATA\[|\-\-)|[\]\-]{2}>\s*$/g, bz = {option: [1, "<select multiple='multiple'>", "</select>"], legend: [1, "<fieldset>", "</fieldset>"], thead: [1, "<table>", "</table>"], tr: [2, "<table><tbody>", "</tbody></table>"], td: [3, "<table><tbody><tr>", "</tr></tbody></table>"], col: [2, "<table><tbody></tbody><colgroup>", "</colgroup></table>"], area: [1, "<map>"
        , "</map>"], _default: [0, "", ""]}, bA = bk(e), bB = bA.appendChild(e.createElement("div"));
    bz.optgroup = bz.option, bz.tbody = bz.tfoot = bz.colgroup = bz.caption = bz.thead, bz.th = bz.td, p.support.htmlSerialize || (bz._default = [1, "X<div>", "</div>"]), p.fn.extend({text: function (a) {
        return p.access(this, function (a) {
            return a === b ? p.text(this) : this.empty().append((this[0] && this[0].ownerDocument || e).createTextNode(a))
        }, null, a, arguments.length)
    }, wrapAll: function (a) {
        if (p.isFunction(a))return this.each(function (b) {
            p(this).wrapAll(a.call(this, b))
        });
        if (this[0]) {
            var b = p(a, this[0].ownerDocument).eq(0).clone(!0);
            this[0].parentNode && b.insertBefore(this[0]), b.map(function () {
                var a = this;
                while (a.firstChild && a.firstChild.nodeType === 1)a = a.firstChild;
                return a
            }).append(this)
        }
        return this
    }, wrapInner: function (a) {
        return p.isFunction(a) ? this.each(function (b) {
            p(this).wrapInner(a.call(this, b))
        }) : this.each(function () {
            var b = p(this), c = b.contents();
            c.length ? c.wrapAll(a) : b.append(a)
        })
    }, wrap: function (a) {
        var b = p.isFunction(a);
        return this.each(function (c) {
            p(this).wrapAll(b ? a.call(this, c) : a)
        })
    }, unwrap: function () {
        return this.parent().each(function () {
            p.nodeName(this, "body") || p(this).replaceWith(this.childNodes)
        }).end()
    }, append: function () {
        return this.domManip(arguments, !0, function (a) {
            (this.nodeType === 1 || this.nodeType === 11) && this.appendChild(a)
        })
    }, prepend: function () {
        return this.domManip(arguments, !0, function (a) {
            (this.nodeType === 1 || this.nodeType === 11) && this.insertBefore(a, this.firstChild)
        })
    }, before: function () {
        if (!bh(this[0]))return this.domManip(arguments, !1, function (a) {
            this.parentNode.insertBefore(a, this)
        });
        if (arguments.length) {
            var a = p.clean(arguments);
            return this.pushStack(p.merge(a, this), "before", this.selector)
        }
    }, after: function () {
        if (!bh(this[0]))return this.domManip(arguments, !1, function (a) {
            this.parentNode.insertBefore(a, this.nextSibling)
        });
        if (arguments.length) {
            var a = p.clean(arguments);
            return this.pushStack(p.merge(this, a), "after", this.selector)
        }
    }, remove: function (a, b) {
        var c, d = 0;
        for (; (c = this[d]) != null; d++)if (!a || p.filter(a, [c]).length)!b && c.nodeType === 1 && (p.cleanData(c.getElementsByTagName("*")), p.cleanData([c])), c.parentNode && c.parentNode.removeChild(c);
        return this
    }, empty: function () {
        var a, b = 0;
        for (; (a = this[b]) != null; b++) {
            a.nodeType === 1 && p.cleanData(a.getElementsByTagName("*"));
            while (a.firstChild)a.removeChild(a.firstChild)
        }
        return this
    }, clone: function (a, b) {
        return a = a == null ? !1 : a, b = b == null ? a : b, this.map(function () {
            return p.clone(this, a, b)
        })
    }, html: function (a) {
        return p.access(this, function (a) {
            var c = this[0] || {}, d = 0, e = this.length;
            if (a === b)return c.nodeType === 1 ? c.innerHTML.replace(bm, "") : b;
            if (typeof a == "string" && !bs.test(a) && (p.support.htmlSerialize || !bu.test(a)) && (p.support.leadingWhitespace || !bn.test(a)) && !bz[(bp.exec(a) || ["", ""])[1].toLowerCase()]) {
                a = a.replace(bo, "<$1></$2>");
                try {
                    for (; d < e; d++)c = this[d] || {}, c.nodeType === 1 && (p.cleanData(c.getElementsByTagName("*")), c.innerHTML = a);
                    c = 0
                } catch (f) {
                }
            }
            c && this.empty().append(a)
        }, null, a, arguments.length)
    }, replaceWith: function (a) {
        return bh(this[0]) ? this.length ? this.pushStack(p(p.isFunction(a) ? a() : a), "replaceWith", a) : this : p.isFunction(a) ? this.each(function (b) {
            var c = p(this), d = c.html();
            c.replaceWith(a.call(this, b, d))
        }) : (typeof a != "string" && (a = p(a).detach()), this.each(function () {
            var b = this.nextSibling, c = this.parentNode;
            p(this).remove(), b ? p(b).before(a) : p(c).append(a)
        }))
    }, detach: function (a) {
        return this.remove(a, !0)
    }, domManip: function (a, c, d) {
        a = [].concat.apply([], a);
        var e, f, g, h, i = 0, j = a[0], k = [], l = this.length;
        if (!p.support.checkClone && l > 1 && typeof j == "string" && bw.test(j))return this.each(function () {
            p(this).domManip(a, c, d)
        });
        if (p.isFunction(j))return this.each(function (e) {
            var f = p(this);
            a[0] = j.call(this, e, c ? f.html() : b), f.domManip(a, c, d)
        });
        if (this[0]) {
            e = p.buildFragment(a, this, k), g = e.fragment, f = g.firstChild, g.childNodes.length === 1 && (g = f);
            if (f) {
                c = c && p.nodeName(f, "tr");
                for (h = e.cacheable || l - 1; i < l; i++)d.call(c && p.nodeName(this[i], "table") ? bC(this[i], "tbody") : this[i], i === h ? g : p.clone(g, !0, !0))
            }
            g = f = null, k.length && p.each(k, function (a, b) {
                b.src ? p.ajax ? p.ajax({url: b.src, type: "GET", dataType: "script", async: !1, global: !1, "throws": !0}) : p.error("no ajax") : p.globalEval((b.text || b.textContent || b.innerHTML || "").replace(by, "")), b.parentNode && b.parentNode.removeChild(b)
            })
        }
        return this
    }}), p.buildFragment = function (a, c, d) {
        var f, g, h, i = a[0];
        return c = c || e, c = !c.nodeType && c[0] || c, c = c.ownerDocument || c, a.length === 1 && typeof i == "string" && i.length < 512 && c === e && i.charAt(0) === "<" && !bt.test(i) && (p.support.checkClone || !bw.test(i)) && (p.support.html5Clone || !bu.test(i)) && (g = !0, f = p.fragments[i], h = f !== b), f || (f = c.createDocumentFragment(), p.clean(a, c, f, d), g && (p.fragments[i] = h && f)), {fragment: f, cacheable: g}
    }, p.fragments = {}, p.each({appendTo: "append", prependTo: "prepend", insertBefore: "before", insertAfter: "after", replaceAll: "replaceWith"}, function (a, b) {
        p.fn[a] = function (c) {
            var d, e = 0, f = [], g = p(c), h = g.length, i = this.length === 1 && this[0].parentNode;
            if ((i == null || i && i.nodeType === 11 && i.childNodes.length === 1) && h === 1)return g[b](this[0]), this;
            for (; e < h; e++)d = (e > 0 ? this.clone(!0) : this).get(), p(g[e])[b](d), f = f.concat(d);
            return this.pushStack(f, a, g.selector)
        }
    }), p.extend({clone: function (a, b, c) {
        var d, e, f, g;
        p.support.html5Clone || p.isXMLDoc(a) || !bu.test("<" + a.nodeName + ">") ? g = a.cloneNode(!0) : (bB.innerHTML = a.outerHTML, bB.removeChild(g = bB.firstChild));
        if ((!p.support.noCloneEvent || !p.support.noCloneChecked) && (a.nodeType === 1 || a.nodeType === 11) && !p.isXMLDoc(a)) {
            bE(a, g), d = bF(a), e = bF(g);
            for (f = 0; d[f]; ++f)e[f] && bE(d[f], e[f])
        }
        if (b) {
            bD(a, g);
            if (c) {
                d = bF(a), e = bF(g);
                for (f = 0; d[f]; ++f)bD(d[f], e[f])
            }
        }
        return d = e = null, g
    }, clean: function (a, b, c, d) {
        var f, g, h, i, j, k, l, m, n, o, q, r, s = b === e && bA, t = [];
        if (!b || typeof b.createDocumentFragment == "undefined")b = e;
        for (f = 0; (h = a[f]) != null; f++) {
            typeof h == "number" && (h += "");
            if (!h)continue;
            if (typeof h == "string")if (!br.test(h))h = b.createTextNode(h); else {
                s = s || bk(b), l = b.createElement("div"), s.appendChild(l), h = h.replace(bo, "<$1></$2>"), i = (bp.exec(h) || ["", ""])[1].toLowerCase(), j = bz[i] || bz._default, k = j[0], l.innerHTML = j[1] + h + j[2];
                while (k--)l = l.lastChild;
                if (!p.support.tbody) {
                    m = bq.test(h), n = i === "table" && !m ? l.firstChild && l.firstChild.childNodes : j[1] === "<table>" && !m ? l.childNodes : [];
                    for (g = n.length - 1; g >= 0; --g)p.nodeName(n[g], "tbody") && !n[g].childNodes.length && n[g].parentNode.removeChild(n[g])
                }
                !p.support.leadingWhitespace && bn.test(h) && l.insertBefore(b.createTextNode(bn.exec(h)[0]), l.firstChild), h = l.childNodes, l.parentNode.removeChild(l)
            }
            h.nodeType ? t.push(h) : p.merge(t, h)
        }
        l && (h = l = s = null);
        if (!p.support.appendChecked)for (f = 0; (h = t[f]) != null; f++)p.nodeName(h, "input") ? bG(h) : typeof h.getElementsByTagName != "undefined" && p.grep(h.getElementsByTagName("input"), bG);
        if (c) {
            q = function (a) {
                if (!a.type || bx.test(a.type))return d ? d.push(a.parentNode ? a.parentNode.removeChild(a) : a) : c.appendChild(a)
            };
            for (f = 0; (h = t[f]) != null; f++)if (!p.nodeName(h, "script") || !q(h))c.appendChild(h), typeof h.getElementsByTagName != "undefined" && (r = p.grep(p.merge([], h.getElementsByTagName("script")), q), t.splice.apply(t, [f + 1, 0].concat(r)), f += r.length)
        }
        return t
    }, cleanData: function (a, b) {
        var c, d, e, f, g = 0, h = p.expando, i = p.cache, j = p.support.deleteExpando, k = p.event.special;
        for (; (e = a[g]) != null; g++)if (b || p.acceptData(e)) {
            d = e[h], c = d && i[d];
            if (c) {
                if (c.events)for (f in c.events)k[f] ? p.event.remove(e, f) : p.removeEvent(e, f, c.handle);
                i[d] && (delete i[d], j ? delete e[h] : e.removeAttribute ? e.removeAttribute(h) : e[h] = null, p.deletedIds.push(d))
            }
        }
    }}), function () {
        var a, b;
        p.uaMatch = function (a) {
            a = a.toLowerCase();
            var b = /(chrome)[ \/]([\w.]+)/.exec(a) || /(webkit)[ \/]([\w.]+)/.exec(a) || /(opera)(?:.*version|)[ \/]([\w.]+)/.exec(a) || /(msie) ([\w.]+)/.exec(a) || a.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec(a) || [];
            return{browser: b[1] || "", version: b[2] || "0"}
        }, a = p.uaMatch(g.userAgent), b = {}, a.browser && (b[a.browser] = !0, b.version = a.version), b.chrome ? b.webkit = !0 : b.webkit && (b.safari = !0), p.browser = b, p.sub = function () {
            function a(b, c) {
                return new a.fn.init(b, c)
            }

            p.extend(!0, a, this), a.superclass = this, a.fn = a.prototype = this(), a.fn.constructor = a, a.sub = this.sub, a.fn.init = function (d, e) {
                return e && e instanceof p && !(e instanceof a) && (e = a(e)), p.fn.init.call(this, d, e, b)
            }, a.fn.init.prototype = a.fn;
            var b = a(e);
            return a
        }
    }();
    var bH, bI, bJ, bK = /alpha\([^)]*\)/i, bL = /opacity=([^)]*)/, bM = /^(top|right|bottom|left)$/, bN = /^(none|table(?!-c[ea]).+)/, bO = /^margin/, bP = new RegExp("^(" + q + ")(.*)$", "i"), bQ = new RegExp("^(" + q + ")(?!px)[a-z%]+$", "i"), bR = new RegExp("^([-+])=(" + q + ")", "i"), bS = {BODY: "block"}, bT = {position: "absolute", visibility: "hidden", display: "block"}, bU = {letterSpacing: 0, fontWeight: 400}, bV = ["Top", "Right", "Bottom", "Left"], bW = ["Webkit", "O", "Moz", "ms"], bX = p.fn.toggle;
    p.fn.extend({css: function (a, c) {
        return p.access(this, function (a, c, d) {
            return d !== b ? p.style(a, c, d) : p.css(a, c)
        }, a, c, arguments.length > 1)
    }, show: function () {
        return b$(this, !0)
    }, hide: function () {
        return b$(this)
    }, toggle: function (a, b) {
        var c = typeof a == "boolean";
        return p.isFunction(a) && p.isFunction(b) ? bX.apply(this, arguments) : this.each(function () {
            (c ? a : bZ(this)) ? p(this).show() : p(this).hide()
        })
    }}), p.extend({cssHooks: {opacity: {get: function (a, b) {
        if (b) {
            var c = bH(a, "opacity");
            return c === "" ? "1" : c
        }
    }}}, cssNumber: {fillOpacity: !0, fontWeight: !0, lineHeight: !0, opacity: !0, orphans: !0, widows: !0, zIndex: !0, zoom: !0}, cssProps: {"float": p.support.cssFloat ? "cssFloat" : "styleFloat"}, style: function (a, c, d, e) {
        if (!a || a.nodeType === 3 || a.nodeType === 8 || !a.style)return;
        var f, g, h, i = p.camelCase(c), j = a.style;
        c = p.cssProps[i] || (p.cssProps[i] = bY(j, i)), h = p.cssHooks[c] || p.cssHooks[i];
        if (d === b)return h && "get"in h && (f = h.get(a, !1, e)) !== b ? f : j[c];
        g = typeof d, g === "string" && (f = bR.exec(d)) && (d = (f[1] + 1) * f[2] + parseFloat(p.css(a, c)), g = "number");
        if (d == null || g === "number" && isNaN(d))return;
        g === "number" && !p.cssNumber[i] && (d += "px");
        if (!h || !("set"in h) || (d = h.set(a, d, e)) !== b)try {
            j[c] = d
        } catch (k) {
        }
    }, css: function (a, c, d, e) {
        var f, g, h, i = p.camelCase(c);
        return c = p.cssProps[i] || (p.cssProps[i] = bY(a.style, i)), h = p.cssHooks[c] || p.cssHooks[i], h && "get"in h && (f = h.get(a, !0, e)), f === b && (f = bH(a, c)), f === "normal" && c in bU && (f = bU[c]), d || e !== b ? (g = parseFloat(f), d || p.isNumeric(g) ? g || 0 : f) : f
    }, swap: function (a, b, c) {
        var d, e, f = {};
        for (e in b)f[e] = a.style[e], a.style[e] = b[e];
        d = c.call(a);
        for (e in b)a.style[e] = f[e];
        return d
    }}), a.getComputedStyle ? bH = function (b, c) {
        var d, e, f, g, h = a.getComputedStyle(b, null), i = b.style;
        return h && (d = h.getPropertyValue(c) || h[c], d === "" && !p.contains(b.ownerDocument, b) && (d = p.style(b, c)), bQ.test(d) && bO.test(c) && (e = i.width, f = i.minWidth, g = i.maxWidth, i.minWidth = i.maxWidth = i.width = d, d = h.width, i.width = e, i.minWidth = f, i.maxWidth = g)), d
    } : e.documentElement.currentStyle && (bH = function (a, b) {
        var c, d, e = a.currentStyle && a.currentStyle[b], f = a.style;
        return e == null && f && f[b] && (e = f[b]), bQ.test(e) && !bM.test(b) && (c = f.left, d = a.runtimeStyle && a.runtimeStyle.left, d && (a.runtimeStyle.left = a.currentStyle.left), f.left = b === "fontSize" ? "1em" : e, e = f.pixelLeft + "px", f.left = c, d && (a.runtimeStyle.left = d)), e === "" ? "auto" : e
    }), p.each(["height", "width"], function (a, b) {
        p.cssHooks[b] = {get: function (a, c, d) {
            if (c)return a.offsetWidth === 0 && bN.test(bH(a, "display")) ? p.swap(a, bT, function () {
                return cb(a, b, d)
            }) : cb(a, b, d)
        }, set: function (a, c, d) {
            return b_(a, c, d ? ca(a, b, d, p.support.boxSizing && p.css(a, "boxSizing") === "border-box") : 0)
        }}
    }), p.support.opacity || (p.cssHooks.opacity = {get: function (a, b) {
        return bL.test((b && a.currentStyle ? a.currentStyle.filter : a.style.filter) || "") ? .01 * parseFloat(RegExp.$1) + "" : b ? "1" : ""
    }, set: function (a, b) {
        var c = a.style, d = a.currentStyle, e = p.isNumeric(b) ? "alpha(opacity=" + b * 100 + ")" : "", f = d && d.filter || c.filter || "";
        c.zoom = 1;
        if (b >= 1 && p.trim(f.replace(bK, "")) === "" && c.removeAttribute) {
            c.removeAttribute("filter");
            if (d && !d.filter)return
        }
        c.filter = bK.test(f) ? f.replace(bK, e) : f + " " + e
    }}), p(function () {
        p.support.reliableMarginRight || (p.cssHooks.marginRight = {get: function (a, b) {
            return p.swap(a, {display: "inline-block"}, function () {
                if (b)return bH(a, "marginRight")
            })
        }}), !p.support.pixelPosition && p.fn.position && p.each(["top", "left"], function (a, b) {
            p.cssHooks[b] = {get: function (a, c) {
                if (c) {
                    var d = bH(a, b);
                    return bQ.test(d) ? p(a).position()[b] + "px" : d
                }
            }}
        })
    }), p.expr && p.expr.filters && (p.expr.filters.hidden = function (a) {
        return a.offsetWidth === 0 && a.offsetHeight === 0 || !p.support.reliableHiddenOffsets && (a.style && a.style.display || bH(a, "display")) === "none"
    }, p.expr.filters.visible = function (a) {
        return!p.expr.filters.hidden(a)
    }), p.each({margin: "", padding: "", border: "Width"}, function (a, b) {
        p.cssHooks[a + b] = {expand: function (c) {
            var d, e = typeof c == "string" ? c.split(" ") : [c], f = {};
            for (d = 0; d < 4; d++)f[a + bV[d] + b] = e[d] || e[d - 2] || e[0];
            return f
        }}, bO.test(a) || (p.cssHooks[a + b].set = b_)
    });
    var cd = /%20/g, ce = /\[\]$/, cf = /\r?\n/g, cg = /^(?:color|date|datetime|datetime-local|email|hidden|month|number|password|range|search|tel|text|time|url|week)$/i, ch = /^(?:select|textarea)/i;
    p.fn.extend({serialize: function () {
        return p.param(this.serializeArray())
    }, serializeArray: function () {
        return this.map(function () {
            return this.elements ? p.makeArray(this.elements) : this
        }).filter(function () {
            return this.name && !this.disabled && (this.checked || ch.test(this.nodeName) || cg.test(this.type))
        }).map(function (a, b) {
            var c = p(this).val();
            return c == null ? null : p.isArray(c) ? p.map(c, function (a, c) {
                return{name: b.name, value: a.replace(cf, "\r\n")}
            }) : {name: b.name, value: c.replace(cf, "\r\n")}
        }).get()
    }}), p.param = function (a, c) {
        var d, e = [], f = function (a, b) {
            b = p.isFunction(b) ? b() : b == null ? "" : b, e[e.length] = encodeURIComponent(a) + "=" + encodeURIComponent(b)
        };
        c === b && (c = p.ajaxSettings && p.ajaxSettings.traditional);
        if (p.isArray(a) || a.jquery && !p.isPlainObject(a))p.each(a, function () {
            f(this.name, this.value)
        }); else for (d in a)ci(d, a[d], c, f);
        return e.join("&").replace(cd, "+")
    };
    var cj, ck, cl = /#.*$/, cm = /^(.*?):[ \t]*([^\r\n]*)\r?$/mg, cn = /^(?:about|app|app\-storage|.+\-extension|file|res|widget):$/, co = /^(?:GET|HEAD)$/, cp = /^\/\//, cq = /\?/, cr = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, cs = /([?&])_=[^&]*/, ct = /^([\w\+\.\-]+:)(?:\/\/([^\/?#:]*)(?::(\d+)|)|)/, cu = p.fn.load, cv = {}, cw = {}, cx = ["*/"] + ["*"];
    try {
        ck = f.href
    } catch (cy) {
        ck = e.createElement("a"), ck.href = "", ck = ck.href
    }
    cj = ct.exec(ck.toLowerCase()) || [], p.fn.load = function (a, c, d) {
        if (typeof a != "string" && cu)return cu.apply(this, arguments);
        if (!this.length)return this;
        var e, f, g, h = this, i = a.indexOf(" ");
        return i >= 0 && (e = a.slice(i, a.length), a = a.slice(0, i)), p.isFunction(c) ? (d = c, c = b) : c && typeof c == "object" && (f = "POST"), p.ajax({url: a, type: f, dataType: "html", data: c, complete: function (a, b) {
            d && h.each(d, g || [a.responseText, b, a])
        }}).done(function (a) {
            g = arguments, h.html(e ? p("<div>").append(a.replace(cr, "")).find(e) : a)
        }), this
    }, p.each("ajaxStart ajaxStop ajaxComplete ajaxError ajaxSuccess ajaxSend".split(" "), function (a, b) {
        p.fn[b] = function (a) {
            return this.on(b, a)
        }
    }), p.each(["get", "post"], function (a, c) {
        p[c] = function (a, d, e, f) {
            return p.isFunction(d) && (f = f || e, e = d, d = b), p.ajax({type: c, url: a, data: d, success: e, dataType: f})
        }
    }), p.extend({getScript: function (a, c) {
        return p.get(a, b, c, "script")
    }, getJSON: function (a, b, c) {
        return p.get(a, b, c, "json")
    }, ajaxSetup: function (a, b) {
        return b ? cB(a, p.ajaxSettings) : (b = a, a = p.ajaxSettings), cB(a, b), a
    }, ajaxSettings: {url: ck, isLocal: cn.test(cj[1]), global: !0, type: "GET", contentType: "application/x-www-form-urlencoded; charset=UTF-8", processData: !0, async: !0, accepts: {xml: "application/xml, text/xml", html: "text/html", text: "text/plain", json: "application/json, text/javascript", "*": cx}, contents: {xml: /xml/, html: /html/, json: /json/}, responseFields: {xml: "responseXML", text: "responseText"}, converters: {"* text": a.String, "text html": !0, "text json": p.parseJSON, "text xml": p.parseXML}, flatOptions: {context: !0, url: !0}}, ajaxPrefilter: cz(cv), ajaxTransport: cz(cw), ajax: function (a, c) {
        function y(a, c, f, i) {
            var k, s, t, u, w, y = c;
            if (v === 2)return;
            v = 2, h && clearTimeout(h), g = b, e = i || "", x.readyState = a > 0 ? 4 : 0, f && (u = cC(l, x, f));
            if (a >= 200 && a < 300 || a === 304)l.ifModified && (w = x.getResponseHeader("Last-Modified"), w && (p.lastModified[d] = w), w = x.getResponseHeader("Etag"), w && (p.etag[d] = w)), a === 304 ? (y = "notmodified", k = !0) : (k = cD(l, u), y = k.state, s = k.data, t = k.error, k = !t); else {
                t = y;
                if (!y || a)y = "error", a < 0 && (a = 0)
            }
            x.status = a, x.statusText = (c || y) + "", k ? o.resolveWith(m, [s, y, x]) : o.rejectWith(m, [x, y, t]), x.statusCode(r), r = b, j && n.trigger("ajax" + (k ? "Success" : "Error"), [x, l, k ? s : t]), q.fireWith(m, [x, y]), j && (n.trigger("ajaxComplete", [x, l]), --p.active || p.event.trigger("ajaxStop"))
        }

        typeof a == "object" && (c = a, a = b), c = c || {};
        var d, e, f, g, h, i, j, k, l = p.ajaxSetup({}, c), m = l.context || l, n = m !== l && (m.nodeType || m instanceof p) ? p(m) : p.event, o = p.Deferred(), q = p.Callbacks("once memory"), r = l.statusCode || {}, t = {}, u = {}, v = 0, w = "canceled", x = {readyState: 0, setRequestHeader: function (a, b) {
            if (!v) {
                var c = a.toLowerCase();
                a = u[c] = u[c] || a, t[a] = b
            }
            return this
        }, getAllResponseHeaders: function () {
            return v === 2 ? e : null
        }, getResponseHeader: function (a) {
            var c;
            if (v === 2) {
                if (!f) {
                    f = {};
                    while (c = cm.exec(e))f[c[1].toLowerCase()] = c[2]
                }
                c = f[a.toLowerCase()]
            }
            return c === b ? null : c
        }, overrideMimeType: function (a) {
            return v || (l.mimeType = a), this
        }, abort: function (a) {
            return a = a || w, g && g.abort(a), y(0, a), this
        }};
        o.promise(x), x.success = x.done, x.error = x.fail, x.complete = q.add, x.statusCode = function (a) {
            if (a) {
                var b;
                if (v < 2)for (b in a)r[b] = [r[b], a[b]]; else b = a[x.status], x.always(b)
            }
            return this
        }, l.url = ((a || l.url) + "").replace(cl, "").replace(cp, cj[1] + "//"), l.dataTypes = p.trim(l.dataType || "*").toLowerCase().split(s), l.crossDomain == null && (i = ct.exec(l.url.toLowerCase()), l.crossDomain = !(!i || i[1] === cj[1] && i[2] === cj[2] && (i[3] || (i[1] === "http:" ? 80 : 443)) == (cj[3] || (cj[1] === "http:" ? 80 : 443)))), l.data && l.processData && typeof l.data != "string" && (l.data = p.param(l.data, l.traditional)), cA(cv, l, c, x);
        if (v === 2)return x;
        j = l.global, l.type = l.type.toUpperCase(), l.hasContent = !co.test(l.type), j && p.active++ === 0 && p.event.trigger("ajaxStart");
        if (!l.hasContent) {
            l.data && (l.url += (cq.test(l.url) ? "&" : "?") + l.data, delete l.data), d = l.url;
            if (l.cache === !1) {
                var z = p.now(), A = l.url.replace(cs, "$1_=" + z);
                l.url = A + (A === l.url ? (cq.test(l.url) ? "&" : "?") + "_=" + z : "")
            }
        }
        (l.data && l.hasContent && l.contentType !== !1 || c.contentType) && x.setRequestHeader("Content-Type", l.contentType), l.ifModified && (d = d || l.url, p.lastModified[d] && x.setRequestHeader("If-Modified-Since", p.lastModified[d]), p.etag[d] && x.setRequestHeader("If-None-Match", p.etag[d])), x.setRequestHeader("Accept", l.dataTypes[0] && l.accepts[l.dataTypes[0]] ? l.accepts[l.dataTypes[0]] + (l.dataTypes[0] !== "*" ? ", " + cx + "; q=0.01" : "") : l.accepts["*"]);
        for (k in l.headers)x.setRequestHeader(k, l.headers[k]);
        if (!l.beforeSend || l.beforeSend.call(m, x, l) !== !1 && v !== 2) {
            w = "abort";
            for (k in{success: 1, error: 1, complete: 1})x[k](l[k]);
            g = cA(cw, l, c, x);
            if (!g)y(-1, "No Transport"); else {
                x.readyState = 1, j && n.trigger("ajaxSend", [x, l]), l.async && l.timeout > 0 && (h = setTimeout(function () {
                    x.abort("timeout")
                }, l.timeout));
                try {
                    v = 1, g.send(t, y)
                } catch (B) {
                    if (!(v < 2))throw B;
                    y(-1, B)
                }
            }
            return x
        }
        return x.abort()
    }, active: 0, lastModified: {}, etag: {}});
    var cE = [], cF = /\?/, cG = /(=)\?(?=&|$)|\?\?/, cH = p.now();
    p.ajaxSetup({jsonp: "callback", jsonpCallback: function () {
        var a = cE.pop() || p.expando + "_" + cH++;
        return this[a] = !0, a
    }}), p.ajaxPrefilter("json jsonp", function (c, d, e) {
        var f, g, h, i = c.data, j = c.url, k = c.jsonp !== !1, l = k && cG.test(j), m = k && !l && typeof i == "string" && !(c.contentType || "").indexOf("application/x-www-form-urlencoded") && cG.test(i);
        if (c.dataTypes[0] === "jsonp" || l || m)return f = c.jsonpCallback = p.isFunction(c.jsonpCallback) ? c.jsonpCallback() : c.jsonpCallback, g = a[f], l ? c.url = j.replace(cG, "$1" + f) : m ? c.data = i.replace(cG, "$1" + f) : k && (c.url += (cF.test(j) ? "&" : "?") + c.jsonp + "=" + f), c.converters["script json"] = function () {
            return h || p.error(f + " was not called"), h[0]
        }, c.dataTypes[0] = "json", a[f] = function () {
            h = arguments
        }, e.always(function () {
            a[f] = g, c[f] && (c.jsonpCallback = d.jsonpCallback, cE.push(f)), h && p.isFunction(g) && g(h[0]), h = g = b
        }), "script"
    }), p.ajaxSetup({accepts: {script: "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"}, contents: {script: /javascript|ecmascript/}, converters: {"text script": function (a) {
        return p.globalEval(a), a
    }}}), p.ajaxPrefilter("script", function (a) {
        a.cache === b && (a.cache = !1), a.crossDomain && (a.type = "GET", a.global = !1)
    }), p.ajaxTransport("script", function (a) {
        if (a.crossDomain) {
            var c, d = e.head || e.getElementsByTagName("head")[0] || e.documentElement;
            return{send: function (f, g) {
                c = e.createElement("script"), c.async = "async", a.scriptCharset && (c.charset = a.scriptCharset), c.src = a.url, c.onload = c.onreadystatechange = function (a, e) {
                    if (e || !c.readyState || /loaded|complete/.test(c.readyState))c.onload = c.onreadystatechange = null, d && c.parentNode && d.removeChild(c), c = b, e || g(200, "success")
                }, d.insertBefore(c, d.firstChild)
            }, abort: function () {
                c && c.onload(0, 1)
            }}
        }
    });
    var cI, cJ = a.ActiveXObject ? function () {
        for (var a in cI)cI[a](0, 1)
    } : !1, cK = 0;
    p.ajaxSettings.xhr = a.ActiveXObject ? function () {
        return!this.isLocal && cL() || cM()
    } : cL, function (a) {
        p.extend(p.support, {ajax: !!a, cors: !!a && "withCredentials"in a})
    }(p.ajaxSettings.xhr()), p.support.ajax && p.ajaxTransport(function (c) {
        if (!c.crossDomain || p.support.cors) {
            var d;
            return{send: function (e, f) {
                var g, h, i = c.xhr();
                c.username ? i.open(c.type, c.url, c.async, c.username, c.password) : i.open(c.type, c.url, c.async);
                if (c.xhrFields)for (h in c.xhrFields)i[h] = c.xhrFields[h];
                c.mimeType && i.overrideMimeType && i.overrideMimeType(c.mimeType), !c.crossDomain && !e["X-Requested-With"] && (e["X-Requested-With"] = "XMLHttpRequest");
                try {
                    for (h in e)i.setRequestHeader(h, e[h])
                } catch (j) {
                }
                i.send(c.hasContent && c.data || null), d = function (a, e) {
                    var h, j, k, l, m;
                    try {
                        if (d && (e || i.readyState === 4)) {
                            d = b, g && (i.onreadystatechange = p.noop, cJ && delete cI[g]);
                            if (e)i.readyState !== 4 && i.abort(); else {
                                h = i.status, k = i.getAllResponseHeaders(), l = {}, m = i.responseXML, m && m.documentElement && (l.xml = m);
                                try {
                                    l.text = i.responseText
                                } catch (n) {
                                }
                                try {
                                    j = i.statusText
                                } catch (n) {
                                    j = ""
                                }
                                !h && c.isLocal && !c.crossDomain ? h = l.text ? 200 : 404 : h === 1223 && (h = 204)
                            }
                        }
                    } catch (o) {
                        e || f(-1, o)
                    }
                    l && f(h, j, l, k)
                }, c.async ? i.readyState === 4 ? setTimeout(d, 0) : (g = ++cK, cJ && (cI || (cI = {}, p(a).unload(cJ)), cI[g] = d), i.onreadystatechange = d) : d()
            }, abort: function () {
                d && d(0, 1)
            }}
        }
    });
    var cN, cO, cP = /^(?:toggle|show|hide)$/, cQ = new RegExp("^(?:([-+])=|)(" + q + ")([a-z%]*)$", "i"), cR = /queueHooks$/, cS = [cY], cT = {"*": [function (a, b) {
        var c, d, e = this.createTween(a, b), f = cQ.exec(b), g = e.cur(), h = +g || 0, i = 1, j = 20;
        if (f) {
            c = +f[2], d = f[3] || (p.cssNumber[a] ? "" : "px");
            if (d !== "px" && h) {
                h = p.css(e.elem, a, !0) || c || 1;
                do i = i || ".5", h /= i, p.style(e.elem, a, h + d); while (i !== (i = e.cur() / g) && i !== 1 && --j)
            }
            e.unit = d, e.start = h, e.end = f[1] ? h + (f[1] + 1) * c : c
        }
        return e
    }]};
    p.Animation = p.extend(cW, {tweener: function (a, b) {
        p.isFunction(a) ? (b = a, a = ["*"]) : a = a.split(" ");
        var c, d = 0, e = a.length;
        for (; d < e; d++)c = a[d], cT[c] = cT[c] || [], cT[c].unshift(b)
    }, prefilter: function (a, b) {
        b ? cS.unshift(a) : cS.push(a)
    }}), p.Tween = cZ, cZ.prototype = {constructor: cZ, init: function (a, b, c, d, e, f) {
        this.elem = a, this.prop = c, this.easing = e || "swing", this.options = b, this.start = this.now = this.cur(), this.end = d, this.unit = f || (p.cssNumber[c] ? "" : "px")
    }, cur: function () {
        var a = cZ.propHooks[this.prop];
        return a && a.get ? a.get(this) : cZ.propHooks._default.get(this)
    }, run: function (a) {
        var b, c = cZ.propHooks[this.prop];
        return this.options.duration ? this.pos = b = p.easing[this.easing](a, this.options.duration * a, 0, 1, this.options.duration) : this.pos = b = a, this.now = (this.end - this.start) * b + this.start, this.options.step && this.options.step.call(this.elem, this.now, this), c && c.set ? c.set(this) : cZ.propHooks._default.set(this), this
    }}, cZ.prototype.init.prototype = cZ.prototype, cZ.propHooks = {_default: {get: function (a) {
        var b;
        return a.elem[a.prop] == null || !!a.elem.style && a.elem.style[a.prop] != null ? (b = p.css(a.elem, a.prop, !1, ""), !b || b === "auto" ? 0 : b) : a.elem[a.prop]
    }, set: function (a) {
        p.fx.step[a.prop] ? p.fx.step[a.prop](a) : a.elem.style && (a.elem.style[p.cssProps[a.prop]] != null || p.cssHooks[a.prop]) ? p.style(a.elem, a.prop, a.now + a.unit) : a.elem[a.prop] = a.now
    }}}, cZ.propHooks.scrollTop = cZ.propHooks.scrollLeft = {set: function (a) {
        a.elem.nodeType && a.elem.parentNode && (a.elem[a.prop] = a.now)
    }}, p.each(["toggle", "show", "hide"], function (a, b) {
        var c = p.fn[b];
        p.fn[b] = function (d, e, f) {
            return d == null || typeof d == "boolean" || !a && p.isFunction(d) && p.isFunction(e) ? c.apply(this, arguments) : this.animate(c$(b, !0), d, e, f)
        }
    }), p.fn.extend({fadeTo: function (a, b, c, d) {
        return this.filter(bZ).css("opacity", 0).show().end().animate({opacity: b}, a, c, d)
    }, animate: function (a, b, c, d) {
        var e = p.isEmptyObject(a), f = p.speed(b, c, d), g = function () {
            var b = cW(this, p.extend({}, a), f);
            e && b.stop(!0)
        };
        return e || f.queue === !1 ? this.each(g) : this.queue(f.queue, g)
    }, stop: function (a, c, d) {
        var e = function (a) {
            var b = a.stop;
            delete a.stop, b(d)
        };
        return typeof a != "string" && (d = c, c = a, a = b), c && a !== !1 && this.queue(a || "fx", []), this.each(function () {
            var b = !0, c = a != null && a + "queueHooks", f = p.timers, g = p._data(this);
            if (c)g[c] && g[c].stop && e(g[c]); else for (c in g)g[c] && g[c].stop && cR.test(c) && e(g[c]);
            for (c = f.length; c--;)f[c].elem === this && (a == null || f[c].queue === a) && (f[c].anim.stop(d), b = !1, f.splice(c, 1));
            (b || !d) && p.dequeue(this, a)
        })
    }}), p.each({slideDown: c$("show"), slideUp: c$("hide"), slideToggle: c$("toggle"), fadeIn: {opacity: "show"}, fadeOut: {opacity: "hide"}, fadeToggle: {opacity: "toggle"}}, function (a, b) {
        p.fn[a] = function (a, c, d) {
            return this.animate(b, a, c, d)
        }
    }), p.speed = function (a, b, c) {
        var d = a && typeof a == "object" ? p.extend({}, a) : {complete: c || !c && b || p.isFunction(a) && a, duration: a, easing: c && b || b && !p.isFunction(b) && b};
        d.duration = p.fx.off ? 0 : typeof d.duration == "number" ? d.duration : d.duration in p.fx.speeds ? p.fx.speeds[d.duration] : p.fx.speeds._default;
        if (d.queue == null || d.queue === !0)d.queue = "fx";
        return d.old = d.complete, d.complete = function () {
            p.isFunction(d.old) && d.old.call(this), d.queue && p.dequeue(this, d.queue)
        }, d
    }, p.easing = {linear: function (a) {
        return a
    }, swing: function (a) {
        return.5 - Math.cos(a * Math.PI) / 2
    }}, p.timers = [], p.fx = cZ.prototype.init, p.fx.tick = function () {
        var a, c = p.timers, d = 0;
        cN = p.now();
        for (; d < c.length; d++)a = c[d], !a() && c[d] === a && c.splice(d--, 1);
        c.length || p.fx.stop(), cN = b
    }, p.fx.timer = function (a) {
        a() && p.timers.push(a) && !cO && (cO = setInterval(p.fx.tick, p.fx.interval))
    }, p.fx.interval = 13, p.fx.stop = function () {
        clearInterval(cO), cO = null
    }, p.fx.speeds = {slow: 600, fast: 200, _default: 400}, p.fx.step = {}, p.expr && p.expr.filters && (p.expr.filters.animated = function (a) {
        return p.grep(p.timers,function (b) {
            return a === b.elem
        }).length
    });
    var c_ = /^(?:body|html)$/i;
    p.fn.offset = function (a) {
        if (arguments.length)return a === b ? this : this.each(function (b) {
            p.offset.setOffset(this, a, b)
        });
        var c, d, e, f, g, h, i, j = {top: 0, left: 0}, k = this[0], l = k && k.ownerDocument;
        if (!l)return;
        return(d = l.body) === k ? p.offset.bodyOffset(k) : (c = l.documentElement, p.contains(c, k) ? (typeof k.getBoundingClientRect != "undefined" && (j = k.getBoundingClientRect()), e = da(l), f = c.clientTop || d.clientTop || 0, g = c.clientLeft || d.clientLeft || 0, h = e.pageYOffset || c.scrollTop, i = e.pageXOffset || c.scrollLeft, {top: j.top + h - f, left: j.left + i - g}) : j)
    }, p.offset = {bodyOffset: function (a) {
        var b = a.offsetTop, c = a.offsetLeft;
        return p.support.doesNotIncludeMarginInBodyOffset && (b += parseFloat(p.css(a, "marginTop")) || 0, c += parseFloat(p.css(a, "marginLeft")) || 0), {top: b, left: c}
    }, setOffset: function (a, b, c) {
        var d = p.css(a, "position");
        d === "static" && (a.style.position = "relative");
        var e = p(a), f = e.offset(), g = p.css(a, "top"), h = p.css(a, "left"), i = (d === "absolute" || d === "fixed") && p.inArray("auto", [g, h]) > -1, j = {}, k = {}, l, m;
        i ? (k = e.position(), l = k.top, m = k.left) : (l = parseFloat(g) || 0, m = parseFloat(h) || 0), p.isFunction(b) && (b = b.call(a, c, f)), b.top != null && (j.top = b.top - f.top + l), b.left != null && (j.left = b.left - f.left + m), "using"in b ? b.using.call(a, j) : e.css(j)
    }}, p.fn.extend({position: function () {
        if (!this[0])return;
        var a = this[0], b = this.offsetParent(), c = this.offset(), d = c_.test(b[0].nodeName) ? {top: 0, left: 0} : b.offset();
        return c.top -= parseFloat(p.css(a, "marginTop")) || 0, c.left -= parseFloat(p.css(a, "marginLeft")) || 0, d.top += parseFloat(p.css(b[0], "borderTopWidth")) || 0, d.left += parseFloat(p.css(b[0], "borderLeftWidth")) || 0, {top: c.top - d.top, left: c.left - d.left}
    }, offsetParent: function () {
        return this.map(function () {
            var a = this.offsetParent || e.body;
            while (a && !c_.test(a.nodeName) && p.css(a, "position") === "static")a = a.offsetParent;
            return a || e.body
        })
    }}), p.each({scrollLeft: "pageXOffset", scrollTop: "pageYOffset"}, function (a, c) {
        var d = /Y/.test(c);
        p.fn[a] = function (e) {
            return p.access(this, function (a, e, f) {
                var g = da(a);
                if (f === b)return g ? c in g ? g[c] : g.document.documentElement[e] : a[e];
                g ? g.scrollTo(d ? p(g).scrollLeft() : f, d ? f : p(g).scrollTop()) : a[e] = f
            }, a, e, arguments.length, null)
        }
    }), p.each({Height: "height", Width: "width"}, function (a, c) {
        p.each({padding: "inner" + a, content: c, "": "outer" + a}, function (d, e) {
            p.fn[e] = function (e, f) {
                var g = arguments.length && (d || typeof e != "boolean"), h = d || (e === !0 || f === !0 ? "margin" : "border");
                return p.access(this, function (c, d, e) {
                    var f;
                    return p.isWindow(c) ? c.document.documentElement["client" + a] : c.nodeType === 9 ? (f = c.documentElement, Math.max(c.body["scroll" + a], f["scroll" + a], c.body["offset" + a], f["offset" + a], f["client" + a])) : e === b ? p.css(c, d, e, h) : p.style(c, d, e, h)
                }, c, g ? e : b, g, null)
            }
        })
    }), a.jQuery = a.$ = p, typeof define == "function" && define.amd && define.amd.jQuery && define("jquery", [], function () {
        return p
    })
})(window), function (a, b) {
    function e(b, c) {
        var d, e, g, h = b.nodeName.toLowerCase();
        return"area" === h ? (d = b.parentNode, e = d.name, !b.href || !e || d.nodeName.toLowerCase() !== "map" ? !1 : (g = a("img[usemap=#" + e + "]")[0], !!g && f(g))) : (/input|select|textarea|button|object/.test(h) ? !b.disabled : "a" === h ? b.href || c : c) && f(b)
    }

    function f(b) {
        return a.expr.filters.visible(b) && !a(b).parents().andSelf().filter(function () {
            return a.css(this, "visibility") === "hidden"
        }).length
    }

    var c = 0, d = /^ui-id-\d+$/;
    a.ui = a.ui || {};
    if (a.ui.version)return;
    a.extend(a.ui, {version: "1.9.2", keyCode: {BACKSPACE: 8, COMMA: 188, DELETE: 46, DOWN: 40, END: 35, ENTER: 13, ESCAPE: 27, HOME: 36, LEFT: 37, NUMPAD_ADD: 107, NUMPAD_DECIMAL: 110, NUMPAD_DIVIDE: 111, NUMPAD_ENTER: 108, NUMPAD_MULTIPLY: 106, NUMPAD_SUBTRACT: 109, PAGE_DOWN: 34, PAGE_UP: 33, PERIOD: 190, RIGHT: 39, SPACE: 32, TAB: 9, UP: 38}}), a.fn.extend({_focus: a.fn.focus, focus: function (b, c) {
        return typeof b == "number" ? this.each(function () {
            var d = this;
            setTimeout(function () {
                a(d).focus(), c && c.call(d)
            }, b)
        }) : this._focus.apply(this, arguments)
    }, scrollParent: function () {
        var b;
        return a.ui.ie && /(static|relative)/.test(this.css("position")) || /absolute/.test(this.css("position")) ? b = this.parents().filter(function () {
            return/(relative|absolute|fixed)/.test(a.css(this, "position")) && /(auto|scroll)/.test(a.css(this, "overflow") + a.css(this, "overflow-y") + a.css(this, "overflow-x"))
        }).eq(0) : b = this.parents().filter(function () {
            return/(auto|scroll)/.test(a.css(this, "overflow") + a.css(this, "overflow-y") + a.css(this, "overflow-x"))
        }).eq(0), /fixed/.test(this.css("position")) || !b.length ? a(document) : b
    }, zIndex: function (c) {
        if (c !== b)return this.css("zIndex", c);
        if (this.length) {
            var d = a(this[0]), e, f;
            while (d.length && d[0] !== document) {
                e = d.css("position");
                if (e === "absolute" || e === "relative" || e === "fixed") {
                    f = parseInt(d.css("zIndex"), 10);
                    if (!isNaN(f) && f !== 0)return f
                }
                d = d.parent()
            }
        }
        return 0
    }, uniqueId: function () {
        return this.each(function () {
            this.id || (this.id = "ui-id-" + ++c)
        })
    }, removeUniqueId: function () {
        return this.each(function () {
            d.test(this.id) && a(this).removeAttr("id")
        })
    }}), a.extend(a.expr[":"], {data: a.expr.createPseudo ? a.expr.createPseudo(function (b) {
        return function (c) {
            return!!a.data(c, b)
        }
    }) : function (b, c, d) {
        return!!a.data(b, d[3])
    }, focusable: function (b) {
        return e(b, !isNaN(a.attr(b, "tabindex")))
    }, tabbable: function (b) {
        var c = a.attr(b, "tabindex"), d = isNaN(c);
        return(d || c >= 0) && e(b, !d)
    }}), a(function () {
        var b = document.body, c = b.appendChild(c = document.createElement("div"));
        c.offsetHeight, a.extend(c.style, {minHeight: "100px", height: "auto", padding: 0, borderWidth: 0}), a.support.minHeight = c.offsetHeight === 100, a.support.selectstart = "onselectstart"in c, b.removeChild(c).style.display = "none"
    }), a("<a>").outerWidth(1).jquery || a.each(["Width", "Height"], function (c, d) {
        function h(b, c, d, f) {
            return a.each(e, function () {
                c -= parseFloat(a.css(b, "padding" + this)) || 0, d && (c -= parseFloat(a.css(b, "border" + this + "Width")) || 0), f && (c -= parseFloat(a.css(b, "margin" + this)) || 0)
            }), c
        }

        var e = d === "Width" ? ["Left", "Right"] : ["Top", "Bottom"], f = d.toLowerCase(), g = {innerWidth: a.fn.innerWidth, innerHeight: a.fn.innerHeight, outerWidth: a.fn.outerWidth, outerHeight: a.fn.outerHeight};
        a.fn["inner" + d] = function (c) {
            return c === b ? g["inner" + d].call(this) : this.each(function () {
                a(this).css(f, h(this, c) + "px")
            })
        }, a.fn["outer" + d] = function (b, c) {
            return typeof b != "number" ? g["outer" + d].call(this, b) : this.each(function () {
                a(this).css(f, h(this, b, !0, c) + "px")
            })
        }
    }), a("<a>").data("a-b", "a").removeData("a-b").data("a-b") && (a.fn.removeData = function (b) {
        return function (c) {
            return arguments.length ? b.call(this, a.camelCase(c)) : b.call(this)
        }
    }(a.fn.removeData)), function () {
        var b = /msie ([\w.]+)/.exec(navigator.userAgent.toLowerCase()) || [];
        a.ui.ie = b.length ? !0 : !1, a.ui.ie6 = parseFloat(b[1], 10) === 6
    }(), a.fn.extend({disableSelection: function () {
        return this.bind((a.support.selectstart ? "selectstart" : "mousedown") + ".ui-disableSelection", function (a) {
            a.preventDefault()
        })
    }, enableSelection: function () {
        return this.unbind(".ui-disableSelection")
    }}), a.extend(a.ui, {plugin: {add: function (b, c, d) {
        var e, f = a.ui[b].prototype;
        for (e in d)f.plugins[e] = f.plugins[e] || [], f.plugins[e].push([c, d[e]])
    }, call: function (a, b, c) {
        var d, e = a.plugins[b];
        if (!e || !a.element[0].parentNode || a.element[0].parentNode.nodeType === 11)return;
        for (d = 0; d < e.length; d++)a.options[e[d][0]] && e[d][1].apply(a.element, c)
    }}, contains: a.contains, hasScroll: function (b, c) {
        if (a(b).css("overflow") === "hidden")return!1;
        var d = c && c === "left" ? "scrollLeft" : "scrollTop", e = !1;
        return b[d] > 0 ? !0 : (b[d] = 1, e = b[d] > 0, b[d] = 0, e)
    }, isOverAxis: function (a, b, c) {
        return a > b && a < b + c
    }, isOver: function (b, c, d, e, f, g) {
        return a.ui.isOverAxis(b, d, f) && a.ui.isOverAxis(c, e, g)
    }})
}(jQuery), function (a, b) {
    var c = 0, d = Array.prototype.slice, e = a.cleanData;
    a.cleanData = function (b) {
        for (var c = 0, d; (d = b[c]) != null; c++)try {
            a(d).triggerHandler("remove")
        } catch (f) {
        }
        e(b)
    }, a.widget = function (b, c, d) {
        var e, f, g, h, i = b.split(".")[0];
        b = b.split(".")[1], e = i + "-" + b, d || (d = c, c = a.Widget), a.expr[":"][e.toLowerCase()] = function (b) {
            return!!a.data(b, e)
        }, a[i] = a[i] || {}, f = a[i][b], g = a[i][b] = function (a, b) {
            if (!this._createWidget)return new g(a, b);
            arguments.length && this._createWidget(a, b)
        }, a.extend(g, f, {version: d.version, _proto: a.extend({}, d), _childConstructors: []}), h = new c, h.options = a.widget.extend({}, h.options), a.each(d, function (b, e) {
            a.isFunction(e) && (d[b] = function () {
                var a = function () {
                    return c.prototype[b].apply(this, arguments)
                }, d = function (a) {
                    return c.prototype[b].apply(this, a)
                };
                return function () {
                    var b = this._super, c = this._superApply, f;
                    return this._super = a, this._superApply = d, f = e.apply(this, arguments), this._super = b, this._superApply = c, f
                }
            }())
        }), g.prototype = a.widget.extend(h, {widgetEventPrefix: f ? h.widgetEventPrefix : b}, d, {constructor: g, namespace: i, widgetName: b, widgetBaseClass: e, widgetFullName: e}), f ? (a.each(f._childConstructors, function (b, c) {
            var d = c.prototype;
            a.widget(d.namespace + "." + d.widgetName, g, c._proto)
        }), delete f._childConstructors) : c._childConstructors.push(g), a.widget.bridge(b, g)
    }, a.widget.extend = function (c) {
        var e = d.call(arguments, 1), f = 0, g = e.length, h, i;
        for (; f < g; f++)for (h in e[f])i = e[f][h], e[f].hasOwnProperty(h) && i !== b && (a.isPlainObject(i) ? c[h] = a.isPlainObject(c[h]) ? a.widget.extend({}, c[h], i) : a.widget.extend({}, i) : c[h] = i);
        return c
    }, a.widget.bridge = function (c, e) {
        var f = e.prototype.widgetFullName || c;
        a.fn[c] = function (g) {
            var h = typeof g == "string", i = d.call(arguments, 1), j = this;
            return g = !h && i.length ? a.widget.extend.apply(null, [g].concat(i)) : g, h ? this.each(function () {
                var d, e = a.data(this, f);
                if (!e)return a.error("cannot call methods on " + c + " prior to initialization; " + "attempted to call method '" + g + "'");
                if (!a.isFunction(e[g]) || g.charAt(0) === "_")return a.error("no such method '" + g + "' for " + c + " widget instance");
                d = e[g].apply(e, i);
                if (d !== e && d !== b)return j = d && d.jquery ? j.pushStack(d.get()) : d, !1
            }) : this.each(function () {
                var b = a.data(this, f);
                b ? b.option(g || {})._init() : a.data(this, f, new e(g, this))
            }), j
        }
    }, a.Widget = function () {
    }, a.Widget._childConstructors = [], a.Widget.prototype = {widgetName: "widget", widgetEventPrefix: "", defaultElement: "<div>", options: {disabled: !1, create: null}, _createWidget: function (b, d) {
        d = a(d || this.defaultElement || this)[0], this.element = a(d), this.uuid = c++, this.eventNamespace = "." + this.widgetName + this.uuid, this.options = a.widget.extend({}, this.options, this._getCreateOptions(), b), this.bindings = a(), this.hoverable = a(), this.focusable = a(), d !== this && (a.data(d, this.widgetName, this), a.data(d, this.widgetFullName, this), this._on(!0, this.element, {remove: function (a) {
            a.target === d && this.destroy()
        }}), this.document = a(d.style ? d.ownerDocument : d.document || d), this.window = a(this.document[0].defaultView || this.document[0].parentWindow)), this._create(), this._trigger("create", null, this._getCreateEventData()), this._init()
    }, _getCreateOptions: a.noop, _getCreateEventData: a.noop, _create: a.noop, _init: a.noop, destroy: function () {
        this._destroy(), this.element.unbind(this.eventNamespace).removeData(this.widgetName).removeData(this.widgetFullName).removeData(a.camelCase(this.widgetFullName)), this.widget().unbind(this.eventNamespace).removeAttr("aria-disabled").removeClass(this.widgetFullName + "-disabled " + "ui-state-disabled"), this.bindings.unbind(this.eventNamespace), this.hoverable.removeClass("ui-state-hover"), this.focusable.removeClass("ui-state-focus")
    }, _destroy: a.noop, widget: function () {
        return this.element
    }, option: function (c, d) {
        var e = c, f, g, h;
        if (arguments.length === 0)return a.widget.extend({}, this.options);
        if (typeof c == "string") {
            e = {}, f = c.split("."), c = f.shift();
            if (f.length) {
                g = e[c] = a.widget.extend({}, this.options[c]);
                for (h = 0; h < f.length - 1; h++)g[f[h]] = g[f[h]] || {}, g = g[f[h]];
                c = f.pop();
                if (d === b)return g[c] === b ? null : g[c];
                g[c] = d
            } else {
                if (d === b)return this.options[c] === b ? null : this.options[c];
                e[c] = d
            }
        }
        return this._setOptions(e), this
    }, _setOptions: function (a) {
        var b;
        for (b in a)this._setOption(b, a[b]);
        return this
    }, _setOption: function (a, b) {
        return this.options[a] = b, a === "disabled" && (this.widget().toggleClass(this.widgetFullName + "-disabled ui-state-disabled", !!b).attr("aria-disabled", b), this.hoverable.removeClass("ui-state-hover"), this.focusable.removeClass("ui-state-focus")), this
    }, enable: function () {
        return this._setOption("disabled", !1)
    }, disable: function () {
        return this._setOption("disabled", !0)
    }, _on: function (b, c, d) {
        var e, f = this;
        typeof b != "boolean" && (d = c, c = b, b = !1), d ? (c = e = a(c), this.bindings = this.bindings.add(c)) : (d = c, c = this.element, e = this.widget()), a.each(d, function (d, g) {
            function h() {
                if (!b && (f.options.disabled === !0 || a(this).hasClass("ui-state-disabled")))return;
                return(typeof g == "string" ? f[g] : g).apply(f, arguments)
            }

            typeof g != "string" && (h.guid = g.guid = g.guid || h.guid || a.guid++);
            var i = d.match(/^(\w+)\s*(.*)$/), j = i[1] + f.eventNamespace, k = i[2];
            k ? e.delegate(k, j, h) : c.bind(j, h)
        })
    }, _off: function (a, b) {
        b = (b || "").split(" ").join(this.eventNamespace + " ") + this.eventNamespace, a.unbind(b).undelegate(b)
    }, _delay: function (a, b) {
        function c() {
            return(typeof a == "string" ? d[a] : a).apply(d, arguments)
        }

        var d = this;
        return setTimeout(c, b || 0)
    }, _hoverable: function (b) {
        this.hoverable = this.hoverable.add(b), this._on(b, {mouseenter: function (b) {
            a(b.currentTarget).addClass("ui-state-hover")
        }, mouseleave: function (b) {
            a(b.currentTarget).removeClass("ui-state-hover")
        }})
    }, _focusable: function (b) {
        this.focusable = this.focusable.add(b), this._on(b, {focusin: function (b) {
            a(b.currentTarget).addClass("ui-state-focus")
        }, focusout: function (b) {
            a(b.currentTarget).removeClass("ui-state-focus")
        }})
    }, _trigger: function (b, c, d) {
        var e, f, g = this.options[b];
        d = d || {}, c = a.Event(c), c.type = (b === this.widgetEventPrefix ? b : this.widgetEventPrefix + b).toLowerCase(), c.target = this.element[0], f = c.originalEvent;
        if (f)for (e in f)e in c || (c[e] = f[e]);
        return this.element.trigger(c, d), !(a.isFunction(g) && g.apply(this.element[0], [c].concat(d)) === !1 || c.isDefaultPrevented())
    }}, a.each({show: "fadeIn", hide: "fadeOut"}, function (b, c) {
        a.Widget.prototype["_" + b] = function (d, e, f) {
            typeof e == "string" && (e = {effect: e});
            var g, h = e ? e === !0 || typeof e == "number" ? c : e.effect || c : b;
            e = e || {}, typeof e == "number" && (e = {duration: e}), g = !a.isEmptyObject(e), e.complete = f, e.delay && d.delay(e.delay), g && a.effects && (a.effects.effect[h] || a.uiBackCompat !== !1 && a.effects[h]) ? d[b](e) : h !== b && d[h] ? d[h](e.duration, e.easing, f) : d.queue(function (c) {
                a(this)[b](), f && f.call(d[0]), c()
            })
        }
    }), a.uiBackCompat !== !1 && (a.Widget.prototype._getCreateOptions = function () {
        return a.metadata && a.metadata.get(this.element[0])[this.widgetName]
    })
}(jQuery), function (a, b) {
    var c = !1;
    a(document).mouseup(function (a) {
        c = !1
    }), a.widget("ui.mouse", {version: "1.9.2", options: {cancel: "input,textarea,button,select,option", distance: 1, delay: 0}, _mouseInit: function () {
        var b = this;
        this.element.bind("mousedown." + this.widgetName,function (a) {
            return b._mouseDown(a)
        }).bind("click." + this.widgetName, function (c) {
            if (!0 === a.data(c.target, b.widgetName + ".preventClickEvent"))return a.removeData(c.target, b.widgetName + ".preventClickEvent"), c.stopImmediatePropagation(), !1
        }), this.started = !1
    }, _mouseDestroy: function () {
        this.element.unbind("." + this.widgetName), this._mouseMoveDelegate && a(document).unbind("mousemove." + this.widgetName, this._mouseMoveDelegate).unbind("mouseup." + this.widgetName, this._mouseUpDelegate)
    }, _mouseDown: function (b) {
        if (c)return;
        this._mouseStarted && this._mouseUp(b), this._mouseDownEvent = b;
        var d = this, e = b.which === 1, f = typeof this.options.cancel == "string" && b.target.nodeName ? a(b.target).closest(this.options.cancel).length : !1;
        if (!e || f || !this._mouseCapture(b))return!0;
        this.mouseDelayMet = !this.options.delay, this.mouseDelayMet || (this._mouseDelayTimer = setTimeout(function () {
            d.mouseDelayMet = !0
        }, this.options.delay));
        if (this._mouseDistanceMet(b) && this._mouseDelayMet(b)) {
            this._mouseStarted = this._mouseStart(b) !== !1;
            if (!this._mouseStarted)return b.preventDefault(), !0
        }
        return!0 === a.data(b.target, this.widgetName + ".preventClickEvent") && a.removeData(b.target, this.widgetName + ".preventClickEvent"), this._mouseMoveDelegate = function (a) {
            return d._mouseMove(a)
        }, this._mouseUpDelegate = function (a) {
            return d._mouseUp(a)
        }, a(document).bind("mousemove." + this.widgetName, this._mouseMoveDelegate).bind("mouseup." + this.widgetName, this._mouseUpDelegate), b.preventDefault(), c = !0, !0
    }, _mouseMove: function (b) {
        return!a.ui.ie || document.documentMode >= 9 || !!b.button ? this._mouseStarted ? (this._mouseDrag(b), b.preventDefault()) : (this._mouseDistanceMet(b) && this._mouseDelayMet(b) && (this._mouseStarted = this._mouseStart(this._mouseDownEvent, b) !== !1, this._mouseStarted ? this._mouseDrag(b) : this._mouseUp(b)), !this._mouseStarted) : this._mouseUp(b)
    }, _mouseUp: function (b) {
        return a(document).unbind("mousemove." + this.widgetName, this._mouseMoveDelegate).unbind("mouseup." + this.widgetName, this._mouseUpDelegate), this._mouseStarted && (this._mouseStarted = !1, b.target === this._mouseDownEvent.target && a.data(b.target, this.widgetName + ".preventClickEvent", !0), this._mouseStop(b)), !1
    }, _mouseDistanceMet: function (a) {
        return Math.max(Math.abs(this._mouseDownEvent.pageX - a.pageX), Math.abs(this._mouseDownEvent.pageY - a.pageY)) >= this.options.distance
    }, _mouseDelayMet: function (a) {
        return this.mouseDelayMet
    }, _mouseStart: function (a) {
    }, _mouseDrag: function (a) {
    }, _mouseStop: function (a) {
    }, _mouseCapture: function (a) {
        return!0
    }})
}(jQuery), function (a, b) {
    a.widget("ui.draggable", a.ui.mouse, {version: "1.9.2", widgetEventPrefix: "drag", options: {addClasses: !0, appendTo: "parent", axis: !1, connectToSortable: !1, containment: !1, cursor: "auto", cursorAt: !1, grid: !1, handle: !1, helper: "original", iframeFix: !1, opacity: !1, refreshPositions: !1, revert: !1, revertDuration: 500, scope: "default", scroll: !0, scrollSensitivity: 20, scrollSpeed: 20, snap: !1, snapMode: "both", snapTolerance: 20, stack: !1, zIndex: !1}, _create: function () {
        this.options.helper == "original" && !/^(?:r|a|f)/.test(this.element.css("position")) && (this.element[0].style.position = "relative"), this.options.addClasses && this.element.addClass("ui-draggable"), this.options.disabled && this.element.addClass("ui-draggable-disabled"), this._mouseInit()
    }, _destroy: function () {
        this.element.removeClass("ui-draggable ui-draggable-dragging ui-draggable-disabled"), this._mouseDestroy()
    }, _mouseCapture: function (b) {
        var c = this.options;
        return this.helper || c.disabled || a(b.target).is(".ui-resizable-handle") ? !1 : (this.handle = this._getHandle(b), this.handle ? (a(c.iframeFix === !0 ? "iframe" : c.iframeFix).each(function () {
            a('<div class="ui-draggable-iframeFix" style="background: #fff;"></div>').css({width: this.offsetWidth + "px", height: this.offsetHeight + "px", position: "absolute", opacity: "0.001", zIndex: 1e3}).css(a(this).offset()).appendTo("body")
        }), !0) : !1)
    }, _mouseStart: function (b) {
        var c = this.options;
        return this.helper = this._createHelper(b), this.helper.addClass("ui-draggable-dragging"), this._cacheHelperProportions(), a.ui.ddmanager && (a.ui.ddmanager.current = this), this._cacheMargins(), this.cssPosition = this.helper.css("position"), this.scrollParent = this.helper.scrollParent(), this.offset = this.positionAbs = this.element.offset(), this.offset = {top: this.offset.top - this.margins.top, left: this.offset.left - this.margins.left}, a.extend(this.offset, {click: {left: b.pageX - this.offset.left, top: b.pageY - this.offset.top}, parent: this._getParentOffset(), relative: this._getRelativeOffset()}), this.originalPosition = this.position = this._generatePosition(b), this.originalPageX = b.pageX, this.originalPageY = b.pageY, c.cursorAt && this._adjustOffsetFromHelper(c.cursorAt), c.containment && this._setContainment(), this._trigger("start", b) === !1 ? (this._clear(), !1) : (this._cacheHelperProportions(), a.ui.ddmanager && !c.dropBehaviour && a.ui.ddmanager.prepareOffsets(this, b), this._mouseDrag(b, !0), a.ui.ddmanager && a.ui.ddmanager.dragStart(this, b), !0)
    }, _mouseDrag: function (b, c) {
        this.position = this._generatePosition(b), this.positionAbs = this._convertPositionTo("absolute");
        if (!c) {
            var d = this._uiHash();
            if (this._trigger("drag", b, d) === !1)return this._mouseUp({}), !1;
            this.position = d.position
        }
        if (!this.options.axis || this.options.axis != "y")this.helper[0].style.left = this.position.left + "px";
        if (!this.options.axis || this.options.axis != "x")this.helper[0].style.top = this.position.top + "px";
        return a.ui.ddmanager && a.ui.ddmanager.drag(this, b), !1
    }, _mouseStop: function (b) {
        var c = !1;
        a.ui.ddmanager && !this.options.dropBehaviour && (c = a.ui.ddmanager.drop(this, b)), this.dropped && (c = this.dropped, this.dropped = !1);
        var d = this.element[0], e = !1;
        while (d && (d = d.parentNode))d == document && (e = !0);
        if (!e && this.options.helper === "original")return!1;
        if (this.options.revert == "invalid" && !c || this.options.revert == "valid" && c || this.options.revert === !0 || a.isFunction(this.options.revert) && this.options.revert.call(this.element, c)) {
            var f = this;
            a(this.helper).animate(this.originalPosition, parseInt(this.options.revertDuration, 10), function () {
                f._trigger("stop", b) !== !1 && f._clear()
            })
        } else this._trigger("stop", b) !== !1 && this._clear();
        return!1
    }, _mouseUp: function (b) {
        return a("div.ui-draggable-iframeFix").each(function () {
            this.parentNode.removeChild(this)
        }), a.ui.ddmanager && a.ui.ddmanager.dragStop(this, b), a.ui.mouse.prototype._mouseUp.call(this, b)
    }, cancel: function () {
        return this.helper.is(".ui-draggable-dragging") ? this._mouseUp({}) : this._clear(), this
    }, _getHandle: function (b) {
        var c = !this.options.handle || !a(this.options.handle, this.element).length ? !0 : !1;
        return a(this.options.handle, this.element).find("*").andSelf().each(function () {
            this == b.target && (c = !0)
        }), c
    }, _createHelper: function (b) {
        var c = this.options, d = a.isFunction(c.helper) ? a(c.helper.apply(this.element[0], [b])) : c.helper == "clone" ? this.element.clone().removeAttr("id") : this.element;
        return d.parents("body").length || d.appendTo(c.appendTo == "parent" ? this.element[0].parentNode : c.appendTo), d[0] != this.element[0] && !/(fixed|absolute)/.test(d.css("position")) && d.css("position", "absolute"), d
    }, _adjustOffsetFromHelper: function (b) {
        typeof b == "string" && (b = b.split(" ")), a.isArray(b) && (b = {left: +b[0], top: +b[1] || 0}), "left"in b && (this.offset.click.left = b.left + this.margins.left), "right"in b && (this.offset.click.left = this.helperProportions.width - b.right + this.margins.left), "top"in b && (this.offset.click.top = b.top + this.margins.top), "bottom"in b && (this.offset.click.top = this.helperProportions.height - b.bottom + this.margins.top)
    }, _getParentOffset: function () {
        this.offsetParent = this.helper.offsetParent();
        var b = this.offsetParent.offset();
        this.cssPosition == "absolute" && this.scrollParent[0] != document && a.contains(this.scrollParent[0], this.offsetParent[0]) && (b.left += this.scrollParent.scrollLeft(), b.top += this.scrollParent.scrollTop());
        if (this.offsetParent[0] == document.body || this.offsetParent[0].tagName && this.offsetParent[0].tagName.toLowerCase() == "html" && a.ui.ie)b = {top: 0, left: 0};
        return{top: b.top + (parseInt(this.offsetParent.css("borderTopWidth"), 10) || 0), left: b.left + (parseInt(this.offsetParent.css("borderLeftWidth"), 10) || 0)}
    }, _getRelativeOffset: function () {
        if (this.cssPosition == "relative") {
            var a = this.element.position();
            return{top: a.top - (parseInt(this.helper.css("top"), 10) || 0) + this.scrollParent.scrollTop(), left: a.left - (parseInt(this.helper.css("left"), 10) || 0) + this.scrollParent.scrollLeft()}
        }
        return{top: 0, left: 0}
    }, _cacheMargins: function () {
        this.margins = {left: parseInt(this.element.css("marginLeft"), 10) || 0, top: parseInt(this.element.css("marginTop"), 10) || 0, right: parseInt(this.element.css("marginRight"), 10) || 0, bottom: parseInt(this.element.css("marginBottom"), 10) || 0}
    }, _cacheHelperProportions: function () {
        this.helperProportions = {width: this.helper.outerWidth(), height: this.helper.outerHeight()}
    }, _setContainment: function () {
        var b = this.options;
        b.containment == "parent" && (b.containment = this.helper[0].parentNode);
        if (b.containment == "document" || b.containment == "window")this.containment = [b.containment == "document" ? 0 : a(window).scrollLeft() - this.offset.relative.left - this.offset.parent.left, b.containment == "document" ? 0 : a(window).scrollTop() - this.offset.relative.top - this.offset.parent.top, (b.containment == "document" ? 0 : a(window).scrollLeft()) + a(b.containment == "document" ? document : window).width() - this.helperProportions.width - this.margins.left, (b.containment == "document" ? 0 : a(window).scrollTop()) + (a(b.containment == "document" ? document : window).height() || document.body.parentNode.scrollHeight) - this.helperProportions.height - this.margins.top];
        if (!/^(document|window|parent)$/.test(b.containment) && b.containment.constructor != Array) {
            var c = a(b.containment), d = c[0];
            if (!d)return;
            var e = c.offset(), f = a(d).css("overflow") != "hidden";
            this.containment = [(parseInt(a(d).css("borderLeftWidth"), 10) || 0) + (parseInt(a(d).css("paddingLeft"), 10) || 0), (parseInt(a(d).css("borderTopWidth"), 10) || 0) + (parseInt(a(d).css("paddingTop"), 10) || 0), (f ? Math.max(d.scrollWidth, d.offsetWidth) : d.offsetWidth) - (parseInt(a(d).css("borderLeftWidth"), 10) || 0) - (parseInt(a(d).css("paddingRight"), 10) || 0) - this.helperProportions.width - this.margins.left - this.margins.right, (f ? Math.max(d.scrollHeight, d.offsetHeight) : d.offsetHeight) - (parseInt(a(d).css("borderTopWidth"), 10) || 0) - (parseInt(a(d).css("paddingBottom"), 10) || 0) - this.helperProportions.height - this.margins.top - this.margins.bottom], this.relative_container = c
        } else b.containment.constructor == Array && (this.containment = b.containment)
    }, _convertPositionTo: function (b, c) {
        c || (c = this.position);
        var d = b == "absolute" ? 1 : -1, e = this.options, f = this.cssPosition != "absolute" || this.scrollParent[0] != document && !!a.contains(this.scrollParent[0], this.offsetParent[0]) ? this.scrollParent : this.offsetParent, g = /(html|body)/i.test(f[0].tagName);
        return{top: c.top + this.offset.relative.top * d + this.offset.parent.top * d - (this.cssPosition == "fixed" ? -this.scrollParent.scrollTop() : g ? 0 : f.scrollTop()) * d, left: c.left + this.offset.relative.left * d + this.offset.parent.left * d - (this.cssPosition == "fixed" ? -this.scrollParent.scrollLeft() : g ? 0 : f.scrollLeft()) * d}
    }, _generatePosition: function (b) {
        var c = this.options, d = this.cssPosition != "absolute" || this.scrollParent[0] != document && !!a.contains(this.scrollParent[0], this.offsetParent[0]) ? this.scrollParent : this.offsetParent, e = /(html|body)/i.test(d[0].tagName), f = b.pageX, g = b.pageY;
        if (this.originalPosition) {
            var h;
            if (this.containment) {
                if (this.relative_container) {
                    var i = this.relative_container.offset();
                    h = [this.containment[0] + i.left, this.containment[1] + i.top, this.containment[2] + i.left, this.containment[3] + i.top]
                } else h = this.containment;
                b.pageX - this.offset.click.left < h[0] && (f = h[0] + this.offset.click.left), b.pageY - this.offset.click.top < h[1] && (g = h[1] + this.offset.click.top), b.pageX - this.offset.click.left > h[2] && (f = h[2] + this.offset.click.left), b.pageY - this.offset.click.top > h[3] && (g = h[3] + this.offset.click.top)
            }
            if (c.grid) {
                var j = c.grid[1] ? this.originalPageY + Math.round((g - this.originalPageY) / c.grid[1]) * c.grid[1] : this.originalPageY;
                g = h ? j - this.offset.click.top < h[1] || j - this.offset.click.top > h[3] ? j - this.offset.click.top < h[1] ? j + c.grid[1] : j - c.grid[1] : j : j;
                var k = c.grid[0] ? this.originalPageX + Math.round((f - this.originalPageX) / c.grid[0]) * c.grid[0] : this.originalPageX;
                f = h ? k - this.offset.click.left < h[0] || k - this.offset.click.left > h[2] ? k - this.offset.click.left < h[0] ? k + c.grid[0] : k - c.grid[0] : k : k
            }
        }
        return{top: g - this.offset.click.top - this.offset.relative.top - this.offset.parent.top + (this.cssPosition == "fixed" ? -this.scrollParent.scrollTop() : e ? 0 : d.scrollTop()), left: f - this.offset.click.left - this.offset.relative.left - this.offset.parent.left + (this.cssPosition == "fixed" ? -this.scrollParent.scrollLeft() : e ? 0 : d.scrollLeft())}
    }, _clear: function () {
        this.helper.removeClass("ui-draggable-dragging"), this.helper[0] != this.element[0] && !this.cancelHelperRemoval && this.helper.remove(), this.helper = null, this.cancelHelperRemoval = !1
    }, _trigger: function (b, c, d) {
        return d = d || this._uiHash(), a.ui.plugin.call(this, b, [c, d]), b == "drag" && (this.positionAbs = this._convertPositionTo("absolute")), a.Widget.prototype._trigger.call(this, b, c, d)
    }, plugins: {}, _uiHash: function (a) {
        return{helper: this.helper, position: this.position, originalPosition: this.originalPosition, offset: this.positionAbs}
    }}), a.ui.plugin.add("draggable", "connectToSortable", {start: function (b, c) {
        var d = a(this).data("draggable"), e = d.options, f = a.extend({}, c, {item: d.element});
        d.sortables = [], a(e.connectToSortable).each(function () {
            var c = a.data(this, "sortable");
            c && !c.options.disabled && (d.sortables.push({instance: c, shouldRevert: c.options.revert}), c.refreshPositions(), c._trigger("activate", b, f))
        })
    }, stop: function (b, c) {
        var d = a(this).data("draggable"), e = a.extend({}, c, {item: d.element});
        a.each(d.sortables, function () {
            this.instance.isOver ? (this.instance.isOver = 0, d.cancelHelperRemoval = !0, this.instance.cancelHelperRemoval = !1, this.shouldRevert && (this.instance.options.revert = !0), this.instance._mouseStop(b), this.instance.options.helper = this.instance.options._helper, d.options.helper == "original" && this.instance.currentItem.css({top: "auto", left: "auto"})) : (this.instance.cancelHelperRemoval = !1, this.instance._trigger("deactivate", b, e))
        })
    }, drag: function (b, c) {
        var d = a(this).data("draggable"), e = this, f = function (b) {
            var c = this.offset.click.top, d = this.offset.click.left, e = this.positionAbs.top, f = this.positionAbs.left, g = b.height, h = b.width, i = b.top, j = b.left;
            return a.ui.isOver(e + c, f + d, i, j, g, h)
        };
        a.each(d.sortables, function (f) {
            var g = !1, h = this;
            this.instance.positionAbs = d.positionAbs, this.instance.helperProportions = d.helperProportions, this.instance.offset.click = d.offset.click, this.instance._intersectsWith(this.instance.containerCache) && (g = !0, a.each(d.sortables, function () {
                return this.instance.positionAbs = d.positionAbs, this.instance.helperProportions = d.helperProportions, this.instance.offset.click = d.offset.click, this != h && this.instance._intersectsWith(this.instance.containerCache) && a.ui.contains(h.instance.element[0], this.instance.element[0]) && (g = !1), g
            })), g ? (this.instance.isOver || (this.instance.isOver = 1, this.instance.currentItem = a(e).clone().removeAttr("id").appendTo(this.instance.element).data("sortable-item", !0), this.instance.options._helper = this.instance.options.helper, this.instance.options.helper = function () {
                return c.helper[0]
            }, b.target = this.instance.currentItem[0], this.instance._mouseCapture(b, !0), this.instance._mouseStart(b, !0, !0), this.instance.offset.click.top = d.offset.click.top, this.instance.offset.click.left = d.offset.click.left, this.instance.offset.parent.left -= d.offset.parent.left - this.instance.offset.parent.left, this.instance.offset.parent.top -= d.offset.parent.top - this.instance.offset.parent.top, d._trigger("toSortable", b), d.dropped = this.instance.element, d.currentItem = d.element, this.instance.fromOutside = d), this.instance.currentItem && this.instance._mouseDrag(b)) : this.instance.isOver && (this.instance.isOver = 0, this.instance.cancelHelperRemoval = !0, this.instance.options.revert = !1, this.instance._trigger("out", b, this.instance._uiHash(this.instance)), this.instance._mouseStop(b, !0), this.instance.options.helper = this.instance.options._helper, this.instance.currentItem.remove(), this.instance.placeholder && this.instance.placeholder.remove(), d._trigger("fromSortable", b), d.dropped = !1)
        })
    }}), a.ui.plugin.add("draggable", "cursor", {start: function (b, c) {
        var d = a("body"), e = a(this).data("draggable").options;
        d.css("cursor") && (e._cursor = d.css("cursor")), d.css("cursor", e.cursor)
    }, stop: function (b, c) {
        var d = a(this).data("draggable").options;
        d._cursor && a("body").css("cursor", d._cursor)
    }}), a.ui.plugin.add("draggable", "opacity", {start: function (b, c) {
        var d = a(c.helper), e = a(this).data("draggable").options;
        d.css("opacity") && (e._opacity = d.css("opacity")), d.css("opacity", e.opacity)
    }, stop: function (b, c) {
        var d = a(this).data("draggable").options;
        d._opacity && a(c.helper).css("opacity", d._opacity)
    }}), a.ui.plugin.add("draggable", "scroll", {start: function (b, c) {
        var d = a(this).data("draggable");
        d.scrollParent[0] != document && d.scrollParent[0].tagName != "HTML" && (d.overflowOffset = d.scrollParent.offset())
    }, drag: function (b, c) {
        var d = a(this).data("draggable"), e = d.options, f = !1;
        if (d.scrollParent[0] != document && d.scrollParent[0].tagName != "HTML") {
            if (!e.axis || e.axis != "x")d.overflowOffset.top + d.scrollParent[0].offsetHeight - b.pageY < e.scrollSensitivity ? d.scrollParent[0].scrollTop = f = d.scrollParent[0].scrollTop + e.scrollSpeed : b.pageY - d.overflowOffset.top < e.scrollSensitivity && (d.scrollParent[0].scrollTop = f = d.scrollParent[0].scrollTop - e.scrollSpeed);
            if (!e.axis || e.axis != "y")d.overflowOffset.left + d.scrollParent[0].offsetWidth - b.pageX < e.scrollSensitivity ? d.scrollParent[0].scrollLeft = f = d.scrollParent[0].scrollLeft + e.scrollSpeed : b.pageX - d.overflowOffset.left < e.scrollSensitivity && (d.scrollParent[0].scrollLeft = f = d.scrollParent[0].scrollLeft - e.scrollSpeed)
        } else {
            if (!e.axis || e.axis != "x")b.pageY - a(document).scrollTop() < e.scrollSensitivity ? f = a(document).scrollTop(a(document).scrollTop() - e.scrollSpeed) : a(window).height() - (b.pageY - a(document).scrollTop()) < e.scrollSensitivity && (f = a(document).scrollTop(a(document).scrollTop() + e.scrollSpeed));
            if (!e.axis || e.axis != "y")b.pageX - a(document).scrollLeft() < e.scrollSensitivity ? f = a(document).scrollLeft(a(document).scrollLeft() - e.scrollSpeed) : a(window).width() - (b.pageX - a(document).scrollLeft()) < e.scrollSensitivity && (f = a(document).scrollLeft(a(document).scrollLeft() + e.scrollSpeed))
        }
        f !== !1 && a.ui.ddmanager && !e.dropBehaviour && a.ui.ddmanager.prepareOffsets(d, b)
    }}), a.ui.plugin.add("draggable", "snap", {start: function (b, c) {
        var d = a(this).data("draggable"), e = d.options;
        d.snapElements = [], a(e.snap.constructor != String ? e.snap.items || ":data(draggable)" : e.snap).each(function () {
            var b = a(this), c = b.offset();
            this != d.element[0] && d.snapElements.push({item: this, width: b.outerWidth(), height: b.outerHeight(), top: c.top, left: c.left})
        })
    }, drag: function (b, c) {
        var d = a(this).data("draggable"), e = d.options, f = e.snapTolerance, g = c.offset.left, h = g + d.helperProportions.width, i = c.offset.top, j = i + d.helperProportions.height;
        for (var k = d.snapElements.length - 1; k >= 0; k--) {
            var l = d.snapElements[k].left, m = l + d.snapElements[k].width, n = d.snapElements[k].top, o = n + d.snapElements[k].height;
            if (!(l - f < g && g < m + f && n - f < i && i < o + f || l - f < g && g < m + f && n - f < j && j < o + f || l - f < h && h < m + f && n - f < i && i < o + f || l - f < h && h < m + f && n - f < j && j < o + f)) {
                d.snapElements[k].snapping && d.options.snap.release && d.options.snap.release.call(d.element, b, a.extend(d._uiHash(), {snapItem: d.snapElements[k].item})), d.snapElements[k].snapping = !1;
                continue
            }
            if (e.snapMode != "inner") {
                var p = Math.abs(n - j) <= f, q = Math.abs(o - i) <= f, r = Math.abs(l - h) <= f, s = Math.abs(m - g) <= f;
                p && (c.position.top = d._convertPositionTo("relative", {top: n - d.helperProportions.height, left: 0}).top - d.margins.top), q && (c.position.top = d._convertPositionTo("relative", {top: o, left: 0}).top - d.margins.top), r && (c.position.left = d._convertPositionTo("relative", {top: 0, left: l - d.helperProportions.width}).left - d.margins.left), s && (c.position.left = d._convertPositionTo("relative", {top: 0, left: m}).left - d.margins.left)
            }
            var t = p || q || r || s;
            if (e.snapMode != "outer") {
                var p = Math.abs(n - i) <= f, q = Math.abs(o - j) <= f, r = Math.abs(l - g) <= f, s = Math.abs(m - h) <= f;
                p && (c.position.top = d._convertPositionTo("relative", {top: n, left: 0}).top - d.margins.top), q && (c.position.top = d._convertPositionTo("relative", {top: o - d.helperProportions.height, left: 0}).top - d.margins.top), r && (c.position.left = d._convertPositionTo("relative", {top: 0, left: l}).left - d.margins.left), s && (c.position.left = d._convertPositionTo("relative", {top: 0, left: m - d.helperProportions.width}).left - d.margins.left)
            }
            !d.snapElements[k].snapping && (p || q || r || s || t) && d.options.snap.snap && d.options.snap.snap.call(d.element, b, a.extend(d._uiHash(), {snapItem: d.snapElements[k].item})), d.snapElements[k].snapping = p || q || r || s || t
        }
    }}), a.ui.plugin.add("draggable", "stack", {start: function (b, c) {
        var d = a(this).data("draggable").options, e = a.makeArray(a(d.stack)).sort(function (b, c) {
            return(parseInt(a(b).css("zIndex"), 10) || 0) - (parseInt(a(c).css("zIndex"), 10) || 0)
        });
        if (!e.length)return;
        var f = parseInt(e[0].style.zIndex) || 0;
        a(e).each(function (a) {
            this.style.zIndex = f + a
        }), this[0].style.zIndex = f + e.length
    }}), a.ui.plugin.add("draggable", "zIndex", {start: function (b, c) {
        var d = a(c.helper), e = a(this).data("draggable").options;
        d.css("zIndex") && (e._zIndex = d.css("zIndex")), d.css("zIndex", e.zIndex)
    }, stop: function (b, c) {
        var d = a(this).data("draggable").options;
        d._zIndex && a(c.helper).css("zIndex", d._zIndex)
    }})
}(jQuery), function (a, b) {
    a.widget("ui.droppable", {version: "1.9.2", widgetEventPrefix: "drop", options: {accept: "*", activeClass: !1, addClasses: !0, greedy: !1, hoverClass: !1, scope: "default", tolerance: "intersect"}, _create: function () {
        var b = this.options, c = b.accept;
        this.isover = 0, this.isout = 1, this.accept = a.isFunction(c) ? c : function (a) {
            return a.is(c)
        }, this.proportions = {width: this.element[0].offsetWidth, height: this.element[0].offsetHeight}, a.ui.ddmanager.droppables[b.scope] = a.ui.ddmanager.droppables[b.scope] || [], a.ui.ddmanager.droppables[b.scope].push(this), b.addClasses && this.element.addClass("ui-droppable")
    }, _destroy: function () {
        var b = a.ui.ddmanager.droppables[this.options.scope];
        for (var c = 0; c < b.length; c++)b[c] == this && b.splice(c, 1);
        this.element.removeClass("ui-droppable ui-droppable-disabled")
    }, _setOption: function (b, c) {
        b == "accept" && (this.accept = a.isFunction(c) ? c : function (a) {
            return a.is(c)
        }), a.Widget.prototype._setOption.apply(this, arguments)
    }, _activate: function (b) {
        var c = a.ui.ddmanager.current;
        this.options.activeClass && this.element.addClass(this.options.activeClass), c && this._trigger("activate", b, this.ui(c))
    }, _deactivate: function (b) {
        var c = a.ui.ddmanager.current;
        this.options.activeClass && this.element.removeClass(this.options.activeClass), c && this._trigger("deactivate", b, this.ui(c))
    }, _over: function (b) {
        var c = a.ui.ddmanager.current;
        if (!c || (c.currentItem || c.element)[0] == this.element[0])return;
        this.accept.call(this.element[0], c.currentItem || c.element) && (this.options.hoverClass && this.element.addClass(this.options.hoverClass), this._trigger("over", b, this.ui(c)))
    }, _out: function (b) {
        var c = a.ui.ddmanager.current;
        if (!c || (c.currentItem || c.element)[0] == this.element[0])return;
        this.accept.call(this.element[0], c.currentItem || c.element) && (this.options.hoverClass && this.element.removeClass(this.options.hoverClass), this._trigger("out", b, this.ui(c)))
    }, _drop: function (b, c) {
        var d = c || a.ui.ddmanager.current;
        if (!d || (d.currentItem || d.element)[0] == this.element[0])return!1;
        var e = !1;
        return this.element.find(":data(droppable)").not(".ui-draggable-dragging").each(function () {
            var b = a.data(this, "droppable");
            if (b.options.greedy && !b.options.disabled && b.options.scope == d.options.scope && b.accept.call(b.element[0], d.currentItem || d.element) && a.ui.intersect(d, a.extend(b, {offset: b.element.offset()}), b.options.tolerance))return e = !0, !1
        }), e ? !1 : this.accept.call(this.element[0], d.currentItem || d.element) ? (this.options.activeClass && this.element.removeClass(this.options.activeClass), this.options.hoverClass && this.element.removeClass(this.options.hoverClass), this._trigger("drop", b, this.ui(d)), this.element) : !1
    }, ui: function (a) {
        return{draggable: a.currentItem || a.element, helper: a.helper, position: a.position, offset: a.positionAbs}
    }}), a.ui.intersect = function (b, c, d) {
        if (!c.offset)return!1;
        var e = (b.positionAbs || b.position.absolute).left, f = e + b.helperProportions.width, g = (b.positionAbs || b.position.absolute).top, h = g + b.helperProportions.height, i = c.offset.left, j = i + c.proportions.width, k = c.offset.top, l = k + c.proportions.height;
        switch (d) {
            case"fit":
                return i <= e && f <= j && k <= g && h <= l;
            case"intersect":
                return i < e + b.helperProportions.width / 2 && f - b.helperProportions.width / 2 < j && k < g + b.helperProportions.height / 2 && h - b.helperProportions.height / 2 < l;
            case"pointer":
                var m = (b.positionAbs || b.position.absolute).left + (b.clickOffset || b.offset.click).left, n = (b.positionAbs || b.position.absolute).top + (b.clickOffset || b.offset.click).top, o = a.ui.isOver(n, m, k, i, c.proportions.height, c.proportions.width);
                return o;
            case"touch":
                return(g >= k && g <= l || h >= k && h <= l || g < k && h > l) && (e >= i && e <= j || f >= i && f <= j || e < i && f > j);
            default:
                return!1
        }
    }, a.ui.ddmanager = {current: null, droppables: {"default": []}, prepareOffsets: function (b, c) {
        var d = a.ui.ddmanager.droppables[b.options.scope] || [], e = c ? c.type : null, f = (b.currentItem || b.element).find(":data(droppable)").andSelf();
        a:for (var g = 0; g < d.length; g++) {
            if (d[g].options.disabled || b && !d[g].accept.call(d[g].element[0], b.currentItem || b.element))continue;
            for (var h = 0; h < f.length; h++)if (f[h] == d[g].element[0]) {
                d[g].proportions.height = 0;
                continue a
            }
            d[g].visible = d[g].element.css("display") != "none";
            if (!d[g].visible)continue;
            e == "mousedown" && d[g]._activate.call(d[g], c), d[g].offset = d[g].element.offset(), d[g].proportions = {width: d[g].element[0].offsetWidth, height: d[g].element[0].offsetHeight}
        }
    }, drop: function (b, c) {
        var d = !1;
        return a.each(a.ui.ddmanager.droppables[b.options.scope] || [], function () {
            if (!this.options)return;
            !this.options.disabled && this.visible && a.ui.intersect(b, this, this.options.tolerance) && (d = this._drop.call(this, c) || d), !this.options.disabled && this.visible && this.accept.call(this.element[0], b.currentItem || b.element) && (this.isout = 1, this.isover = 0, this._deactivate.call(this, c))
        }), d
    }, dragStart: function (b, c) {
        b.element.parentsUntil("body").bind("scroll.droppable", function () {
            b.options.refreshPositions || a.ui.ddmanager.prepareOffsets(b, c)
        })
    }, drag: function (b, c) {
        b.options.refreshPositions && a.ui.ddmanager.prepareOffsets(b, c), a.each(a.ui.ddmanager.droppables[b.options.scope] || [], function () {
            if (this.options.disabled ||
                this.greedyChild || !this.visible)return;
            var d = a.ui.intersect(b, this, this.options.tolerance), e = !d && this.isover == 1 ? "isout" : d && this.isover == 0 ? "isover" : null;
            if (!e)return;
            var f;
            if (this.options.greedy) {
                var g = this.options.scope, h = this.element.parents(":data(droppable)").filter(function () {
                    return a.data(this, "droppable").options.scope === g
                });
                h.length && (f = a.data(h[0], "droppable"), f.greedyChild = e == "isover" ? 1 : 0)
            }
            f && e == "isover" && (f.isover = 0, f.isout = 1, f._out.call(f, c)), this[e] = 1, this[e == "isout" ? "isover" : "isout"] = 0, this[e == "isover" ? "_over" : "_out"].call(this, c), f && e == "isout" && (f.isout = 0, f.isover = 1, f._over.call(f, c))
        })
    }, dragStop: function (b, c) {
        b.element.parentsUntil("body").unbind("scroll.droppable"), b.options.refreshPositions || a.ui.ddmanager.prepareOffsets(b, c)
    }}
}(jQuery), function (a, b) {
    a.widget("ui.resizable", a.ui.mouse, {version: "1.9.2", widgetEventPrefix: "resize", options: {alsoResize: !1, animate: !1, animateDuration: "slow", animateEasing: "swing", aspectRatio: !1, autoHide: !1, containment: !1, ghost: !1, grid: !1, handles: "e,s,se", helper: !1, maxHeight: null, maxWidth: null, minHeight: 10, minWidth: 10, zIndex: 1e3}, _create: function () {
        var b = this, c = this.options;
        this.element.addClass("ui-resizable"), a.extend(this, {_aspectRatio: !!c.aspectRatio, aspectRatio: c.aspectRatio, originalElement: this.element, _proportionallyResizeElements: [], _helper: c.helper || c.ghost || c.animate ? c.helper || "ui-resizable-helper" : null}), this.element[0].nodeName.match(/canvas|textarea|input|select|button|img/i) && (this.element.wrap(a('<div class="ui-wrapper" style="overflow: hidden;"></div>').css({position: this.element.css("position"), width: this.element.outerWidth(), height: this.element.outerHeight(), top: this.element.css("top"), left: this.element.css("left")})), this.element = this.element.parent().data("resizable", this.element.data("resizable")), this.elementIsWrapper = !0, this.element.css({marginLeft: this.originalElement.css("marginLeft"), marginTop: this.originalElement.css("marginTop"), marginRight: this.originalElement.css("marginRight"), marginBottom: this.originalElement.css("marginBottom")}), this.originalElement.css({marginLeft: 0, marginTop: 0, marginRight: 0, marginBottom: 0}), this.originalResizeStyle = this.originalElement.css("resize"), this.originalElement.css("resize", "none"), this._proportionallyResizeElements.push(this.originalElement.css({position: "static", zoom: 1, display: "block"})), this.originalElement.css({margin: this.originalElement.css("margin")}), this._proportionallyResize()), this.handles = c.handles || (a(".ui-resizable-handle", this.element).length ? {n: ".ui-resizable-n", e: ".ui-resizable-e", s: ".ui-resizable-s", w: ".ui-resizable-w", se: ".ui-resizable-se", sw: ".ui-resizable-sw", ne: ".ui-resizable-ne", nw: ".ui-resizable-nw"} : "e,s,se");
        if (this.handles.constructor == String) {
            this.handles == "all" && (this.handles = "n,e,s,w,se,sw,ne,nw");
            var d = this.handles.split(",");
            this.handles = {};
            for (var e = 0; e < d.length; e++) {
                var f = a.trim(d[e]), g = "ui-resizable-" + f, h = a('<div class="ui-resizable-handle ' + g + '"></div>');
                h.css({zIndex: c.zIndex}), "se" == f && h.addClass("ui-icon ui-icon-gripsmall-diagonal-se"), this.handles[f] = ".ui-resizable-" + f, this.element.append(h)
            }
        }
        this._renderAxis = function (b) {
            b = b || this.element;
            for (var c in this.handles) {
                this.handles[c].constructor == String && (this.handles[c] = a(this.handles[c], this.element).show());
                if (this.elementIsWrapper && this.originalElement[0].nodeName.match(/textarea|input|select|button/i)) {
                    var d = a(this.handles[c], this.element), e = 0;
                    e = /sw|ne|nw|se|n|s/.test(c) ? d.outerHeight() : d.outerWidth();
                    var f = ["padding", /ne|nw|n/.test(c) ? "Top" : /se|sw|s/.test(c) ? "Bottom" : /^e$/.test(c) ? "Right" : "Left"].join("");
                    b.css(f, e), this._proportionallyResize()
                }
                if (!a(this.handles[c]).length)continue
            }
        }, this._renderAxis(this.element), this._handles = a(".ui-resizable-handle", this.element).disableSelection(), this._handles.mouseover(function () {
            if (!b.resizing) {
                if (this.className)var a = this.className.match(/ui-resizable-(se|sw|ne|nw|n|e|s|w)/i);
                b.axis = a && a[1] ? a[1] : "se"
            }
        }), c.autoHide && (this._handles.hide(), a(this.element).addClass("ui-resizable-autohide").mouseenter(function () {
            if (c.disabled)return;
            a(this).removeClass("ui-resizable-autohide"), b._handles.show()
        }).mouseleave(function () {
            if (c.disabled)return;
            b.resizing || (a(this).addClass("ui-resizable-autohide"), b._handles.hide())
        })), this._mouseInit()
    }, _destroy: function () {
        this._mouseDestroy();
        var b = function (b) {
            a(b).removeClass("ui-resizable ui-resizable-disabled ui-resizable-resizing").removeData("resizable").removeData("ui-resizable").unbind(".resizable").find(".ui-resizable-handle").remove()
        };
        if (this.elementIsWrapper) {
            b(this.element);
            var c = this.element;
            this.originalElement.css({position: c.css("position"), width: c.outerWidth(), height: c.outerHeight(), top: c.css("top"), left: c.css("left")}).insertAfter(c), c.remove()
        }
        return this.originalElement.css("resize", this.originalResizeStyle), b(this.originalElement), this
    }, _mouseCapture: function (b) {
        var c = !1;
        for (var d in this.handles)a(this.handles[d])[0] == b.target && (c = !0);
        return!this.options.disabled && c
    }, _mouseStart: function (b) {
        var d = this.options, e = this.element.position(), f = this.element;
        this.resizing = !0, this.documentScroll = {top: a(document).scrollTop(), left: a(document).scrollLeft()}, (f.is(".ui-draggable") || /absolute/.test(f.css("position"))) && f.css({position: "absolute", top: e.top, left: e.left}), this._renderProxy();
        var g = c(this.helper.css("left")), h = c(this.helper.css("top"));
        d.containment && (g += a(d.containment).scrollLeft() || 0, h += a(d.containment).scrollTop() || 0), this.offset = this.helper.offset(), this.position = {left: g, top: h}, this.size = this._helper ? {width: f.outerWidth(), height: f.outerHeight()} : {width: f.width(), height: f.height()}, this.originalSize = this._helper ? {width: f.outerWidth(), height: f.outerHeight()} : {width: f.width(), height: f.height()}, this.originalPosition = {left: g, top: h}, this.sizeDiff = {width: f.outerWidth() - f.width(), height: f.outerHeight() - f.height()}, this.originalMousePosition = {left: b.pageX, top: b.pageY}, this.aspectRatio = typeof d.aspectRatio == "number" ? d.aspectRatio : this.originalSize.width / this.originalSize.height || 1;
        var i = a(".ui-resizable-" + this.axis).css("cursor");
        return a("body").css("cursor", i == "auto" ? this.axis + "-resize" : i), f.addClass("ui-resizable-resizing"), this._propagate("start", b), !0
    }, _mouseDrag: function (a) {
        var b = this.helper, c = this.options, d = {}, e = this, f = this.originalMousePosition, g = this.axis, h = a.pageX - f.left || 0, i = a.pageY - f.top || 0, j = this._change[g];
        if (!j)return!1;
        var k = j.apply(this, [a, h, i]);
        this._updateVirtualBoundaries(a.shiftKey);
        if (this._aspectRatio || a.shiftKey)k = this._updateRatio(k, a);
        return k = this._respectSize(k, a), this._propagate("resize", a), b.css({top: this.position.top + "px", left: this.position.left + "px", width: this.size.width + "px", height: this.size.height + "px"}), !this._helper && this._proportionallyResizeElements.length && this._proportionallyResize(), this._updateCache(k), this._trigger("resize", a, this.ui()), !1
    }, _mouseStop: function (b) {
        this.resizing = !1;
        var c = this.options, d = this;
        if (this._helper) {
            var e = this._proportionallyResizeElements, f = e.length && /textarea/i.test(e[0].nodeName), g = f && a.ui.hasScroll(e[0], "left") ? 0 : d.sizeDiff.height, h = f ? 0 : d.sizeDiff.width, i = {width: d.helper.width() - h, height: d.helper.height() - g}, j = parseInt(d.element.css("left"), 10) + (d.position.left - d.originalPosition.left) || null, k = parseInt(d.element.css("top"), 10) + (d.position.top - d.originalPosition.top) || null;
            c.animate || this.element.css(a.extend(i, {top: k, left: j})), d.helper.height(d.size.height), d.helper.width(d.size.width), this._helper && !c.animate && this._proportionallyResize()
        }
        return a("body").css("cursor", "auto"), this.element.removeClass("ui-resizable-resizing"), this._propagate("stop", b), this._helper && this.helper.remove(), !1
    }, _updateVirtualBoundaries: function (a) {
        var b = this.options, c, e, f, g, h;
        h = {minWidth: d(b.minWidth) ? b.minWidth : 0, maxWidth: d(b.maxWidth) ? b.maxWidth : Infinity, minHeight: d(b.minHeight) ? b.minHeight : 0, maxHeight: d(b.maxHeight) ? b.maxHeight : Infinity};
        if (this._aspectRatio || a)c = h.minHeight * this.aspectRatio, f = h.minWidth / this.aspectRatio, e = h.maxHeight * this.aspectRatio, g = h.maxWidth / this.aspectRatio, c > h.minWidth && (h.minWidth = c), f > h.minHeight && (h.minHeight = f), e < h.maxWidth && (h.maxWidth = e), g < h.maxHeight && (h.maxHeight = g);
        this._vBoundaries = h
    }, _updateCache: function (a) {
        var b = this.options;
        this.offset = this.helper.offset(), d(a.left) && (this.position.left = a.left), d(a.top) && (this.position.top = a.top), d(a.height) && (this.size.height = a.height), d(a.width) && (this.size.width = a.width)
    }, _updateRatio: function (a, b) {
        var c = this.options, e = this.position, f = this.size, g = this.axis;
        return d(a.height) ? a.width = a.height * this.aspectRatio : d(a.width) && (a.height = a.width / this.aspectRatio), g == "sw" && (a.left = e.left + (f.width - a.width), a.top = null), g == "nw" && (a.top = e.top + (f.height - a.height), a.left = e.left + (f.width - a.width)), a
    }, _respectSize: function (a, b) {
        var c = this.helper, e = this._vBoundaries, f = this._aspectRatio || b.shiftKey, g = this.axis, h = d(a.width) && e.maxWidth && e.maxWidth < a.width, i = d(a.height) && e.maxHeight && e.maxHeight < a.height, j = d(a.width) && e.minWidth && e.minWidth > a.width, k = d(a.height) && e.minHeight && e.minHeight > a.height;
        j && (a.width = e.minWidth), k && (a.height = e.minHeight), h && (a.width = e.maxWidth), i && (a.height = e.maxHeight);
        var l = this.originalPosition.left + this.originalSize.width, m = this.position.top + this.size.height, n = /sw|nw|w/.test(g), o = /nw|ne|n/.test(g);
        j && n && (a.left = l - e.minWidth), h && n && (a.left = l - e.maxWidth), k && o && (a.top = m - e.minHeight), i && o && (a.top = m - e.maxHeight);
        var p = !a.width && !a.height;
        return p && !a.left && a.top ? a.top = null : p && !a.top && a.left && (a.left = null), a
    }, _proportionallyResize: function () {
        var b = this.options;
        if (!this._proportionallyResizeElements.length)return;
        var c = this.helper || this.element;
        for (var d = 0; d < this._proportionallyResizeElements.length; d++) {
            var e = this._proportionallyResizeElements[d];
            if (!this.borderDif) {
                var f = [e.css("borderTopWidth"), e.css("borderRightWidth"), e.css("borderBottomWidth"), e.css("borderLeftWidth")], g = [e.css("paddingTop"), e.css("paddingRight"), e.css("paddingBottom"), e.css("paddingLeft")];
                this.borderDif = a.map(f, function (a, b) {
                    var c = parseInt(a, 10) || 0, d = parseInt(g[b], 10) || 0;
                    return c + d
                })
            }
            e.css({height: c.height() - this.borderDif[0] - this.borderDif[2] || 0, width: c.width() - this.borderDif[1] - this.borderDif[3] || 0})
        }
    }, _renderProxy: function () {
        var b = this.element, c = this.options;
        this.elementOffset = b.offset();
        if (this._helper) {
            this.helper = this.helper || a('<div style="overflow:hidden;"></div>');
            var d = a.ui.ie6 ? 1 : 0, e = a.ui.ie6 ? 2 : -1;
            this.helper.addClass(this._helper).css({width: this.element.outerWidth() + e, height: this.element.outerHeight() + e, position: "absolute", left: this.elementOffset.left - d + "px", top: this.elementOffset.top - d + "px", zIndex: ++c.zIndex}), this.helper.appendTo("body").disableSelection()
        } else this.helper = this.element
    }, _change: {e: function (a, b, c) {
        return{width: this.originalSize.width + b}
    }, w: function (a, b, c) {
        var d = this.options, e = this.originalSize, f = this.originalPosition;
        return{left: f.left + b, width: e.width - b}
    }, n: function (a, b, c) {
        var d = this.options, e = this.originalSize, f = this.originalPosition;
        return{top: f.top + c, height: e.height - c}
    }, s: function (a, b, c) {
        return{height: this.originalSize.height + c}
    }, se: function (b, c, d) {
        return a.extend(this._change.s.apply(this, arguments), this._change.e.apply(this, [b, c, d]))
    }, sw: function (b, c, d) {
        return a.extend(this._change.s.apply(this, arguments), this._change.w.apply(this, [b, c, d]))
    }, ne: function (b, c, d) {
        return a.extend(this._change.n.apply(this, arguments), this._change.e.apply(this, [b, c, d]))
    }, nw: function (b, c, d) {
        return a.extend(this._change.n.apply(this, arguments), this._change.w.apply(this, [b, c, d]))
    }}, _propagate: function (b, c) {
        a.ui.plugin.call(this, b, [c, this.ui()]), b != "resize" && this._trigger(b, c, this.ui())
    }, plugins: {}, ui: function () {
        return{originalElement: this.originalElement, element: this.element, helper: this.helper, position: this.position, size: this.size, originalSize: this.originalSize, originalPosition: this.originalPosition}
    }}), a.ui.plugin.add("resizable", "alsoResize", {start: function (b, c) {
        var d = a(this).data("resizable"), e = d.options, f = function (b) {
            a(b).each(function () {
                var b = a(this);
                b.data("resizable-alsoresize", {width: parseInt(b.width(), 10), height: parseInt(b.height(), 10), left: parseInt(b.css("left"), 10), top: parseInt(b.css("top"), 10)})
            })
        };
        typeof e.alsoResize == "object" && !e.alsoResize.parentNode ? e.alsoResize.length ? (e.alsoResize = e.alsoResize[0], f(e.alsoResize)) : a.each(e.alsoResize, function (a) {
            f(a)
        }) : f(e.alsoResize)
    }, resize: function (b, c) {
        var d = a(this).data("resizable"), e = d.options, f = d.originalSize, g = d.originalPosition, h = {height: d.size.height - f.height || 0, width: d.size.width - f.width || 0, top: d.position.top - g.top || 0, left: d.position.left - g.left || 0}, i = function (b, d) {
            a(b).each(function () {
                var b = a(this), e = a(this).data("resizable-alsoresize"), f = {}, g = d && d.length ? d : b.parents(c.originalElement[0]).length ? ["width", "height"] : ["width", "height", "top", "left"];
                a.each(g, function (a, b) {
                    var c = (e[b] || 0) + (h[b] || 0);
                    c && c >= 0 && (f[b] = c || null)
                }), b.css(f)
            })
        };
        typeof e.alsoResize == "object" && !e.alsoResize.nodeType ? a.each(e.alsoResize, function (a, b) {
            i(a, b)
        }) : i(e.alsoResize)
    }, stop: function (b, c) {
        a(this).removeData("resizable-alsoresize")
    }}), a.ui.plugin.add("resizable", "animate", {stop: function (b, c) {
        var d = a(this).data("resizable"), e = d.options, f = d._proportionallyResizeElements, g = f.length && /textarea/i.test(f[0].nodeName), h = g && a.ui.hasScroll(f[0], "left") ? 0 : d.sizeDiff.height, i = g ? 0 : d.sizeDiff.width, j = {width: d.size.width - i, height: d.size.height - h}, k = parseInt(d.element.css("left"), 10) + (d.position.left - d.originalPosition.left) || null, l = parseInt(d.element.css("top"), 10) + (d.position.top - d.originalPosition.top) || null;
        d.element.animate(a.extend(j, l && k ? {top: l, left: k} : {}), {duration: e.animateDuration, easing: e.animateEasing, step: function () {
            var c = {width: parseInt(d.element.css("width"), 10), height: parseInt(d.element.css("height"), 10), top: parseInt(d.element.css("top"), 10), left: parseInt(d.element.css("left"), 10)};
            f && f.length && a(f[0]).css({width: c.width, height: c.height}), d._updateCache(c), d._propagate("resize", b)
        }})
    }}), a.ui.plugin.add("resizable", "containment", {start: function (b, d) {
        var e = a(this).data("resizable"), f = e.options, g = e.element, h = f.containment, i = h instanceof a ? h.get(0) : /parent/.test(h) ? g.parent().get(0) : h;
        if (!i)return;
        e.containerElement = a(i);
        if (/document/.test(h) || h == document)e.containerOffset = {left: 0, top: 0}, e.containerPosition = {left: 0, top: 0}, e.parentData = {element: a(document), left: 0, top: 0, width: a(document).width(), height: a(document).height() || document.body.parentNode.scrollHeight}; else {
            var j = a(i), k = [];
            a(["Top", "Right", "Left", "Bottom"]).each(function (a, b) {
                k[a] = c(j.css("padding" + b))
            }), e.containerOffset = j.offset(), e.containerPosition = j.position(), e.containerSize = {height: j.innerHeight() - k[3], width: j.innerWidth() - k[1]};
            var l = e.containerOffset, m = e.containerSize.height, n = e.containerSize.width, o = a.ui.hasScroll(i, "left") ? i.scrollWidth : n, p = a.ui.hasScroll(i) ? i.scrollHeight : m;
            e.parentData = {element: i, left: l.left, top: l.top, width: o, height: p}
        }
    }, resize: function (b, c) {
        var d = a(this).data("resizable"), e = d.options, f = d.containerSize, g = d.containerOffset, h = d.size, i = d.position, j = d._aspectRatio || b.shiftKey, k = {top: 0, left: 0}, l = d.containerElement;
        l[0] != document && /static/.test(l.css("position")) && (k = g), i.left < (d._helper ? g.left : 0) && (d.size.width = d.size.width + (d._helper ? d.position.left - g.left : d.position.left - k.left), j && (d.size.height = d.size.width / d.aspectRatio), d.position.left = e.helper ? g.left : 0), i.top < (d._helper ? g.top : 0) && (d.size.height = d.size.height + (d._helper ? d.position.top - g.top : d.position.top), j && (d.size.width = d.size.height * d.aspectRatio), d.position.top = d._helper ? g.top : 0), d.offset.left = d.parentData.left + d.position.left, d.offset.top = d.parentData.top + d.position.top;
        var m = Math.abs((d._helper ? d.offset.left - k.left : d.offset.left - k.left) + d.sizeDiff.width), n = Math.abs((d._helper ? d.offset.top - k.top : d.offset.top - g.top) + d.sizeDiff.height), o = d.containerElement.get(0) == d.element.parent().get(0), p = /relative|absolute/.test(d.containerElement.css("position"));
        o && p && (m -= d.parentData.left), m + d.size.width >= d.parentData.width && (d.size.width = d.parentData.width - m, j && (d.size.height = d.size.width / d.aspectRatio)), n + d.size.height >= d.parentData.height && (d.size.height = d.parentData.height - n, j && (d.size.width = d.size.height * d.aspectRatio))
    }, stop: function (b, c) {
        var d = a(this).data("resizable"), e = d.options, f = d.position, g = d.containerOffset, h = d.containerPosition, i = d.containerElement, j = a(d.helper), k = j.offset(), l = j.outerWidth() - d.sizeDiff.width, m = j.outerHeight() - d.sizeDiff.height;
        d._helper && !e.animate && /relative/.test(i.css("position")) && a(this).css({left: k.left - h.left - g.left, width: l, height: m}), d._helper && !e.animate && /static/.test(i.css("position")) && a(this).css({left: k.left - h.left - g.left, width: l, height: m})
    }}), a.ui.plugin.add("resizable", "ghost", {start: function (b, c) {
        var d = a(this).data("resizable"), e = d.options, f = d.size;
        d.ghost = d.originalElement.clone(), d.ghost.css({opacity: .25, display: "block", position: "relative", height: f.height, width: f.width, margin: 0, left: 0, top: 0}).addClass("ui-resizable-ghost").addClass(typeof e.ghost == "string" ? e.ghost : ""), d.ghost.appendTo(d.helper)
    }, resize: function (b, c) {
        var d = a(this).data("resizable"), e = d.options;
        d.ghost && d.ghost.css({position: "relative", height: d.size.height, width: d.size.width})
    }, stop: function (b, c) {
        var d = a(this).data("resizable"), e = d.options;
        d.ghost && d.helper && d.helper.get(0).removeChild(d.ghost.get(0))
    }}), a.ui.plugin.add("resizable", "grid", {resize: function (b, c) {
        var d = a(this).data("resizable"), e = d.options, f = d.size, g = d.originalSize, h = d.originalPosition, i = d.axis, j = e._aspectRatio || b.shiftKey;
        e.grid = typeof e.grid == "number" ? [e.grid, e.grid] : e.grid;
        var k = Math.round((f.width - g.width) / (e.grid[0] || 1)) * (e.grid[0] || 1), l = Math.round((f.height - g.height) / (e.grid[1] || 1)) * (e.grid[1] || 1);
        /^(se|s|e)$/.test(i) ? (d.size.width = g.width + k, d.size.height = g.height + l) : /^(ne)$/.test(i) ? (d.size.width = g.width + k, d.size.height = g.height + l, d.position.top = h.top - l) : /^(sw)$/.test(i) ? (d.size.width = g.width + k, d.size.height = g.height + l, d.position.left = h.left - k) : (d.size.width = g.width + k, d.size.height = g.height + l, d.position.top = h.top - l, d.position.left = h.left - k)
    }});
    var c = function (a) {
        return parseInt(a, 10) || 0
    }, d = function (a) {
        return!isNaN(parseInt(a, 10))
    }
}(jQuery), function (a, b) {
    a.widget("ui.selectable", a.ui.mouse, {version: "1.9.2", options: {appendTo: "body", autoRefresh: !0, distance: 0, filter: "*", tolerance: "touch"}, _create: function () {
        var b = this;
        this.element.addClass("ui-selectable"), this.dragged = !1;
        var c;
        this.refresh = function () {
            c = a(b.options.filter, b.element[0]), c.addClass("ui-selectee"), c.each(function () {
                var b = a(this), c = b.offset();
                a.data(this, "selectable-item", {element: this, $element: b, left: c.left, top: c.top, right: c.left + b.outerWidth(), bottom: c.top + b.outerHeight(), startselected: !1, selected: b.hasClass("ui-selected"), selecting: b.hasClass("ui-selecting"), unselecting: b.hasClass("ui-unselecting")})
            })
        }, this.refresh(), this.selectees = c.addClass("ui-selectee"), this._mouseInit(), this.helper = a("<div class='ui-selectable-helper'></div>")
    }, _destroy: function () {
        this.selectees.removeClass("ui-selectee").removeData("selectable-item"), this.element.removeClass("ui-selectable ui-selectable-disabled"), this._mouseDestroy()
    }, _mouseStart: function (b) {
        var c = this;
        this.opos = [b.pageX, b.pageY];
        if (this.options.disabled)return;
        var d = this.options;
        this.selectees = a(d.filter, this.element[0]), this._trigger("start", b), a(d.appendTo).append(this.helper), this.helper.css({left: b.clientX, top: b.clientY, width: 0, height: 0}), d.autoRefresh && this.refresh(), this.selectees.filter(".ui-selected").each(function () {
            var d = a.data(this, "selectable-item");
            d.startselected = !0, !b.metaKey && !b.ctrlKey && (d.$element.removeClass("ui-selected"), d.selected = !1, d.$element.addClass("ui-unselecting"), d.unselecting = !0, c._trigger("unselecting", b, {unselecting: d.element}))
        }), a(b.target).parents().andSelf().each(function () {
            var d = a.data(this, "selectable-item");
            if (d) {
                var e = !b.metaKey && !b.ctrlKey || !d.$element.hasClass("ui-selected");
                return d.$element.removeClass(e ? "ui-unselecting" : "ui-selected").addClass(e ? "ui-selecting" : "ui-unselecting"), d.unselecting = !e, d.selecting = e, d.selected = e, e ? c._trigger("selecting", b, {selecting: d.element}) : c._trigger("unselecting", b, {unselecting: d.element}), !1
            }
        })
    }, _mouseDrag: function (b) {
        var c = this;
        this.dragged = !0;
        if (this.options.disabled)return;
        var d = this.options, e = this.opos[0], f = this.opos[1], g = b.pageX, h = b.pageY;
        if (e > g) {
            var i = g;
            g = e, e = i
        }
        if (f > h) {
            var i = h;
            h = f, f = i
        }
        return this.helper.css({left: e, top: f, width: g - e, height: h - f}), this.selectees.each(function () {
            var i = a.data(this, "selectable-item");
            if (!i || i.element == c.element[0])return;
            var j = !1;
            d.tolerance == "touch" ? j = !(i.left > g || i.right < e || i.top > h || i.bottom < f) : d.tolerance == "fit" && (j = i.left > e && i.right < g && i.top > f && i.bottom < h), j ? (i.selected && (i.$element.removeClass("ui-selected"), i.selected = !1), i.unselecting && (i.$element.removeClass("ui-unselecting"), i.unselecting = !1), i.selecting || (i.$element.addClass("ui-selecting"), i.selecting = !0, c._trigger("selecting", b, {selecting: i.element}))) : (i.selecting && ((b.metaKey || b.ctrlKey) && i.startselected ? (i.$element.removeClass("ui-selecting"), i.selecting = !1, i.$element.addClass("ui-selected"), i.selected = !0) : (i.$element.removeClass("ui-selecting"), i.selecting = !1, i.startselected && (i.$element.addClass("ui-unselecting"), i.unselecting = !0), c._trigger("unselecting", b, {unselecting: i.element}))), i.selected && !b.metaKey && !b.ctrlKey && !i.startselected && (i.$element.removeClass("ui-selected"), i.selected = !1, i.$element.addClass("ui-unselecting"), i.unselecting = !0, c._trigger("unselecting", b, {unselecting: i.element})))
        }), !1
    }, _mouseStop: function (b) {
        var c = this;
        this.dragged = !1;
        var d = this.options;
        return a(".ui-unselecting", this.element[0]).each(function () {
            var d = a.data(this, "selectable-item");
            d.$element.removeClass("ui-unselecting"), d.unselecting = !1, d.startselected = !1, c._trigger("unselected", b, {unselected: d.element})
        }), a(".ui-selecting", this.element[0]).each(function () {
            var d = a.data(this, "selectable-item");
            d.$element.removeClass("ui-selecting").addClass("ui-selected"), d.selecting = !1, d.selected = !0, d.startselected = !0, c._trigger("selected", b, {selected: d.element})
        }), this._trigger("stop", b), this.helper.remove(), !1
    }})
}(jQuery), function (a, b) {
    a.widget("ui.sortable", a.ui.mouse, {version: "1.9.2", widgetEventPrefix: "sort", ready: !1, options: {appendTo: "parent", axis: !1, connectWith: !1, containment: !1, cursor: "auto", cursorAt: !1, dropOnEmpty: !0, forcePlaceholderSize: !1, forceHelperSize: !1, grid: !1, handle: !1, helper: "original", items: "> *", opacity: !1, placeholder: !1, revert: !1, scroll: !0, scrollSensitivity: 20, scrollSpeed: 20, scope: "default", tolerance: "intersect", zIndex: 1e3}, _create: function () {
        var a = this.options;
        this.containerCache = {}, this.element.addClass("ui-sortable"), this.refresh(), this.floating = this.items.length ? a.axis === "x" || /left|right/.test(this.items[0].item.css("float")) || /inline|table-cell/.test(this.items[0].item.css("display")) : !1, this.offset = this.element.offset(), this._mouseInit(), this.ready = !0
    }, _destroy: function () {
        this.element.removeClass("ui-sortable ui-sortable-disabled"), this._mouseDestroy();
        for (var a = this.items.length - 1; a >= 0; a--)this.items[a].item.removeData(this.widgetName + "-item");
        return this
    }, _setOption: function (b, c) {
        b === "disabled" ? (this.options[b] = c, this.widget().toggleClass("ui-sortable-disabled", !!c)) : a.Widget.prototype._setOption.apply(this, arguments)
    }, _mouseCapture: function (b, c) {
        var d = this;
        if (this.reverting)return!1;
        if (this.options.disabled || this.options.type == "static")return!1;
        this._refreshItems(b);
        var e = null, f = a(b.target).parents().each(function () {
            if (a.data(this, d.widgetName + "-item") == d)return e = a(this), !1
        });
        a.data(b.target, d.widgetName + "-item") == d && (e = a(b.target));
        if (!e)return!1;
        if (this.options.handle && !c) {
            var g = !1;
            a(this.options.handle, e).find("*").andSelf().each(function () {
                this == b.target && (g = !0)
            });
            if (!g)return!1
        }
        return this.currentItem = e, this._removeCurrentsFromItems(), !0
    }, _mouseStart: function (b, c, d) {
        var e = this.options;
        this.currentContainer = this, this.refreshPositions(), this.helper = this._createHelper(b), this._cacheHelperProportions(), this._cacheMargins(), this.scrollParent = this.helper.scrollParent(), this.offset = this.currentItem.offset(), this.offset = {top: this.offset.top - this.margins.top, left: this.offset.left - this.margins.left}, a.extend(this.offset, {click: {left: b.pageX - this.offset.left, top: b.pageY - this.offset.top}, parent: this._getParentOffset(), relative: this._getRelativeOffset()}), this.helper.css("position", "absolute"), this.cssPosition = this.helper.css("position"), this.originalPosition = this._generatePosition(b), this.originalPageX = b.pageX, this.originalPageY = b.pageY, e.cursorAt && this._adjustOffsetFromHelper(e.cursorAt), this.domPosition = {prev: this.currentItem.prev()[0], parent: this.currentItem.parent()[0]}, this.helper[0] != this.currentItem[0] && this.currentItem.hide(), this._createPlaceholder(), e.containment && this._setContainment(), e.cursor && (a("body").css("cursor") && (this._storedCursor = a("body").css("cursor")), a("body").css("cursor", e.cursor)), e.opacity && (this.helper.css("opacity") && (this._storedOpacity = this.helper.css("opacity")), this.helper.css("opacity", e.opacity)), e.zIndex && (this.helper.css("zIndex") && (this._storedZIndex = this.helper.css("zIndex")), this.helper.css("zIndex", e.zIndex)), this.scrollParent[0] != document && this.scrollParent[0].tagName != "HTML" && (this.overflowOffset = this.scrollParent.offset()), this._trigger("start", b, this._uiHash()), this._preserveHelperProportions || this._cacheHelperProportions();
        if (!d)for (var f = this.containers.length - 1; f >= 0; f--)this.containers[f]._trigger("activate", b, this._uiHash(this));
        return a.ui.ddmanager && (a.ui.ddmanager.current = this), a.ui.ddmanager && !e.dropBehaviour && a.ui.ddmanager.prepareOffsets(this, b), this.dragging = !0, this.helper.addClass("ui-sortable-helper"), this._mouseDrag(b), !0
    }, _mouseDrag: function (b) {
        this.position = this._generatePosition(b), this.positionAbs = this._convertPositionTo("absolute"), this.lastPositionAbs || (this.lastPositionAbs = this.positionAbs);
        if (this.options.scroll) {
            var c = this.options, d = !1;
            this.scrollParent[0] != document && this.scrollParent[0].tagName != "HTML" ? (this.overflowOffset.top + this.scrollParent[0].offsetHeight - b.pageY < c.scrollSensitivity ? this.scrollParent[0].scrollTop = d = this.scrollParent[0].scrollTop + c.scrollSpeed : b.pageY - this.overflowOffset.top < c.scrollSensitivity && (this.scrollParent[0].scrollTop = d = this.scrollParent[0].scrollTop - c.scrollSpeed), this.overflowOffset.left + this.scrollParent[0].offsetWidth - b.pageX < c.scrollSensitivity ? this.scrollParent[0].scrollLeft = d = this.scrollParent[0].scrollLeft + c.scrollSpeed : b.pageX - this.overflowOffset.left < c.scrollSensitivity && (this.scrollParent[0].scrollLeft = d = this.scrollParent[0].scrollLeft - c.scrollSpeed)) : (b.pageY - a(document).scrollTop() < c.scrollSensitivity ? d = a(document).scrollTop(a(document).scrollTop() - c.scrollSpeed) : a(window).height() - (b.pageY - a(document).scrollTop()) < c.scrollSensitivity && (d = a(document).scrollTop(a(document).scrollTop() + c.scrollSpeed)), b.pageX - a(document).scrollLeft() < c.scrollSensitivity ? d = a(document).scrollLeft(a(document).scrollLeft() - c.scrollSpeed) : a(window).width() - (b.pageX - a(document).scrollLeft()) < c.scrollSensitivity && (d = a(document).scrollLeft(a(document).scrollLeft() + c.scrollSpeed))), d !== !1 && a.ui.ddmanager && !c.dropBehaviour && a.ui.ddmanager.prepareOffsets(this, b)
        }
        this.positionAbs = this._convertPositionTo("absolute");
        if (!this.options.axis || this.options.axis != "y")this.helper[0].style.left = this.position.left + "px";
        if (!this.options.axis || this.options.axis != "x")this.helper[0].style.top = this.position.top + "px";
        for (var e = this.items.length - 1; e >= 0; e--) {
            var f = this.items[e], g = f.item[0], h = this._intersectsWithPointer(f);
            if (!h)continue;
            if (f.instance !== this.currentContainer)continue;
            if (g != this.currentItem[0] && this.placeholder[h == 1 ? "next" : "prev"]()[0] != g && !a.contains(this.placeholder[0], g) && (this.options.type == "semi-dynamic" ? !a.contains(this.element[0], g) : !0)) {
                this.direction = h == 1 ? "down" : "up";
                if (this.options.tolerance != "pointer" && !this._intersectsWithSides(f))break;
                this._rearrange(b, f), this._trigger("change", b, this._uiHash());
                break
            }
        }
        return this._contactContainers(b), a.ui.ddmanager && a.ui.ddmanager.drag(this, b), this._trigger("sort", b, this._uiHash()), this.lastPositionAbs = this.positionAbs, !1
    }, _mouseStop: function (b, c) {
        if (!b)return;
        a.ui.ddmanager && !this.options.dropBehaviour && a.ui.ddmanager.drop(this, b);
        if (this.options.revert) {
            var d = this, e = this.placeholder.offset();
            this.reverting = !0, a(this.helper).animate({left: e.left - this.offset.parent.left - this.margins.left + (this.offsetParent[0] == document.body ? 0 : this.offsetParent[0].scrollLeft), top: e.top - this.offset.parent.top - this.margins.top + (this.offsetParent[0] == document.body ? 0 : this.offsetParent[0].scrollTop)}, parseInt(this.options.revert, 10) || 500, function () {
                d._clear(b)
            })
        } else this._clear(b, c);
        return!1
    }, cancel: function () {
        if (this.dragging) {
            this._mouseUp({target: null}), this.options.helper == "original" ? this.currentItem.css(this._storedCSS).removeClass("ui-sortable-helper") : this.currentItem.show();
            for (var b = this.containers.length - 1; b >= 0; b--)this.containers[b]._trigger("deactivate", null, this._uiHash(this)), this.containers[b].containerCache.over && (this.containers[b]._trigger("out", null, this._uiHash(this)), this.containers[b].containerCache.over = 0)
        }
        return this.placeholder && (this.placeholder[0].parentNode && this.placeholder[0].parentNode.removeChild(this.placeholder[0]), this.options.helper != "original" && this.helper && this.helper[0].parentNode && this.helper.remove(), a.extend(this, {helper: null, dragging: !1, reverting: !1, _noFinalSort: null}), this.domPosition.prev ? a(this.domPosition.prev).after(this.currentItem) : a(this.domPosition.parent).prepend(this.currentItem)), this
    }, serialize: function (b) {
        var c = this._getItemsAsjQuery(b && b.connected), d = [];
        return b = b || {}, a(c).each(function () {
            var c = (a(b.item || this).attr(b.attribute || "id") || "").match(b.expression || /(.+)[-=_](.+)/);
            c && d.push((b.key || c[1] + "[]") + "=" + (b.key && b.expression ? c[1] : c[2]))
        }), !d.length && b.key && d.push(b.key + "="), d.join("&")
    }, toArray: function (b) {
        var c = this._getItemsAsjQuery(b && b.connected), d = [];
        return b = b || {}, c.each(function () {
            d.push(a(b.item || this).attr(b.attribute || "id") || "")
        }), d
    }, _intersectsWith: function (a) {
        var b = this.positionAbs.left, c = b + this.helperProportions.width, d = this.positionAbs.top, e = d + this.helperProportions.height, f = a.left, g = f + a.width, h = a.top, i = h + a.height, j = this.offset.click.top, k = this.offset.click.left, l = d + j > h && d + j < i && b + k > f && b + k < g;
        return this.options.tolerance == "pointer" || this.options.forcePointerForContainers || this.options.tolerance != "pointer" && this.helperProportions[this.floating ? "width" : "height"] > a[this.floating ? "width" : "height"] ? l : f < b + this.helperProportions.width / 2 && c - this.helperProportions.width / 2 < g && h < d + this.helperProportions.height / 2 && e - this.helperProportions.height / 2 < i
    }, _intersectsWithPointer: function (b) {
        var c = this.options.axis === "x" || a.ui.isOverAxis(this.positionAbs.top + this.offset.click.top, b.top, b.height), d = this.options.axis === "y" || a.ui.isOverAxis(this.positionAbs.left + this.offset.click.left, b.left, b.width), e = c && d, f = this._getDragVerticalDirection(), g = this._getDragHorizontalDirection();
        return e ? this.floating ? g && g == "right" || f == "down" ? 2 : 1 : f && (f == "down" ? 2 : 1) : !1
    }, _intersectsWithSides: function (b) {
        var c = a.ui.isOverAxis(this.positionAbs.top + this.offset.click.top, b.top + b.height / 2, b.height), d = a.ui.isOverAxis(this.positionAbs.left + this.offset.click.left, b.left + b.width / 2, b.width), e = this._getDragVerticalDirection(), f = this._getDragHorizontalDirection();
        return this.floating && f ? f == "right" && d || f == "left" && !d : e && (e == "down" && c || e == "up" && !c)
    }, _getDragVerticalDirection: function () {
        var a = this.positionAbs.top - this.lastPositionAbs.top;
        return a != 0 && (a > 0 ? "down" : "up")
    }, _getDragHorizontalDirection: function () {
        var a = this.positionAbs.left - this.lastPositionAbs.left;
        return a != 0 && (a > 0 ? "right" : "left")
    }, refresh: function (a) {
        return this._refreshItems(a), this.refreshPositions(), this
    }, _connectWith: function () {
        var a = this.options;
        return a.connectWith.constructor == String ? [a.connectWith] : a.connectWith
    }, _getItemsAsjQuery: function (b) {
        var c = [], d = [], e = this._connectWith();
        if (e && b)for (var f = e.length - 1; f >= 0; f--) {
            var g = a(e[f]);
            for (var h = g.length - 1; h >= 0; h--) {
                var i = a.data(g[h], this.widgetName);
                i && i != this && !i.options.disabled && d.push([a.isFunction(i.options.items) ? i.options.items.call(i.element) : a(i.options.items, i.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"), i])
            }
        }
        d.push([a.isFunction(this.options.items) ? this.options.items.call(this.element, null, {options: this.options, item: this.currentItem}) : a(this.options.items, this.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"), this]);
        for (var f = d.length - 1; f >= 0; f--)d[f][0].each(function () {
            c.push(this)
        });
        return a(c)
    }, _removeCurrentsFromItems: function () {
        var b = this.currentItem.find(":data(" + this.widgetName + "-item)");
        this.items = a.grep(this.items, function (a) {
            for (var c = 0; c < b.length; c++)if (b[c] == a.item[0])return!1;
            return!0
        })
    }, _refreshItems: function (b) {
        this.items = [], this.containers = [this];
        var c = this.items, d = [
            [a.isFunction(this.options.items) ? this.options.items.call(this.element[0], b, {item: this.currentItem}) : a(this.options.items, this.element), this]
        ], e = this._connectWith();
        if (e && this.ready)for (var f = e.length - 1; f >= 0; f--) {
            var g = a(e[f]);
            for (var h = g.length - 1; h >= 0; h--) {
                var i =
                    a.data(g[h], this.widgetName);
                i && i != this && !i.options.disabled && (d.push([a.isFunction(i.options.items) ? i.options.items.call(i.element[0], b, {item: this.currentItem}) : a(i.options.items, i.element), i]), this.containers.push(i))
            }
        }
        for (var f = d.length - 1; f >= 0; f--) {
            var j = d[f][1], k = d[f][0];
            for (var h = 0, l = k.length; h < l; h++) {
                var m = a(k[h]);
                m.data(this.widgetName + "-item", j), c.push({item: m, instance: j, width: 0, height: 0, left: 0, top: 0})
            }
        }
    }, refreshPositions: function (b) {
        this.offsetParent && this.helper && (this.offset.parent = this._getParentOffset());
        for (var c = this.items.length - 1; c >= 0; c--) {
            var d = this.items[c];
            if (d.instance != this.currentContainer && this.currentContainer && d.item[0] != this.currentItem[0])continue;
            var e = this.options.toleranceElement ? a(this.options.toleranceElement, d.item) : d.item;
            b || (d.width = e.outerWidth(), d.height = e.outerHeight());
            var f = e.offset();
            d.left = f.left, d.top = f.top
        }
        if (this.options.custom && this.options.custom.refreshContainers)this.options.custom.refreshContainers.call(this); else for (var c = this.containers.length - 1; c >= 0; c--) {
            var f = this.containers[c].element.offset();
            this.containers[c].containerCache.left = f.left, this.containers[c].containerCache.top = f.top, this.containers[c].containerCache.width = this.containers[c].element.outerWidth(), this.containers[c].containerCache.height = this.containers[c].element.outerHeight()
        }
        return this
    }, _createPlaceholder: function (b) {
        b = b || this;
        var c = b.options;
        if (!c.placeholder || c.placeholder.constructor == String) {
            var d = c.placeholder;
            c.placeholder = {element: function () {
                var c = a(document.createElement(b.currentItem[0].nodeName)).addClass(d || b.currentItem[0].className + " ui-sortable-placeholder").removeClass("ui-sortable-helper")[0];
                return d || (c.style.visibility = "hidden"), c
            }, update: function (a, e) {
                if (d && !c.forcePlaceholderSize)return;
                e.height() || e.height(b.currentItem.innerHeight() - parseInt(b.currentItem.css("paddingTop") || 0, 10) - parseInt(b.currentItem.css("paddingBottom") || 0, 10)), e.width() || e.width(b.currentItem.innerWidth() - parseInt(b.currentItem.css("paddingLeft") || 0, 10) - parseInt(b.currentItem.css("paddingRight") || 0, 10))
            }}
        }
        b.placeholder = a(c.placeholder.element.call(b.element, b.currentItem)), b.currentItem.after(b.placeholder), c.placeholder.update(b, b.placeholder)
    }, _contactContainers: function (b) {
        var c = null, d = null;
        for (var e = this.containers.length - 1; e >= 0; e--) {
            if (a.contains(this.currentItem[0], this.containers[e].element[0]))continue;
            if (this._intersectsWith(this.containers[e].containerCache)) {
                if (c && a.contains(this.containers[e].element[0], c.element[0]))continue;
                c = this.containers[e], d = e
            } else this.containers[e].containerCache.over && (this.containers[e]._trigger("out", b, this._uiHash(this)), this.containers[e].containerCache.over = 0)
        }
        if (!c)return;
        if (this.containers.length === 1)this.containers[d]._trigger("over", b, this._uiHash(this)), this.containers[d].containerCache.over = 1; else {
            var f = 1e4, g = null, h = this.containers[d].floating ? "left" : "top", i = this.containers[d].floating ? "width" : "height", j = this.positionAbs[h] + this.offset.click[h];
            for (var k = this.items.length - 1; k >= 0; k--) {
                if (!a.contains(this.containers[d].element[0], this.items[k].item[0]))continue;
                if (this.items[k].item[0] == this.currentItem[0])continue;
                var l = this.items[k].item.offset()[h], m = !1;
                Math.abs(l - j) > Math.abs(l + this.items[k][i] - j) && (m = !0, l += this.items[k][i]), Math.abs(l - j) < f && (f = Math.abs(l - j), g = this.items[k], this.direction = m ? "up" : "down")
            }
            if (!g && !this.options.dropOnEmpty)return;
            this.currentContainer = this.containers[d], g ? this._rearrange(b, g, null, !0) : this._rearrange(b, null, this.containers[d].element, !0), this._trigger("change", b, this._uiHash()), this.containers[d]._trigger("change", b, this._uiHash(this)), this.options.placeholder.update(this.currentContainer, this.placeholder), this.containers[d]._trigger("over", b, this._uiHash(this)), this.containers[d].containerCache.over = 1
        }
    }, _createHelper: function (b) {
        var c = this.options, d = a.isFunction(c.helper) ? a(c.helper.apply(this.element[0], [b, this.currentItem])) : c.helper == "clone" ? this.currentItem.clone() : this.currentItem;
        return d.parents("body").length || a(c.appendTo != "parent" ? c.appendTo : this.currentItem[0].parentNode)[0].appendChild(d[0]), d[0] == this.currentItem[0] && (this._storedCSS = {width: this.currentItem[0].style.width, height: this.currentItem[0].style.height, position: this.currentItem.css("position"), top: this.currentItem.css("top"), left: this.currentItem.css("left")}), (d[0].style.width == "" || c.forceHelperSize) && d.width(this.currentItem.width()), (d[0].style.height == "" || c.forceHelperSize) && d.height(this.currentItem.height()), d
    }, _adjustOffsetFromHelper: function (b) {
        typeof b == "string" && (b = b.split(" ")), a.isArray(b) && (b = {left: +b[0], top: +b[1] || 0}), "left"in b && (this.offset.click.left = b.left + this.margins.left), "right"in b && (this.offset.click.left = this.helperProportions.width - b.right + this.margins.left), "top"in b && (this.offset.click.top = b.top + this.margins.top), "bottom"in b && (this.offset.click.top = this.helperProportions.height - b.bottom + this.margins.top)
    }, _getParentOffset: function () {
        this.offsetParent = this.helper.offsetParent();
        var b = this.offsetParent.offset();
        this.cssPosition == "absolute" && this.scrollParent[0] != document && a.contains(this.scrollParent[0], this.offsetParent[0]) && (b.left += this.scrollParent.scrollLeft(), b.top += this.scrollParent.scrollTop());
        if (this.offsetParent[0] == document.body || this.offsetParent[0].tagName && this.offsetParent[0].tagName.toLowerCase() == "html" && a.ui.ie)b = {top: 0, left: 0};
        return{top: b.top + (parseInt(this.offsetParent.css("borderTopWidth"), 10) || 0), left: b.left + (parseInt(this.offsetParent.css("borderLeftWidth"), 10) || 0)}
    }, _getRelativeOffset: function () {
        if (this.cssPosition == "relative") {
            var a = this.currentItem.position();
            return{top: a.top - (parseInt(this.helper.css("top"), 10) || 0) + this.scrollParent.scrollTop(), left: a.left - (parseInt(this.helper.css("left"), 10) || 0) + this.scrollParent.scrollLeft()}
        }
        return{top: 0, left: 0}
    }, _cacheMargins: function () {
        this.margins = {left: parseInt(this.currentItem.css("marginLeft"), 10) || 0, top: parseInt(this.currentItem.css("marginTop"), 10) || 0}
    }, _cacheHelperProportions: function () {
        this.helperProportions = {width: this.helper.outerWidth(), height: this.helper.outerHeight()}
    }, _setContainment: function () {
        var b = this.options;
        b.containment == "parent" && (b.containment = this.helper[0].parentNode);
        if (b.containment == "document" || b.containment == "window")this.containment = [0 - this.offset.relative.left - this.offset.parent.left, 0 - this.offset.relative.top - this.offset.parent.top, a(b.containment == "document" ? document : window).width() - this.helperProportions.width - this.margins.left, (a(b.containment == "document" ? document : window).height() || document.body.parentNode.scrollHeight) - this.helperProportions.height - this.margins.top];
        if (!/^(document|window|parent)$/.test(b.containment)) {
            var c = a(b.containment)[0], d = a(b.containment).offset(), e = a(c).css("overflow") != "hidden";
            this.containment = [d.left + (parseInt(a(c).css("borderLeftWidth"), 10) || 0) + (parseInt(a(c).css("paddingLeft"), 10) || 0) - this.margins.left, d.top + (parseInt(a(c).css("borderTopWidth"), 10) || 0) + (parseInt(a(c).css("paddingTop"), 10) || 0) - this.margins.top, d.left + (e ? Math.max(c.scrollWidth, c.offsetWidth) : c.offsetWidth) - (parseInt(a(c).css("borderLeftWidth"), 10) || 0) - (parseInt(a(c).css("paddingRight"), 10) || 0) - this.helperProportions.width - this.margins.left, d.top + (e ? Math.max(c.scrollHeight, c.offsetHeight) : c.offsetHeight) - (parseInt(a(c).css("borderTopWidth"), 10) || 0) - (parseInt(a(c).css("paddingBottom"), 10) || 0) - this.helperProportions.height - this.margins.top]
        }
    }, _convertPositionTo: function (b, c) {
        c || (c = this.position);
        var d = b == "absolute" ? 1 : -1, e = this.options, f = this.cssPosition != "absolute" || this.scrollParent[0] != document && !!a.contains(this.scrollParent[0], this.offsetParent[0]) ? this.scrollParent : this.offsetParent, g = /(html|body)/i.test(f[0].tagName);
        return{top: c.top + this.offset.relative.top * d + this.offset.parent.top * d - (this.cssPosition == "fixed" ? -this.scrollParent.scrollTop() : g ? 0 : f.scrollTop()) * d, left: c.left + this.offset.relative.left * d + this.offset.parent.left * d - (this.cssPosition == "fixed" ? -this.scrollParent.scrollLeft() : g ? 0 : f.scrollLeft()) * d}
    }, _generatePosition: function (b) {
        var c = this.options, d = this.cssPosition != "absolute" || this.scrollParent[0] != document && !!a.contains(this.scrollParent[0], this.offsetParent[0]) ? this.scrollParent : this.offsetParent, e = /(html|body)/i.test(d[0].tagName);
        this.cssPosition == "relative" && (this.scrollParent[0] == document || this.scrollParent[0] == this.offsetParent[0]) && (this.offset.relative = this._getRelativeOffset());
        var f = b.pageX, g = b.pageY;
        if (this.originalPosition) {
            this.containment && (b.pageX - this.offset.click.left < this.containment[0] && (f = this.containment[0] + this.offset.click.left), b.pageY - this.offset.click.top < this.containment[1] && (g = this.containment[1] + this.offset.click.top), b.pageX - this.offset.click.left > this.containment[2] && (f = this.containment[2] + this.offset.click.left), b.pageY - this.offset.click.top > this.containment[3] && (g = this.containment[3] + this.offset.click.top));
            if (c.grid) {
                var h = this.originalPageY + Math.round((g - this.originalPageY) / c.grid[1]) * c.grid[1];
                g = this.containment ? h - this.offset.click.top < this.containment[1] || h - this.offset.click.top > this.containment[3] ? h - this.offset.click.top < this.containment[1] ? h + c.grid[1] : h - c.grid[1] : h : h;
                var i = this.originalPageX + Math.round((f - this.originalPageX) / c.grid[0]) * c.grid[0];
                f = this.containment ? i - this.offset.click.left < this.containment[0] || i - this.offset.click.left > this.containment[2] ? i - this.offset.click.left < this.containment[0] ? i + c.grid[0] : i - c.grid[0] : i : i
            }
        }
        return{top: g - this.offset.click.top - this.offset.relative.top - this.offset.parent.top + (this.cssPosition == "fixed" ? -this.scrollParent.scrollTop() : e ? 0 : d.scrollTop()), left: f - this.offset.click.left - this.offset.relative.left - this.offset.parent.left + (this.cssPosition == "fixed" ? -this.scrollParent.scrollLeft() : e ? 0 : d.scrollLeft())}
    }, _rearrange: function (a, b, c, d) {
        c ? c[0].appendChild(this.placeholder[0]) : b.item[0].parentNode.insertBefore(this.placeholder[0], this.direction == "down" ? b.item[0] : b.item[0].nextSibling), this.counter = this.counter ? ++this.counter : 1;
        var e = this.counter;
        this._delay(function () {
            e == this.counter && this.refreshPositions(!d)
        })
    }, _clear: function (b, c) {
        this.reverting = !1;
        var d = [];
        !this._noFinalSort && this.currentItem.parent().length && this.placeholder.before(this.currentItem), this._noFinalSort = null;
        if (this.helper[0] == this.currentItem[0]) {
            for (var e in this._storedCSS)if (this._storedCSS[e] == "auto" || this._storedCSS[e] == "static")this._storedCSS[e] = "";
            this.currentItem.css(this._storedCSS).removeClass("ui-sortable-helper")
        } else this.currentItem.show();
        this.fromOutside && !c && d.push(function (a) {
            this._trigger("receive", a, this._uiHash(this.fromOutside))
        }), (this.fromOutside || this.domPosition.prev != this.currentItem.prev().not(".ui-sortable-helper")[0] || this.domPosition.parent != this.currentItem.parent()[0]) && !c && d.push(function (a) {
            this._trigger("update", a, this._uiHash())
        }), this !== this.currentContainer && (c || (d.push(function (a) {
            this._trigger("remove", a, this._uiHash())
        }), d.push(function (a) {
            return function (b) {
                a._trigger("receive", b, this._uiHash(this))
            }
        }.call(this, this.currentContainer)), d.push(function (a) {
            return function (b) {
                a._trigger("update", b, this._uiHash(this))
            }
        }.call(this, this.currentContainer))));
        for (var e = this.containers.length - 1; e >= 0; e--)c || d.push(function (a) {
            return function (b) {
                a._trigger("deactivate", b, this._uiHash(this))
            }
        }.call(this, this.containers[e])), this.containers[e].containerCache.over && (d.push(function (a) {
            return function (b) {
                a._trigger("out", b, this._uiHash(this))
            }
        }.call(this, this.containers[e])), this.containers[e].containerCache.over = 0);
        this._storedCursor && a("body").css("cursor", this._storedCursor), this._storedOpacity && this.helper.css("opacity", this._storedOpacity), this._storedZIndex && this.helper.css("zIndex", this._storedZIndex == "auto" ? "" : this._storedZIndex), this.dragging = !1;
        if (this.cancelHelperRemoval) {
            if (!c) {
                this._trigger("beforeStop", b, this._uiHash());
                for (var e = 0; e < d.length; e++)d[e].call(this, b);
                this._trigger("stop", b, this._uiHash())
            }
            return this.fromOutside = !1, !1
        }
        c || this._trigger("beforeStop", b, this._uiHash()), this.placeholder[0].parentNode.removeChild(this.placeholder[0]), this.helper[0] != this.currentItem[0] && this.helper.remove(), this.helper = null;
        if (!c) {
            for (var e = 0; e < d.length; e++)d[e].call(this, b);
            this._trigger("stop", b, this._uiHash())
        }
        return this.fromOutside = !1, !0
    }, _trigger: function () {
        a.Widget.prototype._trigger.apply(this, arguments) === !1 && this.cancel()
    }, _uiHash: function (b) {
        var c = b || this;
        return{helper: c.helper, placeholder: c.placeholder || a([]), position: c.position, originalPosition: c.originalPosition, offset: c.positionAbs, item: c.currentItem, sender: b ? b.element : null}
    }})
}(jQuery), jQuery.effects || function (a, b) {
    var c = a.uiBackCompat !== !1, d = "ui-effects-";
    a.effects = {effect: {}}, function (b, c) {
        function n(a, b, c) {
            var d = i[b.type] || {};
            return a == null ? c || !b.def ? null : b.def : (a = d.floor ? ~~a : parseFloat(a), isNaN(a) ? b.def : d.mod ? (a + d.mod) % d.mod : 0 > a ? 0 : d.max < a ? d.max : a)
        }

        function o(a) {
            var c = g(), d = c._rgba = [];
            return a = a.toLowerCase(), m(f, function (b, e) {
                var f, g = e.re.exec(a), i = g && e.parse(g), j = e.space || "rgba";
                if (i)return f = c[j](i), c[h[j].cache] = f[h[j].cache], d = c._rgba = f._rgba, !1
            }), d.length ? (d.join() === "0,0,0,0" && b.extend(d, l.transparent), c) : l[a]
        }

        function p(a, b, c) {
            return c = (c + 1) % 1, c * 6 < 1 ? a + (b - a) * c * 6 : c * 2 < 1 ? b : c * 3 < 2 ? a + (b - a) * (2 / 3 - c) * 6 : a
        }

        var d = "backgroundColor borderBottomColor borderLeftColor borderRightColor borderTopColor color columnRuleColor outlineColor textDecorationColor textEmphasisColor".split(" "), e = /^([\-+])=\s*(\d+\.?\d*)/, f = [
            {re: /rgba?\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*(?:,\s*(\d+(?:\.\d+)?)\s*)?\)/, parse: function (a) {
                return[a[1], a[2], a[3], a[4]]
            }},
            {re: /rgba?\(\s*(\d+(?:\.\d+)?)\%\s*,\s*(\d+(?:\.\d+)?)\%\s*,\s*(\d+(?:\.\d+)?)\%\s*(?:,\s*(\d+(?:\.\d+)?)\s*)?\)/, parse: function (a) {
                return[a[1] * 2.55, a[2] * 2.55, a[3] * 2.55, a[4]]
            }},
            {re: /#([a-f0-9]{2})([a-f0-9]{2})([a-f0-9]{2})/, parse: function (a) {
                return[parseInt(a[1], 16), parseInt(a[2], 16), parseInt(a[3], 16)]
            }},
            {re: /#([a-f0-9])([a-f0-9])([a-f0-9])/, parse: function (a) {
                return[parseInt(a[1] + a[1], 16), parseInt(a[2] + a[2], 16), parseInt(a[3] + a[3], 16)]
            }},
            {re: /hsla?\(\s*(\d+(?:\.\d+)?)\s*,\s*(\d+(?:\.\d+)?)\%\s*,\s*(\d+(?:\.\d+)?)\%\s*(?:,\s*(\d+(?:\.\d+)?)\s*)?\)/, space: "hsla", parse: function (a) {
                return[a[1], a[2] / 100, a[3] / 100, a[4]]
            }}
        ], g = b.Color = function (a, c, d, e) {
            return new b.Color.fn.parse(a, c, d, e)
        }, h = {rgba: {props: {red: {idx: 0, type: "byte"}, green: {idx: 1, type: "byte"}, blue: {idx: 2, type: "byte"}}}, hsla: {props: {hue: {idx: 0, type: "degrees"}, saturation: {idx: 1, type: "percent"}, lightness: {idx: 2, type: "percent"}}}}, i = {"byte": {floor: !0, max: 255}, percent: {max: 1}, degrees: {mod: 360, floor: !0}}, j = g.support = {}, k = b("<p>")[0], l, m = b.each;
        k.style.cssText = "background-color:rgba(1,1,1,.5)", j.rgba = k.style.backgroundColor.indexOf("rgba") > -1, m(h, function (a, b) {
            b.cache = "_" + a, b.props.alpha = {idx: 3, type: "percent", def: 1}
        }), g.fn = b.extend(g.prototype, {parse: function (d, e, f, i) {
            if (d === c)return this._rgba = [null, null, null, null], this;
            if (d.jquery || d.nodeType)d = b(d).css(e), e = c;
            var j = this, k = b.type(d), p = this._rgba = [];
            e !== c && (d = [d, e, f, i], k = "array");
            if (k === "string")return this.parse(o(d) || l._default);
            if (k === "array")return m(h.rgba.props, function (a, b) {
                p[b.idx] = n(d[b.idx], b)
            }), this;
            if (k === "object")return d instanceof g ? m(h, function (a, b) {
                d[b.cache] && (j[b.cache] = d[b.cache].slice())
            }) : m(h, function (b, c) {
                var e = c.cache;
                m(c.props, function (a, b) {
                    if (!j[e] && c.to) {
                        if (a === "alpha" || d[a] == null)return;
                        j[e] = c.to(j._rgba)
                    }
                    j[e][b.idx] = n(d[a], b, !0)
                }), j[e] && a.inArray(null, j[e].slice(0, 3)) < 0 && (j[e][3] = 1, c.from && (j._rgba = c.from(j[e])))
            }), this
        }, is: function (a) {
            var b = g(a), c = !0, d = this;
            return m(h, function (a, e) {
                var f, g = b[e.cache];
                return g && (f = d[e.cache] || e.to && e.to(d._rgba) || [], m(e.props, function (a, b) {
                    if (g[b.idx] != null)return c = g[b.idx] === f[b.idx], c
                })), c
            }), c
        }, _space: function () {
            var a = [], b = this;
            return m(h, function (c, d) {
                b[d.cache] && a.push(c)
            }), a.pop()
        }, transition: function (a, b) {
            var c = g(a), d = c._space(), e = h[d], f = this.alpha() === 0 ? g("transparent") : this, j = f[e.cache] || e.to(f._rgba), k = j.slice();
            return c = c[e.cache], m(e.props, function (a, d) {
                var e = d.idx, f = j[e], g = c[e], h = i[d.type] || {};
                if (g === null)return;
                f === null ? k[e] = g : (h.mod && (g - f > h.mod / 2 ? f += h.mod : f - g > h.mod / 2 && (f -= h.mod)), k[e] = n((g - f) * b + f, d))
            }), this[d](k)
        }, blend: function (a) {
            if (this._rgba[3] === 1)return this;
            var c = this._rgba.slice(), d = c.pop(), e = g(a)._rgba;
            return g(b.map(c, function (a, b) {
                return(1 - d) * e[b] + d * a
            }))
        }, toRgbaString: function () {
            var a = "rgba(", c = b.map(this._rgba, function (a, b) {
                return a == null ? b > 2 ? 1 : 0 : a
            });
            return c[3] === 1 && (c.pop(), a = "rgb("), a + c.join() + ")"
        }, toHslaString: function () {
            var a = "hsla(", c = b.map(this.hsla(), function (a, b) {
                return a == null && (a = b > 2 ? 1 : 0), b && b < 3 && (a = Math.round(a * 100) + "%"), a
            });
            return c[3] === 1 && (c.pop(), a = "hsl("), a + c.join() + ")"
        }, toHexString: function (a) {
            var c = this._rgba.slice(), d = c.pop();
            return a && c.push(~~(d * 255)), "#" + b.map(c,function (a) {
                return a = (a || 0).toString(16), a.length === 1 ? "0" + a : a
            }).join("")
        }, toString: function () {
            return this._rgba[3] === 0 ? "transparent" : this.toRgbaString()
        }}), g.fn.parse.prototype = g.fn, h.hsla.to = function (a) {
            if (a[0] == null || a[1] == null || a[2] == null)return[null, null, null, a[3]];
            var b = a[0] / 255, c = a[1] / 255, d = a[2] / 255, e = a[3], f = Math.max(b, c, d), g = Math.min(b, c, d), h = f - g, i = f + g, j = i * .5, k, l;
            return g === f ? k = 0 : b === f ? k = 60 * (c - d) / h + 360 : c === f ? k = 60 * (d - b) / h + 120 : k = 60 * (b - c) / h + 240, j === 0 || j === 1 ? l = j : j <= .5 ? l = h / i : l = h / (2 - i), [Math.round(k) % 360, l, j, e == null ? 1 : e]
        }, h.hsla.from = function (a) {
            if (a[0] == null || a[1] == null || a[2] == null)return[null, null, null, a[3]];
            var b = a[0] / 360, c = a[1], d = a[2], e = a[3], f = d <= .5 ? d * (1 + c) : d + c - d * c, g = 2 * d - f;
            return[Math.round(p(g, f, b + 1 / 3) * 255), Math.round(p(g, f, b) * 255), Math.round(p(g, f, b - 1 / 3) * 255), e]
        }, m(h, function (a, d) {
            var f = d.props, h = d.cache, i = d.to, j = d.from;
            g.fn[a] = function (a) {
                i && !this[h] && (this[h] = i(this._rgba));
                if (a === c)return this[h].slice();
                var d, e = b.type(a), k = e === "array" || e === "object" ? a : arguments, l = this[h].slice();
                return m(f, function (a, b) {
                    var c = k[e === "object" ? a : b.idx];
                    c == null && (c = l[b.idx]), l[b.idx] = n(c, b)
                }), j ? (d = g(j(l)), d[h] = l, d) : g(l)
            }, m(f, function (c, d) {
                if (g.fn[c])return;
                g.fn[c] = function (f) {
                    var g = b.type(f), h = c === "alpha" ? this._hsla ? "hsla" : "rgba" : a, i = this[h](), j = i[d.idx], k;
                    return g === "undefined" ? j : (g === "function" && (f = f.call(this, j), g = b.type(f)), f == null && d.empty ? this : (g === "string" && (k = e.exec(f), k && (f = j + parseFloat(k[2]) * (k[1] === "+" ? 1 : -1))), i[d.idx] = f, this[h](i)))
                }
            })
        }), m(d, function (a, c) {
            b.cssHooks[c] = {set: function (a, d) {
                var e, f, h = "";
                if (b.type(d) !== "string" || (e = o(d))) {
                    d = g(e || d);
                    if (!j.rgba && d._rgba[3] !== 1) {
                        f = c === "backgroundColor" ? a.parentNode : a;
                        while ((h === "" || h === "transparent") && f && f.style)try {
                            h = b.css(f, "backgroundColor"), f = f.parentNode
                        } catch (i) {
                        }
                        d = d.blend(h && h !== "transparent" ? h : "_default")
                    }
                    d = d.toRgbaString()
                }
                try {
                    a.style[c] = d
                } catch (k) {
                }
            }}, b.fx.step[c] = function (a) {
                a.colorInit || (a.start = g(a.elem, c), a.end = g(a.end), a.colorInit = !0), b.cssHooks[c].set(a.elem, a.start.transition(a.end, a.pos))
            }
        }), b.cssHooks.borderColor = {expand: function (a) {
            var b = {};
            return m(["Top", "Right", "Bottom", "Left"], function (c, d) {
                b["border" + d + "Color"] = a
            }), b
        }}, l = b.Color.names = {aqua: "#00ffff", black: "#000000", blue: "#0000ff", fuchsia: "#ff00ff", gray: "#808080", green: "#008000", lime: "#00ff00", maroon: "#800000", navy: "#000080", olive: "#808000", purple: "#800080", red: "#ff0000", silver: "#c0c0c0", teal: "#008080", white: "#ffffff", yellow: "#ffff00", transparent: [null, null, null, 0], _default: "#ffffff"}
    }(jQuery), function () {
        function e() {
            var b = this.ownerDocument.defaultView ? this.ownerDocument.defaultView.getComputedStyle(this, null) : this.currentStyle, c = {}, d, e;
            if (b && b.length && b[0] && b[b[0]]) {
                e = b.length;
                while (e--)d = b[e], typeof b[d] == "string" && (c[a.camelCase(d)] = b[d])
            } else for (d in b)typeof b[d] == "string" && (c[d] = b[d]);
            return c
        }

        function f(b, c) {
            var e = {}, f, g;
            for (f in c)g = c[f], b[f] !== g && !d[f] && (a.fx.step[f] || !isNaN(parseFloat(g))) && (e[f] = g);
            return e
        }

        var c = ["add", "remove", "toggle"], d = {border: 1, borderBottom: 1, borderColor: 1, borderLeft: 1, borderRight: 1, borderTop: 1, borderWidth: 1, margin: 1, padding: 1};
        a.each(["borderLeftStyle", "borderRightStyle", "borderBottomStyle", "borderTopStyle"], function (b, c) {
            a.fx.step[c] = function (a) {
                if (a.end !== "none" && !a.setAttr || a.pos === 1 && !a.setAttr)jQuery.style(a.elem, c, a.end), a.setAttr = !0
            }
        }), a.effects.animateClass = function (b, d, g, h) {
            var i = a.speed(d, g, h);
            return this.queue(function () {
                var d = a(this), g = d.attr("class") || "", h, j = i.children ? d.find("*").andSelf() : d;
                j = j.map(function () {
                    var b = a(this);
                    return{el: b, start: e.call(this)}
                }), h = function () {
                    a.each(c, function (a, c) {
                        b[c] && d[c + "Class"](b[c])
                    })
                }, h(), j = j.map(function () {
                    return this.end = e.call(this.el[0]), this.diff = f(this.start, this.end), this
                }), d.attr("class", g), j = j.map(function () {
                    var b = this, c = a.Deferred(), d = jQuery.extend({}, i, {queue: !1, complete: function () {
                        c.resolve(b)
                    }});
                    return this.el.animate(this.diff, d), c.promise()
                }), a.when.apply(a, j.get()).done(function () {
                    h(), a.each(arguments, function () {
                        var b = this.el;
                        a.each(this.diff, function (a) {
                            b.css(a, "")
                        })
                    }), i.complete.call(d[0])
                })
            })
        }, a.fn.extend({_addClass: a.fn.addClass, addClass: function (b, c, d, e) {
            return c ? a.effects.animateClass.call(this, {add: b}, c, d, e) : this._addClass(b)
        }, _removeClass: a.fn.removeClass, removeClass: function (b, c, d, e) {
            return c ? a.effects.animateClass.call(this, {remove: b}, c, d, e) : this._removeClass(b)
        }, _toggleClass: a.fn.toggleClass, toggleClass: function (c, d, e, f, g) {
            return typeof d == "boolean" || d === b ? e ? a.effects.animateClass.call(this, d ? {add: c} : {remove: c}, e, f, g) : this._toggleClass(c, d) : a.effects.animateClass.call(this, {toggle: c}, d, e, f)
        }, switchClass: function (b, c, d, e, f) {
            return a.effects.animateClass.call(this, {add: c, remove: b}, d, e, f)
        }})
    }(), function () {
        function e(b, c, d, e) {
            a.isPlainObject(b) && (c = b, b = b.effect), b = {effect: b}, c == null && (c = {}), a.isFunction(c) && (e = c, d = null, c = {});
            if (typeof c == "number" || a.fx.speeds[c])e = d, d = c, c = {};
            return a.isFunction(d) && (e = d, d = null), c && a.extend(b, c), d = d || c.duration, b.duration = a.fx.off ? 0 : typeof d == "number" ? d : d in a.fx.speeds ? a.fx.speeds[d] : a.fx.speeds._default, b.complete = e || c.complete, b
        }

        function f(b) {
            return!b || typeof b == "number" || a.fx.speeds[b] ? !0 : typeof b == "string" && !a.effects.effect[b] ? c && a.effects[b] ? !1 : !0 : !1
        }

        a.extend(a.effects, {version: "1.9.2", save: function (a, b) {
            for (var c = 0; c < b.length; c++)b[c] !== null && a.data(d + b[c], a[0].style[b[c]])
        }, restore: function (a, c) {
            var e, f;
            for (f = 0; f < c.length; f++)c[f] !== null && (e = a.data(d + c[f]), e === b && (e = ""), a.css(c[f], e))
        }, setMode: function (a, b) {
            return b === "toggle" && (b = a.is(":hidden") ? "show" : "hide"), b
        }, getBaseline: function (a, b) {
            var c, d;
            switch (a[0]) {
                case"top":
                    c = 0;
                    break;
                case"middle":
                    c = .5;
                    break;
                case"bottom":
                    c = 1;
                    break;
                default:
                    c = a[0] / b.height
            }
            switch (a[1]) {
                case"left":
                    d = 0;
                    break;
                case"center":
                    d = .5;
                    break;
                case"right":
                    d = 1;
                    break;
                default:
                    d = a[1] / b.width
            }
            return{x: d, y: c}
        }, createWrapper: function (b) {
            if (b.parent().is(".ui-effects-wrapper"))return b.parent();
            var c = {width: b.outerWidth(!0), height: b.outerHeight(!0), "float": b.css("float")}, d = a("<div></div>").addClass("ui-effects-wrapper").css({fontSize: "100%", background: "transparent", border: "none", margin: 0, padding: 0}), e = {width: b.width(), height: b.height()}, f = document.activeElement;
            try {
                f.id
            } catch (g) {
                f = document.body
            }
            return b.wrap(d), (b[0] === f || a.contains(b[0], f)) && a(f).focus(), d = b.parent(), b.css("position") === "static" ? (d.css({position: "relative"}), b.css({position: "relative"})) : (a.extend(c, {position: b.css("position"), zIndex: b.css("z-index")}), a.each(["top", "left", "bottom", "right"], function (a, d) {
                c[d] = b.css(d), isNaN(parseInt(c[d], 10)) && (c[d] = "auto")
            }), b.css({position: "relative", top: 0, left: 0, right: "auto", bottom: "auto"})), b.css(e), d.css(c).show()
        }, removeWrapper: function (b) {
            var c = document.activeElement;
            return b.parent().is(".ui-effects-wrapper") && (b.parent().replaceWith(b), (b[0] === c || a.contains(b[0], c)) && a(c).focus()), b
        }, setTransition: function (b, c, d, e) {
            return e = e || {}, a.each(c, function (a, c) {
                var f = b.cssUnit(c);
                f[0] > 0 && (e[c] = f[0] * d + f[1])
            }), e
        }}), a.fn.extend({effect: function () {
            function i(c) {
                function h() {
                    a.isFunction(e) && e.call(d[0]), a.isFunction(c) && c()
                }

                var d = a(this), e = b.complete, f = b.mode;
                (d.is(":hidden") ? f === "hide" : f === "show") ? h() : g.call(d[0], b, h)
            }

            var b = e.apply(this, arguments), d = b.mode, f = b.queue, g = a.effects.effect[b.effect], h = !g && c && a.effects[b.effect];
            return a.fx.off || !g && !h ? d ? this[d](b.duration, b.complete) : this.each(function () {
                b.complete && b.complete.call(this)
            }) : g ? f === !1 ? this.each(i) : this.queue(f || "fx", i) : h.call(this, {options: b, duration: b.duration, callback: b.complete, mode: b.mode})
        }, _show: a.fn.show, show: function (a) {
            if (f(a))return this._show.apply(this, arguments);
            var b = e.apply(this, arguments);
            return b.mode = "show", this.effect.call(this, b)
        }, _hide: a.fn.hide, hide: function (a) {
            if (f(a))return this._hide.apply(this, arguments);
            var b = e.apply(this, arguments);
            return b.mode = "hide", this.effect.call(this, b)
        }, __toggle: a.fn.toggle, toggle: function (b) {
            if (f(b) || typeof b == "boolean" || a.isFunction(b))return this.__toggle.apply(this, arguments);
            var c = e.apply(this, arguments);
            return c.mode = "toggle", this.effect.call(this, c)
        }, cssUnit: function (b) {
            var c = this.css(b), d = [];
            return a.each(["em", "px", "%", "pt"], function (a, b) {
                c.indexOf(b) > 0 && (d = [parseFloat(c), b])
            }), d
        }})
    }(), function () {
        var b = {};
        a.each(["Quad", "Cubic", "Quart", "Quint", "Expo"], function (a, c) {
            b[c] = function (b) {
                return Math.pow(b, a + 2)
            }
        }), a.extend(b, {Sine: function (a) {
            return 1 - Math.cos(a * Math.PI / 2)
        }, Circ: function (a) {
            return 1 - Math.sqrt(1 - a * a)
        }, Elastic: function (a) {
            return a === 0 || a === 1 ? a : -Math.pow(2, 8 * (a - 1)) * Math.sin(((a - 1) * 80 - 7.5) * Math.PI / 15)
        }, Back: function (a) {
            return a * a * (3 * a - 2)
        }, Bounce: function (a) {
            var b, c = 4;
            while (a < ((b = Math.pow(2, --c)) - 1) / 11);
            return 1 / Math.pow(4, 3 - c) - 7.5625 * Math.pow((b * 3 - 2) / 22 - a, 2)
        }}), a.each(b, function (b, c) {
            a.easing["easeIn" + b] = c, a.easing["easeOut" + b] = function (a) {
                return 1 - c(1 - a)
            }, a.easing["easeInOut" + b] = function (a) {
                return a < .5 ? c(a * 2) / 2 : 1 - c(a * -2 + 2) / 2
            }
        })
    }()
}(jQuery), function (a, b) {
    var c = 0, d = {}, e = {};
    d.height = d.paddingTop = d.paddingBottom = d.borderTopWidth = d.borderBottomWidth = "hide", e.height = e.paddingTop = e.paddingBottom = e.borderTopWidth = e.borderBottomWidth = "show", a.widget("ui.accordion", {version: "1.9.2", options: {active: 0, animate: {}, collapsible: !1, event: "click", header: "> li > :first-child,> :not(li):even", heightStyle: "auto", icons: {activeHeader: "ui-icon-triangle-1-s", header: "ui-icon-triangle-1-e"}, activate: null, beforeActivate: null}, _create: function () {
        var b = this.accordionId = "ui-accordion-" + (this.element.attr("id") || ++c), d = this.options;
        this.prevShow = this.prevHide = a(), this.element.addClass("ui-accordion ui-widget ui-helper-reset"), this.headers = this.element.find(d.header).addClass("ui-accordion-header ui-helper-reset ui-state-default ui-corner-all"), this._hoverable(this.headers), this._focusable(this.headers), this.headers.next().addClass("ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom").hide(), !d.collapsible && (d.active === !1 || d.active == null) && (d.active = 0), d.active < 0 && (d.active += this.headers.length), this.active = this._findActive(d.active).addClass("ui-accordion-header-active ui-state-active").toggleClass("ui-corner-all ui-corner-top"), this.active.next().addClass("ui-accordion-content-active").show(), this._createIcons(), this.refresh(), this.element.attr("role", "tablist"), this.headers.attr("role", "tab").each(function (c) {
            var d = a(this), e = d.attr("id"), f = d.next(), g = f.attr("id");
            e || (e = b + "-header-" + c, d.attr("id", e)), g || (g = b + "-panel-" + c, f.attr("id", g)), d.attr("aria-controls", g), f.attr("aria-labelledby", e)
        }).next().attr("role", "tabpanel"), this.headers.not(this.active).attr({"aria-selected": "false", tabIndex: -1}).next().attr({"aria-expanded": "false", "aria-hidden": "true"}).hide(), this.active.length ? this.active.attr({"aria-selected": "true", tabIndex: 0}).next().attr({"aria-expanded": "true", "aria-hidden": "false"}) : this.headers.eq(0).attr("tabIndex", 0), this._on(this.headers, {keydown: "_keydown"}), this._on(this.headers.next(), {keydown: "_panelKeyDown"}), this._setupEvents(d.event)
    }, _getCreateEventData: function () {
        return{header: this.active, content: this.active.length ? this.active.next() : a()}
    }, _createIcons: function () {
        var b = this.options.icons;
        b && (a("<span>").addClass("ui-accordion-header-icon ui-icon " + b.header).prependTo(this.headers), this.active.children(".ui-accordion-header-icon").removeClass(b.header).addClass(b.activeHeader), this.headers.addClass("ui-accordion-icons"))
    }, _destroyIcons: function () {
        this.headers.removeClass("ui-accordion-icons").children(".ui-accordion-header-icon").remove()
    }, _destroy: function () {
        var a;
        this.element.removeClass("ui-accordion ui-widget ui-helper-reset").removeAttr("role"), this.headers.removeClass("ui-accordion-header ui-accordion-header-active ui-helper-reset ui-state-default ui-corner-all ui-state-active ui-state-disabled ui-corner-top").removeAttr("role").removeAttr("aria-selected").removeAttr("aria-controls").removeAttr("tabIndex").each(function () {
            /^ui-accordion/.test(this.id) && this.removeAttribute("id")
        }), this._destroyIcons(), a = this.headers.next().css("display", "").removeAttr("role").removeAttr("aria-expanded").removeAttr("aria-hidden").removeAttr("aria-labelledby").removeClass("ui-helper-reset ui-widget-content ui-corner-bottom ui-accordion-content ui-accordion-content-active ui-state-disabled").each(function () {
            /^ui-accordion/.test(this.id) && this.removeAttribute("id")
        }), this.options.heightStyle !== "content" && a.css("height", "")
    }, _setOption: function (a, b) {
        if (a === "active") {
            this._activate(b);
            return
        }
        a === "event" && (this.options.event && this._off(this.headers, this.options.event), this._setupEvents(b)), this._super(a, b), a === "collapsible" && !b && this.options.active === !1 && this._activate(0), a === "icons" && (this._destroyIcons(), b && this._createIcons()), a === "disabled" && this.headers.add(this.headers.next()).toggleClass("ui-state-disabled", !!b)
    }, _keydown: function (b) {
        if (b.altKey || b.ctrlKey)return;
        var c = a.ui.keyCode, d = this.headers.length, e = this.headers.index(b.target), f = !1;
        switch (b.keyCode) {
            case c.RIGHT:
            case c.DOWN:
                f = this.headers[(e + 1) % d];
                break;
            case c.LEFT:
            case c.UP:
                f = this.headers[(e - 1 + d) % d];
                break;
            case c.SPACE:
            case c.ENTER:
                this._eventHandler(b);
                break;
            case c.HOME:
                f = this.headers[0];
                break;
            case c.END:
                f = this.headers[d - 1]
        }
        f && (a(b.target).attr("tabIndex", -1), a(f).attr("tabIndex", 0), f.focus(), b.preventDefault())
    }, _panelKeyDown: function (b) {
        b.keyCode === a.ui.keyCode.UP && b.ctrlKey && a(b.currentTarget).prev().focus()
    }, refresh: function () {
        var b, c, d = this.options.heightStyle, e = this.element.parent();
        d === "fill" ? (a.support.minHeight || (c = e.css("overflow"), e.css("overflow", "hidden")), b = e.height(), this.element.siblings(":visible").each(function () {
            var c = a(this), d = c.css("position");
            if (d === "absolute" || d === "fixed")return;
            b -= c.outerHeight(!0)
        }), c && e.css("overflow", c), this.headers.each(function () {
            b -= a(this).outerHeight(!0)
        }), this.headers.next().each(function () {
            a(this).height(Math.max(0, b - a(this).innerHeight() + a(this).height()))
        }).css("overflow", "auto")) : d === "auto" && (b = 0, this.headers.next().each(function () {
            b = Math.max(b, a(this).css("height", "").height())
        }).height(b))
    }, _activate: function (b) {
        var c = this._findActive(b)[0];
        if (c === this.active[0])return;
        c = c || this.active[0], this._eventHandler({target: c, currentTarget: c, preventDefault: a.noop})
    }, _findActive: function (b) {
        return typeof b == "number" ? this.headers.eq(b) : a()
    }, _setupEvents: function (b) {
        var c = {};
        if (!b)return;
        a.each(b.split(" "), function (a, b) {
            c[b] = "_eventHandler"
        }), this._on(this.headers, c)
    }, _eventHandler: function (b) {
        var c = this.options, d = this.active, e = a(b.currentTarget), f = e[0] === d[0], g = f && c.collapsible, h = g ? a() : e.next(), i = d.next(), j = {oldHeader: d, oldPanel: i, newHeader: g ? a() : e, newPanel: h};
        b.preventDefault();
        if (f && !c.collapsible || this._trigger("beforeActivate", b, j) === !1)return;
        c.active = g ? !1 : this.headers.index(e), this.active = f ? a() : e, this._toggle(j), d.removeClass("ui-accordion-header-active ui-state-active"), c.icons && d.children(".ui-accordion-header-icon").removeClass(c.icons.activeHeader).addClass(c.icons.header), f || (e.removeClass("ui-corner-all").addClass("ui-accordion-header-active ui-state-active ui-corner-top"), c.icons && e.children(".ui-accordion-header-icon").removeClass(c.icons.header).addClass(c.icons.activeHeader), e.next().addClass("ui-accordion-content-active"))
    }, _toggle: function (b) {
        var c = b.newPanel, d = this.prevShow.length ? this.prevShow : b.oldPanel;
        this.prevShow.add(this.prevHide).stop(!0, !0), this.prevShow = c, this.prevHide = d, this.options.animate ? this._animate(c, d, b) : (d.hide(), c.show(), this._toggleComplete(b)), d.attr({"aria-expanded": "false", "aria-hidden": "true"}), d.prev().attr("aria-selected", "false"), c.length && d.length ? d.prev().attr("tabIndex", -1) : c.length && this.headers.filter(function () {
            return a(this).attr("tabIndex") === 0
        }).attr("tabIndex", -1), c.attr({"aria-expanded": "true", "aria-hidden": "false"}).prev().attr({"aria-selected": "true", tabIndex: 0})
    }, _animate: function (a, b, c) {
        var f, g, h, i = this, j = 0, k = a.length && (!b.length || a.index() < b.index()), l = this.options.animate || {}, m = k && l.down || l, n = function () {
            i._toggleComplete(c)
        };
        typeof m == "number" && (h = m), typeof m == "string" && (g = m), g = g || m.easing || l.easing, h = h || m.duration || l.duration;
        if (!b.length)return a.animate(e, h, g, n);
        if (!a.length)return b.animate(d, h, g, n);
        f = a.show().outerHeight(), b.animate(d, {duration: h, easing: g, step: function (a, b) {
            b.now = Math.round(a)
        }}), a.hide().animate(e, {duration: h, easing: g, complete: n, step: function (a, c) {
            c.now = Math.round(a), c.prop !== "height" ? j += c.now : i.options.heightStyle !== "content" && (c.now = Math.round(f - b.outerHeight() - j), j = 0)
        }})
    }, _toggleComplete: function (a) {
        var b = a.oldPanel;
        b.removeClass("ui-accordion-content-active").prev().removeClass("ui-corner-top").addClass("ui-corner-all"), b.length && (b.parent()[0].className = b.parent()[0].className), this._trigger("activate", null, a)
    }}), a.uiBackCompat !== !1 && (function (a, b) {
        a.extend(b.options, {navigation: !1, navigationFilter: function () {
            return this.href.toLowerCase() === location.href.toLowerCase()
        }});
        var c = b._create;
        b._create = function () {
            if (this.options.navigation) {
                var b = this, d = this.element.find(this.options.header), e = d.next(), f = d.add(e).find("a").filter(this.options.navigationFilter)[0];
                f && d.add(e).each(function (c) {
                    if (a.contains(this, f))return b.options.active = Math.floor(c / 2), !1
                })
            }
            c.call(this)
        }
    }(jQuery, jQuery.ui.accordion.prototype), function (a, b) {
        a.extend(b.options, {heightStyle: null, autoHeight: !0, clearStyle: !1, fillSpace: !1});
        var c = b._create, d = b._setOption;
        a.extend(b, {_create: function () {
            this.options.heightStyle = this.options.heightStyle || this._mergeHeightStyle(), c.call(this)
        }, _setOption: function (a) {
            if (a === "autoHeight" || a === "clearStyle" || a === "fillSpace")this.options.heightStyle = this._mergeHeightStyle();
            d.apply(this, arguments)
        }, _mergeHeightStyle: function () {
            var a = this.options;
            if (a.fillSpace)return"fill";
            if (a.clearStyle)return"content";
            if (a.autoHeight)return"auto"
        }})
    }(jQuery, jQuery.ui.accordion.prototype), function (a, b) {
        a.extend(b.options.icons, {activeHeader: null, headerSelected: "ui-icon-triangle-1-s"});
        var c = b._createIcons;
        b._createIcons = function () {
            this.options.icons && (this.options.icons.activeHeader = this.options.icons.activeHeader || this.options.icons.headerSelected), c.call(this)
        }
    }(jQuery, jQuery.ui.accordion.prototype), function (a, b) {
        b.activate = b._activate;
        var c = b._findActive;
        b._findActive = function (a) {
            return a === -1 && (a = !1), a && typeof a != "number" && (a = this.headers.index(this.headers.filter(a)), a === -1 && (a = !1)), c.call(this, a)
        }
    }(jQuery, jQuery.ui.accordion.prototype), jQuery.ui.accordion.prototype.resize = jQuery.ui.accordion.prototype.refresh, function (a, b) {
        a.extend(b.options, {change: null, changestart: null});
        var c = b._trigger;
        b._trigger = function (a, b, d) {
            var e = c.apply(this, arguments);
            return e ? (a === "beforeActivate" ? e = c.call(this, "changestart", b, {oldHeader: d.oldHeader, oldContent: d.oldPanel, newHeader: d.newHeader, newContent: d.newPanel}) : a === "activate" && (e = c.call(this, "change", b, {oldHeader: d.oldHeader, oldContent: d.oldPanel, newHeader: d.newHeader, newContent: d.newPanel})), e) : !1
        }
    }(jQuery, jQuery.ui.accordion.prototype), function (a, b) {
        a.extend(b.options, {animate: null, animated: "slide"});
        var c = b._create;
        b._create = function () {
            var a = this.options;
            a.animate === null && (a.animated ? a.animated === "slide" ? a.animate = 300 : a.animated === "bounceslide" ? a.animate = {duration: 200, down: {easing: "easeOutBounce", duration: 1e3}} : a.animate = a.animated : a.animate = !1), c.call(this)
        }
    }(jQuery, jQuery.ui.accordion.prototype))
}(jQuery), function (a, b) {
    var c = 0;
    a.widget("ui.autocomplete", {version: "1.9.2", defaultElement: "<input>", options: {appendTo: "body", autoFocus: !1, delay: 300, minLength: 1, position: {my: "left top", at: "left bottom", collision: "none"}, source: null, change: null, close: null, focus: null, open: null, response: null, search: null, select: null}, pending: 0, _create: function () {
        var b, c, d;
        this.isMultiLine = this._isMultiLine(), this.valueMethod = this.element[this.element.is("input,textarea") ? "val" : "text"], this.isNewMenu = !0, this.element.addClass("ui-autocomplete-input").attr("autocomplete", "off"), this._on(this.element, {keydown: function (e) {
            if (this.element.prop("readOnly")) {
                b = !0, d = !0, c = !0;
                return
            }
            b = !1, d = !1, c = !1;
            var f = a.ui.keyCode;
            switch (e.keyCode) {
                case f.PAGE_UP:
                    b = !0, this._move("previousPage", e);
                    break;
                case f.PAGE_DOWN:
                    b = !0, this._move("nextPage", e);
                    break;
                case f.UP:
                    b = !0, this._keyEvent("previous", e);
                    break;
                case f.DOWN:
                    b = !0, this._keyEvent("next", e);
                    break;
                case f.ENTER:
                case f.NUMPAD_ENTER:
                    this.menu.active && (b = !0, e.preventDefault(), this.menu.select(e));
                    break;
                case f.TAB:
                    this.menu.active && this.menu.select(e);
                    break;
                case f.ESCAPE:
                    this.menu.element.is(":visible") && (this._value(this.term), this.close(e), e.preventDefault());
                    break;
                default:
                    c = !0, this._searchTimeout(e)
            }
        }, keypress: function (d) {
            if (b) {
                b = !1, d.preventDefault();
                return
            }
            if (c)return;
            var e = a.ui.keyCode;
            switch (d.keyCode) {
                case e.PAGE_UP:
                    this._move("previousPage", d);
                    break;
                case e.PAGE_DOWN:
                    this._move("nextPage", d);
                    break;
                case e.UP:
                    this._keyEvent("previous", d);
                    break;
                case e.DOWN:
                    this._keyEvent("next", d)
            }
        }, input: function (a) {
            if (d) {
                d = !1, a.preventDefault();
                return
            }
            this._searchTimeout(a)
        }, focus: function () {
            this.selectedItem = null, this.previous = this._value()
        }, blur: function (a) {
            if (this.cancelBlur) {
                delete this.cancelBlur;
                return
            }
            clearTimeout(this.searching), this.close(a), this._change(a)
        }}), this._initSource(), this.menu = a("<ul>").addClass("ui-autocomplete").appendTo(this.document.find(this.options.appendTo || "body")[0]).menu({input: a(), role: null}).zIndex(this.element.zIndex() + 1).hide().data("menu"), this._on(this.menu.element, {mousedown: function (b) {
            b.preventDefault(), this.cancelBlur = !0, this._delay(function () {
                delete this.cancelBlur
            });
            var c = this.menu.element[0];
            a(b.target).closest(".ui-menu-item").length || this._delay(function () {
                var b = this;
                this.document.one("mousedown", function (d) {
                    d.target !== b.element[0] && d.target !== c && !a.contains(c, d.target) && b.close()
                })
            })
        }, menufocus: function (b, c) {
            if (this.isNewMenu) {
                this.isNewMenu = !1;
                if (b.originalEvent && /^mouse/.test(b.originalEvent.type)) {
                    this.menu.blur(), this.document.one("mousemove", function () {
                        a(b.target).trigger(b.originalEvent)
                    });
                    return
                }
            }
            var d = c.item.data("ui-autocomplete-item") || c.item.data("item.autocomplete");
            !1 !== this._trigger("focus", b, {item: d}) ? b.originalEvent && /^key/.test(b.originalEvent.type) && this._value(d.value) : this.liveRegion.text(d.value)
        }, menuselect: function (a, b) {
            var c = b.item.data("ui-autocomplete-item") || b.item.data("item.autocomplete"), d = this.previous;
            this.element[0] !== this.document[0].activeElement && (this.element.focus(), this.previous = d, this._delay(function () {
                this.previous = d, this.selectedItem = c
            })), !1 !== this._trigger("select", a, {item: c}) && this._value(c.value), this.term = this._value(), this.close(a), this.selectedItem = c
        }}), this.liveRegion = a("<span>", {role: "status", "aria-live": "polite"}).addClass("ui-helper-hidden-accessible").insertAfter(this.element), a.fn.bgiframe && this.menu.element.bgiframe(), this._on(this.window, {beforeunload: function () {
            this.element.removeAttr("autocomplete")
        }})
    }, _destroy: function () {
        clearTimeout(this.searching), this.element.removeClass("ui-autocomplete-input").removeAttr("autocomplete"), this.menu.element.remove(), this.liveRegion.remove()
    }, _setOption: function (a, b) {
        this._super(a, b), a === "source" && this._initSource(), a === "appendTo" && this.menu.element.appendTo(this.document.find(b || "body")[0]), a === "disabled" && b && this.xhr && this.xhr.abort()
    }, _isMultiLine: function () {
        return this.element.is("textarea") ? !0 : this.element.is("input") ? !1 : this.element.prop("isContentEditable")
    }, _initSource: function () {
        var b, c, d = this;
        a.isArray(this.options.source) ? (b = this.options.source, this.source = function (c, d) {
            d(a.ui.autocomplete.filter(b, c.term))
        }) : typeof this.options.source == "string" ? (c = this.options.source, this.source = function (b, e) {
            d.xhr && d.xhr.abort(), d.xhr = a.ajax({url: c, data: b, dataType: "json", success: function (a) {
                e(a)
            }, error: function () {
                e([])
            }})
        }) : this.source = this.options.source
    }, _searchTimeout: function (a) {
        clearTimeout(this.searching), this.searching = this._delay(function () {
            this.term !== this._value() && (this.selectedItem = null, this.search(null, a))
        }, this.options.delay)
    }, search: function (a, b) {
        a = a != null ? a : this._value(), this.term = this._value();
        if (a.length < this.options.minLength)return this.close(b);
        if (this._trigger("search", b) === !1)return;
        return this._search(a)
    }, _search: function (a) {
        this.pending++, this.element.addClass("ui-autocomplete-loading"), this.cancelSearch = !1, this.source({term: a}, this._response())
    }, _response: function () {
        var a = this, b = ++c;
        return function (d) {
            b === c && a.__response(d), a.pending--, a.pending || a.element.removeClass("ui-autocomplete-loading")
        }
    }, __response: function (a) {
        a && (a = this._normalize(a)), this._trigger("response", null, {content: a}), !this.options.disabled && a && a.length && !this.cancelSearch ? (this._suggest(a), this._trigger("open")) : this._close()
    }, close: function (a) {
        this.cancelSearch = !0, this._close(a)
    }, _close: function (a) {
        this.menu.element.is(":visible") && (this.menu.element.hide(), this.menu.blur(), this.isNewMenu = !0, this._trigger("close", a))
    }, _change: function (a) {
        this.previous !== this._value() && this._trigger("change", a, {item: this.selectedItem})
    }, _normalize: function (b) {
        return b.length && b[0].label && b[0].value ? b : a.map(b, function (b) {
            return typeof b == "string" ? {label: b, value: b} : a.extend({label: b.label || b.value, value: b.value || b.label}, b)
        })
    }, _suggest: function (b) {
        var c = this.menu.element.empty().zIndex(this.element.zIndex() + 1);
        this._renderMenu(c, b), this.menu.refresh(), c.show(), this._resizeMenu(), c.position(a.extend({of: this.element}, this.options.position)), this.options.autoFocus && this.menu.next()
    }, _resizeMenu: function () {
        var a = this.menu.element;
        a.outerWidth(Math.max(a.width("").outerWidth() + 1, this.element.outerWidth()))
    }, _renderMenu: function (b, c) {
        var d = this;
        a.each(c, function (a, c) {
            d._renderItemData(b, c)
        })
    }, _renderItemData: function (a, b) {
        return this._renderItem(a, b).data("ui-autocomplete-item", b)
    }, _renderItem: function (b, c) {
        return a("<li>").append(a("<a>").text(c.label)).appendTo(b)
    }, _move: function (a, b) {
        if (!this.menu.element.is(":visible")) {
            this.search(null, b);
            return
        }
        if (this.menu.isFirstItem() && /^previous/.test(a) || this.menu.isLastItem() && /^next/.test(a)) {
            this._value(this.term), this.menu.blur();
            return
        }
        this.menu[a](b)
    }, widget: function () {
        return this.menu.element
    }, _value: function () {
        return this.valueMethod.apply(this.element, arguments)
    }, _keyEvent: function (a, b) {
        if (!this.isMultiLine || this.menu.element.is(":visible"))this._move(a, b), b.preventDefault()
    }}), a.extend(a.ui.autocomplete, {escapeRegex: function (a) {
        return a.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&")
    }, filter: function (b, c) {
        var d = new RegExp(a.ui.autocomplete.escapeRegex(c), "i");
        return a.grep(b, function (a) {
            return d.test(a.label || a.value || a)
        })
    }}), a.widget("ui.autocomplete", a.ui.autocomplete, {options: {messages: {noResults: "No search results.", results: function (a) {
        return a + (a > 1 ? " results are" : " result is") + " available, use up and down arrow keys to navigate."
    }}}, __response: function (a) {
        var b;
        this._superApply(arguments);
        if (this.options.disabled || this.cancelSearch)return;
        a && a.length ? b = this.options.messages.results(a.length) : b = this.options.messages.noResults, this.liveRegion.text(b)
    }})
}(jQuery), function (a, b) {
    var c, d, e, f, g = "ui-button ui-widget ui-state-default ui-corner-all", h = "ui-state-hover ui-state-active ", i = "ui-button-icons-only ui-button-icon-only ui-button-text-icons ui-button-text-icon-primary ui-button-text-icon-secondary ui-button-text-only", j = function () {
        var b = a(this).find(":ui-button");
        setTimeout(function () {
            b.button("refresh")
        }, 1)
    }, k = function (b) {
        var c = b.name, d = b.form, e = a([]);
        return c && (d ? e = a(d).find("[name='" + c + "']") : e = a("[name='" + c + "']", b.ownerDocument).filter(function () {
            return!this.form
        })), e
    };
    a.widget("ui.button", {version: "1.9.2", defaultElement: "<button>", options: {disabled: null, text: !0, label: null, icons: {primary: null, secondary: null}}, _create: function () {
        this.element.closest("form").unbind("reset" + this.eventNamespace).bind("reset" + this.eventNamespace, j), typeof this.options.disabled != "boolean" ? this.options.disabled = !!this.element.prop("disabled") : this.element.prop("disabled", this.options.disabled), this._determineButtonType(), this.hasTitle = !!this.buttonElement.attr("title");
        var b = this, h = this.options, i = this.type === "checkbox" || this.type === "radio", l = i ? "" : "ui-state-active", m = "ui-state-focus";
        h.label === null && (h.label = this.type === "input" ? this.buttonElement.val() : this.buttonElement.html()), this._hoverable(this.buttonElement), this.buttonElement.addClass(g).attr("role", "button").bind("mouseenter" + this.eventNamespace,function () {
            if (h.disabled)return;
            this === c && a(this).addClass("ui-state-active")
        }).bind("mouseleave" + this.eventNamespace,function () {
            if (h.disabled)return;
            a(this).removeClass(l)
        }).bind("click" + this.eventNamespace, function (a) {
            h.disabled && (a.preventDefault(), a.stopImmediatePropagation())
        }), this.element.bind("focus" + this.eventNamespace,function () {
            b.buttonElement.addClass(m)
        }).bind("blur" + this.eventNamespace, function () {
            b.buttonElement.removeClass(m)
        }), i && (this.element.bind("change" + this.eventNamespace, function () {
            if (f)return;
            b.refresh()
        }), this.buttonElement.bind("mousedown" + this.eventNamespace,function (a) {
            if (h.disabled)return;
            f = !1, d = a.pageX, e = a.pageY
        }).bind("mouseup" + this.eventNamespace, function (a) {
            if (h.disabled)return;
            if (d !== a.pageX || e !== a.pageY)f = !0
        })), this.type === "checkbox" ? this.buttonElement.bind("click" + this.eventNamespace, function () {
            if (h.disabled || f)return!1;
            a(this).toggleClass("ui-state-active"), b.buttonElement.attr("aria-pressed", b.element[0].checked)
        }) : this.type === "radio" ? this.buttonElement.bind("click" + this.eventNamespace, function () {
            if (h.disabled || f)return!1;
            a(this).addClass("ui-state-active"), b.buttonElement.attr("aria-pressed", "true");
            var c = b.element[0];
            k(c).not(c).map(function () {
                return a(this).button("widget")[0]
            }).removeClass("ui-state-active").attr("aria-pressed", "false")
        }) : (this.buttonElement.bind("mousedown" + this.eventNamespace,function () {
            if (h.disabled)return!1;
            a(this).addClass("ui-state-active"), c = this, b.document.one("mouseup", function () {
                c = null
            })
        }).bind("mouseup" + this.eventNamespace,function () {
            if (h.disabled)return!1;
            a(this).removeClass("ui-state-active")
        }).bind("keydown" + this.eventNamespace,function (b) {
            if (h.disabled)return!1;
            (b.keyCode === a.ui.keyCode.SPACE || b.keyCode === a.ui.keyCode.ENTER) && a(this).addClass("ui-state-active")
        }).bind("keyup" + this.eventNamespace, function () {
            a(this).removeClass("ui-state-active")
        }), this.buttonElement.is("a") && this.buttonElement.keyup(function (b) {
            b.keyCode === a.ui.keyCode.SPACE && a(this).click()
        })), this._setOption("disabled", h.disabled), this._resetButton()
    }, _determineButtonType: function () {
        var a, b, c;
        this.element.is("[type=checkbox]") ? this.type = "checkbox" : this.element.is("[type=radio]") ? this.type = "radio" : this.element.is("input") ? this.type = "input" : this.type = "button", this.type === "checkbox" || this.type === "radio" ? (a = this.element.parents().last(), b = "label[for='" + this.element.attr("id") + "']", this.buttonElement = a.find(b), this.buttonElement.length || (a = a.length ? a.siblings() : this.element.siblings(), this.buttonElement = a.filter(b), this.buttonElement.length || (this.buttonElement = a.find(b))), this.element.addClass("ui-helper-hidden-accessible"), c = this.element.is(":checked"), c && this.buttonElement.addClass("ui-state-active"), this.buttonElement.prop("aria-pressed", c)) : this.buttonElement = this.element
    }, widget: function () {
        return this.buttonElement
    }, _destroy: function () {
        this.element.removeClass("ui-helper-hidden-accessible"), this.buttonElement.removeClass(g + " " + h + " " + i).removeAttr("role").removeAttr("aria-pressed").html(this.buttonElement.find(".ui-button-text").html()), this.hasTitle || this.buttonElement.removeAttr("title")
    }, _setOption: function (a, b) {
        this._super(a, b);
        if (a === "disabled") {
            b ? this.element.prop("disabled", !0) : this.element.prop("disabled", !1);
            return
        }
        this._resetButton()
    }, refresh: function () {
        var b = this.element.is("input, button") ? this.element.is(":disabled") : this.element.hasClass("ui-button-disabled");
        b !== this.options.disabled && this._setOption("disabled", b), this.type === "radio" ? k(this.element[0]).each(function () {
            a(this).is(":checked") ? a(this).button("widget").addClass("ui-state-active").attr("aria-pressed", "true") : a(this).button("widget").removeClass("ui-state-active").attr("aria-pressed", "false")
        }) : this.type === "checkbox" && (this.element.is(":checked") ? this.buttonElement.addClass("ui-state-active").attr("aria-pressed", "true") : this.buttonElement.removeClass("ui-state-active").attr("aria-pressed", "false"))
    }, _resetButton: function () {
        if (this.type === "input") {
            this.options.label && this.element.val(this.options.label);
            return
        }
        var b = this.buttonElement.removeClass(i), c = a("<span></span>", this.document[0]).addClass("ui-button-text").html(this.options.label).appendTo(b.empty()).text(), d = this.options.icons, e = d.primary && d.secondary, f = [];
        d.primary || d.secondary ? (this.options.text && f.push("ui-button-text-icon" + (e ? "s" : d.primary ? "-primary" : "-secondary")), d.primary && b.prepend("<span class='ui-button-icon-primary ui-icon " + d.primary + "'></span>"), d.secondary && b.append("<span class='ui-button-icon-secondary ui-icon " + d.secondary + "'></span>"), this.options.text || (f.push(e ? "ui-button-icons-only" : "ui-button-icon-only"), this.hasTitle || b.attr("title", a.trim(c)))) : f.push("ui-button-text-only"), b.addClass(f.join(" "))
    }}), a.widget("ui.buttonset", {version: "1.9.2", options: {items: "button, input[type=button], input[type=submit], input[type=reset], input[type=checkbox], input[type=radio], a, :data(button)"}, _create: function () {
        this.element.addClass("ui-buttonset")
    }, _init: function () {
        this.refresh()
    }, _setOption: function (a, b) {
        a === "disabled" && this.buttons.button("option", a, b), this._super(a, b)
    }, refresh: function () {
        var b = this.element.css("direction") === "rtl";
        this.buttons = this.element.find(this.options.items).filter(":ui-button").button("refresh").end().not(":ui-button").button().end().map(function () {
            return a(this).button("widget")[0]
        }).removeClass("ui-corner-all ui-corner-left ui-corner-right").filter(":first").addClass(b ? "ui-corner-right" : "ui-corner-left").end().filter(":last").addClass(b ? "ui-corner-left" : "ui-corner-right").end().end()
    }, _destroy: function () {
        this.element.removeClass("ui-buttonset"), this.buttons.map(function () {
            return a(this).button("widget")[0]
        }).removeClass("ui-corner-left ui-corner-right").end().button("destroy")
    }})
}(jQuery), function ($, undefined) {
    function Datepicker() {
        this.debug = !1, this._curInst = null, this._keyEvent = !1, this._disabledInputs = [], this._datepickerShowing = !1, this._inDialog = !1, this._mainDivId = "ui-datepicker-div", this._inlineClass = "ui-datepicker-inline", this._appendClass = "ui-datepicker-append", this._triggerClass = "ui-datepicker-trigger", this._dialogClass = "ui-datepicker-dialog", this._disableClass = "ui-datepicker-disabled", this._unselectableClass = "ui-datepicker-unselectable", this._currentClass = "ui-datepicker-current-day", this._dayOverClass = "ui-datepicker-days-cell-over", this.regional = [], this.regional[""] = {closeText: "Done", prevText: "Prev", nextText: "Next", currentText: "Today", monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"], monthNamesShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"], dayNames: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], dayNamesShort: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], dayNamesMin: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"], weekHeader: "Wk", dateFormat: "mm/dd/yy", firstDay: 0, isRTL: !1, showMonthAfterYear: !1, yearSuffix: ""}, this._defaults = {showOn: "focus", showAnim: "fadeIn", showOptions: {}, defaultDate: null, appendText: "", buttonText: "...", buttonImage: "", buttonImageOnly: !1, hideIfNoPrevNext: !1, navigationAsDateFormat: !1, gotoCurrent: !1, changeMonth: !1, changeYear: !1, yearRange: "c-10:c+10", showOtherMonths: !1, selectOtherMonths: !1, showWeek: !1, calculateWeek: this.iso8601Week, shortYearCutoff: "+10", minDate: null, maxDate: null, duration: "fast", beforeShowDay: null, beforeShow: null, onSelect: null, onChangeMonthYear: null, onClose: null, numberOfMonths: 1, showCurrentAtPos: 0, stepMonths: 1, stepBigMonths: 12, altField: "", altFormat: "", constrainInput: !0, showButtonPanel: !1, autoSize: !1, disabled: !1}, $.extend(this._defaults, this.regional[""]), this.dpDiv = bindHover($('<div id="' + this._mainDivId + '" class="ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all"></div>'))
    }

    function bindHover(a) {
        var b = "button, .ui-datepicker-prev, .ui-datepicker-next, .ui-datepicker-calendar td a";
        return a.delegate(b, "mouseout",function () {
            $(this).removeClass("ui-state-hover"), this.className.indexOf("ui-datepicker-prev") != -1 && $(this).removeClass("ui-datepicker-prev-hover"), this.className.indexOf("ui-datepicker-next") != -1 && $(this).removeClass("ui-datepicker-next-hover")
        }).delegate(b, "mouseover", function () {
            $.datepicker._isDisabledDatepicker(instActive.inline ? a.parent()[0] : instActive.input[0]) || ($(this).parents(".ui-datepicker-calendar").find("a").removeClass("ui-state-hover"), $(this).addClass("ui-state-hover"), this.className.indexOf("ui-datepicker-prev") != -1 && $(this).addClass("ui-datepicker-prev-hover"), this.className.indexOf("ui-datepicker-next") != -1 && $(this).addClass("ui-datepicker-next-hover"))
        })
    }

    function extendRemove(a, b) {
        $.extend(a, b);
        for (var c in b)if (b[c] == null || b[c] == undefined)a[c] = b[c];
        return a
    }

    $.extend($.ui, {datepicker: {version: "1.9.2"}});
    var PROP_NAME = "datepicker", dpuuid = (new Date).getTime(), instActive;
    $.extend(Datepicker.prototype, {markerClassName: "hasDatepicker", maxRows: 4, log: function () {
        this.debug && console.log.apply("", arguments)
    }, _widgetDatepicker: function () {
        return this.dpDiv
    }, setDefaults: function (a) {
        return extendRemove(this._defaults, a || {}), this
    }, _attachDatepicker: function (target, settings) {
        var inlineSettings = null;
        for (var attrName in this._defaults) {
            var attrValue = target.getAttribute("date:" + attrName);
            if (attrValue) {
                inlineSettings = inlineSettings || {};
                try {
                    inlineSettings[attrName] = eval(attrValue)
                } catch (err) {
                    inlineSettings[attrName] = attrValue
                }
            }
        }
        var nodeName = target.nodeName.toLowerCase(), inline = nodeName == "div" || nodeName == "span";
        target.id || (this.uuid += 1, target.id = "dp" + this.uuid);
        var inst = this._newInst($(target), inline);
        inst.settings = $.extend({}, settings || {}, inlineSettings || {}), nodeName == "input" ? this._connectDatepicker(target, inst) : inline && this._inlineDatepicker(target, inst)
    }, _newInst: function (a, b) {
        var c = a[0].id.replace(/([^A-Za-z0-9_-])/g, "\\\\$1");
        return{id: c, input: a, selectedDay: 0, selectedMonth: 0, selectedYear: 0, drawMonth: 0, drawYear: 0, inline: b, dpDiv: b ? bindHover($('<div class="' + this._inlineClass + ' ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all"></div>')) : this.dpDiv}
    }, _connectDatepicker: function (a, b) {
        var c = $(a);
        b.append = $([]), b.trigger = $([]);
        if (c.hasClass(this.markerClassName))return;
        this._attachments(c, b), c.addClass(this.markerClassName).keydown(this._doKeyDown).keypress(this._doKeyPress).keyup(this._doKeyUp).bind("setData.datepicker",function (a, c, d) {
            b.settings[c] = d
        }).bind("getData.datepicker", function (a, c) {
            return this._get(b, c)
        }), this._autoSize(b), $.data(a, PROP_NAME, b), b.settings.disabled && this._disableDatepicker(a)
    }, _attachments: function (a, b) {
        var c = this._get(b, "appendText"), d = this._get(b, "isRTL");
        b.append && b.append.remove(), c && (b.append = $('<span class="' + this._appendClass + '">' + c + "</span>"), a[d ? "before" : "after"](b.append)), a.unbind("focus", this._showDatepicker), b.trigger && b.trigger.remove();
        var e = this._get(b, "showOn");
        (e == "focus" || e == "both") && a.focus(this._showDatepicker);
        if (e == "button" || e == "both") {
            var f = this._get(b, "buttonText"), g = this._get(b, "buttonImage");
            b.trigger = $(this._get(b, "buttonImageOnly") ? $("<img/>").addClass(this._triggerClass).attr({src: g, alt: f, title: f}) : $('<button type="button"></button>').addClass(this._triggerClass).html(g == "" ? f : $("<img/>").attr({src: g, alt: f, title: f}))), a[d ? "before" : "after"](b.trigger), b.trigger.click(function () {
                return $.datepicker._datepickerShowing && $.datepicker._lastInput == a[0] ? $.datepicker._hideDatepicker() : $.datepicker._datepickerShowing && $.datepicker._lastInput != a[0] ? ($.datepicker._hideDatepicker(), $.datepicker._showDatepicker(a[0])) : $.datepicker._showDatepicker(a[0]), !1
            })
        }
    }, _autoSize: function (a) {
        if (this._get(a, "autoSize") && !a.inline) {
            var b = new Date(2009, 11, 20), c = this._get(a, "dateFormat");
            if (c.match(/[DM]/)) {
                var d = function (a) {
                    var b = 0, c = 0;
                    for (var d = 0; d < a.length; d++)a[d].length > b && (b = a[d].length, c = d);
                    return c
                };
                b.setMonth(d(this._get(a, c.match(/MM/) ? "monthNames" : "monthNamesShort"))), b.setDate(d(this._get(a, c.match(/DD/) ? "dayNames" : "dayNamesShort")) + 20 - b.getDay())
            }
            a.input.attr("size", this._formatDate(a, b).length)
        }
    }, _inlineDatepicker: function (a, b) {
        var c = $(a);
        if (c.hasClass(this.markerClassName))return;
        c.addClass(this.markerClassName).append(b.dpDiv).bind("setData.datepicker",function (a, c, d) {
            b.settings[c] = d
        }).bind("getData.datepicker", function (a, c) {
            return this._get(b, c)
        }), $.data(a, PROP_NAME, b), this._setDate(b, this._getDefaultDate(b), !0), this._updateDatepicker(b), this._updateAlternate(b), b.settings.disabled && this._disableDatepicker(a), b.dpDiv.css("display", "block")
    }, _dialogDatepicker: function (a, b, c, d, e) {
        var f = this._dialogInst;
        if (!f) {
            this.uuid += 1;
            var g = "dp" + this.uuid;
            this._dialogInput = $('<input type="text" id="' + g + '" style="position: absolute; top: -100px; width: 0px;"/>'), this._dialogInput.keydown(this._doKeyDown), $("body").append(this._dialogInput), f = this._dialogInst = this._newInst(this._dialogInput, !1), f.settings = {}, $.data(this._dialogInput[0], PROP_NAME, f)
        }
        extendRemove(f.settings, d || {}), b = b && b.constructor == Date ? this._formatDate(f, b) : b, this._dialogInput.val(b), this._pos = e ? e.length ? e : [e.pageX, e.pageY] : null;
        if (!this._pos) {
            var h = document.documentElement.clientWidth, i = document.documentElement.clientHeight, j = document.documentElement.scrollLeft || document.body.scrollLeft, k = document.documentElement.scrollTop || document.body.scrollTop;
            this._pos = [h / 2 - 100 + j, i / 2 - 150 + k]
        }
        return this._dialogInput.css("left", this._pos[0] + 20 + "px").css("top", this._pos[1] + "px"), f.settings.onSelect = c, this._inDialog = !0, this.dpDiv.addClass(this._dialogClass), this._showDatepicker(this._dialogInput[0]), $.blockUI && $.blockUI(this.dpDiv), $.data(this._dialogInput[0], PROP_NAME, f), this
    }, _destroyDatepicker: function (a) {
        var b = $(a), c = $.data(a, PROP_NAME);
        if (!b.hasClass(this.markerClassName))return;
        var d = a.nodeName.toLowerCase();
        $.removeData(a, PROP_NAME), d == "input" ? (c.append.remove(), c.trigger.remove(), b.removeClass(this.markerClassName).unbind("focus", this._showDatepicker).unbind("keydown", this._doKeyDown).unbind("keypress", this._doKeyPress).unbind("keyup", this._doKeyUp)) : (d == "div" || d == "span") && b.removeClass(this.markerClassName).empty()
    }, _enableDatepicker: function (a) {
        var b = $(a), c = $.data(a, PROP_NAME);
        if (!b.hasClass(this.markerClassName))return;
        var d = a.nodeName.toLowerCase();
        if (d == "input")a.disabled = !1, c.trigger.filter("button").each(function () {
            this.disabled = !1
        }).end().filter("img").css({opacity: "1.0", cursor: ""}); else if (d == "div" || d == "span") {
            var e = b.children("." + this._inlineClass);
            e.children().removeClass("ui-state-disabled"), e.find("select.ui-datepicker-month, select.ui-datepicker-year").prop("disabled", !1)
        }
        this._disabledInputs = $.map(this._disabledInputs, function (b) {
            return b == a ? null : b
        })
    }, _disableDatepicker: function (a) {
        var b = $(a), c = $.data(a, PROP_NAME);
        if (!b.hasClass(this.markerClassName))return;
        var d = a.nodeName.toLowerCase();
        if (d == "input")a.disabled = !0, c.trigger.filter("button").each(function () {
            this.disabled = !0
        }).end().filter("img").css({opacity: "0.5", cursor: "default"}); else if (d == "div" || d == "span") {
            var e = b.children("." + this._inlineClass);
            e.children().addClass("ui-state-disabled"), e.find("select.ui-datepicker-month, select.ui-datepicker-year").prop("disabled", !0)
        }
        this._disabledInputs = $.map(this._disabledInputs, function (b) {
            return b == a ? null : b
        }), this._disabledInputs[this._disabledInputs.length] = a
    }, _isDisabledDatepicker: function (a) {
        if (!a)return!1;
        for (var b = 0; b < this._disabledInputs.length; b++)if (this._disabledInputs[b] == a)return!0;
        return!1
    }, _getInst: function (a) {
        try {
            return $.data(a, PROP_NAME)
        } catch (b) {
            throw"Missing instance data for this datepicker"
        }
    }, _optionDatepicker: function (a, b, c) {
        var d = this._getInst(a);
        if (arguments.length == 2 && typeof b == "string")return b == "defaults" ? $.extend({}, $.datepicker._defaults) : d ? b == "all" ? $.extend({}, d.settings) : this._get(d, b) : null;
        var e = b || {};
        typeof b == "string" && (e = {}, e[b] = c);
        if (d) {
            this._curInst == d && this._hideDatepicker();
            var f = this._getDateDatepicker(a, !0), g = this._getMinMaxDate(d, "min"), h = this._getMinMaxDate(d, "max");
            extendRemove(d.settings, e), g !== null && e.dateFormat !== undefined && e.minDate === undefined && (d.settings.minDate = this._formatDate(d, g)), h !== null && e.dateFormat !== undefined && e.maxDate === undefined && (d.settings.maxDate = this._formatDate(d, h)), this._attachments($(a), d), this._autoSize(d), this._setDate(d, f), this._updateAlternate(d), this._updateDatepicker(d)
        }
    }, _changeDatepicker: function (a, b, c) {
        this._optionDatepicker(a, b, c)
    }, _refreshDatepicker: function (a) {
        var b = this._getInst(a);
        b && this._updateDatepicker(b)
    }, _setDateDatepicker: function (a, b) {
        var c = this._getInst(a);
        c && (this._setDate(c, b), this._updateDatepicker(c), this._updateAlternate(c))
    }, _getDateDatepicker: function (a, b) {
        var c = this._getInst(a);
        return c && !c.inline && this._setDateFromField(c, b), c ? this._getDate(c) : null
    }, _doKeyDown: function (a) {
        var b = $.datepicker._getInst(a.target), c = !0, d = b.dpDiv.is(".ui-datepicker-rtl");
        b._keyEvent = !0;
        if ($.datepicker._datepickerShowing)switch (a.keyCode) {
            case 9:
                $.datepicker._hideDatepicker(), c = !1;
                break;
            case 13:
                var e = $("td." + $.datepicker._dayOverClass + ":not(." + $.datepicker._currentClass + ")", b.dpDiv);
                e[0] && $.datepicker._selectDay(a.target, b.selectedMonth, b.selectedYear, e[0]);
                var f = $.datepicker._get(b, "onSelect");
                if (f) {
                    var g = $.datepicker._formatDate(b);
                    f.apply(b.input ? b.input[0] : null, [g, b])
                } else $.datepicker._hideDatepicker();
                return!1;
            case 27:
                $.datepicker._hideDatepicker();
                break;
            case 33:
                $.datepicker._adjustDate(a.target, a.ctrlKey ? -$.datepicker._get(b, "stepBigMonths") : -$.datepicker._get(b, "stepMonths"), "M");
                break;
            case 34:
                $.datepicker._adjustDate(a.target, a.ctrlKey ? +$.datepicker._get(b, "stepBigMonths") : +$.datepicker._get(b, "stepMonths"), "M");
                break;
            case 35:
                (a.ctrlKey || a.metaKey) && $.datepicker._clearDate(a.target), c = a.ctrlKey || a.metaKey;
                break;
            case 36:
                (a.ctrlKey || a.metaKey) && $.datepicker._gotoToday(a.target), c = a.ctrlKey || a.metaKey;
                break;
            case 37:
                (a.ctrlKey || a.metaKey) && $.datepicker._adjustDate(a.target, d ? 1 : -1, "D"), c = a.ctrlKey || a.metaKey, a.originalEvent.altKey && $.datepicker._adjustDate(a.target, a.ctrlKey ? -$.datepicker._get(b, "stepBigMonths") : -$.datepicker._get(b, "stepMonths"), "M");
                break;
            case 38:
                (a.ctrlKey || a.metaKey) && $.datepicker._adjustDate(a.target, -7, "D"), c = a.ctrlKey || a.metaKey;
                break;
            case 39:
                (a.ctrlKey || a.metaKey) && $.datepicker._adjustDate(a.target, d ? -1 : 1, "D"), c = a.ctrlKey || a.metaKey, a.originalEvent.altKey && $.datepicker._adjustDate(a.target, a.ctrlKey ? +$.datepicker._get(b, "stepBigMonths") : +$.datepicker._get(b, "stepMonths"), "M");
                break;
            case 40:
                (a.ctrlKey || a.metaKey) && $.datepicker._adjustDate(a.target, 7, "D"), c = a.ctrlKey || a.metaKey;
                break;
            default:
                c = !1
        } else a.keyCode == 36 && a.ctrlKey ? $.datepicker._showDatepicker(this) : c = !1;
        c && (a.preventDefault(), a.stopPropagation())
    }, _doKeyPress: function (a) {
        var b = $.datepicker._getInst(a.target);
        if ($.datepicker._get(b, "constrainInput")) {
            var c = $.datepicker._possibleChars($.datepicker._get(b, "dateFormat")), d = String.fromCharCode(a.charCode == undefined ? a.keyCode : a.charCode);
            return a.ctrlKey || a.metaKey || d < " " || !c || c.indexOf(d) > -1
        }
    }, _doKeyUp: function (a) {
        var b = $.datepicker._getInst(a.target);
        if (b.input.val() != b.lastVal)try {
            var c = $.datepicker.parseDate($.datepicker._get(b, "dateFormat"), b.input ? b.input.val() : null, $.datepicker._getFormatConfig(b));
            c && ($.datepicker._setDateFromField(b), $.datepicker._updateAlternate(b), $.datepicker._updateDatepicker(b))
        } catch (d) {
            $.datepicker.log(d)
        }
        return!0
    }, _showDatepicker: function (a) {
        a = a.target || a, a.nodeName.toLowerCase() != "input" && (a = $("input", a.parentNode)[0]);
        if ($.datepicker._isDisabledDatepicker(a) || $.datepicker._lastInput == a)return;
        var b = $.datepicker._getInst(a);
        $.datepicker._curInst && $.datepicker._curInst != b && ($.datepicker._curInst.dpDiv.stop(!0, !0), b && $.datepicker._datepickerShowing && $.datepicker._hideDatepicker($.datepicker._curInst.input[0]));
        var c = $.datepicker._get(b, "beforeShow"), d = c ? c.apply(a, [a, b]) : {};
        if (d === !1)return;
        extendRemove(b.settings, d), b.lastVal = null, $.datepicker._lastInput = a, $.datepicker._setDateFromField(b), $.datepicker._inDialog && (a.value = ""), $.datepicker._pos || ($.datepicker._pos = $.datepicker._findPos(a), $.datepicker._pos[1] += a.offsetHeight);
        var e = !1;
        $(a).parents().each(function () {
            return e |= $(this).css("position") == "fixed", !e
        });
        var f = {left: $.datepicker._pos[0], top: $.datepicker._pos[1]};
        $.datepicker._pos = null, b.dpDiv.empty(), b.dpDiv.css({position: "absolute", display: "block", top: "-1000px"}), $.datepicker._updateDatepicker(b), f = $.datepicker._checkOffset(b, f, e), b.dpDiv.css({position: $.datepicker._inDialog && $.blockUI ? "static" : e ? "fixed" : "absolute", display: "none", left: f.left + "px", top: f.top + "px"});
        if (!b.inline) {
            var g = $.datepicker._get(b, "showAnim"), h = $.datepicker._get(b, "duration"), i = function () {
                var a = b.dpDiv.find("iframe.ui-datepicker-cover");
                if (!!a.length) {
                    var c = $.datepicker._getBorders(b.dpDiv);
                    a.css({left: -c[0], top: -c[1], width: b.dpDiv.outerWidth(), height: b.dpDiv.outerHeight()})
                }
            };
            b.dpDiv.zIndex($(a).zIndex() + 1), $.datepicker._datepickerShowing = !0, $.effects && ($.effects.effect[g] || $.effects[g]) ? b.dpDiv.show(g, $.datepicker._get(b, "showOptions"), h, i) : b.dpDiv[g || "show"](g ? h : null, i), (!g || !h) && i(), b.input.is(":visible") && !b.input.is(":disabled") && b.input.focus(), $.datepicker._curInst = b
        }
    }, _updateDatepicker: function (a) {
        this.maxRows = 4;
        var b = $.datepicker._getBorders(a.dpDiv);
        instActive = a, a.dpDiv.empty().append(this._generateHTML(a)), this._attachHandlers(a);
        var c = a.dpDiv.find("iframe.ui-datepicker-cover");
        !c.length || c.css({left: -b[0], top: -b[1], width: a.dpDiv.outerWidth
            (), height: a.dpDiv.outerHeight()}), a.dpDiv.find("." + this._dayOverClass + " a").mouseover();
        var d = this._getNumberOfMonths(a), e = d[1], f = 17;
        a.dpDiv.removeClass("ui-datepicker-multi-2 ui-datepicker-multi-3 ui-datepicker-multi-4").width(""), e > 1 && a.dpDiv.addClass("ui-datepicker-multi-" + e).css("width", f * e + "em"), a.dpDiv[(d[0] != 1 || d[1] != 1 ? "add" : "remove") + "Class"]("ui-datepicker-multi"), a.dpDiv[(this._get(a, "isRTL") ? "add" : "remove") + "Class"]("ui-datepicker-rtl"), a == $.datepicker._curInst && $.datepicker._datepickerShowing && a.input && a.input.is(":visible") && !a.input.is(":disabled") && a.input[0] != document.activeElement && a.input.focus();
        if (a.yearshtml) {
            var g = a.yearshtml;
            setTimeout(function () {
                g === a.yearshtml && a.yearshtml && a.dpDiv.find("select.ui-datepicker-year:first").replaceWith(a.yearshtml), g = a.yearshtml = null
            }, 0)
        }
    }, _getBorders: function (a) {
        var b = function (a) {
            return{thin: 1, medium: 2, thick: 3}[a] || a
        };
        return[parseFloat(b(a.css("border-left-width"))), parseFloat(b(a.css("border-top-width")))]
    }, _checkOffset: function (a, b, c) {
        var d = a.dpDiv.outerWidth(), e = a.dpDiv.outerHeight(), f = a.input ? a.input.outerWidth() : 0, g = a.input ? a.input.outerHeight() : 0, h = document.documentElement.clientWidth + (c ? 0 : $(document).scrollLeft()), i = document.documentElement.clientHeight + (c ? 0 : $(document).scrollTop());
        return b.left -= this._get(a, "isRTL") ? d - f : 0, b.left -= c && b.left == a.input.offset().left ? $(document).scrollLeft() : 0, b.top -= c && b.top == a.input.offset().top + g ? $(document).scrollTop() : 0, b.left -= Math.min(b.left, b.left + d > h && h > d ? Math.abs(b.left + d - h) : 0), b.top -= Math.min(b.top, b.top + e > i && i > e ? Math.abs(e + g) : 0), b
    }, _findPos: function (a) {
        var b = this._getInst(a), c = this._get(b, "isRTL");
        while (a && (a.type == "hidden" || a.nodeType != 1 || $.expr.filters.hidden(a)))a = a[c ? "previousSibling" : "nextSibling"];
        var d = $(a).offset();
        return[d.left, d.top]
    }, _hideDatepicker: function (a) {
        var b = this._curInst;
        if (!b || a && b != $.data(a, PROP_NAME))return;
        if (this._datepickerShowing) {
            var c = this._get(b, "showAnim"), d = this._get(b, "duration"), e = function () {
                $.datepicker._tidyDialog(b)
            };
            $.effects && ($.effects.effect[c] || $.effects[c]) ? b.dpDiv.hide(c, $.datepicker._get(b, "showOptions"), d, e) : b.dpDiv[c == "slideDown" ? "slideUp" : c == "fadeIn" ? "fadeOut" : "hide"](c ? d : null, e), c || e(), this._datepickerShowing = !1;
            var f = this._get(b, "onClose");
            f && f.apply(b.input ? b.input[0] : null, [b.input ? b.input.val() : "", b]), this._lastInput = null, this._inDialog && (this._dialogInput.css({position: "absolute", left: "0", top: "-100px"}), $.blockUI && ($.unblockUI(), $("body").append(this.dpDiv))), this._inDialog = !1
        }
    }, _tidyDialog: function (a) {
        a.dpDiv.removeClass(this._dialogClass).unbind(".ui-datepicker-calendar")
    }, _checkExternalClick: function (a) {
        if (!$.datepicker._curInst)return;
        var b = $(a.target), c = $.datepicker._getInst(b[0]);
        (b[0].id != $.datepicker._mainDivId && b.parents("#" + $.datepicker._mainDivId).length == 0 && !b.hasClass($.datepicker.markerClassName) && !b.closest("." + $.datepicker._triggerClass).length && $.datepicker._datepickerShowing && (!$.datepicker._inDialog || !$.blockUI) || b.hasClass($.datepicker.markerClassName) && $.datepicker._curInst != c) && $.datepicker._hideDatepicker()
    }, _adjustDate: function (a, b, c) {
        var d = $(a), e = this._getInst(d[0]);
        if (this._isDisabledDatepicker(d[0]))return;
        this._adjustInstDate(e, b + (c == "M" ? this._get(e, "showCurrentAtPos") : 0), c), this._updateDatepicker(e)
    }, _gotoToday: function (a) {
        var b = $(a), c = this._getInst(b[0]);
        if (this._get(c, "gotoCurrent") && c.currentDay)c.selectedDay = c.currentDay, c.drawMonth = c.selectedMonth = c.currentMonth, c.drawYear = c.selectedYear = c.currentYear; else {
            var d = new Date;
            c.selectedDay = d.getDate(), c.drawMonth = c.selectedMonth = d.getMonth(), c.drawYear = c.selectedYear = d.getFullYear()
        }
        this._notifyChange(c), this._adjustDate(b)
    }, _selectMonthYear: function (a, b, c) {
        var d = $(a), e = this._getInst(d[0]);
        e["selected" + (c == "M" ? "Month" : "Year")] = e["draw" + (c == "M" ? "Month" : "Year")] = parseInt(b.options[b.selectedIndex].value, 10), this._notifyChange(e), this._adjustDate(d)
    }, _selectDay: function (a, b, c, d) {
        var e = $(a);
        if ($(d).hasClass(this._unselectableClass) || this._isDisabledDatepicker(e[0]))return;
        var f = this._getInst(e[0]);
        f.selectedDay = f.currentDay = $("a", d).html(), f.selectedMonth = f.currentMonth = b, f.selectedYear = f.currentYear = c, this._selectDate(a, this._formatDate(f, f.currentDay, f.currentMonth, f.currentYear))
    }, _clearDate: function (a) {
        var b = $(a), c = this._getInst(b[0]);
        this._selectDate(b, "")
    }, _selectDate: function (a, b) {
        var c = $(a), d = this._getInst(c[0]);
        b = b != null ? b : this._formatDate(d), d.input && d.input.val(b), this._updateAlternate(d);
        var e = this._get(d, "onSelect");
        e ? e.apply(d.input ? d.input[0] : null, [b, d]) : d.input && d.input.trigger("change"), d.inline ? this._updateDatepicker(d) : (this._hideDatepicker(), this._lastInput = d.input[0], typeof d.input[0] != "object" && d.input.focus(), this._lastInput = null)
    }, _updateAlternate: function (a) {
        var b = this._get(a, "altField");
        if (b) {
            var c = this._get(a, "altFormat") || this._get(a, "dateFormat"), d = this._getDate(a), e = this.formatDate(c, d, this._getFormatConfig(a));
            $(b).each(function () {
                $(this).val(e)
            })
        }
    }, noWeekends: function (a) {
        var b = a.getDay();
        return[b > 0 && b < 6, ""]
    }, iso8601Week: function (a) {
        var b = new Date(a.getTime());
        b.setDate(b.getDate() + 4 - (b.getDay() || 7));
        var c = b.getTime();
        return b.setMonth(0), b.setDate(1), Math.floor(Math.round((c - b) / 864e5) / 7) + 1
    }, parseDate: function (a, b, c) {
        if (a == null || b == null)throw"Invalid arguments";
        b = typeof b == "object" ? b.toString() : b + "";
        if (b == "")return null;
        var d = (c ? c.shortYearCutoff : null) || this._defaults.shortYearCutoff;
        d = typeof d != "string" ? d : (new Date).getFullYear() % 100 + parseInt(d, 10);
        var e = (c ? c.dayNamesShort : null) || this._defaults.dayNamesShort, f = (c ? c.dayNames : null) || this._defaults.dayNames, g = (c ? c.monthNamesShort : null) || this._defaults.monthNamesShort, h = (c ? c.monthNames : null) || this._defaults.monthNames, i = -1, j = -1, k = -1, l = -1, m = !1, n = function (b) {
            var c = s + 1 < a.length && a.charAt(s + 1) == b;
            return c && s++, c
        }, o = function (a) {
            var c = n(a), d = a == "@" ? 14 : a == "!" ? 20 : a == "y" && c ? 4 : a == "o" ? 3 : 2, e = new RegExp("^\\d{1," + d + "}"), f = b.substring(r).match(e);
            if (!f)throw"Missing number at position " + r;
            return r += f[0].length, parseInt(f[0], 10)
        }, p = function (a, c, d) {
            var e = $.map(n(a) ? d : c,function (a, b) {
                return[
                    [b, a]
                ]
            }).sort(function (a, b) {
                return-(a[1].length - b[1].length)
            }), f = -1;
            $.each(e, function (a, c) {
                var d = c[1];
                if (b.substr(r, d.length).toLowerCase() == d.toLowerCase())return f = c[0], r += d.length, !1
            });
            if (f != -1)return f + 1;
            throw"Unknown name at position " + r
        }, q = function () {
            if (b.charAt(r) != a.charAt(s))throw"Unexpected literal at position " + r;
            r++
        }, r = 0;
        for (var s = 0; s < a.length; s++)if (m)a.charAt(s) == "'" && !n("'") ? m = !1 : q(); else switch (a.charAt(s)) {
            case"d":
                k = o("d");
                break;
            case"D":
                p("D", e, f);
                break;
            case"o":
                l = o("o");
                break;
            case"m":
                j = o("m");
                break;
            case"M":
                j = p("M", g, h);
                break;
            case"y":
                i = o("y");
                break;
            case"@":
                var t = new Date(o("@"));
                i = t.getFullYear(), j = t.getMonth() + 1, k = t.getDate();
                break;
            case"!":
                var t = new Date((o("!") - this._ticksTo1970) / 1e4);
                i = t.getFullYear(), j = t.getMonth() + 1, k = t.getDate();
                break;
            case"'":
                n("'") ? q() : m = !0;
                break;
            default:
                q()
        }
        if (r < b.length) {
            var u = b.substr(r);
            if (!/^\s+/.test(u))throw"Extra/unparsed characters found in date: " + u
        }
        i == -1 ? i = (new Date).getFullYear() : i < 100 && (i += (new Date).getFullYear() - (new Date).getFullYear() % 100 + (i <= d ? 0 : -100));
        if (l > -1) {
            j = 1, k = l;
            do {
                var v = this._getDaysInMonth(i, j - 1);
                if (k <= v)break;
                j++, k -= v
            } while (!0)
        }
        var t = this._daylightSavingAdjust(new Date(i, j - 1, k));
        if (t.getFullYear() != i || t.getMonth() + 1 != j || t.getDate() != k)throw"Invalid date";
        return t
    }, ATOM: "yy-mm-dd", COOKIE: "D, dd M yy", ISO_8601: "yy-mm-dd", RFC_822: "D, d M y", RFC_850: "DD, dd-M-y", RFC_1036: "D, d M y", RFC_1123: "D, d M yy", RFC_2822: "D, d M yy", RSS: "D, d M y", TICKS: "!", TIMESTAMP: "@", W3C: "yy-mm-dd", _ticksTo1970: (718685 + Math.floor(492.5) - Math.floor(19.7) + Math.floor(4.925)) * 24 * 60 * 60 * 1e7, formatDate: function (a, b, c) {
        if (!b)return"";
        var d = (c ? c.dayNamesShort : null) || this._defaults.dayNamesShort, e = (c ? c.dayNames : null) || this._defaults.dayNames, f = (c ? c.monthNamesShort : null) || this._defaults.monthNamesShort, g = (c ? c.monthNames : null) || this._defaults.monthNames, h = function (b) {
            var c = m + 1 < a.length && a.charAt(m + 1) == b;
            return c && m++, c
        }, i = function (a, b, c) {
            var d = "" + b;
            if (h(a))while (d.length < c)d = "0" + d;
            return d
        }, j = function (a, b, c, d) {
            return h(a) ? d[b] : c[b]
        }, k = "", l = !1;
        if (b)for (var m = 0; m < a.length; m++)if (l)a.charAt(m) == "'" && !h("'") ? l = !1 : k += a.charAt(m); else switch (a.charAt(m)) {
            case"d":
                k += i("d", b.getDate(), 2);
                break;
            case"D":
                k += j("D", b.getDay(), d, e);
                break;
            case"o":
                k += i("o", Math.round(((new Date(b.getFullYear(), b.getMonth(), b.getDate())).getTime() - (new Date(b.getFullYear(), 0, 0)).getTime()) / 864e5), 3);
                break;
            case"m":
                k += i("m", b.getMonth() + 1, 2);
                break;
            case"M":
                k += j("M", b.getMonth(), f, g);
                break;
            case"y":
                k += h("y") ? b.getFullYear() : (b.getYear() % 100 < 10 ? "0" : "") + b.getYear() % 100;
                break;
            case"@":
                k += b.getTime();
                break;
            case"!":
                k += b.getTime() * 1e4 + this._ticksTo1970;
                break;
            case"'":
                h("'") ? k += "'" : l = !0;
                break;
            default:
                k += a.charAt(m)
        }
        return k
    }, _possibleChars: function (a) {
        var b = "", c = !1, d = function (b) {
            var c = e + 1 < a.length && a.charAt(e + 1) == b;
            return c && e++, c
        };
        for (var e = 0; e < a.length; e++)if (c)a.charAt(e) == "'" && !d("'") ? c = !1 : b += a.charAt(e); else switch (a.charAt(e)) {
            case"d":
            case"m":
            case"y":
            case"@":
                b += "0123456789";
                break;
            case"D":
            case"M":
                return null;
            case"'":
                d("'") ? b += "'" : c = !0;
                break;
            default:
                b += a.charAt(e)
        }
        return b
    }, _get: function (a, b) {
        return a.settings[b] !== undefined ? a.settings[b] : this._defaults[b]
    }, _setDateFromField: function (a, b) {
        if (a.input.val() == a.lastVal)return;
        var c = this._get(a, "dateFormat"), d = a.lastVal = a.input ? a.input.val() : null, e, f;
        e = f = this._getDefaultDate(a);
        var g = this._getFormatConfig(a);
        try {
            e = this.parseDate(c, d, g) || f
        } catch (h) {
            this.log(h), d = b ? "" : d
        }
        a.selectedDay = e.getDate(), a.drawMonth = a.selectedMonth = e.getMonth(), a.drawYear = a.selectedYear = e.getFullYear(), a.currentDay = d ? e.getDate() : 0, a.currentMonth = d ? e.getMonth() : 0, a.currentYear = d ? e.getFullYear() : 0, this._adjustInstDate(a)
    }, _getDefaultDate: function (a) {
        return this._restrictMinMax(a, this._determineDate(a, this._get(a, "defaultDate"), new Date))
    }, _determineDate: function (a, b, c) {
        var d = function (a) {
            var b = new Date;
            return b.setDate(b.getDate() + a), b
        }, e = function (b) {
            try {
                return $.datepicker.parseDate($.datepicker._get(a, "dateFormat"), b, $.datepicker._getFormatConfig(a))
            } catch (c) {
            }
            var d = (b.toLowerCase().match(/^c/) ? $.datepicker._getDate(a) : null) || new Date, e = d.getFullYear(), f = d.getMonth(), g = d.getDate(), h = /([+-]?[0-9]+)\s*(d|D|w|W|m|M|y|Y)?/g, i = h.exec(b);
            while (i) {
                switch (i[2] || "d") {
                    case"d":
                    case"D":
                        g += parseInt(i[1], 10);
                        break;
                    case"w":
                    case"W":
                        g += parseInt(i[1], 10) * 7;
                        break;
                    case"m":
                    case"M":
                        f += parseInt(i[1], 10), g = Math.min(g, $.datepicker._getDaysInMonth(e, f));
                        break;
                    case"y":
                    case"Y":
                        e += parseInt(i[1], 10), g = Math.min(g, $.datepicker._getDaysInMonth(e, f))
                }
                i = h.exec(b)
            }
            return new Date(e, f, g)
        }, f = b == null || b === "" ? c : typeof b == "string" ? e(b) : typeof b == "number" ? isNaN(b) ? c : d(b) : new Date(b.getTime());
        return f = f && f.toString() == "Invalid Date" ? c : f, f && (f.setHours(0), f.setMinutes(0), f.setSeconds(0), f.setMilliseconds(0)), this._daylightSavingAdjust(f)
    }, _daylightSavingAdjust: function (a) {
        return a ? (a.setHours(a.getHours() > 12 ? a.getHours() + 2 : 0), a) : null
    }, _setDate: function (a, b, c) {
        var d = !b, e = a.selectedMonth, f = a.selectedYear, g = this._restrictMinMax(a, this._determineDate(a, b, new Date));
        a.selectedDay = a.currentDay = g.getDate(), a.drawMonth = a.selectedMonth = a.currentMonth = g.getMonth(), a.drawYear = a.selectedYear = a.currentYear = g.getFullYear(), (e != a.selectedMonth || f != a.selectedYear) && !c && this._notifyChange(a), this._adjustInstDate(a), a.input && a.input.val(d ? "" : this._formatDate(a))
    }, _getDate: function (a) {
        var b = !a.currentYear || a.input && a.input.val() == "" ? null : this._daylightSavingAdjust(new Date(a.currentYear, a.currentMonth, a.currentDay));
        return b
    }, _attachHandlers: function (a) {
        var b = this._get(a, "stepMonths"), c = "#" + a.id.replace(/\\\\/g, "\\");
        a.dpDiv.find("[data-handler]").map(function () {
            var a = {prev: function () {
                window["DP_jQuery_" + dpuuid].datepicker._adjustDate(c, -b, "M")
            }, next: function () {
                window["DP_jQuery_" + dpuuid].datepicker._adjustDate(c, +b, "M")
            }, hide: function () {
                window["DP_jQuery_" + dpuuid].datepicker._hideDatepicker()
            }, today: function () {
                window["DP_jQuery_" + dpuuid].datepicker._gotoToday(c)
            }, selectDay: function () {
                return window["DP_jQuery_" + dpuuid].datepicker._selectDay(c, +this.getAttribute("data-month"), +this.getAttribute("data-year"), this), !1
            }, selectMonth: function () {
                return window["DP_jQuery_" + dpuuid].datepicker._selectMonthYear(c, this, "M"), !1
            }, selectYear: function () {
                return window["DP_jQuery_" + dpuuid].datepicker._selectMonthYear(c, this, "Y"), !1
            }};
            $(this).bind(this.getAttribute("data-event"), a[this.getAttribute("data-handler")])
        })
    }, _generateHTML: function (a) {
        var b = new Date;
        b = this._daylightSavingAdjust(new Date(b.getFullYear(), b.getMonth(), b.getDate()));
        var c = this._get(a, "isRTL"), d = this._get(a, "showButtonPanel"), e = this._get(a, "hideIfNoPrevNext"), f = this._get(a, "navigationAsDateFormat"), g = this._getNumberOfMonths(a), h = this._get(a, "showCurrentAtPos"), i = this._get(a, "stepMonths"), j = g[0] != 1 || g[1] != 1, k = this._daylightSavingAdjust(a.currentDay ? new Date(a.currentYear, a.currentMonth, a.currentDay) : new Date(9999, 9, 9)), l = this._getMinMaxDate(a, "min"), m = this._getMinMaxDate(a, "max"), n = a.drawMonth - h, o = a.drawYear;
        n < 0 && (n += 12, o--);
        if (m) {
            var p = this._daylightSavingAdjust(new Date(m.getFullYear(), m.getMonth() - g[0] * g[1] + 1, m.getDate()));
            p = l && p < l ? l : p;
            while (this._daylightSavingAdjust(new Date(o, n, 1)) > p)n--, n < 0 && (n = 11, o--)
        }
        a.drawMonth = n, a.drawYear = o;
        var q = this._get(a, "prevText");
        q = f ? this.formatDate(q, this._daylightSavingAdjust(new Date(o, n - i, 1)), this._getFormatConfig(a)) : q;
        var r = this._canAdjustMonth(a, -1, o, n) ? '<a class="ui-datepicker-prev ui-corner-all" data-handler="prev" data-event="click" title="' + q + '"><span class="ui-icon ui-icon-circle-triangle-' + (c ? "e" : "w") + '">' + q + "</span></a>" : e ? "" : '<a class="ui-datepicker-prev ui-corner-all ui-state-disabled" title="' + q + '"><span class="ui-icon ui-icon-circle-triangle-' + (c ? "e" : "w") + '">' + q + "</span></a>", s = this._get(a, "nextText");
        s = f ? this.formatDate(s, this._daylightSavingAdjust(new Date(o, n + i, 1)), this._getFormatConfig(a)) : s;
        var t = this._canAdjustMonth(a, 1, o, n) ? '<a class="ui-datepicker-next ui-corner-all" data-handler="next" data-event="click" title="' + s + '"><span class="ui-icon ui-icon-circle-triangle-' + (c ? "w" : "e") + '">' + s + "</span></a>" : e ? "" : '<a class="ui-datepicker-next ui-corner-all ui-state-disabled" title="' + s + '"><span class="ui-icon ui-icon-circle-triangle-' + (c ? "w" : "e") + '">' + s + "</span></a>", u = this._get(a, "currentText"), v = this._get(a, "gotoCurrent") && a.currentDay ? k : b;
        u = f ? this.formatDate(u, v, this._getFormatConfig(a)) : u;
        var w = a.inline ? "" : '<button type="button" class="ui-datepicker-close ui-state-default ui-priority-primary ui-corner-all" data-handler="hide" data-event="click">' + this._get(a, "closeText") + "</button>", x = d ? '<div class="ui-datepicker-buttonpane ui-widget-content">' + (c ? w : "") + (this._isInRange(a, v) ? '<button type="button" class="ui-datepicker-current ui-state-default ui-priority-secondary ui-corner-all" data-handler="today" data-event="click">' + u + "</button>" : "") + (c ? "" : w) + "</div>" : "", y = parseInt(this._get(a, "firstDay"), 10);
        y = isNaN(y) ? 0 : y;
        var z = this._get(a, "showWeek"), A = this._get(a, "dayNames"), B = this._get(a, "dayNamesShort"), C = this._get(a, "dayNamesMin"), D = this._get(a, "monthNames"), E = this._get(a, "monthNamesShort"), F = this._get(a, "beforeShowDay"), G = this._get(a, "showOtherMonths"), H = this._get(a, "selectOtherMonths"), I = this._get(a, "calculateWeek") || this.iso8601Week, J = this._getDefaultDate(a), K = "";
        for (var L = 0; L < g[0]; L++) {
            var M = "";
            this.maxRows = 4;
            for (var N = 0; N < g[1]; N++) {
                var O = this._daylightSavingAdjust(new Date(o, n, a.selectedDay)), P = " ui-corner-all", Q = "";
                if (j) {
                    Q += '<div class="ui-datepicker-group';
                    if (g[1] > 1)switch (N) {
                        case 0:
                            Q += " ui-datepicker-group-first", P = " ui-corner-" + (c ? "right" : "left");
                            break;
                        case g[1] - 1:
                            Q += " ui-datepicker-group-last", P = " ui-corner-" + (c ? "left" : "right");
                            break;
                        default:
                            Q += " ui-datepicker-group-middle", P = ""
                    }
                    Q += '">'
                }
                Q += '<div class="ui-datepicker-header ui-widget-header ui-helper-clearfix' + P + '">' + (/all|left/.test(P) && L == 0 ? c ? t : r : "") + (/all|right/.test(P) && L == 0 ? c ? r : t : "") + this._generateMonthYearHeader(a, n, o, l, m, L > 0 || N > 0, D, E) + '</div><table class="ui-datepicker-calendar"><thead>' + "<tr>";
                var R = z ? '<th class="ui-datepicker-week-col">' + this._get(a, "weekHeader") + "</th>" : "";
                for (var S = 0; S < 7; S++) {
                    var T = (S + y) % 7;
                    R += "<th" + ((S + y + 6) % 7 >= 5 ? ' class="ui-datepicker-week-end"' : "") + ">" + '<span title="' + A[T] + '">' + C[T] + "</span></th>"
                }
                Q += R + "</tr></thead><tbody>";
                var U = this._getDaysInMonth(o, n);
                o == a.selectedYear && n == a.selectedMonth && (a.selectedDay = Math.min(a.selectedDay, U));
                var V = (this._getFirstDayOfMonth(o, n) - y + 7) % 7, W = Math.ceil((V + U) / 7), X = j ? this.maxRows > W ? this.maxRows : W : W;
                this.maxRows = X;
                var Y = this._daylightSavingAdjust(new Date(o, n, 1 - V));
                for (var Z = 0; Z < X; Z++) {
                    Q += "<tr>";
                    var _ = z ? '<td class="ui-datepicker-week-col">' + this._get(a, "calculateWeek")(Y) + "</td>" : "";
                    for (var S = 0; S < 7; S++) {
                        var ba = F ? F.apply(a.input ? a.input[0] : null, [Y]) : [!0, ""], bb = Y.getMonth() != n, bc = bb && !H || !ba[0] || l && Y < l || m && Y > m;
                        _ += '<td class="' + ((S + y + 6) % 7 >= 5 ? " ui-datepicker-week-end" : "") + (bb ? " ui-datepicker-other-month" : "") + (Y.getTime() == O.getTime() && n == a.selectedMonth && a._keyEvent || J.getTime() == Y.getTime() && J.getTime() == O.getTime() ? " " + this._dayOverClass : "") + (bc ? " " + this._unselectableClass + " ui-state-disabled" : "") + (bb && !G ? "" : " " + ba[1] + (Y.getTime() == k.getTime() ? " " + this._currentClass : "") + (Y.getTime() == b.getTime() ? " ui-datepicker-today" : "")) + '"' + ((!bb || G) && ba[2] ? ' title="' + ba[2] + '"' : "") + (bc ? "" : ' data-handler="selectDay" data-event="click" data-month="' + Y.getMonth() + '" data-year="' + Y.getFullYear() + '"') + ">" + (bb && !G ? "&#xa0;" : bc ? '<span class="ui-state-default">' + Y.getDate() + "</span>" : '<a class="ui-state-default' + (Y.getTime() == b.getTime() ? " ui-state-highlight" : "") + (Y.getTime() == k.getTime() ? " ui-state-active" : "") + (bb ? " ui-priority-secondary" : "") + '" href="#">' + Y.getDate() + "</a>") + "</td>", Y.setDate(Y.getDate() + 1), Y = this._daylightSavingAdjust(Y)
                    }
                    Q += _ + "</tr>"
                }
                n++, n > 11 && (n = 0, o++), Q += "</tbody></table>" + (j ? "</div>" + (g[0] > 0 && N == g[1] - 1 ? '<div class="ui-datepicker-row-break"></div>' : "") : ""), M += Q
            }
            K += M
        }
        return K += x + ($.ui.ie6 && !a.inline ? '<iframe src="javascript:false;" class="ui-datepicker-cover" frameborder="0"></iframe>' : ""), a._keyEvent = !1, K
    }, _generateMonthYearHeader: function (a, b, c, d, e, f, g, h) {
        var i = this._get(a, "changeMonth"), j = this._get(a, "changeYear"), k = this._get(a, "showMonthAfterYear"), l = '<div class="ui-datepicker-title">', m = "";
        if (f || !i)m += '<span class="ui-datepicker-month">' + g[b] + "</span>"; else {
            var n = d && d.getFullYear() == c, o = e && e.getFullYear() == c;
            m += '<select class="ui-datepicker-month" data-handler="selectMonth" data-event="change">';
            for (var p = 0; p < 12; p++)(!n || p >= d.getMonth()) && (!o || p <= e.getMonth()) && (m += '<option value="' + p + '"' + (p == b ? ' selected="selected"' : "") + ">" + h[p] + "</option>");
            m += "</select>"
        }
        k || (l += m + (f || !i || !j ? "&#xa0;" : ""));
        if (!a.yearshtml) {
            a.yearshtml = "";
            if (f || !j)l += '<span class="ui-datepicker-year">' + c + "</span>"; else {
                var q = this._get(a, "yearRange").split(":"), r = (new Date).getFullYear(), s = function (a) {
                    var b = a.match(/c[+-].*/) ? c + parseInt(a.substring(1), 10) : a.match(/[+-].*/) ? r + parseInt(a, 10) : parseInt(a, 10);
                    return isNaN(b) ? r : b
                }, t = s(q[0]), u = Math.max(t, s(q[1] || ""));
                t = d ? Math.max(t, d.getFullYear()) : t, u = e ? Math.min(u, e.getFullYear()) : u, a.yearshtml += '<select class="ui-datepicker-year" data-handler="selectYear" data-event="change">';
                for (; t <= u; t++)a.yearshtml += '<option value="' + t + '"' + (t == c ? ' selected="selected"' : "") + ">" + t + "</option>";
                a.yearshtml += "</select>", l += a.yearshtml, a.yearshtml = null
            }
        }
        return l += this._get(a, "yearSuffix"), k && (l += (f || !i || !j ? "&#xa0;" : "") + m), l += "</div>", l
    }, _adjustInstDate: function (a, b, c) {
        var d = a.drawYear + (c == "Y" ? b : 0), e = a.drawMonth + (c == "M" ? b : 0), f = Math.min(a.selectedDay, this._getDaysInMonth(d, e)) + (c == "D" ? b : 0), g = this._restrictMinMax(a, this._daylightSavingAdjust(new Date(d, e, f)));
        a.selectedDay = g.getDate(), a.drawMonth = a.selectedMonth = g.getMonth(), a.drawYear = a.selectedYear = g.getFullYear(), (c == "M" || c == "Y") && this._notifyChange(a)
    }, _restrictMinMax: function (a, b) {
        var c = this._getMinMaxDate(a, "min"), d = this._getMinMaxDate(a, "max"), e = c && b < c ? c : b;
        return e = d && e > d ? d : e, e
    }, _notifyChange: function (a) {
        var b = this._get(a, "onChangeMonthYear");
        b && b.apply(a.input ? a.input[0] : null, [a.selectedYear, a.selectedMonth + 1, a])
    }, _getNumberOfMonths: function (a) {
        var b = this._get(a, "numberOfMonths");
        return b == null ? [1, 1] : typeof b == "number" ? [1, b] : b
    }, _getMinMaxDate: function (a, b) {
        return this._determineDate(a, this._get(a, b + "Date"), null)
    }, _getDaysInMonth: function (a, b) {
        return 32 - this._daylightSavingAdjust(new Date(a, b, 32)).getDate()
    }, _getFirstDayOfMonth: function (a, b) {
        return(new Date(a, b, 1)).getDay()
    }, _canAdjustMonth: function (a, b, c, d) {
        var e = this._getNumberOfMonths(a), f = this._daylightSavingAdjust(new Date(c, d + (b < 0 ? b : e[0] * e[1]), 1));
        return b < 0 && f.setDate(this._getDaysInMonth(f.getFullYear(), f.getMonth())), this._isInRange(a, f)
    }, _isInRange: function (a, b) {
        var c = this._getMinMaxDate(a, "min"), d = this._getMinMaxDate(a, "max");
        return(!c || b.getTime() >= c.getTime()) && (!d || b.getTime() <= d.getTime())
    }, _getFormatConfig: function (a) {
        var b = this._get(a, "shortYearCutoff");
        return b = typeof b != "string" ? b : (new Date).getFullYear() % 100 + parseInt(b, 10), {shortYearCutoff: b, dayNamesShort: this._get(a, "dayNamesShort"), dayNames: this._get(a, "dayNames"), monthNamesShort: this._get(a, "monthNamesShort"), monthNames: this._get(a, "monthNames")}
    }, _formatDate: function (a, b, c, d) {
        b || (a.currentDay = a.selectedDay, a.currentMonth = a.selectedMonth, a.currentYear = a.selectedYear);
        var e = b ? typeof b == "object" ? b : this._daylightSavingAdjust(new Date(d, c, b)) : this._daylightSavingAdjust(new Date(a.currentYear, a.currentMonth, a.currentDay));
        return this.formatDate(this._get(a, "dateFormat"), e, this._getFormatConfig(a))
    }}), $.fn.datepicker = function (a) {
        if (!this.length)return this;
        $.datepicker.initialized || ($(document).mousedown($.datepicker._checkExternalClick).find(document.body).append($.datepicker.dpDiv), $.datepicker.initialized = !0);
        var b = Array.prototype.slice.call(arguments, 1);
        return typeof a != "string" || a != "isDisabled" && a != "getDate" && a != "widget" ? a == "option" && arguments.length == 2 && typeof arguments[1] == "string" ? $.datepicker["_" + a + "Datepicker"].apply($.datepicker, [this[0]].concat(b)) : this.each(function () {
            typeof a == "string" ? $.datepicker["_" + a + "Datepicker"].apply($.datepicker, [this].concat(b)) : $.datepicker._attachDatepicker(this, a)
        }) : $.datepicker["_" + a + "Datepicker"].apply($.datepicker, [this[0]].concat(b))
    }, $.datepicker = new Datepicker, $.datepicker.initialized = !1, $.datepicker.uuid = (new Date).getTime(), $.datepicker.version = "1.9.2", window["DP_jQuery_" + dpuuid] = $
}(jQuery), function (a, b) {
    var c = "ui-dialog ui-widget ui-widget-content ui-corner-all ", d = {buttons: !0, height: !0, maxHeight: !0, maxWidth: !0, minHeight: !0, minWidth: !0, width: !0}, e = {maxHeight: !0, maxWidth: !0, minHeight: !0, minWidth: !0};
    a.widget("ui.dialog", {version: "1.9.2", options: {autoOpen: !0, buttons: {}, closeOnEscape: !0, closeText: "close", dialogClass: "", draggable: !0, hide: null, height: "auto", maxHeight: !1, maxWidth: !1, minHeight: 150, minWidth: 150, modal: !1, position: {my: "center", at: "center", of: window, collision: "fit", using: function (b) {
        var c = a(this).css(b).offset().top;
        c < 0 && a(this).css("top", b.top - c)
    }}, resizable: !0, show: null, stack: !0, title: "", width: 300, zIndex: 1e3}, _create: function () {
        this.originalTitle = this.element.attr("title"), typeof this.originalTitle != "string" && (this.originalTitle = ""), this.oldPosition = {parent: this.element.parent(), index: this.element.parent().children().index(this.element)}, this.options.title = this.options.title || this.originalTitle;
        var b = this, d = this.options, e = d.title || "&#160;", f, g, h, i, j;
        f = (this.uiDialog = a("<div>")).addClass(c + d.dialogClass).css({display: "none", outline: 0, zIndex: d.zIndex}).attr("tabIndex", -1).keydown(function (c) {
            d.closeOnEscape && !c.isDefaultPrevented() && c.keyCode && c.keyCode === a.ui.keyCode.ESCAPE && (b.close(c), c.preventDefault())
        }).mousedown(function (a) {
            b.moveToTop(!1, a)
        }).appendTo("body"), this.element.show().removeAttr("title").addClass("ui-dialog-content ui-widget-content").appendTo(f), g = (this.uiDialogTitlebar = a("<div>")).addClass("ui-dialog-titlebar  ui-widget-header  ui-corner-all  ui-helper-clearfix").bind("mousedown",function () {
            f.focus()
        }).prependTo(f), h = a("<a href='#'></a>").addClass("ui-dialog-titlebar-close  ui-corner-all").attr("role", "button").click(function (a) {
            a.preventDefault(), b.close(a)
        }).appendTo(g), (this.uiDialogTitlebarCloseText = a("<span>")).addClass("ui-icon ui-icon-closethick").text(d.closeText).appendTo(h), i = a("<span>").uniqueId().addClass("ui-dialog-title").html(e).prependTo(g), j = (this.uiDialogButtonPane = a("<div>")).addClass("ui-dialog-buttonpane ui-widget-content ui-helper-clearfix"), (this.uiButtonSet = a("<div>")).addClass("ui-dialog-buttonset").appendTo(j), f.attr({role: "dialog", "aria-labelledby": i.attr("id")}), g.find("*").add(g).disableSelection(), this._hoverable(h), this._focusable(h), d.draggable && a.fn.draggable && this._makeDraggable(), d.resizable && a.fn.resizable && this._makeResizable(), this._createButtons(d.buttons), this._isOpen = !1, a.fn.bgiframe && f.bgiframe(), this._on(f, {keydown: function (b) {
            if (!d.modal || b.keyCode !== a.ui.keyCode.TAB)return;
            var c = a(":tabbable", f), e = c.filter(":first"), g = c.filter(":last");
            if (b.target === g[0] && !b.shiftKey)return e.focus(1), !1;
            if (b.target === e[0] && b.shiftKey)return g.focus(1), !1
        }})
    }, _init: function () {
        this.options.autoOpen && this.open()
    }, _destroy: function () {
        var a, b = this.oldPosition;
        this.overlay && this.overlay.destroy(), this.uiDialog.hide(), this.element.removeClass("ui-dialog-content ui-widget-content").hide().appendTo("body"), this.uiDialog.remove(), this.originalTitle && this.element.attr("title", this.originalTitle), a = b.parent.children().eq(b.index), a.length && a[0] !== this.element[0] ? a.before(this.element) : b.parent.append(this.element)
    }, widget: function () {
        return this.uiDialog
    }, close: function (b) {
        var c = this, d, e;
        if (!this._isOpen)return;
        if (!1 === this._trigger("beforeClose", b))return;
        return this._isOpen = !1, this.overlay && this.overlay.destroy(), this.options.hide ? this._hide(this.uiDialog, this.options.hide, function () {
            c._trigger("close", b)
        }) : (this.uiDialog.hide(), this._trigger("close", b)), a.ui.dialog.overlay.resize(), this.options.modal && (d = 0, a(".ui-dialog").each(function () {
            this !== c.uiDialog[0] && (e = a(this).css("z-index"), isNaN(e) || (d = Math.max(d, e)))
        }), a.ui.dialog.maxZ = d), this
    }, isOpen: function () {
        return this._isOpen
    }, moveToTop: function (b, c) {
        var d = this.options, e;
        return d.modal && !b || !d.stack && !d.modal ? this._trigger("focus", c) : (d.zIndex > a.ui.dialog.maxZ && (a.ui.dialog.maxZ = d.zIndex), this.overlay && (a.ui.dialog.maxZ += 1, a.ui.dialog.overlay.maxZ = a.ui.dialog.maxZ, this.overlay.$el.css("z-index", a.ui.dialog.overlay.maxZ)), e = {scrollTop: this.element.scrollTop(), scrollLeft: this.element.scrollLeft()}, a.ui.dialog.maxZ += 1, this.uiDialog.css("z-index", a.ui.dialog.maxZ), this.element.attr(e), this._trigger("focus", c), this)
    }, open: function () {
        if (this._isOpen)return;
        var b, c = this.options, d = this.uiDialog;
        return this._size(), this._position(c.position), d.show(c.show), this.overlay = c.modal ? new a.ui.dialog.overlay(this) : null, this.moveToTop(!0), b = this.element.find(":tabbable"), b.length || (b = this.uiDialogButtonPane.find(":tabbable"), b.length || (b = d)), b.eq(0).focus(), this._isOpen = !0, this._trigger("open"), this
    }, _createButtons: function (b) {
        var c = this, d = !1;
        this.uiDialogButtonPane.remove(), this.uiButtonSet.empty(), typeof b == "object" && b !== null && a.each(b, function () {
            return!(d = !0)
        }), d ? (a.each(b, function (b, d) {
            var e, f;
            d = a.isFunction(d) ? {click: d, text: b} : d, d = a.extend({type: "button"}, d), f = d.click, d.click = function () {
                f.apply(c.element[0], arguments)
            }, e = a("<button></button>", d).appendTo(c.uiButtonSet), a.fn.button && e.button()
        }), this.uiDialog.addClass("ui-dialog-buttons"), this.uiDialogButtonPane.appendTo(this.uiDialog)) : this.uiDialog.removeClass("ui-dialog-buttons")
    }, _makeDraggable: function () {
        function d(a) {
            return{position: a.position, offset: a.offset}
        }

        var b = this, c = this.options;
        this.uiDialog.draggable({cancel: ".ui-dialog-content, .ui-dialog-titlebar-close", handle: ".ui-dialog-titlebar", containment: "document", start: function (c, e) {
            a(this).addClass("ui-dialog-dragging"), b._trigger("dragStart", c, d(e))
        }, drag: function (a, c) {
            b._trigger("drag", a, d(c))
        }, stop: function (e, f) {
            c.position = [f.position.left - b.document.scrollLeft(), f.position.top - b.document.scrollTop()], a(this).removeClass("ui-dialog-dragging"), b._trigger("dragStop", e, d(f)), a.ui.dialog.overlay.resize()
        }})
    }, _makeResizable: function (c) {
        function h(a) {
            return{originalPosition: a.originalPosition, originalSize: a.originalSize, position: a.position, size: a.size}
        }

        c = c === b ? this.options.resizable : c;
        var d = this, e = this.options, f = this.uiDialog.css("position"), g = typeof c == "string" ? c : "n,e,s,w,se,sw,ne,nw";
        this.uiDialog.resizable({cancel: ".ui-dialog-content", containment: "document", alsoResize: this.element, maxWidth: e.maxWidth, maxHeight: e.maxHeight, minWidth: e.minWidth, minHeight: this._minHeight(), handles: g, start: function (b, c) {
            a(this).addClass("ui-dialog-resizing"), d._trigger("resizeStart", b, h(c))
        }, resize: function (a, b) {
            d._trigger("resize", a, h(b))
        }, stop: function (b, c) {
            a(this).removeClass("ui-dialog-resizing"), e.height = a(this).height(), e.width = a(this).width(), d._trigger("resizeStop", b, h(c)), a.ui.dialog.overlay.resize()
        }}).css("position", f).find(".ui-resizable-se").addClass("ui-icon ui-icon-grip-diagonal-se")
    }, _minHeight: function () {
        var a = this.options;
        return a.height === "auto" ? a.minHeight : Math.min(a.minHeight, a.height)
    }, _position: function (b) {
        var c = [], d = [0, 0], e;
        if (b) {
            if (typeof b == "string" || typeof b == "object" && "0"in b)c = b.split ? b.split(" ") : [b[0], b[1]], c.length === 1 && (c[1] = c[0]), a.each(["left", "top"], function (a, b) {
                +c[a] === c[a] && (d[a] = c[a], c[a] = b)
            }), b = {my: c[0] + (d[0] < 0 ? d[0] : "+" + d[0]) + " " + c[1] + (d[1] < 0 ? d[1] : "+" + d[1]), at: c.join(" ")};
            b = a.extend({}, a.ui.dialog.prototype.options.position, b)
        } else b = a.ui.dialog.prototype.options.position;
        e = this.uiDialog.is(":visible"), e || this.uiDialog.show(), this.uiDialog.position(b), e || this.uiDialog.hide()
    }, _setOptions: function (b) {
        var c = this, f = {}, g = !1;
        a.each(b, function (a, b) {
            c._setOption(a, b), a in d && (g = !0), a in e && (f[a] = b)
        }), g && this._size(), this.uiDialog.is(":data(resizable)") && this.uiDialog.resizable("option", f)
    }, _setOption: function (b, d) {
        var e, f, g = this.uiDialog;
        switch (b) {
            case"buttons":
                this._createButtons(d);
                break;
            case"closeText":
                this.uiDialogTitlebarCloseText.text("" + d);
                break;
            case"dialogClass":
                g.removeClass(this.options.dialogClass).addClass(c + d);
                break;
            case"disabled":
                d ? g.addClass("ui-dialog-disabled") : g.removeClass("ui-dialog-disabled");
                break;
            case"draggable":
                e = g.is(":data(draggable)"), e && !d && g.draggable("destroy"), !e && d && this._makeDraggable();
                break;
            case"position":
                this._position(d);
                break;
            case"resizable":
                f = g.is(":data(resizable)"), f && !d && g.resizable("destroy"), f && typeof d == "string" && g.resizable("option", "handles", d), !f && d !== !1 && this._makeResizable(d);
                break;
            case"title":
                a(".ui-dialog-title", this.uiDialogTitlebar).html("" + (d || "&#160;"))
        }
        this._super(b, d)
    }, _size: function () {
        var b, c, d, e = this.options, f = this.uiDialog.is(":visible");
        this.element.show().css({width: "auto", minHeight: 0, height: 0}), e.minWidth > e.width && (e.width = e.minWidth), b = this.uiDialog.css({height: "auto", width: e.width}).outerHeight(), c = Math.max(0, e.minHeight - b), e.height === "auto" ? a.support.minHeight ? this.element.css({minHeight: c, height: "auto"}) : (this.uiDialog.show(), d = this.element.css("height", "auto").height(), f || this.uiDialog.hide(), this.element.height(Math.max(d, c))) : this.element.height(Math.max(e.height - b, 0)), this.uiDialog.is(":data(resizable)") && this.uiDialog.resizable("option", "minHeight", this._minHeight())
    }}), a.extend(a.ui.dialog, {uuid: 0, maxZ: 0, getTitleId: function (a) {
        var b = a.attr("id");
        return b || (this.uuid += 1, b = this.uuid), "ui-dialog-title-" + b
    }, overlay: function (b) {
        this.$el = a.ui.dialog.overlay.create(b)
    }}), a.extend(a.ui.dialog.overlay, {instances: [], oldInstances: [], maxZ: 0, events: a.map("focus,mousedown,mouseup,keydown,keypress,click".split(","),function (a) {
        return a + ".dialog-overlay"
    }).join(" "), create: function (b) {
        this.instances.length === 0 && (setTimeout(function () {
            a.ui.dialog.overlay.instances.length && a(document).bind(a.ui.dialog.overlay.events, function (b) {
                if (a(b.target).zIndex() < a.ui.dialog.overlay.maxZ)return!1
            })
        }, 1), a(window).bind("resize.dialog-overlay", a.ui.dialog.overlay.resize));
        var c = this.oldInstances.pop() || a("<div>").addClass("ui-widget-overlay");
        return a(document).bind("keydown.dialog-overlay", function (d) {
            var e = a.ui.dialog.overlay.instances;
            e.length !== 0 && e[e.length - 1] === c && b.options.closeOnEscape && !d.isDefaultPrevented() && d.keyCode && d.keyCode === a.ui.keyCode.ESCAPE && (b.close(d), d.preventDefault())
        }), c.appendTo(document.body).css({width: this.width(), height: this.height()}), a.fn.bgiframe && c.bgiframe(), this.instances.push(c), c
    }, destroy: function (b) {
        var c = a.inArray(b, this.instances), d = 0;
        c !== -1 && this.oldInstances.push(this.instances.splice(c, 1)[0]), this.instances.length === 0 && a([document, window]).unbind(".dialog-overlay"), b.height(0).width(0).remove(), a.each(this.instances, function () {
            d = Math.max(d, this.css("z-index"))
        }), this.maxZ = d
    }, height: function () {
        var b, c;
        return a.ui.ie ? (b = Math.max(document.documentElement.scrollHeight, document.body.scrollHeight), c = Math.max(document.documentElement.offsetHeight, document.body.offsetHeight), b < c ? a(window).height() + "px" : b + "px") : a(document).height() + "px"
    }, width: function () {
        var b, c;
        return a.ui.ie ? (b = Math.max(document.documentElement.scrollWidth, document.body.scrollWidth), c = Math.max(document.documentElement.offsetWidth
            , document.body.offsetWidth), b < c ? a(window).width() + "px" : b + "px") : a(document).width() + "px"
    }, resize: function () {
        var b = a([]);
        a.each(a.ui.dialog.overlay.instances, function () {
            b = b.add(this)
        }), b.css({width: 0, height: 0}).css({width: a.ui.dialog.overlay.width(), height: a.ui.dialog.overlay.height()})
    }}), a.extend(a.ui.dialog.overlay.prototype, {destroy: function () {
        a.ui.dialog.overlay.destroy(this.$el)
    }})
}(jQuery), function (a, b) {
    var c = /up|down|vertical/, d = /up|left|vertical|horizontal/;
    a.effects.effect.blind = function (b, e) {
        var f = a(this), g = ["position", "top", "bottom", "left", "right", "height", "width"], h = a.effects.setMode(f, b.mode || "hide"), i = b.direction || "up", j = c.test(i), k = j ? "height" : "width", l = j ? "top" : "left", m = d.test(i), n = {}, o = h === "show", p, q, r;
        f.parent().is(".ui-effects-wrapper") ? a.effects.save(f.parent(), g) : a.effects.save(f, g), f.show(), p = a.effects.createWrapper(f).css({overflow: "hidden"}), q = p[k](), r = parseFloat(p.css(l)) || 0, n[k] = o ? q : 0, m || (f.css(j ? "bottom" : "right", 0).css(j ? "top" : "left", "auto").css({position: "absolute"}), n[l] = o ? r : q + r), o && (p.css(k, 0), m || p.css(l, r + q)), p.animate(n, {duration: b.duration, easing: b.easing, queue: !1, complete: function () {
            h === "hide" && f.hide(), a.effects.restore(f, g), a.effects.removeWrapper(f), e()
        }})
    }
}(jQuery), function (a, b) {
    a.effects.effect.bounce = function (b, c) {
        var d = a(this), e = ["position", "top", "bottom", "left", "right", "height", "width"], f = a.effects.setMode(d, b.mode || "effect"), g = f === "hide", h = f === "show", i = b.direction || "up", j = b.distance, k = b.times || 5, l = k * 2 + (h || g ? 1 : 0), m = b.duration / l, n = b.easing, o = i === "up" || i === "down" ? "top" : "left", p = i === "up" || i === "left", q, r, s, t = d.queue(), u = t.length;
        (h || g) && e.push("opacity"), a.effects.save(d, e), d.show(), a.effects.createWrapper(d), j || (j = d[o === "top" ? "outerHeight" : "outerWidth"]() / 3), h && (s = {opacity: 1}, s[o] = 0, d.css("opacity", 0).css(o, p ? -j * 2 : j * 2).animate(s, m, n)), g && (j /= Math.pow(2, k - 1)), s = {}, s[o] = 0;
        for (q = 0; q < k; q++)r = {}, r[o] = (p ? "-=" : "+=") + j, d.animate(r, m, n).animate(s, m, n), j = g ? j * 2 : j / 2;
        g && (r = {opacity: 0}, r[o] = (p ? "-=" : "+=") + j, d.animate(r, m, n)), d.queue(function () {
            g && d.hide(), a.effects.restore(d, e), a.effects.removeWrapper(d), c()
        }), u > 1 && t.splice.apply(t, [1, 0].concat(t.splice(u, l + 1))), d.dequeue()
    }
}(jQuery), function (a, b) {
    a.effects.effect.clip = function (b, c) {
        var d = a(this), e = ["position", "top", "bottom", "left", "right", "height", "width"], f = a.effects.setMode(d, b.mode || "hide"), g = f === "show", h = b.direction || "vertical", i = h === "vertical", j = i ? "height" : "width", k = i ? "top" : "left", l = {}, m, n, o;
        a.effects.save(d, e), d.show(), m = a.effects.createWrapper(d).css({overflow: "hidden"}), n = d[0].tagName === "IMG" ? m : d, o = n[j](), g && (n.css(j, 0), n.css(k, o / 2)), l[j] = g ? o : 0, l[k] = g ? 0 : o / 2, n.animate(l, {queue: !1, duration: b.duration, easing: b.easing, complete: function () {
            g || d.hide(), a.effects.restore(d, e), a.effects.removeWrapper(d), c()
        }})
    }
}(jQuery), function (a, b) {
    a.effects.effect.drop = function (b, c) {
        var d = a(this), e = ["position", "top", "bottom", "left", "right", "opacity", "height", "width"], f = a.effects.setMode(d, b.mode || "hide"), g = f === "show", h = b.direction || "left", i = h === "up" || h === "down" ? "top" : "left", j = h === "up" || h === "left" ? "pos" : "neg", k = {opacity: g ? 1 : 0}, l;
        a.effects.save(d, e), d.show(), a.effects.createWrapper(d), l = b.distance || d[i === "top" ? "outerHeight" : "outerWidth"](!0) / 2, g && d.css("opacity", 0).css(i, j === "pos" ? -l : l), k[i] = (g ? j === "pos" ? "+=" : "-=" : j === "pos" ? "-=" : "+=") + l, d.animate(k, {queue: !1, duration: b.duration, easing: b.easing, complete: function () {
            f === "hide" && d.hide(), a.effects.restore(d, e), a.effects.removeWrapper(d), c()
        }})
    }
}(jQuery), function (a, b) {
    a.effects.effect.explode = function (b, c) {
        function s() {
            l.push(this), l.length === d * e && t()
        }

        function t() {
            f.css({visibility: "visible"}), a(l).remove(), h || f.hide(), c()
        }

        var d = b.pieces ? Math.round(Math.sqrt(b.pieces)) : 3, e = d, f = a(this), g = a.effects.setMode(f, b.mode || "hide"), h = g === "show", i = f.show().css("visibility", "hidden").offset(), j = Math.ceil(f.outerWidth() / e), k = Math.ceil(f.outerHeight() / d), l = [], m, n, o, p, q, r;
        for (m = 0; m < d; m++) {
            p = i.top + m * k, r = m - (d - 1) / 2;
            for (n = 0; n < e; n++)o = i.left + n * j, q = n - (e - 1) / 2, f.clone().appendTo("body").wrap("<div></div>").css({position: "absolute", visibility: "visible", left: -n * j, top: -m * k}).parent().addClass("ui-effects-explode").css({position: "absolute", overflow: "hidden", width: j, height: k, left: o + (h ? q * j : 0), top: p + (h ? r * k : 0), opacity: h ? 0 : 1}).animate({left: o + (h ? 0 : q * j), top: p + (h ? 0 : r * k), opacity: h ? 1 : 0}, b.duration || 500, b.easing, s)
        }
    }
}(jQuery), function (a, b) {
    a.effects.effect.fade = function (b, c) {
        var d = a(this), e = a.effects.setMode(d, b.mode || "toggle");
        d.animate({opacity: e}, {queue: !1, duration: b.duration, easing: b.easing, complete: c})
    }
}(jQuery), function (a, b) {
    a.effects.effect.fold = function (b, c) {
        var d = a(this), e = ["position", "top", "bottom", "left", "right", "height", "width"], f = a.effects.setMode(d, b.mode || "hide"), g = f === "show", h = f === "hide", i = b.size || 15, j = /([0-9]+)%/.exec(i), k = !!b.horizFirst, l = g !== k, m = l ? ["width", "height"] : ["height", "width"], n = b.duration / 2, o, p, q = {}, r = {};
        a.effects.save(d, e), d.show(), o = a.effects.createWrapper(d).css({overflow: "hidden"}), p = l ? [o.width(), o.height()] : [o.height(), o.width()], j && (i = parseInt(j[1], 10) / 100 * p[h ? 0 : 1]), g && o.css(k ? {height: 0, width: i} : {height: i, width: 0}), q[m[0]] = g ? p[0] : i, r[m[1]] = g ? p[1] : 0, o.animate(q, n, b.easing).animate(r, n, b.easing, function () {
            h && d.hide(), a.effects.restore(d, e), a.effects.removeWrapper(d), c()
        })
    }
}(jQuery), function (a, b) {
    a.effects.effect.highlight = function (b, c) {
        var d = a(this), e = ["backgroundImage", "backgroundColor", "opacity"], f = a.effects.setMode(d, b.mode || "show"), g = {backgroundColor: d.css("backgroundColor")};
        f === "hide" && (g.opacity = 0), a.effects.save(d, e), d.show().css({backgroundImage: "none", backgroundColor: b.color || "#ffff99"}).animate(g, {queue: !1, duration: b.duration, easing: b.easing, complete: function () {
            f === "hide" && d.hide(), a.effects.restore(d, e), c()
        }})
    }
}(jQuery), function (a, b) {
    a.effects.effect.pulsate = function (b, c) {
        var d = a(this), e = a.effects.setMode(d, b.mode || "show"), f = e === "show", g = e === "hide", h = f || e === "hide", i = (b.times || 5) * 2 + (h ? 1 : 0), j = b.duration / i, k = 0, l = d.queue(), m = l.length, n;
        if (f || !d.is(":visible"))d.css("opacity", 0).show(), k = 1;
        for (n = 1; n < i; n++)d.animate({opacity: k}, j, b.easing), k = 1 - k;
        d.animate({opacity: k}, j, b.easing), d.queue(function () {
            g && d.hide(), c()
        }), m > 1 && l.splice.apply(l, [1, 0].concat(l.splice(m, i + 1))), d.dequeue()
    }
}(jQuery), function (a, b) {
    a.effects.effect.puff = function (b, c) {
        var d = a(this), e = a.effects.setMode(d, b.mode || "hide"), f = e === "hide", g = parseInt(b.percent, 10) || 150, h = g / 100, i = {height: d.height(), width: d.width(), outerHeight: d.outerHeight(), outerWidth: d.outerWidth()};
        a.extend(b, {effect: "scale", queue: !1, fade: !0, mode: e, complete: c, percent: f ? g : 100, from: f ? i : {height: i.height * h, width: i.width * h, outerHeight: i.outerHeight * h, outerWidth: i.outerWidth * h}}), d.effect(b)
    }, a.effects.effect.scale = function (b, c) {
        var d = a(this), e = a.extend(!0, {}, b), f = a.effects.setMode(d, b.mode || "effect"), g = parseInt(b.percent, 10) || (parseInt(b.percent, 10) === 0 ? 0 : f === "hide" ? 0 : 100), h = b.direction || "both", i = b.origin, j = {height: d.height(), width: d.width(), outerHeight: d.outerHeight(), outerWidth: d.outerWidth()}, k = {y: h !== "horizontal" ? g / 100 : 1, x: h !== "vertical" ? g / 100 : 1};
        e.effect = "size", e.queue = !1, e.complete = c, f !== "effect" && (e.origin = i || ["middle", "center"], e.restore = !0), e.from = b.from || (f === "show" ? {height: 0, width: 0, outerHeight: 0, outerWidth: 0} : j), e.to = {height: j.height * k.y, width: j.width * k.x, outerHeight: j.outerHeight * k.y, outerWidth: j.outerWidth * k.x}, e.fade && (f === "show" && (e.from.opacity = 0, e.to.opacity = 1), f === "hide" && (e.from.opacity = 1, e.to.opacity = 0)), d.effect(e)
    }, a.effects.effect.size = function (b, c) {
        var d, e, f, g = a(this), h = ["position", "top", "bottom", "left", "right", "width", "height", "overflow", "opacity"], i = ["position", "top", "bottom", "left", "right", "overflow", "opacity"], j = ["width", "height", "overflow"], k = ["fontSize"], l = ["borderTopWidth", "borderBottomWidth", "paddingTop", "paddingBottom"], m = ["borderLeftWidth", "borderRightWidth", "paddingLeft", "paddingRight"], n = a.effects.setMode(g, b.mode || "effect"), o = b.restore || n !== "effect", p = b.scale || "both", q = b.origin || ["middle", "center"], r = g.css("position"), s = o ? h : i, t = {height: 0, width: 0, outerHeight: 0, outerWidth: 0};
        n === "show" && g.show(), d = {height: g.height(), width: g.width(), outerHeight: g.outerHeight(), outerWidth: g.outerWidth()}, b.mode === "toggle" && n === "show" ? (g.from = b.to || t, g.to = b.from || d) : (g.from = b.from || (n === "show" ? t : d), g.to = b.to || (n === "hide" ? t : d)), f = {from: {y: g.from.height / d.height, x: g.from.width / d.width}, to: {y: g.to.height / d.height, x: g.to.width / d.width}};
        if (p === "box" || p === "both")f.from.y !== f.to.y && (s = s.concat(l), g.from = a.effects.setTransition(g, l, f.from.y, g.from), g.to = a.effects.setTransition(g, l, f.to.y, g.to)), f.from.x !== f.to.x && (s = s.concat(m), g.from = a.effects.setTransition(g, m, f.from.x, g.from), g.to = a.effects.setTransition(g, m, f.to.x, g.to));
        (p === "content" || p === "both") && f.from.y !== f.to.y && (s = s.concat(k).concat(j), g.from = a.effects.setTransition(g, k, f.from.y, g.from), g.to = a.effects.setTransition(g, k, f.to.y, g.to)), a.effects.save(g, s), g.show(), a.effects.createWrapper(g), g.css("overflow", "hidden").css(g.from), q && (e = a.effects.getBaseline(q, d), g.from.top = (d.outerHeight - g.outerHeight()) * e.y, g.from.left = (d.outerWidth - g.outerWidth()) * e.x, g.to.top = (d.outerHeight - g.to.outerHeight) * e.y, g.to.left = (d.outerWidth - g.to.outerWidth) * e.x), g.css(g.from);
        if (p === "content" || p === "both")l = l.concat(["marginTop", "marginBottom"]).concat(k), m = m.concat(["marginLeft", "marginRight"]), j = h.concat(l).concat(m), g.find("*[width]").each(function () {
            var c = a(this), d = {height: c.height(), width: c.width(), outerHeight: c.outerHeight(), outerWidth: c.outerWidth()};
            o && a.effects.save(c, j), c.from = {height: d.height * f.from.y, width: d.width * f.from.x, outerHeight: d.outerHeight * f.from.y, outerWidth: d.outerWidth * f.from.x}, c.to = {height: d.height * f.to.y, width: d.width * f.to.x, outerHeight: d.height * f.to.y, outerWidth: d.width * f.to.x}, f.from.y !== f.to.y && (c.from = a.effects.setTransition(c, l, f.from.y, c.from), c.to = a.effects.setTransition(c, l, f.to.y, c.to)), f.from.x !== f.to.x && (c.from = a.effects.setTransition(c, m, f.from.x, c.from), c.to = a.effects.setTransition(c, m, f.to.x, c.to)), c.css(c.from), c.animate(c.to, b.duration, b.easing, function () {
                o && a.effects.restore(c, j)
            })
        });
        g.animate(g.to, {queue: !1, duration: b.duration, easing: b.easing, complete: function () {
            g.to.opacity === 0 && g.css("opacity", g.from.opacity), n === "hide" && g.hide(), a.effects.restore(g, s), o || (r === "static" ? g.css({position: "relative", top: g.to.top, left: g.to.left}) : a.each(["top", "left"], function (a, b) {
                g.css(b, function (b, c) {
                    var d = parseInt(c, 10), e = a ? g.to.left : g.to.top;
                    return c === "auto" ? e + "px" : d + e + "px"
                })
            })), a.effects.removeWrapper(g), c()
        }})
    }
}(jQuery), function (a, b) {
    a.effects.effect.shake = function (b, c) {
        var d = a(this), e = ["position", "top", "bottom", "left", "right", "height", "width"], f = a.effects.setMode(d, b.mode || "effect"), g = b.direction || "left", h = b.distance || 20, i = b.times || 3, j = i * 2 + 1, k = Math.round(b.duration / j), l = g === "up" || g === "down" ? "top" : "left", m = g === "up" || g === "left", n = {}, o = {}, p = {}, q, r = d.queue(), s = r.length;
        a.effects.save(d, e), d.show(), a.effects.createWrapper(d), n[l] = (m ? "-=" : "+=") + h, o[l] = (m ? "+=" : "-=") + h * 2, p[l] = (m ? "-=" : "+=") + h * 2, d.animate(n, k, b.easing);
        for (q = 1; q < i; q++)d.animate(o, k, b.easing).animate(p, k, b.easing);
        d.animate(o, k, b.easing).animate(n, k / 2, b.easing).queue(function () {
            f === "hide" && d.hide(), a.effects.restore(d, e), a.effects.removeWrapper(d), c()
        }), s > 1 && r.splice.apply(r, [1, 0].concat(r.splice(s, j + 1))), d.dequeue()
    }
}(jQuery), function (a, b) {
    a.effects.effect.slide = function (b, c) {
        var d = a(this), e = ["position", "top", "bottom", "left", "right", "width", "height"], f = a.effects.setMode(d, b.mode || "show"), g = f === "show", h = b.direction || "left", i = h === "up" || h === "down" ? "top" : "left", j = h === "up" || h === "left", k, l = {};
        a.effects.save(d, e), d.show(), k = b.distance || d[i === "top" ? "outerHeight" : "outerWidth"](!0), a.effects.createWrapper(d).css({overflow: "hidden"}), g && d.css(i, j ? isNaN(k) ? "-" + k : -k : k), l[i] = (g ? j ? "+=" : "-=" : j ? "-=" : "+=") + k, d.animate(l, {queue: !1, duration: b.duration, easing: b.easing, complete: function () {
            f === "hide" && d.hide(), a.effects.restore(d, e), a.effects.removeWrapper(d), c()
        }})
    }
}(jQuery), function (a, b) {
    a.effects.effect.transfer = function (b, c) {
        var d = a(this), e = a(b.to), f = e.css("position") === "fixed", g = a("body"), h = f ? g.scrollTop() : 0, i = f ? g.scrollLeft() : 0, j = e.offset(), k = {top: j.top - h, left: j.left - i, height: e.innerHeight(), width: e.innerWidth()}, l = d.offset(), m = a('<div class="ui-effects-transfer"></div>').appendTo(document.body).addClass(b.className).css({top: l.top - h, left: l.left - i, height: d.innerHeight(), width: d.innerWidth(), position: f ? "fixed" : "absolute"}).animate(k, b.duration, b.easing, function () {
            m.remove(), c()
        })
    }
}(jQuery), function (a, b) {
    var c = !1;
    a.widget("ui.menu", {version: "1.9.2", defaultElement: "<ul>", delay: 300, options: {icons: {submenu: "ui-icon-carat-1-e"}, menus: "ul", position: {my: "left top", at: "right top"}, role: "menu", blur: null, focus: null, select: null}, _create: function () {
        this.activeMenu = this.element, this.element.uniqueId().addClass("ui-menu ui-widget ui-widget-content ui-corner-all").toggleClass("ui-menu-icons", !!this.element.find(".ui-icon").length).attr({role: this.options.role, tabIndex: 0}).bind("click" + this.eventNamespace, a.proxy(function (a) {
            this.options.disabled && a.preventDefault()
        }, this)), this.options.disabled && this.element.addClass("ui-state-disabled").attr("aria-disabled", "true"), this._on({"mousedown .ui-menu-item > a": function (a) {
            a.preventDefault()
        }, "click .ui-state-disabled > a": function (a) {
            a.preventDefault()
        }, "click .ui-menu-item:has(a)": function (b) {
            var d = a(b.target).closest(".ui-menu-item");
            !c && d.not(".ui-state-disabled").length && (c = !0, this.select(b), d.has(".ui-menu").length ? this.expand(b) : this.element.is(":focus") || (this.element.trigger("focus", [!0]), this.active && this.active.parents(".ui-menu").length === 1 && clearTimeout(this.timer)))
        }, "mouseenter .ui-menu-item": function (b) {
            var c = a(b.currentTarget);
            c.siblings().children(".ui-state-active").removeClass("ui-state-active"), this.focus(b, c)
        }, mouseleave: "collapseAll", "mouseleave .ui-menu": "collapseAll", focus: function (a, b) {
            var c = this.active || this.element.children(".ui-menu-item").eq(0);
            b || this.focus(a, c)
        }, blur: function (b) {
            this._delay(function () {
                a.contains(this.element[0], this.document[0].activeElement) || this.collapseAll(b)
            })
        }, keydown: "_keydown"}), this.refresh(), this._on(this.document, {click: function (b) {
            a(b.target).closest(".ui-menu").length || this.collapseAll(b), c = !1
        }})
    }, _destroy: function () {
        this.element.removeAttr("aria-activedescendant").find(".ui-menu").andSelf().removeClass("ui-menu ui-widget ui-widget-content ui-corner-all ui-menu-icons").removeAttr("role").removeAttr("tabIndex").removeAttr("aria-labelledby").removeAttr("aria-expanded").removeAttr("aria-hidden").removeAttr("aria-disabled").removeUniqueId().show(), this.element.find(".ui-menu-item").removeClass("ui-menu-item").removeAttr("role").removeAttr("aria-disabled").children("a").removeUniqueId().removeClass("ui-corner-all ui-state-hover").removeAttr("tabIndex").removeAttr("role").removeAttr("aria-haspopup").children().each(function () {
            var b = a(this);
            b.data("ui-menu-submenu-carat") && b.remove()
        }), this.element.find(".ui-menu-divider").removeClass("ui-menu-divider ui-widget-content")
    }, _keydown: function (b) {
        function i(a) {
            return a.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&")
        }

        var c, d, e, f, g, h = !0;
        switch (b.keyCode) {
            case a.ui.keyCode.PAGE_UP:
                this.previousPage(b);
                break;
            case a.ui.keyCode.PAGE_DOWN:
                this.nextPage(b);
                break;
            case a.ui.keyCode.HOME:
                this._move("first", "first", b);
                break;
            case a.ui.keyCode.END:
                this._move("last", "last", b);
                break;
            case a.ui.keyCode.UP:
                this.previous(b);
                break;
            case a.ui.keyCode.DOWN:
                this.next(b);
                break;
            case a.ui.keyCode.LEFT:
                this.collapse(b);
                break;
            case a.ui.keyCode.RIGHT:
                this.active && !this.active.is(".ui-state-disabled") && this.expand(b);
                break;
            case a.ui.keyCode.ENTER:
            case a.ui.keyCode.SPACE:
                this._activate(b);
                break;
            case a.ui.keyCode.ESCAPE:
                this.collapse(b);
                break;
            default:
                h = !1, d = this.previousFilter || "", e = String.fromCharCode(b.keyCode), f = !1, clearTimeout(this.filterTimer), e === d ? f = !0 : e = d + e, g = new RegExp("^" + i(e), "i"), c = this.activeMenu.children(".ui-menu-item").filter(function () {
                    return g.test(a(this).children("a").text())
                }), c = f && c.index(this.active.next()) !== -1 ? this.active.nextAll(".ui-menu-item") : c, c.length || (e = String.fromCharCode(b.keyCode), g = new RegExp("^" + i(e), "i"), c = this.activeMenu.children(".ui-menu-item").filter(function () {
                    return g.test(a(this).children("a").text())
                })), c.length ? (this.focus(b, c), c.length > 1 ? (this.previousFilter = e, this.filterTimer = this._delay(function () {
                    delete this.previousFilter
                }, 1e3)) : delete this.previousFilter) : delete this.previousFilter
        }
        h && b.preventDefault()
    }, _activate: function (a) {
        this.active.is(".ui-state-disabled") || (this.active.children("a[aria-haspopup='true']").length ? this.expand(a) : this.select(a))
    }, refresh: function () {
        var b, c = this.options.icons.submenu, d = this.element.find(this.options.menus);
        d.filter(":not(.ui-menu)").addClass("ui-menu ui-widget ui-widget-content ui-corner-all").hide().attr({role: this.options.role, "aria-hidden": "true", "aria-expanded": "false"}).each(function () {
            var b = a(this), d = b.prev("a"), e = a("<span>").addClass("ui-menu-icon ui-icon " + c).data("ui-menu-submenu-carat", !0);
            d.attr("aria-haspopup", "true").prepend(e), b.attr("aria-labelledby", d.attr("id"))
        }), b = d.add(this.element), b.children(":not(.ui-menu-item):has(a)").addClass("ui-menu-item").attr("role", "presentation").children("a").uniqueId().addClass("ui-corner-all").attr({tabIndex: -1, role: this._itemRole()}), b.children(":not(.ui-menu-item)").each(function () {
            var b = a(this);
            /[^\-—–\s]/.test(b.text()) || b.addClass("ui-widget-content ui-menu-divider")
        }), b.children(".ui-state-disabled").attr("aria-disabled", "true"), this.active && !a.contains(this.element[0], this.active[0]) && this.blur()
    }, _itemRole: function () {
        return{menu: "menuitem", listbox: "option"}[this.options.role]
    }, focus: function (a, b) {
        var c, d;
        this.blur(a, a && a.type === "focus"), this._scrollIntoView(b), this.active = b.first(), d = this.active.children("a").addClass("ui-state-focus"), this.options.role && this.element.attr("aria-activedescendant", d.attr("id")), this.active.parent().closest(".ui-menu-item").children("a:first").addClass("ui-state-active"), a && a.type === "keydown" ? this._close() : this.timer = this._delay(function () {
            this._close()
        }, this.delay), c = b.children(".ui-menu"), c.length && /^mouse/.test(a.type) && this._startOpening(c), this.activeMenu = b.parent(), this._trigger("focus", a, {item: b})
    }, _scrollIntoView: function (b) {
        var c, d, e, f, g, h;
        this._hasScroll() && (c = parseFloat(a.css(this.activeMenu[0], "borderTopWidth")) || 0, d = parseFloat(a.css(this.activeMenu[0], "paddingTop")) || 0, e = b.offset().top - this.activeMenu.offset().top - c - d, f = this.activeMenu.scrollTop(), g = this.activeMenu.height(), h = b.height(), e < 0 ? this.activeMenu.scrollTop(f + e) : e + h > g && this.activeMenu.scrollTop(f + e - g + h))
    }, blur: function (a, b) {
        b || clearTimeout(this.timer);
        if (!this.active)return;
        this.active.children("a").removeClass("ui-state-focus"), this.active = null, this._trigger("blur", a, {item: this.active})
    }, _startOpening: function (a) {
        clearTimeout(this.timer);
        if (a.attr("aria-hidden") !== "true")return;
        this.timer = this._delay(function () {
            this._close(), this._open(a)
        }, this.delay)
    }, _open: function (b) {
        var c = a.extend({of: this.active}, this.options.position);
        clearTimeout(this.timer), this.element.find(".ui-menu").not(b.parents(".ui-menu")).hide().attr("aria-hidden", "true"), b.show().removeAttr("aria-hidden").attr("aria-expanded", "true").position(c)
    }, collapseAll: function (b, c) {
        clearTimeout(this.timer), this.timer = this._delay(function () {
            var d = c ? this.element : a(b && b.target).closest(this.element.find(".ui-menu"));
            d.length || (d = this.element), this._close(d), this.blur(b), this.activeMenu = d
        }, this.delay)
    }, _close: function (a) {
        a || (a = this.active ? this.active.parent() : this.element), a.find(".ui-menu").hide().attr("aria-hidden", "true").attr("aria-expanded", "false").end().find("a.ui-state-active").removeClass("ui-state-active")
    }, collapse: function (a) {
        var b = this.active && this.active.parent().closest(".ui-menu-item", this.element);
        b && b.length && (this._close(), this.focus(a, b))
    }, expand: function (a) {
        var b = this.active && this.active.children(".ui-menu ").children(".ui-menu-item").first();
        b && b.length && (this._open(b.parent()), this._delay(function () {
            this.focus(a, b)
        }))
    }, next: function (a) {
        this._move("next", "first", a)
    }, previous: function (a) {
        this._move("prev", "last", a)
    }, isFirstItem: function () {
        return this.active && !this.active.prevAll(".ui-menu-item").length
    }, isLastItem: function () {
        return this.active && !this.active.nextAll(".ui-menu-item").length
    }, _move: function (a, b, c) {
        var d;
        this.active && (a === "first" || a === "last" ? d = this.active[a === "first" ? "prevAll" : "nextAll"](".ui-menu-item").eq(-1) : d = this.active[a + "All"](".ui-menu-item").eq(0));
        if (!d || !d.length || !this.active)d = this.activeMenu.children(".ui-menu-item")[b]();
        this.focus(c, d)
    }, nextPage: function (b) {
        var c, d, e;
        if (!this.active) {
            this.next(b);
            return
        }
        if (this.isLastItem())return;
        this._hasScroll() ? (d = this.active.offset().top, e = this.element.height(), this.active.nextAll(".ui-menu-item").each(function () {
            return c = a(this), c.offset().top - d - e < 0
        }), this.focus(b, c)) : this.focus(b, this.activeMenu.children(".ui-menu-item")[this.active ? "last" : "first"]())
    }, previousPage: function (b) {
        var c, d, e;
        if (!this.active) {
            this.next(b);
            return
        }
        if (this.isFirstItem())return;
        this._hasScroll() ? (d = this.active.offset().top, e = this.element.height(), this.active.prevAll(".ui-menu-item").each(function () {
            return c = a(this), c.offset().top - d + e > 0
        }), this.focus(b, c)) : this.focus(b, this.activeMenu.children(".ui-menu-item").first())
    }, _hasScroll: function () {
        return this.element.outerHeight() < this.element.prop("scrollHeight")
    }, select: function (b) {
        this.active = this.active || a(b.target).closest(".ui-menu-item");
        var c = {item: this.active};
        this.active.has(".ui-menu").length || this.collapseAll(b, !0), this._trigger("select", b, c)
    }})
}(jQuery), function (a, b) {
    function m(a, b, c) {
        return[parseInt(a[0], 10) * (k.test(a[0]) ? b / 100 : 1), parseInt(a[1], 10) * (k.test(a[1]) ? c / 100 : 1)]
    }

    function n(b, c) {
        return parseInt(a.css(b, c), 10) || 0
    }

    a.ui = a.ui || {};
    var c, d = Math.max, e = Math.abs, f = Math.round, g = /left|center|right/, h = /top|center|bottom/, i = /[\+\-]\d+%?/, j = /^\w+/, k = /%$/, l = a.fn.position;
    a.position = {scrollbarWidth: function () {
        if (c !== b)return c;
        var d, e, f = a("<div style='display:block;width:50px;height:50px;overflow:hidden;'><div style='height:100px;width:auto;'></div></div>"), g = f.children()[0];
        return a("body").append(f), d = g.offsetWidth, f.css("overflow", "scroll"), e = g.offsetWidth, d === e && (e = f[0].clientWidth), f.remove(), c = d - e
    }, getScrollInfo: function (b) {
        var c = b.isWindow ? "" : b.element.css("overflow-x"), d = b.isWindow ? "" : b.element.css("overflow-y"), e = c === "scroll" || c === "auto" && b.width < b.element[0].scrollWidth, f = d === "scroll" || d === "auto" && b.height < b.element[0].scrollHeight;
        return{width: e ? a.position.scrollbarWidth() : 0, height: f ? a.position.scrollbarWidth() : 0}
    }, getWithinInfo: function (b) {
        var c = a(b || window), d = a.isWindow(c[0]);
        return{element: c, isWindow: d, offset: c.offset() || {left: 0, top: 0}, scrollLeft: c.scrollLeft(), scrollTop: c.scrollTop(), width: d ? c.width() : c.outerWidth(), height: d ? c.height() : c.outerHeight()}
    }}, a.fn.position = function (b) {
        if (!b || !b.of)return l.apply(this, arguments);
        b = a.extend({}, b);
        var c, k, o, p, q, r = a(b.of), s = a.position.getWithinInfo(b.within), t = a.position.getScrollInfo(s), u = r[0], v = (b.collision || "flip").split(" "), w = {};
        return u.nodeType === 9 ? (k = r.width(), o = r.height(), p = {top: 0, left: 0}) : a.isWindow(u) ? (k = r.width(), o = r.height(), p = {top: r.scrollTop(), left: r.scrollLeft()}) : u.preventDefault ? (b.at = "left top", k = o = 0, p = {top: u.pageY, left: u.pageX}) : (k = r.outerWidth(), o = r.outerHeight(), p = r.offset()), q = a.extend({}, p), a.each(["my", "at"], function () {
            var a = (b[this] || "").split(" "), c, d;
            a.length === 1 && (a = g.test(a[0]) ? a.concat(["center"]) : h.test(a[0]) ? ["center"].concat(a) : ["center", "center"]), a[0] = g.test(a[0]) ? a[0] : "center", a[1] = h.test(a[1]) ? a[1] : "center", c = i.exec(a[0]), d = i.exec(a[1]), w[this] = [c ? c[0] : 0, d ? d[0] : 0], b[this] = [j.exec(a[0])[0], j.exec(a[1])[0]]
        }), v.length === 1 && (v[1] = v[0]), b.at[0] === "right" ? q.left += k : b.at[0] === "center" && (q.left += k / 2), b.at[1] === "bottom" ? q.top += o : b.at[1] === "center" && (q.top += o / 2), c = m(w.at, k, o), q.left += c[0], q.top += c[1], this.each(function () {
            var g, h, i = a(this), j = i.outerWidth(), l = i.outerHeight(), u = n(this, "marginLeft"), x = n(this, "marginTop"), y = j + u + n(this, "marginRight") + t.width, z = l + x + n(this, "marginBottom") + t.height, A = a.extend({}, q), B = m(w.my, i.outerWidth(), i.outerHeight());
            b.my[0] === "right" ? A.left -= j : b.my[0] === "center" && (A.left -= j / 2), b.my[1] === "bottom" ? A.top -= l : b.my[1] === "center" && (A.top -= l / 2), A.left += B[0], A.top += B[1], a.support.offsetFractions || (A.left = f(A.left), A.top = f(A.top)), g = {marginLeft: u, marginTop: x}, a.each(["left", "top"], function (d, e) {
                a.ui.position[v[d]] && a.ui.position[v[d]][e](A, {targetWidth: k, targetHeight: o, elemWidth: j, elemHeight: l, collisionPosition: g, collisionWidth: y, collisionHeight: z, offset: [c[0] + B[0], c[1] + B[1]], my: b.my, at: b.at, within: s, elem: i})
            }), a.fn.bgiframe && i.bgiframe(), b.using && (h = function (a) {
                var c = p.left - A.left, f = c + k - j, g = p.top - A.top, h = g + o - l, m = {target: {element: r, left: p.left, top: p.top, width: k, height: o}, element: {element: i, left: A.left, top: A.top, width: j, height: l}, horizontal: f < 0 ? "left" : c > 0 ? "right" : "center", vertical: h < 0 ? "top" : g > 0 ? "bottom" : "middle"};
                k < j && e(c + f) < k && (m.horizontal = "center"), o < l && e(g + h) < o && (m.vertical = "middle"), d(e(c), e(f)) > d(e(g), e(h)) ? m.important = "horizontal" : m.important = "vertical", b.using.call(this, a, m)
            }), i.offset(a.extend(A, {using: h}))
        })
    }, a.ui.position = {fit: {left: function (a, b) {
        var c = b.within, e = c.isWindow ? c.scrollLeft : c.offset.left, f = c.width, g = a.left - b.collisionPosition.marginLeft, h = e - g, i = g + b.collisionWidth - f - e, j;
        b.collisionWidth > f ? h > 0 && i <= 0 ? (j = a.left + h + b.collisionWidth - f - e, a.left += h - j) : i > 0 && h <= 0 ? a.left = e : h > i ? a.left = e + f - b.collisionWidth : a.left = e : h > 0 ? a.left += h : i > 0 ? a.left -= i : a.left = d(a.left - g, a.left)
    }, top: function (a, b) {
        var c = b.within, e = c.isWindow ? c.scrollTop : c.offset.top, f = b.within.height, g = a.top - b.collisionPosition.marginTop, h = e - g, i = g + b.collisionHeight - f - e, j;
        b.collisionHeight > f ? h > 0 && i <= 0 ? (j = a.top + h + b.collisionHeight - f - e, a.top += h - j) : i > 0 && h <= 0 ? a.top = e : h > i ? a.top = e + f - b.collisionHeight : a.top = e : h > 0 ? a.top += h : i > 0 ? a.top -= i : a.top = d(a.top - g, a.top)
    }}, flip: {left: function (a, b) {
        var c = b.within, d = c.offset.left + c.scrollLeft, f = c.width, g = c.isWindow ? c.scrollLeft : c.offset.left, h = a.left - b.collisionPosition.marginLeft, i = h - g, j = h + b.collisionWidth - f - g, k = b.my[0] === "left" ? -b.elemWidth : b.my[0] === "right" ? b.elemWidth : 0, l = b.at[0] === "left" ? b.targetWidth : b.at[0] === "right" ? -b.targetWidth : 0, m = -2 * b.offset[0], n, o;
        if (i < 0) {
            n = a.left + k + l + m + b.collisionWidth - f - d;
            if (n < 0 || n < e(i))a.left += k + l + m
        } else if (j > 0) {
            o = a.left - b.collisionPosition.marginLeft + k + l + m - g;
            if (o > 0 || e(o) < j)a.left += k + l + m
        }
    }, top: function (a, b) {
        var c = b.within, d = c.offset.top + c.scrollTop, f = c.height, g = c.isWindow ? c.scrollTop : c.offset.top, h = a.top - b.collisionPosition.marginTop, i = h - g, j = h + b.collisionHeight - f - g, k = b.my[1] === "top", l = k ? -b.elemHeight : b.my[1] === "bottom" ? b.elemHeight : 0, m = b.at[1] === "top" ? b.targetHeight : b.at[1] === "bottom" ? -b.targetHeight : 0, n = -2 * b.offset[1], o, p;
        i < 0 ? (p = a.top + l + m + n + b.collisionHeight - f - d, a.top + l + m + n > i && (p < 0 || p < e(i)) && (a.top += l + m + n)) : j > 0 && (o = a.top - b.collisionPosition.marginTop + l + m + n - g, a.top + l + m + n > j && (o > 0 || e(o) < j) && (a.top += l + m + n))
    }}, flipfit: {left: function () {
        a.ui.position.flip.left.apply(this, arguments), a.ui.position.fit.left.apply(this, arguments)
    }, top: function () {
        a.ui.position.flip.top.apply(this, arguments), a.ui.position.fit.top.apply(this, arguments)
    }}}, function () {
        var b, c, d, e, f, g = document.getElementsByTagName("body")[0], h = document.createElement("div");
        b = document.createElement(g ? "div" : "body"), d = {visibility: "hidden", width: 0, height: 0, border: 0, margin: 0, background: "none"}, g && a.extend(d, {position: "absolute", left: "-1000px", top: "-1000px"});
        for (f in d)b.style[f] = d[f];
        b.appendChild(h), c = g || document.documentElement, c.insertBefore(b, c.firstChild), h.style.cssText = "position: absolute; left: 10.7432222px;", e = a(h).offset().left, a.support.offsetFractions = e > 10 && e < 11, b.innerHTML = "", c.removeChild(b)
    }(), a.uiBackCompat !== !1 && function (a) {
        var c = a.fn.position;
        a.fn.position = function (d) {
            if (!d || !d.offset)return c.call(this, d);
            var e = d.offset.split(" "), f = d.at.split(" ");
            return e.length === 1 && (e[1] = e[0]), /^\d/.test(e[0]) && (e[0] = "+" + e[0]), /^\d/.test(e[1]) && (e[1] = "+" + e[1]), f.length === 1 && (/left|center|right/.test(f[0]) ? f[1] = "center" : (f[1] = f[0], f[0] = "center")), c.call(this, a.extend(d, {at: f[0] + e[0] + " " + f[1] + e[1], offset: b}))
        }
    }(jQuery)
}(jQuery), function (a, b) {
    a.widget("ui.progressbar", {version: "1.9.2", options: {value: 0, max: 100}, min: 0, _create: function () {
        this.element.addClass("ui-progressbar ui-widget ui-widget-content ui-corner-all").attr({role: "progressbar", "aria-valuemin": this.min, "aria-valuemax": this.options.max, "aria-valuenow": this._value()}), this.valueDiv = a("<div class='ui-progressbar-value ui-widget-header ui-corner-left'></div>").appendTo(this.element), this.oldValue = this._value(), this._refreshValue()
    }, _destroy: function () {
        this.element.removeClass("ui-progressbar ui-widget ui-widget-content ui-corner-all").removeAttr("role").removeAttr("aria-valuemin").removeAttr("aria-valuemax").removeAttr("aria-valuenow"), this.valueDiv.remove()
    }, value: function (a) {
        return a === b ? this._value() : (this._setOption("value", a), this)
    }, _setOption: function (a, b) {
        a === "value" && (this.options.value = b, this._refreshValue(), this._value() === this.options.max && this._trigger("complete")), this._super(a, b)
    }, _value: function () {
        var a = this.options.value;
        return typeof a != "number" && (a = 0), Math.min(this.options.max, Math.max(this.min, a))
    }, _percentage: function () {
        return 100 * this._value() / this.options.max
    }, _refreshValue: function () {
        var a = this.value(), b = this._percentage();
        this.oldValue !== a && (this.oldValue = a, this._trigger("change")), this.valueDiv.toggle(a > this.min).toggleClass("ui-corner-right", a === this.options.max).width(b.toFixed(0) + "%"), this.element.attr("aria-valuenow", a)
    }})
}(jQuery), function (a, b) {
    var c = 5;
    a.widget("ui.slider", a.ui.mouse, {version: "1.9.2", widgetEventPrefix: "slide", options: {animate: !1, distance: 0, max: 100, min: 0, orientation: "horizontal", range: !1, step: 1, value: 0, values: null}, _create: function () {
        var b, d, e = this.options, f = this.element.find(".ui-slider-handle").addClass("ui-state-default ui-corner-all"), g = "<a class='ui-slider-handle ui-state-default ui-corner-all' href='#'></a>", h = [];
        this._keySliding = !1, this._mouseSliding = !1, this._animateOff = !0, this._handleIndex = null, this._detectOrientation(), this._mouseInit(), this.element.addClass("ui-slider ui-slider-" + this.orientation + " ui-widget" + " ui-widget-content" + " ui-corner-all" + (e.disabled ? " ui-slider-disabled ui-disabled" : "")), this.range = a([]), e.range && (e.range === !0 && (e.values || (e.values = [this._valueMin(), this._valueMin()]), e.values.length && e.values.length !== 2 && (e.values = [e.values[0], e.values[0]])), this.range = a("<div></div>").appendTo(this.element).addClass("ui-slider-range ui-widget-header" + (e.range === "min" || e.range === "max" ? " ui-slider-range-" + e.range : ""))), d = e.values && e.values.length || 1;
        for (b = f.length; b < d; b++)h.push(g);
        this.handles = f.add(a(h.join("")).appendTo(this.element)), this.handle = this.handles.eq(0), this.handles.add(this.range).filter("a").click(function (a) {
            a.preventDefault()
        }).mouseenter(function () {
            e.disabled || a(this).addClass("ui-state-hover")
        }).mouseleave(function () {
            a(this).removeClass("ui-state-hover")
        }).focus(function () {
            e.disabled ? a(this).blur() : (a(".ui-slider .ui-state-focus").removeClass("ui-state-focus"), a(this).addClass("ui-state-focus"))
        }).blur(function () {
            a(this).removeClass("ui-state-focus")
        }), this.handles.each(function (b) {
            a(this).data("ui-slider-handle-index", b)
        }), this._on(this.handles, {keydown: function (b) {
            var d, e, f, g, h = a(b.target).data("ui-slider-handle-index");
            switch (b.keyCode) {
                case a.ui.keyCode.HOME:
                case a.ui.keyCode.END:
                case a.ui.keyCode.PAGE_UP:
                case a.ui.keyCode.PAGE_DOWN:
                case a.ui.keyCode.UP:
                case a.ui.keyCode.RIGHT:
                case a.ui.keyCode.DOWN:
                case a.ui.keyCode.LEFT:
                    b.preventDefault();
                    if (!this._keySliding) {
                        this._keySliding = !0, a(b.target).addClass("ui-state-active"), d = this._start(b, h);
                        if (d === !1)return
                    }
            }
            g = this.options.step, this.options.values && this.options.values.length ? e = f = this.values(h) : e = f = this.value();
            switch (b.keyCode) {
                case a.ui.keyCode.HOME:
                    f = this._valueMin();
                    break;
                case a.ui.keyCode.END:
                    f = this._valueMax();
                    break;
                case a.ui.keyCode.PAGE_UP:
                    f = this._trimAlignValue(e + (this._valueMax() - this._valueMin()) / c);
                    break;
                case a.ui.keyCode.PAGE_DOWN:
                    f = this._trimAlignValue(e - (this._valueMax() - this._valueMin()) / c);
                    break;
                case a.ui.keyCode.UP:
                case a.ui.keyCode.RIGHT:
                    if (e === this._valueMax())return;
                    f = this._trimAlignValue(e + g);
                    break;
                case a.ui.keyCode.DOWN:
                case a.ui.keyCode.LEFT:
                    if (e === this._valueMin())return;
                    f = this._trimAlignValue(e - g)
            }
            this._slide(b, h, f)
        }, keyup: function (b) {
            var c = a(b.target).data("ui-slider-handle-index");
            this._keySliding && (this._keySliding = !1, this._stop(b, c), this._change(b, c), a(b.target).removeClass("ui-state-active"))
        }}), this._refreshValue(), this._animateOff = !1
    }, _destroy: function () {
        this.handles.remove(), this.range.remove(), this.element.removeClass("ui-slider ui-slider-horizontal ui-slider-vertical ui-slider-disabled ui-widget ui-widget-content ui-corner-all"), this._mouseDestroy()
    }, _mouseCapture: function (b) {
        var c, d, e, f, g, h, i, j, k = this, l = this.options;
        return l.disabled ? !1 : (this.elementSize = {width: this.element.outerWidth(), height: this.element.outerHeight()}, this.elementOffset = this.element.offset(), c = {x: b.pageX, y: b.pageY}, d = this._normValueFromMouse(c), e = this._valueMax() - this._valueMin() + 1, this.handles.each
        (function (b) {
            var c = Math.abs(d - k.values(b));
            e > c && (e = c, f = a(this), g = b)
        }), l.range === !0 && this.values(1) === l.min && (g += 1, f = a(this.handles[g])), h = this._start(b, g), h === !1 ? !1 : (this._mouseSliding = !0, this._handleIndex = g, f.addClass("ui-state-active").focus(), i = f.offset(), j = !a(b.target).parents().andSelf().is(".ui-slider-handle"), this._clickOffset = j ? {left: 0, top: 0} : {left: b.pageX - i.left - f.width() / 2, top: b.pageY - i.top - f.height() / 2 - (parseInt(f.css("borderTopWidth"), 10) || 0) - (parseInt(f.css("borderBottomWidth"), 10) || 0) + (parseInt(f.css("marginTop"), 10) || 0)}, this.handles.hasClass("ui-state-hover") || this._slide(b, g, d), this._animateOff = !0, !0))
    }, _mouseStart: function () {
        return!0
    }, _mouseDrag: function (a) {
        var b = {x: a.pageX, y: a.pageY}, c = this._normValueFromMouse(b);
        return this._slide(a, this._handleIndex, c), !1
    }, _mouseStop: function (a) {
        return this.handles.removeClass("ui-state-active"), this._mouseSliding = !1, this._stop(a, this._handleIndex), this._change(a, this._handleIndex), this._handleIndex = null, this._clickOffset = null, this._animateOff = !1, !1
    }, _detectOrientation: function () {
        this.orientation = this.options.orientation === "vertical" ? "vertical" : "horizontal"
    }, _normValueFromMouse: function (a) {
        var b, c, d, e, f;
        return this.orientation === "horizontal" ? (b = this.elementSize.width, c = a.x - this.elementOffset.left - (this._clickOffset ? this._clickOffset.left : 0)) : (b = this.elementSize.height, c = a.y - this.elementOffset.top - (this._clickOffset ? this._clickOffset.top : 0)), d = c / b, d > 1 && (d = 1), d < 0 && (d = 0), this.orientation === "vertical" && (d = 1 - d), e = this._valueMax() - this._valueMin(), f = this._valueMin() + d * e, this._trimAlignValue(f)
    }, _start: function (a, b) {
        var c = {handle: this.handles[b], value: this.value()};
        return this.options.values && this.options.values.length && (c.value = this.values(b), c.values = this.values()), this._trigger("start", a, c)
    }, _slide: function (a, b, c) {
        var d, e, f;
        this.options.values && this.options.values.length ? (d = this.values(b ? 0 : 1), this.options.values.length === 2 && this.options.range === !0 && (b === 0 && c > d || b === 1 && c < d) && (c = d), c !== this.values(b) && (e = this.values(), e[b] = c, f = this._trigger("slide", a, {handle: this.handles[b], value: c, values: e}), d = this.values(b ? 0 : 1), f !== !1 && this.values(b, c, !0))) : c !== this.value() && (f = this._trigger("slide", a, {handle: this.handles[b], value: c}), f !== !1 && this.value(c))
    }, _stop: function (a, b) {
        var c = {handle: this.handles[b], value: this.value()};
        this.options.values && this.options.values.length && (c.value = this.values(b), c.values = this.values()), this._trigger("stop", a, c)
    }, _change: function (a, b) {
        if (!this._keySliding && !this._mouseSliding) {
            var c = {handle: this.handles[b], value: this.value()};
            this.options.values && this.options.values.length && (c.value = this.values(b), c.values = this.values()), this._trigger("change", a, c)
        }
    }, value: function (a) {
        if (arguments.length) {
            this.options.value = this._trimAlignValue(a), this._refreshValue(), this._change(null, 0);
            return
        }
        return this._value()
    }, values: function (b, c) {
        var d, e, f;
        if (arguments.length > 1) {
            this.options.values[b] = this._trimAlignValue(c), this._refreshValue(), this._change(null, b);
            return
        }
        if (!arguments.length)return this._values();
        if (!a.isArray(arguments[0]))return this.options.values && this.options.values.length ? this._values(b) : this.value();
        d = this.options.values, e = arguments[0];
        for (f = 0; f < d.length; f += 1)d[f] = this._trimAlignValue(e[f]), this._change(null, f);
        this._refreshValue()
    }, _setOption: function (b, c) {
        var d, e = 0;
        a.isArray(this.options.values) && (e = this.options.values.length), a.Widget.prototype._setOption.apply(this, arguments);
        switch (b) {
            case"disabled":
                c ? (this.handles.filter(".ui-state-focus").blur(), this.handles.removeClass("ui-state-hover"), this.handles.prop("disabled", !0), this.element.addClass("ui-disabled")) : (this.handles.prop("disabled", !1), this.element.removeClass("ui-disabled"));
                break;
            case"orientation":
                this._detectOrientation(), this.element.removeClass("ui-slider-horizontal ui-slider-vertical").addClass("ui-slider-" + this.orientation), this._refreshValue();
                break;
            case"value":
                this._animateOff = !0, this._refreshValue(), this._change(null, 0), this._animateOff = !1;
                break;
            case"values":
                this._animateOff = !0, this._refreshValue();
                for (d = 0; d < e; d += 1)this._change(null, d);
                this._animateOff = !1;
                break;
            case"min":
            case"max":
                this._animateOff = !0, this._refreshValue(), this._animateOff = !1
        }
    }, _value: function () {
        var a = this.options.value;
        return a = this._trimAlignValue(a), a
    }, _values: function (a) {
        var b, c, d;
        if (arguments.length)return b = this.options.values[a], b = this._trimAlignValue(b), b;
        c = this.options.values.slice();
        for (d = 0; d < c.length; d += 1)c[d] = this._trimAlignValue(c[d]);
        return c
    }, _trimAlignValue: function (a) {
        if (a <= this._valueMin())return this._valueMin();
        if (a >= this._valueMax())return this._valueMax();
        var b = this.options.step > 0 ? this.options.step : 1, c = (a - this._valueMin()) % b, d = a - c;
        return Math.abs(c) * 2 >= b && (d += c > 0 ? b : -b), parseFloat(d.toFixed(5))
    }, _valueMin: function () {
        return this.options.min
    }, _valueMax: function () {
        return this.options.max
    }, _refreshValue: function () {
        var b, c, d, e, f, g = this.options.range, h = this.options, i = this, j = this._animateOff ? !1 : h.animate, k = {};
        this.options.values && this.options.values.length ? this.handles.each(function (d) {
            c = (i.values(d) - i._valueMin()) / (i._valueMax() - i._valueMin()) * 100, k[i.orientation === "horizontal" ? "left" : "bottom"] = c + "%", a(this).stop(1, 1)[j ? "animate" : "css"](k, h.animate), i.options.range === !0 && (i.orientation === "horizontal" ? (d === 0 && i.range.stop(1, 1)[j ? "animate" : "css"]({left: c + "%"}, h.animate), d === 1 && i.range[j ? "animate" : "css"]({width: c - b + "%"}, {queue: !1, duration: h.animate})) : (d === 0 && i.range.stop(1, 1)[j ? "animate" : "css"]({bottom: c + "%"}, h.animate), d === 1 && i.range[j ? "animate" : "css"]({height: c - b + "%"}, {queue: !1, duration: h.animate}))), b = c
        }) : (d = this.value(), e = this._valueMin(), f = this._valueMax(), c = f !== e ? (d - e) / (f - e) * 100 : 0, k[this.orientation === "horizontal" ? "left" : "bottom"] = c + "%", this.handle.stop(1, 1)[j ? "animate" : "css"](k, h.animate), g === "min" && this.orientation === "horizontal" && this.range.stop(1, 1)[j ? "animate" : "css"]({width: c + "%"}, h.animate), g === "max" && this.orientation === "horizontal" && this.range[j ? "animate" : "css"]({width: 100 - c + "%"}, {queue: !1, duration: h.animate}), g === "min" && this.orientation === "vertical" && this.range.stop(1, 1)[j ? "animate" : "css"]({height: c + "%"}, h.animate), g === "max" && this.orientation === "vertical" && this.range[j ? "animate" : "css"]({height: 100 - c + "%"}, {queue: !1, duration: h.animate}))
    }})
}(jQuery), function (a) {
    function b(a) {
        return function () {
            var b = this.element.val();
            a.apply(this, arguments), this._refresh(), b !== this.element.val() && this._trigger("change")
        }
    }

    a.widget("ui.spinner", {version: "1.9.2", defaultElement: "<input>", widgetEventPrefix: "spin", options: {culture: null, icons: {down: "ui-icon-triangle-1-s", up: "ui-icon-triangle-1-n"}, incremental: !0, max: null, min: null, numberFormat: null, page: 10, step: 1, change: null, spin: null, start: null, stop: null}, _create: function () {
        this._setOption("max", this.options.max), this._setOption("min", this.options.min), this._setOption("step", this.options.step), this._value(this.element.val(), !0), this._draw(), this._on(this._events), this._refresh(), this._on(this.window, {beforeunload: function () {
            this.element.removeAttr("autocomplete")
        }})
    }, _getCreateOptions: function () {
        var b = {}, c = this.element;
        return a.each(["min", "max", "step"], function (a, d) {
            var e = c.attr(d);
            e !== undefined && e.length && (b[d] = e)
        }), b
    }, _events: {keydown: function (a) {
        this._start(a) && this._keydown(a) && a.preventDefault()
    }, keyup: "_stop", focus: function () {
        this.previous = this.element.val()
    }, blur: function (a) {
        if (this.cancelBlur) {
            delete this.cancelBlur;
            return
        }
        this._refresh(), this.previous !== this.element.val() && this._trigger("change", a)
    }, mousewheel: function (a, b) {
        if (!b)return;
        if (!this.spinning && !this._start(a))return!1;
        this._spin((b > 0 ? 1 : -1) * this.options.step, a), clearTimeout(this.mousewheelTimer), this.mousewheelTimer = this._delay(function () {
            this.spinning && this._stop(a)
        }, 100), a.preventDefault()
    }, "mousedown .ui-spinner-button": function (b) {
        function d() {
            var a = this.element[0] === this.document[0].activeElement;
            a || (this.element.focus(), this.previous = c, this._delay(function () {
                this.previous = c
            }))
        }

        var c;
        c = this.element[0] === this.document[0].activeElement ? this.previous : this.element.val(), b.preventDefault(), d.call(this), this.cancelBlur = !0, this._delay(function () {
            delete this.cancelBlur, d.call(this)
        });
        if (this._start(b) === !1)return;
        this._repeat(null, a(b.currentTarget).hasClass("ui-spinner-up") ? 1 : -1, b)
    }, "mouseup .ui-spinner-button": "_stop", "mouseenter .ui-spinner-button": function (b) {
        if (!a(b.currentTarget).hasClass("ui-state-active"))return;
        if (this._start(b) === !1)return!1;
        this._repeat(null, a(b.currentTarget).hasClass("ui-spinner-up") ? 1 : -1, b)
    }, "mouseleave .ui-spinner-button": "_stop"}, _draw: function () {
        var a = this.uiSpinner = this.element.addClass("ui-spinner-input").attr("autocomplete", "off").wrap(this._uiSpinnerHtml()).parent().append(this._buttonHtml());
        this.element.attr("role", "spinbutton"), this.buttons = a.find(".ui-spinner-button").attr("tabIndex", -1).button().removeClass("ui-corner-all"), this.buttons.height() > Math.ceil(a.height() * .5) && a.height() > 0 && a.height(a.height()), this.options.disabled && this.disable()
    }, _keydown: function (b) {
        var c = this.options, d = a.ui.keyCode;
        switch (b.keyCode) {
            case d.UP:
                return this._repeat(null, 1, b), !0;
            case d.DOWN:
                return this._repeat(null, -1, b), !0;
            case d.PAGE_UP:
                return this._repeat(null, c.page, b), !0;
            case d.PAGE_DOWN:
                return this._repeat(null, -c.page, b), !0
        }
        return!1
    }, _uiSpinnerHtml: function () {
        return"<span class='ui-spinner ui-widget ui-widget-content ui-corner-all'></span>"
    }, _buttonHtml: function () {
        return"<a class='ui-spinner-button ui-spinner-up ui-corner-tr'><span class='ui-icon " + this.options.icons.up + "'>&#9650;</span>" + "</a>" + "<a class='ui-spinner-button ui-spinner-down ui-corner-br'>" + "<span class='ui-icon " + this.options.icons.down + "'>&#9660;</span>" + "</a>"
    }, _start: function (a) {
        return!this.spinning && this._trigger("start", a) === !1 ? !1 : (this.counter || (this.counter = 1), this.spinning = !0, !0)
    }, _repeat: function (a, b, c) {
        a = a || 500, clearTimeout(this.timer), this.timer = this._delay(function () {
            this._repeat(40, b, c)
        }, a), this._spin(b * this.options.step, c)
    }, _spin: function (a, b) {
        var c = this.value() || 0;
        this.counter || (this.counter = 1), c = this._adjustValue(c + a * this._increment(this.counter));
        if (!this.spinning || this._trigger("spin", b, {value: c}) !== !1)this._value(c), this.counter++
    }, _increment: function (b) {
        var c = this.options.incremental;
        return c ? a.isFunction(c) ? c(b) : Math.floor(b * b * b / 5e4 - b * b / 500 + 17 * b / 200 + 1) : 1
    }, _precision: function () {
        var a = this._precisionOf(this.options.step);
        return this.options.min !== null && (a = Math.max(a, this._precisionOf(this.options.min))), a
    }, _precisionOf: function (a) {
        var b = a.toString(), c = b.indexOf(".");
        return c === -1 ? 0 : b.length - c - 1
    }, _adjustValue: function (a) {
        var b, c, d = this.options;
        return b = d.min !== null ? d.min : 0, c = a - b, c = Math.round(c / d.step) * d.step, a = b + c, a = parseFloat(a.toFixed(this._precision())), d.max !== null && a > d.max ? d.max : d.min !== null && a < d.min ? d.min : a
    }, _stop: function (a) {
        if (!this.spinning)return;
        clearTimeout(this.timer), clearTimeout(this.mousewheelTimer), this.counter = 0, this.spinning = !1, this._trigger("stop", a)
    }, _setOption: function (a, b) {
        if (a === "culture" || a === "numberFormat") {
            var c = this._parse(this.element.val());
            this.options[a] = b, this.element.val(this._format(c));
            return
        }
        (a === "max" || a === "min" || a === "step") && typeof b == "string" && (b = this._parse(b)), this._super(a, b), a === "disabled" && (b ? (this.element.prop("disabled", !0), this.buttons.button("disable")) : (this.element.prop("disabled", !1), this.buttons.button("enable")))
    }, _setOptions: b(function (a) {
        this._super(a), this._value(this.element.val())
    }), _parse: function (a) {
        return typeof a == "string" && a !== "" && (a = window.Globalize && this.options.numberFormat ? Globalize.parseFloat(a, 10, this.options.culture) : +a), a === "" || isNaN(a) ? null : a
    }, _format: function (a) {
        return a === "" ? "" : window.Globalize && this.options.numberFormat ? Globalize.format(a, this.options.numberFormat, this.options.culture) : a
    }, _refresh: function () {
        this.element.attr({"aria-valuemin": this.options.min, "aria-valuemax": this.options.max, "aria-valuenow": this._parse(this.element.val())})
    }, _value: function (a, b) {
        var c;
        a !== "" && (c = this._parse(a), c !== null && (b || (c = this._adjustValue(c)), a = this._format(c))), this.element.val(a), this._refresh()
    }, _destroy: function () {
        this.element.removeClass("ui-spinner-input").prop("disabled", !1).removeAttr("autocomplete").removeAttr("role").removeAttr("aria-valuemin").removeAttr("aria-valuemax").removeAttr("aria-valuenow"), this.uiSpinner.replaceWith(this.element)
    }, stepUp: b(function (a) {
        this._stepUp(a)
    }), _stepUp: function (a) {
        this._spin((a || 1) * this.options.step)
    }, stepDown: b(function (a) {
        this._stepDown(a)
    }), _stepDown: function (a) {
        this._spin((a || 1) * -this.options.step)
    }, pageUp: b(function (a) {
        this._stepUp((a || 1) * this.options.page)
    }), pageDown: b(function (a) {
        this._stepDown((a || 1) * this.options.page)
    }), value: function (a) {
        if (!arguments.length)return this._parse(this.element.val());
        b(this._value).call(this, a)
    }, widget: function () {
        return this.uiSpinner
    }})
}(jQuery), function (a, b) {
    function e() {
        return++c
    }

    function f(a) {
        return a.hash.length > 1 && a.href.replace(d, "") === location.href.replace(d, "").replace(/\s/g, "%20")
    }

    var c = 0, d = /#.*$/;
    a.widget("ui.tabs", {version: "1.9.2", delay: 300, options: {active: null, collapsible: !1, event: "click", heightStyle: "content", hide: null, show: null, activate: null, beforeActivate: null, beforeLoad: null, load: null}, _create: function () {
        var b = this, c = this.options, d = c.active, e = location.hash.substring(1);
        this.running = !1, this.element.addClass("ui-tabs ui-widget ui-widget-content ui-corner-all").toggleClass("ui-tabs-collapsible", c.collapsible).delegate(".ui-tabs-nav > li", "mousedown" + this.eventNamespace,function (b) {
            a(this).is(".ui-state-disabled") && b.preventDefault()
        }).delegate(".ui-tabs-anchor", "focus" + this.eventNamespace, function () {
            a(this).closest("li").is(".ui-state-disabled") && this.blur()
        }), this._processTabs();
        if (d === null) {
            e && this.tabs.each(function (b, c) {
                if (a(c).attr("aria-controls") === e)return d = b, !1
            }), d === null && (d = this.tabs.index(this.tabs.filter(".ui-tabs-active")));
            if (d === null || d === -1)d = this.tabs.length ? 0 : !1
        }
        d !== !1 && (d = this.tabs.index(this.tabs.eq(d)), d === -1 && (d = c.collapsible ? !1 : 0)), c.active = d, !c.collapsible && c.active === !1 && this.anchors.length && (c.active = 0), a.isArray(c.disabled) && (c.disabled = a.unique(c.disabled.concat(a.map(this.tabs.filter(".ui-state-disabled"), function (a) {
            return b.tabs.index(a)
        }))).sort()), this.options.active !== !1 && this.anchors.length ? this.active = this._findActive(this.options.active) : this.active = a(), this._refresh(), this.active.length && this.load(c.active)
    }, _getCreateEventData: function () {
        return{tab: this.active, panel: this.active.length ? this._getPanelForTab(this.active) : a()}
    }, _tabKeydown: function (b) {
        var c = a(this.document[0].activeElement).closest("li"), d = this.tabs.index(c), e = !0;
        if (this._handlePageNav(b))return;
        switch (b.keyCode) {
            case a.ui.keyCode.RIGHT:
            case a.ui.keyCode.DOWN:
                d++;
                break;
            case a.ui.keyCode.UP:
            case a.ui.keyCode.LEFT:
                e = !1, d--;
                break;
            case a.ui.keyCode.END:
                d = this.anchors.length - 1;
                break;
            case a.ui.keyCode.HOME:
                d = 0;
                break;
            case a.ui.keyCode.SPACE:
                b.preventDefault(), clearTimeout(this.activating), this._activate(d);
                return;
            case a.ui.keyCode.ENTER:
                b.preventDefault(), clearTimeout(this.activating), this._activate(d === this.options.active ? !1 : d);
                return;
            default:
                return
        }
        b.preventDefault(), clearTimeout(this.activating), d = this._focusNextTab(d, e), b.ctrlKey || (c.attr("aria-selected", "false"), this.tabs.eq(d).attr("aria-selected", "true"), this.activating = this._delay(function () {
            this.option("active", d)
        }, this.delay))
    }, _panelKeydown: function (b) {
        if (this._handlePageNav(b))return;
        b.ctrlKey && b.keyCode === a.ui.keyCode.UP && (b.preventDefault(), this.active.focus())
    }, _handlePageNav: function (b) {
        if (b.altKey && b.keyCode === a.ui.keyCode.PAGE_UP)return this._activate(this._focusNextTab(this.options.active - 1, !1)), !0;
        if (b.altKey && b.keyCode === a.ui.keyCode.PAGE_DOWN)return this._activate(this._focusNextTab(this.options.active + 1, !0)), !0
    }, _findNextTab: function (b, c) {
        function e() {
            return b > d && (b = 0), b < 0 && (b = d), b
        }

        var d = this.tabs.length - 1;
        while (a.inArray(e(), this.options.disabled) !== -1)b = c ? b + 1 : b - 1;
        return b
    }, _focusNextTab: function (a, b) {
        return a = this._findNextTab(a, b), this.tabs.eq(a).focus(), a
    }, _setOption: function (a, b) {
        if (a === "active") {
            this._activate(b);
            return
        }
        if (a === "disabled") {
            this._setupDisabled(b);
            return
        }
        this._super(a, b), a === "collapsible" && (this.element.toggleClass("ui-tabs-collapsible", b), !b && this.options.active === !1 && this._activate(0)), a === "event" && this._setupEvents(b), a === "heightStyle" && this._setupHeightStyle(b)
    }, _tabId: function (a) {
        return a.attr("aria-controls") || "ui-tabs-" + e()
    }, _sanitizeSelector: function (a) {
        return a ? a.replace(/[!"$%&'()*+,.\/:;<=>?@\[\]\^`{|}~]/g, "\\$&") : ""
    }, refresh: function () {
        var b = this.options, c = this.tablist.children(":has(a[href])");
        b.disabled = a.map(c.filter(".ui-state-disabled"), function (a) {
            return c.index(a)
        }), this._processTabs(), b.active === !1 || !this.anchors.length ? (b.active = !1, this.active = a()) : this.active.length && !a.contains(this.tablist[0], this.active[0]) ? this.tabs.length === b.disabled.length ? (b.active = !1, this.active = a()) : this._activate(this._findNextTab(Math.max(0, b.active - 1), !1)) : b.active = this.tabs.index(this.active), this._refresh()
    }, _refresh: function () {
        this._setupDisabled(this.options.disabled), this._setupEvents(this.options.event), this._setupHeightStyle(this.options.heightStyle), this.tabs.not(this.active).attr({"aria-selected": "false", tabIndex: -1}), this.panels.not(this._getPanelForTab(this.active)).hide().attr({"aria-expanded": "false", "aria-hidden": "true"}), this.active.length ? (this.active.addClass("ui-tabs-active ui-state-active").attr({"aria-selected": "true", tabIndex: 0}), this._getPanelForTab(this.active).show().attr({"aria-expanded": "true", "aria-hidden": "false"})) : this.tabs.eq(0).attr("tabIndex", 0)
    }, _processTabs: function () {
        var b = this;
        this.tablist = this._getList().addClass("ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all").attr("role", "tablist"), this.tabs = this.tablist.find("> li:has(a[href])").addClass("ui-state-default ui-corner-top").attr({role: "tab", tabIndex: -1}), this.anchors = this.tabs.map(function () {
            return a("a", this)[0]
        }).addClass("ui-tabs-anchor").attr({role: "presentation", tabIndex: -1}), this.panels = a(), this.anchors.each(function (c, d) {
            var e, g, h, i = a(d).uniqueId().attr("id"), j = a(d).closest("li"), k = j.attr("aria-controls");
            f(d) ? (e = d.hash, g = b.element.find(b._sanitizeSelector(e))) : (h = b._tabId(j), e = "#" + h, g = b.element.find(e), g.length || (g = b._createPanel(h), g.insertAfter(b.panels[c - 1] || b.tablist)), g.attr("aria-live", "polite")), g.length && (b.panels = b.panels.add(g)), k && j.data("ui-tabs-aria-controls", k), j.attr({"aria-controls": e.substring(1), "aria-labelledby": i}), g.attr("aria-labelledby", i)
        }), this.panels.addClass("ui-tabs-panel ui-widget-content ui-corner-bottom").attr("role", "tabpanel")
    }, _getList: function () {
        return this.element.find("ol,ul").eq(0)
    }, _createPanel: function (b) {
        return a("<div>").attr("id", b).addClass("ui-tabs-panel ui-widget-content ui-corner-bottom").data("ui-tabs-destroy", !0)
    }, _setupDisabled: function (b) {
        a.isArray(b) && (b.length ? b.length === this.anchors.length && (b = !0) : b = !1);
        for (var c = 0, d; d = this.tabs[c]; c++)b === !0 || a.inArray(c, b) !== -1 ? a(d).addClass("ui-state-disabled").attr("aria-disabled", "true") : a(d).removeClass("ui-state-disabled").removeAttr("aria-disabled");
        this.options.disabled = b
    }, _setupEvents: function (b) {
        var c = {click: function (a) {
            a.preventDefault()
        }};
        b && a.each(b.split(" "), function (a, b) {
            c[b] = "_eventHandler"
        }), this._off(this.anchors.add(this.tabs).add(this.panels)), this._on(this.anchors, c), this._on(this.tabs, {keydown: "_tabKeydown"}), this._on(this.panels, {keydown: "_panelKeydown"}), this._focusable(this.tabs), this._hoverable(this.tabs)
    }, _setupHeightStyle: function (b) {
        var c, d, e = this.element.parent();
        b === "fill" ? (a.support.minHeight || (d = e.css("overflow"), e.css("overflow", "hidden")), c = e.height(), this.element.siblings(":visible").each(function () {
            var b = a(this), d = b.css("position");
            if (d === "absolute" || d === "fixed")return;
            c -= b.outerHeight(!0)
        }), d && e.css("overflow", d), this.element.children().not(this.panels).each(function () {
            c -= a(this).outerHeight(!0)
        }), this.panels.each(function () {
            a(this).height(Math.max(0, c - a(this).innerHeight() + a(this).height()))
        }).css("overflow", "auto")) : b === "auto" && (c = 0, this.panels.each(function () {
            c = Math.max(c, a(this).height("").height())
        }).height(c))
    }, _eventHandler: function (b) {
        var c = this.options, d = this.active, e = a(b.currentTarget), f = e.closest("li"), g = f[0] === d[0], h = g && c.collapsible, i = h ? a() : this._getPanelForTab(f), j = d.length ? this._getPanelForTab(d) : a(), k = {oldTab: d, oldPanel: j, newTab: h ? a() : f, newPanel: i};
        b.preventDefault();
        if (f.hasClass("ui-state-disabled") || f.hasClass("ui-tabs-loading") || this.running || g && !c.collapsible || this._trigger("beforeActivate", b, k) === !1)return;
        c.active = h ? !1 : this.tabs.index(f), this.active = g ? a() : f, this.xhr && this.xhr.abort(), !j.length && !i.length && a.error("jQuery UI Tabs: Mismatching fragment identifier."), i.length && this.load(this.tabs.index(f), b), this._toggle(b, k)
    }, _toggle: function (b, c) {
        function g() {
            d.running = !1, d._trigger("activate", b, c)
        }

        function h() {
            c.newTab.closest("li").addClass("ui-tabs-active ui-state-active"), e.length && d.options.show ? d._show(e, d.options.show, g) : (e.show(), g())
        }

        var d = this, e = c.newPanel, f = c.oldPanel;
        this.running = !0, f.length && this.options.hide ? this._hide(f, this.options.hide, function () {
            c.oldTab.closest("li").removeClass("ui-tabs-active ui-state-active"), h()
        }) : (c.oldTab.closest("li").removeClass("ui-tabs-active ui-state-active"), f.hide(), h()), f.attr({"aria-expanded": "false", "aria-hidden": "true"}), c.oldTab.attr("aria-selected", "false"), e.length && f.length ? c.oldTab.attr("tabIndex", -1) : e.length && this.tabs.filter(function () {
            return a(this).attr("tabIndex") === 0
        }).attr("tabIndex", -1), e.attr({"aria-expanded": "true", "aria-hidden": "false"}), c.newTab.attr({"aria-selected": "true", tabIndex: 0})
    }, _activate: function (b) {
        var c, d = this._findActive(b);
        if (d[0] === this.active[0])return;
        d.length || (d = this.active), c = d.find(".ui-tabs-anchor")[0], this._eventHandler({target: c, currentTarget: c, preventDefault: a.noop})
    }, _findActive: function (b) {
        return b === !1 ? a() : this.tabs.eq(b)
    }, _getIndex: function (a) {
        return typeof a == "string" && (a = this.anchors.index(this.anchors.filter("[href$='" + a + "']"))), a
    }, _destroy: function () {
        this.xhr && this.xhr.abort(), this.element.removeClass("ui-tabs ui-widget ui-widget-content ui-corner-all ui-tabs-collapsible"), this.tablist.removeClass("ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all").removeAttr("role"), this.anchors.removeClass("ui-tabs-anchor").removeAttr("role").removeAttr("tabIndex").removeData("href.tabs").removeData("load.tabs").removeUniqueId(), this.tabs.add(this.panels).each(function () {
            a.data(this, "ui-tabs-destroy") ? a(this).remove() : a(this).removeClass("ui-state-default ui-state-active ui-state-disabled ui-corner-top ui-corner-bottom ui-widget-content ui-tabs-active ui-tabs-panel").removeAttr("tabIndex").removeAttr("aria-live").removeAttr("aria-busy").removeAttr("aria-selected").removeAttr("aria-labelledby").removeAttr("aria-hidden").removeAttr("aria-expanded").removeAttr("role")
        }), this.tabs.each(function () {
            var b = a(this), c = b.data("ui-tabs-aria-controls");
            c ? b.attr("aria-controls", c) : b.removeAttr("aria-controls")
        }), this.panels.show(), this.options.heightStyle !== "content" && this.panels.css("height", "")
    }, enable: function (c) {
        var d = this.options.disabled;
        if (d === !1)return;
        c === b ? d = !1 : (c = this._getIndex(c), a.isArray(d) ? d = a.map(d, function (a) {
            return a !== c ? a : null
        }) : d = a.map(this.tabs, function (a, b) {
            return b !== c ? b : null
        })), this._setupDisabled(d)
    }, disable: function (c) {
        var d = this.options.disabled;
        if (d === !0)return;
        if (c === b)d = !0; else {
            c = this._getIndex(c);
            if (a.inArray(c, d) !== -1)return;
            a.isArray(d) ? d = a.merge([c], d).sort() : d = [c]
        }
        this._setupDisabled(d)
    }, load: function (b, c) {
        b = this._getIndex(b);
        var d = this, e = this.tabs.eq(b), g = e.find(".ui-tabs-anchor"), h = this._getPanelForTab(e), i = {tab: e, panel: h};
        if (f(g[0]))return;
        this.xhr = a.ajax(this._ajaxSettings(g, c, i)), this.xhr && this.xhr.statusText !== "canceled" && (e.addClass("ui-tabs-loading"), h.attr("aria-busy", "true"), this.xhr.success(function (a) {
            setTimeout(function () {
                h.html(a), d._trigger("load", c, i)
            }, 1)
        }).complete(function (a, b) {
            setTimeout(function () {
                b === "abort" && d.panels.stop(!1, !0), e.removeClass("ui-tabs-loading"), h.removeAttr("aria-busy"), a === d.xhr && delete d.xhr
            }, 1)
        }))
    }, _ajaxSettings: function (b, c, d) {
        var e = this;
        return{url: b.attr("href"), beforeSend: function (b, f) {
            return e._trigger("beforeLoad", c, a.extend({jqXHR: b, ajaxSettings: f}, d))
        }}
    }, _getPanelForTab: function (b) {
        var c = a(b).attr("aria-controls");
        return this.element.find(this._sanitizeSelector("#" + c))
    }}), a.uiBackCompat !== !1 && (a.ui.tabs.prototype._ui = function (a, b) {
        return{tab: a, panel: b, index: this.anchors.index(a)}
    }, a.widget("ui.tabs", a.ui.tabs, {url: function (a, b) {
        this.anchors.eq(a).attr("href", b)
    }}), a.widget("ui.tabs", a.ui.tabs, {options: {ajaxOptions: null, cache: !1}, _create: function () {
        this._super();
        var b = this;
        this._on({tabsbeforeload: function (c, d) {
            if (a.data(d.tab[0], "cache.tabs")) {
                c.preventDefault();
                return
            }
            d.jqXHR.success(function () {
                b.options.cache && a.data(d.tab[0], "cache.tabs", !0)
            })
        }})
    }, _ajaxSettings: function (b, c, d) {
        var e = this.options.ajaxOptions;
        return a.extend({}, e, {error: function (a, b) {
            try {
                e.error(a, b, d.tab.closest("li").index(), d.tab[0])
            } catch (c) {
            }
        }}, this._superApply(arguments))
    }, _setOption: function (a, b) {
        a === "cache" && b === !1 && this.anchors.removeData("cache.tabs"), this._super(a, b)
    }, _destroy: function () {
        this.anchors.removeData("cache.tabs"), this._super()
    }, url: function (a) {
        this.anchors.eq(a).removeData("cache.tabs"), this._superApply(arguments)
    }}), a.widget("ui.tabs", a.ui.tabs, {abort: function () {
        this.xhr && this.xhr.abort()
    }}), a.widget("ui.tabs", a.ui.tabs, {options: {spinner: "<em>Loading&#8230;</em>"}, _create: function () {
        this._super(), this._on({tabsbeforeload: function (a, b) {
            if (a.target !== this.element[0] || !this.options.spinner)return;
            var c = b.tab.find("span"), d = c.html();
            c.html(this.options.spinner), b.jqXHR.complete(function () {
                c.html(d)
            })
        }})
    }}), a.widget("ui.tabs", a.ui.tabs, {options: {enable: null, disable: null}, enable: function (b) {
        var c = this.options, d;
        if (b && c.disabled === !0 || a.isArray(c.disabled) && a.inArray(b, c.disabled) !== -1)d = !0;
        this._superApply(arguments), d && this._trigger("enable", null, this._ui(this.anchors[b], this.panels[b]))
    }, disable: function (b) {
        var c = this.options, d;
        if (b && c.disabled === !1 || a.isArray(c.disabled) && a.inArray(b, c.disabled) === -1)d = !0;
        this._superApply(arguments), d && this._trigger("disable", null, this._ui(this.anchors[b], this.panels[b]))
    }}), a.widget("ui.tabs", a.ui.tabs, {options: {add: null, remove: null, tabTemplate: "<li><a href='#{href}'><span>#{label}</span></a></li>"}, add: function (c, d, e) {
        e === b && (e = this.anchors.length);
        var f, g, h = this.options, i = a(h.tabTemplate.replace(/#\{href\}/g, c).replace(/#\{label\}/g, d)), j = c.indexOf("#") ? this._tabId(i) : c.replace("#", "");
        return i.addClass("ui-state-default ui-corner-top").data("ui-tabs-destroy", !0), i.attr("aria-controls", j), f = e >= this.tabs.length, g = this.element.find("#" + j), g.length || (g = this._createPanel(j), f ? e > 0 ? g.insertAfter(this.panels.eq(-1)) : g.appendTo(this.element) : g.insertBefore(this.panels[e])), g.addClass("ui-tabs-panel ui-widget-content ui-corner-bottom").hide(), f ? i.appendTo(this.tablist) : i.insertBefore(this.tabs[e]), h.disabled = a.map(h.disabled, function (a) {
            return a >= e ? ++a : a
        }), this.refresh(), this.tabs.length === 1 && h.active === !1 && this.option("active", 0), this._trigger("add", null, this._ui(this.anchors[e], this.panels[e])), this
    }, remove: function (b) {
        b = this._getIndex(b);
        var c = this.options, d = this.tabs.eq(b).remove(), e = this._getPanelForTab(d).remove();
        return d.hasClass("ui-tabs-active") && this.anchors.length > 2 && this._activate(b + (b + 1 < this.anchors.length ? 1 : -1)), c.disabled = a.map(a.grep(c.disabled, function (a) {
            return a !== b
        }), function (a) {
            return a >= b ? --a : a
        }), this.refresh(), this._trigger("remove", null, this._ui(d.find("a")[0], e[0])), this
    }}), a.widget("ui.tabs", a.ui.tabs, {length: function () {
        return this.anchors.length
    }}), a.widget("ui.tabs", a.ui.tabs, {options: {idPrefix: "ui-tabs-"}, _tabId: function (b) {
        var c = b.is("li") ? b.find("a[href]") : b;
        return c = c[0], a(c).closest("li").attr("aria-controls") || c.title && c.title.replace(/\s/g, "_").replace(/[^\w\u00c0-\uFFFF\-]/g, "") || this.options.idPrefix + e()
    }}), a.widget("ui.tabs", a.ui.tabs, {options: {panelTemplate: "<div></div>"}, _createPanel: function (b) {
        return a(this.options.panelTemplate).attr("id", b).addClass("ui-tabs-panel ui-widget-content ui-corner-bottom").data("ui-tabs-destroy", !0)
    }}), a.widget("ui.tabs", a.ui.tabs, {_create: function () {
        var a = this.options;
        a.active === null && a.selected !== b && (a.active = a.selected === -1 ? !1 : a.selected), this._super(), a.selected = a.active, a.selected === !1 && (a.selected = -1)
    }, _setOption: function (a, b) {
        if (a !== "selected")return this._super(a, b);
        var c = this.options;
        this._super("active", b === -1 ? !1 : b), c.selected = c.active, c.selected === !1 && (c.selected = -1)
    }, _eventHandler: function () {
        this._superApply(arguments), this.options.selected = this.options.active, this.options.selected === !1 && (this.options.selected = -1)
    }}), a.widget("ui.tabs", a.ui.tabs, {options: {show: null, select: null}, _create: function () {
        this._super(), this.options.active !== !1 && this._trigger("show", null, this._ui(this.active.find(".ui-tabs-anchor")[0], this._getPanelForTab(this.active)[0]))
    }, _trigger: function (a, b, c) {
        var d, e, f = this._superApply(arguments);
        return f ? (a === "beforeActivate" ? (d = c.newTab.length ? c.newTab : c.oldTab, e = c.newPanel.length ? c.newPanel : c.oldPanel, f = this._super("select", b, {tab: d.find(".ui-tabs-anchor")[0], panel: e[0], index: d.closest("li").index()})) : a === "activate" && c.newTab.length && (f = this._super("show", b, {tab: c.newTab.find(".ui-tabs-anchor")[0], panel: c.newPanel[0], index: c.newTab.closest("li").index()})), f) : !1
    }}), a.widget("ui.tabs", a.ui.tabs, {select: function (a) {
        a = this._getIndex(a);
        if (a === -1) {
            if (!this.options.collapsible || this.options.selected === -1)return;
            a = this.options.selected
        }
        this.anchors.eq(a).trigger(this.options.event + this.eventNamespace)
    }}), function () {
        var b = 0;
        a.widget("ui.tabs", a.ui.tabs, {options: {cookie: null}, _create: function () {
            var a = this.options, b;
            a.active == null && a.cookie && (b = parseInt(this._cookie(), 10), b === -1 && (b = !1), a.active = b), this._super()
        }, _cookie: function (c) {
            var d = [this.cookie || (this.cookie = this.options.cookie.name || "ui-tabs-" + ++b)];
            return arguments.length && (d.push(c === !1 ? -1 : c), d.push(this.options.cookie)), a.cookie.apply(null, d)
        }, _refresh: function () {
            this._super(), this.options.cookie && this._cookie(this.options.active, this.options.cookie)
        }, _eventHandler: function () {
            this._superApply(arguments), this.options.cookie && this._cookie(this.options.active, this.options.cookie)
        }, _destroy: function () {
            this._super(), this.options.cookie && this._cookie(null, this.options.cookie)
        }})
    }(), a.widget("ui.tabs", a.ui.tabs, {_trigger: function (b, c, d) {
        var e = a.extend({}, d);
        return b === "load" && (e.panel = e.panel[0], e.tab = e.tab.find(".ui-tabs-anchor")[0]), this._super(b, c, e)
    }}), a.widget("ui.tabs", a.ui.tabs, {options: {fx: null}, _getFx: function () {
        var b, c, d = this.options.fx;
        return d && (a.isArray(d) ? (b = d[0], c = d[1]) : b = c = d), d ? {show: c, hide: b} : null
    }, _toggle: function (a, b) {
        function g() {
            c.running = !1, c._trigger("activate", a, b)
        }

        function h() {
            b.newTab.closest("li").addClass("ui-tabs-active ui-state-active"), d.length && f.show ? d.animate(f.show, f.show.duration, function () {
                g()
            }) : (d.show(), g())
        }

        var c = this, d = b.newPanel, e = b.oldPanel, f = this._getFx();
        if (!f)return this._super(a, b);
        c.running = !0, e.length && f.hide ? e.animate(f.hide, f.hide.duration, function () {
            b.oldTab.closest("li").removeClass("ui-tabs-active ui-state-active"), h()
        }) : (b.oldTab.closest("li").removeClass("ui-tabs-active ui-state-active"), e.hide(), h())
    }}))
}(jQuery), function (a) {
    function c(b, c) {
        var d = (b.attr("aria-describedby") || "").split(/\s+/);
        d.push(c), b.data("ui-tooltip-id", c).attr("aria-describedby", a.trim(d.join(" ")))
    }

    function d(b) {
        var c = b.data("ui-tooltip-id"), d = (b.attr("aria-describedby") || "").split(/\s+/), e = a.inArray(c, d);
        e !== -1 && d.splice(e, 1), b.removeData("ui-tooltip-id"), d = a.trim(d.join(" ")), d ? b.attr("aria-describedby", d) : b.removeAttr("aria-describedby")
    }

    var b = 0;
    a.widget("ui.tooltip", {version: "1.9.2", options: {content: function () {
        return a(this).attr("title")
    }, hide: !0, items: "[title]:not([disabled])", position: {my: "left top+15", at: "left bottom", collision: "flipfit flip"}, show: !0, tooltipClass: null, track: !1, close: null, open: null}, _create: function () {
        this._on({mouseover: "open", focusin: "open"}), this.tooltips = {}, this.parents = {}, this.options.disabled && this._disable()
    }, _setOption: function (b, c) {
        var d = this;
        if (b === "disabled") {
            this[c ? "_disable" : "_enable"](), this.options[b] = c;
            return
        }
        this._super(b, c), b === "content" && a.each(this.tooltips, function (a, b) {
            d._updateContent(b)
        })
    }, _disable: function () {
        var b = this;
        a.each(this.tooltips, function (c, d) {
            var e = a.Event("blur");
            e.target = e.currentTarget = d[0], b.close(e, !0)
        }), this.element.find(this.options.items).andSelf().each(function () {
            var b = a(this);
            b.is("[title]") && b.data("ui-tooltip-title", b.attr("title")).attr("title", "")
        })
    }, _enable: function () {
        this.element.find(this.options.items).andSelf().each(function () {
            var b = a(this);
            b.data("ui-tooltip-title") && b.attr("title", b.data("ui-tooltip-title"))
        })
    }, open: function (b) {
        var c = this, d = a(b ? b.target : this.element).closest(this.options.items);
        if (!d.length || d.data("ui-tooltip-id"))return;
        d.attr("title") && d.data("ui-tooltip-title", d.attr("title")), d.data("ui-tooltip-open"
            , !0), b && b.type === "mouseover" && d.parents().each(function () {
            var b = a(this), d;
            b.data("ui-tooltip-open") && (d = a.Event("blur"), d.target = d.currentTarget = this, c.close(d, !0)), b.attr("title") && (b.uniqueId(), c.parents[this.id] = {element: this, title: b.attr("title")}, b.attr("title", ""))
        }), this._updateContent(d, b)
    }, _updateContent: function (a, b) {
        var c, d = this.options.content, e = this, f = b ? b.type : null;
        if (typeof d == "string")return this._open(b, a, d);
        c = d.call(a[0], function (c) {
            if (!a.data("ui-tooltip-open"))return;
            e._delay(function () {
                b && (b.type = f), this._open(b, a, c)
            })
        }), c && this._open(b, a, c)
    }, _open: function (b, d, e) {
        function j(a) {
            i.of = a;
            if (f.is(":hidden"))return;
            f.position(i)
        }

        var f, g, h, i = a.extend({}, this.options.position);
        if (!e)return;
        f = this._find(d);
        if (f.length) {
            f.find(".ui-tooltip-content").html(e);
            return
        }
        d.is("[title]") && (b && b.type === "mouseover" ? d.attr("title", "") : d.removeAttr("title")), f = this._tooltip(d), c(d, f.attr("id")), f.find(".ui-tooltip-content").html(e), this.options.track && b && /^mouse/.test(b.type) ? (this._on(this.document, {mousemove: j}), j(b)) : f.position(a.extend({of: d}, this.options.position)), f.hide(), this._show(f, this.options.show), this.options.show && this.options.show.delay && (h = setInterval(function () {
            f.is(":visible") && (j(i.of), clearInterval(h))
        }, a.fx.interval)), this._trigger("open", b, {tooltip: f}), g = {keyup: function (b) {
            if (b.keyCode === a.ui.keyCode.ESCAPE) {
                var c = a.Event(b);
                c.currentTarget = d[0], this.close(c, !0)
            }
        }, remove: function () {
            this._removeTooltip(f)
        }};
        if (!b || b.type === "mouseover")g.mouseleave = "close";
        if (!b || b.type === "focusin")g.focusout = "close";
        this._on(!0, d, g)
    }, close: function (b) {
        var c = this, e = a(b ? b.currentTarget : this.element), f = this._find(e);
        if (this.closing)return;
        e.data("ui-tooltip-title") && e.attr("title", e.data("ui-tooltip-title")), d(e), f.stop(!0), this._hide(f, this.options.hide, function () {
            c._removeTooltip(a(this))
        }), e.removeData("ui-tooltip-open"), this._off(e, "mouseleave focusout keyup"), e[0] !== this.element[0] && this._off(e, "remove"), this._off(this.document, "mousemove"), b && b.type === "mouseleave" && a.each(this.parents, function (b, d) {
            a(d.element).attr("title", d.title), delete c.parents[b]
        }), this.closing = !0, this._trigger("close", b, {tooltip: f}), this.closing = !1
    }, _tooltip: function (c) {
        var d = "ui-tooltip-" + b++, e = a("<div>").attr({id: d, role: "tooltip"}).addClass("ui-tooltip ui-widget ui-corner-all ui-widget-content " + (this.options.tooltipClass || ""));
        return a("<div>").addClass("ui-tooltip-content").appendTo(e), e.appendTo(this.document[0].body), a.fn.bgiframe && e.bgiframe(), this.tooltips[d] = c, e
    }, _find: function (b) {
        var c = b.data("ui-tooltip-id");
        return c ? a("#" + c) : a()
    }, _removeTooltip: function (a) {
        a.remove(), delete this.tooltips[a.attr("id")]
    }, _destroy: function () {
        var b = this;
        a.each(this.tooltips, function (c, d) {
            var e = a.Event("blur");
            e.target = e.currentTarget = d[0], b.close(e, !0), a("#" + c).remove(), d.data("ui-tooltip-title") && (d.attr("title", d.data("ui-tooltip-title")), d.removeData("ui-tooltip-title"))
        })
    }})
}(jQuery), function (a, b) {
    var c = function () {
        var b = a._data(document, "events");
        return b && b.click && a.grep(b.click,function (a) {
            return a.namespace === "rails"
        }).length
    };
    c() && a.error("jquery-ujs has already been loaded!");
    var d;
    a.rails = d = {linkClickSelector: "a[data-confirm], a[data-method], a[data-remote], a[data-disable-with]", inputChangeSelector: "select[data-remote], input[data-remote], textarea[data-remote]", formSubmitSelector: "form", formInputClickSelector: "form input[type=submit], form input[type=image], form button[type=submit], form button:not([type])", disableSelector: "input[data-disable-with], button[data-disable-with], textarea[data-disable-with]", enableSelector: "input[data-disable-with]:disabled, button[data-disable-with]:disabled, textarea[data-disable-with]:disabled", requiredInputSelector: "input[name][required]:not([disabled]),textarea[name][required]:not([disabled])", fileInputSelector: "input:file", linkDisableSelector: "a[data-disable-with]", CSRFProtection: function (b) {
        var c = a('meta[name="csrf-token"]').attr("content");
        c && b.setRequestHeader("X-CSRF-Token", c)
    }, fire: function (b, c, d) {
        var e = a.Event(c);
        return b.trigger(e, d), e.result !== !1
    }, confirm: function (a) {
        return confirm(a)
    }, ajax: function (b) {
        return a.ajax(b)
    }, href: function (a) {
        return a.attr("href")
    }, handleRemote: function (c) {
        var e, f, g, h, i, j, k, l;
        if (d.fire(c, "ajax:before")) {
            h = c.data("cross-domain"), i = h === b ? null : h, j = c.data("with-credentials") || null, k = c.data("type") || a.ajaxSettings && a.ajaxSettings.dataType;
            if (c.is("form")) {
                e = c.attr("method"), f = c.attr("action"), g = c.serializeArray();
                var m = c.data("ujs:submit-button");
                m && (g.push(m), c.data("ujs:submit-button", null))
            } else c.is(d.inputChangeSelector) ? (e = c.data("method"), f = c.data("url"), g = c.serialize(), c.data("params") && (g = g + "&" + c.data("params"))) : (e = c.data("method"), f = d.href(c), g = c.data("params") || null);
            l = {type: e || "GET", data: g, dataType: k, beforeSend: function (a, e) {
                return e.dataType === b && a.setRequestHeader("accept", "*/*;q=0.5, " + e.accepts.script), d.fire(c, "ajax:beforeSend", [a, e])
            }, success: function (a, b, d) {
                c.trigger("ajax:success", [a, b, d])
            }, complete: function (a, b) {
                c.trigger("ajax:complete", [a, b])
            }, error: function (a, b, d) {
                c.trigger("ajax:error", [a, b, d])
            }, xhrFields: {withCredentials: j}, crossDomain: i}, f && (l.url = f);
            var n = d.ajax(l);
            return c.trigger("ajax:send", n), n
        }
        return!1
    }, handleMethod: function (c) {
        var e = d.href(c), f = c.data("method"), g = c.attr("target"), h = a("meta[name=csrf-token]").attr("content"), i = a("meta[name=csrf-param]").attr("content"), j = a('<form method="post" action="' + e + '"></form>'), k = '<input name="_method" value="' + f + '" type="hidden" />';
        i !== b && h !== b && (k += '<input name="' + i + '" value="' + h + '" type="hidden" />'), g && j.attr("target", g), j.hide().append(k).appendTo("body"), j.submit()
    }, disableFormElements: function (b) {
        b.find(d.disableSelector).each(function () {
            var b = a(this), c = b.is("button") ? "html" : "val";
            b.data("ujs:enable-with", b[c]()), b[c](b.data("disable-with")), b.prop("disabled", !0)
        })
    }, enableFormElements: function (b) {
        b.find(d.enableSelector).each(function () {
            var b = a(this), c = b.is("button") ? "html" : "val";
            b.data("ujs:enable-with") && b[c](b.data("ujs:enable-with")), b.prop("disabled", !1)
        })
    }, allowAction: function (a) {
        var b = a.data("confirm"), c = !1, e;
        return b ? (d.fire(a, "confirm") && (c = d.confirm(b), e = d.fire(a, "confirm:complete", [c])), c && e) : !0
    }, blankInputs: function (b, c, d) {
        var e = a(), f, g, h = c || "input,textarea", i = b.find(h);
        return i.each(function () {
            f = a(this), g = f.is(":checkbox,:radio") ? f.is(":checked") : f.val();
            if (!g == !d) {
                if (f.is(":radio") && i.filter('input:radio:checked[name="' + f.attr("name") + '"]').length)return!0;
                e = e.add(f)
            }
        }), e.length ? e : !1
    }, nonBlankInputs: function (a, b) {
        return d.blankInputs(a, b, !0)
    }, stopEverything: function (b) {
        return a(b.target).trigger("ujs:everythingStopped"), b.stopImmediatePropagation(), !1
    }, callFormSubmitBindings: function (c, d) {
        var e = c.data("events"), f = !0;
        return e !== b && e.submit !== b && a.each(e.submit, function (a, b) {
            if (typeof b.handler == "function")return f = b.handler(d)
        }), f
    }, disableElement: function (a) {
        a.data("ujs:enable-with", a.html()), a.html(a.data("disable-with")), a.bind("click.railsDisable", function (a) {
            return d.stopEverything(a)
        })
    }, enableElement: function (a) {
        a.data("ujs:enable-with") !== b && (a.html(a.data("ujs:enable-with")), a.data("ujs:enable-with", !1)), a.unbind("click.railsDisable")
    }}, d.fire(a(document), "rails:attachBindings") && (a.ajaxPrefilter(function (a, b, c) {
        a.crossDomain || d.CSRFProtection(c)
    }), a(document).delegate(d.linkDisableSelector, "ajax:complete", function () {
        d.enableElement(a(this))
    }), a(document).delegate(d.linkClickSelector, "click.rails", function (c) {
        var e = a(this), f = e.data("method"), g = e.data("params");
        if (!d.allowAction(e))return d.stopEverything(c);
        e.is(d.linkDisableSelector) && d.disableElement(e);
        if (e.data("remote") !== b) {
            if ((c.metaKey || c.ctrlKey) && (!f || f === "GET") && !g)return!0;
            var h = d.handleRemote(e);
            return h === !1 ? d.enableElement(e) : h.error(function () {
                d.enableElement(e)
            }), !1
        }
        if (e.data("method"))return d.handleMethod(e), !1
    }), a(document).delegate(d.inputChangeSelector, "change.rails", function (b) {
        var c = a(this);
        return d.allowAction(c) ? (d.handleRemote(c), !1) : d.stopEverything(b)
    }), a(document).delegate(d.formSubmitSelector, "submit.rails", function (c) {
        var e = a(this), f = e.data("remote") !== b, g = d.blankInputs(e, d.requiredInputSelector), h = d.nonBlankInputs(e, d.fileInputSelector);
        if (!d.allowAction(e))return d.stopEverything(c);
        if (g && e.attr("novalidate") == b && d.fire(e, "ajax:aborted:required", [g]))return d.stopEverything(c);
        if (f) {
            if (h) {
                setTimeout(function () {
                    d.disableFormElements(e)
                }, 13);
                var i = d.fire(e, "ajax:aborted:file", [h]);
                return i || setTimeout(function () {
                    d.enableFormElements(e)
                }, 13), i
            }
            return!a.support.submitBubbles && a().jquery < "1.7" && d.callFormSubmitBindings(e, c) === !1 ? d.stopEverything(c) : (d.handleRemote(e), !1)
        }
        setTimeout(function () {
            d.disableFormElements(e)
        }, 13)
    }), a(document).delegate(d.formInputClickSelector, "click.rails", function (b) {
        var c = a(this);
        if (!d.allowAction(c))return d.stopEverything(b);
        var e = c.attr("name"), f = e ? {name: e, value: c.val()} : null;
        c.closest("form").data("ujs:submit-button", f)
    }), a(document).delegate(d.formSubmitSelector, "ajax:beforeSend.rails", function (b) {
        this == b.target && d.disableFormElements(a(this))
    }), a(document).delegate(d.formSubmitSelector, "ajax:complete.rails", function (b) {
        this == b.target && d.enableFormElements(a(this))
    }), a(function () {
        csrf_token = a("meta[name=csrf-token]").attr("content"), csrf_param = a("meta[name=csrf-param]").attr("content"), a('form input[name="' + csrf_param + '"]').val(csrf_token)
    }))
}(jQuery), function () {
    window.ActiveAdmin = {}, window.AA || (window.AA = window.ActiveAdmin)
}.call(this), function () {
    window.ActiveAdmin.CheckboxToggler = ActiveAdmin.CheckboxToggler = function () {
        function a(a, b) {
            var c;
            this.options = a, this.container = b, c = {}, this.options = $.extend({}, c, a), this._init(), this._bind()
        }

        return a.prototype._init = function () {
            if (!this.container)throw new Error("Container element not found");
            this.$container = $(this.container);
            if (!this.$container.find(".toggle_all").length)throw new Error('"toggle all" checkbox not found');
            return this.toggle_all_checkbox = this.$container.find(".toggle_all"), this.checkboxes = this.$container.find(":checkbox").not(this.toggle_all_checkbox)
        }, a.prototype._bind = function () {
            var a = this;
            return this.checkboxes.change(function (b) {
                return a._didChangeCheckbox(b.target)
            }), this.toggle_all_checkbox.change(function () {
                return a._didChangeToggleAllCheckbox()
            })
        }, a.prototype._didChangeCheckbox = function (a) {
            switch (this.checkboxes.filter(":checked").length) {
                case this.checkboxes.length - 1:
                    return this.toggle_all_checkbox.prop({checked: null});
                case this.checkboxes.length:
                    return this.toggle_all_checkbox.prop({checked: !0})
            }
        }, a.prototype._didChangeToggleAllCheckbox = function () {
            var a, b = this;
            return a = this.toggle_all_checkbox.prop("checked") ? !0 : null, this.checkboxes.each(function (c, d) {
                return $(d).prop({checked: a}), b._didChangeCheckbox(d)
            })
        }, a
    }(), jQuery(function (a) {
        return a.widget.bridge("checkboxToggler", ActiveAdmin.CheckboxToggler)
    })
}.call(this), function () {
    window.ActiveAdmin.DropdownMenu = ActiveAdmin.DropdownMenu = function () {
        function a(a, b) {
            var c;
            this.options = a, this.element = b, this.$element = $(this.element), c = {fadeInDuration: 20, fadeOutDuration: 100, onClickActionItemCallback: null}, this.options = $.extend({}, c, a), this.$menuButton = this.$element.find(".dropdown_menu_button"), this.$menuList = this.$element.find(".dropdown_menu_list_wrapper"), this.isOpen = !1, this._buildMenuList(), this._bind()
        }

        return a.prototype.open = function () {
            return this.isOpen = !0, this.$menuList.fadeIn(this.options.fadeInDuration), this._positionMenuList(), this._positionNipple(), this
        }, a.prototype.close = function () {
            return this.isOpen = !1, this.$menuList.fadeOut(this.options.fadeOutDuration), this
        }, a.prototype.destroy = function () {
            return this.$element.unbind(), this.$element = null, this
        }, a.prototype.isDisabled = function () {
            return this.$menuButton.hasClass("disabled")
        }, a.prototype.disable = function () {
            return this.$menuButton.addClass("disabled")
        }, a.prototype.enable = function () {
            return this.$menuButton.removeClass("disabled")
        }, a.prototype.option = function (a, b) {
            return $.isPlainObject(a) ? this.options = $.extend(!0, this.options, a) : a != null ? this.options[a] : this.options[a] = b
        }, a.prototype._buildMenuList = function () {
            return this.$menuList.prepend('<div class="dropdown_menu_nipple"></div>'), this.$menuList.hide()
        }, a.prototype._bind = function () {
            var a = this;
            return $("body").bind("click", function () {
                if (a.isOpen === !0)return a.close()
            }), this.$menuButton.bind("click", function () {
                return a.isDisabled() || (a.isOpen === !0 ? a.close() : a.open()), !1
            })
        }, a.prototype._positionMenuList = function () {
            var a, b, c;
            return a = this.$menuButton.position().left + this.$menuButton.outerWidth() / 2, b = this.$menuList.outerWidth() / 2, c = a - b, this.$menuList.css("left", c)
        }, a.prototype._positionNipple = function () {
            var a, b, c, d, e;
            return c = this.$menuList.outerWidth() / 2, b = this.$menuButton.position().top + this.$menuButton.outerHeight() + 10, this.$menuList.css("top", b), a = this.$menuList.find(".dropdown_menu_nipple"), d = a.outerWidth() / 2, e = c - d, a.css("left", e)
        }, a
    }(), function (a) {
        return a.widget.bridge("aaDropdownMenu", ActiveAdmin.DropdownMenu), a(function () {
            return a(".dropdown_menu").aaDropdownMenu()
        })
    }(jQuery)
}.call(this), function () {
    window.ActiveAdmin.Popover = ActiveAdmin.Popover = function () {
        function a(a, b) {
            var c;
            this.options = a, this.element = b, this.$element = $(this.element), c = {fadeInDuration: 20, fadeOutDuration: 100, autoOpen: !0, pageWrapperElement: "#wrapper", onClickActionItemCallback: null}, this.options = $.extend({}, c, a), this.$popover = null, this.isOpen = !1, $(this.$element.attr("href")).length > 0 ? this.$popover = $(this.$element.attr("href")) : this.$popover = this.$element.next(".popover"), this._buildPopover(), this._bind()
        }

        return a.prototype.open = function () {
            return this.isOpen = !0, this.$popover.fadeIn(this.options.fadeInDuration), this._positionPopover(), this._positionNipple(), this
        }, a.prototype.close = function () {
            return this.isOpen = !1, this.$popover.fadeOut(this.options.fadeOutDuration), this
        }, a.prototype.destroy = function () {
            return this.$element.removeData("popover"), this.$element.unbind(), this.$element = null, this
        }, a.prototype.option = function () {
        }, a.prototype._buildPopover = function () {
            return this.$popover.prepend('<div class="popover_nipple"></div>'), this.$popover.hide(), this.$popover.addClass("popover")
        }, a.prototype._bind = function () {
            var a = this;
            $(this.options.pageWrapperElement).bind("click", function (b) {
                if (a.isOpen === !0)return a.close()
            });
            if (this.options.autoOpen === !0)return this.$element.bind("click", function () {
                return a.isOpen === !0 ? a.close() : a.open(), !1
            })
        }, a.prototype._positionPopover = function () {
            var a, b, c;
            return a = this.$element.offset().left + this.$element.outerWidth() / 2, b = this.$popover.outerWidth() / 2, c = a - b, this.$popover.css("left", c)
        }, a.prototype._positionNipple = function () {
            var a, b, c, d, e;
            return c = this.$popover.outerWidth() / 2, b = this.$element.offset().top + this.$element.outerHeight() + 10, this.$popover.css("top", b), a = this.$popover.find(".popover_nipple"), d = a.outerWidth() / 2, e = c - d, a.css("left", e)
        }, a
    }(), function (a) {
        return a.widget.bridge("popover", ActiveAdmin.Popover)
    }(jQuery)
}.call(this), function () {
    var a, b = {}.hasOwnProperty, c = function (a, c) {
        function e() {
            this.constructor = a
        }

        for (var d in c)b.call(c, d) && (a[d] = c[d]);
        return e.prototype = c.prototype, a.prototype = new e, a.__super__ = c.prototype, a
    };
    window.ActiveAdmin.TableCheckboxToggler = ActiveAdmin.TableCheckboxToggler = function (b) {
        function d() {
            return a = d.__super__.constructor.apply(this, arguments), a
        }

        return c(d, b), d.prototype._init = function () {
            return d.__super__._init.apply(this, arguments)
        }, d.prototype._bind = function () {
            var a = this;
            return d.__super__._bind.apply(this, arguments), this.$container.find("tbody td").click(function (b) {
                if (b.target.type !== "checkbox")return a._didClickCell(b.target)
            })
        }, d.prototype._didChangeCheckbox = function (a) {
            var b;
            return d.__super__._didChangeCheckbox.apply(this, arguments), b = $(a).parents("tr"), a.checked ? b.addClass("selected") : b.removeClass("selected")
        }, d.prototype._didClickCell = function (a) {
            return $(a).parent("tr").find(":checkbox").click()
        }, d
    }(ActiveAdmin.CheckboxToggler), jQuery(function (a) {
        return a.widget.bridge("tableCheckboxToggler", ActiveAdmin.TableCheckboxToggler)
    })
}.call(this), function () {
    $(function () {
        return $(document).on("focus", ".datepicker:not(.hasDatepicker)", function () {
            return $(this).datepicker({dateFormat: "yy-mm-dd"})
        }), $(".clear_filters_btn").click(function () {
            return window.location.search = ""
        }), $(".dropdown_button").popover(), $(".filter_form").submit(function () {
            return $(this).find(":input").filter(function () {
                return this.value === ""
            }).prop("disabled", !0)
        }), $(".filter_form_field.select_and_search select").change(function () {
            return $(this).siblings("input").prop({name: "q[" + this.value + "]"})
        })
    })
}.call(this), function () {
    jQuery(function (a) {
        a(document).delegate("#batch_actions_selector li a", "click.rails", function () {
            return a("#batch_action").val(a(this).attr("data-action")), a("#collection_selection").submit()
        });
        if (a("#batch_actions_selector").length && a(":checkbox.toggle_all").length)return a(".paginated_collection table.index_table").length ? a(".paginated_collection table.index_table").tableCheckboxToggler() : a(".paginated_collection").checkboxToggler(), a(".paginated_collection").find(":checkbox").bind("change", function () {
            return a(".paginated_collection").find(":checkbox").filter(":checked").length > 0 ? a("#batch_actions_selector").aaDropdownMenu("enable") : a("#batch_actions_selector").aaDropdownMenu("disable")
        })
    })
}.call(this);