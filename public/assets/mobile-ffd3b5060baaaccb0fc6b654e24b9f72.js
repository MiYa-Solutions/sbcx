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
    }), a(document).delegate
    (d.linkClickSelector, "click.rails", function (c) {
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
}(jQuery), function (a, b, c) {
    typeof define == "function" && define.amd ? define(["jquery"], function (d) {
        return c(d, a, b), d.mobile
    }) : c(a.jQuery, a, b)
}(this, document, function (a, b, c, d) {
    (function (a, b, d) {
        var e = {};
        a.mobile = a.extend({}, {version: "1.2.0", ns: "", subPageUrlKey: "ui-page", activePageClass: "ui-page-active", activeBtnClass: "ui-btn-active", focusClass: "ui-focus", ajaxEnabled: !0, hashListeningEnabled: !0, linkBindingEnabled: !0, defaultPageTransition: "fade", maxTransitionWidth: !1, minScrollBack: 250, touchOverflowEnabled: !1, defaultDialogTransition: "pop", pageLoadErrorMessage: "Error Loading Page", pageLoadErrorMessageTheme: "e", phonegapNavigationEnabled: !1, autoInitializePage: !0, pushStateEnabled: !0, ignoreContentEnabled: !1, orientationChangeEnabled: !0, buttonMarkup: {hoverDelay: 200}, keyCode: {ALT: 18, BACKSPACE: 8, CAPS_LOCK: 20, COMMA: 188, COMMAND: 91, COMMAND_LEFT: 91, COMMAND_RIGHT: 93, CONTROL: 17, DELETE: 46, DOWN: 40, END: 35, ENTER: 13, ESCAPE: 27, HOME: 36, INSERT: 45, LEFT: 37, MENU: 93, NUMPAD_ADD: 107, NUMPAD_DECIMAL: 110, NUMPAD_DIVIDE: 111, NUMPAD_ENTER: 108, NUMPAD_MULTIPLY: 106, NUMPAD_SUBTRACT: 109, PAGE_DOWN: 34, PAGE_UP: 33, PERIOD: 190, RIGHT: 39, SHIFT: 16, SPACE: 32, TAB: 9, UP: 38, WINDOWS: 91}, silentScroll: function (d) {
            a.type(d) !== "number" && (d = a.mobile.defaultHomeScroll), a.event.special.scrollstart.enabled = !1, setTimeout(function () {
                b.scrollTo(0, d), a(c).trigger("silentscroll", {x: 0, y: d})
            }, 20), setTimeout(function () {
                a.event.special.scrollstart.enabled = !0
            }, 150)
        }, nsNormalizeDict: e, nsNormalize: function (b) {
            if (!b)return;
            return e[b] || (e[b] = a.camelCase(a.mobile.ns + b))
        }, getInheritedTheme: function (a, b) {
            var c = a[0], d = "", e = /ui-(bar|body|overlay)-([a-z])\b/, f, g;
            while (c) {
                f = c.className || "";
                if (f && (g = e.exec(f)) && (d = g[2]))break;
                c = c.parentNode
            }
            return d || b || "a"
        }, closestPageData: function (a) {
            return a.closest(':jqmData(role="page"), :jqmData(role="dialog")').data("page")
        }, enhanceable: function (a) {
            return this.haveParents(a, "enhance")
        }, hijackable: function (a) {
            return this.haveParents(a, "ajax")
        }, haveParents: function (b, c) {
            if (!a.mobile.ignoreContentEnabled)return b;
            var d = b.length, e = a(), f, g, h;
            for (var i = 0; i < d; i++) {
                g = b.eq(i), h = !1, f = b[i];
                while (f) {
                    var j = f.getAttribute ? f.getAttribute("data-" + a.mobile.ns + c) : "";
                    if (j === "false") {
                        h = !0;
                        break
                    }
                    f = f.parentNode
                }
                h || (e = e.add(g))
            }
            return e
        }, getScreenHeight: function () {
            return b.innerHeight || a(b).height()
        }}, a.mobile), a.fn.jqmData = function (b, c) {
            var e;
            return typeof b != "undefined" && (b && (b = a.mobile.nsNormalize(b)), arguments.length < 2 || c === d ? e = this.data(b) : e = this.data(b, c)), e
        }, a.jqmData = function (b, c, d) {
            var e;
            return typeof c != "undefined" && (e = a.data(b, c ? a.mobile.nsNormalize(c) : c, d)), e
        }, a.fn.jqmRemoveData = function (b) {
            return this.removeData(a.mobile.nsNormalize(b))
        }, a.jqmRemoveData = function (b, c) {
            return a.removeData(b, a.mobile.nsNormalize(c))
        }, a.fn.removeWithDependents = function () {
            a.removeWithDependents(this)
        }, a.removeWithDependents = function (b) {
            var c = a(b);
            (c.jqmData("dependents") || a()).remove(), c.remove()
        }, a.fn.addDependents = function (b) {
            a.addDependents(a(this), b)
        }, a.addDependents = function (b, c) {
            var d = a(b).jqmData("dependents") || a();
            a(b).jqmData("dependents", a.merge(d, c))
        }, a.fn.getEncodedText = function () {
            return a("<div/>").text(a(this).text()).html()
        }, a.fn.jqmEnhanceable = function () {
            return a.mobile.enhanceable(this)
        }, a.fn.jqmHijackable = function () {
            return a.mobile.hijackable(this)
        };
        var f = a.find, g = /:jqmData\(([^)]*)\)/g;
        a.find = function (b, c, d, e) {
            return b = b.replace(g, "[data-" + (a.mobile.ns || "") + "$1]"), f.call(this, b, c, d, e)
        }, a.extend(a.find, f), a.find.matches = function (b, c) {
            return a.find(b, null, null, c)
        }, a.find.matchesSelector = function (b, c) {
            return a.find(c, null, null, [b]).length > 0
        }
    })(a, this), function (a, b) {
        var c = 0, d = Array.prototype.slice, e = a.cleanData;
        a.cleanData = function (b) {
            for (var c = 0, d; (d = b[c]) != null; c++)try {
                a(d).triggerHandler("remove")
            } catch (f) {
            }
            e(b)
        }, a.widget = function (b, c, d) {
            var e, f, g, h, i = b.split(".")[0];
            b = b.split(".")[1], e = i + "-" + b, d || (d = c, c = a.Widget), a.expr[":"][e] = function (b) {
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
            }), g.prototype = a.widget.extend(h, {widgetEventPrefix: b}, d, {constructor: g, namespace: i, widgetName: b, widgetBaseClass: e, widgetFullName: e}), f ? (a.each(f._childConstructors, function (b, c) {
                var d = c.prototype;
                a.widget(d.namespace + "." + d.widgetName, g, c._proto)
            }), delete f._childConstructors) : c._childConstructors.push(g), a.widget.bridge(b, g)
        }, a.widget.extend = function (c) {
            var e = d.call(arguments, 1), f = 0, g = e.length, h, i;
            for (; f < g; f++)for (h in e[f])i = e[f][h], e[f].hasOwnProperty(h) && i !== b && (c[h] = a.isPlainObject(i) ? a.widget.extend({}, c[h], i) : i);
            return c
        }, a.widget.bridge = function (c, e) {
            var f = e.prototype.widgetFullName;
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
                    b ? b.option(g || {})._init() : new e(g, this)
                }), j
            }
        }, a.Widget = function (a, b) {
        }, a.Widget._childConstructors = [], a.Widget.prototype = {widgetName: "widget", widgetEventPrefix: "", defaultElement: "<div>", options: {disabled: !1, create: null}, _createWidget: function (b, d) {
            d = a(d || this.defaultElement || this)[0], this.element = a(d), this.uuid = c++, this.eventNamespace = "." + this.widgetName + this.uuid, this.options = a.widget.extend({}, this.options, this._getCreateOptions(), b), this.bindings = a(), this.hoverable = a(), this.focusable = a(), d !== this && (a.data(d, this.widgetName, this), a.data(d, this.widgetFullName, this), this._on({remove: "destroy"}), this.document = a(d.style ? d.ownerDocument : d.document || d), this.window = a(this.document[0].defaultView || this.document[0].parentWindow)), this._create(), this._trigger("create", null, this._getCreateEventData()), this._init()
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
        }, _on: function (b, c) {
            c ? (b = a(b), this.bindings = this.bindings.add(b)) : (c = b, b = this.element);
            var d = this;
            a.each(c, function (c, e) {
                function f() {
                    if (d.options.disabled === !0 || a(this).hasClass("ui-state-disabled"))return;
                    return(typeof e == "string" ? d[e] : e).apply(d, arguments)
                }

                typeof e != "string" && (f.guid = e.guid = e.guid || f.guid || a.guid++);
                var g = c.match(/^(\w+)\s*(.*)$/), h = g[1] + d.eventNamespace, i = g[2];
                i ? d.widget().delegate(i, h, f) : b.bind(h, f)
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
    }(a), function (a, b) {
        a.widget("mobile.widget", {_createWidget: function () {
            a.Widget.prototype._createWidget.apply(this, arguments), this._trigger("init")
        }, _getCreateOptions: function () {
            var c = this.element, d = {};
            return a.each(this.options, function (a) {
                var e = c.jqmData(a.replace(/[A-Z]/g, function (a) {
                    return"-" + a.toLowerCase()
                }));
                e !== b && (d[a] = e)
            }), d
        }, enhanceWithin: function (b, c) {
            this.enhance(a(this.options.initSelector, a(b)), c)
        }, enhance: function (b, c) {
            var d, e, f = a(b), g = this;
            f = a.mobile.enhanceable(f), c && f.length && (d = a.mobile.closestPageData(f), e = d && d.keepNativeSelector() || "", f = f.not(e)), f[this.widgetName]()
        }, raise: function (a) {
            throw"Widget [" + this.widgetName + "]: " + a
        }})
    }(a), function (a, b) {
        a.extend(a.mobile, {loadingMessageTextVisible: d, loadingMessageTheme: d, loadingMessage: d, showPageLoadingMsg: function (b, c, d) {
            a.mobile.loading("show", b, c, d)
        }, hidePageLoadingMsg: function () {
            a.mobile.loading("hide")
        }, loading: function () {
            this.loaderWidget.loader.apply(this.loaderWidget, arguments)
        }});
        var c = "ui-loader", e = a("html"), f = a(b);
        a.widget("mobile.loader", {options: {theme: "a", textVisible: !1, html: "", text: "loading"}, defaultHtml: "<div class='" + c + "'>" + "<span class='ui-icon ui-icon-loading'></span>" + "<h1></h1>" + "</div>", fakeFixLoader: function () {
            var b = a("." + a.mobile.activeBtnClass).first();
            this.element.css({top: a.support.scrollTop && f.scrollTop() + f.height() / 2 || b.length && b.offset().top || 100})
        }, checkLoaderPosition: function () {
            var b = this.element.offset(), c = f.scrollTop(), d = a.mobile.getScreenHeight();
            if (b.top < c || b.top - c > d)this.element.addClass("ui-loader-fakefix"), this.fakeFixLoader(), f.unbind("scroll", this.checkLoaderPosition).bind("scroll", this.fakeFixLoader)
        }, resetHtml: function () {
            this.element.html(a(this.defaultHtml).html())
        }, show: function (b, g, h) {
            var i, j, k, l;
            this.resetHtml(), a.type(b) === "object" ? (l = a.extend({}, this.options, b), b = l.theme || a.mobile.loadingMessageTheme) : (l = this.options, b = b || a.mobile.loadingMessageTheme || l.theme), j = g || a.mobile.loadingMessage || l.text, e.addClass("ui-loading");
            if (a.mobile.loadingMessage !== !1 || l.html)a.mobile.loadingMessageTextVisible !== d ? i = a.mobile.loadingMessageTextVisible : i = l.textVisible, this.element.attr("class", c + " ui-corner-all ui-body-" + b + " ui-loader-" + (i || g || b.text ? "verbose" : "default") + (l.textonly || h ? " ui-loader-textonly" : "")), l.html ? this.element.html(l.html) : this.element.find("h1").text(j), this.element.appendTo(a.mobile.pageContainer), this.checkLoaderPosition(), f.bind("scroll", a.proxy(this.checkLoaderPosition, this))
        }, hide: function () {
            e.removeClass("ui-loading"), a.mobile.loadingMessage && this.element.removeClass("ui-loader-fakefix"), a(b).unbind("scroll", a.proxy(this.fakeFixLoader, this)), a(b).unbind("scroll", a.proxy(this.checkLoaderPosition, this))
        }}), f.bind("pagecontainercreate", function () {
            a.mobile.loaderWidget = a.mobile.loaderWidget || a(a.mobile.loader.prototype.defaultHtml).loader()
        })
    }(a, this), function (a, b, c, d) {
        function x(a) {
            while (a && typeof a.originalEvent != "undefined")a = a.originalEvent;
            return a
        }

        function y(b, c) {
            var e = b.type, f, g, i, k, l, m, n, o, p;
            b = a.Event(b), b.type = c, f = b.originalEvent, g = a.event.props, e.search(/^(mouse|click)/) > -1 && (g = j);
            if (f)for (n = g.length, k; n;)k = g[--n], b[k] = f[k];
            e.search(/mouse(down|up)|click/) > -1 && !b.which && (b.which = 1);
            if (e.search(/^touch/) !== -1) {
                i = x(f), e = i.touches, l = i.changedTouches, m = e && e.length ? e[0] : l && l.length ? l[0] : d;
                if (m)for (o = 0, p = h.length; o < p; o++)k = h[o], b[k] = m[k]
            }
            return b
        }

        function z(b) {
            var c = {}, d, f;
            while (b) {
                d = a.data(b, e);
                for (f in d)d[f] && (c[f] = c.hasVirtualBinding = !0);
                b = b.parentNode
            }
            return c
        }

        function A(b, c) {
            var d;
            while (b) {
                d = a.data(b, e);
                if (d && (!c || d[c]))return b;
                b = b.parentNode
            }
            return null
        }

        function B() {
            r = !1
        }

        function C() {
            r = !0
        }

        function D() {
            v = 0, p.length = 0, q = !1, C()
        }

        function E() {
            B()
        }

        function F() {
            G(), l = setTimeout(function () {
                l = 0, D()
            }, a.vmouse.resetTimerDuration)
        }

        function G() {
            l && (clearTimeout(l), l = 0)
        }

        function H(b, c, d) {
            var e;
            if (d && d[b] || !d && A(c.target, b))e = y(c, b), a(c.target).trigger(e);
            return e
        }

        function I(b) {
            var c = a.data(b.target, f);
            if (!q && (!v || v !== c)) {
                var d = H("v" + b.type, b);
                d && (d.isDefaultPrevented() && b.preventDefault(), d.isPropagationStopped() && b.stopPropagation(), d.isImmediatePropagationStopped() && b.stopImmediatePropagation())
            }
        }

        function J(b) {
            var c = x(b).touches, d, e;
            if (c && c.length === 1) {
                d = b.target, e = z(d);
                if (e.hasVirtualBinding) {
                    v = u++, a.data(d, f, v), G(), E(), o = !1;
                    var g = x(b).touches[0];
                    m = g.pageX, n = g.pageY, H("vmouseover", b, e), H("vmousedown", b, e)
                }
            }
        }

        function K(a) {
            if (r)return;
            o || H("vmousecancel", a, z(a.target)), o = !0, F()
        }

        function L(b) {
            if (r)return;
            var c = x(b).touches[0], d = o, e = a.vmouse.moveDistanceThreshold, f = z(b.target);
            o = o || Math.abs(c.pageX - m) > e || Math.abs(c.pageY - n) > e, o && !d && H("vmousecancel", b, f), H("vmousemove", b, f), F()
        }

        function M(a) {
            if (r)return;
            C();
            var b = z(a.target), c;
            H("vmouseup", a, b);
            if (!o) {
                var d = H("vclick", a, b);
                d && d.isDefaultPrevented() && (c = x(a).changedTouches[0], p.push({touchID: v, x: c.clientX, y: c.clientY}), q = !0)
            }
            H("vmouseout", a, b), o = !1, F()
        }

        function N(b) {
            var c = a.data(b, e), d;
            if (c)for (d in c)if (c[d])return!0;
            return!1
        }

        function O() {
        }

        function P(b) {
            var c = b.substr(1);
            return{setup: function (d, f) {
                N(this) || a.data(this, e, {});
                var g = a.data(this, e);
                g[b] = !0, k[b] = (k[b] || 0) + 1, k[b] === 1 && t.bind(c, I), a(this).bind(c, O), s && (k.touchstart = (k.touchstart || 0) + 1, k.touchstart === 1 && t.bind("touchstart", J).bind("touchend", M).bind("touchmove", L).bind("scroll", K))
            }, teardown: function (d, f) {
                --k[b], k[b] || t.unbind(c, I), s && (--k.touchstart, k.touchstart || t.unbind("touchstart", J).unbind("touchmove", L).unbind("touchend", M).unbind("scroll", K));
                var g = a(this), h = a.data(this, e);
                h && (h[b] = !1), g.unbind(c, O), N(this) || g.removeData(e)
            }}
        }

        var e = "virtualMouseBindings", f = "virtualTouchID", g = "vmouseover vmousedown vmousemove vmouseup vclick vmouseout vmousecancel".split(" "), h = "clientX clientY pageX pageY screenX screenY".split(" "), i = a.event.mouseHooks ? a.event.mouseHooks.props : [], j = a.event.props.concat(i), k = {}, l = 0, m = 0, n = 0, o = !1, p = [], q = !1, r = !1, s = "addEventListener"in c, t = a(c), u = 1, v = 0, w;
        a.vmouse = {moveDistanceThreshold: 10, clickDistanceThreshold: 10, resetTimerDuration: 1500};
        for (var Q = 0; Q < g.length; Q++)a.event.special[g[Q]] = P(g[Q]);
        s && c.addEventListener("click", function (b) {
            var c = p.length, d = b.target, e, g, h, i, j, k;
            if (c) {
                e = b.clientX, g = b.clientY, w = a.vmouse.clickDistanceThreshold, h = d;
                while (h) {
                    for (i = 0; i < c; i++) {
                        j = p[i], k = 0;
                        if (h === d && Math.abs(j.x - e) < w && Math.abs(j.y - g) < w || a.data(h, f) === j.touchID) {
                            b.preventDefault(), b.stopPropagation();
                            return
                        }
                    }
                    h = h.parentNode
                }
            }
        }, !0)
    }(a, b, c), function (a, b) {
        var d = {touch: "ontouchend"in c};
        a.mobile = a.mobile || {}, a.mobile.support = a.mobile.support || {}, a.extend(a.support, d), a.extend(a.mobile.support, d)
    }(a), function (a, b, d) {
        function j(b, c, d) {
            var e = d.type;
            d.type = c, a.event.handle.call(b, d), d.type = e
        }

        a.each("touchstart touchmove touchend tap taphold swipe swipeleft swiperight scrollstart scrollstop".split(" "), function (b, c) {
            a.fn[c] = function (a) {
                return a ? this.bind(c, a) : this.trigger(c)
            }, a.attrFn && (a.attrFn[c] = !0)
        });
        var e = a.mobile.support.touch, f = "touchmove scroll", g = e ? "touchstart" : "mousedown", h = e ? "touchend" : "mouseup", i = e ? "touchmove" : "mousemove";
        a.event.special.scrollstart = {enabled: !0, setup: function () {
            function g(a, c) {
                d = c, j(b, d ? "scrollstart" : "scrollstop", a)
            }

            var b = this, c = a(b), d, e;
            c.bind(f, function (b) {
                if (!a.event.special.scrollstart.enabled)return;
                d || g(b, !0), clearTimeout(e), e = setTimeout(function () {
                    g(b, !1)
                }, 50)
            })
        }}, a.event.special.tap = {tapholdThreshold: 750, setup: function () {
            var b = this, d = a(b);
            d.bind("vmousedown", function (e) {
                function i() {
                    clearTimeout(h)
                }

                function k() {
                    i(), d.unbind("vclick", l).unbind("vmouseup", i), a(c).unbind("vmousecancel", k)
                }

                function l(a) {
                    k(), f === a.target && j(b, "tap", a)
                }

                if (e.which && e.which !== 1)return!1;
                var f = e.target, g = e.originalEvent, h;
                d.bind("vmouseup", i).bind("vclick", l), a(c).bind("vmousecancel", k), h = setTimeout(function () {
                    j(b, "taphold", a.Event("taphold", {target: f}))
                }, a.event.special.tap.tapholdThreshold)
            })
        }}, a.event.special.swipe = {scrollSupressionThreshold: 30, durationThreshold: 1e3, horizontalDistanceThreshold: 30, verticalDistanceThreshold: 75, setup: function () {
            var b = this, c = a(b);
            c.bind(g, function (b) {
                function j(b) {
                    if (!f)return;
                    var c = b.originalEvent.touches ? b.originalEvent.touches[0] : b;
                    g = {time: (new Date).getTime(), coords: [c.pageX, c.pageY]}, Math.abs(f.coords[0] - g.coords[0]) > a.event.special.swipe.scrollSupressionThreshold && b.preventDefault()
                }

                var e = b.originalEvent.touches ? b.originalEvent.touches[0] : b, f = {time: (new Date).getTime(), coords: [e.pageX, e.pageY], origin: a(b.target)}, g;
                c.bind(i, j).one(h, function (b) {
                    c.unbind(i, j), f && g && g.time - f.time < a.event.special.swipe.durationThreshold && Math.abs(f.coords[0] - g.coords[0]) > a.event.special.swipe.horizontalDistanceThreshold && Math.abs(f.coords[1] - g.coords[1]) < a.event.special.swipe.verticalDistanceThreshold && f.origin.trigger("swipe").trigger(f.coords[0] > g.coords[0] ? "swipeleft" : "swiperight"), f = g = d
                })
            })
        }}, a.each({scrollstop: "scrollstart", taphold: "tap", swipeleft: "swipe", swiperight: "swipe"}, function (b, c) {
            a.event.special[b] = {setup: function () {
                a(this).bind(c, a.noop)
            }}
        })
    }(a, this), function (a, c) {
        a.extend(a.support, {orientation: "orientation"in b && "onorientationchange"in b})
    }(a), function (a) {
        a.event.special.throttledresize = {setup: function () {
            a(this).bind("resize", c)
        }, teardown: function () {
            a(this).unbind("resize", c)
        }};
        var b = 250, c = function () {
            f = (new Date).getTime(), g = f - d, g >= b ? (d = f, a(this).trigger("throttledresize")) : (e && clearTimeout(e), e = setTimeout(c, b - g))
        }, d = 0, e, f, g
    }(a), function (a, b) {
        function o() {
            var a = g();
            a !== h && (h = a, d.trigger(e))
        }

        var d = a(b), e = "orientationchange", f, g, h, i, j, k = {0: !0, 180: !0};
        if (a.support.orientation) {
            var l = b.innerWidth || a(b).width(), m = b.innerHeight || a(b).height(), n = 50;
            i = l > m && l - m > n, j = k[b.orientation];
            if (i && j || !i && !j)k = {"-90": !0, 90: !0}
        }
        a.event.special.orientationchange = a.extend({}, a.event.special.orientationchange, {setup: function () {
            if (a.support.orientation && !a.event.special.orientationchange.disabled)return!1;
            h = g(), d.bind("throttledresize", o)
        }, teardown: function () {
            if (a.support.orientation && !a.event.special.orientationchange.disabled)return!1;
            d.unbind("throttledresize", o)
        }, add: function (a) {
            var b = a.handler;
            a.handler = function (a) {
                return a.orientation = g(), b.apply(this, arguments)
            }
        }}), a.event.special.orientationchange.orientation = g = function () {
            var d = !0, e = c.documentElement;
            return a.support.orientation ? d = k[b.orientation] : d = e && e.clientWidth / e.clientHeight < 1.1, d ? "portrait" : "landscape"
        }, a.fn[e] = function (a) {
            return a ? this.bind(e, a) : this.trigger(e)
        }, a.attrFn && (a.attrFn[e] = !0)
    }(a, this), function (a, d) {
        var e = a(b), f = a("html");
        a.mobile.media = function () {
            var b = {}, d = a("<div id='jquery-mediatest'></div>"), e = a("<body>").append(d);
            return function (a) {
                if (!(a in b)) {
                    var g = c.createElement("style"), h = "@media " + a + " { #jquery-mediatest { position:absolute; } }";
                    g.type = "text/css", g.styleSheet ? g.styleSheet.cssText = h : g.appendChild(c.createTextNode(h)), f.prepend(e).prepend(g), b[a] = d.css("position") === "absolute", e.add(g).remove()
                }
                return b[a]
            }
        }()
    }(a), function (a, d) {
        function e(a) {
            var b = a.charAt(0).toUpperCase() + a.substr(1), c = (a + " " + h.join(b + " ") + b).split(" ");
            for (var e in c)if (g[c[e]] !== d)return!0
        }

        function m(a, b, d) {
            var e = c.createElement("div"), f = function (a) {
                return a.charAt(0).toUpperCase() + a.substr(1)
            }, g = function (a) {
                return"-" + a.charAt(0).toLowerCase() + a.substr(1) + "-"
            }, i = function (c) {
                var d = g(c) + a + ": " + b + ";", h = f(c), i = h + f(a);
                e.setAttribute("style", d), !e.style[i] || (k = !0)
            }, j = d ? [d] : h, k;
            for (var l = 0; l < j.length; l++)i(j[l]);
            return!!k
        }

        function n() {
            var b = "transform-3d";
            return m("perspective", "10px", "moz") || a.mobile.media("(-" + h.join("-" + b + "),(-") + "-" + b + "),(" + b + ")")
        }

        function o() {
            var b = location.protocol + "//" + location.host + location.pathname + "ui-dir/", c = a("head base"), d = null, e = "", g, h;
            return c.length ? e = c.attr("href") : c = d = a("<base>", {href: b}).appendTo("head"), g = a("<a href='testurl' />").prependTo(f), h = g[0].href, c[0].href = e || location.pathname, d && d.remove(), h.indexOf(b) === 0
        }

        function p() {
            var a = c.createElement("x"), d = c.documentElement, e = b.getComputedStyle, f;
            return"pointerEvents"in a.style ? (a.style.pointerEvents = "auto", a.style.pointerEvents = "x", d.appendChild(a), f = e && e(a, "").pointerEvents === "auto", d.removeChild(a), !!f) : !1
        }

        function q() {
            var a = c.createElement("div");
            return typeof a.getBoundingClientRect != "undefined"
        }

        var f = a("<body>").prependTo("html"), g = f[0].style, h = ["Webkit", "Moz", "O"], i = "palmGetResource"in b, j = b.opera, k = b.operamini && {}.toString.call(b.operamini) === "[object OperaMini]", l = b.blackberry && !e("-webkit-transform");
        a.extend(a.mobile, {browser: {}}), a.mobile.browser.ie = function () {
            var a = 3, b = c.createElement("div"), d = b.all || [];
            do b.innerHTML = "<!--[if gt IE " + ++a + "]><br><![endif]-->"; while (d[0]);
            return a > 4 ? a : !a
        }(), a.extend(a.support, {cssTransitions: "WebKitTransitionEvent"in b || m("transition", "height 100ms linear") && !j, pushState: "pushState"in history && "replaceState"in history, mediaquery: a.mobile.media("only all"), cssPseudoElement: !!e("content"), touchOverflow: !!e("overflowScrolling"), cssTransform3d: n(), boxShadow: !!e("boxShadow") && !l, scrollTop: ("pageXOffset"in b || "scrollTop"in c.documentElement || "scrollTop"in f[0]) && !i && !k, dynamicBaseTag: o(), cssPointerEvents: p(), boundingRect: q()}), f.remove();
        var r = function () {
            var a = b.navigator.userAgent;
            return a.indexOf("Nokia") > -1 && (a.indexOf("Symbian/3") > -1 || a.indexOf("Series60/5") > -1) && a.indexOf("AppleWebKit") > -1 && a.match(/(BrowserNG|NokiaBrowser)\/7\.[0-3]/)
        }();
        a.mobile.gradeA = function () {
            return(a.support.mediaquery || a.mobile.browser.ie && a.mobile.browser.ie >= 7) && (a.support.boundingRect || a.fn.jquery.match(/1\.[0-7+]\.[0-9+]?/) !== null)
        }, a.mobile.ajaxBlacklist = b.blackberry && !b.WebKitPoint || k || r, r && a(function () {
            a("head link[rel='stylesheet']").attr("rel", "alternate stylesheet").attr("rel", "stylesheet")
        }), a.support.boxShadow || a("html").addClass("ui-mobile-nosupport-boxshadow")
    }(a), function (a, b) {
        a.widget("mobile.page", a.mobile.widget, {options: {theme: "c", domCache: !1, keepNativeDefault: ":jqmData(role='none'), :jqmData(role='nojs')"}, _create: function () {
            var a = this;
            if (a._trigger("beforecreate") === !1)return!1;
            a.element.attr("tabindex", "0").addClass("ui-page ui-body-" + a.options.theme).bind("pagebeforehide",function () {
                a.removeContainerBackground()
            }).bind("pagebeforeshow", function () {
                a.setContainerBackground()
            })
        }, removeContainerBackground: function () {
            a.mobile.pageContainer.removeClass("ui-overlay-" + a.mobile.getInheritedTheme(this.element.parent()))
        }, setContainerBackground: function (b) {
            this.options.theme && a.mobile.pageContainer.addClass("ui-overlay-" + (b || this.options.theme))
        }, keepNativeSelector: function () {
            var b = this.options, c = b.keepNative && a.trim(b.keepNative);
            return c && b.keepNative !== b.keepNativeDefault ? [b.keepNative, b.keepNativeDefault].join(", ") : b.keepNativeDefault
        }})
    }(a), function (a, b, d) {
        function k(a) {
            return a = a || location.href, "#" + a.replace(/^[^#]*#?(.*)$/, "$1")
        }

        var e = "hashchange", f = c, g, h = a.event.special, i = f.documentMode, j = "on" + e in b && (i === d || i > 7);
        a.fn[e] = function (a) {
            return a ? this.bind(e, a) : this.trigger(e)
        }, a.fn[e].delay = 50, h[e] = a.extend(h[e], {setup: function () {
            if (j)return!1;
            a(g.start)
        }, teardown: function () {
            if (j)return!1;
            a(g.stop)
        }}), g = function () {
            function n() {
                var c = k(), d = m(h);
                c !== h ? (l(h = c, d), a(b).trigger(e)) : d !== h && (location.href = location.href.replace(/#.*/, "") + d), g = setTimeout(n, a.fn[e].delay)
            }

            var c = {}, g, h = k(), i = function (a) {
                return a
            }, l = i, m = i;
            return c.start = function () {
                g || n()
            }, c.stop = function () {
                g && clearTimeout(g), g = d
            }, a.browser.msie && !j && function () {
                var b, d;
                c.start = function () {
                    b || (d = a.fn[e].src, d = d && d + k(), b = a('<iframe tabindex="-1" title="empty"/>').hide().one("load",function () {
                        d || l(k()), n()
                    }).attr("src", d || "javascript:0").insertAfter("body")[0].contentWindow, f.onpropertychange = function () {
                        try {
                            event.propertyName === "title" && (b.document.title = f.title)
                        } catch (a) {
                        }
                    })
                }, c.stop = i, m = function () {
                    return k(b.location.href)
                }, l = function (c, d) {
                    var g = b.document, h = a.fn[e].domain;
                    c !== d && (g.title = f.title, g.open(), h && g.write('<script>document.domain="' + h + '"</script>'), g.close(), b.location.hash = c)
                }
            }(), c
        }()
    }(a, this), function (a, b, c) {
        var d = function (d) {
            return d === c && (d = !0), function (c, e, f, g) {
                var h = new a.Deferred, i = e ? " reverse" : "", j = a.mobile.urlHistory.getActive(), k = j.lastScroll || a.mobile.defaultHomeScroll, l = a.mobile.getScreenHeight(), m = a.mobile.maxTransitionWidth !== !1 && a(b).width() > a.mobile.maxTransitionWidth, n = !a.support.cssTransitions || m || !c || c === "none" || Math.max(a(b).scrollTop(), k) > a.mobile.getMaxScrollForTransition(), o = " ui-page-pre-in", p = function () {
                    a.mobile.pageContainer.toggleClass("ui-mobile-viewport-transitioning viewport-" + c)
                }, q = function () {
                    a.event.special.scrollstart.enabled = !1, b.scrollTo(0, k), setTimeout(function () {
                        a.event.special.scrollstart.enabled = !0
                    }, 150)
                }, r = function () {
                    g.removeClass(a.mobile.activePageClass + " out in reverse " + c).height("")
                }, s = function () {
                    d ? g.animationComplete(t) : t(), g.height(l + a(b).scrollTop()).addClass(c + " out" + i)
                }, t = function () {
                    g && d && r(), u()
                }, u = function () {
                    f.css("z-index", -10), f.addClass(a.mobile.activePageClass + o), a.mobile.focusPage(f), f.height(l + k), q(), f.css("z-index", ""), n || f.animationComplete(v), f.removeClass(o).addClass(c + " in" + i), n && v()
                }, v = function () {
                    d || g && r(), f.removeClass("out in reverse " + c).height(""), p(), a(b).scrollTop() !== k && q(), h.resolve(c, e, f, g, !0)
                };
                return p(), g && !n ? s() : t(), h.promise()
            }
        }, e = d(), f = d(!1), g = function () {
            return a.mobile.getScreenHeight() * 3
        };
        a.mobile.defaultTransitionHandler = e, a.mobile.transitionHandlers = {"default": a.mobile.defaultTransitionHandler, sequential: e, simultaneous: f}, a.mobile.transitionFallbacks = {}, a.mobile._maybeDegradeTransition = function (b) {
            return b && !a.support.cssTransform3d && a.mobile.transitionFallbacks[b] && (b = a.mobile.transitionFallbacks[b]), b
        }, a.mobile.getMaxScrollForTransition = a.mobile.getMaxScrollForTransition || g
    }(a, this), function (a, d) {
        function u(b) {
            !!i && (!i.closest("." + a.mobile.activePageClass).length || b) && i.removeClass(a.mobile.activeBtnClass), i = null
        }

        function v() {
            m = !1, l.length > 0 && a.mobile.changePage.apply(null, l.pop())
        }

        function z(b, c, d, e) {
            c && c.data("page")._trigger("beforehide", null, {nextPage: b}), b.data("page")._trigger("beforeshow", null, {prevPage: c || a("")}), a.mobile.hidePageLoadingMsg(), d = a.mobile._maybeDegradeTransition(d);
            var f = a.mobile.transitionHandlers[d || "default"] || a.mobile.defaultTransitionHandler, g = f(d, e, b, c);
            return g.done(function () {
                c && c.data("page")._trigger("hide", null, {nextPage: b}), b.data("page")._trigger("show", null, {prevPage: c || a("")})
            }), g
        }

        function A() {
            var b = a("." + a.mobile.activePageClass), c = parseFloat(b.css("padding-top")), d = parseFloat(b.css("padding-bottom")), e = parseFloat(b.css("border-top-width")), f = parseFloat(b.css("border-bottom-width"));
            b.css("min-height", s() - c - d - e - f)
        }

        function B(b, c) {
            c && b.attr("data-" + a.mobile.ns + "role", c), b.page()
        }

        function C(a) {
            while (a) {
                if (typeof a.nodeName == "string" && a.nodeName.toLowerCase() === "a")break;
                a = a.parentNode
            }
            return a
        }

        function D(b) {
            var c = a(b).closest(".ui-page").jqmData("url"), d = q.hrefNoHash;
            if (!c || !h.isPath(c))c = d;
            return h.makeUrlAbsolute(c, d)
        }

        var e = a(b), f = a("html"), g = a("head"), h = {urlParseRE: /^(((([^:\/#\?]+:)?(?:(\/\/)((?:(([^:@\/#\?]+)(?:\:([^:@\/#\?]+))?)@)?(([^:\/#\?\]\[]+|\[[^\/\]@#?]+\])(?:\:([0-9]+))?))?)?)?((\/?(?:[^\/\?#]+\/+)*)([^\?#]*)))?(\?[^#]+)?)(#.*)?/, getLocation: function (a) {
            var b = a ? this.parseUrl(a) : location, c = this.parseUrl(a || location.href).hash;
            return c = c === "#" ? "" : c, b.protocol + "//" + b.host + b.pathname + b.search + c
        }, parseLocation: function () {
            return this.parseUrl(this.getLocation())
        }, parseUrl: function (b) {
            if (a.type(b) === "object")return b;
            var c = h.urlParseRE.exec(b || "") || [];
            return{href: c[0] || "", hrefNoHash: c[1] || "", hrefNoSearch: c[2] || "", domain: c[3] || "", protocol: c[4] || "", doubleSlash: c[5] || "", authority: c[6] || "", username: c[8] || "", password: c[9] || "", host: c[10] || "", hostname: c[11] || "", port: c[12] || "", pathname: c[13] || "", directory: c[14] || "", filename: c[15] || "", search: c[16] || "", hash: c[17] || ""}
        }, makePathAbsolute: function (a, b) {
            if (a && a.charAt(0) === "/")return a;
            a = a || "", b = b ? b.replace(/^\/|(\/[^\/]*|[^\/]+)$/g, "") : "";
            var c = b ? b.split("/") : [], d = a.split("/");
            for (var e = 0; e < d.length; e++) {
                var f = d[e];
                switch (f) {
                    case".":
                        break;
                    case"..":
                        c.length && c.pop();
                        break;
                    default:
                        c.push(f)
                }
            }
            return"/" + c.join("/")
        }, isSameDomain: function (a, b) {
            return h.parseUrl(a).domain === h.parseUrl(b).domain
        }, isRelativeUrl: function (a) {
            return h.parseUrl(a).protocol === ""
        }, isAbsoluteUrl: function (a) {
            return h.parseUrl(a).protocol !== ""
        }, makeUrlAbsolute: function (a, b) {
            if (!h.isRelativeUrl(a))return a;
            b === d && (b = q);
            var c = h.parseUrl(a), e = h.parseUrl(b), f = c.protocol || e.protocol, g = c.protocol ? c.doubleSlash : c.doubleSlash || e.doubleSlash, i = c.authority || e.authority, j = c.pathname !== "", k = h.makePathAbsolute(c.pathname || e.filename, e.pathname), l = c.search || !j && e.search || "", m = c.hash;
            return f + g + i + k + l + m
        }, addSearchParams: function (b, c) {
            var d = h.parseUrl(b), e = typeof c == "object" ? a.param(c) : c, f = d.search || "?";
            return d.hrefNoSearch + f + (f.charAt(f.length - 1) !== "?" ? "&" : "") + e + (d.hash || "")
        }, convertUrlToDataUrl: function (a) {
            var c = h.parseUrl(a);
            return h.isEmbeddedPage(c) ? c.hash.split(n)[0].replace(/^#/, "") : h.isSameDomain(c, q) ? c.hrefNoHash.replace(q.domain, "").split(n)[0] : b.decodeURIComponent(a)
        }, get: function (a) {
            return a === d && (a = h.parseLocation().hash), h.stripHash(a).replace(/[^\/]*\.[^\/*]+$/, "")
        }, getFilePath: function (b) {
            var c = "&" + a.mobile.subPageUrlKey;
            return b && b.split(c)[0].split(n)[0]
        }, set: function (a) {
            location.hash = a
        }, isPath: function (a) {
            return/\//.test(a)
        }, clean: function (a) {
            return a.replace(q.domain, "")
        }, stripHash: function (a) {
            return a
                .replace(/^#/, "")
        }, cleanHash: function (a) {
            return h.stripHash(a.replace(/\?.*$/, "").replace(n, ""))
        }, isHashValid: function (a) {
            return/^#[^#]+$/.test(a)
        }, isExternal: function (a) {
            var b = h.parseUrl(a);
            return b.protocol && b.domain !== p.domain ? !0 : !1
        }, hasProtocol: function (a) {
            return/^(:?\w+:)/.test(a)
        }, isFirstPageUrl: function (b) {
            var c = h.parseUrl(h.makeUrlAbsolute(b, q)), e = c.hrefNoHash === p.hrefNoHash || r && c.hrefNoHash === q.hrefNoHash, f = a.mobile.firstPage, g = f && f[0] ? f[0].id : d;
            return e && (!c.hash || c.hash === "#" || g && c.hash.replace(/^#/, "") === g)
        }, isEmbeddedPage: function (a) {
            var b = h.parseUrl(a);
            return b.protocol !== "" ? b.hash && (b.hrefNoHash === p.hrefNoHash || r && b.hrefNoHash === q.hrefNoHash) : /^#/.test(b.href)
        }, isPermittedCrossDomainRequest: function (b, c) {
            return a.mobile.allowCrossDomainPages && b.protocol === "file:" && c.search(/^https?:/) !== -1
        }}, i = null, j = {stack: [], activeIndex: 0, getActive: function () {
            return j.stack[j.activeIndex]
        }, getPrev: function () {
            return j.stack[j.activeIndex - 1]
        }, getNext: function () {
            return j.stack[j.activeIndex + 1]
        }, addNew: function (a, b, c, d, e) {
            j.getNext() && j.clearForward(), j.stack.push({url: a, transition: b, title: c, pageUrl: d, role: e}), j.activeIndex = j.stack.length - 1
        }, clearForward: function () {
            j.stack = j.stack.slice(0, j.activeIndex + 1)
        }, directHashChange: function (b) {
            var c, e, f, g = this.getActive();
            a.each(j.stack, function (a, d) {
                decodeURIComponent(b.currentUrl) === decodeURIComponent(d.url) && (c = a < j.activeIndex, e = !c, f = a)
            }), this.activeIndex = f !== d ? f : this.activeIndex, c ? (b.either || b.isBack)(!0) : e && (b.either || b.isForward)(!1)
        }, ignoreNextHashChange: !1}, k = "[tabindex],a,button:visible,select:visible,input", l = [], m = !1, n = "&ui-state=dialog", o = g.children("base"), p = h.parseLocation(), q = o.length ? h.parseUrl(h.makeUrlAbsolute(o.attr("href"), p.href)) : p, r = p.hrefNoHash !== q.hrefNoHash, s = a.mobile.getScreenHeight, t = a.support.dynamicBaseTag ? {element: o.length ? o : a("<base>", {href: q.hrefNoHash}).prependTo(g), set: function (a) {
            t.element.attr("href", h.makeUrlAbsolute(a, q))
        }, reset: function () {
            t.element.attr("href", q.hrefNoHash)
        }} : d;
        a.mobile.back = function () {
            var a = b.navigator;
            this.phonegapNavigationEnabled && a && a.app && a.app.backHistory ? a.app.backHistory() : b.history.back()
        }, a.mobile.focusPage = function (a) {
            var b = a.find("[autofocus]"), c = a.find(".ui-title:eq(0)");
            if (b.length) {
                b.focus();
                return
            }
            c.length ? c.focus() : a.focus()
        };
        var w = !0, x, y;
        x = function () {
            if (!w)return;
            var b = a.mobile.urlHistory.getActive();
            if (b) {
                var c = e.scrollTop();
                b.lastScroll = c < a.mobile.minScrollBack ? a.mobile.defaultHomeScroll : c
            }
        }, y = function () {
            setTimeout(x, 100)
        }, e.bind(a.support.pushState ? "popstate" : "hashchange", function () {
            w = !1
        }), e.one(a.support.pushState ? "popstate" : "hashchange", function () {
            w = !0
        }), e.one("pagecontainercreate", function () {
            a.mobile.pageContainer.bind("pagechange", function () {
                w = !0, e.unbind("scrollstop", y), e.bind("scrollstop", y)
            })
        }), e.bind("scrollstop", y), a.mobile._maybeDegradeTransition = a.mobile._maybeDegradeTransition || function (a) {
            return a
        }, a.fn.animationComplete = function (b) {
            return a.support.cssTransitions ? a(this).one("webkitAnimationEnd animationend", b) : (setTimeout(b, 0), a(this))
        }, a.mobile.path = h, a.mobile.base = t, a.mobile.urlHistory = j, a.mobile.dialogHashKey = n, a.mobile.allowCrossDomainPages = !1, a.mobile.getDocumentUrl = function (b) {
            return b ? a.extend({}, p) : p.href
        }, a.mobile.getDocumentBase = function (b) {
            return b ? a.extend({}, q) : q.href
        }, a.mobile._bindPageRemove = function () {
            var b = a(this);
            !b.data("page").options.domCache && b.is(":jqmData(external-page='true')") && b.bind("pagehide.remove", function () {
                var b = a(this), c = new a.Event("pageremove");
                b.trigger(c), c.isDefaultPrevented() || b.removeWithDependents()
            })
        }, a.mobile.loadPage = function (b, c) {
            var e = a.Deferred(), f = a.extend({}, a.mobile.loadPage.defaults, c), g = null, i = null, j = function () {
                var b = a.mobile.activePage && D(a.mobile.activePage);
                return b || q.hrefNoHash
            }, k = h.makeUrlAbsolute(b, j());
            f.data && f.type === "get" && (k = h.addSearchParams(k, f.data), f.data = d), f.data && f.type === "post" && (f.reloadPage = !0);
            var l = h.getFilePath(k), m = h.convertUrlToDataUrl(k);
            f.pageContainer = f.pageContainer || a.mobile.pageContainer, g = f.pageContainer.children("[data-" + a.mobile.ns + "url='" + m + "']"), g.length === 0 && m && !h.isPath(m) && (g = f.pageContainer.children("#" + m).attr("data-" + a.mobile.ns + "url", m).jqmData("url", m));
            if (g.length === 0)if (a.mobile.firstPage && h.isFirstPageUrl(l))a.mobile.firstPage.parent().length && (g = a(a.mobile.firstPage)); else if (h.isEmbeddedPage(l))return e.reject(k, c), e.promise();
            if (g.length) {
                if (!f.reloadPage)return B(g, f.role), e.resolve(k, c, g), e.promise();
                i = g
            }
            var n = f.pageContainer, o = new a.Event("pagebeforeload"), r = {url: b, absUrl: k, dataUrl: m, deferred: e, options: f};
            n.trigger(o, r);
            if (o.isDefaultPrevented())return e.promise();
            if (f.showLoadMsg)var s = setTimeout(function () {
                a.mobile.showPageLoadingMsg()
            }, f.loadMsgDelay), u = function () {
                clearTimeout(s), a.mobile.hidePageLoadingMsg()
            };
            return t && t.reset(), !a.mobile.allowCrossDomainPages && !h.isSameDomain(p, k) ? e.reject(k, c) : a.ajax({url: l, type: f.type, data: f.data, dataType: "html", success: function (d, j, n) {
                var o = a("<div></div>"), p = d.match(/<title[^>]*>([^<]*)/) && RegExp.$1, q = new RegExp("(<[^>]+\\bdata-" + a.mobile.ns + "role=[\"']?page[\"']?[^>]*>)"), s = new RegExp("\\bdata-" + a.mobile.ns + "url=[\"']?([^\"'>]*)[\"']?");
                q.test(d) && RegExp.$1 && s.test(RegExp.$1) && RegExp.$1 && (b = l = h.getFilePath(a("<div>" + RegExp.$1 + "</div>").text())), t && t.set(l), o.get(0).innerHTML = d, g = o.find(":jqmData(role='page'), :jqmData(role='dialog')").first(), g.length || (g = a("<div data-" + a.mobile.ns + "role='page'>" + d.split(/<\/?body[^>]*>/gmi)[1] + "</div>")), p && !g.jqmData("title") && (~p.indexOf("&") && (p = a("<div>" + p + "</div>").text()), g.jqmData("title", p));
                if (!a.support.dynamicBaseTag) {
                    var v = h.get(l);
                    g.find("[src], link[href], a[rel='external'], :jqmData(ajax='false'), a[target]").each(function () {
                        var b = a(this).is("[href]") ? "href" : a(this).is("[src]") ? "src" : "action", c = a(this).attr(b);
                        c = c.replace(location.protocol + "//" + location.host + location.pathname, ""), /^(\w+:|#|\/)/.test(c) || a(this).attr(b, v + c)
                    })
                }
                g.attr("data-" + a.mobile.ns + "url", h.convertUrlToDataUrl(l)).attr("data-" + a.mobile.ns + "external-page", !0).appendTo(f.pageContainer), g.one("pagecreate", a.mobile._bindPageRemove), B(g, f.role), k.indexOf("&" + a.mobile.subPageUrlKey) > -1 && (g = f.pageContainer.children("[data-" + a.mobile.ns + "url='" + m + "']")), f.showLoadMsg && u(), r.xhr = n, r.textStatus = j, r.page = g, f.pageContainer.trigger("pageload", r), e.resolve(k, c, g, i)
            }, error: function (b, d, g) {
                t && t.set(h.get()), r.xhr = b, r.textStatus = d, r.errorThrown = g;
                var i = new a.Event("pageloadfailed");
                f.pageContainer.trigger(i, r);
                if (i.isDefaultPrevented())return;
                f.showLoadMsg && (u(), a.mobile.showPageLoadingMsg(a.mobile.pageLoadErrorMessageTheme, a.mobile.pageLoadErrorMessage, !0), setTimeout(a.mobile.hidePageLoadingMsg, 1500)), e.reject(k, c)
            }}), e.promise()
        }, a.mobile.loadPage.defaults = {type: "get", data: d, reloadPage: !1, role: d, showLoadMsg: !1, pageContainer: d, loadMsgDelay: 50}, a.mobile.changePage = function (b, e) {
            if (m) {
                l.unshift(arguments);
                return
            }
            var f = a.extend({}, a.mobile.changePage.defaults, e);
            f.pageContainer = f.pageContainer || a.mobile.pageContainer, f.fromPage = f.fromPage || a.mobile.activePage;
            var g = f.pageContainer, i = new a.Event("pagebeforechange"), k = {toPage: b, options: f};
            g.trigger(i, k);
            if (i.isDefaultPrevented())return;
            b = k.toPage, m = !0;
            if (typeof b == "string") {
                a.mobile.loadPage(b, f).done(function (b, c, d, e) {
                    m = !1, c.duplicateCachedPage = e, a.mobile.changePage(d, c)
                }).fail(function (a, b) {
                    m = !1, u(!0), v(), f.pageContainer.trigger("pagechangefailed", k)
                });
                return
            }
            b[0] === a.mobile.firstPage[0] && !f.dataUrl && (f.dataUrl = p.hrefNoHash);
            var o = f.fromPage, q = f.dataUrl && h.convertUrlToDataUrl(f.dataUrl) || b.jqmData("url"), r = q, s = h.getFilePath(q), t = j.getActive(), w = j.activeIndex === 0, x = 0, y = c.title, A = f.role === "dialog" || b.jqmData("role") === "dialog";
            if (o && o[0] === b[0] && !f.allowSamePageTransition) {
                m = !1, g.trigger("pagechange", k), f.fromHashChange && j.directHashChange({currentUrl: q, isBack: function () {
                }, isForward: function () {
                }});
                return
            }
            B(b, f.role), f.fromHashChange && j.directHashChange({currentUrl: q, isBack: function () {
                x = -1
            }, isForward: function () {
                x = 1
            }});
            try {
                c.activeElement && c.activeElement.nodeName.toLowerCase() !== "body" ? a(c.activeElement).blur() : a("input:focus, textarea:focus, select:focus").blur()
            } catch (C) {
            }
            var D = !1;
            A && t && (t.url.indexOf(n) > -1 && !a.mobile.activePage.is(".ui-dialog") && (f.changeHash = !1, D = !0), q = (t.url || "") + (D ? "" : n), j.activeIndex === 0 && q === j.initialDst && (q += n)), f.changeHash !== !1 && q && (j.ignoreNextHashChange = !0, h.set(q));
            var E = t ? b.jqmData("title") || b.children(":jqmData(role='header')").find(".ui-title").getEncodedText() : y;
            !!E && y === c.title && (y = E), b.jqmData("title") || b.jqmData("title", y), f.transition = f.transition || (x && !w ? t.transition : d) || (A ? a.mobile.defaultDialogTransition : a.mobile.defaultPageTransition), x || (D && (j.activeIndex = Math.max(0, j.activeIndex - 1)), j.addNew(q, f.transition, y, r, f.role)), c.title = j.getActive().title, a.mobile.activePage = b, f.reverse = f.reverse || x < 0, z(b, o, f.transition, f.reverse).done(function (c, d, e, h, i) {
                u(), f.duplicateCachedPage && f.duplicateCachedPage.remove(), i || a.mobile.focusPage(b), v(), g.trigger("pagechange", k)
            })
        }, a.mobile.changePage.defaults = {transition: d, reverse: !1, changeHash: !0, fromHashChange: !1, role: d, duplicateCachedPage: d, pageContainer: d, showLoadMsg: !0, dataUrl: d, fromPage: d, allowSamePageTransition: !1}, a.mobile.navreadyDeferred = a.Deferred(), a.mobile.navreadyDeferred.done(function () {
            a(c).delegate("form", "submit", function (b) {
                var c = a(this);
                if (!a.mobile.ajaxEnabled || c.is(":jqmData(ajax='false')") || !c.jqmHijackable().length)return;
                var d = c.attr("method"), e = c.attr("target"), f = c.attr("action");
                f || (f = D(c), f === q.hrefNoHash && (f = p.hrefNoSearch)), f = h.makeUrlAbsolute(f, D(c));
                if (h.isExternal(f) && !h.isPermittedCrossDomainRequest(p, f) || e)return;
                a.mobile.changePage(f, {type: d && d.length && d.toLowerCase() || "get", data: c.serialize(), transition: c.jqmData("transition"), reverse: c.jqmData("direction") === "reverse", reloadPage: !0}), b.preventDefault()
            }), a(c).bind("vclick", function (b) {
                if (b.which > 1 || !a.mobile.linkBindingEnabled)return;
                var c = C(b.target);
                if (!a(c).jqmHijackable().length)return;
                c && h.parseUrl(c.getAttribute("href") || "#").hash !== "#" && (u(!0), i = a(c).closest(".ui-btn").not(".ui-disabled"), i.addClass(a.mobile.activeBtnClass))
            }), a(c).bind("click", function (c) {
                if (!a.mobile.linkBindingEnabled)return;
                var e = C(c.target), f = a(e), g;
                if (!e || c.which > 1 || !f.jqmHijackable().length)return;
                g = function () {
                    b.setTimeout(function () {
                        u(!0)
                    }, 200)
                };
                if (f.is(":jqmData(rel='back')"))return a.mobile.back(), !1;
                var i = D(f), j = h.makeUrlAbsolute(f.attr("href") || "#", i);
                if (!a.mobile.ajaxEnabled && !h.isEmbeddedPage(j)) {
                    g();
                    return
                }
                if (j.search("#") !== -1) {
                    j = j.replace(/[^#]*#/, "");
                    if (!j) {
                        c.preventDefault();
                        return
                    }
                    h.isPath(j) ? j = h.makeUrlAbsolute(j, i) : j = h.makeUrlAbsolute("#" + j, p.hrefNoHash)
                }
                var k = f.is("[rel='external']") || f.is(":jqmData(ajax='false')") || f.is("[target]"), l = k || h.isExternal(j) && !h.isPermittedCrossDomainRequest(p, j);
                if (l) {
                    g();
                    return
                }
                var m = f.jqmData("transition"), n = f.jqmData("direction") === "reverse" || f.jqmData("back"), o = f.attr("data-" + a.mobile.ns + "rel") || d;
                a.mobile.changePage(j, {transition: m, reverse: n, role: o, link: f}), c.preventDefault()
            }), a(c).delegate(".ui-page", "pageshow.prefetch", function () {
                var b = [];
                a(this).find("a:jqmData(prefetch)").each(function () {
                    var c = a(this), d = c.attr("href");
                    d && a.inArray(d, b) === -1 && (b.push(d), a.mobile.loadPage(d, {role: c.attr("data-" + a.mobile.ns + "rel")}))
                })
            }), a.mobile._handleHashChange = function (c) {
                var e = h.stripHash(c), f = a.mobile.urlHistory.stack.length === 0 ? "none" : d, g = new a.Event("navigate"), i = {transition: f, changeHash: !1, fromHashChange: !0};
                0 === j.stack.length && (j.initialDst = e), a.mobile.pageContainer.trigger(g);
                if (g.isDefaultPrevented())return;
                if (!a.mobile.hashListeningEnabled || j.ignoreNextHashChange) {
                    j.ignoreNextHashChange = !1;
                    return
                }
                if (j.stack.length > 1 && e.indexOf(n) > -1 && j.initialDst !== e) {
                    if (!a.mobile.activePage.is(".ui-dialog")) {
                        j.directHashChange({currentUrl: e, isBack: function () {
                            a.mobile.back()
                        }, isForward: function () {
                            b.history.forward()
                        }});
                        return
                    }
                    j.directHashChange({currentUrl: e, either: function (b) {
                        var c = a.mobile.urlHistory.getActive();
                        e = c.pageUrl, a.extend(i, {role: c.role, transition: c.transition, reverse: b})
                    }})
                }
                e ? (e = typeof e == "string" && !h.isPath(e) ? h.makeUrlAbsolute("#" + e, q) : e, e === h.makeUrlAbsolute("#" + j.initialDst, q) && j.stack.length && j.stack[0].url !== j.initialDst.replace(n, "") && (e = a.mobile.firstPage), a.mobile.changePage(e, i)) : a.mobile.changePage(a.mobile.firstPage, i)
            }, e.bind("hashchange", function (b, c) {
                a.mobile._handleHashChange(h.parseLocation().hash)
            }), a(c).bind("pageshow", A), a(b).bind("throttledresize", A)
        })
    }(a), function (a, b) {
        var e = {}, f = e, g = a(b), h = a.mobile.path.parseLocation(), i = a.Deferred(), j = a.Deferred();
        a(c).ready(a.proxy(j, "resolve")), a(c).one("mobileinit", a.proxy(i, "resolve")), a.extend(e, {initialFilePath: function () {
            return h.pathname + h.search
        }(), hashChangeTimeout: 200, hashChangeEnableTimer: d, initialHref: h.hrefNoHash, state: function () {
            return{hash: a.mobile.path.parseLocation().hash || "#" + f.initialFilePath, title: c.title, initialHref: f.initialHref}
        }, resetUIKeys: function (b) {
            var c = a.mobile.dialogHashKey, d = "&" + a.mobile.subPageUrlKey, e = b.indexOf(c);
            return e > -1 ? b = b.slice(0, e) + "#" + b.slice(e) : b.indexOf(d) > -1 && (b = b.split(d).join("#" + d)), b
        }, nextHashChangePrevented: function (b) {
            a.mobile.urlHistory.ignoreNextHashChange = b, f.onHashChangeDisabled = b
        }, onHashChange: function (b) {
            if (f.onHashChangeDisabled)return;
            var d, e, g = a.mobile.path.parseLocation().hash, h = a.mobile.path.isPath(g), i = h ? a.mobile.path.getLocation() : a.mobile.getDocumentUrl();
            g = h ? g.replace("#", "") : g, e = f.state(), d = a.mobile.path.makeUrlAbsolute(g, i), h && (d = f.resetUIKeys(d)), history.replaceState(e, c.title, d)
        }, onPopState: function (b) {
            var c = b.originalEvent.state, d, e, g;
            c && (clearTimeout(f.hashChangeEnableTimer), f.nextHashChangePrevented(!1), a.mobile._handleHashChange(c.hash), f.nextHashChangePrevented(!0), f.hashChangeEnableTimer = setTimeout(function () {
                f.nextHashChangePrevented(!1)
            }, f.hashChangeTimeout))
        }, init: function () {
            g.bind("hashchange", f.onHashChange), g.bind("popstate", f.onPopState), location.hash === "" && history.replaceState(f.state(), c.title, a.mobile.path.getLocation())
        }}), a.when(j, i, a.mobile.navreadyDeferred).done(function () {
            a.mobile.pushStateEnabled && a.support.pushState && e.init()
        })
    }(a, this), function (a, b, c) {
        a.mobile.transitionFallbacks.flip = "fade"
    }(a, this), function (a, b, c) {
        a.mobile.transitionFallbacks.flow = "fade"
    }(a, this), function (a, b, c) {
        a.mobile.transitionFallbacks.pop = "fade"
    }(a, this), function (a, b, c) {
        a.mobile.transitionHandlers.slide = a.mobile.transitionHandlers.simultaneous, a.mobile.transitionFallbacks.slide = "fade"
    }(a, this), function (a, b, c) {
        a.mobile.transitionFallbacks.slidedown = "fade"
    }(a, this), function (a, b, c) {
        a.mobile.transitionFallbacks.slidefade = "fade"
    }(a, this), function (a, b, c) {
        a.mobile.transitionFallbacks.slideup = "fade"
    }(a, this), function (a, b, c) {
        a.mobile.transitionFallbacks.turn = "fade"
    }(a, this), function (a, b) {
        a.mobile.page.prototype.options.degradeInputs = {color: !1, date: !1, datetime: !1, "datetime-local": !1, email: !1, month: !1, number: !1, range: "number", search: "text", tel: !1, time: !1, url: !1, week: !1}, a(c).bind("pagecreate create", function (b) {
            var c = a.mobile.closestPageData(a(b.target)), d;
            if (!c)return;
            d = c.options, a(b.target).find("input").not(c.keepNativeSelector()).each(function () {
                var b = a(this), c = this.getAttribute("type"), e = d.degradeInputs[c] || "text";
                if (d.degradeInputs[c]) {
                    var f = a("<div>").html(b.clone()).html(), g = f.indexOf(" type=") > -1, h = g ? /\s+type=["']?\w+['"]?/ : /\/?>/, i = ' type="' + e + '" data-' + a.mobile.ns + 'type="' + c + '"' + (g ? "" : ">");
                    b.replaceWith(f.replace(h, i))
                }
            })
        })
    }(a), function (a, b, d) {
        a.widget("mobile.dialog", a.mobile.widget, {options: {closeBtnText: "Close", overlayTheme: "a", initSelector: ":jqmData(role='dialog')"}, _create: function () {
            var b = this, c = this.element, d = a("<a href='#' data-" + a.mobile.ns + "icon='delete' data-" + a.mobile.ns + "iconpos='notext'>" + this.options.closeBtnText + "</a>"), e = a("<div/>", {role: "dialog", "class": "ui-dialog-contain ui-corner-all ui-overlay-shadow"});
            c.addClass("ui-dialog ui-overlay-" + this.options.overlayTheme), c.wrapInner(e).children().find(":jqmData(role='header')").prepend(d).end().children(":first-child").addClass("ui-corner-top").end().children(":last-child").addClass("ui-corner-bottom"), d.bind("click", function () {
                b.close()
            }), c.bind("vclick submit",function (b) {
                var c = a(b.target).closest(b.type === "vclick" ? "a" : "form"), d;
                c.length && !c.jqmData("transition") && (d = a.mobile.urlHistory.getActive() || {}, c.attr("data-" + a.mobile.ns + "transition", d.transition || a.mobile.defaultDialogTransition).attr("data-" + a.mobile.ns + "direction", "reverse"))
            }).bind("pagehide",function (b, c) {
                a(this).find("." + a.mobile.activeBtnClass).not(".ui-slider-bg").removeClass(a.mobile.activeBtnClass)
            }).bind("pagebeforeshow", function () {
                b._isCloseable = !0, b.options.overlayTheme && b.element.page("removeContainerBackground").page("setContainerBackground", b.options.overlayTheme)
            })
        }, close: function () {
            var b;
            this._isCloseable && (this._isCloseable = !1, a.mobile.hashListeningEnabled ? a.mobile.back() : (b = a.mobile.urlHistory.getPrev().url, a.mobile.path.isPath(b) || (b = a.mobile.path.makeUrlAbsolute("#" + b)), a.mobile.changePage(b, {changeHash: !1, fromHashChange: !0})))
        }}), a(c).delegate(a.mobile.dialog.prototype.options.initSelector, "pagecreate", function () {
            a.mobile.dialog.prototype.enhance(this)
        })
    }(a, this), function (a, b) {
        a.mobile.page.prototype.options.backBtnText = "Back", a.mobile.page.prototype.options.addBackBtn = !1, a.mobile.page.prototype.options.backBtnTheme = null, a.mobile.page.prototype.options.headerTheme = "a", a.mobile.page.prototype.options.footerTheme = "a", a.mobile.page.prototype.options.contentTheme = null, a(c).bind("pagecreate", function (b) {
            var c = a(b.target), d = c.data("page").options, e = c.jqmData("role"), f = d.theme;
            a(":jqmData(role='header'), :jqmData(role='footer'), :jqmData(role='content')", c).jqmEnhanceable().each(function () {
                var b = a(this), g = b.jqmData("role"), h = b.jqmData("theme"), i = h || d.contentTheme || e === "dialog" && f, j, k, l, m;
                b.addClass("ui-" + g);
                if (g === "header" || g === "footer") {
                    var n = h || (g === "header" ? d.headerTheme : d.footerTheme) || f;
                    b.addClass("ui-bar-" + n).attr("role", g === "header" ? "banner" : "contentinfo"), g === "header" && (j = b.children("a, button"), k = j.hasClass("ui-btn-left"), l = j.hasClass("ui-btn-right"), k = k || j.eq(0).not(".ui-btn-right").addClass("ui-btn-left").length, l = l || j.eq(1).addClass("ui-btn-right").length), d.addBackBtn && g === "header" && a(".ui-page").length > 1 && c.jqmData("url") !== a.mobile.path.stripHash(location.hash) && !k && (m = a("<a href='javascript:void(0);' class='ui-btn-left' data-" + a.mobile.ns + "rel='back' data-" + a.mobile.ns + "icon='arrow-l'>" + d.backBtnText + "</a>").attr("data-" + a.mobile.ns + "theme", d.backBtnTheme || n).prependTo(b)), b.children("h1, h2, h3, h4, h5, h6").addClass("ui-title").attr({role: "heading", "aria-level": "1"})
                } else g === "content" && (i && b.addClass("ui-body-" + i), b.attr("role", "main"))
            })
        })
    }(a), function (a, b) {
        a.fn.fieldcontain = function (a) {
            return this.addClass("ui-field-contain ui-body ui-br").contents().filter(function () {
                return this.nodeType === 3 && !/\S/.test(this.nodeValue)
            }).remove()
        }, a(c).bind("pagecreate create", function (b) {
            a(":jqmData(role='fieldcontain')", b.target).jqmEnhanceable().fieldcontain()
        })
    }(a), function (a, b) {
        a.fn.grid = function (b) {
            return this.each(function () {
                var c = a(this), d = a.extend({grid: null}, b), e = c.children(), f = {solo: 1, a: 2, b: 3, c: 4, d: 5}, g = d.grid, h;
                if (!g)if (e.length <= 5)for (var i in f)f[i] === e.length && (g = i); else g = "a", c.addClass("ui-grid-duo");
                h = f[g], c.addClass("ui-grid-" + g), e.filter(":nth-child(" + h + "n+1)").addClass("ui-block-a"), h > 1 && e.filter(":nth-child(" + h + "n+2)").addClass("ui-block-b"), h > 2 && e.filter(":nth-child(" + h + "n+3)").addClass("ui-block-c"), h > 3 && e.filter(":nth-child(" + h + "n+4)").addClass("ui-block-d"), h > 4 && e.filter(":nth-child(" + h + "n+5)").addClass("ui-block-e")
            })
        }
    }(a), function (a, b) {
        a(c).bind("pagecreate create", function (b) {
            a(":jqmData(role='nojs')", b.target).addClass("ui-nojs")
        })
    }(a), function (a, b) {
        function d(a) {
            var b;
            while (a) {
                b = typeof a.className == "string" && a.className + " ";
                if (b && b.indexOf("ui-btn ") > -1 && b.indexOf("ui-disabled ") < 0)break;
                a = a.parentNode
            }
            return a
        }

        a.fn.buttonMarkup = function (d) {
            var f = this, g = function (b, c) {
                j.setAttribute("data-" + a.mobile.ns + b, c), i.jqmData(b, c)
            };
            d = d && a.type(d) === "object" ? d : {};
            for (var h = 0; h < f.length; h++) {
                var i = f.eq(h), j = i[0], k = a.extend({}, a.fn.buttonMarkup.defaults, {icon: d.icon !== b ? d.icon : i.jqmData("icon"), iconpos: d.iconpos !== b ? d.iconpos : i.jqmData("iconpos"), theme: d.theme !== b ? d.theme : i.jqmData("theme") || a.mobile.getInheritedTheme(i, "c"), inline: d.inline !== b ? d.inline : i.jqmData("inline"), shadow: d.shadow !== b ? d.shadow : i.jqmData("shadow"), corners: d.corners !== b ? d.corners : i.jqmData("corners"), iconshadow: d.iconshadow !== b ? d.iconshadow : i.jqmData("iconshadow"), mini: d.mini !== b ? d.mini : i.jqmData("mini")}, d), l = "ui-btn-inner", m = "ui-btn-text", n, o, p, q, r, s;
                a.each(k, g), i.jqmData("rel") === "popup" && i.attr("href") && (j.setAttribute("aria-haspopup", !0), j.setAttribute("aria-owns", j.getAttribute("href"))), s = a.data(j.tagName === "INPUT" || j.tagName === "BUTTON" ? j.parentNode : j, "buttonElements"), s ? (j = s.outer, i = a(j), p = s.inner, q = s.text, a(s.icon).remove(), s.icon = null) : (p = c.createElement(k.wrapperEls), q = c.createElement(k.wrapperEls)), r = k.icon ? c.createElement("span") : null, e && !s && e(), k.theme || (k.theme = a.mobile.getInheritedTheme(i, "c")), n = "ui-btn ui-btn-up-" + k.theme, n += k.shadow ? " ui-shadow" : "", n += k.corners ? " ui-btn-corner-all" : "", k.mini !== b && (n += k.mini === !0 ? " ui-mini" : " ui-fullsize"), k.inline !== b && (n += k.inline === !0 ? " ui-btn-inline" : " ui-btn-block"), k.icon && (k.icon = "ui-icon-" + k.icon, k.iconpos = k.iconpos || "left", o = "ui-icon " + k.icon, k.iconshadow && (o += " ui-icon-shadow")), k.iconpos && (n += " ui-btn-icon-" + k.iconpos, k.iconpos === "notext" && !i.attr("title") && i.attr("title", i.getEncodedText())), l += k.corners ? " ui-btn-corner-all" : "", k.iconpos && k.iconpos === "notext" && !i.attr("title") && i.attr("title", i.getEncodedText()), s && i.removeClass(s.bcls || ""), i.removeClass("ui-link").addClass(n), p.className = l, q.className = m, s || p.appendChild(q);
                if (r) {
                    r.className = o;
                    if (!s || !s.icon)r.innerHTML = "&#160;", p.appendChild(r)
                }
                while (j.firstChild && !s)q.appendChild(j.firstChild);
                s || j.appendChild(p), s = {bcls: n, outer: j, inner: p, text: q, icon: r}, a.data(j, "buttonElements", s), a.data(p, "buttonElements", s), a.data(q, "buttonElements", s), r && a.data(r, "buttonElements", s)
            }
            return this
        }, a.fn.buttonMarkup.defaults = {corners: !0, shadow: !0, iconshadow: !0, wrapperEls: "span"};
        var e = function () {
            var b = a.mobile.buttonMarkup.hoverDelay, f, g;
            a(c).bind({"vmousedown vmousecancel vmouseup vmouseover vmouseout focus blur scrollstart": function (c) {
                var e, h = a(d(c.target)), i = c.originalEvent && /^touch/.test(c.originalEvent.type), j = c.type;
                if (h.length) {
                    e = h.attr("data-" + a.mobile.ns + "theme");
                    if (j === "vmousedown")i ? f = setTimeout(function () {
                        h.removeClass("ui-btn-up-" + e).addClass("ui-btn-down-" + e)
                    }, b) : h.removeClass("ui-btn-up-" + e).addClass("ui-btn-down-" + e); else if (j === "vmousecancel" || j === "vmouseup")h.removeClass("ui-btn-down-" + e).addClass("ui-btn-up-" + e); else if (j === "vmouseover" || j === "focus")i ? g = setTimeout(function () {
                        h.removeClass("ui-btn-up-" + e).addClass("ui-btn-hover-" + e)
                    }, b) : h.removeClass("ui-btn-up-" + e).addClass("ui-btn-hover-" + e); else if (j === "vmouseout" || j === "blur" || j === "scrollstart")h.removeClass("ui-btn-hover-" + e + " ui-btn-down-" + e).addClass("ui-btn-up-" + e), f && clearTimeout(f), g && clearTimeout(g)
                }
            }, "focusin focus": function (b) {
                a(d(b.target)).addClass(a.mobile.focusClass)
            }, "focusout blur": function (b) {
                a(d(b.target)).removeClass(a.mobile.focusClass)
            }}), e = null
        };
        a(c).bind("pagecreate create", function (b) {
            a(":jqmData(role='button'), .ui-bar > a, .ui-header > a, .ui-footer > a, .ui-bar > :jqmData(role='controlgroup') > a", b.target).jqmEnhanceable().not("button, input, .ui-btn, :jqmData(role='none'), :jqmData(role='nojs')").buttonMarkup()
        })
    }(a), function (a, b) {
        a.widget("mobile.collapsible", a.mobile.widget, {options: {expandCueText: " click to expand contents", collapseCueText: " click to collapse contents", collapsed: !0, heading: "h1,h2,h3,h4,h5,h6,legend", theme: null, contentTheme: null, inset: !0, mini: !1, initSelector: ":jqmData(role='collapsible')"}, _create: function () {
            var c = this.element, d = this.options, e = c.addClass("ui-collapsible"), f = c.children(d.heading).first(), g = c.jqmData("collapsed-icon") || d.collapsedIcon, h = c.jqmData("expanded-icon") || d.expandedIcon, i = e.wrapInner("<div class='ui-collapsible-content'></div>").children(".ui-collapsible-content"), j = c.closest(":jqmData(role='collapsible-set')").addClass("ui-collapsible-set");
            f.is("legend") && (f = a("<div role='heading'>" + f.html() + "</div>").insertBefore(f), f.next().remove()), j.length ? (d.theme || (d.theme = j.jqmData("theme") || a.mobile.getInheritedTheme(j, "c")), d.contentTheme || (d.contentTheme = j.jqmData("content-theme")), d.collapsedIcon || (d.collapsedIcon = j.jqmData("collapsed-icon")), d.expandedIcon || (d.expandedIcon = j.jqmData("expanded-icon")), d.iconPos || (d.iconPos = j.jqmData("iconpos")), j.jqmData("inset") !== b ? d.inset = j.jqmData("inset") : d.inset = !0, d.mini || (d.mini = j.jqmData("mini"))) : d.theme || (d.theme = a.mobile.getInheritedTheme(c, "c")), !d.inset || e.addClass("ui-collapsible-inset"), i.addClass(d.contentTheme ? "ui-body-" + d.contentTheme : ""), g = c.jqmData("collapsed-icon") || d.collapsedIcon || "plus", h = c.jqmData("expanded-icon") || d.expandedIcon || "minus", f.insertBefore(i).addClass("ui-collapsible-heading").append("<span class='ui-collapsible-heading-status'></span>").wrapInner("<a href='#' class='ui-collapsible-heading-toggle'></a>").find("a").first().buttonMarkup({shadow: !1, corners: !1, iconpos: c.jqmData("iconpos") || d.iconPos || "left", icon: g, mini: d.mini, theme: d.theme}), !d.inset || f.find("a").first().add(".ui-btn-inner", c).addClass("ui-corner-top ui-corner-bottom"), e.bind("expand collapse",function (b) {
                if (!b.isDefaultPrevented()) {
                    var c = a(this), k = b.type === "collapse", l = d.contentTheme;
                    b.preventDefault(), f.toggleClass("ui-collapsible-heading-collapsed", k).find(".ui-collapsible-heading-status").text(k ? d.expandCueText : d.collapseCueText).end().find(".ui-icon").toggleClass("ui-icon-" + h, !k).toggleClass("ui-icon-" + g, k || h === g).end().find("a").first().removeClass(a.mobile.activeBtnClass), c.toggleClass("ui-collapsible-collapsed", k), i.toggleClass("ui-collapsible-content-collapsed", k).attr("aria-hidden", k), l && !!d.inset && (!j.length || e.jqmData("collapsible-last")) && (f.find("a").first().add(f.find(".ui-btn-inner")).toggleClass("ui-corner-bottom", k), i.toggleClass("ui-corner-bottom", !k)), i.trigger("updatelayout")
                }
            }).trigger(d.collapsed ? "collapse" : "expand"), f.bind("tap",function (b) {
                f.find("a").first().addClass(a.mobile.activeBtnClass)
            }).bind("click", function (a) {
                var b = f.is(".ui-collapsible-heading-collapsed") ? "expand" : "collapse";
                e.trigger(b), a.preventDefault(), a.stopPropagation()
            })
        }}), a(c).bind("pagecreate create", function (b) {
            a.mobile.collapsible.prototype.enhanceWithin(b.target)
        })
    }(a), function (a, b) {
        a.widget("mobile.collapsibleset", a.mobile.widget, {options: {initSelector: ":jqmData(role='collapsible-set')"}, _create: function () {
            var c = this.element.addClass("ui-collapsible-set"), d = this.options;
            d.theme || (d.theme = a.mobile.getInheritedTheme(c, "c")), d.contentTheme || (d.contentTheme = c.jqmData("content-theme")), c.jqmData("inset") !== b && (d.inset = c.jqmData("inset")), d.inset = d.inset !== b ? d.inset : !0, c.jqmData("collapsiblebound") || c.jqmData("collapsiblebound", !0).bind("expand collapse",function (b) {
                var c = b.type === "collapse", e = a(b.target).closest(".ui-collapsible"), f = e.data("collapsible");
                e.jqmData("collapsible-last") && !!d.inset && (e.find(".ui-collapsible-heading").first().find("a").first().toggleClass("ui-corner-bottom", c).find(".ui-btn-inner").toggleClass("ui-corner-bottom", c), e.find(".ui-collapsible-content").toggleClass("ui-corner-bottom", !c))
            }).bind("expand", function (b) {
                var c = a(b.target).closest(".ui-collapsible");
                c.parent().is(":jqmData(role='collapsible-set')") && c.siblings(".ui-collapsible").trigger("collapse")
            })
        }, _init: function () {
            var a = this.element, b = a.children(":jqmData(role='collapsible')"), c = b.filter(":jqmData(collapsed='false')");
            this.refresh(), c.trigger("expand")
        }, refresh: function () {
            var b = this.element, c = this.options, d = b.children(":jqmData(role='collapsible')");
            a.mobile.collapsible.prototype.enhance(d.not(".ui-collapsible")), !c.inset || (d.each(function () {
                a(this).jqmRemoveData("collapsible-last").find(".ui-collapsible-heading").find("a").first().removeClass("ui-corner-top ui-corner-bottom").find(".ui-btn-inner").removeClass("ui-corner-top ui-corner-bottom")
            }), d.first().find("a").first().addClass("ui-corner-top").find(".ui-btn-inner").addClass("ui-corner-top"), d.last().jqmData("collapsible-last", !0).find("a").first().addClass("ui-corner-bottom").find(".ui-btn-inner").addClass("ui-corner-bottom"))
        }}), a(c).bind("pagecreate create", function (b) {
            a.mobile.collapsibleset.prototype.enhanceWithin(b.target)
        })
    }(a), function (a, b) {
        a.widget("mobile.navbar", a.mobile.widget, {options: {iconpos: "top", grid: null, initSelector: ":jqmData(role='navbar')"}, _create: function () {
            var c = this.element, d = c.find("a"), e = d.filter(":jqmData(icon)").length ? this.options.iconpos : b;
            c.addClass("ui-navbar ui-mini").attr("role", "navigation").find("ul").jqmEnhanceable().grid({grid: this.options.grid}), d.buttonMarkup({corners: !1, shadow: !1, inline: !0, iconpos: e}), c.delegate("a", "vclick", function (b) {
                a(b.target).hasClass("ui-disabled") || (d.removeClass(a.mobile.activeBtnClass), a(this).addClass(a.mobile.activeBtnClass))
            }), c.closest(".ui-page").bind("pagebeforeshow", function () {
                d.filter(".ui-state-persist").addClass(a.mobile.activeBtnClass)
            })
        }}), a(c).bind("pagecreate create", function (b) {
            a.mobile.navbar.prototype.enhanceWithin(b.target)
        })
    }(a), function (a, b) {
        var d = {};
        a.widget("mobile.listview", a.mobile.widget, {options: {theme: null, countTheme: "c", headerTheme: "b", dividerTheme: "b", splitIcon: "arrow-r", splitTheme: "b", inset: !1, initSelector: ":jqmData(role='listview')"}, _create: function () {
            var a = this, b = "";
            b += a.options.inset ? " ui-listview-inset ui-corner-all ui-shadow " : "", a.element.addClass(function (a, c) {
                return c + " ui-listview " + b
            }), a.refresh(!0)
        }, _removeCorners: function (a, b) {
            var c = "ui-corner-top ui-corner-tr ui-corner-tl", d = "ui-corner-bottom ui-corner-br ui-corner-bl";
            a = a.add(a.find(".ui-btn-inner, .ui-li-link-alt, .ui-li-thumb")), b === "top" ? a.removeClass(c) : b === "bottom" ? a.removeClass(d) : a.removeClass(c + " " + d)
        }, _refreshCorners: function (a) {
            var b, c, d, e;
            b = this.element.children("li"), c = a || b.filter(":visible").length === 0 ? b.not(".ui-screen-hidden") : b.filter(":visible"), b.filter(".ui-li-last").removeClass("ui-li-last"), this.options.inset ? (this._removeCorners(b), d = c.first().addClass("ui-corner-top"), d.add(d.find(".ui-btn-inner").not(".ui-li-link-alt span:first-child")).addClass("ui-corner-top").end().find(".ui-li-link-alt, .ui-li-link-alt span:first-child").addClass("ui-corner-tr").end().find(".ui-li-thumb").not(".ui-li-icon").addClass("ui-corner-tl"), e = c.last().addClass("ui-corner-bottom ui-li-last"), e.add(e.find(".ui-btn-inner")).find(".ui-li-link-alt").addClass("ui-corner-br").end().find(".ui-li-thumb").not(".ui-li-icon").addClass("ui-corner-bl")) : c.last().addClass("ui-li-last"), a || this.element.trigger("updatelayout")
        }, _findFirstElementByTagName: function (a, b, c, d) {
            var e = {};
            e[c] = e[d] = !0;
            while (a) {
                if (e[a.nodeName])return a;
                a = a[b]
            }
            return null
        }, _getChildrenByTagName: function (b, c, d) {
            var e = [], f = {};
            f[c] = f[d] = !0, b = b.firstChild;
            while (b)f[b.nodeName] && e.push(b), b = b.nextSibling;
            return a(e)
        }, _addThumbClasses: function (b) {
            var c, d, e = b.length;
            for (c = 0; c < e; c++)d = a(this._findFirstElementByTagName(b[c].firstChild, "nextSibling", "img", "IMG")), d.length && (d.addClass("ui-li-thumb"), a(this._findFirstElementByTagName(d[0].parentNode, "parentNode", "li", "LI")).addClass(d.is(".ui-li-icon") ? "ui-li-has-icon" : "ui-li-has-thumb"))
        }, refresh: function (b) {
            this.parentPage = this.element.closest(".ui-page"), this._createSubPages();
            var d = this.options, e = this.element, f = this, g = e.jqmData("dividertheme") || d.dividerTheme, h = e.jqmData("splittheme"), i = e.jqmData("spliticon"), j = this._getChildrenByTagName(e[0], "li", "LI"), k = !!a.nodeName(e[0], "ol"), l = !a.support.cssPseudoElement, m = e.attr("start"), n = {}, o, p, q, r, s, t, u, v, w, x, y, z, A, B;
            k && l && e.find(".ui-li-dec").remove(), k && (m || m === 0 ? l ? u = parseFloat(m) : (v = parseFloat(m) - 1, e.css("counter-reset", "listnumbering " + v)) : l && (u = 1)), d.theme || (d.theme = a.mobile.getInheritedTheme(this.element, "c"));
            for (var C = 0, D = j.length; C < D; C++) {
                o = j.eq(C), p = "ui-li";
                if (b || !o.hasClass("ui-li")) {
                    q = o.jqmData("theme") || d.theme, r = this._getChildrenByTagName(o[0], "a", "A");
                    var E = o.jqmData("role") === "list-divider";
                    r.length && !E ? (y = o.jqmData("icon"), o.buttonMarkup({wrapperEls: "div", shadow: !1, corners: !1, iconpos: "right", icon: r.length > 1 || y === !1 ? !1 : y || "arrow-r", theme: q}), y !== !1 && r.length === 1 && o.addClass("ui-li-has-arrow"), r.first().removeClass("ui-link").addClass("ui-link-inherit"), r.length > 1 && (p += " ui-li-has-alt", s = r.last(), t = h || s.jqmData("theme") || d.splitTheme, B = s.jqmData("icon"), s.appendTo(o).attr("title", s.getEncodedText()).addClass("ui-li-link-alt").empty().buttonMarkup({shadow: !1, corners: !1, theme: q, icon: !1, iconpos: "notext"}).find(".ui-btn-inner").append(a(c.createElement("span")).buttonMarkup({shadow: !0, corners: !0, theme: t, iconpos: "notext", icon: B || y || i || d.splitIcon})))) : E ? (p += " ui-li-divider ui-bar-" + g, o.attr("role", "heading"), k && (m || m === 0 ? l ? u = parseFloat(m) : (w = parseFloat(m) - 1, o.css("counter-reset", "listnumbering " + w)) : l && (u = 1))) : p += " ui-li-static ui-btn-up-" +
                        q
                }
                k && l && p.indexOf("ui-li-divider") < 0 && (x = p.indexOf("ui-li-static") > 0 ? o : o.find(".ui-link-inherit"), x.addClass("ui-li-jsnumbering").prepend("<span class='ui-li-dec'>" + u++ + ". </span>")), n[p] || (n[p] = []), n[p].push(o[0])
            }
            for (p in n)a(n[p]).addClass(p).children(".ui-btn-inner").addClass(p);
            e.find("h1, h2, h3, h4, h5, h6").addClass("ui-li-heading").end().find("p, dl").addClass("ui-li-desc").end().find(".ui-li-aside").each(function () {
                var b = a(this);
                b.prependTo(b.parent())
            }).end().find(".ui-li-count").each(function () {
                a(this).closest("li").addClass("ui-li-has-count")
            }).addClass("ui-btn-up-" + (e.jqmData("counttheme") || this.options.countTheme) + " ui-btn-corner-all"), this._addThumbClasses(j), this._addThumbClasses(e.find(".ui-link-inherit")), this._refreshCorners(b), this._trigger("afterrefresh")
        }, _idStringEscape: function (a) {
            return a.replace(/[^a-zA-Z0-9]/g, "-")
        }, _createSubPages: function () {
            var b = this.element, c = b.closest(".ui-page"), e = c.jqmData("url"), f = e || c[0][a.expando], g = b.attr("id"), h = this.options, i = "data-" + a.mobile.ns, j = this, k = c.find(":jqmData(role='footer')").jqmData("id"), l;
            typeof d[f] == "undefined" && (d[f] = -1), g = g || ++d[f], a(b.find("li>ul, li>ol").toArray().reverse()).each(function (c) {
                var d = this, f = a(this), j = f.attr("id") || g + "-" + c, m = f.parent(), n = a(f.prevAll().toArray().reverse()), p = n.length ? n : a("<span>" + a.trim(m.contents()[0].nodeValue) + "</span>"), q = p.first().getEncodedText(), r = (e || "") + "&" + a.mobile.subPageUrlKey + "=" + j, s = f.jqmData("theme") || h.theme, t = f.jqmData("counttheme") || b.jqmData("counttheme") || h.countTheme, u, v;
                l = !0, u = f.detach().wrap("<div " + i + "role='page' " + i + "url='" + r + "' " + i + "theme='" + s + "' " + i + "count-theme='" + t + "'><div " + i + "role='content'></div></div>").parent().before("<div " + i + "role='header' " + i + "theme='" + h.headerTheme + "'><div class='ui-title'>" + q + "</div></div>").after(k ? a("<div " + i + "role='footer' " + i + "id='" + k + "'>") : "").parent().appendTo(a.mobile.pageContainer), u.page(), v = m.find("a:first"), v.length || (v = a("<a/>").html(p || q).prependTo(m.empty())), v.attr("href", "#" + r)
            }).listview();
            if (l && c.is(":jqmData(external-page='true')") && c.data("page").options.domCache === !1) {
                var m = function (b, d) {
                    var f = d.nextPage, g, h = new a.Event("pageremove");
                    d.nextPage && (g = f.jqmData("url"), g.indexOf(e + "&" + a.mobile.subPageUrlKey) !== 0 && (j.childPages().remove(), c.trigger(h), h.isDefaultPrevented() || c.removeWithDependents()))
                };
                c.unbind("pagehide.remove").bind("pagehide.remove", m)
            }
        }, childPages: function () {
            var b = this.parentPage.jqmData("url");
            return a(":jqmData(url^='" + b + "&" + a.mobile.subPageUrlKey + "')")
        }}), a(c).bind("pagecreate create", function (b) {
            a.mobile.listview.prototype.enhanceWithin(b.target)
        })
    }(a), function (a, b) {
        a.mobile.listview.prototype.options.autodividers = !1, a.mobile.listview.prototype.options.autodividersSelector = function (a) {
            var b = a.text() || null;
            return b ? (b = b.slice(0, 1).toUpperCase(), b) : null
        }, a(c).delegate("ul,ol", "listviewcreate", function () {
            var b = a(this), d = b.data("listview");
            if (!d || !d.options.autodividers)return;
            var e = function () {
                b.find("li:jqmData(role='list-divider')").remove();
                var e = b.find("li"), f = null, g, h;
                for (var i = 0; i < e.length; i++) {
                    g = e[i], h = d.options.autodividersSelector(a(g));
                    if (h && f !== h) {
                        var j = c.createElement("li");
                        j.appendChild(c.createTextNode(h)), j.setAttribute("data-" + a.mobile.ns + "role", "list-divider"), g.parentNode.insertBefore(j, g)
                    }
                    f = h
                }
            }, f = function () {
                b.unbind("listviewafterrefresh", f), e(), d.refresh(), b.bind("listviewafterrefresh", f)
            };
            f()
        })
    }(a), function (a, b) {
        a.widget("mobile.checkboxradio", a.mobile.widget, {options: {theme: null, initSelector: "input[type='checkbox'],input[type='radio']"}, _create: function () {
            var d = this, e = this.element, f = function (a, b) {
                return a.jqmData(b) || a.closest("form, fieldset").jqmData(b)
            }, g = a(e).closest("label"), h = g.length ? g : a(e).closest("form, fieldset, :jqmData(role='page'), :jqmData(role='dialog')").find("label").filter("[for='" + e[0].id + "']").first(), i = e[0].type, j = f(e, "mini"), k = i + "-on", l = i + "-off", m = e.parents(":jqmData(type='horizontal')").length ? b : l, n = f(e, "iconpos"), o = m ? "" : " " + a.mobile.activeBtnClass, p = "ui-" + k + o, q = "ui-" + l, r = "ui-icon-" + k, s = "ui-icon-" + l;
            if (i !== "checkbox" && i !== "radio")return;
            a.extend(this, {label: h, inputtype: i, checkedClass: p, uncheckedClass: q, checkedicon: r, uncheckedicon: s}), this.options.theme || (this.options.theme = a.mobile.getInheritedTheme(this.element, "c")), h.buttonMarkup({theme: this.options.theme, icon: m, shadow: !1, mini: j, iconpos: n});
            var t = c.createElement("div");
            t.className = "ui-" + i, e.add(h).wrapAll(t), h.bind({vmouseover: function (b) {
                a(this).parent().is(".ui-disabled") && b.stopPropagation()
            }, vclick: function (a) {
                if (e.is(":disabled")) {
                    a.preventDefault();
                    return
                }
                return d._cacheVals(), e.prop("checked", i === "radio" && !0 || !e.prop("checked")), e.triggerHandler("click"), d._getInputSet().not(e).prop("checked", !1), d._updateAll(), !1
            }}), e.bind({vmousedown: function () {
                d._cacheVals()
            }, vclick: function () {
                var b = a(this);
                b.is(":checked") ? (b.prop("checked", !0), d._getInputSet().not(b).prop("checked", !1)) : b.prop("checked", !1), d._updateAll()
            }, focus: function () {
                h.addClass(a.mobile.focusClass)
            }, blur: function () {
                h.removeClass(a.mobile.focusClass)
            }}), this.refresh()
        }, _cacheVals: function () {
            this._getInputSet().each(function () {
                a(this).jqmData("cacheVal", this.checked)
            })
        }, _getInputSet: function () {
            return this.inputtype === "checkbox" ? this.element : this.element.closest("form, fieldset, :jqmData(role='page'), :jqmData(role='dialog')").find("input[name='" + this.element[0].name + "'][type='" + this.inputtype + "']")
        }, _updateAll: function () {
            var b = this;
            this._getInputSet().each(function () {
                var c = a(this);
                (this.checked || b.inputtype === "checkbox") && c.trigger("change")
            }).checkboxradio("refresh")
        }, refresh: function () {
            var a = this.element[0], b = this.label, c = b.find(".ui-icon");
            a.checked ? (b.addClass(this.checkedClass).removeClass(this.uncheckedClass), c.addClass(this.checkedicon).removeClass(this.uncheckedicon)) : (b.removeClass(this.checkedClass).addClass(this.uncheckedClass), c.removeClass(this.checkedicon).addClass(this.uncheckedicon)), a.disabled ? this.disable() : this.enable()
        }, disable: function () {
            this.element.prop("disabled", !0).parent().addClass("ui-disabled")
        }, enable: function () {
            this.element.prop("disabled", !1).parent().removeClass("ui-disabled")
        }}), a(c).bind("pagecreate create", function (b) {
            a.mobile.checkboxradio.prototype.enhanceWithin(b.target, !0)
        })
    }(a), function (a, b) {
        a.widget("mobile.button", a.mobile.widget, {options: {theme: null, icon: null, iconpos: null, corners: !0, shadow: !0, iconshadow: !0, initSelector: "button, [type='button'], [type='submit'], [type='reset']"}, _create: function () {
            var d = this.element, e, f = this.options, g, h, i = f.inline || d.jqmData("inline"), j = f.mini || d.jqmData("mini"), k = "", l;
            if (d[0].tagName === "A") {
                d.hasClass("ui-btn") || d.buttonMarkup();
                return
            }
            this.options.theme || (this.options.theme = a.mobile.getInheritedTheme(this.element, "c")), !~d[0].className.indexOf("ui-btn-left") || (k = "ui-btn-left"), !~d[0].className.indexOf("ui-btn-right") || (k = "ui-btn-right");
            if (d.attr("type") === "submit" || d.attr("type") === "reset")k ? k += " ui-submit" : k = "ui-submit";
            a("label[for='" + d.attr("id") + "']").addClass("ui-submit"), this.button = a("<div></div>")[d.html() ? "html" : "text"](d.html() || d.val()).insertBefore(d).buttonMarkup({theme: f.theme, icon: f.icon, iconpos: f.iconpos, inline: i, corners: f.corners, shadow: f.shadow, iconshadow: f.iconshadow, mini: j}).addClass(k).append(d.addClass("ui-btn-hidden")), e = this.button, g = d.attr("type"), h = d.attr("name"), g !== "button" && g !== "reset" && h && d.bind("vclick", function () {
                l === b && (l = a("<input>", {type: "hidden", name: d.attr("name"), value: d.attr("value")}).insertBefore(d), a(c).one("submit", function () {
                    l.remove(), l = b
                }))
            }), d.bind({focus: function () {
                e.addClass(a.mobile.focusClass)
            }, blur: function () {
                e.removeClass(a.mobile.focusClass)
            }}), this.refresh()
        }, enable: function () {
            return this.element.attr("disabled", !1), this.button.removeClass("ui-disabled").attr("aria-disabled", !1), this._setOption("disabled", !1)
        }, disable: function () {
            return this.element.attr("disabled", !0), this.button.addClass("ui-disabled").attr("aria-disabled", !0), this._setOption("disabled", !0)
        }, refresh: function () {
            var b = this.element;
            b.prop("disabled") ? this.disable() : this.enable(), a(this.button.data("buttonElements").text)[b.html() ? "html" : "text"](b.html() || b.val())
        }}), a(c).bind("pagecreate create", function (b) {
            a.mobile.button.prototype.enhanceWithin(b.target, !0)
        })
    }(a), function (a, b) {
        a.fn.controlgroup = function (b) {
            function c(a, b) {
                a.removeClass("ui-btn-corner-all ui-corner-top ui-corner-bottom ui-corner-left ui-corner-right ui-controlgroup-last ui-shadow").eq(0).addClass(b[0]).end().last().addClass(b[1]).addClass("ui-controlgroup-last")
            }

            return this.each(function () {
                var d = a(this), e = a.extend({direction: d.jqmData("type") || "vertical", shadow: !1, excludeInvisible: !0, mini: d.jqmData("mini")}, b), f = d.children("legend"), g = d.children(".ui-controlgroup-label"), h = d.children(".ui-controlgroup-controls"), i = e.direction === "horizontal" ? ["ui-corner-left", "ui-corner-right"] : ["ui-corner-top", "ui-corner-bottom"], j = d.find("input").first().attr("type");
                h.length && h.contents().unwrap(), d.wrapInner("<div class='ui-controlgroup-controls'></div>"), f.length ? (a("<div role='heading' class='ui-controlgroup-label'>" + f.html() + "</div>").insertBefore(d.children(0)), f.remove()) : g.length && d.prepend(g), d.addClass("ui-corner-all ui-controlgroup ui-controlgroup-" + e.direction), c(d.find(".ui-btn" + (e.excludeInvisible ? ":visible" : "")).not(".ui-slider-handle"), i), c(d.find(".ui-btn-inner"), i), e.shadow && d.addClass("ui-shadow"), e.mini && d.addClass("ui-mini")
            })
        }
    }(a), function (a, b) {
        a(c).bind("pagecreate create", function (b) {
            a(b.target).find("a").jqmEnhanceable().not(".ui-btn, .ui-link-inherit, :jqmData(role='none'), :jqmData(role='nojs')").addClass("ui-link")
        })
    }(a), function (a, d) {
        function e(a, b, c, d) {
            var e = d;
            return a < b ? e = c + (a - b) / 2 : e = Math.min(Math.max(c, d - b / 2), c + a - b), e
        }

        function f() {
            var c = a(b);
            return{x: c.scrollLeft(), y: c.scrollTop(), cx: b.innerWidth || c.width(), cy: b.innerHeight || c.height()}
        }

        a.widget("mobile.popup", a.mobile.widget, {options: {theme: null, overlayTheme: null, shadow: !0, corners: !0, transition: "none", positionTo: "origin", tolerance: null, initSelector: ":jqmData(role='popup')", closeLinkSelector: "a:jqmData(rel='back')", closeLinkEvents: "click.popup", navigateEvents: "navigate.popup", closeEvents: "navigate.popup pagebeforechange.popup", history: !a.mobile.browser.ie}, _eatEventAndClose: function (a) {
            return a.preventDefault(), a.stopImmediatePropagation(), this.close(), !1
        }, _resizeScreen: function () {
            var a = this._ui.container.outerHeight(!0);
            this._ui.screen.removeAttr("style"), a > this._ui.screen.height() && this._ui.screen.height(a)
        }, _handleWindowKeyUp: function (b) {
            if (this._isOpen && b.keyCode === a.mobile.keyCode.ESCAPE)return this._eatEventAndClose(b)
        }, _maybeRefreshTimeout: function () {
            var b = f();
            if (this._resizeData) {
                if (b.x === this._resizeData.winCoords.x && b.y === this._resizeData.winCoords.y && b.cx === this._resizeData.winCoords.cx && b.cy === this._resizeData.winCoords.cy)return!1;
                clearTimeout(this._resizeData.timeoutId)
            }
            return this._resizeData = {timeoutId: setTimeout(a.proxy(this, "_resizeTimeout"), 200), winCoords: b}, !0
        }, _resizeTimeout: function () {
            this._maybeRefreshTimeout() || (this._trigger("beforeposition"), this._ui.container.removeClass("ui-selectmenu-hidden").offset(this._placementCoords(this._desiredCoords(d, d, "window"))), this._resizeScreen(), this._resizeData = null, this._orientationchangeInProgress = !1)
        }, _handleWindowResize: function (a) {
            this._isOpen && this._maybeRefreshTimeout()
        }, _handleWindowOrientationchange: function (a) {
            this._orientationchangeInProgress || (this._ui.container.addClass("ui-selectmenu-hidden").removeAttr("style"), this._orientationchangeInProgress = !0)
        }, _create: function () {
            var c = {screen: a("<div class='ui-screen-hidden ui-popup-screen'></div>"), placeholder: a("<div style='display: none;'><!-- placeholder --></div>"), container: a("<div class='ui-popup-container ui-selectmenu-hidden'></div>")}, e = this.element.closest(".ui-page"), f = this.element.attr("id"), g = this;
            this.options.history = this.options.history && a.mobile.ajaxEnabled && a.mobile.hashListeningEnabled, e.length === 0 && (e = a("body")), this.options.container = this.options.container || a.mobile.pageContainer, e.append(c.screen), c.container.insertAfter(c.screen), c.placeholder.insertAfter(this.element), f && (c.screen.attr("id", f + "-screen"), c.container.attr("id", f + "-popup"), c.placeholder.html("<!-- placeholder for " + f + " -->")), c.container.append(this.element), this.element.addClass("ui-popup"), a.extend(this, {_page: e, _ui: c, _fallbackTransition: "", _currentTransition: !1, _prereqs: null, _isOpen: !1, _tolerance: null, _resizeData: null, _orientationchangeInProgress: !1, _globalHandlers: [
                {src: a(b), handler: {orientationchange: a.proxy(this, "_handleWindowOrientationchange"), resize: a.proxy(this, "_handleWindowResize"), keyup: a.proxy(this, "_handleWindowKeyUp")}}
            ]}), a.each(this.options, function (a, b) {
                g.options[a] = d, g._setOption(a, b, !0)
            }), c.screen.bind("vclick", a.proxy(this, "_eatEventAndClose")), a.each(this._globalHandlers, function (a, b) {
                b.src.bind(b.handler)
            })
        }, _applyTheme: function (a, b, c) {
            var d = (a.attr("class") || "").split(" "), e = !0, f = null, g, h = String(b);
            while (d.length > 0) {
                f = d.pop(), g = (new RegExp("^ui-" + c + "-([a-z])$")).exec(f);
                if (g && g.length > 1) {
                    f = g[1];
                    break
                }
                f = null
            }
            b !== f && (a.removeClass("ui-" + c + "-" + f), b !== null && b !== "none" && a.addClass("ui-" + c + "-" + h))
        }, _setTheme: function (a) {
            this._applyTheme(this.element, a, "body")
        }, _setOverlayTheme: function (a) {
            this._applyTheme(this._ui.screen, a, "overlay"), this._isOpen && this._ui.screen.addClass("in")
        }, _setShadow: function (a) {
            this.element.toggleClass("ui-overlay-shadow", a)
        }, _setCorners: function (a) {
            this.element.toggleClass("ui-corner-all", a)
        }, _applyTransition: function (b) {
            this._ui.container.removeClass(this._fallbackTransition), b && b !== "none" && (this._fallbackTransition = a.mobile._maybeDegradeTransition(b), this._ui.container.addClass(this._fallbackTransition))
        }, _setTransition: function (a) {
            this._currentTransition || this._applyTransition(a)
        }, _setTolerance: function (b) {
            var c = {t: 30, r: 15, b: 30, l: 15};
            if (b) {
                var d = String(b).split(",");
                a.each(d, function (a, b) {
                    d[a] = parseInt(b, 10)
                });
                switch (d.length) {
                    case 1:
                        isNaN(d[0]) || (c.t = c.r = c.b = c.l = d[0]);
                        break;
                    case 2:
                        isNaN(d[0]) || (c.t = c.b = d[0]), isNaN(d[1]) || (c.l = c.r = d[1]);
                        break;
                    case 4:
                        isNaN(d[0]) || (c.t = d[0]), isNaN(d[1]) || (c.r = d[1]), isNaN(d[2]) || (c.b = d[2]), isNaN(d[3]) || (c.l = d[3]);
                        break;
                    default:
                }
            }
            this._tolerance = c
        }, _setOption: function (b, c) {
            var e, f = "_set" + b.charAt(0).toUpperCase() + b.slice(1);
            this[f] !== d && this[f](c), e = ["initSelector", "closeLinkSelector", "closeLinkEvents", "navigateEvents", "closeEvents", "history", "container"], a.mobile.widget.prototype._setOption.apply(this, arguments), a.inArray(b, e) === -1 && this.element.attr("data-" + (a.mobile.ns || "") + b.replace(/([A-Z])/, "-$1").toLowerCase(), c)
        }, _placementCoords: function (a) {
            var b = f(), d = {x: this._tolerance.l, y: b.y + this._tolerance.t, cx: b.cx - this._tolerance.l - this._tolerance.r, cy: b.cy - this._tolerance.t - this._tolerance.b}, g, h;
            this._ui.container.css("max-width", d.cx), g = {cx: this._ui.container.outerWidth(!0), cy: this._ui.container.outerHeight(!0)}, h = {x: e(d.cx, g.cx, d.x, a.x), y: e(d.cy, g.cy, d.y, a.y)}, h.y = Math.max(0, h.y);
            var i = c.documentElement, j = c.body, k = Math.max(i.clientHeight, j.scrollHeight, j.offsetHeight, i.scrollHeight, i.offsetHeight);
            return h.y -= Math.min(h.y, Math.max(0, h.y + g.cy - k)), {left: h.x, top: h.y}
        }, _createPrereqs: function (b, c, d) {
            var e = this, f;
            f = {screen: a.Deferred(), container: a.Deferred()}, f.screen.then(function () {
                f === e._prereqs && b()
            }), f.container.then(function () {
                f === e._prereqs && c()
            }), a.when(f.screen, f.container).done(function () {
                f === e._prereqs && (e._prereqs = null, d())
            }), e._prereqs = f
        }, _animate: function (b) {
            this._ui.screen.removeClass(b.classToRemove).addClass(b.screenClassToAdd), b.prereqs.screen.resolve(), b.transition && b.transition !== "none" ? (b.applyTransition && this._applyTransition(b.transition), this._ui.container.animationComplete(a.proxy(b.prereqs.container, "resolve")).addClass(b.containerClassToAdd).removeClass(b.classToRemove)) : b.prereqs.container.resolve()
        }, _desiredCoords: function (b, c, d) {
            var e = null, g, h = f();
            if (d && d !== "origin")if (d === "window")b = h.cx / 2 + h.x, c = h.cy / 2 + h.y; else {
                try {
                    e = a(d)
                } catch (i) {
                    e = null
                }
                e && (e.filter(":visible"), e.length === 0 && (e = null))
            }
            e && (g = e.offset(), b = g.left + e.outerWidth() / 2, c = g.top + e.outerHeight() / 2);
            if (a.type(b) !== "number" || isNaN(b))b = h.cx / 2 + h.x;
            if (a.type(c) !== "number" || isNaN(c))c = h.cy / 2 + h.y;
            return{x: b, y: c}
        }, _openPrereqsComplete: function () {
            var a = this;
            a._ui.container.addClass("ui-popup-active"), a._isOpen = !0, a._resizeScreen(), setTimeout(function () {
                a._ui.container.attr("tabindex", "0").focus(), a._trigger("afteropen")
            })
        }, _open: function (c) {
            var d, e, f = function () {
                var a = b, c = navigator.userAgent, d = c.match(/AppleWebKit\/([0-9\.]+)/), e = !!d && d[1], f = c.match(/Android (\d+(?:\.\d+))/), g = !!f && f[1], h = c.indexOf("Chrome") > -1;
                return f !== null && g === "4.0" && e && e > 534.13 && !h ? !0 : !1
            }();
            c = c || {}, e = c.transition || this.options.transition, this._trigger("beforeposition"), d = this._placementCoords(this._desiredCoords(c.x, c.y, c.positionTo || this.options.positionTo || "origin")), this._createPrereqs(a.noop, a.noop, a.proxy(this, "_openPrereqsComplete")), e ? (this._currentTransition = e, this._applyTransition(e)) : e = this.options.transition, this.options.theme || this._setTheme(this._page.jqmData("theme") || a.mobile.getInheritedTheme(this._page, "c")), this._ui.screen.removeClass("ui-screen-hidden"), this._ui.container.removeClass("ui-selectmenu-hidden").offset(d), this.options.overlayTheme && f && this.element.closest(".ui-page").addClass("ui-popup-open"), this._animate({additionalCondition: !0, transition: e, classToRemove: "", screenClassToAdd: "in", containerClassToAdd: "in", applyTransition: !1, prereqs: this._prereqs})
        }, _closePrereqScreen: function () {
            this._ui.screen.removeClass("out").addClass("ui-screen-hidden")
        }, _closePrereqContainer: function () {
            this._ui.container.removeClass("reverse out").addClass("ui-selectmenu-hidden").removeAttr("style")
        }, _closePrereqsDone: function () {
            var b = this, c = b.options;
            b._ui.container.removeAttr("tabindex"), c.container.unbind(c.closeEvents), b.element.undelegate(c.closeLinkSelector, c.closeLinkEvents), a.mobile.popup.active = d, b._trigger("afterclose")
        }, _close: function () {
            this._ui.container.removeClass("ui-popup-active"), this._page.removeClass("ui-popup-open"), this._isOpen = !1, this._createPrereqs(a.proxy(this, "_closePrereqScreen"), a.proxy(this, "_closePrereqContainer"), a.proxy(this, "_closePrereqsDone")), this._animate({additionalCondition: this._ui.screen.hasClass("in"), transition: this._currentTransition || this.options.transition, classToRemove: "in", screenClassToAdd: "out", containerClassToAdd: "reverse out", applyTransition: !0, prereqs: this._prereqs})
        }, _destroy: function () {
            var b = this;
            b._close(), b._setTheme("none"), b.element.insertAfter(b._ui.placeholder).removeClass("ui-popup ui-overlay-shadow ui-corner-all"), b._ui.screen.remove(), b._ui.container.remove(), b._ui.placeholder.remove(), a.each(b._globalHandlers, function (b, c) {
                a.each(c.handler, function (a, b) {
                    c.src.unbind(a, b)
                })
            })
        }, _bindContainerClose: function () {
            var b = this;
            b.options.container.one(b.options.closeEvents, a.proxy(b._close, b))
        }, open: function (b) {
            var c = this, e = this.options, f, g, h, i, j, k;
            if (a.mobile.popup.active)return;
            a.mobile.popup.active = this;
            if (!e.history) {
                c._open(b), c._bindContainerClose(), c.element.delegate(e.closeLinkSelector, e.closeLinkEvents, function (a) {
                    return c._close(), !1
                });
                return
            }
            g = a.mobile.dialogHashKey, h = a.mobile.activePage, i = h.is(".ui-dialog"), f = a.mobile.urlHistory.getActive().url, j = f.indexOf(g) > -1 && !i, k = a.mobile.urlHistory;
            if (j) {
                c._open(b), c._bindContainerClose();
                return
            }
            f.indexOf(g) === -1 && !i ? f += g : f = a.mobile.path.parseLocation().hash + g, k.activeIndex === 0 && f === k.initialDst && (f += g), e.container.one(e.navigateEvents, function (a) {
                a.preventDefault(), c._open(b), c._bindContainerClose()
            }), k.ignoreNextHashChange = i, k.addNew(f, d, d, d, "dialog"), a.mobile.path.set(f)
        }, close: function () {
            if (!a.mobile.popup.active)return;
            this.options.history ? a.mobile.back() : this._close()
        }}), a.mobile.popup.handleLink = function (b) {
            var c = b.closest(":jqmData(role='page')"), d = c.length === 0 ? a("body") : c, e = a(a.mobile.path.parseUrl(b.attr("href")).hash, d[0]), f;
            e.data("popup") && (f = b.offset(), e.popup("open", {x: f.left + b.outerWidth() / 2, y: f.top + b.outerHeight() / 2, transition: b.jqmData("transition"), positionTo: b.jqmData("position-to"), link: b})), setTimeout(function () {
                b.removeClass(a.mobile.activeBtnClass)
            }, 300)
        }, a(c).bind("pagebeforechange", function (b, c) {
            c.options.role === "popup" && (a.mobile.popup.handleLink(c.options.link), b.preventDefault())
        }), a(c).bind("pagecreate create", function (b) {
            a.mobile.popup.prototype.enhanceWithin(b.target, !0)
        })
    }(a), function (a) {
        var b = a("meta[name=viewport]"), c = b.attr("content"), d = c + ",maximum-scale=1, user-scalable=no", e = c + ",maximum-scale=10, user-scalable=yes", f = /(user-scalable[\s]*=[\s]*no)|(maximum-scale[\s]*=[\s]*1)[$,\s]/.test(c);
        a.mobile.zoom = a.extend({}, {enabled: !f, locked: !1, disable: function (c) {
            !f && !a.mobile.zoom.locked && (b.attr("content", d), a.mobile.zoom.enabled = !1, a.mobile.zoom.locked = c || !1)
        }, enable: function (c) {
            !f && (!a.mobile.zoom.locked || c === !0) && (b.attr("content", e), a.mobile.zoom.enabled = !0, a.mobile.zoom.locked = !1)
        }, restore: function () {
            f || (b.attr("content", c), a.mobile.zoom.enabled = !0)
        }})
    }(a), function (a, d) {
        a.widget("mobile.textinput", a.mobile.widget, {options: {theme: null, preventFocusZoom: /iPhone|iPad|iPod/.test(navigator.platform) && navigator.userAgent.indexOf("AppleWebKit") > -1, initSelector: "input[type='text'], input[type='search'], :jqmData(type='search'), input[type='number'], :jqmData(type='number'), input[type='password'], input[type='email'], input[type='url'], input[type='tel'], textarea, input[type='time'], input[type='date'], input[type='month'], input[type='week'], input[type='datetime'], input[type='datetime-local'], input[type='color'], input:not([type])", clearSearchButtonText: "clear text", disabled: !1}, _create: function () {
            function m() {
                setTimeout(function () {
                    l.toggleClass("ui-input-clear-hidden", !e.val())
                }, 0)
            }

            var d = this, e = this.element, f = this.options, g = f.theme || a.mobile.getInheritedTheme(this.element, "c"), h = " ui-body-" + g, i = e.jqmData("mini") === !0, j = i ? " ui-mini" : "", k, l;
            a("label[for='" + e.attr("id") + "']").addClass("ui-input-text"), k = e.addClass("ui-input-text ui-body-" + g), typeof e[0].autocorrect != "undefined" && !a.support.touchOverflow && (e[0].setAttribute("autocorrect", "off"), e[0].setAttribute("autocomplete", "off")), e.is("[type='search'],:jqmData(type='search')") ? (k = e.wrap("<div class='ui-input-search ui-shadow-inset ui-btn-corner-all ui-btn-shadow ui-icon-searchfield" + h + j + "'></div>").parent(), l = a("<a href='#' class='ui-input-clear' title='" + f.clearSearchButtonText + "'>" + f.clearSearchButtonText + "</a>").bind("click",function (a) {
                e.val("").focus().trigger("change"), l.addClass("ui-input-clear-hidden"), a.preventDefault()
            }).appendTo(k).buttonMarkup({icon: "delete", iconpos: "notext", corners: !0, shadow: !0, mini: i}), m(), e.bind("paste cut keyup focus change blur", m)) : e.addClass("ui-corner-all ui-shadow-inset" + h + j), e.focus(function () {
                k.addClass(a.mobile.focusClass)
            }).blur(function () {
                k.removeClass(a.mobile.focusClass)
            }).bind("focus",function () {
                f.preventFocusZoom && a.mobile.zoom.disable(!0)
            }).bind("blur", function () {
                f.preventFocusZoom && a.mobile.zoom.enable(!0)
            });
            if (e.is("textarea")) {
                var n = 15, o = 100, p;
                this._keyup = function () {
                    var a = e[0].scrollHeight, b = e[0].clientHeight;
                    b < a && e.height(a + n)
                }, e.keyup(function () {
                    clearTimeout(p), p = setTimeout(d._keyup, o)
                }), this._on(a(c), {pagechange: "_keyup"}), a.trim(e.val()) && this._on(a(b), {load: "_keyup"})
            }
            e.attr("disabled") && this.disable()
        }, disable: function () {
            var a;
            return this.element.attr("disabled", !0).is("[type='search'], :jqmData(type='search')") ? a = this.element.parent() : a = this.element, a.addClass("ui-disabled"), this._setOption("disabled", !0)
        }, enable: function () {
            var a;
            return this.element.attr("disabled", !1).is("[type='search'], :jqmData(type='search')") ? a = this.element.parent() : a = this.element, a.removeClass("ui-disabled"), this._setOption("disabled", !1)
        }}), a(c).bind("pagecreate create", function (b) {
            a.mobile.textinput.prototype.enhanceWithin(b.target, !0)
        })
    }(a), function (a, b) {
        a.mobile.listview.prototype.options.filter = !1, a.mobile.listview.prototype.options.filterPlaceholder = "Filter items...", a.mobile.listview.prototype.options.filterTheme = "c";
        var d = function (a, b, c) {
            return a.toString().toLowerCase().indexOf(b) === -1
        };
        a.mobile.listview.prototype.options.filterCallback = d, a(c).delegate(":jqmData(role='listview')", "listviewcreate", function () {
            var b = a(this), c = b.data("listview");
            if (!c.options.filter)return;
            var e = a("<form>", {"class": "ui-listview-filter ui-bar-" + c.options.filterTheme, role: "search"}), f = a("<input>", {placeholder: c.options.filterPlaceholder}).attr("data-" + a.mobile.ns + "type", "search").jqmData("lastval", "").bind("keyup change",function () {
                var e = a(this), f = this.value.toLowerCase(), g = null, h = e.jqmData("lastval") + "", i = !1, j = "", k, l = c.options.filterCallback !== d;
                c._trigger("beforefilter", "beforefilter", {input: this}), e.jqmData("lastval", f), l || f.length < h.length || f.indexOf(h) !== 0 ? g = b.children() : g = b.children(":not(.ui-screen-hidden)");
                if (f) {
                    for (var m = g.length - 1; m >= 0; m--)k = a(g[m]), j = k.jqmData("filtertext") || k.text(), k.is("li:jqmData(role=list-divider)") ? (k.toggleClass("ui-filter-hidequeue", !i), i = !1) : c.options.filterCallback(j, f, k) ? k.toggleClass("ui-filter-hidequeue", !0) : i = !0;
                    g.filter(":not(.ui-filter-hidequeue)").toggleClass("ui-screen-hidden", !1), g.filter(".ui-filter-hidequeue").toggleClass("ui-screen-hidden", !0).toggleClass("ui-filter-hidequeue", !1)
                } else g.toggleClass("ui-screen-hidden", !1);
                c._refreshCorners()
            }).appendTo(e).textinput();
            c.options.inset && e.addClass("ui-listview-filter-inset"), e.bind("submit",function () {
                return!1
            }).insertBefore(b)
        })
    }(a), function (a, d) {
        a.widget("mobile.slider", a.mobile.widget, {widgetEventPrefix: "slide", options: {theme: null, trackTheme: null, disabled: !1, initSelector: "input[type='range'], :jqmData(type='range'), :jqmData(role='slider')", mini: !1}, _create: function () {
            var e = this, f = this.element, g = a.mobile.getInheritedTheme(f, "c"), h = this.options.theme || g, i = this.options.trackTheme || g, j = f[0].nodeName.toLowerCase(), k = j === "select" ? "ui-slider-switch" : "", l = f.attr("id"), m = a("[for='" + l + "']"), n = m.attr("id") || l + "-label", o = m.attr("id", n), p = function () {
                return j === "input" ? parseFloat(f.val()) : f[0].selectedIndex
            }, q = j === "input" ? parseFloat(f.attr("min")) : 0, r = j === "input" ? parseFloat(f.attr("max")) : f.find("option").length - 1, s = b.parseFloat(f.attr("step") || 1), t = this.options.inline || f.jqmData("inline") === !0 ? " ui-slider-inline" : "", u = this.options.mini || f.jqmData("mini") ? " ui-slider-mini" : "", v = c.createElement("a"), w = a(v), x = c.createElement("div"), y = a(x), z = f.jqmData("highlight") && j !== "select" ? function () {
                var b = c.createElement("div");
                return b.className = "ui-slider-bg " + a.mobile.activeBtnClass + " ui-btn-corner-all", a(b).prependTo(y)
            }() : !1, A;
            this._type = j, v.setAttribute("href", "#"), x.setAttribute("role", "application"), x.className = ["ui-slider ", k, " ui-btn-down-", i, " ui-btn-corner-all", t, u].join(""), v.className = "ui-slider-handle", x.appendChild(v), w.buttonMarkup({corners: !0, theme: h, shadow: !0}).attr({role: "slider", "aria-valuemin": q, "aria-valuemax": r, "aria-valuenow": p(), "aria-valuetext": p(), title: p(), "aria-labelledby": n}), a.extend(this, {slider: y, handle: w, valuebg: z, dragging: !1, beforeStart: null, userModified: !1, mouseMoved: !1});
            if (j === "select") {
                var B = c.createElement("div");
                B.className = "ui-slider-inneroffset";
                for (var C = 0, D = x.childNodes.length; C < D; C++)B.appendChild(x.childNodes[C]);
                x.appendChild(B), w.addClass("ui-slider-handle-snapping"), A = f.find("option");
                for (var E = 0, F = A.length; E < F; E++) {
                    var G = E ? "a" : "b", H = E ? " " + a.mobile.activeBtnClass : " ui-btn-down-" + i, I = c.createElement("div"), J = c.createElement("span");
                    J.className = ["ui-slider-label ui-slider-label-", G, H, " ui-btn-corner-all"].join(""), J.setAttribute("role", "img"), J.appendChild(c.createTextNode(A[E].innerHTML)), a(J).prependTo(y)
                }
                e._labels = a(".ui-slider-label", y)
            }
            o.addClass("ui-slider"), f.addClass(j === "input" ? "ui-slider-input" : "ui-slider-switch").change(function () {
                e.mouseMoved || e.refresh(p(), !0)
            }).keyup(function () {
                e.refresh(p(), !0, !0)
            }).blur(function () {
                e.refresh(p(), !0)
            }), this._preventDocumentDrag = function (a) {
                if (e.dragging && !e.options.disabled)return e.mouseMoved = !0, j === "select" && w.removeClass("ui-slider-handle-snapping"), e.refresh(a), e.userModified = e.beforeStart !== f[0].selectedIndex, !1
            }, this._on(a(c), {vmousemove: this._preventDocumentDrag}), f.bind("vmouseup", a.proxy(e._checkedRefresh, e)), y.bind("vmousedown",function (a) {
                return e.options.disabled ? !1 : (e.dragging = !0, e.userModified = !1, e.mouseMoved = !1, j === "select" && (e.beforeStart = f[0].selectedIndex), e.refresh(a), e._trigger("start"), !1)
            }).bind("vclick", !1), this._sliderMouseUp = function () {
                if (e.dragging)return e.dragging = !1, j === "select" && (w.addClass("ui-slider-handle-snapping"), e.mouseMoved ? e.userModified ? e.refresh(e.beforeStart === 0 ? 1 : 0) : e.refresh(e.beforeStart) : e.refresh(e.beforeStart === 0 ? 1 : 0)), e.mouseMoved = !1, e._trigger("stop"), !1
            }, this._on(y.add(c), {vmouseup: this._sliderMouseUp}), y.insertAfter(f), j === "select" && this.handle.bind({focus: function () {
                y.addClass(a.mobile.focusClass)
            }, blur: function () {
                y.removeClass(a.mobile.focusClass)
            }}), this.handle.bind({vmousedown: function () {
                a(this).focus()
            }, vclick: !1, keydown: function (b) {
                var c = p();
                if (e.options.disabled)return;
                switch (b.keyCode) {
                    case a.mobile.keyCode.HOME:
                    case a.mobile.keyCode.END:
                    case a.mobile.keyCode.PAGE_UP:
                    case a.mobile.keyCode.PAGE_DOWN:
                    case a.mobile.keyCode.UP:
                    case a.mobile.keyCode.RIGHT:
                    case a.mobile.keyCode.DOWN:
                    case a.mobile.keyCode.LEFT:
                        b.preventDefault(), e._keySliding || (e._keySliding = !0, a(this).addClass("ui-state-active"))
                }
                switch (b.keyCode) {
                    case a.mobile.keyCode.HOME:
                        e.refresh(q);
                        break;
                    case a.mobile.keyCode.END:
                        e.refresh(r);
                        break;
                    case a.mobile.keyCode.PAGE_UP:
                    case a.mobile.keyCode.UP:
                    case a.mobile.keyCode.RIGHT:
                        e.refresh(c + s);
                        break;
                    case a.mobile.keyCode.PAGE_DOWN:
                    case a.mobile.keyCode.DOWN:
                    case a.mobile.keyCode.LEFT:
                        e.refresh(c - s)
                }
            }, keyup: function (b) {
                e._keySliding && (e._keySliding = !1, a(this).removeClass("ui-state-active"))
            }}), this.refresh(d, d, !0)
        }, _checkedRefresh: function () {
            this.value != this._value() && this.refresh(this._value())
        }, _value: function () {
            return this._type === "input" ? parseFloat(this.element.val()) : this.element[0].selectedIndex
        }, refresh: function (b, c, d) {
            (this.options.disabled || this.element.attr("disabled")) && this.disable(), this.value = this._value();
            var e = this.element, f, g = e[0].nodeName.toLowerCase(), h = g === "input" ? parseFloat(e.attr("min")) : 0, i = g === "input" ? parseFloat(e.attr("max")) : e.find("option").length - 1, j = g === "input" && parseFloat(e.attr("step")) > 0 ? parseFloat(e.attr("step")) : 1;
            if (typeof b == "object") {
                var k = b, l = 8;
                if (!this.dragging || k.pageX < this.slider.offset().left - l || k.pageX > this.slider.offset().left + this.slider.width() + l)return;
                f = Math.round((k.pageX - this.slider.offset().left) / this.slider.width() * 100)
            } else b == null && (b = g === "input" ? parseFloat(e.val() || 0) : e[0].selectedIndex), f = (parseFloat(b) - h) / (i - h) * 100;
            if (isNaN(f))return;
            f < 0 && (f = 0), f > 100 && (f = 100);
            var m = f / 100 * (i - h) + h, n = (m - h) % j, o = m - n;
            Math.abs(n) * 2 >= j && (o += n > 0 ? j : -j), m = parseFloat(o.toFixed(5)), m < h && (m = h), m > i && (m = i), this.handle.css("left", f + "%"), this.handle.attr({"aria-valuenow": g === "input" ? m : e.find("option").eq(m).attr("value"), "aria-valuetext": g === "input" ? m : e.find("option").eq(m).getEncodedText(), title: g === "input" ? m : e.find("option").eq(m).getEncodedText()}), this.valuebg && this.valuebg.css("width", f + "%");
            if (this._labels) {
                var p = this.handle.width() / this.slider.width() * 100, q = f && p + (100 - p) * f / 100, r = f === 100 ? 0 : Math.min(p + 100 - q, 100);
                this._labels.each(function () {
                    var b = a(this).is(".ui-slider-label-a");
                    a(this).width((b ? q : r) + "%")
                })
            }
            if (!d) {
                var s = !1;
                g === "input" ? (s = e.val() !== m, e.val(m)) : (s = e[0].selectedIndex !== m, e[0].selectedIndex = m), !c && s && e.trigger("change")
            }
        }, enable: function () {
            return this.element.attr("disabled", !1), this.slider.removeClass("ui-disabled").attr("aria-disabled", !1), this._setOption("disabled", !1)
        }, disable: function () {
            return this.element.attr("disabled", !0), this.slider.addClass("ui-disabled").attr("aria-disabled", !0), this._setOption("disabled", !0)
        }}), a(c).bind("pagecreate create", function (b) {
            a.mobile.slider.prototype.enhanceWithin(b.target, !0)
        })
    }(a), function (a, d) {
        a.widget("mobile.selectmenu", a.mobile.widget, {options: {theme: null, disabled: !1, icon: "arrow-d", iconpos: "right", inline: !1, corners: !0, shadow: !0, iconshadow: !0, overlayTheme: "a", hidePlaceholderMenuItems: !0, closeText: "Close", nativeMenu: !0, preventFocusZoom: /iPhone|iPad|iPod/.test(navigator.platform) && navigator.userAgent.indexOf("AppleWebKit") > -1, initSelector: "select:not( :jqmData(role='slider') )", mini: !1}, _button: function () {
            return a("<div/>")
        }, _setDisabled: function (a) {
            return this.element.attr("disabled", a), this.button.attr("aria-disabled", a), this._setOption("disabled", a)
        }, _focusButton: function () {
            var a = this;
            setTimeout(function () {
                a.button.focus()
            }, 40)
        }, _selectOptions: function () {
            return this.select.find("option")
        }, _preExtension: function () {
            var b = "";
            !~this.element[0].className.indexOf("ui-btn-left") || (b = " ui-btn-left"), !~this.element[0].className.indexOf("ui-btn-right") || (b = " ui-btn-right"), this.select = this.element.wrap("<div class='ui-select" + b + "'>"), this.selectID = this.select.attr("id"), this.label = a("label[for='" + this.selectID + "']").addClass("ui-select"), this.isMultiple = this.select[0].multiple, this.options.theme || (this.options
                .theme = a.mobile.getInheritedTheme(this.select, "c"))
        }, _create: function () {
            this._preExtension(), this._trigger("beforeCreate"), this.button = this._button();
            var c = this, d = this.options, e = d.inline || this.select.jqmData("inline"), f = d.mini || this.select.jqmData("mini"), g = d.icon ? d.iconpos || this.select.jqmData("iconpos") : !1, h = this.select[0].selectedIndex === -1 ? 0 : this.select[0].selectedIndex, i = this.button.insertBefore(this.select).buttonMarkup({theme: d.theme, icon: d.icon, iconpos: g, inline: e, corners: d.corners, shadow: d.shadow, iconshadow: d.iconshadow, mini: f});
            this.setButtonText(), d.nativeMenu && b.opera && b.opera.version && i.addClass("ui-select-nativeonly"), this.isMultiple && (this.buttonCount = a("<span>").addClass("ui-li-count ui-btn-up-c ui-btn-corner-all").hide().appendTo(i.addClass("ui-li-has-count"))), (d.disabled || this.element.attr("disabled")) && this.disable(), this.select.change(function () {
                c.refresh()
            }), this.build()
        }, build: function () {
            var b = this;
            this.select.appendTo(b.button).bind("vmousedown",function () {
                b.button.addClass(a.mobile.activeBtnClass)
            }).bind("focus",function () {
                b.button.addClass(a.mobile.focusClass)
            }).bind("blur",function () {
                b.button.removeClass(a.mobile.focusClass)
            }).bind("focus vmouseover",function () {
                b.button.trigger("vmouseover")
            }).bind("vmousemove",function () {
                b.button.removeClass(a.mobile.activeBtnClass)
            }).bind("change blur vmouseout",function () {
                b.button.trigger("vmouseout").removeClass(a.mobile.activeBtnClass)
            }).bind("change blur", function () {
                b.button.removeClass("ui-btn-down-" + b.options.theme)
            }), b.button.bind("vmousedown",function () {
                b.options.preventFocusZoom && a.mobile.zoom.disable(!0)
            }).bind("mouseup", function () {
                b.options.preventFocusZoom && setTimeout(function () {
                    a.mobile.zoom.enable(!0)
                }, 0)
            })
        }, selected: function () {
            return this._selectOptions().filter(":selected")
        }, selectedIndices: function () {
            var a = this;
            return this.selected().map(function () {
                return a._selectOptions().index(this)
            }).get()
        }, setButtonText: function () {
            var b = this, d = this.selected(), e = this.placeholder, f = a(c.createElement("span"));
            this.button.find(".ui-btn-text").html(function () {
                return d.length ? e = d.map(function () {
                    return a(this).text()
                }).get().join(", ") : e = b.placeholder, f.text(e).addClass(b.select.attr("class")).addClass(d.attr("class"))
            })
        }, setButtonCount: function () {
            var a = this.selected();
            this.isMultiple && this.buttonCount[a.length > 1 ? "show" : "hide"]().text(a.length)
        }, refresh: function () {
            this.setButtonText(), this.setButtonCount()
        }, open: a.noop, close: a.noop, disable: function () {
            this._setDisabled(!0), this.button.addClass("ui-disabled")
        }, enable: function () {
            this._setDisabled(!1), this.button.removeClass("ui-disabled")
        }}), a(c).bind("pagecreate create", function (b) {
            a.mobile.selectmenu.prototype.enhanceWithin(b.target, !0)
        })
    }(a), function (a, d) {
        var e = function (d) {
            var e = d.select, f = d.selectID, g = d.label, h = d.select.closest(".ui-page"), i = d._selectOptions(), j = d.isMultiple = d.select[0].multiple, k = f + "-button", l = f + "-menu", m = a("<div data-" + a.mobile.ns + "role='dialog' data-" + a.mobile.ns + "theme='" + d.options.theme + "' data-" + a.mobile.ns + "overlay-theme='" + d.options.overlayTheme + "'>" + "<div data-" + a.mobile.ns + "role='header'>" + "<div class='ui-title'>" + g.getEncodedText() + "</div>" + "</div>" + "<div data-" + a.mobile.ns + "role='content'></div>" + "</div>"), n = a("<div>", {"class": "ui-selectmenu"}).insertAfter(d.select).popup({theme: "a"}), o = a("<ul>", {"class": "ui-selectmenu-list", id: l, role: "listbox", "aria-labelledby": k}).attr("data-" + a.mobile.ns + "theme", d.options.theme).appendTo(n), p = a("<div>", {"class": "ui-header ui-bar-" + d.options.theme}).prependTo(n), q = a("<h1>", {"class": "ui-title"}).appendTo(p), r, s, t;
            d.isMultiple && (t = a("<a>", {text: d.options.closeText, href: "#", "class": "ui-btn-left"}).attr("data-" + a.mobile.ns + "iconpos", "notext").attr("data-" + a.mobile.ns + "icon", "delete").appendTo(p).buttonMarkup()), a.extend(d, {select: d.select, selectID: f, buttonId: k, menuId: l, thisPage: h, menuPage: m, label: g, selectOptions: i, isMultiple: j, theme: d.options.theme, listbox: n, list: o, header: p, headerTitle: q, headerClose: t, menuPageContent: r, menuPageClose: s, placeholder: "", build: function () {
                var b = this;
                b.refresh(), b.select.attr("tabindex", "-1").focus(function () {
                    a(this).blur(), b.button.focus()
                }), b.button.bind("vclick keydown", function (c) {
                    if (c.type === "vclick" || c.keyCode && (c.keyCode === a.mobile.keyCode.ENTER || c.keyCode === a.mobile.keyCode.SPACE))b.open(), c.preventDefault()
                }), b.list.attr("role", "listbox").bind("focusin",function (b) {
                    a(b.target).attr("tabindex", "0").trigger("vmouseover")
                }).bind("focusout",function (b) {
                    a(b.target).attr("tabindex", "-1").trigger("vmouseout")
                }).delegate("li:not(.ui-disabled, .ui-li-divider)", "click",function (c) {
                    var e = b.select[0].selectedIndex, f = b.list.find("li:not(.ui-li-divider)").index(this), g = b._selectOptions().eq(f)[0];
                    g.selected = b.isMultiple ? !g.selected : !0, b.isMultiple && a(this).find(".ui-icon").toggleClass("ui-icon-checkbox-on", g.selected).toggleClass("ui-icon-checkbox-off", !g.selected), (b.isMultiple || e !== f) && b.select.trigger("change"), b.isMultiple ? b.list.find("li:not(.ui-li-divider)").eq(f).addClass("ui-btn-down-" + d.options.theme).find("a").first().focus() : b.close(), c.preventDefault()
                }).keydown(function (b) {
                    var c = a(b.target), e = c.closest("li"), f, g;
                    switch (b.keyCode) {
                        case 38:
                            return f = e.prev().not(".ui-selectmenu-placeholder"), f.is(".ui-li-divider") && (f = f.prev()), f.length && (c.blur().attr("tabindex", "-1"), f.addClass("ui-btn-down-" + d.options.theme).find("a").first().focus()), !1;
                        case 40:
                            return g = e.next(), g.is(".ui-li-divider") && (g = g.next()), g.length && (c.blur().attr("tabindex", "-1"), g.addClass("ui-btn-down-" + d.options.theme).find("a").first().focus()), !1;
                        case 13:
                        case 32:
                            return c.trigger("click"), !1
                    }
                }), b.menuPage.bind("pagehide", function () {
                    b.list.appendTo(b.listbox), b._focusButton(), a.mobile._bindPageRemove.call(b.thisPage)
                }), b.listbox.bind("popupafterclose", function (a) {
                    b.close()
                }), b.isMultiple && b.headerClose.click(function () {
                    if (b.menuType === "overlay")return b.close(), !1
                }), b.thisPage.addDependents(this.menuPage)
            }, _isRebuildRequired: function () {
                var a = this.list.find("li"), b = this._selectOptions();
                return b.text() !== a.text()
            }, selected: function () {
                return this._selectOptions().filter(":selected:not( :jqmData(placeholder='true') )")
            }, refresh: function (b, c) {
                var d = this, e = this.element, f = this.isMultiple, g;
                (b || this._isRebuildRequired()) && d._buildList(), g = this.selectedIndices(), d.setButtonText(), d.setButtonCount(), d.list.find("li:not(.ui-li-divider)").removeClass(a.mobile.activeBtnClass).attr("aria-selected", !1).each(function (b) {
                    if (a.inArray(b, g) > -1) {
                        var c = a(this);
                        c.attr("aria-selected", !0), d.isMultiple ? c.find(".ui-icon").removeClass("ui-icon-checkbox-off").addClass("ui-icon-checkbox-on") : c.is(".ui-selectmenu-placeholder") ? c.next().addClass(a.mobile.activeBtnClass) : c.addClass(a.mobile.activeBtnClass)
                    }
                })
            }, close: function () {
                if (this.options.disabled || !this.isOpen)return;
                var b = this;
                b.menuType === "page" ? a.mobile.back() : (b.listbox.popup("close"), b.list.appendTo(b.listbox), b._focusButton()), b.isOpen = !1
            }, open: function () {
                function o() {
                    var b = c.list.find("." + a.mobile.activeBtnClass + " a");
                    b.length === 0 && (b = c.list.find("li.ui-btn:not( :jqmData(placeholder='true') ) a")), b.first().focus().closest("li").addClass("ui-btn-down-" + d.options.theme)
                }

                if (this.options.disabled)return;
                var c = this, e = a(b), f = c.list.parent(), g = f.outerHeight(), h = f.outerWidth(), i = a("." + a.mobile.activePageClass), j = e.scrollTop(), k = c.button.offset().top, l = e.height(), n = e.width();
                c.button.addClass(a.mobile.activeBtnClass), setTimeout(function () {
                    c.button.removeClass(a.mobile.activeBtnClass)
                }, 300), g > l - 80 || !a.support.scrollTop ? (c.menuPage.appendTo(a.mobile.pageContainer).page(), c.menuPageContent = m.find(".ui-content"), c.menuPageClose = m.find(".ui-header a"), c.thisPage.unbind("pagehide.remove"), j === 0 && k > l && c.thisPage.one("pagehide", function () {
                    a(this).jqmData("lastScroll", k)
                }), c.menuPage.one("pageshow", function () {
                    o(), c.isOpen = !0
                }), c.menuType = "page", c.menuPageContent.append(c.list), c.menuPage.find("div .ui-title").text(c.label.text()), a.mobile.changePage(c.menuPage, {transition: a.mobile.defaultDialogTransition})) : (c.menuType = "overlay", c.listbox.one("popupafteropen", o).popup("open", {x: c.button.offset().left + c.button.outerWidth() / 2, y: c.button.offset().top + c.button.outerHeight() / 2}), c.isOpen = !0)
            }, _buildList: function () {
                var b = this, d = this.options, e = this.placeholder, f = !0, g = [], h = [], i = b.isMultiple ? "checkbox-off" : "false";
                b.list.empty().filter(".ui-listview").listview("destroy");
                var j = b.select.find("option"), k = j.length, l = this.select[0], m = "data-" + a.mobile.ns, n = m + "option-index", o = m + "icon", p = m + "role", q = m + "placeholder", r = c.createDocumentFragment(), s = !1, t;
                for (var u = 0; u < k; u++, s = !1) {
                    var v = j[u], w = a(v), x = v.parentNode, y = w.text(), z = c.createElement("a"), A = [];
                    z.setAttribute("href", "#"), z.appendChild(c.createTextNode(y));
                    if (x !== l && x.nodeName.toLowerCase() === "optgroup") {
                        var B = x.getAttribute("label");
                        if (B !== t) {
                            var C = c.createElement("li");
                            C.setAttribute(p, "list-divider"), C.setAttribute("role", "option"), C.setAttribute("tabindex", "-1"), C.appendChild(c.createTextNode(B)), r.appendChild(C), t = B
                        }
                    }
                    f && (!v.getAttribute("value") || y.length === 0 || w.jqmData("placeholder")) && (f = !1, s = !0, v.setAttribute(q, !0), d.hidePlaceholderMenuItems && A.push("ui-selectmenu-placeholder"), e || (e = b.placeholder = y));
                    var D = c.createElement("li");
                    v.disabled && (A.push("ui-disabled"), D.setAttribute("aria-disabled", !0)), D.setAttribute(n, u), D.setAttribute(o, i), s && D.setAttribute(q, !0), D.className = A.join(" "), D.setAttribute("role", "option"), z.setAttribute("tabindex", "-1"), D.appendChild(z), r.appendChild(D)
                }
                b.list[0].appendChild(r), !this.isMultiple && !e.length ? this.header.hide() : this.headerTitle.text(this.placeholder), b.list.listview()
            }, _button: function () {
                return a("<a>", {href: "#", role: "button", id: this.buttonId, "aria-haspopup": "true", "aria-owns": this.menuId})
            }})
        };
        a(c).bind("selectmenubeforecreate", function (b) {
            var c = a(b.target).data("selectmenu");
            !c.options.nativeMenu && c.element.parents(":jqmData(role='popup')").length === 0 && e(c)
        })
    }(a), function (a, d) {
        a.widget("mobile.fixedtoolbar", a.mobile.widget, {options: {visibleOnPageShow: !0, disablePageZoom: !0, transition: "slide", fullscreen: !1, tapToggle: !0, tapToggleBlacklist: "a, button, input, select, textarea, .ui-header-fixed, .ui-footer-fixed, .ui-popup", hideDuringFocus: "input, textarea, select", updatePagePadding: !0, trackPersistentToolbars: !0, supportBlacklist: function () {
            var a = b, c = navigator.userAgent, d = navigator.platform, e = c.match(/AppleWebKit\/([0-9]+)/), f = !!e && e[1], g = c.match(/Fennec\/([0-9]+)/), h = !!g && g[1], i = c.match(/Opera Mobi\/([0-9]+)/), j = !!i && i[1];
            return(d.indexOf("iPhone") > -1 || d.indexOf("iPad") > -1 || d.indexOf("iPod") > -1) && f && f < 534 || a.operamini && {}.toString.call(a.operamini) === "[object OperaMini]" || i && j < 7458 || c.indexOf("Android") > -1 && f && f < 533 || h && h < 6 || "palmGetResource"in b && f && f < 534 || c.indexOf("MeeGo") > -1 && c.indexOf("NokiaBrowser/8.5.0") > -1 ? !0 : !1
        }, initSelector: ":jqmData(position='fixed')"}, _create: function () {
            var a = this, b = a.options, c = a.element, d = c.is(":jqmData(role='header')") ? "header" : "footer", e = c.closest(".ui-page");
            if (b.supportBlacklist()) {
                a.destroy();
                return
            }
            c.addClass("ui-" + d + "-fixed"), b.fullscreen ? (c.addClass("ui-" + d + "-fullscreen"), e.addClass("ui-page-" + d + "-fullscreen")) : e.addClass("ui-page-" + d + "-fixed"), a._addTransitionClass(), a._bindPageEvents(), a._bindToggleHandlers()
        }, _addTransitionClass: function () {
            var a = this.options.transition;
            a && a !== "none" && (a === "slide" && (a = this.element.is(".ui-header") ? "slidedown" : "slideup"), this.element.addClass(a))
        }, _bindPageEvents: function () {
            var c = this, d = c.options, e = c.element;
            e.closest(".ui-page").bind("pagebeforeshow",function () {
                d.disablePageZoom && a.mobile.zoom.disable(!0), d.visibleOnPageShow || c.hide(!0)
            }).bind("webkitAnimationStart animationstart updatelayout",function () {
                var a = this;
                d.updatePagePadding && c.updatePagePadding(a)
            }).bind("pageshow",function () {
                var e = this;
                c.updatePagePadding(e), d.updatePagePadding && a(b).bind("throttledresize." + c.widgetName, function () {
                    c.updatePagePadding(e)
                })
            }).bind("pagebeforehide", function (e, f) {
                d.disablePageZoom && a.mobile.zoom.enable(!0), d.updatePagePadding && a(b).unbind("throttledresize." + c.widgetName);
                if (d.trackPersistentToolbars) {
                    var g = a(".ui-footer-fixed:jqmData(id)", this), h = a(".ui-header-fixed:jqmData(id)", this), i = g.length && f.nextPage && a(".ui-footer-fixed:jqmData(id='" + g.jqmData("id") + "')", f.nextPage) || a(), j = h.length && f.nextPage && a(".ui-header-fixed:jqmData(id='" + h.jqmData("id") + "')", f.nextPage) || a();
                    if (i.length || j.length)i.add(j).appendTo(a.mobile.pageContainer), f.nextPage.one("pageshow", function () {
                        i.add(j).appendTo(this)
                    })
                }
            })
        }, _visible: !0, updatePagePadding: function (b) {
            var c = this.element, d = c.is(".ui-header");
            if (this.options.fullscreen)return;
            b = b || c.closest(".ui-page"), a(b).css("padding-" + (d ? "top" : "bottom"), c.outerHeight())
        }, _useTransition: function (c) {
            var d = a(b), e = this.element, f = d.scrollTop(), g = e.height(), h = e.closest(".ui-page").height(), i = a.mobile.getScreenHeight(), j = e.is(":jqmData(role='header')") ? "header" : "footer";
            return!c && (this.options.transition && this.options.transition !== "none" && (j === "header" && !this.options.fullscreen && f > g || j === "footer" && !this.options.fullscreen && f + i < h - g) || this.options.fullscreen)
        }, show: function (a) {
            var b = "ui-fixed-hidden", c = this.element;
            this._useTransition(a) ? c.removeClass("out " + b).addClass("in") : c.removeClass(b), this._visible = !0
        }, hide: function (a) {
            var b = "ui-fixed-hidden", c = this.element, d = "out" + (this.options.transition === "slide" ? " reverse" : "");
            this._useTransition(a) ? c.addClass(d).removeClass("in").animationComplete(function () {
                c.addClass(b).removeClass(d)
            }) : c.addClass(b).removeClass(d), this._visible = !1
        }, toggle: function () {
            this[this._visible ? "hide" : "show"]()
        }, _bindToggleHandlers: function () {
            var b = this, c = b.options, d = b.element;
            d.closest(".ui-page").bind("vclick",function (d) {
                c.tapToggle && !a(d.target).closest(c.tapToggleBlacklist).length && b.toggle()
            }).bind("focusin focusout", function (d) {
                screen.width < 500 && a(d.target).is(c.hideDuringFocus) && !a(d.target).closest(".ui-header-fixed, .ui-footer-fixed").length && b[d.type === "focusin" && b._visible ? "hide" : "show"]()
            })
        }, destroy: function () {
            this.element.removeClass("ui-header-fixed ui-footer-fixed ui-header-fullscreen ui-footer-fullscreen in out fade slidedown slideup ui-fixed-hidden"), this.element.closest(".ui-page").removeClass("ui-page-header-fixed ui-page-footer-fixed ui-page-header-fullscreen ui-page-footer-fullscreen")
        }}), a(c).bind("pagecreate create", function (b) {
            a(b.target).jqmData("fullscreen") && a(a.mobile.fixedtoolbar.prototype.options.initSelector, b.target).not(":jqmData(fullscreen)").jqmData("fullscreen", !0), a.mobile.fixedtoolbar.prototype.enhanceWithin(b.target)
        })
    }(a), function (a, b) {
        function i(a) {
            d = a.originalEvent, h = d.accelerationIncludingGravity, e = Math.abs(h.x), f = Math.abs(h.y), g = Math.abs(h.z), !b.orientation && (e > 7 || (g > 6 && f < 8 || g < 8 && f > 6) && e > 5) ? c.enabled && c.disable() : c.enabled || c.enable()
        }

        if (!(/iPhone|iPad|iPod/.test(navigator.platform) && navigator.userAgent.indexOf("AppleWebKit") > -1))return;
        var c = a.mobile.zoom, d, e, f, g, h;
        a(b).bind("orientationchange.iosorientationfix", c.enable).bind("devicemotion.iosorientationfix", i)
    }(a, this), function (a, b, d) {
        function h() {
            e.removeClass("ui-mobile-rendering")
        }

        var e = a("html"), f = a("head"), g = a(b);
        a(b.document).trigger("mobileinit");
        if (!a.mobile.gradeA())return;
        a.mobile.ajaxBlacklist && (a.mobile.ajaxEnabled = !1), e.addClass("ui-mobile ui-mobile-rendering"), setTimeout(h, 5e3), a.extend(a.mobile, {initializePage: function () {
            var b = a(":jqmData(role='page'), :jqmData(role='dialog')"), d = a.mobile.path.parseLocation().hash.replace("#", ""), e = c.getElementById(d);
            b.length || (b = a("body").wrapInner("<div data-" + a.mobile.ns + "role='page'></div>").children(0)), b.each(function () {
                var b = a(this);
                b.jqmData("url") || b.attr("data-" + a.mobile.ns + "url", b.attr("id") || location.pathname + location.search)
            }), a.mobile.firstPage = b.first(), a.mobile.pageContainer = b.first().parent().addClass("ui-mobile-viewport"), g.trigger("pagecontainercreate"), a.mobile.showPageLoadingMsg(), h(), !a.mobile.hashListeningEnabled || !a.mobile.path.isHashValid(location.hash) || !a(e).is(':jqmData(role="page")') && !a.mobile.path.isPath(d) && d !== a.mobile.dialogHashKey ? (a.mobile.path.isHashValid(location.hash) && (a.mobile.urlHistory.initialDst = d.replace("#", "")), a.mobile.changePage(a.mobile.firstPage, {transition: "none", reverse: !0, changeHash: !1, fromHashChange: !0})) : g.trigger("hashchange", [!0])
        }}), a.mobile.navreadyDeferred.resolve(), a(function () {
            b.scrollTo(0, 1), a.mobile.defaultHomeScroll = !a.support.scrollTop || a(b).scrollTop() === 1 ? 0 : 1, a.fn.controlgroup && a(c).bind("pagecreate create", function (b) {
                a(":jqmData(role='controlgroup')", b.target).jqmEnhanceable().controlgroup({excludeInvisible: !1})
            }), a.mobile.autoInitializePage && a.mobile.initializePage(), g.load(a.mobile.silentScroll), a.support.cssPointerEvents || a(c).delegate(".ui-disabled", "vclick", function (a) {
                a.preventDefault(), a.stopImmediatePropagation()
            })
        })
    }(a, this)
}), function () {
    $(document).bind("pageshow", function (a) {
        return $("#customer-autocomplete").autocomplete({method: "GET", icon: "arrow-r", target: $("#customer-suggestions"), source: "/service_calls/autocomplete_customer_name", callback: function (a) {
            var b;
            return b = $(a.currentTarget), $("#customer-autocomplete").val(b.text()), $("#service_call_customer_id").val(b.data("autocomplete").id), $("#service_call_address1").val(b.data("autocomplete").address1), $("#service_call_address2").val(b.data("autocomplete").address2), $("#service_call_company").val(b.data("autocomplete").company), $("#service_call_city").val(b.data("autocomplete").phone), $("#service_call_zip").val(b.data("autocomplete").zip), $("#service_call_state").val(b.data("autocomplete").state), $("#service_call_state").selectmenu("refresh"), $("#service_call_phone").val(b.data("autocomplete").phone), $("#service_call_mobile_phone").val(b.data("autocomplete").mobile_phone), $("#service_call_work_phone").val(b.data("autocomplete").work_phone), $("#service_call_email").val(b.data("autocomplete").email), $("#customer-autocomplete").autocomplete("clear")
        }, minLength: 2, transition: "fade", matchFromStart: !1, loadingHtml: '<li data-icon="none"><a href="#">Searching...</a></li>', interval: 3e3, builder: null})
    })
}.call(this), function (a) {
    "use strict";
    var b = {method: "GET", icon: "arrow-r", cancelRequests: !1, target: a(), source: null, callback: null, link: null, minLength: 0, transition: "fade", matchFromStart: !0, labelHTML: function (a) {
        return a
    }, onNoResults: function () {
        return
    }, onLoading: function () {
        return
    }, onLoadingFinished: function () {
        return
    }, termParam: "term", loadingHtml: '<li data-icon="none"><a href="#">Searching...</a></li>', interval: 0, builder: null}, c = {}, d = function (b, c, d) {
        var f;
        d.builder ? f = d.builder.apply(b.eq(0), [c, d]) : (f = [], c && a.each(c, function (b, c) {
            a.isPlainObject(c) ? f.push("<li data-icon=" + d.icon + '><a href="' + d.link + encodeURIComponent(c.value) + '" data-transition="' + d.transition + "\" data-autocomplete='" + JSON.stringify(c) + "'>" + d.labelHTML(c.label) + "</a></li>") : f.push("<li data-icon=" + d.icon + '><a href="' + d.link + encodeURIComponent(c) + '" data-transition="' + d.transition + '">' + d.labelHTML(c) + "</a></li>")
        })), a.isArray(f) && (f = f.join("")), a(d.target).html(f).listview("refresh"), d.callback !== null && a.isFunction(d.callback) && e(d), f.length > 0 ? b.trigger("targetUpdated.autocomplete") : (b.trigger("targetCleared.autocomplete"), d.onNoResults && d.onNoResults())
    }, e = function (b) {
        a("li a", a(b.target)).bind("click.autocomplete", function (a) {
            a.stopPropagation(), a.preventDefault(), b.callback(a)
        })
    }, f = function (a, b) {
        b.html("").listview("refresh").closest("fieldset").removeClass("ui-search-active"), a.trigger("targetCleared.autocomplete")
    }, g = function (b) {
        var e = a(this), h = e.attr("id"), i, j, k = e.jqmData("autocomplete"), l, m;
        Date.now || (Date.now = function () {
            return(new Date).valueOf()
        }), b && (b.keyCode === 38 ? a(".ui-btn-active", a(k.target)).removeClass("ui-btn-active").prevAll("li.ui-btn:eq(0)").addClass("ui-btn-active").length || a(".ui-btn:last", a(k.target)).addClass("ui-btn-active") : b.keyCode === 40 ? a(".ui-btn-active", a(k.target)).removeClass("ui-btn-active").nextAll("li.ui-btn:eq(0)").addClass("ui-btn-active").length || a(".ui-btn:first", a(k.target)).addClass("ui-btn-active") : b.keyCode === 13 && (a(".ui-btn-active a", a(k.target)).click().length || a(".ui-btn:first a", a(k.target)).click()));
        if (k) {
            i = e.val();
            if (k._lastText === i)return;
            k._retryTimeout && (window.clearTimeout(k._retryTimeout), k._retryTimeout = null);
            if (!(!b || b.keyCode !== 13 && b.keyCode !== 38 && b.keyCode !== 40))return;
            if (i.length < k.minLength)f(e, a(k.target)); else {
                if (k.interval && Date.now() - k._lastRequest < k.interval) {
                    k._retryTimeout = window.setTimeout(a.proxy(g, this), k.interval - Date.now() + k._lastRequest);
                    return
                }
                k._lastRequest = Date.now(), k._lastText = i;
                if (a.isArray(k.source))j = k.source.sort().filter(function (b) {
                    return k.matchFromStart ? (l, m = new RegExp("^" + i, "i")) : (l, m = new RegExp(i, "i")), a.isPlainObject(b) ? l = b.label : l = b, m.test(l)
                }), d(e, j, k); else if (typeof k.source == "function")k.source(i, function (a) {
                    d(e, a, k)
                }); else {
                    var n = {type: k.method, data: {}, dataType: "json", beforeSend: function (b) {
                        k.cancelRequests && (c[h] && c[h].abort(), c[h] = b), k.onLoading && k.onLoadingFinished && k.onLoading(), k.loadingHtml && (a(k.target).html(k.loadingHtml).listview("refresh"), a(k.target).closest("fieldset").addClass("ui-search-active"))
                    }, success: function (a) {
                        d(e, a, k)
                    }, complete: function () {
                        k.cancelRequests && (c[h] = null), k.onLoadingFinished && k.onLoadingFinished()
                    }};
                    if (a.isPlainObject(k.source)) {
                        k.source.callback && k.source.callback(i, n);
                        for (var o in k.source)o !== "callback" && (n[o] = k.source[o])
                    } else n.url = k.source;
                    k.termParam && (n.data[k.termParam] = i), a.ajax(n)
                }
            }
        }
    }, h = {init: function (c) {
        var d = this;
        d.jqmData("autocomplete", a.extend({}, b, c));
        var e = d.jqmData("autocomplete");
        return d.unbind("keyup.autocomplete").bind("keyup.autocomplete", g).next(".ui-input-clear").bind("click", function () {
            f(d, a(e.target))
        })
    }, update: function (b) {
        var c = this.jqmData("autocomplete");
        return c && this.jqmData("autocomplete", a.extend(c, b)), this
    }, clear: function () {
        var b = this.jqmData("autocomplete");
        return b && f(this, a(b.target)), this
    }, destroy: function () {
        var b = this.jqmData("autocomplete");
        return b && (f(this, a(b.target)), this.jqmRemoveData("autocomplete"), this.unbind(".autocomplete")), this
    }};
    a.fn.autocomplete = function (a) {
        if (h[a])return h[a].apply(this, Array.prototype.slice.call(arguments, 1));
        if (typeof a == "object" || !a)return h.init.apply(this, arguments)
    }
}(jQuery), function () {
    $(document).live("pageshow", function () {
        return $("#bom_buyer_id").selectmenu("refresh"), $("#bom_buyer_id").change(function (a) {
            var b;
            return b = $("#bom_buyer_id option:selected").data("type"), $("#bom_buyer_type").val(b)
        }), $("#material-autocomplete").autocomplete({method: "GET", icon: "arrow-r", target: $("#material-suggestions"), source: "/materials/autocomplete_material_name", callback: function (a) {
            var b;
            return b = $(a.currentTarget), $("#material-autocomplete").val(b.text()), $("#bom_material_id").val(b.data("autocomplete").id), $("#bom_price").val(b.data("autocomplete").price_cents / 100), $("#bom_cost").val(b.data("autocomplete").cost_cents / 100), $("#material-autocomplete").autocomplete("clear")
        }, minLength: 2, transition: "fade", matchFromStart: !1, loadingHtml: '<li data-icon="none"><a href="#">Searching...</a></li>', interval: 3e3, builder: null})
    })
}.call(this), function () {
    var a, b, c, d, e, f;
    a = null, d = function (b) {
        return b.data("props") ? ($(a).hide(400), a = "#" + b.data("props"), $(a).show(400)) : $(a).hide(400)
    }, f = function (a, d) {
        var e;
        return e = a.find(":selected").data("agreements"), e ? b(d, e) : c(d)
    }, b = function (b, c) {
        return b.empty(), a !== null && $(a).hide(), c.length > 1 && b.append("<option></option>"), $.each(c, function (a, c) {
            var d;
            return d = $("<option></option>"), d.attr("value", c[1]), d.text(c[0]), d.data("props", c[2]), b.append(d)
        }), e(b)
    }, e = function (a) {
        var b;
        return a.val($("#" + a.id + " option:first").val()).selectmenu("refresh"), b = a.parent("div"), b = b.parent("div"), b.show(400), b.prev("div.ui-block-a").show(400), d(a.find(":selected"))
    }, c = function (a) {
        var b;
        return a.empty(), b = a.parent("div"), b = b.parent("div"), b.hide(400), b.prev("div.ui-block-a").hide(400)
    }, $(document).live("pageinit", function () {
        return f($("#service_call_subcontractor_id"), $("#service_call_subcon_agreement_id")), $("#service_call_subcontractor_id").change(function () {
            return $(a).hide(400), f($("#service_call_subcontractor_id"), $("#service_call_subcon_agreement_id"))
        }), f($("#service_call_provider_id"), $("#service_call_provider_agreement_id")), $("#service_call_provider_id").change(function () {
            return $(a).hide(400), f($("#service_call_provider_id"), $("#service_call_provider_agreement_id"))
        }), $("#service_call_subcon_agreement_id").change(function () {
            return d($("#service_call_subcon_agreement_id :selected"))
        }), $("#service_call_provider_agreement_id").change(function () {
            return d($("#service_call_provider_agreement_id :selected"))
        })
    })
}.call(this), function (a) {
    a.widget("mobile.jqmMobiscroll", a.mobile.widget, {options: {theme: "jqm", preset: "date", animate: "pop"}, _create: function () {
        var b = this.element, c = a.extend(this.options, b.jqmData("options"));
        b.mobiscroll(c)
    }}), a(document).bind("pagebeforecreate", function (b) {
        a('input[type="date"]:jqmData(role="mobiscroll")', b.target).prop("type", "text")
    }), a(document).bind("pagecreate create", function (b) {
        a(document).trigger("mobiscrollbeforecreate"), a(':jqmData(role="mobiscroll")', b.target).each(function () {
            "undefined" == typeof a(this).data("mobiscroll") && a(this).jqmMobiscroll()
        })
    })
}(jQuery), function (a) {
    function b(b, c) {
        function f(b) {
            return a.isArray(bj.readonly) ? (b = a(".dwwl", X).index(b), bj.readonly[b]) : bj.readonly
        }

        function h(a) {
            var b = '<div class="dw-bf">', c = 1, d;
            for (d in bl[a])0 == c % 20 && (b += '</div><div class="dw-bf">'), b += '<div class="dw-li dw-v" data-val="' + d + '" style="height:' + V + "px;line-height:" + V + 'px;"><div class="dw-i">' + bl[a][d] + "</div></div>", c++;
            return b + "</div>"
        }

        function i(b) {
            m = a(".dw-li", b).index(a(".dw-v", b).eq(0)), n = a(".dw-li", b).index(a(".dw-v", b).eq(-1)), t = a(".dw-ul", X).index(b), l = V, o = bd
        }

        function p(a) {
            var b = bj.headerText;
            return b ? "function" == typeof b ? b.call(bf, a) : b.replace(/\{value\}/i, a) : ""
        }

        function z() {
            bd.temp = bn && (null !== bd.val && bd.val != bg.val() || !bg.val().length) || null === bd.values ? bj.parseValue(bg.val() || "", bd) : bd.values.slice(0), bd.setValue(!0)
        }

        function J(b, c, d, e) {
            !1 !== O("validate", [X, c]) && a(".dw-ul", X).each(function (d) {
                var f = a(this), g = a('.dw-li[data-val="' + bd.temp[d] + '"]', f), h = a(".dw-li", f), i = h.index(g), j = h.length, k = d == c || void 0 === c;
                if (!g.hasClass("dw-v")) {
                    for (var l = g, m = 0, n = 0; 0 <= i - m && !l.hasClass("dw-v");)m++, l = h.eq(i - m);
                    for (; i + n < j && !g.hasClass("dw-v");)n++, g = h.eq(i + n);
                    (n < m && n && 2 !== e || !m || !l.hasClass("dw-v") || 1 == e) && g.hasClass("dw-v") ? i += n : (g = l, i -= m)
                }
                if (!g.hasClass("dw-sel") || k)bd.temp[d] = g.attr("data-val"), a(".dw-sel", f).removeClass("dw-sel"), g.addClass("dw-sel"), bd.scroll(f, d, i, b)
            }), bd.change(d)
        }

        function K(b) {
            if (!("inline" == bj.display || Y === a(window).width() && $ === a(window).height() && b)) {
                var c, d, e, f, g, h, i, j, k, l = 0, m = 0, b = a(window).scrollTop();
                f = a(".dwwr", X);
                var n = a(".dw", X), o = {};
                g = void 0 === bj.anchor ? bg : bj.anchor, Y = a(window).width(), $ = a(window).height(), Z = (Z = window.innerHeight) || $, /modal|bubble/.test(bj.display) && (a(".dwc", X).each(function () {
                    c = a(this).outerWidth(!0), l += c, m = c > m ? c : m
                }), c = l > Y ? m : l, f.width(c)), _ = n.outerWidth(), ba = n.outerHeight(!0), "modal" == bj.display ? (d = (Y - _) / 2, e = b + (Z - ba) / 2) : "bubble" == bj.display ? (k = !0, j = a(".dw-arrw-i", X), d = g.offset(), h = d.top, i = d.left, f = g.outerWidth(), g = g.outerHeight(), d = i - (n.outerWidth(!0) - f) / 2, d = d > Y - _ ? Y - (_ + 20) : d, d = 0 <= d ? d : 20, e = h - ba, e < b || h > b + Z ? (n.removeClass("dw-bubble-top").addClass("dw-bubble-bottom"), e = h + g) : n.removeClass("dw-bubble-bottom").addClass("dw-bubble-top"), j = j.outerWidth(), f = i + f / 2 - (d + (_ - j) / 2), a(".dw-arr", X).css({left: f > j ? j : f})) : (o.width = "100%", "top" == bj.display ? e = b : "bottom" == bj.display && (e = b + Z - ba)), o.top = 0 > e ? 0 : e, o.left = d, n.css(o), a(".dw-persp", X).height(0).height(e + ba > a(document).height() ? e + ba : a(document).height()), k && (e + ba > b + Z || h > b + Z) && a(window).scrollTop(e + ba - Z)
            }
        }

        function L(a) {
            if ("touchstart" === a.type)D = !0, setTimeout(function () {
                D = !1
            }, 500); else if (D)return D = !1;
            return!0
        }

        function O(b, d) {
            var e;
            return d.push(bd), a.each([bk, c], function (a, c) {
                c[b] && (e = c[b].apply(bf, d))
            }), e
        }

        function S(a) {
            var b = +a.data("pos") + 1;
            g(a, b > n ? m : b, 1)
        }

        function T(a) {
            var b = +a.data("pos") - 1;
            g(a, b < m ? n : b, 2)
        }

        var U, V, W, X, Y, Z, $, _, ba, bb, bc, bd = this, be = a.mobiscroll, bf = b, bg = a(bf), bh, bi, bj = C({}, H), bk = {}, bl = [], bm = {}, bn = bg.is("input"), bo = !1;
        bd.enable = function () {
            bj.disabled = !1, bn && bg.prop("disabled", !1)
        }, bd.disable = function () {
            bj.disabled = !0, bn && bg.prop("disabled", !0)
        }, bd.scroll = function (a, b, c, d, e, f) {
            function g() {
                clearInterval(bm[b]), bm[b] = void 0, a.data("pos", c).closest(".dwwl").removeClass("dwa")
            }

            var h = (U - c) * V, i, f = f || k;
            a.attr("style", (d ? B + "-transition:all " + d.toFixed(1) + "s ease-out;" : "") + (A ? B + "-transform:translate3d(0," + h + "px,0);" : "top:" + h + "px;")), bm[b] && g(), d && void 0 !== e ? (i = 0, a.closest(".dwwl").addClass("dwa"), bm[b] = setInterval(function () {
                i += .1, a.data("pos", Math.round((c - e) * Math.sin(i / d * (Math.PI / 2)) + e)), i >= d && (g(), f())
            }, 100), O("onAnimStart", [b, d])) : (a.data("pos", c), f())
        }, bd.setValue = function (a, b, c, d) {
            d || (bd.values = bd.temp.slice(0)), bo && a && J(c), b && (W = bj.formatResult(bd.temp), bd.val = W, bn && bg.val(W).trigger("change"))
        }, bd.validate = function (a, b) {
            J(.2, a, !0, b)
        }, bd.change = function (b) {
            W = bj.formatResult(bd.temp), "inline" == bj.display ? bd.setValue(!1, b) : a(".dwv", X).html(p(W)), b && O("onChange", [W])
        }, bd.changeWheel = function (b, c) {
            if (X) {
                var d = 0, e, f, g = b.length;
                for (e in bj.wheels)for (f in bj.wheels[e]) {
                    if (-1 < a.inArray(d, b) && (bl[d] = bj.wheels[e][f], a(".dw-ul", X).eq(d).html(h(d)), g--, !g)) {
                        K(), J(c);
                        return
                    }
                    d++
                }
            }
        }, bd.isVisible = function () {
            return bo
        }, bd.tap = function (a, b) {
            var c, d;
            a.bind("touchstart",function (a) {
                a.preventDefault(), c = !1, d = !0
            }).bind("touchmove",function () {
                c = !0
            }).bind("touchend",function (a) {
                c || b.call(this, a)
            }).bind("click", function (a) {
                d || b.call(this, a)
            })
        }, bd.show = function (b) {
            if (bj.disabled || bo)return!1;
            "top" == bj.display && (bb = "slidedown"), "bottom" == bj.display && (bb = "slideup"), z(), O("onBeforeShow", [X]);
            var c = 0, e, k = "";
            bb && !b && (k = "dw-" + bb + " dw-in");
            for (var l = '<div class="dw-trans ' + bj.theme + " dw-" + bj.display + '">' + ("inline" == bj.display ? '<div class="dw dwbg dwi"><div class="dwwr">' : '<div class="dw-persp"><div class="dwo"></div><div class="dw dwbg ' + k + '"><div class="dw-arrw"><div class="dw-arrw-i"><div class="dw-arr"></div></div></div><div class="dwwr">' + (bj.headerText ? '<div class="dwv"></div>' : "")), b = 0; b < bj.wheels.length; b++) {
                l += '<div class="dwc' + ("scroller" != bj.mode ? " dwpm" : " dwsc") + (bj.showLabel ? "" : " dwhl") + '"><div class="dwwc dwrc"><table cellpadding="0" cellspacing="0"><tr>';
                for (e in bj.wheels[b])bl[c] = bj.wheels[b][e], l += '<td><div class="dwwl dwrc dwwl' + c + '">' + ("scroller" != bj.mode ? '<div class="dwwb dwwbp" style="height:' + V + "px;line-height:" + V + 'px;"><span>+</span></div><div class="dwwb dwwbm" style="height:' + V + "px;line-height:" + V + 'px;"><span>&ndash;</span></div>' : "") + '<div class="dwl">' + e + '</div><div class="dww" style="height:' + bj.rows * V + "px;min-width:" + bj.width + 'px;"><div class="dw-ul">', l += h(c), l += '</div><div class="dwwo"></div></div><div class="dwwol"></div></div></td>', c++;
                l += "</tr></table></div></div>"
            }
            l += ("inline" != bj.display ? '<div class="dwbc' + (bj.button3 ? " dwbc-p" : "") + '"><span class="dwbw dwb-s"><span class="dwb">' + bj.setText + "</span></span>" + (bj.button3 ? '<span class="dwbw dwb-n"><span class="dwb">' + bj.button3Text + "</span></span>" : "") + '<span class="dwbw dwb-c"><span class="dwb">' + bj.cancelText + "</span></span></div></div>" : '<div class="dwcc"></div>') + "</div></div></div>", X = a(l), J(), O("onMarkupReady", [X]), "inline" != bj.display ? (X.appendTo("body"), setTimeout(function () {
                X.removeClass("dw-trans").find(".dw").removeClass(k)
            }, 350)) : bg.is("div") ? bg.html(X) : X.insertAfter(bg), bo = !0, bh.init(X, bd), "inline" != bj.display && (bd.tap(a(".dwb-s span", X), function () {
                bd.hide(!1, "set") !== !1 && (bd.setValue(!1, !0), O("onSelect", [bd.val]))
            }), bd.tap(a(".dwb-c span", X), function () {
                bd.cancel()
            }), bj.button3 && bd.tap(a(".dwb-n span", X), bj.button3), bj.scrollLock && X.bind("touchmove", function (a) {
                ba <= Z && _ <= Y && a.preventDefault()
            }), a("input,select,button").each(function () {
                a(this).prop("disabled") || a(this).addClass("dwtd").prop("disabled", !0)
            }), K(), a(window).bind("resize.dw", function () {
                clearTimeout(bc), bc = setTimeout(function () {
                    K(!0)
                }, 100)
            })), X.delegate(".dwwl", "DOMMouseScroll mousewheel",function (b) {
                if (!f(this)) {
                    b.preventDefault();
                    var b = b.originalEvent, b = b.wheelDelta ? b.wheelDelta / 120 : b.detail ? -b.detail / 3 : 0, c = a(".dw-ul", this), d = +c.data("pos"), d = Math.round(d - b);
                    i(c), g(c, d, b < 0 ? 1 : 2, !0, d)
                }
            }).delegate(".dwb, .dwwb", E,function () {
                a(this).addClass("dwb-a")
            }).delegate(".dwwb", E,function (b) {
                b.stopPropagation(), b.preventDefault();
                var c = a(this).closest(".dwwl");
                if (L(b) && !f(c) && !c.hasClass("dwa")) {
                    r = !0;
                    var d = c.find(".dw-ul"), e = a(this).hasClass("dwwbp") ? S : T;
                    i(d), clearInterval(j), j = setInterval(function () {
                        e(d)
                    }, bj.delay), e(d)
                }
            }).delegate(".dwwl", E, function (b) {
                b.preventDefault(), L(b) && !q && !f(this) && !r && bj.mode != "clickpick" && (q = !0, a(document).bind(F, G), s = a(".dw-ul", this), s.closest(".dwwl").addClass("dwa"), x = +s.data("pos"), i(s), y = bm[t] !== void 0, u = d(b), w = new Date, v = u, bd.scroll(s, t, x))
            }), O("onShow", [X, W])
        }, bd.hide = function (b, c) {
            if (!1 === O("onClose", [W, c]))return!1;
            a(".dwtd").prop("disabled", !1).removeClass("dwtd"), bg.blur(), X && ("inline" != bj.display && bb && !b ? (a(".dw", X).addClass("dw-" + bb + " dw-out"), setTimeout(function () {
                X.remove(), X = null
            }, 350)) : (X.remove(), X = null), bo = !1, a(window).unbind(".dw"))
        }, bd.cancel = function () {
            !1 !== bd.hide(!1, "cancel") && O("onCancel", [bd.val])
        }, bd.init = function (a) {
            bh = C({defaults: {}, init: k}, be.themes[a.theme || bj.theme]), bi = be.i18n[a.lang || bj.lang], C(c, a), C(bj, bh.defaults, bi, c), bd.settings = bj, bg.unbind(".dw");
            if (a = be.presets[bj.preset])bk = a.call(bf, bd), C(bj, bk, c), C(I, bk.methods);
            U = Math.floor(bj.rows / 2), V = bj.height, bb = bj.animate, void 0 !== bg.data("dwro") && (bf.readOnly = e(bg.data("dwro"))), bo && bd.hide(), "inline" == bj.display ? bd.show() : (z(), bn && bj.showOnFocus && (bg.data("dwro", bf.readOnly), bf.readOnly = !0, bg.bind("focus.dw", function () {
                bd.show()
            })))
        }, bd.values = null, bd.val = null, bd.temp = null, bd.init(c)
    }

    function c(a) {
        for (var b in a)if (void 0 !== z[a[b]])return!0;
        return!1
    }

    function d(a) {
        var b = a.originalEvent, c = a.changedTouches;
        return c || b && b.changedTouches ? b ? b.changedTouches[0].pageY : c[0].pageY : a.pageY
    }

    function e(a) {
        return!0 === a || "true" == a
    }

    function f(a, b, c) {
        return a = a > c ? c : a, a < b ? b : a
    }

    function g(b, c, d, e, g) {
        var c = f(c, m, n), h = a(".dw-li", b).eq(c), i = t, e = e ? c == g ? .1 : Math.abs(.1 * (c - g)) : 0;
        o.scroll(b, i, c, e, g, function () {
            o.temp[i] = h.attr("data-val"), o.validate(i, d)
        })
    }

    function h(a, b, c) {
        return I[b] ? I[b].apply(a, Array.prototype.slice.call(c, 1)) : "object" == typeof b ? I.init.call(a, b) : a
    }

    var i = {}, j, k = function () {
    }, l, m, n, o, p = (new Date).getTime(), q, r, s, t, u, v, w, x, y, z = document.createElement("modernizr").style, A = c(["perspectiveProperty", "WebkitPerspective", "MozPerspective", "OPerspective", "msPerspective"]), B = function () {
        var a = ["Webkit", "Moz", "O", "ms"], b;
        for (b in a)if (c([a[b] + "Transform"]))return"-" + a[b].toLowerCase();
        return""
    }(), C = a.extend, D, E = "touchstart mousedown", F = "touchmove mousemove", G = function (a) {
        a.preventDefault(), v = d(a), o.scroll(s, t, f(x + (u - v) / l, m - 1, n + 1)), y = !0
    }, H = {width: 70, height: 40, rows: 3, delay: 300, disabled: !1, readonly: !1, showOnFocus: !0, showLabel: !0, wheels: [], theme: "", headerText: "{value}", display: "modal", mode: "scroller", preset: "", lang: "en-US", setText: "Set", cancelText: "Cancel", scrollLock: !0, formatResult: function (a) {
        return a.join(" ")
    }, parseValue: function (a, b) {
        var c = b.settings.wheels, d = a.split(" "), e = [], f = 0, g, h, i;
        for (g = 0; g < c.length; g++)for (h in c[g]) {
            if (void 0 !== c[g][h][d[f]])e.push(d[f]); else for (i in c[g][h]) {
                e.push(i);
                break
            }
            f++
        }
        return e
    }}, I = {init: function (a) {
        return void 0 === a && (a = {}), this.each(function () {
            this.id || (p += 1, this.id = "scoller" + p), i[this.id] = new b(this, a)
        })
    }, enable: function () {
        return this.each(function () {
            var a = i[this.id];
            a && a.enable()
        })
    }, disable: function () {
        return this.each(function () {
            var a = i[this.id];
            a && a.disable()
        })
    }, isDisabled: function () {
        var a = i[this[0].id];
        if (a)return a.settings.disabled
    }, isVisible: function () {
        var a = i[this[0].id];
        if (a)return a.isVisible()
    }, option: function (a, b) {
        return this.each(function () {
            var c = i[this.id];
            if (c) {
                var d = {};
                "object" == typeof a ? d = a : d[a] = b, c.init(d)
            }
        })
    }, setValue: function (a, b, c, d) {
        return this.each(function () {
            var e = i[this.id];
            e && (e.temp = a, e.setValue(!0, b, c, d))
        })
    }, getInst: function () {
        return i[this[0].id]
    }, getValue: function () {
        var a = i[this[0].id];
        if (a)return a.values
    }, show: function () {
        var a = i[this[0].id];
        if (a)return a.show()
    }, hide: function () {
        return this.each(function () {
            var a = i[this.id];
            a && a.hide()
        })
    }, destroy: function () {
        return this.each(function () {
            var b = i[this.id];
            b && (b.hide(), a(this).unbind(".dw"), delete i[this.id], a(this).is("input") && (this.readOnly = e(a(this).data("dwro"))))
        })
    }};
    a(document).bind("touchend mouseup", function () {
        if (q) {
            var b = new Date - w, c = f(x + (u - v) / l, m - 1, n + 1), d;
            d = s.offset().top, 300 > b ? (b = (v - u) / b, b = b * b / .0012, 0 > v - u && (b = -b)) : b = v - u;
            if (!b && !y) {
                d = Math.floor((v - d) / l);
                var e = a(".dw-li", s).eq(d);
                e.addClass("dw-hl"), setTimeout(function () {
                    e.removeClass("dw-hl")
                }, 200)
            } else d = Math.round(x - b / l);
            g(s, d, 0, !0, Math.round(c)), q = !1, s = null, a(document).unbind(F, G)
        }
        r && (clearInterval(j), r = !1), a(".dwb-a").removeClass("dwb-a")
    }), a.fn.mobiscroll = function (b) {
        return C(this, a.mobiscroll.shorts), h(this, b, arguments)
    }, a.mobiscroll = a.mobiscroll || {setDefaults: function (a) {
        C(H, a)
    }, presetShort: function (a) {
        this.shorts[a] = function (b) {
            return h(this, C(b, {preset: a}), arguments)
        }
    }, shorts: {}, presets: {}, themes: {}, i18n: {}}, a.scroller = a.scroller || a.mobiscroll, a.fn.scroller = a.fn.scroller || a.fn.mobiscroll
}(jQuery), function (a) {
    var b = {inputClass: "", invalid: [], rtl: !1, group: !1, groupLabel: "Groups"};
    a.mobiscroll.presetShort("select"), a.mobiscroll.presets.select = function (c) {
        function d(a) {
            return a ? a.replace(/_/, "") : ""
        }

        function e() {
            var b, c = 0, d = {}, e = [
                {}
            ];
            return g.group ? (g.rtl && (c = 1), a("optgroup", h).each(function (b) {
                d["_" + b] = a(this).attr("label")
            }), e[c] = {}, e[c][g.groupLabel] = d, b = j, c += g.rtl ? -1 : 1) : b = h, e[c] = {}, e[c][q] = {}, a("option", b).each(function () {
                var b = a(this).attr("value");
                e[c][q]["_" + b] = a(this).text(), a(this).prop("disabled") && r.push(b)
            }), e
        }

        var f = c.settings, g = a.extend({}, b, f), h = a(this), i = h.val(), j = h.find('option[value="' + h.val() + '"]').parent(), k = j.index() + "", l = k, m, n = this.id + "_dummy";
        a('label[for="' + this.id + '"]').attr("for", n);
        var o = a('label[for="' + n + '"]'), q = void 0 !== g.label ? g.label : o.length ? o.text() : h.attr("name"), r = [], s = {}, t, u, v = f.readonly;
        g.group && !a("optgroup", h).length && (g.group = !1), g.invalid.length || (g.invalid = r), g.group ? g.rtl ? (t = 1, u = 0) : (t = 0, u = 1) : (t = -1, u = 0), a("#" + n).remove(), a("option", h).each(function () {
            s[a(this).attr("value")] = a(this).text()
        });
        var w = a('<input type="text" id="' + n + '" value="' + s[h.val()] + '" class="' + g.inputClass + '" readonly />').insertBefore(h);
        return g.showOnFocus && w.focus(function () {
            c.show()
        }), h.bind("change",function () {
            !m && i != h.val() && c.setSelectVal([h.val()], !0), m = !1
        }).hide().closest(".ui-field-contain").trigger("create"), c.setSelectVal = function (a, b, d) {
            i = a[0], g.group ? (j = h.find('option[value="' + i + '"]').parent(), l = j.index(), c.temp = g.rtl ? ["_" + i, "_" + j.index()] : ["_" + j.index(), "_" + i], l !== k && (f.wheels = e(), c.changeWheel([u]), k = l + "")) : c.temp = ["_" + i], c.setValue(!0, b, d), b && (w.val(s[i]), a = i !== h.val(), h.val(i), a && h.trigger("change"))
        }, c.getSelectVal = function (a) {
            return d((a ? c.temp : c.values)[u])
        }, {width: 50, wheels: void 0, headerText: !1, anchor: w, formatResult: function (a) {
            return s[d(a[u])]
        }, parseValue: function () {
            return i = h.val(), j = h.find('option[value="' + i + '"]').parent(), l = j.index(), g.group && g.rtl ? ["_" + i, "_" + l] : g.group ? ["_" + l, "_" + i] : ["_" + i]
        }, validate: function (b, m) {
            m === t ? (l = d(c.temp[t]), l !== k && (j = h.find("optgroup").eq(l), l = j.index(), i = (i = j.find("option").eq(0).val()) || h.val(), f.wheels = e(), g.group && (c.temp = g.rtl ? ["_" + i, "_" + l] : ["_" + l, "_" + i], c.changeWheel([u]), k = l + "")), f.readonly = v) : i = d(c.temp[u]);
            var n = a(".dw-ul", b).eq(u);
            a.each(g.invalid, function (b, c) {
                a('.dw-li[data-val="_' + c + '"]', n).removeClass("dw-v")
            })
        }, onAnimStart: function (a) {
            a === t && (f.readonly = [g.rtl, !g.rtl])
        }, onBeforeShow: function () {
            f.wheels = e(), g.group && (c.temp = g.rtl ? ["_" + i, "_" + j.index()] : ["_" + j.index(), "_" + i])
        }, onSelect: function (a) {
            w.val(a), m = !0, h.val(d(c.values[u])).trigger("change"), g.group && (c.values = null)
        }, onCancel: function () {
            g.group && (c.values = null)
        }, onChange: function (a) {
            g.display == "inline" && (w.val(a), m = !0, h.val(d(c.temp[u])).trigger("change"))
        }, onClose: function () {
            w.blur()
        }, methods: {setValue: function (b, c, d) {
            return this.each(function () {
                var e = a(this).mobiscroll("getInst");
                e && (e.setSelectVal ? e.setSelectVal(b, c, d) : (e.temp = b, e.setValue(!0, c, d)))
            })
        }, getValue: function (b) {
            var c = a(this).mobiscroll("getInst");
            if (c)return c.getSelectVal ? c.getSelectVal(b) : c.values
        }}}
    }
}(jQuery), function (a) {
    var b = a.mobiscroll, c = new Date, d = {dateFormat: "mm/dd/yy", dateOrder: "mmddy", timeWheels: "hhiiA", timeFormat: "hh:ii A", startYear: c.getFullYear() - 100, endYear: c.getFullYear() + 1, monthNames: "January,February,March,April,May,June,July,August,September,October,November,December".split(","), monthNamesShort: "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec".split(","), dayNames: "Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday".split(","), dayNamesShort: "Sun,Mon,Tue,Wed,Thu,Fri,Sat".split(","), shortYearCutoff: "+10", monthText: "Month", dayText: "Day", yearText: "Year", hourText: "Hours", minuteText: "Minutes", secText: "Seconds", ampmText: "&nbsp;", nowText: "Now", showNow: !1, stepHour: 1, stepMinute: 1, stepSecond: 1, separator: " "}, e = function (c) {
        function e(a, b, c) {
            return void 0 !== o[b] ? +a[o[b]] : void 0 !== c ? c : z[r[b]] ? z[r[b]]() : r[b](z)
        }

        function f(a, b) {
            return Math.floor(a / b) * b
        }

        function g(a) {
            var b = e(a, "h", 0);
            return new Date(e(a, "y"), e(a, "m"), e(a, "d", 1), e(a, "a") ? b + 12 : b, e(a, "i", 0), e(a, "s", 0))
        }

        var h = a(this), i = {}, j;
        if (h.is("input")) {
            switch (h.attr("type")) {
                case"date":
                    j = "yy-mm-dd";
                    break;
                case"datetime":
                    j = "yy-mm-ddTHH:ii:ssZ";
                    break;
                case"datetime-local":
                    j = "yy-mm-ddTHH:ii:ss";
                    break;
                case"month":
                    j = "yy-mm", i.dateOrder = "mmyy";
                    break;
                case"time":
                    j = "HH:ii:ss"
            }
            var k = h.attr("min"), h = h.attr("max");
            k && (i.minDate = b.parseDate(j, k)), h && (i.maxDate = b.parseDate(j, h))
        }
        var l = a.extend({}, d, i, c.settings), m = 0, i = [], n = [], o = {}, q, r = {y: "getFullYear", m: "getMonth", d: "getDate", h: function (a) {
            return a = a.getHours(), a = x && 12 <= a ? a - 12 : a, f(a, A)
        }, i: function (a) {
            return f(a.getMinutes(), B)
        }, s: function (a) {
            return f(a.getSeconds(), D)
        }, a: function (a) {
            return w && 11 < a.getHours() ? 1 : 0
        }}, s = l.preset, t = l.dateOrder, u = l.timeWheels, v = t.match(/D/), w = u.match(/a/i), x = u.match(/h/), y = "datetime" == s ? l.dateFormat + l.separator + l.timeFormat : "time" == s ? l.timeFormat : l.dateFormat, z = new Date, A = l.stepHour, B = l.stepMinute, D = l.stepSecond, E = l.minDate || new Date(l.startYear, 0, 1), F = l.maxDate || new Date(l.endYear, 11, 31, 23, 59, 59);
        c.settings = l, j = j || y;
        if (s.match(/date/i)) {
            a.each(["y", "m", "d"], function (a, b) {
                q = t.search(RegExp(b, "i")), -1 < q && n.push({o: q, v: b})
            }), n.sort(function (a, b) {
                return a.o > b.o ? 1 : -1
            }), a.each(n, function (a, b) {
                o[b.v] = a
            }), h = {};
            for (k = 0; 3 > k; k++)if (k == o.y) {
                m++, h[l.yearText] = {};
                var G = E.getFullYear(), H = F.getFullYear();
                for (q = G; q <= H; q++)h[l.yearText][q] = t.match(/yy/i) ? q : (q + "").substr(2, 2)
            } else if (k == o.m) {
                m++, h[l.monthText] = {};
                for (q = 0; 12 > q; q++)G = t.replace(/[dy]/gi, "").replace(/mm/, 9 > q ? "0" + (q + 1) : q + 1).replace(/m/, q), h[l.monthText][q] = G.match(/MM/) ? G.replace(/MM/, '<span class="dw-mon">' + l.monthNames[q] + "</span>") : G.replace(/M/, '<span class="dw-mon">' + l.monthNamesShort[q] + "</span>")
            } else if (k == o.d) {
                m++, h[l.dayText] = {};
                for (q = 1; 32 > q; q++)h[l.dayText][q] = t.match(/dd/i) && 10 > q ? "0" + q : q
            }
            i.push(h)
        }
        if (s.match(/time/i)) {
            n = [], a.each(["h", "i", "s", "a"], function (a, b) {
                a = u.search(RegExp(b, "i")), -1 < a && n.push({o: a, v: b})
            }), n.sort(function (a, b) {
                return a.o > b.o ? 1 : -1
            }), a.each(n, function (a, b) {
                o[b.v] = m + a
            }), h = {};
            for (k = m; k < m + 4; k++)if (k == o.h) {
                m++, h[l.hourText] = {};
                for (q = 0; q < (x ? 12 : 24); q += A)h[l.hourText][q] = x && 0 == q ? 12 : u.match(/hh/i) && 10 > q ? "0" + q : q
            } else if (k == o.i) {
                m++, h[l.minuteText] = {};
                for (q = 0; 60 > q; q += B)h[l.minuteText][q] = u.match(/ii/) && 10 > q ? "0" + q : q
            } else if (k == o.s) {
                m++, h[l.secText] = {};
                for (q = 0; 60 > q; q += D)h[l.secText][q] = u.match(/ss/) && 10 > q ? "0" + q : q
            } else k == o.a && (m++, s = u.match(/A/), h[l.ampmText] = {0: s ? "AM" : "am", 1: s ? "PM" : "pm"});
            i.push(h)
        }
        return c.setDate = function (a, b, c, d) {
            for (var e in o)this.temp[o[e]] = a[r[e]] ? a[r[e]]() : r[e](a);
            this.setValue(!0, b, c, d)
        }, c.getDate = function (a) {
            return g(a)
        }, {button3Text: l.showNow ? l.nowText : void 0, button3: l.showNow ? function () {
            c.setDate(new Date, !1, .3, !0)
        } : void 0, wheels: i, headerText: function () {
            return b.formatDate(y, g(c.temp), l)
        }, formatResult: function (a) {
            return b.formatDate(j, g(a), l)
        }, parseValue: function (a) {
            var c = new Date, d, e = [];
            try {
                c = b.parseDate(j, a, l)
            } catch (f) {
            }
            for (d in o)e[o[d]] = c[r[d]] ? c[r[d]]() : r[d](c);
            return e
        }, validate: function (b) {
            var d = c.temp, g = {y: E.getFullYear(), m: 0, d: 1, h: 0, i: 0, s: 0, a: 0}, h = {y: F.getFullYear(), m: 11, d: 31, h: f(x ? 11 : 23, A), i: f(59, B), s: f(59, D), a: 1}, i = !0, j = !0;
            a.each("y,m,d,a,h,i,s".split(","), function (c, f) {
                if (o[f] !== void 0) {
                    var k = g[f], m = h[f], n = 31, p = e(d, f), q = a(".dw-ul", b).eq(o[f]), s, u;
                    f == "d" && (s = e(d, "y"), u = e(d, "m"), m = n = 32 - (new Date(s, u, 32)).getDate(), v && a(".dw-li", q).each(function () {
                        var b = a(this), c = b.data("val"), d = (new Date(s, u, c)).getDay(), c = t.replace(/[my]/gi, "").replace(/dd/, c < 10 ? "0" + c : c).replace(/d/, c);
                        a(".dw-i", b).html(c.match(/DD/) ? c.replace(/DD/, '<span class="dw-day">' + l.dayNames[d] + "</span>") : c.replace(/D/, '<span class="dw-day">' + l.dayNamesShort[d] + "</span>"))
                    })), i && E && (k = E[r[f]] ? E[r[f]]() : r[f](E)), j && F && (m = F[r[f]] ? F[r[f]]() : r[f](F));
                    if (f != "y") {
                        var w = a(".dw-li", q).index(a('.dw-li[data-val="' + k + '"]', q)), x = a(".dw-li", q).index(a('.dw-li[data-val="' + m + '"]', q));
                        a(".dw-li", q).removeClass("dw-v").slice(w, x + 1).addClass("dw-v"), f == "d" && a(".dw-li", q).removeClass("dw-h").slice(n).addClass("dw-h")
                    }
                    p < k && (p = k), p > m && (p = m), i && (i = p == k), j && (j = p == m);
                    if (l.invalid && f == "d") {
                        var y = [];
                        l.invalid.dates && a.each(l.invalid.dates, function (a, b) {
                            b.getFullYear() == s && b.getMonth() == u && y.push(b.getDate() - 1)
                        });
                        if (l.invalid.daysOfWeek) {
                            var z = (new Date(s, u, 1)).getDay(), A;
                            a.each(l.invalid.daysOfWeek, function (a, b) {
                                for (A = b - z; A < n; A += 7)A >= 0 && y.push(A)
                            })
                        }
                        l.invalid.daysOfMonth && a.each(l.invalid.daysOfMonth, function (a, b) {
                            b = (b + "").split("/"), b[1] ? b[0] - 1 == u && y.push(b[1] - 1) : y.push(b[0] - 1)
                        }), a.each(y, function (b, c) {
                            a(".dw-li", q).eq(c).removeClass("dw-v")
                        })
                    }
                    d[o[f]] = p
                }
            })
        }, methods: {getDate: function (b) {
            var c = a(this).mobiscroll("getInst");
            if (c)return c.getDate(b ? c.temp : c.values)
        }, setDate: function (b, c, d, e) {
            return void 0 == c && (c = !1), this.each(function () {
                var f = a(this).mobiscroll("getInst");
                f && f.setDate(b, c, d, e)
            })
        }}}
    };
    a.each(["date", "time", "datetime"], function (a, c) {
        b.presets[c] = e, b.presetShort(c)
    }), b.formatDate = function (b, c, e) {
        if (!c)return null;
        var e = a.extend({}, d, e), f = function (a) {
            for (var c = 0; i + 1 < b.length && b.charAt(i + 1) == a;)c++, i++;
            return c
        }, g = function (a, b, c) {
            b = "" + b;
            if (f(a))for (; b.length < c;)b = "0" + b;
            return b
        }, h = function (a, b, c, d) {
            return f(a) ? d[b] : c[b]
        }, i, j = "", k = !1;
        for (i = 0; i < b.length; i++)if (k)"'" == b.charAt(i) && !f("'") ? k = !1 : j += b.charAt(i); else switch (b.charAt(i)) {
            case"d":
                j += g("d", c.getDate(), 2);
                break;
            case"D":
                j += h("D", c.getDay(), e.dayNamesShort, e.dayNames);
                break;
            case"o":
                j += g("o", (c.getTime() - (new Date(c.getFullYear(), 0, 0)).getTime()) / 864e5, 3);
                break;
            case"m":
                j += g("m", c.getMonth() + 1, 2);
                break;
            case"M":
                j += h("M", c.getMonth(), e.monthNamesShort, e.monthNames);
                break;
            case"y":
                j += f("y") ? c.getFullYear() : (10 > c.getYear() % 100 ? "0" : "") + c.getYear() % 100;
                break;
            case"h":
                var l = c.getHours(), j = j + g("h", 12 < l ? l - 12 : 0 == l ? 12 : l, 2);
                break;
            case"H":
                j += g("H", c.getHours(), 2);
                break;
            case"i":
                j += g("i", c.getMinutes(), 2);
                break;
            case"s":
                j += g("s", c.getSeconds(), 2);
                break;
            case"a":
                j += 11 < c.getHours() ? "pm" : "am";
                break;
            case"A":
                j += 11 < c.getHours() ? "PM" : "AM";
                break;
            case"'":
                f("'") ? j += "'" : k = !0;
                break;
            default:
                j += b.charAt(i)
        }
        return j
    }, b.parseDate = function (b, c, e) {
        var f = new Date;
        if (!b || !c)return f;
        var c = "object" == typeof c ? c.toString() : c + "", g = a.extend({}, d, e), h = g.shortYearCutoff, e = f.getFullYear(), i = f.getMonth() + 1, j = f.getDate(), k = -1, l = f.getHours(), f = f.getMinutes(), m = 0, n = -1, o = !1, p = function (a) {
            return(a = t + 1 < b.length && b.charAt(t + 1) == a) && t++, a
        }, q = function (a) {
            return p(a), a = c.substr(s).match(RegExp("^\\d{1," + ("@" == a ? 14 : "!" == a ? 20 : "y" == a ? 4 : "o" == a ? 3 : 2) + "}")), a ? (s += a[0].length, parseInt(a[0], 10)) : 0
        }, r = function (a, b, d) {
            a = p(a) ? d : b;
            for (b = 0; b < a.length; b++)if (c.substr(s, a[b].length).toLowerCase() == a[b].toLowerCase())return s += a[b].length, b + 1;
            return 0
        }, s = 0, t;
        for (t = 0; t < b.length; t++)if (o)"'" == b.charAt(t) && !p("'") ? o = !1 : s++; else switch (b.charAt(t)) {
            case"d":
                j = q("d");
                break;
            case"D":
                r("D", g.dayNamesShort, g.dayNames);
                break;
            case"o":
                k = q("o");
                break;
            case"m":
                i = q("m");
                break;
            case"M":
                i = r("M", g.monthNamesShort, g.monthNames);
                break;
            case"y":
                e = q("y");
                break;
            case"H":
                l = q("H");
                break;
            case"h":
                l = q("h");
                break;
            case"i":
                f = q("i");
                break;
            case"s":
                m = q("s");
                break;
            case"a":
                n = r("a", ["am", "pm"], ["am", "pm"]) - 1;
                break;
            case"A":
                n = r("A", ["am", "pm"], ["am", "pm"]) - 1;
                break;
            case"'":
                p("'") ? s++ : o = !0;
                break;
            default:
                s++
        }
        100 > e && (e += (new Date).getFullYear() - (new Date).getFullYear() % 100 + (e <= ("string" != typeof h ? h : (new Date).getFullYear() % 100 + parseInt(h, 10)) ? 0 : -100));
        if (-1 < k) {
            i = 1, j = k;
            do {
                g = 32 - (new Date(e, i - 1, 32)).getDate();
                if (j <= g)break;
                i++, j -= g
            } while (1)
        }
        l = new Date(e, i - 1, j, -1 == n ? l : n && 12 > l ? l + 12 : !n && 12 == l ? 0 : l, f, m);
        if (l.getFullYear() != e || l.getMonth() + 1 != i || l.getDate() != j)throw"Invalid date";
        return l
    }
}(jQuery), function (a) {
    var b = a.mobiscroll, c = {invalid: [], showInput: !0, inputClass: ""}, d = function (b) {
        function d(b, c, d, f) {
            for (var g = 0; g < c;) {
                var h = a(".dwwl" + g, b), i = e(f, g, d);
                a.each(i, function (b, c) {
                    a('.dw-li[data-val="' + c + '"]', h).removeClass("dw-v")
                }), g++
            }
        }

        function e(a, b, c) {
            for (var d = 0, e, f = []; d < b;) {
                var g = a[d];
                for (e in c)if (c[e].key == g) {
                    c = c[e].children;
                    break
                }
                d++
            }
            for (d = 0; d < c.length;)c[d].invalid && f.push(c[d].key), d++;
            return f
        }

        function f(a, b, c) {
            var d = 0, e, f, h = [
                {}
            ], i = s;
            if (b)for (e = 0; e < b; e++)h[e] = {}, h[e][t[e]] = {};
            for (; d < a.length;) {
                h[d] = {}, e = h[d];
                for (var b = t[d], j = i, k = {}, l = 0; l < j.length;)k[j[l].key] = j[l++].value;
                e[b] = k, e = 0;
                for (b = void 0; e < i.length && void 0 === b;)i[e].key == a[d] && (void 0 !== c && d <= c || void 0 === c) && (b = e), e++;
                if (void 0 !== b && i[b].children)d++, i = i[b].children; else {
                    if (!(f = g(i)) || !f.children)break;
                    d++, i = f.children
                }
            }
            return h
        }

        function g(a, b) {
            if (!a)return!1;
            for (var c = 0, d; c < a.length;)if (!(d = a[c++]).invalid)return b ? c - 1 : d;
            return!1
        }

        function h(b, c) {
            a(".dwc", b).css("display", "").slice(c).hide()
        }

        function i(a, b) {
            var c = [], d = s, e = 0, f = !1, h, i;
            if (void 0 !== a[e] && e <= b) {
                f = 0, h = a[e];
                for (i = void 0; f < d.length && void 0 === i;)d[f].key == a[e] && !d[f].invalid && (i = f), f++
            } else i = g(d, !0), h = d[i].key;
            f = void 0 !== i ? d[i].children : !1;
            for (c[e] = h; f;) {
                d = d[i].children, e++;
                if (void 0 !== a[e] && e <= b) {
                    f = 0, h = a[e];
                    for (i = void 0; f < d.length && void 0 === i;)d[f].key == a[e] && !d[f].invalid && (i = f), f++
                } else i = g(d, !0), i = !1 === i ? void 0 : i, h = d[i].key;
                f = void 0 !== i && g(d[i].children) ? d[i].children : !1, c[e] = h
            }
            return{lvl: e + 1, nVector: c}
        }

        function j(b) {
            var c = [];
            return p = p > q++ ? p : q, b.children("li").each(function (b) {
                var d = a(this), e = d.clone();
                e.children("ul,ol").remove();
                var e = e.html().replace(/^\s\s*/, "").replace(/\s\s*$/, ""), f = d.data("invalid") ? !0 : !1, b = {key: d.data("val") || b, value: e, invalid: f, children: null}, d = d.children("ul,ol");
                d.length && (b.children = j(d)), c.push(b)
            }), q--, c
        }

        var k = a.extend({}, c, b.settings), l = a(this), m, n, o = this.id + "_dummy", p = 0, q = 0, s = k.wheelArray || j(l), t = function (a) {
            var b = [], c;
            for (c = 0; c < a; c++)b[c] = k.labels && k.labels[c] ? k.labels[c] : c;
            return b
        }(p), u = [], v = function (a) {
            for (var b = [], c, d = !0, e = 0; d;)if (c = g(a), b[e++] = c.key, d = c.children)a = c.children;
            return b
        }(s), v = f(v, p);
        return a("#" + o).remove(), k.showInput && (m = a('<input type="text" id="' + o + '" value="" class="' + k.inputClass + '" readonly />').insertBefore(l), b.settings.anchor = m, k.showOnFocus && m.focus(function () {
            b.show()
        })), k.wheelArray || l.hide().closest(".ui-field-contain").trigger("create"), {width: 50, wheels: v, headerText: !1, onBeforeShow: function () {
            var a = b.temp;
            u = b.temp.slice(0), b.settings.wheels = f(a, p, p)
        }, onSelect: function (a) {
            m && m.val(a)
        }, onChange: function (a) {
            m && k.display == "inline" && m.val(a)
        }, onClose: function () {
            m && m.blur()
        }, onAnimStart: function (a) {
            for (var c = b.settings, d = p, e = []; d;)e[--d] = !0;
            e[a] = !1, c.readonly = e
        }, validate: function (a, c) {
            var e = b.temp;
            if (c !== void 0 && u[c] != e[c] || c === void 0 && !n) {
                b.settings.wheels = f(e, null, c);
                var g = [], j = (c || 0) + 1, k = i(e, c);
                c !== void 0 && (b.temp = k.nVector.slice(0));
                for (; j < k.lvl;)g.push(j++);
                h(a, k.lvl), u = b.temp.slice(0);
                if (g.length)return n = !0, b.changeWheel(g), !1;
                d(a, k.lvl, s, b.temp)
            } else k = i(e, e.length), d(a, k.lvl, s, e), h(a, k.lvl);
            n = b.settings.readonly = !1
        }}
    };
    a.each(["list", "image", "treelist"], function (a, c) {
        b.presets[c] = d, b.presetShort(c)
    })
}(jQuery), function () {
    $(document).live("pageinit", function () {
        return $(".mobi-datetime").mobiscroll().datetime(), $(".mobi-dateonly").mobiscroll().date(), $(".mobi-timeonly").mobiscroll().time()
    })
}.call(this);