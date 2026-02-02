
(function(l, r) { if (!l || l.getElementById('livereloadscript')) return; r = l.createElement('script'); r.async = 1; r.src = '//' + (self.location.host || 'localhost').split(':')[0] + ':35729/livereload.js?snipver=1'; r.id = 'livereloadscript'; l.getElementsByTagName('head')[0].appendChild(r) })(self.document);
function getDefaultExportFromCjs (x) {
	return x && x.__esModule && Object.prototype.hasOwnProperty.call(x, 'default') ? x['default'] : x;
}

var observable$1 = {exports: {}};

var hasRequiredObservable;

function requireObservable () {
	if (hasRequiredObservable) return observable$1.exports;
	hasRequiredObservable = 1;
	(function (module, exports$1) {
(function(window, undefined$1) {const ALL_CALLBACKS = '*';
		const define = Object.defineProperties;
		const entries = Object.entries;

		const on = (callbacks, el) => (event, fn) => {
		  if (callbacks.has(event)) {
		    callbacks.get(event).add(fn);
		  } else {
		    callbacks.set(event, new Set().add(fn));
		  }

		  return el
		};

		const deleteCallback = (callbacks, el, event,  fn) => {
		  if (fn) {
		    const fns = callbacks.get(event);

		    if (fns) {
		      fns.delete(fn);
		      if (fns.size === 0) callbacks.delete(event);
		    }
		  } else callbacks.delete(event);
		};

		const off = (callbacks, el) => (event, fn) => {
		  if (event === ALL_CALLBACKS && !fn) {
		    callbacks.clear();
		  } else {
		    deleteCallback(callbacks, el, event, fn);
		  }

		  return el
		};

		const one = (callbacks, el) => (event, fn) => {
		  function on(...args) {
		    el.off(event, on);
		    fn.apply(el, args);
		  }
		  return el.on(event, on)
		};

		const trigger = (callbacks, el) => (event, ...args) => {
		  const fns = callbacks.get(event);

		  if (fns) fns.forEach(fn => fn.apply(el, args));

		  if (callbacks.get(ALL_CALLBACKS) && event !== ALL_CALLBACKS) {
		    el.trigger(ALL_CALLBACKS, event, ...args);
		  }

		  return el
		};

		const observable = function(el) { // eslint-disable-line
		  const callbacks = new Map();
		  const methods = {on, off, one, trigger};

		  el = el || {};

		  define(el,
		    entries(methods).reduce((acc, [key, method]) => {
		      acc[key] = {
		        value: method(callbacks, el),
		        enumerable: false,
		        writable: false,
		        configurable: false
		      };

		      return acc
		    }, {})
		  );

		  return el
		};
		  /* istanbul ignore next */
		  // support CommonJS, AMD & browser
		  module.exports = observable;

		})(); 
	} (observable$1));
	return observable$1.exports;
}

var observableExports = requireObservable();
var observable = /*@__PURE__*/getDefaultExportFromCjs(observableExports);

/******************************************************************************
Copyright (c) Microsoft Corporation.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
***************************************************************************** */
/* global Reflect, Promise, SuppressedError, Symbol, Iterator */


function __classPrivateFieldGet(receiver, state, kind, f) {
    if (kind === "a" && !f) throw new TypeError("Private accessor was defined without a getter");
    if (typeof state === "function" ? receiver !== state || !f : !state.has(receiver)) throw new TypeError("Cannot read private member from an object whose class did not declare it");
    return kind === "m" ? f : kind === "a" ? f.call(receiver) : f ? f.value : state.get(receiver);
}

function __classPrivateFieldSet(receiver, state, value, kind, f) {
    if (kind === "m") throw new TypeError("Private method is not writable");
    if (kind === "a" && !f) throw new TypeError("Private accessor was defined without a setter");
    if (typeof state === "function" ? receiver !== state || !f : !state.has(receiver)) throw new TypeError("Cannot write private member to an object whose class did not declare it");
    return (kind === "a" ? f.call(receiver, value) : f ? f.value = value : state.set(receiver, value)), value;
}

typeof SuppressedError === "function" ? SuppressedError : function (error, suppressed, message) {
    var e = new Error(message);
    return e.name = "SuppressedError", e.error = error, e.suppressed = suppressed, e;
};

var DEV = false;

// Store the references to globals in case someone tries to monkey patch these, causing the below
// to de-opt (this occurs often when using popular extensions).
var is_array = Array.isArray;
var index_of = Array.prototype.indexOf;
var array_from = Array.from;
var define_property = Object.defineProperty;
var get_descriptor = Object.getOwnPropertyDescriptor;
var get_descriptors = Object.getOwnPropertyDescriptors;
var object_prototype = Object.prototype;
var array_prototype = Array.prototype;
var get_prototype_of = Object.getPrototypeOf;
var is_extensible = Object.isExtensible;

const noop = () => {};

/** @param {Function} fn */
function run(fn) {
	return fn();
}

/** @param {Array<() => void>} arr */
function run_all(arr) {
	for (var i = 0; i < arr.length; i++) {
		arr[i]();
	}
}

/**
 * TODO replace with Promise.withResolvers once supported widely enough
 * @template [T=void]
 */
function deferred() {
	/** @type {(value: T) => void} */
	var resolve;

	/** @type {(reason: any) => void} */
	var reject;

	/** @type {Promise<T>} */
	var promise = new Promise((res, rej) => {
		resolve = res;
		reject = rej;
	});

	// @ts-expect-error
	return { promise, resolve, reject };
}

// General flags
const DERIVED = 1 << 1;
const EFFECT = 1 << 2;
const RENDER_EFFECT = 1 << 3;
/**
 * An effect that does not destroy its child effects when it reruns.
 * Runs as part of render effects, i.e. not eagerly as part of tree traversal or effect flushing.
 */
const MANAGED_EFFECT = 1 << 24;
/**
 * An effect that does not destroy its child effects when it reruns (like MANAGED_EFFECT).
 * Runs eagerly as part of tree traversal or effect flushing.
 */
const BLOCK_EFFECT = 1 << 4;
const BRANCH_EFFECT = 1 << 5;
const ROOT_EFFECT = 1 << 6;
const BOUNDARY_EFFECT = 1 << 7;
/**
 * Indicates that a reaction is connected to an effect root — either it is an effect,
 * or it is a derived that is depended on by at least one effect. If a derived has
 * no dependents, we can disconnect it from the graph, allowing it to either be
 * GC'd or reconnected later if an effect comes to depend on it again
 */
const CONNECTED = 1 << 9;
const CLEAN = 1 << 10;
const DIRTY = 1 << 11;
const MAYBE_DIRTY = 1 << 12;
const INERT = 1 << 13;
const DESTROYED = 1 << 14;

// Flags exclusive to effects
/** Set once an effect that should run synchronously has run */
const EFFECT_RAN = 1 << 15;
/**
 * 'Transparent' effects do not create a transition boundary.
 * This is on a block effect 99% of the time but may also be on a branch effect if its parent block effect was pruned
 */
const EFFECT_TRANSPARENT = 1 << 16;
const EAGER_EFFECT = 1 << 17;
const HEAD_EFFECT = 1 << 18;
const EFFECT_PRESERVED = 1 << 19;
const USER_EFFECT = 1 << 20;

// Flags exclusive to deriveds
/**
 * Tells that we marked this derived and its reactions as visited during the "mark as (maybe) dirty"-phase.
 * Will be lifted during execution of the derived and during checking its dirty state (both are necessary
 * because a derived might be checked but not executed).
 */
const WAS_MARKED = 1 << 15;

// Flags used for async
const REACTION_IS_UPDATING = 1 << 21;
const ASYNC = 1 << 22;

const ERROR_VALUE = 1 << 23;

const STATE_SYMBOL = Symbol('$state');
const LEGACY_PROPS = Symbol('legacy props');
const LOADING_ATTR_SYMBOL = Symbol('');
const PROXY_PATH_SYMBOL = Symbol('proxy path');

/** allow users to ignore aborted signal errors if `reason.name === 'StaleReactionError` */
const STALE_REACTION = new (class StaleReactionError extends Error {
	name = 'StaleReactionError';
	message = 'The reaction that called `getAbortSignal()` was re-run or destroyed';
})();

const ELEMENT_NODE = 1;
const DOCUMENT_FRAGMENT_NODE = 11;

/** @import { Equals } from '#client' */

/** @type {Equals} */
function equals(value) {
	return value === this.v;
}

/**
 * @param {unknown} a
 * @param {unknown} b
 * @returns {boolean}
 */
function safe_not_equal(a, b) {
	return a != a
		? b == b
		: a !== b || (a !== null && typeof a === 'object') || typeof a === 'function';
}

/** @type {Equals} */
function safe_equals(value) {
	return !safe_not_equal(value, this.v);
}

/* This file is generated by scripts/process-messages/index.js. Do not edit! */


/**
 * `%name%(...)` can only be used during component initialisation
 * @param {string} name
 * @returns {never}
 */
function lifecycle_outside_component(name) {
	{
		throw new Error(`https://svelte.dev/e/lifecycle_outside_component`);
	}
}

/**
 * Attempted to render a snippet without a `{@render}` block. This would cause the snippet code to be stringified instead of its content being rendered to the DOM. To fix this, change `{snippet}` to `{@render snippet()}`.
 * @returns {never}
 */
function snippet_without_render_tag() {
	{
		throw new Error(`https://svelte.dev/e/snippet_without_render_tag`);
	}
}

/**
 * `%name%` is not a store with a `subscribe` method
 * @param {string} name
 * @returns {never}
 */
function store_invalid_shape(name) {
	{
		throw new Error(`https://svelte.dev/e/store_invalid_shape`);
	}
}

/**
 * The `this` prop on `<svelte:element>` must be a string, if defined
 * @returns {never}
 */
function svelte_element_invalid_this_value() {
	{
		throw new Error(`https://svelte.dev/e/svelte_element_invalid_this_value`);
	}
}

/* This file is generated by scripts/process-messages/index.js. Do not edit! */


/**
 * Cannot create a `$derived(...)` with an `await` expression outside of an effect tree
 * @returns {never}
 */
function async_derived_orphan() {
	{
		throw new Error(`https://svelte.dev/e/async_derived_orphan`);
	}
}

/**
 * Calling `%method%` on a component instance (of %component%) is no longer valid in Svelte 5
 * @param {string} method
 * @param {string} component
 * @returns {never}
 */
function component_api_changed(method, component) {
	{
		throw new Error(`https://svelte.dev/e/component_api_changed`);
	}
}

/**
 * Attempted to instantiate %component% with `new %name%`, which is no longer valid in Svelte 5. If this component is not under your control, set the `compatibility.componentApi` compiler option to `4` to keep it working.
 * @param {string} component
 * @param {string} name
 * @returns {never}
 */
function component_api_invalid_new(component, name) {
	{
		throw new Error(`https://svelte.dev/e/component_api_invalid_new`);
	}
}

/**
 * `%rune%` cannot be used inside an effect cleanup function
 * @param {string} rune
 * @returns {never}
 */
function effect_in_teardown(rune) {
	{
		throw new Error(`https://svelte.dev/e/effect_in_teardown`);
	}
}

/**
 * Effect cannot be created inside a `$derived` value that was not itself created inside an effect
 * @returns {never}
 */
function effect_in_unowned_derived() {
	{
		throw new Error(`https://svelte.dev/e/effect_in_unowned_derived`);
	}
}

/**
 * `%rune%` can only be used inside an effect (e.g. during component initialisation)
 * @param {string} rune
 * @returns {never}
 */
function effect_orphan(rune) {
	{
		throw new Error(`https://svelte.dev/e/effect_orphan`);
	}
}

/**
 * Maximum update depth exceeded. This typically indicates that an effect reads and writes the same piece of state
 * @returns {never}
 */
function effect_update_depth_exceeded() {
	{
		throw new Error(`https://svelte.dev/e/effect_update_depth_exceeded`);
	}
}

/**
 * Cannot do `bind:%key%={undefined}` when `%key%` has a fallback value
 * @param {string} key
 * @returns {never}
 */
function props_invalid_value(key) {
	{
		throw new Error(`https://svelte.dev/e/props_invalid_value`);
	}
}

/**
 * Property descriptors defined on `$state` objects must contain `value` and always be `enumerable`, `configurable` and `writable`.
 * @returns {never}
 */
function state_descriptors_fixed() {
	{
		throw new Error(`https://svelte.dev/e/state_descriptors_fixed`);
	}
}

/**
 * Cannot set prototype of `$state` object
 * @returns {never}
 */
function state_prototype_fixed() {
	{
		throw new Error(`https://svelte.dev/e/state_prototype_fixed`);
	}
}

/**
 * Updating state inside `$derived(...)`, `$inspect(...)` or a template expression is forbidden. If the value should not be reactive, declare it without `$state`
 * @returns {never}
 */
function state_unsafe_mutation() {
	{
		throw new Error(`https://svelte.dev/e/state_unsafe_mutation`);
	}
}

/**
 * A `<svelte:boundary>` `reset` function cannot be called while an error is still being handled
 * @returns {never}
 */
function svelte_boundary_reset_onerror() {
	{
		throw new Error(`https://svelte.dev/e/svelte_boundary_reset_onerror`);
	}
}

/** True if experimental.async=true */
/** True if we're not certain that we only have Svelte 5 code in the compilation */
let legacy_mode_flag = false;
/** True if $inspect.trace is used */
let tracing_mode_flag = false;

function enable_legacy_mode_flag() {
	legacy_mode_flag = true;
}

const EACH_ITEM_REACTIVE = 1;
const EACH_INDEX_REACTIVE = 1 << 1;
/** See EachBlock interface metadata.is_controlled for an explanation what this is */
const EACH_IS_CONTROLLED = 1 << 2;
const EACH_IS_ANIMATED = 1 << 3;
const EACH_ITEM_IMMUTABLE = 1 << 4;

const PROPS_IS_IMMUTABLE = 1;
const PROPS_IS_RUNES = 1 << 1;
const PROPS_IS_UPDATED = 1 << 2;
const PROPS_IS_BINDABLE = 1 << 3;
const PROPS_IS_LAZY_INITIAL = 1 << 4;

const TEMPLATE_FRAGMENT = 1;
const TEMPLATE_USE_IMPORT_NODE = 1 << 1;

const UNINITIALIZED = Symbol();

// Dev-time component properties
const FILENAME = Symbol('filename');

const NAMESPACE_HTML = 'http://www.w3.org/1999/xhtml';
const NAMESPACE_SVG = 'http://www.w3.org/2000/svg';

const ATTACHMENT_KEY = '@attach';

/** @import { Derived, Reaction, Value } from '#client' */

/**
 * @param {Value} source
 * @param {string} label
 */
function tag(source, label) {
	source.label = label;
	tag_proxy(source.v, label);

	return source;
}

/**
 * @param {unknown} value
 * @param {string} label
 */
function tag_proxy(value, label) {
	// @ts-expect-error
	value?.[PROXY_PATH_SYMBOL]?.(label);
	return value;
}

/** @import { ComponentContext, DevStackEntry, Effect } from '#client' */

/** @type {ComponentContext | null} */
let component_context = null;

/** @param {ComponentContext | null} context */
function set_component_context(context) {
	component_context = context;
}

/** @type {DevStackEntry | null} */
let dev_stack = null;

/**
 * Execute a callback with a new dev stack entry
 * @param {() => any} callback - Function to execute
 * @param {DevStackEntry['type']} type - Type of block/component
 * @param {any} component - Component function
 * @param {number} line - Line number
 * @param {number} column - Column number
 * @param {Record<string, any>} [additional] - Any additional properties to add to the dev stack entry
 * @returns {any}
 */
function add_svelte_meta(callback, type, component, line, column, additional) {
	const parent = dev_stack;

	dev_stack = {
		type,
		file: component[FILENAME],
		line,
		column,
		parent,
		...additional
	};

	try {
		return callback();
	} finally {
		dev_stack = parent;
	}
}

/**
 * The current component function. Different from current component context:
 * ```html
 * <!-- App.svelte -->
 * <Foo>
 *   <Bar /> <!-- context == Foo.svelte, function == App.svelte -->
 * </Foo>
 * ```
 * @type {ComponentContext['function']}
 */
let dev_current_component_function = null;

/** @param {ComponentContext['function']} fn */
function set_dev_current_component_function(fn) {
	dev_current_component_function = fn;
}

/**
 * @param {Record<string, unknown>} props
 * @param {any} runes
 * @param {Function} [fn]
 * @returns {void}
 */
function push(props, runes = false, fn) {
	component_context = {
		p: component_context,
		i: false,
		c: null,
		e: null,
		s: props,
		x: null,
		l: legacy_mode_flag && !runes ? { s: null, u: null, $: [] } : null
	};
}

/**
 * @template {Record<string, any>} T
 * @param {T} [component]
 * @returns {T}
 */
function pop(component) {
	var context = /** @type {ComponentContext} */ (component_context);
	var effects = context.e;

	if (effects !== null) {
		context.e = null;

		for (var fn of effects) {
			create_user_effect(fn);
		}
	}

	if (component !== undefined) {
		context.x = component;
	}

	context.i = true;

	component_context = context.p;

	return component ?? /** @type {T} */ ({});
}

/** @returns {boolean} */
function is_runes() {
	return !legacy_mode_flag || (component_context !== null && component_context.l === null);
}

/** @type {Array<() => void>} */
let micro_tasks = [];

function run_micro_tasks() {
	var tasks = micro_tasks;
	micro_tasks = [];
	run_all(tasks);
}

/**
 * @param {() => void} fn
 */
function queue_micro_task(fn) {
	if (micro_tasks.length === 0 && !is_flushing_sync) {
		var tasks = micro_tasks;
		queueMicrotask(() => {
			// If this is false, a flushSync happened in the meantime. Do _not_ run new scheduled microtasks in that case
			// as the ordering of microtasks would be broken at that point - consider this case:
			// - queue_micro_task schedules microtask A to flush task X
			// - synchronously after, flushSync runs, processing task X
			// - synchronously after, some other microtask B is scheduled, but not through queue_micro_task but for example a Promise.resolve() in user code
			// - synchronously after, queue_micro_task schedules microtask C to flush task Y
			// - one tick later, microtask A now resolves, flushing task Y before microtask B, which is incorrect
			// This if check prevents that race condition (that realistically will only happen in tests)
			if (tasks === micro_tasks) run_micro_tasks();
		});
	}

	micro_tasks.push(fn);
}

/**
 * Synchronously run any queued tasks.
 */
function flush_tasks() {
	while (micro_tasks.length > 0) {
		run_micro_tasks();
	}
}

/* This file is generated by scripts/process-messages/index.js. Do not edit! */


/**
 * `%binding%` (%location%) is binding to a non-reactive property
 * @param {string} binding
 * @param {string | undefined | null} [location]
 */
function binding_property_non_reactive(binding, location) {
	{
		console.warn(`https://svelte.dev/e/binding_property_non_reactive`);
	}
}

/**
 * %parent% passed property `%prop%` to %child% with `bind:`, but its parent component %owner% did not declare `%prop%` as a binding. Consider creating a binding between %owner% and %parent% (e.g. `bind:%prop%={...}` instead of `%prop%={...}`)
 * @param {string} parent
 * @param {string} prop
 * @param {string} child
 * @param {string} owner
 */
function ownership_invalid_binding(parent, prop, child, owner) {
	{
		console.warn(`https://svelte.dev/e/ownership_invalid_binding`);
	}
}

/**
 * Mutating unbound props (`%name%`, at %location%) is strongly discouraged. Consider using `bind:%prop%={...}` in %parent% (or using a callback) instead
 * @param {string} name
 * @param {string} location
 * @param {string} prop
 * @param {string} parent
 */
function ownership_invalid_mutation(name, location, prop, parent) {
	{
		console.warn(`https://svelte.dev/e/ownership_invalid_mutation`);
	}
}

/**
 * The `value` property of a `<select multiple>` element should be an array, but it received a non-array value. The selection will be kept as is.
 */
function select_multiple_invalid_value() {
	{
		console.warn(`https://svelte.dev/e/select_multiple_invalid_value`);
	}
}

/**
 * Reactive `$state(...)` proxies and the values they proxy have different identities. Because of this, comparisons with `%operator%` will produce unexpected results
 * @param {string} operator
 */
function state_proxy_equality_mismatch(operator) {
	{
		console.warn(`https://svelte.dev/e/state_proxy_equality_mismatch`);
	}
}

/**
 * A `<svelte:boundary>` `reset` function only resets the boundary the first time it is called
 */
function svelte_boundary_reset_noop() {
	{
		console.warn(`https://svelte.dev/e/svelte_boundary_reset_noop`);
	}
}

/** @import { TemplateNode } from '#client' */


/** @param {TemplateNode} node */
function reset(node) {
	return;
}

function next(count = 1) {
}

/** @import { Source } from '#client' */

/**
 * @template T
 * @param {T} value
 * @returns {T}
 */
function proxy(value) {
	// if non-proxyable, or is already a proxy, return `value`
	if (typeof value !== 'object' || value === null || STATE_SYMBOL in value) {
		return value;
	}

	const prototype = get_prototype_of(value);

	if (prototype !== object_prototype && prototype !== array_prototype) {
		return value;
	}

	/** @type {Map<any, Source<any>>} */
	var sources = new Map();
	var is_proxied_array = is_array(value);
	var version = state(0);
	var parent_version = update_version;

	/**
	 * Executes the proxy in the context of the reaction it was originally created in, if any
	 * @template T
	 * @param {() => T} fn
	 */
	var with_parent = (fn) => {
		if (update_version === parent_version) {
			return fn();
		}

		// child source is being created after the initial proxy —
		// prevent it from being associated with the current reaction
		var reaction = active_reaction;
		var version = update_version;

		set_active_reaction(null);
		set_update_version(parent_version);

		var result = fn();

		set_active_reaction(reaction);
		set_update_version(version);

		return result;
	};

	if (is_proxied_array) {
		// We need to create the length source eagerly to ensure that
		// mutations to the array are properly synced with our proxy
		sources.set('length', state(/** @type {any[]} */ (value).length));
	}

	return new Proxy(/** @type {any} */ (value), {
		defineProperty(_, prop, descriptor) {
			if (
				!('value' in descriptor) ||
				descriptor.configurable === false ||
				descriptor.enumerable === false ||
				descriptor.writable === false
			) {
				// we disallow non-basic descriptors, because unless they are applied to the
				// target object — which we avoid, so that state can be forked — we will run
				// afoul of the various invariants
				// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/Proxy/getOwnPropertyDescriptor#invariants
				state_descriptors_fixed();
			}
			var s = sources.get(prop);
			if (s === undefined) {
				s = with_parent(() => {
					var s = state(descriptor.value);
					sources.set(prop, s);
					return s;
				});
			} else {
				set(s, descriptor.value, true);
			}

			return true;
		},

		deleteProperty(target, prop) {
			var s = sources.get(prop);

			if (s === undefined) {
				if (prop in target) {
					const s = with_parent(() => state(UNINITIALIZED));
					sources.set(prop, s);
					increment(version);
				}
			} else {
				set(s, UNINITIALIZED);
				increment(version);
			}

			return true;
		},

		get(target, prop, receiver) {
			if (prop === STATE_SYMBOL) {
				return value;
			}

			var s = sources.get(prop);
			var exists = prop in target;

			// create a source, but only if it's an own property and not a prototype property
			if (s === undefined && (!exists || get_descriptor(target, prop)?.writable)) {
				s = with_parent(() => {
					var p = proxy(exists ? target[prop] : UNINITIALIZED);
					var s = state(p);

					return s;
				});

				sources.set(prop, s);
			}

			if (s !== undefined) {
				var v = get$1(s);
				return v === UNINITIALIZED ? undefined : v;
			}

			return Reflect.get(target, prop, receiver);
		},

		getOwnPropertyDescriptor(target, prop) {
			var descriptor = Reflect.getOwnPropertyDescriptor(target, prop);

			if (descriptor && 'value' in descriptor) {
				var s = sources.get(prop);
				if (s) descriptor.value = get$1(s);
			} else if (descriptor === undefined) {
				var source = sources.get(prop);
				var value = source?.v;

				if (source !== undefined && value !== UNINITIALIZED) {
					return {
						enumerable: true,
						configurable: true,
						value,
						writable: true
					};
				}
			}

			return descriptor;
		},

		has(target, prop) {
			if (prop === STATE_SYMBOL) {
				return true;
			}

			var s = sources.get(prop);
			var has = (s !== undefined && s.v !== UNINITIALIZED) || Reflect.has(target, prop);

			if (
				s !== undefined ||
				(active_effect !== null && (!has || get_descriptor(target, prop)?.writable))
			) {
				if (s === undefined) {
					s = with_parent(() => {
						var p = has ? proxy(target[prop]) : UNINITIALIZED;
						var s = state(p);

						return s;
					});

					sources.set(prop, s);
				}

				var value = get$1(s);
				if (value === UNINITIALIZED) {
					return false;
				}
			}

			return has;
		},

		set(target, prop, value, receiver) {
			var s = sources.get(prop);
			var has = prop in target;

			// variable.length = value -> clear all signals with index >= value
			if (is_proxied_array && prop === 'length') {
				for (var i = value; i < /** @type {Source<number>} */ (s).v; i += 1) {
					var other_s = sources.get(i + '');
					if (other_s !== undefined) {
						set(other_s, UNINITIALIZED);
					} else if (i in target) {
						// If the item exists in the original, we need to create an uninitialized source,
						// else a later read of the property would result in a source being created with
						// the value of the original item at that index.
						other_s = with_parent(() => state(UNINITIALIZED));
						sources.set(i + '', other_s);
					}
				}
			}

			// If we haven't yet created a source for this property, we need to ensure
			// we do so otherwise if we read it later, then the write won't be tracked and
			// the heuristics of effects will be different vs if we had read the proxied
			// object property before writing to that property.
			if (s === undefined) {
				if (!has || get_descriptor(target, prop)?.writable) {
					s = with_parent(() => state(undefined));
					set(s, proxy(value));

					sources.set(prop, s);
				}
			} else {
				has = s.v !== UNINITIALIZED;

				var p = with_parent(() => proxy(value));
				set(s, p);
			}

			var descriptor = Reflect.getOwnPropertyDescriptor(target, prop);

			// Set the new value before updating any signals so that any listeners get the new value
			if (descriptor?.set) {
				descriptor.set.call(receiver, value);
			}

			if (!has) {
				// If we have mutated an array directly, we might need to
				// signal that length has also changed. Do it before updating metadata
				// to ensure that iterating over the array as a result of a metadata update
				// will not cause the length to be out of sync.
				if (is_proxied_array && typeof prop === 'string') {
					var ls = /** @type {Source<number>} */ (sources.get('length'));
					var n = Number(prop);

					if (Number.isInteger(n) && n >= ls.v) {
						set(ls, n + 1);
					}
				}

				increment(version);
			}

			return true;
		},

		ownKeys(target) {
			get$1(version);

			var own_keys = Reflect.ownKeys(target).filter((key) => {
				var source = sources.get(key);
				return source === undefined || source.v !== UNINITIALIZED;
			});

			for (var [key, source] of sources) {
				if (source.v !== UNINITIALIZED && !(key in target)) {
					own_keys.push(key);
				}
			}

			return own_keys;
		},

		setPrototypeOf() {
			state_prototype_fixed();
		}
	});
}

/**
 * @param {any} value
 */
function get_proxied_value(value) {
	try {
		if (value !== null && typeof value === 'object' && STATE_SYMBOL in value) {
			return value[STATE_SYMBOL];
		}
	} catch {
		// the above if check can throw an error if the value in question
		// is the contentWindow of an iframe on another domain, in which
		// case we want to just return the value (because it's definitely
		// not a proxied value) so we don't break any JavaScript interacting
		// with that iframe (such as various payment companies client side
		// JavaScript libraries interacting with their iframes on the same
		// domain)
	}

	return value;
}

/**
 * @param {any} a
 * @param {any} b
 */
function is(a, b) {
	return Object.is(get_proxied_value(a), get_proxied_value(b));
}

/**
 * @param {any} a
 * @param {any} b
 * @param {boolean} equal
 * @returns {boolean}
 */
function strict_equals(a, b, equal = true) {
	// try-catch needed because this tries to read properties of `a` and `b`,
	// which could be disallowed for example in a secure context
	try {
		if ((a === b) !== (get_proxied_value(a) === get_proxied_value(b))) {
			state_proxy_equality_mismatch(equal ? '===' : '!==');
		}
	} catch {}

	return (a === b) === equal;
}

/** @import { Effect, TemplateNode } from '#client' */

// export these for reference in the compiled code, making global name deduplication unnecessary
/** @type {Window} */
var $window;

/** @type {boolean} */
var is_firefox;

/** @type {() => Node | null} */
var first_child_getter;
/** @type {() => Node | null} */
var next_sibling_getter;

/**
 * Initialize these lazily to avoid issues when using the runtime in a server context
 * where these globals are not available while avoiding a separate server entry point
 */
function init_operations() {
	if ($window !== undefined) {
		return;
	}

	$window = window;
	is_firefox = /Firefox/.test(navigator.userAgent);

	var element_prototype = Element.prototype;
	var node_prototype = Node.prototype;
	var text_prototype = Text.prototype;

	// @ts-ignore
	first_child_getter = get_descriptor(node_prototype, 'firstChild').get;
	// @ts-ignore
	next_sibling_getter = get_descriptor(node_prototype, 'nextSibling').get;

	if (is_extensible(element_prototype)) {
		// the following assignments improve perf of lookups on DOM nodes
		// @ts-expect-error
		element_prototype.__click = undefined;
		// @ts-expect-error
		element_prototype.__className = undefined;
		// @ts-expect-error
		element_prototype.__attributes = null;
		// @ts-expect-error
		element_prototype.__style = undefined;
		// @ts-expect-error
		element_prototype.__e = undefined;
	}

	if (is_extensible(text_prototype)) {
		// @ts-expect-error
		text_prototype.__t = undefined;
	}
}

/**
 * @param {string} value
 * @returns {Text}
 */
function create_text(value = '') {
	return document.createTextNode(value);
}

/**
 * @template {Node} N
 * @param {N} node
 * @returns {Node | null}
 */
/*@__NO_SIDE_EFFECTS__*/
function get_first_child(node) {
	return first_child_getter.call(node);
}

/**
 * @template {Node} N
 * @param {N} node
 * @returns {Node | null}
 */
/*@__NO_SIDE_EFFECTS__*/
function get_next_sibling(node) {
	return next_sibling_getter.call(node);
}

/**
 * Don't mark this as side-effect-free, hydration needs to walk all nodes
 * @template {Node} N
 * @param {N} node
 * @param {boolean} is_text
 * @returns {Node | null}
 */
function child(node, is_text) {
	{
		return get_first_child(node);
	}
}

/**
 * Don't mark this as side-effect-free, hydration needs to walk all nodes
 * @param {DocumentFragment | TemplateNode | TemplateNode[]} fragment
 * @param {boolean} [is_text]
 * @returns {Node | null}
 */
function first_child(fragment, is_text = false) {
	{
		// when not hydrating, `fragment` is a `DocumentFragment` (the result of calling `open_frag`)
		var first = /** @type {DocumentFragment} */ (get_first_child(/** @type {Node} */ (fragment)));

		// TODO prevent user comments with the empty string when preserveComments is true
		if (first instanceof Comment && first.data === '') return get_next_sibling(first);

		return first;
	}
}

/**
 * Don't mark this as side-effect-free, hydration needs to walk all nodes
 * @param {TemplateNode} node
 * @param {number} count
 * @param {boolean} is_text
 * @returns {Node | null}
 */
function sibling(node, count = 1, is_text = false) {
	let next_sibling = node;

	while (count--) {
		next_sibling = /** @type {TemplateNode} */ (get_next_sibling(next_sibling));
	}

	{
		return next_sibling;
	}
}

/**
 * @template {Node} N
 * @param {N} node
 * @returns {void}
 */
function clear_text_content(node) {
	node.textContent = '';
}

/**
 * Returns `true` if we're updating the current block, for example `condition` in
 * an `{#if condition}` block just changed. In this case, the branch should be
 * appended (or removed) at the same time as other updates within the
 * current `<svelte:boundary>`
 */
function should_defer_append() {
	return false;
}

/** @import { Derived, Effect } from '#client' */
/** @import { Boundary } from './dom/blocks/boundary.js' */

/**
 * @param {unknown} error
 */
function handle_error(error) {
	var effect = active_effect;

	// for unowned deriveds, don't throw until we read the value
	if (effect === null) {
		/** @type {Derived} */ (active_reaction).f |= ERROR_VALUE;
		return error;
	}

	if ((effect.f & EFFECT_RAN) === 0) {
		// if the error occurred while creating this subtree, we let it
		// bubble up until it hits a boundary that can handle it
		if ((effect.f & BOUNDARY_EFFECT) === 0) {

			throw error;
		}

		/** @type {Boundary} */ (effect.b).error(error);
	} else {
		// otherwise we bubble up the effect tree ourselves
		invoke_error_boundary(error, effect);
	}
}

/**
 * @param {unknown} error
 * @param {Effect | null} effect
 */
function invoke_error_boundary(error, effect) {
	while (effect !== null) {
		if ((effect.f & BOUNDARY_EFFECT) !== 0) {
			try {
				/** @type {Boundary} */ (effect.b).error(error);
				return;
			} catch (e) {
				error = e;
			}
		}

		effect = effect.parent;
	}

	throw error;
}

/** @import { Fork } from 'svelte' */
/** @import { Derived, Effect, Reaction, Source, Value } from '#client' */

/**
 * @typedef {{
 *   parent: EffectTarget | null;
 *   effect: Effect | null;
 *   effects: Effect[];
 *   render_effects: Effect[];
 *   block_effects: Effect[];
 * }} EffectTarget
 */

/** @type {Set<Batch>} */
const batches = new Set();

/** @type {Batch | null} */
let current_batch = null;

/**
 * This is needed to avoid overwriting inputs in non-async mode
 * TODO 6.0 remove this, as non-async mode will go away
 * @type {Batch | null}
 */
let previous_batch = null;

/**
 * When time travelling (i.e. working in one batch, while other batches
 * still have ongoing work), we ignore the real values of affected
 * signals in favour of their values within the batch
 * @type {Map<Value, any> | null}
 */
let batch_values = null;

// TODO this should really be a property of `batch`
/** @type {Effect[]} */
let queued_root_effects = [];

/** @type {Effect | null} */
let last_scheduled_effect = null;

let is_flushing = false;
let is_flushing_sync = false;

class Batch {
	committed = false;

	/**
	 * The current values of any sources that are updated in this batch
	 * They keys of this map are identical to `this.#previous`
	 * @type {Map<Source, any>}
	 */
	current = new Map();

	/**
	 * The values of any sources that are updated in this batch _before_ those updates took place.
	 * They keys of this map are identical to `this.#current`
	 * @type {Map<Source, any>}
	 */
	previous = new Map();

	/**
	 * When the batch is committed (and the DOM is updated), we need to remove old branches
	 * and append new ones by calling the functions added inside (if/each/key/etc) blocks
	 * @type {Set<() => void>}
	 */
	#commit_callbacks = new Set();

	/**
	 * If a fork is discarded, we need to destroy any effects that are no longer needed
	 * @type {Set<(batch: Batch) => void>}
	 */
	#discard_callbacks = new Set();

	/**
	 * The number of async effects that are currently in flight
	 */
	#pending = 0;

	/**
	 * The number of async effects that are currently in flight, _not_ inside a pending boundary
	 */
	#blocking_pending = 0;

	/**
	 * A deferred that resolves when the batch is committed, used with `settled()`
	 * TODO replace with Promise.withResolvers once supported widely enough
	 * @type {{ promise: Promise<void>, resolve: (value?: any) => void, reject: (reason: unknown) => void } | null}
	 */
	#deferred = null;

	/**
	 * Deferred effects (which run after async work has completed) that are DIRTY
	 * @type {Effect[]}
	 */
	#dirty_effects = [];

	/**
	 * Deferred effects that are MAYBE_DIRTY
	 * @type {Effect[]}
	 */
	#maybe_dirty_effects = [];

	/**
	 * A set of branches that still exist, but will be destroyed when this batch
	 * is committed — we skip over these during `process`
	 * @type {Set<Effect>}
	 */
	skipped_effects = new Set();

	is_fork = false;

	is_deferred() {
		return this.is_fork || this.#blocking_pending > 0;
	}

	/**
	 *
	 * @param {Effect[]} root_effects
	 */
	process(root_effects) {
		queued_root_effects = [];

		previous_batch = null;

		this.apply();

		/** @type {EffectTarget} */
		var target = {
			parent: null,
			effect: null,
			effects: [],
			render_effects: [],
			block_effects: []
		};

		for (const root of root_effects) {
			this.#traverse_effect_tree(root, target);
			// Note: #traverse_effect_tree runs block effects eagerly, which can schedule effects,
			// which means queued_root_effects now may be filled again.

			// Helpful for debugging reactivity loss that has to do with branches being skipped:
			// log_inconsistent_branches(root);
		}

		if (!this.is_fork) {
			this.#resolve();
		}

		if (this.is_deferred()) {
			this.#defer_effects(target.effects);
			this.#defer_effects(target.render_effects);
			this.#defer_effects(target.block_effects);
		} else {
			// If sources are written to, then work needs to happen in a separate batch, else prior sources would be mixed with
			// newly updated sources, which could lead to infinite loops when effects run over and over again.
			previous_batch = this;
			current_batch = null;

			flush_queued_effects(target.render_effects);
			flush_queued_effects(target.effects);

			previous_batch = null;

			this.#deferred?.resolve();
		}

		batch_values = null;
	}

	/**
	 * Traverse the effect tree, executing effects or stashing
	 * them for later execution as appropriate
	 * @param {Effect} root
	 * @param {EffectTarget} target
	 */
	#traverse_effect_tree(root, target) {
		root.f ^= CLEAN;

		var effect = root.first;

		while (effect !== null) {
			var flags = effect.f;
			var is_branch = (flags & (BRANCH_EFFECT | ROOT_EFFECT)) !== 0;
			var is_skippable_branch = is_branch && (flags & CLEAN) !== 0;

			var skip = is_skippable_branch || (flags & INERT) !== 0 || this.skipped_effects.has(effect);

			if ((effect.f & BOUNDARY_EFFECT) !== 0 && effect.b?.is_pending()) {
				target = {
					parent: target,
					effect,
					effects: [],
					render_effects: [],
					block_effects: []
				};
			}

			if (!skip && effect.fn !== null) {
				if (is_branch) {
					effect.f ^= CLEAN;
				} else if ((flags & EFFECT) !== 0) {
					target.effects.push(effect);
				} else if (is_dirty(effect)) {
					if ((effect.f & BLOCK_EFFECT) !== 0) target.block_effects.push(effect);
					update_effect(effect);
				}

				var child = effect.first;

				if (child !== null) {
					effect = child;
					continue;
				}
			}

			var parent = effect.parent;
			effect = effect.next;

			while (effect === null && parent !== null) {
				if (parent === target.effect) {
					// TODO rather than traversing into pending boundaries and deferring the effects,
					// could we just attach the effects _to_ the pending boundary and schedule them
					// once the boundary is ready?
					this.#defer_effects(target.effects);
					this.#defer_effects(target.render_effects);
					this.#defer_effects(target.block_effects);

					target = /** @type {EffectTarget} */ (target.parent);
				}

				effect = parent.next;
				parent = parent.parent;
			}
		}
	}

	/**
	 * @param {Effect[]} effects
	 */
	#defer_effects(effects) {
		for (const e of effects) {
			const target = (e.f & DIRTY) !== 0 ? this.#dirty_effects : this.#maybe_dirty_effects;
			target.push(e);

			// Since we're not executing these effects now, we need to clear any WAS_MARKED flags
			// so that other batches can correctly reach these effects during their own traversal
			this.#clear_marked(e.deps);

			// mark as clean so they get scheduled if they depend on pending async state
			set_signal_status(e, CLEAN);
		}
	}

	/**
	 * @param {Value[] | null} deps
	 */
	#clear_marked(deps) {
		if (deps === null) return;

		for (const dep of deps) {
			if ((dep.f & DERIVED) === 0 || (dep.f & WAS_MARKED) === 0) {
				continue;
			}

			dep.f ^= WAS_MARKED;

			this.#clear_marked(/** @type {Derived} */ (dep).deps);
		}
	}

	/**
	 * Associate a change to a given source with the current
	 * batch, noting its previous and current values
	 * @param {Source} source
	 * @param {any} value
	 */
	capture(source, value) {
		if (!this.previous.has(source)) {
			this.previous.set(source, value);
		}

		// Don't save errors in `batch_values`, or they won't be thrown in `runtime.js#get`
		if ((source.f & ERROR_VALUE) === 0) {
			this.current.set(source, source.v);
			batch_values?.set(source, source.v);
		}
	}

	activate() {
		current_batch = this;
		this.apply();
	}

	deactivate() {
		// If we're not the current batch, don't deactivate,
		// else we could create zombie batches that are never flushed
		if (current_batch !== this) return;

		current_batch = null;
		batch_values = null;
	}

	flush() {
		this.activate();

		if (queued_root_effects.length > 0) {
			flush_effects();

			if (current_batch !== null && current_batch !== this) {
				// this can happen if a new batch was created during `flush_effects()`
				return;
			}
		} else if (this.#pending === 0) {
			this.process([]); // TODO this feels awkward
		}

		this.deactivate();
	}

	discard() {
		for (const fn of this.#discard_callbacks) fn(this);
		this.#discard_callbacks.clear();
	}

	#resolve() {
		if (this.#blocking_pending === 0) {
			// append/remove branches
			for (const fn of this.#commit_callbacks) fn();
			this.#commit_callbacks.clear();
		}

		if (this.#pending === 0) {
			this.#commit();
		}
	}

	#commit() {
		// If there are other pending batches, they now need to be 'rebased' —
		// in other words, we re-run block/async effects with the newly
		// committed state, unless the batch in question has a more
		// recent value for a given source
		if (batches.size > 1) {
			this.previous.clear();

			var previous_batch_values = batch_values;
			var is_earlier = true;

			/** @type {EffectTarget} */
			var dummy_target = {
				parent: null,
				effect: null,
				effects: [],
				render_effects: [],
				block_effects: []
			};

			for (const batch of batches) {
				if (batch === this) {
					is_earlier = false;
					continue;
				}

				/** @type {Source[]} */
				const sources = [];

				for (const [source, value] of this.current) {
					if (batch.current.has(source)) {
						if (is_earlier && value !== batch.current.get(source)) {
							// bring the value up to date
							batch.current.set(source, value);
						} else {
							// same value or later batch has more recent value,
							// no need to re-run these effects
							continue;
						}
					}

					sources.push(source);
				}

				if (sources.length === 0) {
					continue;
				}

				// Re-run async/block effects that depend on distinct values changed in both batches
				const others = [...batch.current.keys()].filter((s) => !this.current.has(s));
				if (others.length > 0) {
					// Avoid running queued root effects on the wrong branch
					var prev_queued_root_effects = queued_root_effects;
					queued_root_effects = [];

					/** @type {Set<Value>} */
					const marked = new Set();
					/** @type {Map<Reaction, boolean>} */
					const checked = new Map();
					for (const source of sources) {
						mark_effects(source, others, marked, checked);
					}

					if (queued_root_effects.length > 0) {
						current_batch = batch;
						batch.apply();

						for (const root of queued_root_effects) {
							batch.#traverse_effect_tree(root, dummy_target);
						}

						// TODO do we need to do anything with `target`? defer block effects?

						batch.deactivate();
					}

					queued_root_effects = prev_queued_root_effects;
				}
			}

			current_batch = null;
			batch_values = previous_batch_values;
		}

		this.committed = true;
		batches.delete(this);
	}

	/**
	 *
	 * @param {boolean} blocking
	 */
	increment(blocking) {
		this.#pending += 1;
		if (blocking) this.#blocking_pending += 1;
	}

	/**
	 *
	 * @param {boolean} blocking
	 */
	decrement(blocking) {
		this.#pending -= 1;
		if (blocking) this.#blocking_pending -= 1;

		this.revive();
	}

	revive() {
		for (const e of this.#dirty_effects) {
			set_signal_status(e, DIRTY);
			schedule_effect(e);
		}

		for (const e of this.#maybe_dirty_effects) {
			set_signal_status(e, MAYBE_DIRTY);
			schedule_effect(e);
		}

		this.#dirty_effects = [];
		this.#maybe_dirty_effects = [];

		this.flush();
	}

	/** @param {() => void} fn */
	oncommit(fn) {
		this.#commit_callbacks.add(fn);
	}

	/** @param {(batch: Batch) => void} fn */
	ondiscard(fn) {
		this.#discard_callbacks.add(fn);
	}

	settled() {
		return (this.#deferred ??= deferred()).promise;
	}

	static ensure() {
		if (current_batch === null) {
			const batch = (current_batch = new Batch());
			batches.add(current_batch);

			if (!is_flushing_sync) {
				Batch.enqueue(() => {
					if (current_batch !== batch) {
						// a flushSync happened in the meantime
						return;
					}

					batch.flush();
				});
			}
		}

		return current_batch;
	}

	/** @param {() => void} task */
	static enqueue(task) {
		queue_micro_task(task);
	}

	apply() {
		return;
	}
}

/**
 * Synchronously flush any pending updates.
 * Returns void if no callback is provided, otherwise returns the result of calling the callback.
 * @template [T=void]
 * @param {(() => T) | undefined} [fn]
 * @returns {T}
 */
function flushSync(fn) {
	var was_flushing_sync = is_flushing_sync;
	is_flushing_sync = true;

	try {
		var result;

		if (fn) ;

		while (true) {
			flush_tasks();

			if (queued_root_effects.length === 0) {
				current_batch?.flush();

				// we need to check again, in case we just updated an `$effect.pending()`
				if (queued_root_effects.length === 0) {
					// this would be reset in `flush_effects()` but since we are early returning here,
					// we need to reset it here as well in case the first time there's 0 queued root effects
					last_scheduled_effect = null;

					return /** @type {T} */ (result);
				}
			}

			flush_effects();
		}
	} finally {
		is_flushing_sync = was_flushing_sync;
	}
}

function flush_effects() {
	var was_updating_effect = is_updating_effect;
	is_flushing = true;

	var source_stacks = null;

	try {
		var flush_count = 0;
		set_is_updating_effect(true);

		while (queued_root_effects.length > 0) {
			var batch = Batch.ensure();

			if (flush_count++ > 1000) {
				var updates, entry; if (DEV) ;

				infinite_loop_guard();
			}

			batch.process(queued_root_effects);
			old_values.clear();

			if (DEV) ;
		}
	} finally {
		is_flushing = false;
		set_is_updating_effect(was_updating_effect);

		last_scheduled_effect = null;
	}
}

function infinite_loop_guard() {
	try {
		effect_update_depth_exceeded();
	} catch (error) {

		// Best effort: invoke the boundary nearest the most recent
		// effect and hope that it's relevant to the infinite loop
		invoke_error_boundary(error, last_scheduled_effect);
	}
}

/** @type {Set<Effect> | null} */
let eager_block_effects = null;

/**
 * @param {Array<Effect>} effects
 * @returns {void}
 */
function flush_queued_effects(effects) {
	var length = effects.length;
	if (length === 0) return;

	var i = 0;

	while (i < length) {
		var effect = effects[i++];

		if ((effect.f & (DESTROYED | INERT)) === 0 && is_dirty(effect)) {
			eager_block_effects = new Set();

			update_effect(effect);

			// Effects with no dependencies or teardown do not get added to the effect tree.
			// Deferred effects (e.g. `$effect(...)`) _are_ added to the tree because we
			// don't know if we need to keep them until they are executed. Doing the check
			// here (rather than in `update_effect`) allows us to skip the work for
			// immediate effects.
			if (effect.deps === null && effect.first === null && effect.nodes_start === null) {
				// if there's no teardown or abort controller we completely unlink
				// the effect from the graph
				if (effect.teardown === null && effect.ac === null) {
					// remove this effect from the graph
					unlink_effect(effect);
				} else {
					// keep the effect in the graph, but free up some memory
					effect.fn = null;
				}
			}

			// If update_effect() has a flushSync() in it, we may have flushed another flush_queued_effects(),
			// which already handled this logic and did set eager_block_effects to null.
			if (eager_block_effects?.size > 0) {
				old_values.clear();

				for (const e of eager_block_effects) {
					// Skip eager effects that have already been unmounted
					if ((e.f & (DESTROYED | INERT)) !== 0) continue;

					// Run effects in order from ancestor to descendant, else we could run into nullpointers
					/** @type {Effect[]} */
					const ordered_effects = [e];
					let ancestor = e.parent;
					while (ancestor !== null) {
						if (eager_block_effects.has(ancestor)) {
							eager_block_effects.delete(ancestor);
							ordered_effects.push(ancestor);
						}
						ancestor = ancestor.parent;
					}

					for (let j = ordered_effects.length - 1; j >= 0; j--) {
						const e = ordered_effects[j];
						// Skip eager effects that have already been unmounted
						if ((e.f & (DESTROYED | INERT)) !== 0) continue;
						update_effect(e);
					}
				}

				eager_block_effects.clear();
			}
		}
	}

	eager_block_effects = null;
}

/**
 * This is similar to `mark_reactions`, but it only marks async/block effects
 * depending on `value` and at least one of the other `sources`, so that
 * these effects can re-run after another batch has been committed
 * @param {Value} value
 * @param {Source[]} sources
 * @param {Set<Value>} marked
 * @param {Map<Reaction, boolean>} checked
 */
function mark_effects(value, sources, marked, checked) {
	if (marked.has(value)) return;
	marked.add(value);

	if (value.reactions !== null) {
		for (const reaction of value.reactions) {
			const flags = reaction.f;

			if ((flags & DERIVED) !== 0) {
				mark_effects(/** @type {Derived} */ (reaction), sources, marked, checked);
			} else if (
				(flags & (ASYNC | BLOCK_EFFECT)) !== 0 &&
				(flags & DIRTY) === 0 &&
				depends_on(reaction, sources, checked)
			) {
				set_signal_status(reaction, DIRTY);
				schedule_effect(/** @type {Effect} */ (reaction));
			}
		}
	}
}

/**
 * @param {Reaction} reaction
 * @param {Source[]} sources
 * @param {Map<Reaction, boolean>} checked
 */
function depends_on(reaction, sources, checked) {
	const depends = checked.get(reaction);
	if (depends !== undefined) return depends;

	if (reaction.deps !== null) {
		for (const dep of reaction.deps) {
			if (sources.includes(dep)) {
				return true;
			}

			if ((dep.f & DERIVED) !== 0 && depends_on(/** @type {Derived} */ (dep), sources, checked)) {
				checked.set(/** @type {Derived} */ (dep), true);
				return true;
			}
		}
	}

	checked.set(reaction, false);

	return false;
}

/**
 * @param {Effect} signal
 * @returns {void}
 */
function schedule_effect(signal) {
	var effect = (last_scheduled_effect = signal);

	while (effect.parent !== null) {
		effect = effect.parent;
		var flags = effect.f;

		// if the effect is being scheduled because a parent (each/await/etc) block
		// updated an internal source, bail out or we'll cause a second flush
		if (
			is_flushing &&
			effect === active_effect &&
			(flags & BLOCK_EFFECT) !== 0 &&
			(flags & HEAD_EFFECT) === 0
		) {
			return;
		}

		if ((flags & (ROOT_EFFECT | BRANCH_EFFECT)) !== 0) {
			if ((flags & CLEAN) === 0) return;
			effect.f ^= CLEAN;
		}
	}

	queued_root_effects.push(effect);
}

/**
 * Returns a `subscribe` function that integrates external event-based systems with Svelte's reactivity.
 * It's particularly useful for integrating with web APIs like `MediaQuery`, `IntersectionObserver`, or `WebSocket`.
 *
 * If `subscribe` is called inside an effect (including indirectly, for example inside a getter),
 * the `start` callback will be called with an `update` function. Whenever `update` is called, the effect re-runs.
 *
 * If `start` returns a cleanup function, it will be called when the effect is destroyed.
 *
 * If `subscribe` is called in multiple effects, `start` will only be called once as long as the effects
 * are active, and the returned teardown function will only be called when all effects are destroyed.
 *
 * It's best understood with an example. Here's an implementation of [`MediaQuery`](https://svelte.dev/docs/svelte/svelte-reactivity#MediaQuery):
 *
 * ```js
 * import { createSubscriber } from 'svelte/reactivity';
 * import { on } from 'svelte/events';
 *
 * export class MediaQuery {
 * 	#query;
 * 	#subscribe;
 *
 * 	constructor(query) {
 * 		this.#query = window.matchMedia(`(${query})`);
 *
 * 		this.#subscribe = createSubscriber((update) => {
 * 			// when the `change` event occurs, re-run any effects that read `this.current`
 * 			const off = on(this.#query, 'change', update);
 *
 * 			// stop listening when all the effects are destroyed
 * 			return () => off();
 * 		});
 * 	}
 *
 * 	get current() {
 * 		// This makes the getter reactive, if read in an effect
 * 		this.#subscribe();
 *
 * 		// Return the current state of the query, whether or not we're in an effect
 * 		return this.#query.matches;
 * 	}
 * }
 * ```
 * @param {(update: () => void) => (() => void) | void} start
 * @since 5.7.0
 */
function createSubscriber(start) {
	let subscribers = 0;
	let version = source(0);
	/** @type {(() => void) | void} */
	let stop;

	return () => {
		if (effect_tracking()) {
			get$1(version);

			render_effect(() => {
				if (subscribers === 0) {
					stop = untrack(() => start(() => increment(version)));
				}

				subscribers += 1;

				return () => {
					queue_micro_task(() => {
						// Only count down after a microtask, else we would reach 0 before our own render effect reruns,
						// but reach 1 again when the tick callback of the prior teardown runs. That would mean we
						// re-subcribe unnecessarily and create a memory leak because the old subscription is never cleaned up.
						subscribers -= 1;

						if (subscribers === 0) {
							stop?.();
							stop = undefined;
							// Increment the version to ensure any dependent deriveds are marked dirty when the subscription is picked up again later.
							// If we didn't do this then the comparison of write versions would determine that the derived has a later version than
							// the subscriber, and it would not be re-run.
							increment(version);
						}
					});
				};
			});
		}
	};
}

/** @import { Effect, Source, TemplateNode, } from '#client' */

/**
 * @typedef {{
 * 	 onerror?: (error: unknown, reset: () => void) => void;
 *   failed?: (anchor: Node, error: () => unknown, reset: () => () => void) => void;
 *   pending?: (anchor: Node) => void;
 * }} BoundaryProps
 */

var flags = EFFECT_TRANSPARENT | EFFECT_PRESERVED | BOUNDARY_EFFECT;

/**
 * @param {TemplateNode} node
 * @param {BoundaryProps} props
 * @param {((anchor: Node) => void)} children
 * @returns {void}
 */
function boundary(node, props, children) {
	new Boundary(node, props, children);
}

class Boundary {
	/** @type {Boundary | null} */
	parent;

	#pending = false;

	/** @type {TemplateNode} */
	#anchor;

	/** @type {TemplateNode | null} */
	#hydrate_open = null;

	/** @type {BoundaryProps} */
	#props;

	/** @type {((anchor: Node) => void)} */
	#children;

	/** @type {Effect} */
	#effect;

	/** @type {Effect | null} */
	#main_effect = null;

	/** @type {Effect | null} */
	#pending_effect = null;

	/** @type {Effect | null} */
	#failed_effect = null;

	/** @type {DocumentFragment | null} */
	#offscreen_fragment = null;

	/** @type {TemplateNode | null} */
	#pending_anchor = null;

	#local_pending_count = 0;
	#pending_count = 0;

	#is_creating_fallback = false;

	/**
	 * A source containing the number of pending async deriveds/expressions.
	 * Only created if `$effect.pending()` is used inside the boundary,
	 * otherwise updating the source results in needless `Batch.ensure()`
	 * calls followed by no-op flushes
	 * @type {Source<number> | null}
	 */
	#effect_pending = null;

	#effect_pending_subscriber = createSubscriber(() => {
		this.#effect_pending = source(this.#local_pending_count);

		return () => {
			this.#effect_pending = null;
		};
	});

	/**
	 * @param {TemplateNode} node
	 * @param {BoundaryProps} props
	 * @param {((anchor: Node) => void)} children
	 */
	constructor(node, props, children) {
		this.#anchor = node;
		this.#props = props;
		this.#children = children;

		this.parent = /** @type {Effect} */ (active_effect).b;

		this.#pending = !!this.#props.pending;

		this.#effect = block(() => {
			/** @type {Effect} */ (active_effect).b = this;

			{
				var anchor = this.#get_anchor();

				try {
					this.#main_effect = branch(() => children(anchor));
				} catch (error) {
					this.error(error);
				}

				if (this.#pending_count > 0) {
					this.#show_pending_snippet();
				} else {
					this.#pending = false;
				}
			}

			return () => {
				this.#pending_anchor?.remove();
			};
		}, flags);
	}

	#hydrate_resolved_content() {
		try {
			this.#main_effect = branch(() => this.#children(this.#anchor));
		} catch (error) {
			this.error(error);
		}

		// Since server rendered resolved content, we never show pending state
		// Even if client-side async operations are still running, the content is already displayed
		this.#pending = false;
	}

	#hydrate_pending_content() {
		const pending = this.#props.pending;
		if (!pending) {
			return;
		}
		this.#pending_effect = branch(() => pending(this.#anchor));

		Batch.enqueue(() => {
			var anchor = this.#get_anchor();

			this.#main_effect = this.#run(() => {
				Batch.ensure();
				return branch(() => this.#children(anchor));
			});

			if (this.#pending_count > 0) {
				this.#show_pending_snippet();
			} else {
				pause_effect(/** @type {Effect} */ (this.#pending_effect), () => {
					this.#pending_effect = null;
				});

				this.#pending = false;
			}
		});
	}

	#get_anchor() {
		var anchor = this.#anchor;

		if (this.#pending) {
			this.#pending_anchor = create_text();
			this.#anchor.before(this.#pending_anchor);

			anchor = this.#pending_anchor;
		}

		return anchor;
	}

	/**
	 * Returns `true` if the effect exists inside a boundary whose pending snippet is shown
	 * @returns {boolean}
	 */
	is_pending() {
		return this.#pending || (!!this.parent && this.parent.is_pending());
	}

	has_pending_snippet() {
		return !!this.#props.pending;
	}

	/**
	 * @param {() => Effect | null} fn
	 */
	#run(fn) {
		var previous_effect = active_effect;
		var previous_reaction = active_reaction;
		var previous_ctx = component_context;

		set_active_effect(this.#effect);
		set_active_reaction(this.#effect);
		set_component_context(this.#effect.ctx);

		try {
			return fn();
		} catch (e) {
			handle_error(e);
			return null;
		} finally {
			set_active_effect(previous_effect);
			set_active_reaction(previous_reaction);
			set_component_context(previous_ctx);
		}
	}

	#show_pending_snippet() {
		const pending = /** @type {(anchor: Node) => void} */ (this.#props.pending);

		if (this.#main_effect !== null) {
			this.#offscreen_fragment = document.createDocumentFragment();
			this.#offscreen_fragment.append(/** @type {TemplateNode} */ (this.#pending_anchor));
			move_effect(this.#main_effect, this.#offscreen_fragment);
		}

		if (this.#pending_effect === null) {
			this.#pending_effect = branch(() => pending(this.#anchor));
		}
	}

	/**
	 * Updates the pending count associated with the currently visible pending snippet,
	 * if any, such that we can replace the snippet with content once work is done
	 * @param {1 | -1} d
	 */
	#update_pending_count(d) {
		if (!this.has_pending_snippet()) {
			if (this.parent) {
				this.parent.#update_pending_count(d);
			}

			// if there's no parent, we're in a scope with no pending snippet
			return;
		}

		this.#pending_count += d;

		if (this.#pending_count === 0) {
			this.#pending = false;

			if (this.#pending_effect) {
				pause_effect(this.#pending_effect, () => {
					this.#pending_effect = null;
				});
			}

			if (this.#offscreen_fragment) {
				this.#anchor.before(this.#offscreen_fragment);
				this.#offscreen_fragment = null;
			}
		}
	}

	/**
	 * Update the source that powers `$effect.pending()` inside this boundary,
	 * and controls when the current `pending` snippet (if any) is removed.
	 * Do not call from inside the class
	 * @param {1 | -1} d
	 */
	update_pending_count(d) {
		this.#update_pending_count(d);

		this.#local_pending_count += d;

		if (this.#effect_pending) {
			internal_set(this.#effect_pending, this.#local_pending_count);
		}
	}

	get_effect_pending() {
		this.#effect_pending_subscriber();
		return get$1(/** @type {Source<number>} */ (this.#effect_pending));
	}

	/** @param {unknown} error */
	error(error) {
		var onerror = this.#props.onerror;
		let failed = this.#props.failed;

		// If we have nothing to capture the error, or if we hit an error while
		// rendering the fallback, re-throw for another boundary to handle
		if (this.#is_creating_fallback || (!onerror && !failed)) {
			throw error;
		}

		if (this.#main_effect) {
			destroy_effect(this.#main_effect);
			this.#main_effect = null;
		}

		if (this.#pending_effect) {
			destroy_effect(this.#pending_effect);
			this.#pending_effect = null;
		}

		if (this.#failed_effect) {
			destroy_effect(this.#failed_effect);
			this.#failed_effect = null;
		}

		var did_reset = false;
		var calling_on_error = false;

		const reset = () => {
			if (did_reset) {
				svelte_boundary_reset_noop();
				return;
			}

			did_reset = true;

			if (calling_on_error) {
				svelte_boundary_reset_onerror();
			}

			// If the failure happened while flushing effects, current_batch can be null
			Batch.ensure();

			this.#local_pending_count = 0;

			if (this.#failed_effect !== null) {
				pause_effect(this.#failed_effect, () => {
					this.#failed_effect = null;
				});
			}

			// we intentionally do not try to find the nearest pending boundary. If this boundary has one, we'll render it on reset
			// but it would be really weird to show the parent's boundary on a child reset.
			this.#pending = this.has_pending_snippet();

			this.#main_effect = this.#run(() => {
				this.#is_creating_fallback = false;
				return branch(() => this.#children(this.#anchor));
			});

			if (this.#pending_count > 0) {
				this.#show_pending_snippet();
			} else {
				this.#pending = false;
			}
		};

		var previous_reaction = active_reaction;

		try {
			set_active_reaction(null);
			calling_on_error = true;
			onerror?.(error, reset);
			calling_on_error = false;
		} catch (error) {
			invoke_error_boundary(error, this.#effect && this.#effect.parent);
		} finally {
			set_active_reaction(previous_reaction);
		}

		if (failed) {
			queue_micro_task(() => {
				this.#failed_effect = this.#run(() => {
					Batch.ensure();
					this.#is_creating_fallback = true;

					try {
						return branch(() => {
							failed(
								this.#anchor,
								() => error,
								() => reset
							);
						});
					} catch (error) {
						invoke_error_boundary(error, /** @type {Effect} */ (this.#effect.parent));
						return null;
					} finally {
						this.#is_creating_fallback = false;
					}
				});
			});
		}
	}
}

/** @import { EachItem, EachState, Effect, MaybeSource, Source, TemplateNode, TransitionManager, Value } from '#client' */
/** @import { Batch } from '../../reactivity/batch.js'; */

/**
 * The row of a keyed each block that is currently updating. We track this
 * so that `animate:` directives have something to attach themselves to
 * @type {EachItem | null}
 */
let current_each_item = null;

/** @param {EachItem | null} item */
function set_current_each_item(item) {
	current_each_item = item;
}

/**
 * @param {any} _
 * @param {number} i
 */
function index(_, i) {
	return i;
}

/**
 * Pause multiple effects simultaneously, and coordinate their
 * subsequent destruction. Used in each blocks
 * @param {EachState} state
 * @param {EachItem[]} to_destroy
 * @param {null | Node} controlled_anchor
 */
function pause_effects(state, to_destroy, controlled_anchor) {
	/** @type {TransitionManager[]} */
	var transitions = [];
	var length = to_destroy.length;

	for (var i = 0; i < length; i++) {
		pause_children(to_destroy[i].e, transitions, true);
	}

	run_out_transitions(transitions, () => {
		// If we're in a controlled each block (i.e. the block is the only child of an
		// element), and we are removing all items, _and_ there are no out transitions,
		// we can use the fast path — emptying the element and replacing the anchor
		var fast_path = transitions.length === 0 && controlled_anchor !== null;

		// TODO only destroy effects if no pending batch needs them. otherwise,
		// just set `item.o` back to `false`

		if (fast_path) {
			var anchor = /** @type {Element} */ (controlled_anchor);
			var parent_node = /** @type {Element} */ (anchor.parentNode);

			clear_text_content(parent_node);
			parent_node.append(anchor);

			state.items.clear();
			link(state, to_destroy[0].prev, to_destroy[length - 1].next);
		}

		for (var i = 0; i < length; i++) {
			var item = to_destroy[i];

			if (!fast_path) {
				state.items.delete(item.k);
				link(state, item.prev, item.next);
			}

			destroy_effect(item.e, !fast_path);
		}

		if (state.first === to_destroy[0]) {
			state.first = to_destroy[0].prev;
		}
	});
}

/**
 * @template V
 * @param {Element | Comment} node The next sibling node, or the parent node if this is a 'controlled' block
 * @param {number} flags
 * @param {() => V[]} get_collection
 * @param {(value: V, index: number) => any} get_key
 * @param {(anchor: Node, item: MaybeSource<V>, index: MaybeSource<number>) => void} render_fn
 * @param {null | ((anchor: Node) => void)} fallback_fn
 * @returns {void}
 */
function each(node, flags, get_collection, get_key, render_fn, fallback_fn = null) {
	var anchor = node;

	/** @type {Map<any, EachItem>} */
	var items = new Map();

	/** @type {EachItem | null} */
	var first = null;

	var is_controlled = (flags & EACH_IS_CONTROLLED) !== 0;
	var is_reactive_value = (flags & EACH_ITEM_REACTIVE) !== 0;
	var is_reactive_index = (flags & EACH_INDEX_REACTIVE) !== 0;

	if (is_controlled) {
		var parent_node = /** @type {Element} */ (node);

		anchor = parent_node.appendChild(create_text());
	}

	/** @type {{ fragment: DocumentFragment | null, effect: Effect } | null} */
	var fallback = null;

	// TODO: ideally we could use derived for runes mode but because of the ability
	// to use a store which can be mutated, we can't do that here as mutating a store
	// will still result in the collection array being the same from the store
	var each_array = derived_safe_equal(() => {
		var collection = get_collection();

		return is_array(collection) ? collection : collection == null ? [] : array_from(collection);
	});

	/** @type {V[]} */
	var array;

	var first_run = true;

	function commit() {
		reconcile(state, array, anchor, flags, get_key);

		if (fallback !== null) {
			if (array.length === 0) {
				if (fallback.fragment) {
					anchor.before(fallback.fragment);
					fallback.fragment = null;
				} else {
					resume_effect(fallback.effect);
				}

				effect.first = fallback.effect;
			} else {
				pause_effect(fallback.effect, () => {
					// TODO only null out if no pending batch needs it,
					// otherwise re-add `fallback.fragment` and move the
					// effect into it
					fallback = null;
				});
			}
		}
	}

	var effect = block(() => {
		array = /** @type {V[]} */ (get$1(each_array));
		var length = array.length;

		var keys = new Set();
		var batch = /** @type {Batch} */ (current_batch);
		var prev = null;
		var defer = should_defer_append();

		for (var i = 0; i < length; i += 1) {

			var value = array[i];
			var key = get_key(value, i);

			var item = first_run ? null : items.get(key);

			if (item) {
				// update before reconciliation, to trigger any async updates
				if (is_reactive_value) {
					internal_set(item.v, value);
				}

				if (is_reactive_index) {
					internal_set(/** @type {Value<number>} */ (item.i), i);
				} else {
					item.i = i;
				}

				if (defer) {
					batch.skipped_effects.delete(item.e);
				}
			} else {
				item = create_item(
					first_run ? anchor : null,
					prev,
					value,
					key,
					i,
					render_fn,
					flags,
					get_collection
				);

				if (first_run) {
					item.o = true;

					if (prev === null) {
						first = item;
					} else {
						prev.next = item;
					}

					prev = item;
				}

				items.set(key, item);
			}

			keys.add(key);
		}

		if (length === 0 && fallback_fn && !fallback) {
			if (first_run) {
				fallback = {
					fragment: null,
					effect: branch(() => fallback_fn(anchor))
				};
			} else {
				var fragment = document.createDocumentFragment();
				var target = create_text();
				fragment.append(target);

				fallback = {
					fragment,
					effect: branch(() => fallback_fn(target))
				};
			}
		}

		if (!first_run) {
			if (defer) {
				for (const [key, item] of items) {
					if (!keys.has(key)) {
						batch.skipped_effects.add(item.e);
					}
				}

				batch.oncommit(commit);
				batch.ondiscard(() => {
					// TODO presumably we need to do something here?
				});
			} else {
				commit();
			}
		}

		// When we mount the each block for the first time, the collection won't be
		// connected to this effect as the effect hasn't finished running yet and its deps
		// won't be assigned. However, it's possible that when reconciling the each block
		// that a mutation occurred and it's made the collection MAYBE_DIRTY, so reading the
		// collection again can provide consistency to the reactive graph again as the deriveds
		// will now be `CLEAN`.
		get$1(each_array);
	});

	/** @type {EachState} */
	var state = { effect, items, first };

	first_run = false;
}

/**
 * Add, remove, or reorder items output by an each block as its input changes
 * @template V
 * @param {EachState} state
 * @param {Array<V>} array
 * @param {Element | Comment | Text} anchor
 * @param {number} flags
 * @param {(value: V, index: number) => any} get_key
 * @returns {void}
 */
function reconcile(state, array, anchor, flags, get_key) {
	var is_animated = (flags & EACH_IS_ANIMATED) !== 0;

	var length = array.length;
	var items = state.items;
	var current = state.first;

	/** @type {undefined | Set<EachItem>} */
	var seen;

	/** @type {EachItem | null} */
	var prev = null;

	/** @type {undefined | Set<EachItem>} */
	var to_animate;

	/** @type {EachItem[]} */
	var matched = [];

	/** @type {EachItem[]} */
	var stashed = [];

	/** @type {V} */
	var value;

	/** @type {any} */
	var key;

	/** @type {EachItem | undefined} */
	var item;

	/** @type {number} */
	var i;

	if (is_animated) {
		for (i = 0; i < length; i += 1) {
			value = array[i];
			key = get_key(value, i);
			item = /** @type {EachItem} */ (items.get(key));

			// offscreen == coming in now, no animation in that case,
			// else this would happen https://github.com/sveltejs/svelte/issues/17181
			if (item.o) {
				item.a?.measure();
				(to_animate ??= new Set()).add(item);
			}
		}
	}

	for (i = 0; i < length; i += 1) {
		value = array[i];
		key = get_key(value, i);

		item = /** @type {EachItem} */ (items.get(key));

		state.first ??= item;

		if (!item.o) {
			item.o = true;

			var next = prev ? prev.next : current;

			link(state, prev, item);
			link(state, item, next);

			move(item, next, anchor);
			prev = item;

			matched = [];
			stashed = [];

			current = prev.next;
			continue;
		}

		if ((item.e.f & INERT) !== 0) {
			resume_effect(item.e);
			if (is_animated) {
				item.a?.unfix();
				(to_animate ??= new Set()).delete(item);
			}
		}

		if (item !== current) {
			if (seen !== undefined && seen.has(item)) {
				if (matched.length < stashed.length) {
					// more efficient to move later items to the front
					var start = stashed[0];
					var j;

					prev = start.prev;

					var a = matched[0];
					var b = matched[matched.length - 1];

					for (j = 0; j < matched.length; j += 1) {
						move(matched[j], start, anchor);
					}

					for (j = 0; j < stashed.length; j += 1) {
						seen.delete(stashed[j]);
					}

					link(state, a.prev, b.next);
					link(state, prev, a);
					link(state, b, start);

					current = start;
					prev = b;
					i -= 1;

					matched = [];
					stashed = [];
				} else {
					// more efficient to move earlier items to the back
					seen.delete(item);
					move(item, current, anchor);

					link(state, item.prev, item.next);
					link(state, item, prev === null ? state.first : prev.next);
					link(state, prev, item);

					prev = item;
				}

				continue;
			}

			matched = [];
			stashed = [];

			while (current !== null && current.k !== key) {
				// If the each block isn't inert and an item has an effect that is already inert,
				// skip over adding it to our seen Set as the item is already being handled
				if ((current.e.f & INERT) === 0) {
					(seen ??= new Set()).add(current);
				}
				stashed.push(current);
				current = current.next;
			}

			if (current === null) {
				continue;
			}

			item = current;
		}

		matched.push(item);
		prev = item;
		current = item.next;
	}

	let has_offscreen_items = items.size > length;

	if (current !== null || seen !== undefined) {
		var to_destroy = seen === undefined ? [] : array_from(seen);

		while (current !== null) {
			// If the each block isn't inert, then inert effects are currently outroing and will be removed once the transition is finished
			if ((current.e.f & INERT) === 0) {
				to_destroy.push(current);
			}
			current = current.next;
		}

		var destroy_length = to_destroy.length;

		has_offscreen_items = items.size - destroy_length > length;

		if (destroy_length > 0) {
			var controlled_anchor = (flags & EACH_IS_CONTROLLED) !== 0 && length === 0 ? anchor : null;

			if (is_animated) {
				for (i = 0; i < destroy_length; i += 1) {
					to_destroy[i].a?.measure();
				}

				for (i = 0; i < destroy_length; i += 1) {
					to_destroy[i].a?.fix();
				}
			}

			pause_effects(state, to_destroy, controlled_anchor);
		}
	}

	// Append offscreen items at the end
	if (has_offscreen_items) {
		for (const item of items.values()) {
			if (!item.o) {
				link(state, prev, item);
				prev = item;
			}
		}
	}

	state.effect.last = prev && prev.e;

	if (is_animated) {
		queue_micro_task(() => {
			if (to_animate === undefined) return;
			for (item of to_animate) {
				item.a?.apply();
			}
		});
	}
}

/**
 * @template V
 * @param {Node | null} anchor
 * @param {EachItem | null} prev
 * @param {V} value
 * @param {unknown} key
 * @param {number} index
 * @param {(anchor: Node, item: V | Source<V>, index: number | Value<number>, collection: () => V[]) => void} render_fn
 * @param {number} flags
 * @param {() => V[]} get_collection
 * @returns {EachItem}
 */
function create_item(anchor, prev, value, key, index, render_fn, flags, get_collection) {
	var previous_each_item = current_each_item;
	var reactive = (flags & EACH_ITEM_REACTIVE) !== 0;
	var mutable = (flags & EACH_ITEM_IMMUTABLE) === 0;

	var v = reactive ? (mutable ? mutable_source(value, false, false) : source(value)) : value;
	var i = (flags & EACH_INDEX_REACTIVE) === 0 ? index : source(index);

	/** @type {EachItem} */
	var item = {
		i,
		v,
		k: key,
		a: null,
		// @ts-expect-error
		e: null,
		o: false,
		prev,
		next: null
	};

	current_each_item = item;

	try {
		if (anchor === null) {
			var fragment = document.createDocumentFragment();
			fragment.append((anchor = create_text()));
		}

		item.e = branch(() => render_fn(/** @type {Node} */ (anchor), v, i, get_collection));

		if (prev !== null) {
			// we only need to set `prev.next = item`, because
			// `item.prev = prev` was set on initialization.
			// the effects themselves are already linked
			prev.next = item;
		}

		return item;
	} finally {
		current_each_item = previous_each_item;
	}
}

/**
 * @param {EachItem} item
 * @param {EachItem | null} next
 * @param {Text | Element | Comment} anchor
 */
function move(item, next, anchor) {
	var end = item.next ? /** @type {TemplateNode} */ (item.next.e.nodes_start) : anchor;

	var dest = next ? /** @type {TemplateNode} */ (next.e.nodes_start) : anchor;
	var node = /** @type {TemplateNode} */ (item.e.nodes_start);

	while (node !== null && node !== end) {
		var next_node = /** @type {TemplateNode} */ (get_next_sibling(node));
		dest.before(node);
		node = next_node;
	}
}

/**
 * @param {EachState} state
 * @param {EachItem | null} prev
 * @param {EachItem | null} next
 */
function link(state, prev, next) {
	if (prev === null) {
		state.first = next;
		state.effect.first = next && next.e;
	} else {
		if (prev.e.next) {
			prev.e.next.prev = null;
		}

		prev.next = next;
		prev.e.next = next && next.e;
	}

	if (next !== null) {
		if (next.e.prev) {
			next.e.prev.next = null;
		}

		next.prev = prev;
		next.e.prev = prev && prev.e;
	}
}

/** @import { Effect, TemplateNode, Value } from '#client' */

/**
 * @param {Array<Promise<void>>} blockers
 * @param {Array<() => any>} sync
 * @param {Array<() => Promise<any>>} async
 * @param {(values: Value[]) => any} fn
 */
function flatten(blockers, sync, async, fn) {
	const d = is_runes() ? derived : derived_safe_equal;

	if (async.length === 0 && blockers.length === 0) {
		fn(sync.map(d));
		return;
	}

	var batch = current_batch;
	var parent = /** @type {Effect} */ (active_effect);

	var restore = capture();

	function run() {
		Promise.all(async.map((expression) => async_derived(expression)))
			.then((result) => {
				restore();

				try {
					fn([...sync.map(d), ...result]);
				} catch (error) {
					// ignore errors in blocks that have already been destroyed
					if ((parent.f & DESTROYED) === 0) {
						invoke_error_boundary(error, parent);
					}
				}

				batch?.deactivate();
				unset_context();
			})
			.catch((error) => {
				invoke_error_boundary(error, parent);
			});
	}

	if (blockers.length > 0) {
		Promise.all(blockers).then(() => {
			restore();

			try {
				return run();
			} finally {
				batch?.deactivate();
				unset_context();
			}
		});
	} else {
		run();
	}
}

/**
 * @param {Array<Promise<void>>} blockers
 * @param {(values: Value[]) => any} fn
 */
function run_after_blockers(blockers, fn) {
	var each_item = current_each_item; // TODO should this be part of capture?
	flatten(blockers, [], [], (v) => {
		set_current_each_item(each_item);
		fn(v);
	});
}

/**
 * Captures the current effect context so that we can restore it after
 * some asynchronous work has happened (so that e.g. `await a + b`
 * causes `b` to be registered as a dependency).
 */
function capture() {
	var previous_effect = active_effect;
	var previous_reaction = active_reaction;
	var previous_component_context = component_context;
	var previous_batch = current_batch;

	return function restore(activate_batch = true) {
		set_active_effect(previous_effect);
		set_active_reaction(previous_reaction);
		set_component_context(previous_component_context);
		if (activate_batch) previous_batch?.activate();
	};
}

function unset_context() {
	set_active_effect(null);
	set_active_reaction(null);
	set_component_context(null);
}

/** @import { Derived, Effect, Source } from '#client' */
/** @import { Batch } from './batch.js'; */

/**
 * @template V
 * @param {() => V} fn
 * @returns {Derived<V>}
 */
/*#__NO_SIDE_EFFECTS__*/
function derived(fn) {
	var flags = DERIVED | DIRTY;
	var parent_derived =
		active_reaction !== null && (active_reaction.f & DERIVED) !== 0
			? /** @type {Derived} */ (active_reaction)
			: null;

	if (active_effect !== null) {
		// Since deriveds are evaluated lazily, any effects created inside them are
		// created too late to ensure that the parent effect is added to the tree
		active_effect.f |= EFFECT_PRESERVED;
	}

	/** @type {Derived<V>} */
	const signal = {
		ctx: component_context,
		deps: null,
		effects: null,
		equals,
		f: flags,
		fn,
		reactions: null,
		rv: 0,
		v: /** @type {V} */ (UNINITIALIZED),
		wv: 0,
		parent: parent_derived ?? active_effect,
		ac: null
	};

	return signal;
}

/**
 * @template V
 * @param {() => V | Promise<V>} fn
 * @param {string} [location] If provided, print a warning if the value is not read immediately after update
 * @returns {Promise<Source<V>>}
 */
/*#__NO_SIDE_EFFECTS__*/
function async_derived(fn, location) {
	let parent = /** @type {Effect | null} */ (active_effect);

	if (parent === null) {
		async_derived_orphan();
	}

	var boundary = /** @type {Boundary} */ (parent.b);

	var promise = /** @type {Promise<V>} */ (/** @type {unknown} */ (undefined));
	var signal = source(/** @type {V} */ (UNINITIALIZED));

	// only suspend in async deriveds created on initialisation
	var should_suspend = !active_reaction;

	/** @type {Map<Batch, ReturnType<typeof deferred<V>>>} */
	var deferreds = new Map();

	async_effect(() => {

		/** @type {ReturnType<typeof deferred<V>>} */
		var d = deferred();
		promise = d.promise;

		try {
			// If this code is changed at some point, make sure to still access the then property
			// of fn() to read any signals it might access, so that we track them as dependencies.
			// We call `unset_context` to undo any `save` calls that happen inside `fn()`
			Promise.resolve(fn())
				.then(d.resolve, d.reject)
				.then(() => {
					if (batch === current_batch && batch.committed) {
						// if the batch was rejected as stale, we need to cleanup
						// after any `$.save(...)` calls inside `fn()`
						batch.deactivate();
					}

					unset_context();
				});
		} catch (error) {
			d.reject(error);
			unset_context();
		}

		var batch = /** @type {Batch} */ (current_batch);

		if (should_suspend) {
			var blocking = !boundary.is_pending();

			boundary.update_pending_count(1);
			batch.increment(blocking);

			deferreds.get(batch)?.reject(STALE_REACTION);
			deferreds.delete(batch); // delete to ensure correct order in Map iteration below
			deferreds.set(batch, d);
		}

		/**
		 * @param {any} value
		 * @param {unknown} error
		 */
		const handler = (value, error = undefined) => {

			batch.activate();

			if (error) {
				if (error !== STALE_REACTION) {
					signal.f |= ERROR_VALUE;

					// @ts-expect-error the error is the wrong type, but we don't care
					internal_set(signal, error);
				}
			} else {
				if ((signal.f & ERROR_VALUE) !== 0) {
					signal.f ^= ERROR_VALUE;
				}

				internal_set(signal, value);

				// All prior async derived runs are now stale
				for (const [b, d] of deferreds) {
					deferreds.delete(b);
					if (b === batch) break;
					d.reject(STALE_REACTION);
				}
			}

			if (should_suspend) {
				boundary.update_pending_count(-1);
				batch.decrement(blocking);
			}
		};

		d.promise.then(handler, (e) => handler(null, e || 'unknown'));
	});

	teardown(() => {
		for (const d of deferreds.values()) {
			d.reject(STALE_REACTION);
		}
	});

	return new Promise((fulfil) => {
		/** @param {Promise<V>} p */
		function next(p) {
			function go() {
				if (p === promise) {
					fulfil(signal);
				} else {
					// if the effect re-runs before the initial promise
					// resolves, delay resolution until we have a value
					next(promise);
				}
			}

			p.then(go, go);
		}

		next(promise);
	});
}

/**
 * @template V
 * @param {() => V} fn
 * @returns {Derived<V>}
 */
/*#__NO_SIDE_EFFECTS__*/
function user_derived(fn) {
	const d = derived(fn);

	push_reaction_value(d);

	return d;
}

/**
 * @template V
 * @param {() => V} fn
 * @returns {Derived<V>}
 */
/*#__NO_SIDE_EFFECTS__*/
function derived_safe_equal(fn) {
	const signal = derived(fn);
	signal.equals = safe_equals;
	return signal;
}

/**
 * @param {Derived} derived
 * @returns {void}
 */
function destroy_derived_effects(derived) {
	var effects = derived.effects;

	if (effects !== null) {
		derived.effects = null;

		for (var i = 0; i < effects.length; i += 1) {
			destroy_effect(/** @type {Effect} */ (effects[i]));
		}
	}
}

/**
 * @param {Derived} derived
 * @returns {Effect | null}
 */
function get_derived_parent_effect(derived) {
	var parent = derived.parent;
	while (parent !== null) {
		if ((parent.f & DERIVED) === 0) {
			// The original parent effect might've been destroyed but the derived
			// is used elsewhere now - do not return the destroyed effect in that case
			return (parent.f & DESTROYED) === 0 ? /** @type {Effect} */ (parent) : null;
		}
		parent = parent.parent;
	}
	return null;
}

/**
 * @template T
 * @param {Derived} derived
 * @returns {T}
 */
function execute_derived(derived) {
	var value;
	var prev_active_effect = active_effect;

	set_active_effect(get_derived_parent_effect(derived));

	{
		try {
			derived.f &= ~WAS_MARKED;
			destroy_derived_effects(derived);
			value = update_reaction(derived);
		} finally {
			set_active_effect(prev_active_effect);
		}
	}

	return value;
}

/**
 * @param {Derived} derived
 * @returns {void}
 */
function update_derived(derived) {
	var value = execute_derived(derived);

	if (!derived.equals(value)) {
		// in a fork, we don't update the underlying value, just `batch_values`.
		// the underlying value will be updated when the fork is committed.
		// otherwise, the next time we get here after a 'real world' state
		// change, `derived.equals` may incorrectly return `true`
		if (!current_batch?.is_fork) {
			derived.v = value;
		}

		derived.wv = increment_write_version();
	}

	// don't mark derived clean if we're reading it inside a
	// cleanup function, or it will cache a stale value
	if (is_destroying_effect) {
		return;
	}

	// During time traveling we don't want to reset the status so that
	// traversal of the graph in the other batches still happens
	if (batch_values !== null) {
		// only cache the value if we're in a tracking context, otherwise we won't
		// clear the cache in `mark_reactions` when dependencies are updated
		if (effect_tracking() || current_batch?.is_fork) {
			batch_values.set(derived, value);
		}
	} else {
		var status = (derived.f & CONNECTED) === 0 ? MAYBE_DIRTY : CLEAN;
		set_signal_status(derived, status);
	}
}

/** @import { Derived, Effect, Source, Value } from '#client' */

/** @type {Set<any>} */
let eager_effects = new Set();

/** @type {Map<Source, any>} */
const old_values = new Map();

let eager_effects_deferred = false;

/**
 * @template V
 * @param {V} v
 * @param {Error | null} [stack]
 * @returns {Source<V>}
 */
// TODO rename this to `state` throughout the codebase
function source(v, stack) {
	/** @type {Value} */
	var signal = {
		f: 0, // TODO ideally we could skip this altogether, but it causes type errors
		v,
		reactions: null,
		equals,
		rv: 0,
		wv: 0
	};

	return signal;
}

/**
 * @template V
 * @param {V} v
 * @param {Error | null} [stack]
 */
/*#__NO_SIDE_EFFECTS__*/
function state(v, stack) {
	const s = source(v);

	push_reaction_value(s);

	return s;
}

/**
 * @template V
 * @param {V} initial_value
 * @param {boolean} [immutable]
 * @returns {Source<V>}
 */
/*#__NO_SIDE_EFFECTS__*/
function mutable_source(initial_value, immutable = false, trackable = true) {
	const s = source(initial_value);
	if (!immutable) {
		s.equals = safe_equals;
	}

	// bind the signal to the component context, in case we need to
	// track updates to trigger beforeUpdate/afterUpdate callbacks
	if (legacy_mode_flag && trackable && component_context !== null && component_context.l !== null) {
		(component_context.l.s ??= []).push(s);
	}

	return s;
}

/**
 * @template V
 * @param {Value<V>} source
 * @param {V} value
 */
function mutate(source, value) {
	set(
		source,
		untrack(() => get$1(source))
	);
	return value;
}

/**
 * @template V
 * @param {Source<V>} source
 * @param {V} value
 * @param {boolean} [should_proxy]
 * @returns {V}
 */
function set(source, value, should_proxy = false) {
	if (
		active_reaction !== null &&
		// since we are untracking the function inside `$inspect.with` we need to add this check
		// to ensure we error if state is set inside an inspect effect
		(!untracking || (active_reaction.f & EAGER_EFFECT) !== 0) &&
		is_runes() &&
		(active_reaction.f & (DERIVED | BLOCK_EFFECT | ASYNC | EAGER_EFFECT)) !== 0 &&
		!current_sources?.includes(source)
	) {
		state_unsafe_mutation();
	}

	let new_value = should_proxy ? proxy(value) : value;

	return internal_set(source, new_value);
}

/**
 * @template V
 * @param {Source<V>} source
 * @param {V} value
 * @returns {V}
 */
function internal_set(source, value) {
	if (!source.equals(value)) {
		var old_value = source.v;

		if (is_destroying_effect) {
			old_values.set(source, value);
		} else {
			old_values.set(source, old_value);
		}

		source.v = value;

		var batch = Batch.ensure();
		batch.capture(source, old_value);

		if ((source.f & DERIVED) !== 0) {
			// if we are assigning to a dirty derived we set it to clean/maybe dirty but we also eagerly execute it to track the dependencies
			if ((source.f & DIRTY) !== 0) {
				execute_derived(/** @type {Derived} */ (source));
			}

			set_signal_status(source, (source.f & CONNECTED) !== 0 ? CLEAN : MAYBE_DIRTY);
		}

		source.wv = increment_write_version();

		// For debugging, in case you want to know which reactions are being scheduled:
		// log_reactions(source);
		mark_reactions(source, DIRTY);

		// It's possible that the current reaction might not have up-to-date dependencies
		// whilst it's actively running. So in the case of ensuring it registers the reaction
		// properly for itself, we need to ensure the current effect actually gets
		// scheduled. i.e: `$effect(() => x++)`
		if (
			is_runes() &&
			active_effect !== null &&
			(active_effect.f & CLEAN) !== 0 &&
			(active_effect.f & (BRANCH_EFFECT | ROOT_EFFECT)) === 0
		) {
			if (untracked_writes === null) {
				set_untracked_writes([source]);
			} else {
				untracked_writes.push(source);
			}
		}

		if (!batch.is_fork && eager_effects.size > 0 && !eager_effects_deferred) {
			flush_eager_effects();
		}
	}

	return value;
}

function flush_eager_effects() {
	eager_effects_deferred = false;
	var prev_is_updating_effect = is_updating_effect;
	set_is_updating_effect(true);

	const inspects = Array.from(eager_effects);

	try {
		for (const effect of inspects) {
			// Mark clean inspect-effects as maybe dirty and then check their dirtiness
			// instead of just updating the effects - this way we avoid overfiring.
			if ((effect.f & CLEAN) !== 0) {
				set_signal_status(effect, MAYBE_DIRTY);
			}

			if (is_dirty(effect)) {
				update_effect(effect);
			}
		}
	} finally {
		set_is_updating_effect(prev_is_updating_effect);
	}

	eager_effects.clear();
}

/**
 * Silently (without using `get`) increment a source
 * @param {Source<number>} source
 */
function increment(source) {
	set(source, source.v + 1);
}

/**
 * @param {Value} signal
 * @param {number} status should be DIRTY or MAYBE_DIRTY
 * @returns {void}
 */
function mark_reactions(signal, status) {
	var reactions = signal.reactions;
	if (reactions === null) return;

	var runes = is_runes();
	var length = reactions.length;

	for (var i = 0; i < length; i++) {
		var reaction = reactions[i];
		var flags = reaction.f;

		// In legacy mode, skip the current effect to prevent infinite loops
		if (!runes && reaction === active_effect) continue;

		var not_dirty = (flags & DIRTY) === 0;

		// don't set a DIRTY reaction to MAYBE_DIRTY
		if (not_dirty) {
			set_signal_status(reaction, status);
		}

		if ((flags & DERIVED) !== 0) {
			var derived = /** @type {Derived} */ (reaction);

			batch_values?.delete(derived);

			if ((flags & WAS_MARKED) === 0) {
				// Only connected deriveds can be reliably unmarked right away
				if (flags & CONNECTED) {
					reaction.f |= WAS_MARKED;
				}

				mark_reactions(derived, MAYBE_DIRTY);
			}
		} else if (not_dirty) {
			if ((flags & BLOCK_EFFECT) !== 0 && eager_block_effects !== null) {
				eager_block_effects.add(/** @type {Effect} */ (reaction));
			}

			schedule_effect(/** @type {Effect} */ (reaction));
		}
	}
}

/**
 * @param {HTMLElement} dom
 * @param {boolean} value
 * @returns {void}
 */
function autofocus(dom, value) {
	if (value) {
		const body = document.body;
		dom.autofocus = true;

		queue_micro_task(() => {
			if (document.activeElement === body) {
				dom.focus();
			}
		});
	}
}

/**
 * The child of a textarea actually corresponds to the defaultValue property, so we need
 * to remove it upon hydration to avoid a bug when someone resets the form value.
 * @param {HTMLTextAreaElement} dom
 * @returns {void}
 */
function remove_textarea_child(dom) {
}

let listening_to_form_reset = false;

function add_form_reset_listener() {
	if (!listening_to_form_reset) {
		listening_to_form_reset = true;
		document.addEventListener(
			'reset',
			(evt) => {
				// Needs to happen one tick later or else the dom properties of the form
				// elements have not updated to their reset values yet
				Promise.resolve().then(() => {
					if (!evt.defaultPrevented) {
						for (const e of /**@type {HTMLFormElement} */ (evt.target).elements) {
							// @ts-expect-error
							e.__on_r?.();
						}
					}
				});
			},
			// In the capture phase to guarantee we get noticed of it (no possibility of stopPropagation)
			{ capture: true }
		);
	}
}

/**
 * @template T
 * @param {() => T} fn
 */
function without_reactive_context(fn) {
	var previous_reaction = active_reaction;
	var previous_effect = active_effect;
	set_active_reaction(null);
	set_active_effect(null);
	try {
		return fn();
	} finally {
		set_active_reaction(previous_reaction);
		set_active_effect(previous_effect);
	}
}

/**
 * Listen to the given event, and then instantiate a global form reset listener if not already done,
 * to notify all bindings when the form is reset
 * @param {HTMLElement} element
 * @param {string} event
 * @param {(is_reset?: true) => void} handler
 * @param {(is_reset?: true) => void} [on_reset]
 */
function listen_to_event_and_reset_event(element, event, handler, on_reset = handler) {
	element.addEventListener(event, () => without_reactive_context(handler));
	// @ts-expect-error
	const prev = element.__on_r;
	if (prev) {
		// special case for checkbox that can have multiple binds (group & checked)
		// @ts-expect-error
		element.__on_r = () => {
			prev();
			on_reset(true);
		};
	} else {
		// @ts-expect-error
		element.__on_r = () => on_reset(true);
	}

	add_form_reset_listener();
}

/** @import { Derived, Effect, Reaction, Signal, Source, Value } from '#client' */

let is_updating_effect = false;

/** @param {boolean} value */
function set_is_updating_effect(value) {
	is_updating_effect = value;
}

let is_destroying_effect = false;

/** @param {boolean} value */
function set_is_destroying_effect(value) {
	is_destroying_effect = value;
}

/** @type {null | Reaction} */
let active_reaction = null;

let untracking = false;

/** @param {null | Reaction} reaction */
function set_active_reaction(reaction) {
	active_reaction = reaction;
}

/** @type {null | Effect} */
let active_effect = null;

/** @param {null | Effect} effect */
function set_active_effect(effect) {
	active_effect = effect;
}

/**
 * When sources are created within a reaction, reading and writing
 * them within that reaction should not cause a re-run
 * @type {null | Source[]}
 */
let current_sources = null;

/** @param {Value} value */
function push_reaction_value(value) {
	if (active_reaction !== null && (true)) {
		if (current_sources === null) {
			current_sources = [value];
		} else {
			current_sources.push(value);
		}
	}
}

/**
 * The dependencies of the reaction that is currently being executed. In many cases,
 * the dependencies are unchanged between runs, and so this will be `null` unless
 * and until a new dependency is accessed — we track this via `skipped_deps`
 * @type {null | Value[]}
 */
let new_deps = null;

let skipped_deps = 0;

/**
 * Tracks writes that the effect it's executed in doesn't listen to yet,
 * so that the dependency can be added to the effect later on if it then reads it
 * @type {null | Source[]}
 */
let untracked_writes = null;

/** @param {null | Source[]} value */
function set_untracked_writes(value) {
	untracked_writes = value;
}

/**
 * @type {number} Used by sources and deriveds for handling updates.
 * Version starts from 1 so that unowned deriveds differentiate between a created effect and a run one for tracing
 **/
let write_version = 1;

/** @type {number} Used to version each read of a source of derived to avoid duplicating depedencies inside a reaction */
let read_version = 0;

let update_version = read_version;

/** @param {number} value */
function set_update_version(value) {
	update_version = value;
}

function increment_write_version() {
	return ++write_version;
}

/**
 * Determines whether a derived or effect is dirty.
 * If it is MAYBE_DIRTY, will set the status to CLEAN
 * @param {Reaction} reaction
 * @returns {boolean}
 */
function is_dirty(reaction) {
	var flags = reaction.f;

	if ((flags & DIRTY) !== 0) {
		return true;
	}

	if (flags & DERIVED) {
		reaction.f &= ~WAS_MARKED;
	}

	if ((flags & MAYBE_DIRTY) !== 0) {
		var dependencies = reaction.deps;

		if (dependencies !== null) {
			var length = dependencies.length;

			for (var i = 0; i < length; i++) {
				var dependency = dependencies[i];

				if (is_dirty(/** @type {Derived} */ (dependency))) {
					update_derived(/** @type {Derived} */ (dependency));
				}

				if (dependency.wv > reaction.wv) {
					return true;
				}
			}
		}

		if (
			(flags & CONNECTED) !== 0 &&
			// During time traveling we don't want to reset the status so that
			// traversal of the graph in the other batches still happens
			batch_values === null
		) {
			set_signal_status(reaction, CLEAN);
		}
	}

	return false;
}

/**
 * @param {Value} signal
 * @param {Effect} effect
 * @param {boolean} [root]
 */
function schedule_possible_effect_self_invalidation(signal, effect, root = true) {
	var reactions = signal.reactions;
	if (reactions === null) return;

	if (current_sources?.includes(signal)) {
		return;
	}

	for (var i = 0; i < reactions.length; i++) {
		var reaction = reactions[i];

		if ((reaction.f & DERIVED) !== 0) {
			schedule_possible_effect_self_invalidation(/** @type {Derived} */ (reaction), effect, false);
		} else if (effect === reaction) {
			if (root) {
				set_signal_status(reaction, DIRTY);
			} else if ((reaction.f & CLEAN) !== 0) {
				set_signal_status(reaction, MAYBE_DIRTY);
			}
			schedule_effect(/** @type {Effect} */ (reaction));
		}
	}
}

/** @param {Reaction} reaction */
function update_reaction(reaction) {
	var previous_deps = new_deps;
	var previous_skipped_deps = skipped_deps;
	var previous_untracked_writes = untracked_writes;
	var previous_reaction = active_reaction;
	var previous_sources = current_sources;
	var previous_component_context = component_context;
	var previous_untracking = untracking;
	var previous_update_version = update_version;

	var flags = reaction.f;

	new_deps = /** @type {null | Value[]} */ (null);
	skipped_deps = 0;
	untracked_writes = null;
	active_reaction = (flags & (BRANCH_EFFECT | ROOT_EFFECT)) === 0 ? reaction : null;

	current_sources = null;
	set_component_context(reaction.ctx);
	untracking = false;
	update_version = ++read_version;

	if (reaction.ac !== null) {
		without_reactive_context(() => {
			/** @type {AbortController} */ (reaction.ac).abort(STALE_REACTION);
		});

		reaction.ac = null;
	}

	try {
		reaction.f |= REACTION_IS_UPDATING;
		var fn = /** @type {Function} */ (reaction.fn);
		var result = fn();
		var deps = reaction.deps;

		if (new_deps !== null) {
			var i;

			remove_reactions(reaction, skipped_deps);

			if (deps !== null && skipped_deps > 0) {
				deps.length = skipped_deps + new_deps.length;
				for (i = 0; i < new_deps.length; i++) {
					deps[skipped_deps + i] = new_deps[i];
				}
			} else {
				reaction.deps = deps = new_deps;
			}

			if (is_updating_effect && effect_tracking() && (reaction.f & CONNECTED) !== 0) {
				for (i = skipped_deps; i < deps.length; i++) {
					(deps[i].reactions ??= []).push(reaction);
				}
			}
		} else if (deps !== null && skipped_deps < deps.length) {
			remove_reactions(reaction, skipped_deps);
			deps.length = skipped_deps;
		}

		// If we're inside an effect and we have untracked writes, then we need to
		// ensure that if any of those untracked writes result in re-invalidation
		// of the current effect, then that happens accordingly
		if (
			is_runes() &&
			untracked_writes !== null &&
			!untracking &&
			deps !== null &&
			(reaction.f & (DERIVED | MAYBE_DIRTY | DIRTY)) === 0
		) {
			for (i = 0; i < /** @type {Source[]} */ (untracked_writes).length; i++) {
				schedule_possible_effect_self_invalidation(
					untracked_writes[i],
					/** @type {Effect} */ (reaction)
				);
			}
		}

		// If we are returning to an previous reaction then
		// we need to increment the read version to ensure that
		// any dependencies in this reaction aren't marked with
		// the same version
		if (previous_reaction !== null && previous_reaction !== reaction) {
			read_version++;

			if (untracked_writes !== null) {
				if (previous_untracked_writes === null) {
					previous_untracked_writes = untracked_writes;
				} else {
					previous_untracked_writes.push(.../** @type {Source[]} */ (untracked_writes));
				}
			}
		}

		if ((reaction.f & ERROR_VALUE) !== 0) {
			reaction.f ^= ERROR_VALUE;
		}

		return result;
	} catch (error) {
		return handle_error(error);
	} finally {
		reaction.f ^= REACTION_IS_UPDATING;
		new_deps = previous_deps;
		skipped_deps = previous_skipped_deps;
		untracked_writes = previous_untracked_writes;
		active_reaction = previous_reaction;
		current_sources = previous_sources;
		set_component_context(previous_component_context);
		untracking = previous_untracking;
		update_version = previous_update_version;
	}
}

/**
 * @template V
 * @param {Reaction} signal
 * @param {Value<V>} dependency
 * @returns {void}
 */
function remove_reaction(signal, dependency) {
	let reactions = dependency.reactions;
	if (reactions !== null) {
		var index = index_of.call(reactions, signal);
		if (index !== -1) {
			var new_length = reactions.length - 1;
			if (new_length === 0) {
				reactions = dependency.reactions = null;
			} else {
				// Swap with last element and then remove.
				reactions[index] = reactions[new_length];
				reactions.pop();
			}
		}
	}

	// If the derived has no reactions, then we can disconnect it from the graph,
	// allowing it to either reconnect in the future, or be GC'd by the VM.
	if (
		reactions === null &&
		(dependency.f & DERIVED) !== 0 &&
		// Destroying a child effect while updating a parent effect can cause a dependency to appear
		// to be unused, when in fact it is used by the currently-updating parent. Checking `new_deps`
		// allows us to skip the expensive work of disconnecting and immediately reconnecting it
		(new_deps === null || !new_deps.includes(dependency))
	) {
		set_signal_status(dependency, MAYBE_DIRTY);
		// If we are working with a derived that is owned by an effect, then mark it as being
		// disconnected and remove the mark flag, as it cannot be reliably removed otherwise
		if ((dependency.f & CONNECTED) !== 0) {
			dependency.f ^= CONNECTED;
			dependency.f &= ~WAS_MARKED;
		}
		// Disconnect any reactions owned by this reaction
		destroy_derived_effects(/** @type {Derived} **/ (dependency));
		remove_reactions(/** @type {Derived} **/ (dependency), 0);
	}
}

/**
 * @param {Reaction} signal
 * @param {number} start_index
 * @returns {void}
 */
function remove_reactions(signal, start_index) {
	var dependencies = signal.deps;
	if (dependencies === null) return;

	for (var i = start_index; i < dependencies.length; i++) {
		remove_reaction(signal, dependencies[i]);
	}
}

/**
 * @param {Effect} effect
 * @returns {void}
 */
function update_effect(effect) {
	var flags = effect.f;

	if ((flags & DESTROYED) !== 0) {
		return;
	}

	set_signal_status(effect, CLEAN);

	var previous_effect = active_effect;
	var was_updating_effect = is_updating_effect;

	active_effect = effect;
	is_updating_effect = true;

	try {
		if ((flags & (BLOCK_EFFECT | MANAGED_EFFECT)) !== 0) {
			destroy_block_effect_children(effect);
		} else {
			destroy_effect_children(effect);
		}

		execute_effect_teardown(effect);
		var teardown = update_reaction(effect);
		effect.teardown = typeof teardown === 'function' ? teardown : null;
		effect.wv = write_version;

		// In DEV, increment versions of any sources that were written to during the effect,
		// so that they are correctly marked as dirty when the effect re-runs
		var dep; if (DEV && tracing_mode_flag && (effect.f & DIRTY) !== 0 && effect.deps !== null) ;
	} finally {
		is_updating_effect = was_updating_effect;
		active_effect = previous_effect;
	}
}

/**
 * Returns a promise that resolves once any pending state changes have been applied.
 * @returns {Promise<void>}
 */
async function tick() {

	await Promise.resolve();

	// By calling flushSync we guarantee that any pending state changes are applied after one tick.
	// TODO look into whether we can make flushing subsequent updates synchronously in the future.
	flushSync();
}

/**
 * @template V
 * @param {Value<V>} signal
 * @returns {V}
 */
function get$1(signal) {
	var flags = signal.f;
	var is_derived = (flags & DERIVED) !== 0;

	// Register the dependency on the current reaction signal.
	if (active_reaction !== null && !untracking) {
		// if we're in a derived that is being read inside an _async_ derived,
		// it's possible that the effect was already destroyed. In this case,
		// we don't add the dependency, because that would create a memory leak
		var destroyed = active_effect !== null && (active_effect.f & DESTROYED) !== 0;

		if (!destroyed && !current_sources?.includes(signal)) {
			var deps = active_reaction.deps;

			if ((active_reaction.f & REACTION_IS_UPDATING) !== 0) {
				// we're in the effect init/update cycle
				if (signal.rv < read_version) {
					signal.rv = read_version;

					// If the signal is accessing the same dependencies in the same
					// order as it did last time, increment `skipped_deps`
					// rather than updating `new_deps`, which creates GC cost
					if (new_deps === null && deps !== null && deps[skipped_deps] === signal) {
						skipped_deps++;
					} else if (new_deps === null) {
						new_deps = [signal];
					} else if (!new_deps.includes(signal)) {
						new_deps.push(signal);
					}
				}
			} else {
				// we're adding a dependency outside the init/update cycle
				// (i.e. after an `await`)
				(active_reaction.deps ??= []).push(signal);

				var reactions = signal.reactions;

				if (reactions === null) {
					signal.reactions = [active_reaction];
				} else if (!reactions.includes(active_reaction)) {
					reactions.push(active_reaction);
				}
			}
		}
	}

	if (is_destroying_effect) {
		if (old_values.has(signal)) {
			return old_values.get(signal);
		}

		if (is_derived) {
			var derived = /** @type {Derived} */ (signal);

			var value = derived.v;

			// if the derived is dirty and has reactions, or depends on the values that just changed, re-execute
			// (a derived can be maybe_dirty due to the effect destroy removing its last reaction)
			if (
				((derived.f & CLEAN) === 0 && derived.reactions !== null) ||
				depends_on_old_values(derived)
			) {
				value = execute_derived(derived);
			}

			old_values.set(derived, value);

			return value;
		}
	} else if (
		is_derived &&
		(!batch_values?.has(signal) || (current_batch?.is_fork && !effect_tracking()))
	) {
		derived = /** @type {Derived} */ (signal);

		if (is_dirty(derived)) {
			update_derived(derived);
		}

		if (is_updating_effect && effect_tracking() && (derived.f & CONNECTED) === 0) {
			reconnect(derived);
		}
	}

	if (batch_values?.has(signal)) {
		return batch_values.get(signal);
	}

	if ((signal.f & ERROR_VALUE) !== 0) {
		throw signal.v;
	}

	return signal.v;
}

/**
 * (Re)connect a disconnected derived, so that it is notified
 * of changes in `mark_reactions`
 * @param {Derived} derived
 */
function reconnect(derived) {
	if (derived.deps === null) return;

	derived.f ^= CONNECTED;

	for (const dep of derived.deps) {
		(dep.reactions ??= []).push(derived);

		if ((dep.f & DERIVED) !== 0 && (dep.f & CONNECTED) === 0) {
			reconnect(/** @type {Derived} */ (dep));
		}
	}
}

/** @param {Derived} derived */
function depends_on_old_values(derived) {
	if (derived.v === UNINITIALIZED) return true; // we don't know, so assume the worst
	if (derived.deps === null) return false;

	for (const dep of derived.deps) {
		if (old_values.has(dep)) {
			return true;
		}

		if ((dep.f & DERIVED) !== 0 && depends_on_old_values(/** @type {Derived} */ (dep))) {
			return true;
		}
	}

	return false;
}

/**
 * When used inside a [`$derived`](https://svelte.dev/docs/svelte/$derived) or [`$effect`](https://svelte.dev/docs/svelte/$effect),
 * any state read inside `fn` will not be treated as a dependency.
 *
 * ```ts
 * $effect(() => {
 *   // this will run when `data` changes, but not when `time` changes
 *   save(data, {
 *     timestamp: untrack(() => time)
 *   });
 * });
 * ```
 * @template T
 * @param {() => T} fn
 * @returns {T}
 */
function untrack(fn) {
	var previous_untracking = untracking;
	try {
		untracking = true;
		return fn();
	} finally {
		untracking = previous_untracking;
	}
}

const STATUS_MASK = -7169;

/**
 * @param {Signal} signal
 * @param {number} status
 * @returns {void}
 */
function set_signal_status(signal, status) {
	signal.f = (signal.f & STATUS_MASK) | status;
}

/**
 * Possibly traverse an object and read all its properties so that they're all reactive in case this is `$state`.
 * Does only check first level of an object for performance reasons (heuristic should be good for 99% of all cases).
 * @param {any} value
 * @returns {void}
 */
function deep_read_state(value) {
	if (typeof value !== 'object' || !value || value instanceof EventTarget) {
		return;
	}

	if (STATE_SYMBOL in value) {
		deep_read(value);
	} else if (!Array.isArray(value)) {
		for (let key in value) {
			const prop = value[key];
			if (typeof prop === 'object' && prop && STATE_SYMBOL in prop) {
				deep_read(prop);
			}
		}
	}
}

/**
 * Deeply traverse an object and read all its properties
 * so that they're all reactive in case this is `$state`
 * @param {any} value
 * @param {Set<any>} visited
 * @returns {void}
 */
function deep_read(value, visited = new Set()) {
	if (
		typeof value === 'object' &&
		value !== null &&
		// We don't want to traverse DOM elements
		!(value instanceof EventTarget) &&
		!visited.has(value)
	) {
		visited.add(value);
		// When working with a possible SvelteDate, this
		// will ensure we capture changes to it.
		if (value instanceof Date) {
			value.getTime();
		}
		for (let key in value) {
			try {
				deep_read(value[key], visited);
			} catch (e) {
				// continue
			}
		}
		const proto = get_prototype_of(value);
		if (
			proto !== Object.prototype &&
			proto !== Array.prototype &&
			proto !== Map.prototype &&
			proto !== Set.prototype &&
			proto !== Date.prototype
		) {
			const descriptors = get_descriptors(proto);
			for (let key in descriptors) {
				const get = descriptors[key].get;
				if (get) {
					try {
						get.call(value);
					} catch (e) {
						// continue
					}
				}
			}
		}
	}
}

/** @import { ComponentContext, ComponentContextLegacy, Derived, Effect, TemplateNode, TransitionManager } from '#client' */

/**
 * @param {'$effect' | '$effect.pre' | '$inspect'} rune
 */
function validate_effect(rune) {
	if (active_effect === null) {
		if (active_reaction === null) {
			effect_orphan();
		}

		effect_in_unowned_derived();
	}

	if (is_destroying_effect) {
		effect_in_teardown();
	}
}

/**
 * @param {Effect} effect
 * @param {Effect} parent_effect
 */
function push_effect(effect, parent_effect) {
	var parent_last = parent_effect.last;
	if (parent_last === null) {
		parent_effect.last = parent_effect.first = effect;
	} else {
		parent_last.next = effect;
		effect.prev = parent_last;
		parent_effect.last = effect;
	}
}

/**
 * @param {number} type
 * @param {null | (() => void | (() => void))} fn
 * @param {boolean} sync
 * @returns {Effect}
 */
function create_effect(type, fn, sync) {
	var parent = active_effect;

	if (parent !== null && (parent.f & INERT) !== 0) {
		type |= INERT;
	}

	/** @type {Effect} */
	var effect = {
		ctx: component_context,
		deps: null,
		nodes_start: null,
		nodes_end: null,
		f: type | DIRTY | CONNECTED,
		first: null,
		fn,
		last: null,
		next: null,
		parent,
		b: parent && parent.b,
		prev: null,
		teardown: null,
		transitions: null,
		wv: 0,
		ac: null
	};

	if (sync) {
		try {
			update_effect(effect);
			effect.f |= EFFECT_RAN;
		} catch (e) {
			destroy_effect(effect);
			throw e;
		}
	} else if (fn !== null) {
		schedule_effect(effect);
	}

	/** @type {Effect | null} */
	var e = effect;

	// if an effect has already ran and doesn't need to be kept in the tree
	// (because it won't re-run, has no DOM, and has no teardown etc)
	// then we skip it and go to its child (if any)
	if (
		sync &&
		e.deps === null &&
		e.teardown === null &&
		e.nodes_start === null &&
		e.first === e.last && // either `null`, or a singular child
		(e.f & EFFECT_PRESERVED) === 0
	) {
		e = e.first;
		if ((type & BLOCK_EFFECT) !== 0 && (type & EFFECT_TRANSPARENT) !== 0 && e !== null) {
			e.f |= EFFECT_TRANSPARENT;
		}
	}

	if (e !== null) {
		e.parent = parent;

		if (parent !== null) {
			push_effect(e, parent);
		}

		// if we're in a derived, add the effect there too
		if (
			active_reaction !== null &&
			(active_reaction.f & DERIVED) !== 0 &&
			(type & ROOT_EFFECT) === 0
		) {
			var derived = /** @type {Derived} */ (active_reaction);
			(derived.effects ??= []).push(e);
		}
	}

	return effect;
}

/**
 * Internal representation of `$effect.tracking()`
 * @returns {boolean}
 */
function effect_tracking() {
	return active_reaction !== null && !untracking;
}

/**
 * @param {() => void} fn
 */
function teardown(fn) {
	const effect = create_effect(RENDER_EFFECT, null, false);
	set_signal_status(effect, CLEAN);
	effect.teardown = fn;
	return effect;
}

/**
 * Internal representation of `$effect(...)`
 * @param {() => void | (() => void)} fn
 */
function user_effect(fn) {
	validate_effect();

	// Non-nested `$effect(...)` in a component should be deferred
	// until the component is mounted
	var flags = /** @type {Effect} */ (active_effect).f;
	var defer = !active_reaction && (flags & BRANCH_EFFECT) !== 0 && (flags & EFFECT_RAN) === 0;

	if (defer) {
		// Top-level `$effect(...)` in an unmounted component — defer until mount
		var context = /** @type {ComponentContext} */ (component_context);
		(context.e ??= []).push(fn);
	} else {
		// Everything else — create immediately
		return create_user_effect(fn);
	}
}

/**
 * @param {() => void | (() => void)} fn
 */
function create_user_effect(fn) {
	return create_effect(EFFECT | USER_EFFECT, fn, false);
}

/**
 * Internal representation of `$effect.pre(...)`
 * @param {() => void | (() => void)} fn
 * @returns {Effect}
 */
function user_pre_effect(fn) {
	validate_effect();
	return create_effect(RENDER_EFFECT | USER_EFFECT, fn, true);
}

/**
 * An effect root whose children can transition out
 * @param {() => void} fn
 * @returns {(options?: { outro?: boolean }) => Promise<void>}
 */
function component_root(fn) {
	Batch.ensure();
	const effect = create_effect(ROOT_EFFECT | EFFECT_PRESERVED, fn, true);

	return (options = {}) => {
		return new Promise((fulfil) => {
			if (options.outro) {
				pause_effect(effect, () => {
					destroy_effect(effect);
					fulfil(undefined);
				});
			} else {
				destroy_effect(effect);
				fulfil(undefined);
			}
		});
	};
}

/**
 * @param {() => void | (() => void)} fn
 * @returns {Effect}
 */
function effect(fn) {
	return create_effect(EFFECT, fn, false);
}

/**
 * Internal representation of `$: ..`
 * @param {() => any} deps
 * @param {() => void | (() => void)} fn
 */
function legacy_pre_effect(deps, fn) {
	var context = /** @type {ComponentContextLegacy} */ (component_context);

	/** @type {{ effect: null | Effect, ran: boolean, deps: () => any }} */
	var token = { effect: null, ran: false, deps };

	context.l.$.push(token);

	token.effect = render_effect(() => {
		deps();

		// If this legacy pre effect has already run before the end of the reset, then
		// bail out to emulate the same behavior.
		if (token.ran) return;

		token.ran = true;
		untrack(fn);
	});
}

function legacy_pre_effect_reset() {
	var context = /** @type {ComponentContextLegacy} */ (component_context);

	render_effect(() => {
		// Run dirty `$:` statements
		for (var token of context.l.$) {
			token.deps();

			var effect = token.effect;

			// If the effect is CLEAN, then make it MAYBE_DIRTY. This ensures we traverse through
			// the effects dependencies and correctly ensure each dependency is up-to-date.
			if ((effect.f & CLEAN) !== 0) {
				set_signal_status(effect, MAYBE_DIRTY);
			}

			if (is_dirty(effect)) {
				update_effect(effect);
			}

			token.ran = false;
		}
	});
}

/**
 * @param {() => void | (() => void)} fn
 * @returns {Effect}
 */
function async_effect(fn) {
	return create_effect(ASYNC | EFFECT_PRESERVED, fn, true);
}

/**
 * @param {() => void | (() => void)} fn
 * @returns {Effect}
 */
function render_effect(fn, flags = 0) {
	return create_effect(RENDER_EFFECT | flags, fn, true);
}

/**
 * @param {(...expressions: any) => void | (() => void)} fn
 * @param {Array<() => any>} sync
 * @param {Array<() => Promise<any>>} async
 * @param {Array<Promise<void>>} blockers
 */
function template_effect(fn, sync = [], async = [], blockers = []) {
	flatten(blockers, sync, async, (values) => {
		create_effect(RENDER_EFFECT, () => fn(...values.map(get$1)), true);
	});
}

/**
 * @param {(() => void)} fn
 * @param {number} flags
 */
function block(fn, flags = 0) {
	var effect = create_effect(BLOCK_EFFECT | flags, fn, true);
	return effect;
}

/**
 * @param {(() => void)} fn
 * @param {number} flags
 */
function managed(fn, flags = 0) {
	var effect = create_effect(MANAGED_EFFECT | flags, fn, true);
	return effect;
}

/**
 * @param {(() => void)} fn
 */
function branch(fn) {
	return create_effect(BRANCH_EFFECT | EFFECT_PRESERVED, fn, true);
}

/**
 * @param {Effect} effect
 */
function execute_effect_teardown(effect) {
	var teardown = effect.teardown;
	if (teardown !== null) {
		const previously_destroying_effect = is_destroying_effect;
		const previous_reaction = active_reaction;
		set_is_destroying_effect(true);
		set_active_reaction(null);
		try {
			teardown.call(null);
		} finally {
			set_is_destroying_effect(previously_destroying_effect);
			set_active_reaction(previous_reaction);
		}
	}
}

/**
 * @param {Effect} signal
 * @param {boolean} remove_dom
 * @returns {void}
 */
function destroy_effect_children(signal, remove_dom = false) {
	var effect = signal.first;
	signal.first = signal.last = null;

	while (effect !== null) {
		const controller = effect.ac;

		if (controller !== null) {
			without_reactive_context(() => {
				controller.abort(STALE_REACTION);
			});
		}

		var next = effect.next;

		if ((effect.f & ROOT_EFFECT) !== 0) {
			// this is now an independent root
			effect.parent = null;
		} else {
			destroy_effect(effect, remove_dom);
		}

		effect = next;
	}
}

/**
 * @param {Effect} signal
 * @returns {void}
 */
function destroy_block_effect_children(signal) {
	var effect = signal.first;

	while (effect !== null) {
		var next = effect.next;
		if ((effect.f & BRANCH_EFFECT) === 0) {
			destroy_effect(effect);
		}
		effect = next;
	}
}

/**
 * @param {Effect} effect
 * @param {boolean} [remove_dom]
 * @returns {void}
 */
function destroy_effect(effect, remove_dom = true) {
	var removed = false;

	if (
		(remove_dom || (effect.f & HEAD_EFFECT) !== 0) &&
		effect.nodes_start !== null &&
		effect.nodes_end !== null
	) {
		remove_effect_dom(effect.nodes_start, /** @type {TemplateNode} */ (effect.nodes_end));
		removed = true;
	}

	destroy_effect_children(effect, remove_dom && !removed);
	remove_reactions(effect, 0);
	set_signal_status(effect, DESTROYED);

	var transitions = effect.transitions;

	if (transitions !== null) {
		for (const transition of transitions) {
			transition.stop();
		}
	}

	execute_effect_teardown(effect);

	var parent = effect.parent;

	// If the parent doesn't have any children, then skip this work altogether
	if (parent !== null && parent.first !== null) {
		unlink_effect(effect);
	}

	// `first` and `child` are nulled out in destroy_effect_children
	// we don't null out `parent` so that error propagation can work correctly
	effect.next =
		effect.prev =
		effect.teardown =
		effect.ctx =
		effect.deps =
		effect.fn =
		effect.nodes_start =
		effect.nodes_end =
		effect.ac =
			null;
}

/**
 *
 * @param {TemplateNode | null} node
 * @param {TemplateNode} end
 */
function remove_effect_dom(node, end) {
	while (node !== null) {
		/** @type {TemplateNode | null} */
		var next = node === end ? null : /** @type {TemplateNode} */ (get_next_sibling(node));

		node.remove();
		node = next;
	}
}

/**
 * Detach an effect from the effect tree, freeing up memory and
 * reducing the amount of work that happens on subsequent traversals
 * @param {Effect} effect
 */
function unlink_effect(effect) {
	var parent = effect.parent;
	var prev = effect.prev;
	var next = effect.next;

	if (prev !== null) prev.next = next;
	if (next !== null) next.prev = prev;

	if (parent !== null) {
		if (parent.first === effect) parent.first = next;
		if (parent.last === effect) parent.last = prev;
	}
}

/**
 * When a block effect is removed, we don't immediately destroy it or yank it
 * out of the DOM, because it might have transitions. Instead, we 'pause' it.
 * It stays around (in memory, and in the DOM) until outro transitions have
 * completed, and if the state change is reversed then we _resume_ it.
 * A paused effect does not update, and the DOM subtree becomes inert.
 * @param {Effect} effect
 * @param {() => void} [callback]
 * @param {boolean} [destroy]
 */
function pause_effect(effect, callback, destroy = true) {
	/** @type {TransitionManager[]} */
	var transitions = [];

	pause_children(effect, transitions, true);

	run_out_transitions(transitions, () => {
		if (destroy) destroy_effect(effect);
		if (callback) callback();
	});
}

/**
 * @param {TransitionManager[]} transitions
 * @param {() => void} fn
 */
function run_out_transitions(transitions, fn) {
	var remaining = transitions.length;
	if (remaining > 0) {
		var check = () => --remaining || fn();
		for (var transition of transitions) {
			transition.out(check);
		}
	} else {
		fn();
	}
}

/**
 * @param {Effect} effect
 * @param {TransitionManager[]} transitions
 * @param {boolean} local
 */
function pause_children(effect, transitions, local) {
	if ((effect.f & INERT) !== 0) return;
	effect.f ^= INERT;

	if (effect.transitions !== null) {
		for (const transition of effect.transitions) {
			if (transition.is_global || local) {
				transitions.push(transition);
			}
		}
	}

	var child = effect.first;

	while (child !== null) {
		var sibling = child.next;
		var transparent =
			(child.f & EFFECT_TRANSPARENT) !== 0 ||
			// If this is a branch effect without a block effect parent,
			// it means the parent block effect was pruned. In that case,
			// transparency information was transferred to the branch effect.
			((child.f & BRANCH_EFFECT) !== 0 && (effect.f & BLOCK_EFFECT) !== 0);
		// TODO we don't need to call pause_children recursively with a linked list in place
		// it's slightly more involved though as we have to account for `transparent` changing
		// through the tree.
		pause_children(child, transitions, transparent ? local : false);
		child = sibling;
	}
}

/**
 * The opposite of `pause_effect`. We call this if (for example)
 * `x` becomes falsy then truthy: `{#if x}...{/if}`
 * @param {Effect} effect
 */
function resume_effect(effect) {
	resume_children(effect, true);
}

/**
 * @param {Effect} effect
 * @param {boolean} local
 */
function resume_children(effect, local) {
	if ((effect.f & INERT) === 0) return;
	effect.f ^= INERT;

	// If a dependency of this effect changed while it was paused,
	// schedule the effect to update. we don't use `is_dirty`
	// here because we don't want to eagerly recompute a derived like
	// `{#if foo}{foo.bar()}{/if}` if `foo` is now `undefined
	if ((effect.f & CLEAN) === 0) {
		set_signal_status(effect, DIRTY);
		schedule_effect(effect);
	}

	var child = effect.first;

	while (child !== null) {
		var sibling = child.next;
		var transparent = (child.f & EFFECT_TRANSPARENT) !== 0 || (child.f & BRANCH_EFFECT) !== 0;
		// TODO we don't need to call resume_children recursively with a linked list in place
		// it's slightly more involved though as we have to account for `transparent` changing
		// through the tree.
		resume_children(child, transparent ? local : false);
		child = sibling;
	}

	if (effect.transitions !== null) {
		for (const transition of effect.transitions) {
			if (transition.is_global || local) {
				transition.in();
			}
		}
	}
}

/**
 * @param {Effect} effect
 * @param {DocumentFragment} fragment
 */
function move_effect(effect, fragment) {
	var node = effect.nodes_start;
	var end = effect.nodes_end;

	while (node !== null) {
		/** @type {TemplateNode | null} */
		var next = node === end ? null : /** @type {TemplateNode} */ (get_next_sibling(node));

		fragment.append(node);
		node = next;
	}
}

/**
 * @param {string} name
 */
function is_capture_event(name) {
	return name.endsWith('capture') && name !== 'gotpointercapture' && name !== 'lostpointercapture';
}

/** List of Element events that will be delegated */
const DELEGATED_EVENTS = [
	'beforeinput',
	'click',
	'change',
	'dblclick',
	'contextmenu',
	'focusin',
	'focusout',
	'input',
	'keydown',
	'keyup',
	'mousedown',
	'mousemove',
	'mouseout',
	'mouseover',
	'mouseup',
	'pointerdown',
	'pointermove',
	'pointerout',
	'pointerover',
	'pointerup',
	'touchend',
	'touchmove',
	'touchstart'
];

/**
 * Returns `true` if `event_name` is a delegated event
 * @param {string} event_name
 */
function can_delegate_event(event_name) {
	return DELEGATED_EVENTS.includes(event_name);
}

/**
 * @type {Record<string, string>}
 * List of attribute names that should be aliased to their property names
 * because they behave differently between setting them as an attribute and
 * setting them as a property.
 */
const ATTRIBUTE_ALIASES = {
	// no `class: 'className'` because we handle that separately
	formnovalidate: 'formNoValidate',
	ismap: 'isMap',
	nomodule: 'noModule',
	playsinline: 'playsInline',
	readonly: 'readOnly',
	defaultvalue: 'defaultValue',
	defaultchecked: 'defaultChecked',
	srcobject: 'srcObject',
	novalidate: 'noValidate',
	allowfullscreen: 'allowFullscreen',
	disablepictureinpicture: 'disablePictureInPicture',
	disableremoteplayback: 'disableRemotePlayback'
};

/**
 * @param {string} name
 */
function normalize_attribute(name) {
	name = name.toLowerCase();
	return ATTRIBUTE_ALIASES[name] ?? name;
}

/**
 * Subset of delegated events which should be passive by default.
 * These two are already passive via browser defaults on window, document and body.
 * But since
 * - we're delegating them
 * - they happen often
 * - they apply to mobile which is generally less performant
 * we're marking them as passive by default for other elements, too.
 */
const PASSIVE_EVENTS = ['touchstart', 'touchmove'];

/**
 * Returns `true` if `name` is a passive event
 * @param {string} name
 */
function is_passive_event(name) {
	return PASSIVE_EVENTS.includes(name);
}

/**
 * Prevent devtools trying to make `location` a clickable link by inserting a zero-width space
 * @template {string | undefined} T
 * @param {T} location
 * @returns {T};
 */
function sanitize_location(location) {
	return /** @type {T} */ (location?.replace(/\//g, '/\u200b'));
}

/** @import { SourceLocation } from '#client' */

/**
 * @param {any} fn
 * @param {string} filename
 * @param {SourceLocation[]} locations
 * @returns {any}
 */
function add_locations(fn, filename, locations) {
	return (/** @type {any[]} */ ...args) => {
		const dom = fn(...args);

		var node = dom.nodeType === DOCUMENT_FRAGMENT_NODE ? dom.firstChild : dom;
		assign_locations(node, filename, locations);

		return dom;
	};
}

/**
 * @param {Element} element
 * @param {string} filename
 * @param {SourceLocation} location
 */
function assign_location(element, filename, location) {
	// @ts-expect-error
	element.__svelte_meta = {
		parent: dev_stack,
		loc: { file: filename, line: location[0], column: location[1] }
	};

	if (location[2]) {
		assign_locations(element.firstChild, filename, location[2]);
	}
}

/**
 * @param {Node | null} node
 * @param {string} filename
 * @param {SourceLocation[]} locations
 */
function assign_locations(node, filename, locations) {
	var i = 0;

	while (node && i < locations.length) {

		if (node.nodeType === ELEMENT_NODE) {
			assign_location(/** @type {Element} */ (node), filename, locations[i++]);
		}

		node = node.nextSibling;
	}
}

/** @type {Set<string>} */
const all_registered_events = new Set();

/** @type {Set<(events: Array<string>) => void>} */
const root_event_handles = new Set();

/**
 * @param {string} event_name
 * @param {EventTarget} dom
 * @param {EventListener} [handler]
 * @param {AddEventListenerOptions} [options]
 */
function create_event(event_name, dom, handler, options = {}) {
	/**
	 * @this {EventTarget}
	 */
	function target_handler(/** @type {Event} */ event) {
		if (!options.capture) {
			// Only call in the bubble phase, else delegated events would be called before the capturing events
			handle_event_propagation.call(dom, event);
		}
		if (!event.cancelBubble) {
			return without_reactive_context(() => {
				return handler?.call(this, event);
			});
		}
	}

	// Chrome has a bug where pointer events don't work when attached to a DOM element that has been cloned
	// with cloneNode() and the DOM element is disconnected from the document. To ensure the event works, we
	// defer the attachment till after it's been appended to the document. TODO: remove this once Chrome fixes
	// this bug. The same applies to wheel events and touch events.
	if (
		event_name.startsWith('pointer') ||
		event_name.startsWith('touch') ||
		event_name === 'wheel'
	) {
		queue_micro_task(() => {
			dom.addEventListener(event_name, target_handler, options);
		});
	} else {
		dom.addEventListener(event_name, target_handler, options);
	}

	return target_handler;
}

/**
 * @param {string} event_name
 * @param {Element} dom
 * @param {EventListener} [handler]
 * @param {boolean} [capture]
 * @param {boolean} [passive]
 * @returns {void}
 */
function event(event_name, dom, handler, capture, passive) {
	var options = { capture, passive };
	var target_handler = create_event(event_name, dom, handler, options);

	if (
		dom === document.body ||
		// @ts-ignore
		dom === window ||
		// @ts-ignore
		dom === document ||
		// Firefox has quirky behavior, it can happen that we still get "canplay" events when the element is already removed
		dom instanceof HTMLMediaElement
	) {
		teardown(() => {
			dom.removeEventListener(event_name, target_handler, options);
		});
	}
}

/**
 * @param {Array<string>} events
 * @returns {void}
 */
function delegate(events) {
	for (var i = 0; i < events.length; i++) {
		all_registered_events.add(events[i]);
	}

	for (var fn of root_event_handles) {
		fn(events);
	}
}

// used to store the reference to the currently propagated event
// to prevent garbage collection between microtasks in Firefox
// If the event object is GCed too early, the expando __root property
// set on the event object is lost, causing the event delegation
// to process the event twice
let last_propagated_event = null;

/**
 * @this {EventTarget}
 * @param {Event} event
 * @returns {void}
 */
function handle_event_propagation(event) {
	var handler_element = this;
	var owner_document = /** @type {Node} */ (handler_element).ownerDocument;
	var event_name = event.type;
	var path = event.composedPath?.() || [];
	var current_target = /** @type {null | Element} */ (path[0] || event.target);

	last_propagated_event = event;

	// composedPath contains list of nodes the event has propagated through.
	// We check __root to skip all nodes below it in case this is a
	// parent of the __root node, which indicates that there's nested
	// mounted apps. In this case we don't want to trigger events multiple times.
	var path_idx = 0;

	// the `last_propagated_event === event` check is redundant, but
	// without it the variable will be DCE'd and things will
	// fail mysteriously in Firefox
	// @ts-expect-error is added below
	var handled_at = last_propagated_event === event && event.__root;

	if (handled_at) {
		var at_idx = path.indexOf(handled_at);
		if (
			at_idx !== -1 &&
			(handler_element === document || handler_element === /** @type {any} */ (window))
		) {
			// This is the fallback document listener or a window listener, but the event was already handled
			// -> ignore, but set handle_at to document/window so that we're resetting the event
			// chain in case someone manually dispatches the same event object again.
			// @ts-expect-error
			event.__root = handler_element;
			return;
		}

		// We're deliberately not skipping if the index is higher, because
		// someone could create an event programmatically and emit it multiple times,
		// in which case we want to handle the whole propagation chain properly each time.
		// (this will only be a false negative if the event is dispatched multiple times and
		// the fallback document listener isn't reached in between, but that's super rare)
		var handler_idx = path.indexOf(handler_element);
		if (handler_idx === -1) {
			// handle_idx can theoretically be -1 (happened in some JSDOM testing scenarios with an event listener on the window object)
			// so guard against that, too, and assume that everything was handled at this point.
			return;
		}

		if (at_idx <= handler_idx) {
			path_idx = at_idx;
		}
	}

	current_target = /** @type {Element} */ (path[path_idx] || event.target);
	// there can only be one delegated event per element, and we either already handled the current target,
	// or this is the very first target in the chain which has a non-delegated listener, in which case it's safe
	// to handle a possible delegated event on it later (through the root delegation listener for example).
	if (current_target === handler_element) return;

	// Proxy currentTarget to correct target
	define_property(event, 'currentTarget', {
		configurable: true,
		get() {
			return current_target || owner_document;
		}
	});

	// This started because of Chromium issue https://chromestatus.com/feature/5128696823545856,
	// where removal or moving of of the DOM can cause sync `blur` events to fire, which can cause logic
	// to run inside the current `active_reaction`, which isn't what we want at all. However, on reflection,
	// it's probably best that all event handled by Svelte have this behaviour, as we don't really want
	// an event handler to run in the context of another reaction or effect.
	var previous_reaction = active_reaction;
	var previous_effect = active_effect;
	set_active_reaction(null);
	set_active_effect(null);

	try {
		/**
		 * @type {unknown}
		 */
		var throw_error;
		/**
		 * @type {unknown[]}
		 */
		var other_errors = [];

		while (current_target !== null) {
			/** @type {null | Element} */
			var parent_element =
				current_target.assignedSlot ||
				current_target.parentNode ||
				/** @type {any} */ (current_target).host ||
				null;

			try {
				// @ts-expect-error
				var delegated = current_target['__' + event_name];

				if (
					delegated != null &&
					(!(/** @type {any} */ (current_target).disabled) ||
						// DOM could've been updated already by the time this is reached, so we check this as well
						// -> the target could not have been disabled because it emits the event in the first place
						event.target === current_target)
				) {
					delegated.call(current_target, event);
				}
			} catch (error) {
				if (throw_error) {
					other_errors.push(error);
				} else {
					throw_error = error;
				}
			}
			if (event.cancelBubble || parent_element === handler_element || parent_element === null) {
				break;
			}
			current_target = parent_element;
		}

		if (throw_error) {
			for (let error of other_errors) {
				// Throw the rest of the errors, one-by-one on a microtask
				queueMicrotask(() => {
					throw error;
				});
			}
			throw throw_error;
		}
	} finally {
		// @ts-expect-error is used above
		event.__root = handler_element;
		// @ts-ignore remove proxy on currentTarget
		delete event.currentTarget;
		set_active_reaction(previous_reaction);
		set_active_effect(previous_effect);
	}
}

/** @param {string} html */
function create_fragment_from_html(html) {
	var elem = document.createElement('template');
	elem.innerHTML = html.replaceAll('<!>', '<!---->'); // XHTML compliance
	return elem.content;
}

/** @import { Effect, TemplateNode } from '#client' */
/** @import { TemplateStructure } from './types' */

/**
 * @param {TemplateNode} start
 * @param {TemplateNode | null} end
 */
function assign_nodes(start, end) {
	var effect = /** @type {Effect} */ (active_effect);
	if (effect.nodes_start === null) {
		effect.nodes_start = start;
		effect.nodes_end = end;
	}
}

/**
 * @param {string} content
 * @param {number} flags
 * @returns {() => Node | Node[]}
 */
/*#__NO_SIDE_EFFECTS__*/
function from_html(content, flags) {
	var is_fragment = (flags & TEMPLATE_FRAGMENT) !== 0;
	var use_import_node = (flags & TEMPLATE_USE_IMPORT_NODE) !== 0;

	/** @type {Node} */
	var node;

	/**
	 * Whether or not the first item is a text/element node. If not, we need to
	 * create an additional comment node to act as `effect.nodes.start`
	 */
	var has_start = !content.startsWith('<!>');

	return () => {

		if (node === undefined) {
			node = create_fragment_from_html(has_start ? content : '<!>' + content);
			if (!is_fragment) node = /** @type {Node} */ (get_first_child(node));
		}

		var clone = /** @type {TemplateNode} */ (
			use_import_node || is_firefox ? document.importNode(node, true) : node.cloneNode(true)
		);

		if (is_fragment) {
			var start = /** @type {TemplateNode} */ (get_first_child(clone));
			var end = /** @type {TemplateNode} */ (clone.lastChild);

			assign_nodes(start, end);
		} else {
			assign_nodes(clone, clone);
		}

		return clone;
	};
}

/**
 * @param {string} content
 * @param {number} flags
 * @param {'svg' | 'math'} ns
 * @returns {() => Node | Node[]}
 */
/*#__NO_SIDE_EFFECTS__*/
function from_namespace(content, flags, ns = 'svg') {
	/**
	 * Whether or not the first item is a text/element node. If not, we need to
	 * create an additional comment node to act as `effect.nodes.start`
	 */
	var has_start = !content.startsWith('<!>');
	var wrapped = `<${ns}>${has_start ? content : '<!>' + content}</${ns}>`;

	/** @type {Element | DocumentFragment} */
	var node;

	return () => {

		if (!node) {
			var fragment = /** @type {DocumentFragment} */ (create_fragment_from_html(wrapped));
			var root = /** @type {Element} */ (get_first_child(fragment));

			{
				node = /** @type {Element} */ (get_first_child(root));
			}
		}

		var clone = /** @type {TemplateNode} */ (node.cloneNode(true));

		{
			assign_nodes(clone, clone);
		}

		return clone;
	};
}

/**
 * @param {string} content
 * @param {number} flags
 */
/*#__NO_SIDE_EFFECTS__*/
function from_svg(content, flags) {
	return from_namespace(content, flags, 'svg');
}

/**
 * Don't mark this as side-effect-free, hydration needs to walk all nodes
 * @param {any} value
 */
function text(value = '') {
	{
		var t = create_text(value + '');
		assign_nodes(t, t);
		return t;
	}
}

/**
 * @returns {TemplateNode | DocumentFragment}
 */
function comment() {

	var frag = document.createDocumentFragment();
	var start = document.createComment('');
	var anchor = create_text();
	frag.append(start, anchor);

	assign_nodes(start, anchor);

	return frag;
}

/**
 * Assign the created (or in hydration mode, traversed) dom elements to the current block
 * and insert the elements into the dom (in client mode).
 * @param {Text | Comment | Element} anchor
 * @param {DocumentFragment | Element} dom
 */
function append(anchor, dom) {

	if (anchor === null) {
		// edge case — void `<svelte:element>` with content
		return;
	}

	anchor.before(/** @type {Node} */ (dom));
}

/** @import { ComponentContext, Effect, TemplateNode } from '#client' */
/** @import { Component, ComponentType, SvelteComponent, MountOptions } from '../../index.js' */

/**
 * @param {Element} text
 * @param {string} value
 * @returns {void}
 */
function set_text(text, value) {
	// For objects, we apply string coercion (which might make things like $state array references in the template reactive) before diffing
	var str = value == null ? '' : typeof value === 'object' ? value + '' : value;
	// @ts-expect-error
	if (str !== (text.__t ??= text.nodeValue)) {
		// @ts-expect-error
		text.__t = str;
		text.nodeValue = str + '';
	}
}

/**
 * Mounts a component to the given target and returns the exports and potentially the props (if compiled with `accessors: true`) of the component.
 * Transitions will play during the initial render unless the `intro` option is set to `false`.
 *
 * @template {Record<string, any>} Props
 * @template {Record<string, any>} Exports
 * @param {ComponentType<SvelteComponent<Props>> | Component<Props, Exports, any>} component
 * @param {MountOptions<Props>} options
 * @returns {Exports}
 */
function mount(component, options) {
	return _mount(component, options);
}

/** @type {Map<string, number>} */
const document_listeners = new Map();

/**
 * @template {Record<string, any>} Exports
 * @param {ComponentType<SvelteComponent<any>> | Component<any>} Component
 * @param {MountOptions} options
 * @returns {Exports}
 */
function _mount(Component, { target, anchor, props = {}, events, context, intro = true }) {
	init_operations();

	/** @type {Set<string>} */
	var registered_events = new Set();

	/** @param {Array<string>} events */
	var event_handle = (events) => {
		for (var i = 0; i < events.length; i++) {
			var event_name = events[i];

			if (registered_events.has(event_name)) continue;
			registered_events.add(event_name);

			var passive = is_passive_event(event_name);

			// Add the event listener to both the container and the document.
			// The container listener ensures we catch events from within in case
			// the outer content stops propagation of the event.
			target.addEventListener(event_name, handle_event_propagation, { passive });

			var n = document_listeners.get(event_name);

			if (n === undefined) {
				// The document listener ensures we catch events that originate from elements that were
				// manually moved outside of the container (e.g. via manual portals).
				document.addEventListener(event_name, handle_event_propagation, { passive });
				document_listeners.set(event_name, 1);
			} else {
				document_listeners.set(event_name, n + 1);
			}
		}
	};

	event_handle(array_from(all_registered_events));
	root_event_handles.add(event_handle);

	/** @type {Exports} */
	// @ts-expect-error will be defined because the render effect runs synchronously
	var component = undefined;

	var unmount = component_root(() => {
		var anchor_node = anchor ?? target.appendChild(create_text());

		boundary(
			/** @type {TemplateNode} */ (anchor_node),
			{
				pending: () => {}
			},
			(anchor_node) => {
				if (context) {
					push({});
					var ctx = /** @type {ComponentContext} */ (component_context);
					ctx.c = context;
				}

				if (events) {
					// We can't spread the object or else we'd lose the state proxy stuff, if it is one
					/** @type {any} */ (props).$$events = events;
				}
				// @ts-expect-error the public typings are not what the actual function looks like
				component = Component(anchor_node, props) || {};

				if (context) {
					pop();
				}
			}
		);

		return () => {
			for (var event_name of registered_events) {
				target.removeEventListener(event_name, handle_event_propagation);

				var n = /** @type {number} */ (document_listeners.get(event_name));

				if (--n === 0) {
					document.removeEventListener(event_name, handle_event_propagation);
					document_listeners.delete(event_name);
				} else {
					document_listeners.set(event_name, n);
				}
			}

			root_event_handles.delete(event_handle);

			if (anchor_node !== anchor) {
				anchor_node.parentNode?.removeChild(anchor_node);
			}
		};
	});

	mounted_components.set(component, unmount);
	return component;
}

/**
 * References of the components that were mounted or hydrated.
 * Uses a `WeakMap` to avoid memory leaks.
 */
let mounted_components = new WeakMap();

/** @typedef {{ file: string, line: number, column: number }} Location */


/**
 * Sets up a validator that
 * - traverses the path of a prop to find out if it is allowed to be mutated
 * - checks that the binding chain is not interrupted
 * @param {Record<string, any>} props
 */
function create_ownership_validator(props) {
	const component = component_context?.function;
	const parent = component_context?.p?.function;

	return {
		/**
		 * @param {string} prop
		 * @param {any[]} path
		 * @param {any} result
		 * @param {number} line
		 * @param {number} column
		 */
		mutation: (prop, path, result, line, column) => {
			const name = path[0];
			if (is_bound_or_unset(props, name) || !parent) {
				return result;
			}

			/** @type {any} */
			let value = props;

			for (let i = 0; i < path.length - 1; i++) {
				value = value[path[i]];
				if (!value?.[STATE_SYMBOL]) {
					return result;
				}
			}

			const location = sanitize_location(`${component[FILENAME]}:${line}:${column}`);

			ownership_invalid_mutation(name, location, prop, parent[FILENAME]);

			return result;
		},
		/**
		 * @param {any} key
		 * @param {any} child_component
		 * @param {() => any} value
		 */
		binding: (key, child_component, value) => {
			if (!is_bound_or_unset(props, key) && parent && value()?.[STATE_SYMBOL]) {
				ownership_invalid_binding(
					component[FILENAME],
					key,
					child_component[FILENAME],
					parent[FILENAME]
				);
			}
		}
	};
}

/**
 * @param {Record<string, any>} props
 * @param {string} prop_name
 */
function is_bound_or_unset(props, prop_name) {
	// Can be the case when someone does `mount(Component, props)` with `let props = $state({...})`
	// or `createClassComponent(Component, props)`
	const is_entry_props = STATE_SYMBOL in props || LEGACY_PROPS in props;
	return (
		!!get_descriptor(props, prop_name)?.set ||
		(is_entry_props && prop_name in props) ||
		!(prop_name in props)
	);
}

/** @param {Function & { [FILENAME]: string }} target */
function check_target(target) {
	if (target) {
		component_api_invalid_new(target[FILENAME] ?? 'a component', target.name);
	}
}

function legacy_api() {
	const component = component_context?.function;

	/** @param {string} method */
	function error(method) {
		component_api_changed(method, component[FILENAME]);
	}

	return {
		$destroy: () => error('$destroy()'),
		$on: () => error('$on(...)'),
		$set: () => error('$set(...)')
	};
}

/** @import { Effect, TemplateNode } from '#client' */

/**
 * @typedef {{ effect: Effect, fragment: DocumentFragment }} Branch
 */

/**
 * @template Key
 */
class BranchManager {
	/** @type {TemplateNode} */
	anchor;

	/** @type {Map<Batch, Key>} */
	#batches = new Map();

	/**
	 * Map of keys to effects that are currently rendered in the DOM.
	 * These effects are visible and actively part of the document tree.
	 * Example:
	 * ```
	 * {#if condition}
	 * 	foo
	 * {:else}
	 * 	bar
	 * {/if}
	 * ```
	 * Can result in the entries `true->Effect` and `false->Effect`
	 * @type {Map<Key, Effect>}
	 */
	#onscreen = new Map();

	/**
	 * Similar to #onscreen with respect to the keys, but contains branches that are not yet
	 * in the DOM, because their insertion is deferred.
	 * @type {Map<Key, Branch>}
	 */
	#offscreen = new Map();

	/**
	 * Keys of effects that are currently outroing
	 * @type {Set<Key>}
	 */
	#outroing = new Set();

	/**
	 * Whether to pause (i.e. outro) on change, or destroy immediately.
	 * This is necessary for `<svelte:element>`
	 */
	#transition = true;

	/**
	 * @param {TemplateNode} anchor
	 * @param {boolean} transition
	 */
	constructor(anchor, transition = true) {
		this.anchor = anchor;
		this.#transition = transition;
	}

	#commit = () => {
		var batch = /** @type {Batch} */ (current_batch);

		// if this batch was made obsolete, bail
		if (!this.#batches.has(batch)) return;

		var key = /** @type {Key} */ (this.#batches.get(batch));

		var onscreen = this.#onscreen.get(key);

		if (onscreen) {
			// effect is already in the DOM — abort any current outro
			resume_effect(onscreen);
			this.#outroing.delete(key);
		} else {
			// effect is currently offscreen. put it in the DOM
			var offscreen = this.#offscreen.get(key);

			if (offscreen) {
				this.#onscreen.set(key, offscreen.effect);
				this.#offscreen.delete(key);

				// remove the anchor...
				/** @type {TemplateNode} */ (offscreen.fragment.lastChild).remove();

				// ...and append the fragment
				this.anchor.before(offscreen.fragment);
				onscreen = offscreen.effect;
			}
		}

		for (const [b, k] of this.#batches) {
			this.#batches.delete(b);

			if (b === batch) {
				// keep values for newer batches
				break;
			}

			const offscreen = this.#offscreen.get(k);

			if (offscreen) {
				// for older batches, destroy offscreen effects
				// as they will never be committed
				destroy_effect(offscreen.effect);
				this.#offscreen.delete(k);
			}
		}

		// outro/destroy all onscreen effects...
		for (const [k, effect] of this.#onscreen) {
			// ...except the one that was just committed
			//    or those that are already outroing (else the transition is aborted and the effect destroyed right away)
			if (k === key || this.#outroing.has(k)) continue;

			const on_destroy = () => {
				const keys = Array.from(this.#batches.values());

				if (keys.includes(k)) {
					// keep the effect offscreen, as another batch will need it
					var fragment = document.createDocumentFragment();
					move_effect(effect, fragment);

					fragment.append(create_text()); // TODO can we avoid this?

					this.#offscreen.set(k, { effect, fragment });
				} else {
					destroy_effect(effect);
				}

				this.#outroing.delete(k);
				this.#onscreen.delete(k);
			};

			if (this.#transition || !onscreen) {
				this.#outroing.add(k);
				pause_effect(effect, on_destroy, false);
			} else {
				on_destroy();
			}
		}
	};

	/**
	 * @param {Batch} batch
	 */
	#discard = (batch) => {
		this.#batches.delete(batch);

		const keys = Array.from(this.#batches.values());

		for (const [k, branch] of this.#offscreen) {
			if (!keys.includes(k)) {
				destroy_effect(branch.effect);
				this.#offscreen.delete(k);
			}
		}
	};

	/**
	 *
	 * @param {any} key
	 * @param {null | ((target: TemplateNode) => void)} fn
	 */
	ensure(key, fn) {
		var batch = /** @type {Batch} */ (current_batch);
		var defer = should_defer_append();

		if (fn && !this.#onscreen.has(key) && !this.#offscreen.has(key)) {
			if (defer) {
				var fragment = document.createDocumentFragment();
				var target = create_text();

				fragment.append(target);

				this.#offscreen.set(key, {
					effect: branch(() => fn(target)),
					fragment
				});
			} else {
				this.#onscreen.set(
					key,
					branch(() => fn(this.anchor))
				);
			}
		}

		this.#batches.set(batch, key);

		if (defer) {
			for (const [k, effect] of this.#onscreen) {
				if (k === key) {
					batch.skipped_effects.delete(effect);
				} else {
					batch.skipped_effects.add(effect);
				}
			}

			for (const [k, branch] of this.#offscreen) {
				if (k === key) {
					batch.skipped_effects.delete(branch.effect);
				} else {
					batch.skipped_effects.add(branch.effect);
				}
			}

			batch.oncommit(this.#commit);
			batch.ondiscard(this.#discard);
		} else {

			this.#commit();
		}
	}
}

/** @import { TemplateNode } from '#client' */

// TODO reinstate https://github.com/sveltejs/svelte/pull/15250

/**
 * @param {TemplateNode} node
 * @param {(branch: (fn: (anchor: Node) => void, flag?: boolean) => void) => void} fn
 * @param {boolean} [elseif] True if this is an `{:else if ...}` block rather than an `{#if ...}`, as that affects which transitions are considered 'local'
 * @returns {void}
 */
function if_block(node, fn, elseif = false) {

	var branches = new BranchManager(node);
	var flags = elseif ? EFFECT_TRANSPARENT : 0;

	/**
	 * @param {boolean} condition,
	 * @param {null | ((anchor: Node) => void)} fn
	 */
	function update_branch(condition, fn) {

		branches.ensure(condition, fn);
	}

	block(() => {
		var has_branch = false;

		fn((fn, flag = true) => {
			has_branch = true;
			update_branch(flag, fn);
		});

		if (!has_branch) {
			update_branch(false, null);
		}
	}, flags);
}

/** @import { Effect, TemplateNode } from '#client' */

/**
 * @param {Element | Text | Comment} node
 * @param {() => string} get_value
 * @param {boolean} [svg]
 * @param {boolean} [mathml]
 * @param {boolean} [skip_warning]
 * @returns {void}
 */
function html(node, get_value, svg = false, mathml = false, skip_warning = false) {
	var anchor = node;

	var value = '';

	template_effect(() => {
		var effect = /** @type {Effect} */ (active_effect);

		if (value === (value = get_value() ?? '')) {
			return;
		}

		if (effect.nodes_start !== null) {
			remove_effect_dom(effect.nodes_start, /** @type {TemplateNode} */ (effect.nodes_end));
			effect.nodes_start = effect.nodes_end = null;
		}

		if (value === '') return;

		var html = value + '';
		if (svg) html = `<svg>${html}</svg>`;
		else if (mathml) html = `<math>${html}</math>`;

		// Don't use create_fragment_with_script_from_html here because that would mean script tags are executed.
		// @html is basically `.innerHTML = ...` and that doesn't execute scripts either due to security reasons.
		/** @type {DocumentFragment | Element} */
		var node = create_fragment_from_html(html);

		if (svg || mathml) {
			node = /** @type {Element} */ (get_first_child(node));
		}

		assign_nodes(
			/** @type {TemplateNode} */ (get_first_child(node)),
			/** @type {TemplateNode} */ (node.lastChild)
		);

		if (svg || mathml) {
			while (get_first_child(node)) {
				anchor.before(/** @type {Node} */ (get_first_child(node)));
			}
		} else {
			anchor.before(node);
		}
	});
}

/**
 * @param {Comment} anchor
 * @param {Record<string, any>} $$props
 * @param {string} name
 * @param {Record<string, unknown>} slot_props
 * @param {null | ((anchor: Comment) => void)} fallback_fn
 */
function slot(anchor, $$props, name, slot_props, fallback_fn) {

	var slot_fn = $$props.$$slots?.[name];
	// Interop: Can use snippets to fill slots
	var is_interop = false;
	if (slot_fn === true) {
		slot_fn = $$props[name === 'default' ? 'children' : name];
		is_interop = true;
	}

	if (slot_fn === undefined) ; else {
		slot_fn(anchor, is_interop ? () => slot_props : slot_props);
	}
}

/** @param {() => unknown} tag_fn */
function validate_dynamic_element_tag(tag_fn) {
	const tag = tag_fn();
	const is_string = typeof tag === 'string';
	if (tag && !is_string) {
		svelte_element_invalid_this_value();
	}
}

/**
 * @param {any} store
 * @param {string} name
 */
function validate_store(store, name) {
	if (store != null && typeof store.subscribe !== 'function') {
		store_invalid_shape();
	}
}

/**
 * @template {(...args: any[]) => unknown} T
 * @param {T} fn
 */
function prevent_snippet_stringification(fn) {
	fn.toString = () => {
		snippet_without_render_tag();
		return '';
	};
	return fn;
}

/** @import { Snippet } from 'svelte' */
/** @import { TemplateNode } from '#client' */
/** @import { Getters } from '#shared' */

/**
 * In development, wrap the snippet function so that it passes validation, and so that the
 * correct component context is set for ownership checks
 * @param {any} component
 * @param {(node: TemplateNode, ...args: any[]) => void} fn
 */
function wrap_snippet(component, fn) {
	const snippet = (/** @type {TemplateNode} */ node, /** @type {any[]} */ ...args) => {
		var previous_component_function = dev_current_component_function;
		set_dev_current_component_function(component);

		try {
			return fn(node, ...args);
		} finally {
			set_dev_current_component_function(previous_component_function);
		}
	};

	prevent_snippet_stringification(snippet);

	return snippet;
}

/** @import { TemplateNode, Dom } from '#client' */

/**
 * @template P
 * @template {(props: P) => void} C
 * @param {TemplateNode} node
 * @param {() => C} get_component
 * @param {(anchor: TemplateNode, component: C) => Dom | void} render_fn
 * @returns {void}
 */
function component(node, get_component, render_fn) {

	var branches = new BranchManager(node);

	block(() => {
		var component = get_component() ?? null;
		branches.ensure(component, component && ((target) => render_fn(target, component)));
	}, EFFECT_TRANSPARENT);
}

/** @import { Effect, TemplateNode } from '#client' */

/**
 * @param {Comment | Element} node
 * @param {() => string} get_tag
 * @param {boolean} is_svg
 * @param {undefined | ((element: Element, anchor: Node | null) => void)} render_fn,
 * @param {undefined | (() => string)} get_namespace
 * @param {undefined | [number, number]} location
 * @returns {void}
 */
function element(node, get_tag, is_svg, render_fn, get_namespace, location) {

	/** @type {null | Element} */
	var element = null;

	var anchor = /** @type {TemplateNode} */ (node);

	/**
	 * The keyed `{#each ...}` item block, if any, that this element is inside.
	 * We track this so we can set it when changing the element, allowing any
	 * `animate:` directive to bind itself to the correct block
	 */
	var each_item_block = current_each_item;

	var branches = new BranchManager(anchor, false);

	block(() => {
		const next_tag = get_tag() || null;
		var ns = next_tag === 'svg' ? NAMESPACE_SVG : null;

		if (next_tag === null) {
			branches.ensure(null, null);
			return;
		}

		branches.ensure(next_tag, (anchor) => {
			// See explanation of `each_item_block` above
			var previous_each_item = current_each_item;
			set_current_each_item(each_item_block);

			if (next_tag) {
				element = ns
						? document.createElementNS(ns, next_tag)
						: document.createElement(next_tag);

				assign_nodes(element, element);

				if (render_fn) {

					// If hydrating, use the existing ssr comment as the anchor so that the
					// inner open and close methods can pick up the existing nodes correctly
					var child_anchor = /** @type {TemplateNode} */ (
						element.appendChild(create_text())
					);

					// `child_anchor` is undefined if this is a void element, but we still
					// need to call `render_fn` in order to run actions etc. If the element
					// contains children, it's a user error (which is warned on elsewhere)
					// and the DOM will be silently discarded
					render_fn(element, child_anchor);
				}

				// we do this after calling `render_fn` so that child effects don't override `nodes.end`
				/** @type {Effect} */ (active_effect).nodes_end = element;

				anchor.before(element);
			}

			set_current_each_item(previous_each_item);
		});

		return () => {
		};
	}, EFFECT_TRANSPARENT);

	teardown(() => {
	});
}

/** @import { ActionPayload } from '#client' */

/**
 * @template P
 * @param {Element} dom
 * @param {(dom: Element, value?: P) => ActionPayload<P>} action
 * @param {() => P} [get_value]
 * @returns {void}
 */
function action(dom, action, get_value) {
	effect(() => {
		var payload = untrack(() => action(dom, get_value?.()) || {});

		if (payload?.destroy) {
			return () => /** @type {Function} */ (payload.destroy)();
		}
	});
}

/** @import { Effect } from '#client' */

// TODO in 6.0 or 7.0, when we remove legacy mode, we can simplify this by
// getting rid of the block/branch stuff and just letting the effect rip.
// see https://github.com/sveltejs/svelte/pull/15962

/**
 * @param {Element} node
 * @param {() => (node: Element) => void} get_fn
 */
function attach(node, get_fn) {
	/** @type {false | undefined | ((node: Element) => void)} */
	var fn = undefined;

	/** @type {Effect | null} */
	var e;

	managed(() => {
		if (fn !== (fn = get_fn())) {
			if (e) {
				destroy_effect(e);
				e = null;
			}

			if (fn) {
				e = branch(() => {
					effect(() => /** @type {(node: Element) => void} */ (fn)(node));
				});
			}
		}
	});
}

function r(e){var t,f,n="";if("string"==typeof e||"number"==typeof e)n+=e;else if("object"==typeof e)if(Array.isArray(e)){var o=e.length;for(t=0;t<o;t++)e[t]&&(f=r(e[t]))&&(n&&(n+=" "),n+=f);}else for(f in e)e[f]&&(n&&(n+=" "),n+=f);return n}function clsx$1(){for(var e,t,f=0,n="",o=arguments.length;f<o;f++)(e=arguments[f])&&(t=r(e))&&(n&&(n+=" "),n+=t);return n}

/**
 * Small wrapper around clsx to preserve Svelte's (weird) handling of falsy values.
 * TODO Svelte 6 revisit this, and likely turn all falsy values into the empty string (what clsx also does)
 * @param  {any} value
 */
function clsx(value) {
	if (typeof value === 'object') {
		return clsx$1(value);
	} else {
		return value ?? '';
	}
}

const whitespace = [...' \t\n\r\f\u00a0\u000b\ufeff'];

/**
 * @param {any} value
 * @param {string | null} [hash]
 * @param {Record<string, boolean>} [directives]
 * @returns {string | null}
 */
function to_class(value, hash, directives) {
	var classname = value == null ? '' : '' + value;

	if (directives) {
		for (var key in directives) {
			if (directives[key]) {
				classname = classname ? classname + ' ' + key : key;
			} else if (classname.length) {
				var len = key.length;
				var a = 0;

				while ((a = classname.indexOf(key, a)) >= 0) {
					var b = a + len;

					if (
						(a === 0 || whitespace.includes(classname[a - 1])) &&
						(b === classname.length || whitespace.includes(classname[b]))
					) {
						classname = (a === 0 ? '' : classname.substring(0, a)) + classname.substring(b + 1);
					} else {
						a = b;
					}
				}
			}
		}
	}

	return classname === '' ? null : classname;
}

/**
 *
 * @param {Record<string,any>} styles
 * @param {boolean} important
 */
function append_styles(styles, important = false) {
	var separator = important ? ' !important;' : ';';
	var css = '';

	for (var key in styles) {
		var value = styles[key];
		if (value != null && value !== '') {
			css += ' ' + key + ': ' + value + separator;
		}
	}

	return css;
}

/**
 * @param {string} name
 * @returns {string}
 */
function to_css_name(name) {
	if (name[0] !== '-' || name[1] !== '-') {
		return name.toLowerCase();
	}
	return name;
}

/**
 * @param {any} value
 * @param {Record<string, any> | [Record<string, any>, Record<string, any>]} [styles]
 * @returns {string | null}
 */
function to_style(value, styles) {
	if (styles) {
		var new_style = '';

		/** @type {Record<string,any> | undefined} */
		var normal_styles;

		/** @type {Record<string,any> | undefined} */
		var important_styles;

		if (Array.isArray(styles)) {
			normal_styles = styles[0];
			important_styles = styles[1];
		} else {
			normal_styles = styles;
		}

		if (value) {
			value = String(value)
				.replaceAll(/\s*\/\*.*?\*\/\s*/g, '')
				.trim();

			/** @type {boolean | '"' | "'"} */
			var in_str = false;
			var in_apo = 0;
			var in_comment = false;

			var reserved_names = [];

			if (normal_styles) {
				reserved_names.push(...Object.keys(normal_styles).map(to_css_name));
			}
			if (important_styles) {
				reserved_names.push(...Object.keys(important_styles).map(to_css_name));
			}

			var start_index = 0;
			var name_index = -1;

			const len = value.length;
			for (var i = 0; i < len; i++) {
				var c = value[i];

				if (in_comment) {
					if (c === '/' && value[i - 1] === '*') {
						in_comment = false;
					}
				} else if (in_str) {
					if (in_str === c) {
						in_str = false;
					}
				} else if (c === '/' && value[i + 1] === '*') {
					in_comment = true;
				} else if (c === '"' || c === "'") {
					in_str = c;
				} else if (c === '(') {
					in_apo++;
				} else if (c === ')') {
					in_apo--;
				}

				if (!in_comment && in_str === false && in_apo === 0) {
					if (c === ':' && name_index === -1) {
						name_index = i;
					} else if (c === ';' || i === len - 1) {
						if (name_index !== -1) {
							var name = to_css_name(value.substring(start_index, name_index).trim());

							if (!reserved_names.includes(name)) {
								if (c !== ';') {
									i++;
								}

								var property = value.substring(start_index, i).trim();
								new_style += ' ' + property + ';';
							}
						}

						start_index = i + 1;
						name_index = -1;
					}
				}
			}
		}

		if (normal_styles) {
			new_style += append_styles(normal_styles);
		}

		if (important_styles) {
			new_style += append_styles(important_styles, true);
		}

		new_style = new_style.trim();
		return new_style === '' ? null : new_style;
	}

	return value == null ? null : String(value);
}

/**
 * @param {Element} dom
 * @param {boolean | number} is_html
 * @param {string | null} value
 * @param {string} [hash]
 * @param {Record<string, any>} [prev_classes]
 * @param {Record<string, any>} [next_classes]
 * @returns {Record<string, boolean> | undefined}
 */
function set_class(dom, is_html, value, hash, prev_classes, next_classes) {
	// @ts-expect-error need to add __className to patched prototype
	var prev = dom.__className;

	if (
		prev !== value ||
		prev === undefined // for edge case of `class={undefined}`
	) {
		var next_class_name = to_class(value, hash, next_classes);

		{
			// Removing the attribute when the value is only an empty string causes
			// performance issues vs simply making the className an empty string. So
			// we should only remove the class if the value is nullish
			// and there no hash/directives :
			if (next_class_name == null) {
				dom.removeAttribute('class');
			} else if (is_html) {
				dom.className = next_class_name;
			} else {
				dom.setAttribute('class', next_class_name);
			}
		}

		// @ts-expect-error need to add __className to patched prototype
		dom.__className = value;
	} else if (next_classes && prev_classes !== next_classes) {
		for (var key in next_classes) {
			var is_present = !!next_classes[key];

			if (prev_classes == null || is_present !== !!prev_classes[key]) {
				dom.classList.toggle(key, is_present);
			}
		}
	}

	return next_classes;
}

/**
 * @param {Element & ElementCSSInlineStyle} dom
 * @param {Record<string, any>} prev
 * @param {Record<string, any>} next
 * @param {string} [priority]
 */
function update_styles(dom, prev = {}, next, priority) {
	for (var key in next) {
		var value = next[key];

		if (prev[key] !== value) {
			if (next[key] == null) {
				dom.style.removeProperty(key);
			} else {
				dom.style.setProperty(key, value, priority);
			}
		}
	}
}

/**
 * @param {Element & ElementCSSInlineStyle} dom
 * @param {string | null} value
 * @param {Record<string, any> | [Record<string, any>, Record<string, any>]} [prev_styles]
 * @param {Record<string, any> | [Record<string, any>, Record<string, any>]} [next_styles]
 */
function set_style(dom, value, prev_styles, next_styles) {
	// @ts-expect-error
	var prev = dom.__style;

	if (prev !== value) {
		var next_style_attr = to_style(value, next_styles);

		{
			if (next_style_attr == null) {
				dom.removeAttribute('style');
			} else {
				dom.style.cssText = next_style_attr;
			}
		}

		// @ts-expect-error
		dom.__style = value;
	} else if (next_styles) {
		if (Array.isArray(next_styles)) {
			update_styles(dom, prev_styles?.[0], next_styles[0]);
			update_styles(dom, prev_styles?.[1], next_styles[1], 'important');
		} else {
			update_styles(dom, prev_styles, next_styles);
		}
	}

	return next_styles;
}

/**
 * Selects the correct option(s) (depending on whether this is a multiple select)
 * @template V
 * @param {HTMLSelectElement} select
 * @param {V} value
 * @param {boolean} mounting
 */
function select_option(select, value, mounting = false) {
	if (select.multiple) {
		// If value is null or undefined, keep the selection as is
		if (value == undefined) {
			return;
		}

		// If not an array, warn and keep the selection as is
		if (!is_array(value)) {
			return select_multiple_invalid_value();
		}

		// Otherwise, update the selection
		for (var option of select.options) {
			option.selected = value.includes(get_option_value(option));
		}

		return;
	}

	for (option of select.options) {
		var option_value = get_option_value(option);
		if (is(option_value, value)) {
			option.selected = true;
			return;
		}
	}

	if (!mounting || value !== undefined) {
		select.selectedIndex = -1; // no option should be selected
	}
}

/**
 * Selects the correct option(s) if `value` is given,
 * and then sets up a mutation observer to sync the
 * current selection to the dom when it changes. Such
 * changes could for example occur when options are
 * inside an `#each` block.
 * @param {HTMLSelectElement} select
 */
function init_select(select) {
	var observer = new MutationObserver(() => {
		// @ts-ignore
		select_option(select, select.__value);
		// Deliberately don't update the potential binding value,
		// the model should be preserved unless explicitly changed
	});

	observer.observe(select, {
		// Listen to option element changes
		childList: true,
		subtree: true, // because of <optgroup>
		// Listen to option element value attribute changes
		// (doesn't get notified of select value changes,
		// because that property is not reflected as an attribute)
		attributes: true,
		attributeFilter: ['value']
	});

	teardown(() => {
		observer.disconnect();
	});
}

/**
 * @param {HTMLSelectElement} select
 * @param {() => unknown} get
 * @param {(value: unknown) => void} set
 * @returns {void}
 */
function bind_select_value(select, get, set = get) {
	var batches = new WeakSet();
	var mounting = true;

	listen_to_event_and_reset_event(select, 'change', (is_reset) => {
		var query = is_reset ? '[selected]' : ':checked';
		/** @type {unknown} */
		var value;

		if (select.multiple) {
			value = [].map.call(select.querySelectorAll(query), get_option_value);
		} else {
			/** @type {HTMLOptionElement | null} */
			var selected_option =
				select.querySelector(query) ??
				// will fall back to first non-disabled option if no option is selected
				select.querySelector('option:not([disabled])');
			value = selected_option && get_option_value(selected_option);
		}

		set(value);

		if (current_batch !== null) {
			batches.add(current_batch);
		}
	});

	// Needs to be an effect, not a render_effect, so that in case of each loops the logic runs after the each block has updated
	effect(() => {
		var value = get();

		if (select === document.activeElement) {
			// we need both, because in non-async mode, render effects run before previous_batch is set
			var batch = /** @type {Batch} */ (previous_batch ?? current_batch);

			// Don't update the <select> if it is focused. We can get here if, for example,
			// an update is deferred because of async work depending on the select:
			//
			// <select bind:value={selected}>...</select>
			// <p>{await find(selected)}</p>
			if (batches.has(batch)) {
				return;
			}
		}

		select_option(select, value, mounting);

		// Mounting and value undefined -> take selection from dom
		if (mounting && value === undefined) {
			/** @type {HTMLOptionElement | null} */
			var selected_option = select.querySelector(':checked');
			if (selected_option !== null) {
				value = get_option_value(selected_option);
				set(value);
			}
		}

		// @ts-ignore
		select.__value = value;
		mounting = false;
	});

	init_select(select);
}

/** @param {HTMLOptionElement} option */
function get_option_value(option) {
	// __value only exists if the <option> has a value attribute
	if ('__value' in option) {
		return option.__value;
	} else {
		return option.value;
	}
}

/** @import { Effect } from '#client' */

const CLASS = Symbol('class');
const STYLE = Symbol('style');

const IS_CUSTOM_ELEMENT = Symbol('is custom element');
const IS_HTML = Symbol('is html');

/**
 * The value/checked attribute in the template actually corresponds to the defaultValue property, so we need
 * to remove it upon hydration to avoid a bug when someone resets the form value.
 * @param {HTMLInputElement} input
 * @returns {void}
 */
function remove_input_defaults(input) {
	return;
}

/**
 * @param {Element} element
 * @param {any} value
 */
function set_value(element, value) {
	var attributes = get_attributes(element);

	if (
		attributes.value ===
			(attributes.value =
				// treat null and undefined the same for the initial value
				value ?? undefined) ||
		// @ts-expect-error
		// `progress` elements always need their value set when it's `0`
		(element.value === value && (value !== 0 || element.nodeName !== 'PROGRESS'))
	) {
		return;
	}

	// @ts-expect-error
	element.value = value ?? '';
}

/**
 * @param {Element} element
 * @param {boolean} checked
 */
function set_checked(element, checked) {
	var attributes = get_attributes(element);

	if (
		attributes.checked ===
		(attributes.checked =
			// treat null and undefined the same for the initial value
			checked ?? undefined)
	) {
		return;
	}

	// @ts-expect-error
	element.checked = checked;
}

/**
 * Sets the `selected` attribute on an `option` element.
 * Not set through the property because that doesn't reflect to the DOM,
 * which means it wouldn't be taken into account when a form is reset.
 * @param {HTMLOptionElement} element
 * @param {boolean} selected
 */
function set_selected(element, selected) {
	if (selected) {
		// The selected option could've changed via user selection, and
		// setting the value without this check would set it back.
		if (!element.hasAttribute('selected')) {
			element.setAttribute('selected', '');
		}
	} else {
		element.removeAttribute('selected');
	}
}

/**
 * @param {Element} element
 * @param {string} attribute
 * @param {string | null} value
 * @param {boolean} [skip_warning]
 */
function set_attribute(element, attribute, value, skip_warning) {
	var attributes = get_attributes(element);

	if (attributes[attribute] === (attributes[attribute] = value)) return;

	if (attribute === 'loading') {
		// @ts-expect-error
		element[LOADING_ATTR_SYMBOL] = value;
	}

	if (value == null) {
		element.removeAttribute(attribute);
	} else if (typeof value !== 'string' && get_setters(element).includes(attribute)) {
		// @ts-ignore
		element[attribute] = value;
	} else {
		element.setAttribute(attribute, value);
	}
}

/**
 * @param {Element} dom
 * @param {string} attribute
 * @param {string} value
 */
function set_xlink_attribute(dom, attribute, value) {
	dom.setAttributeNS('http://www.w3.org/1999/xlink', attribute, value);
}

/**
 * Spreads attributes onto a DOM element, taking into account the currently set attributes
 * @param {Element & ElementCSSInlineStyle} element
 * @param {Record<string | symbol, any> | undefined} prev
 * @param {Record<string | symbol, any>} next New attributes - this function mutates this object
 * @param {string} [css_hash]
 * @param {boolean} [should_remove_defaults]
 * @param {boolean} [skip_warning]
 * @returns {Record<string, any>}
 */
function set_attributes(
	element,
	prev,
	next,
	css_hash,
	should_remove_defaults = false,
	skip_warning = false
) {

	var attributes = get_attributes(element);

	var is_custom_element = attributes[IS_CUSTOM_ELEMENT];
	var preserve_attribute_case = !attributes[IS_HTML];

	var current = prev || {};
	var is_option_element = element.tagName === 'OPTION';

	for (var key in prev) {
		if (!(key in next)) {
			next[key] = null;
		}
	}

	if (next.class) {
		next.class = clsx(next.class);
	} else if (next[CLASS]) {
		next.class = null; /* force call to set_class() */
	}

	if (next[STYLE]) {
		next.style ??= null; /* force call to set_style() */
	}

	var setters = get_setters(element);

	// since key is captured we use const
	for (const key in next) {
		// let instead of var because referenced in a closure
		let value = next[key];

		// Up here because we want to do this for the initial value, too, even if it's undefined,
		// and this wouldn't be reached in case of undefined because of the equality check below
		if (is_option_element && key === 'value' && value == null) {
			// The <option> element is a special case because removing the value attribute means
			// the value is set to the text content of the option element, and setting the value
			// to null or undefined means the value is set to the string "null" or "undefined".
			// To align with how we handle this case in non-spread-scenarios, this logic is needed.
			// There's a super-edge-case bug here that is left in in favor of smaller code size:
			// Because of the "set missing props to null" logic above, we can't differentiate
			// between a missing value and an explicitly set value of null or undefined. That means
			// that once set, the value attribute of an <option> element can't be removed. This is
			// a very rare edge case, and removing the attribute altogether isn't possible either
			// for the <option value={undefined}> case, so we're not losing any functionality here.
			// @ts-ignore
			element.value = element.__value = '';
			current[key] = value;
			continue;
		}

		if (key === 'class') {
			var is_html = element.namespaceURI === 'http://www.w3.org/1999/xhtml';
			set_class(element, is_html, value, css_hash, prev?.[CLASS], next[CLASS]);
			current[key] = value;
			current[CLASS] = next[CLASS];
			continue;
		}

		if (key === 'style') {
			set_style(element, value, prev?.[STYLE], next[STYLE]);
			current[key] = value;
			current[STYLE] = next[STYLE];
			continue;
		}

		var prev_value = current[key];

		// Skip if value is unchanged, unless it's `undefined` and the element still has the attribute
		if (value === prev_value && !(value === undefined && element.hasAttribute(key))) {
			continue;
		}

		current[key] = value;

		var prefix = key[0] + key[1]; // this is faster than key.slice(0, 2)
		if (prefix === '$$') continue;

		if (prefix === 'on') {
			/** @type {{ capture?: true }} */
			const opts = {};
			const event_handle_key = '$$' + key;
			let event_name = key.slice(2);
			var delegated = can_delegate_event(event_name);

			if (is_capture_event(event_name)) {
				event_name = event_name.slice(0, -7);
				opts.capture = true;
			}

			if (!delegated && prev_value) {
				// Listening to same event but different handler -> our handle function below takes care of this
				// If we were to remove and add listeners in this case, it could happen that the event is "swallowed"
				// (the browser seems to not know yet that a new one exists now) and doesn't reach the handler
				// https://github.com/sveltejs/svelte/issues/11903
				if (value != null) continue;

				element.removeEventListener(event_name, current[event_handle_key], opts);
				current[event_handle_key] = null;
			}

			if (value != null) {
				if (!delegated) {
					/**
					 * @this {any}
					 * @param {Event} evt
					 */
					function handle(evt) {
						current[key].call(this, evt);
					}

					current[event_handle_key] = create_event(event_name, element, handle, opts);
				} else {
					// @ts-ignore
					element[`__${event_name}`] = value;
					delegate([event_name]);
				}
			} else if (delegated) {
				// @ts-ignore
				element[`__${event_name}`] = undefined;
			}
		} else if (key === 'style') {
			// avoid using the setter
			set_attribute(element, key, value);
		} else if (key === 'autofocus') {
			autofocus(/** @type {HTMLElement} */ (element), Boolean(value));
		} else if (!is_custom_element && (key === '__value' || (key === 'value' && value != null))) {
			// @ts-ignore We're not running this for custom elements because __value is actually
			// how Lit stores the current value on the element, and messing with that would break things.
			element.value = element.__value = value;
		} else if (key === 'selected' && is_option_element) {
			set_selected(/** @type {HTMLOptionElement} */ (element), value);
		} else {
			var name = key;
			if (!preserve_attribute_case) {
				name = normalize_attribute(name);
			}

			var is_default = name === 'defaultValue' || name === 'defaultChecked';

			if (value == null && !is_custom_element && !is_default) {
				attributes[key] = null;

				if (name === 'value' || name === 'checked') {
					// removing value/checked also removes defaultValue/defaultChecked — preserve
					let input = /** @type {HTMLInputElement} */ (element);
					const use_default = prev === undefined;
					if (name === 'value') {
						let previous = input.defaultValue;
						input.removeAttribute(name);
						input.defaultValue = previous;
						// @ts-ignore
						input.value = input.__value = use_default ? previous : null;
					} else {
						let previous = input.defaultChecked;
						input.removeAttribute(name);
						input.defaultChecked = previous;
						input.checked = use_default ? previous : false;
					}
				} else {
					element.removeAttribute(key);
				}
			} else if (
				is_default ||
				(setters.includes(name) && (is_custom_element || typeof value !== 'string'))
			) {
				// @ts-ignore
				element[name] = value;
				// remove it from attributes's cache
				if (name in attributes) attributes[name] = UNINITIALIZED;
			} else if (typeof value !== 'function') {
				set_attribute(element, name, value);
			}
		}
	}

	return current;
}

/**
 * @param {Element & ElementCSSInlineStyle} element
 * @param {(...expressions: any) => Record<string | symbol, any>} fn
 * @param {Array<() => any>} sync
 * @param {Array<() => Promise<any>>} async
 * @param {Array<Promise<void>>} blockers
 * @param {string} [css_hash]
 * @param {boolean} [should_remove_defaults]
 * @param {boolean} [skip_warning]
 */
function attribute_effect(
	element,
	fn,
	sync = [],
	async = [],
	blockers = [],
	css_hash,
	should_remove_defaults = false,
	skip_warning = false
) {
	flatten(blockers, sync, async, (values) => {
		/** @type {Record<string | symbol, any> | undefined} */
		var prev = undefined;

		/** @type {Record<symbol, Effect>} */
		var effects = {};

		var is_select = element.nodeName === 'SELECT';
		var inited = false;

		managed(() => {
			var next = fn(...values.map(get$1));
			/** @type {Record<string | symbol, any>} */
			var current = set_attributes(
				element,
				prev,
				next,
				css_hash,
				should_remove_defaults,
				skip_warning
			);

			if (inited && is_select && 'value' in next) {
				select_option(/** @type {HTMLSelectElement} */ (element), next.value);
			}

			for (let symbol of Object.getOwnPropertySymbols(effects)) {
				if (!next[symbol]) destroy_effect(effects[symbol]);
			}

			for (let symbol of Object.getOwnPropertySymbols(next)) {
				var n = next[symbol];

				if (symbol.description === ATTACHMENT_KEY && (!prev || n !== prev[symbol])) {
					if (effects[symbol]) destroy_effect(effects[symbol]);
					effects[symbol] = branch(() => attach(element, () => n));
				}

				current[symbol] = n;
			}

			prev = current;
		});

		if (is_select) {
			var select = /** @type {HTMLSelectElement} */ (element);

			effect(() => {
				select_option(select, /** @type {Record<string | symbol, any>} */ (prev).value, true);
				init_select(select);
			});
		}

		inited = true;
	});
}

/**
 *
 * @param {Element} element
 */
function get_attributes(element) {
	return /** @type {Record<string | symbol, unknown>} **/ (
		// @ts-expect-error
		element.__attributes ??= {
			[IS_CUSTOM_ELEMENT]: element.nodeName.includes('-'),
			[IS_HTML]: element.namespaceURI === NAMESPACE_HTML
		}
	);
}

/** @type {Map<string, string[]>} */
var setters_cache = new Map();

/** @param {Element} element */
function get_setters(element) {
	var cache_key = element.getAttribute('is') || element.nodeName;
	var setters = setters_cache.get(cache_key);
	if (setters) return setters;
	setters_cache.set(cache_key, (setters = []));

	var descriptors;
	var proto = element; // In the case of custom elements there might be setters on the instance
	var element_proto = Element.prototype;

	// Stop at Element, from there on there's only unnecessary setters we're not interested in
	// Do not use contructor.name here as that's unreliable in some browser environments
	while (element_proto !== proto) {
		descriptors = get_descriptors(proto);

		for (var key in descriptors) {
			if (descriptors[key].set) {
				setters.push(key);
			}
		}

		proto = get_prototype_of(proto);
	}

	return setters;
}

/** @import { Batch } from '../../../reactivity/batch.js' */

/**
 * @param {HTMLInputElement} input
 * @param {() => unknown} get
 * @param {(value: unknown) => void} set
 * @returns {void}
 */
function bind_value(input, get, set = get) {
	var batches = new WeakSet();

	listen_to_event_and_reset_event(input, 'input', async (is_reset) => {

		/** @type {any} */
		var value = is_reset ? input.defaultValue : input.value;
		value = is_numberlike_input(input) ? to_number(value) : value;
		set(value);

		if (current_batch !== null) {
			batches.add(current_batch);
		}

		// Because `{#each ...}` blocks work by updating sources inside the flush,
		// we need to wait a tick before checking to see if we should forcibly
		// update the input and reset the selection state
		await tick();

		// Respect any validation in accessors
		if (value !== (value = get())) {
			var start = input.selectionStart;
			var end = input.selectionEnd;
			var length = input.value.length;

			// the value is coerced on assignment
			input.value = value ?? '';

			// Restore selection
			if (end !== null) {
				var new_length = input.value.length;
				// If cursor was at end and new input is longer, move cursor to new end
				if (start === end && end === length && new_length > length) {
					input.selectionStart = new_length;
					input.selectionEnd = new_length;
				} else {
					input.selectionStart = start;
					input.selectionEnd = Math.min(end, new_length);
				}
			}
		}
	});

	if (
		// If we are hydrating and the value has since changed,
		// then use the updated value from the input instead.
		// If defaultValue is set, then value == defaultValue
		// TODO Svelte 6: remove input.value check and set to empty string?
		(untrack(get) == null && input.value)
	) {
		set(is_numberlike_input(input) ? to_number(input.value) : input.value);

		if (current_batch !== null) {
			batches.add(current_batch);
		}
	}

	render_effect(() => {

		var value = get();

		if (input === document.activeElement) {
			// we need both, because in non-async mode, render effects run before previous_batch is set
			var batch = /** @type {Batch} */ (previous_batch ?? current_batch);

			// Never rewrite the contents of a focused input. We can get here if, for example,
			// an update is deferred because of async work depending on the input:
			//
			// <input bind:value={query}>
			// <p>{await find(query)}</p>
			if (batches.has(batch)) {
				return;
			}
		}

		if (is_numberlike_input(input) && value === to_number(input.value)) {
			// handles 0 vs 00 case (see https://github.com/sveltejs/svelte/issues/9959)
			return;
		}

		if (input.type === 'date' && !value && !input.value) {
			// Handles the case where a temporarily invalid date is set (while typing, for example with a leading 0 for the day)
			// and prevents this state from clearing the other parts of the date input (see https://github.com/sveltejs/svelte/issues/7897)
			return;
		}

		// don't set the value of the input if it's the same to allow
		// minlength to work properly
		if (value !== input.value) {
			// @ts-expect-error the value is coerced on assignment
			input.value = value ?? '';
		}
	});
}

/**
 * @param {HTMLInputElement} input
 * @param {() => unknown} get
 * @param {(value: unknown) => void} set
 * @returns {void}
 */
function bind_checked(input, get, set = get) {
	listen_to_event_and_reset_event(input, 'change', (is_reset) => {
		var value = is_reset ? input.defaultChecked : input.checked;
		set(value);
	});

	if (
		// If we are hydrating and the value has since changed,
		// then use the update value from the input instead.
		// If defaultChecked is set, then checked == defaultChecked
		untrack(get) == null
	) {
		set(input.checked);
	}

	render_effect(() => {
		var value = get();
		input.checked = Boolean(value);
	});
}

/**
 * @param {HTMLInputElement} input
 */
function is_numberlike_input(input) {
	var type = input.type;
	return type === 'number' || type === 'range';
}

/**
 * @param {string} value
 */
function to_number(value) {
	return value === '' ? null : +value;
}

/**
 * @param {any} bound_value
 * @param {Element} element_or_component
 * @returns {boolean}
 */
function is_bound_this(bound_value, element_or_component) {
	return (
		bound_value === element_or_component || bound_value?.[STATE_SYMBOL] === element_or_component
	);
}

/**
 * @param {any} element_or_component
 * @param {(value: unknown, ...parts: unknown[]) => void} update
 * @param {(...parts: unknown[]) => unknown} get_value
 * @param {() => unknown[]} [get_parts] Set if the this binding is used inside an each block,
 * 										returns all the parts of the each block context that are used in the expression
 * @returns {void}
 */
function bind_this(element_or_component = {}, update, get_value, get_parts) {
	effect(() => {
		/** @type {unknown[]} */
		var old_parts;

		/** @type {unknown[]} */
		var parts;

		render_effect(() => {
			old_parts = parts;
			// We only track changes to the parts, not the value itself to avoid unnecessary reruns.
			parts = get_parts?.() || [];

			untrack(() => {
				if (element_or_component !== get_value(...parts)) {
					update(element_or_component, ...parts);
					// If this is an effect rerun (cause: each block context changes), then nullify the binding at
					// the previous position if it isn't already taken over by a different effect.
					if (old_parts && is_bound_this(get_value(...old_parts), element_or_component)) {
						update(null, ...old_parts);
					}
				}
			});
		});

		return () => {
			// We cannot use effects in the teardown phase, we we use a microtask instead.
			queue_micro_task(() => {
				if (parts && is_bound_this(get_value(...parts), element_or_component)) {
					update(null, ...parts);
				}
			});
		};
	});

	return element_or_component;
}

/** @import { ComponentContextLegacy } from '#client' */

/**
 * Legacy-mode only: Call `onMount` callbacks and set up `beforeUpdate`/`afterUpdate` effects
 * @param {boolean} [immutable]
 */
function init(immutable = false) {
	const context = /** @type {ComponentContextLegacy} */ (component_context);

	const callbacks = context.l.u;
	if (!callbacks) return;

	let props = () => deep_read_state(context.s);

	if (immutable) {
		let version = 0;
		let prev = /** @type {Record<string, any>} */ ({});

		// In legacy immutable mode, before/afterUpdate only fire if the object identity of a prop changes
		const d = derived(() => {
			let changed = false;
			const props = context.s;
			for (const key in props) {
				if (props[key] !== prev[key]) {
					prev[key] = props[key];
					changed = true;
				}
			}
			if (changed) version++;
			return version;
		});

		props = () => get$1(d);
	}

	// beforeUpdate
	if (callbacks.b.length) {
		user_pre_effect(() => {
			observe_all(context, props);
			run_all(callbacks.b);
		});
	}

	// onMount (must run before afterUpdate)
	user_effect(() => {
		const fns = untrack(() => callbacks.m.map(run));
		return () => {
			for (const fn of fns) {
				if (typeof fn === 'function') {
					fn();
				}
			}
		};
	});

	// afterUpdate
	if (callbacks.a.length) {
		user_effect(() => {
			observe_all(context, props);
			run_all(callbacks.a);
		});
	}
}

/**
 * Invoke the getter of all signals associated with a component
 * so they can be registered to the effect this function is called in.
 * @param {ComponentContextLegacy} context
 * @param {(() => void)} props
 */
function observe_all(context, props) {
	if (context.l.s) {
		for (const signal of context.l.s) get$1(signal);
	}

	props();
}

/** @import { StoreReferencesContainer } from '#client' */
/** @import { Store } from '#shared' */

/**
 * Whether or not the prop currently being read is a store binding, as in
 * `<Child bind:x={$y} />`. If it is, we treat the prop as mutable even in
 * runes mode, and skip `binding_property_non_reactive` validation
 */
let is_store_binding = false;

let IS_UNMOUNTED = Symbol();

/**
 * Gets the current value of a store. If the store isn't subscribed to yet, it will create a proxy
 * signal that will be updated when the store is. The store references container is needed to
 * track reassignments to stores and to track the correct component context.
 * @template V
 * @param {Store<V> | null | undefined} store
 * @param {string} store_name
 * @param {StoreReferencesContainer} stores
 * @returns {V}
 */
function store_get(store, store_name, stores) {
	const entry = (stores[store_name] ??= {
		store: null,
		source: mutable_source(undefined),
		unsubscribe: noop
	});

	// if the component that setup this is already unmounted we don't want to register a subscription
	if (entry.store !== store && !(IS_UNMOUNTED in stores)) {
		entry.unsubscribe();
		entry.store = store ?? null;

		if (store == null) {
			entry.source.v = undefined; // see synchronous callback comment below
			entry.unsubscribe = noop;
		} else {
			var is_synchronous_callback = true;

			entry.unsubscribe = subscribe_to_store(store, (v) => {
				if (is_synchronous_callback) {
					// If the first updates to the store value (possibly multiple of them) are synchronously
					// inside a derived, we will hit the `state_unsafe_mutation` error if we `set` the value
					entry.source.v = v;
				} else {
					set(entry.source, v);
				}
			});

			is_synchronous_callback = false;
		}
	}

	// if the component that setup this stores is already unmounted the source will be out of sync
	// so we just use the `get` for the stores, less performant but it avoids to create a memory leak
	// and it will keep the value consistent
	if (store && IS_UNMOUNTED in stores) {
		return get(store);
	}

	return get$1(entry.source);
}

/**
 * Sets the new value of a store and returns that value.
 * @template V
 * @param {Store<V>} store
 * @param {V} value
 * @returns {V}
 */
function store_set(store, value) {
	store.set(value);
	return value;
}

/**
 * Unsubscribes from all auto-subscribed stores on destroy
 * @returns {[StoreReferencesContainer, ()=>void]}
 */
function setup_stores() {
	/** @type {StoreReferencesContainer} */
	const stores = {};

	function cleanup() {
		teardown(() => {
			for (var store_name in stores) {
				const ref = stores[store_name];
				ref.unsubscribe();
			}
			define_property(stores, IS_UNMOUNTED, {
				enumerable: false,
				value: true
			});
		});
	}

	return [stores, cleanup];
}

/**
 * Updates a store with a new value.
 * @param {Store<V>} store  the store to update
 * @param {any} expression  the expression that mutates the store
 * @param {V} new_value  the new store value
 * @template V
 */
function store_mutate(store, expression, new_value) {
	store.set(new_value);
	return expression;
}

/**
 * Called inside prop getters to communicate that the prop is a store binding
 */
function mark_store_binding() {
	is_store_binding = true;
}

/**
 * Returns a tuple that indicates whether `fn()` reads a prop that is a store binding.
 * Used to prevent `binding_property_non_reactive` validation false positives and
 * ensure that these props are treated as mutable even in runes mode
 * @template T
 * @param {() => T} fn
 * @returns {[T, boolean]}
 */
function capture_store_binding(fn) {
	var previous_is_store_binding = is_store_binding;

	try {
		is_store_binding = false;
		return [fn(), is_store_binding];
	} finally {
		is_store_binding = previous_is_store_binding;
	}
}

/** @import { Effect, Source } from './types.js' */

/**
 * This function is responsible for synchronizing a possibly bound prop with the inner component state.
 * It is used whenever the compiler sees that the component writes to the prop, or when it has a default prop_value.
 * @template V
 * @param {Record<string, unknown>} props
 * @param {string} key
 * @param {number} flags
 * @param {V | (() => V)} [fallback]
 * @returns {(() => V | ((arg: V) => V) | ((arg: V, mutation: boolean) => V))}
 */
function prop(props, key, flags, fallback) {
	var runes = !legacy_mode_flag || (flags & PROPS_IS_RUNES) !== 0;
	var bindable = (flags & PROPS_IS_BINDABLE) !== 0;
	var lazy = (flags & PROPS_IS_LAZY_INITIAL) !== 0;

	var fallback_value = /** @type {V} */ (fallback);
	var fallback_dirty = true;

	var get_fallback = () => {
		if (fallback_dirty) {
			fallback_dirty = false;

			fallback_value = lazy
				? untrack(/** @type {() => V} */ (fallback))
				: /** @type {V} */ (fallback);
		}

		return fallback_value;
	};

	/** @type {((v: V) => void) | undefined} */
	var setter;

	if (bindable) {
		// Can be the case when someone does `mount(Component, props)` with `let props = $state({...})`
		// or `createClassComponent(Component, props)`
		var is_entry_props = STATE_SYMBOL in props || LEGACY_PROPS in props;

		setter =
			get_descriptor(props, key)?.set ??
			(is_entry_props && key in props ? (v) => (props[key] = v) : undefined);
	}

	var initial_value;
	var is_store_sub = false;

	if (bindable) {
		[initial_value, is_store_sub] = capture_store_binding(() => /** @type {V} */ (props[key]));
	} else {
		initial_value = /** @type {V} */ (props[key]);
	}

	if (initial_value === undefined && fallback !== undefined) {
		initial_value = get_fallback();

		if (setter) {
			if (runes) props_invalid_value();
			setter(initial_value);
		}
	}

	/** @type {() => V} */
	var getter;

	if (runes) {
		getter = () => {
			var value = /** @type {V} */ (props[key]);
			if (value === undefined) return get_fallback();
			fallback_dirty = true;
			return value;
		};
	} else {
		getter = () => {
			var value = /** @type {V} */ (props[key]);

			if (value !== undefined) {
				// in legacy mode, we don't revert to the fallback value
				// if the prop goes from defined to undefined. The easiest
				// way to model this is to make the fallback undefined
				// as soon as the prop has a value
				fallback_value = /** @type {V} */ (undefined);
			}

			return value === undefined ? fallback_value : value;
		};
	}

	// prop is never written to — we only need a getter
	if (runes && (flags & PROPS_IS_UPDATED) === 0) {
		return getter;
	}

	// prop is written to, but the parent component had `bind:foo` which
	// means we can just call `$$props.foo = value` directly
	if (setter) {
		var legacy_parent = props.$$legacy;
		return /** @type {() => V} */ (
			function (/** @type {V} */ value, /** @type {boolean} */ mutation) {
				if (arguments.length > 0) {
					// We don't want to notify if the value was mutated and the parent is in runes mode.
					// In that case the state proxy (if it exists) should take care of the notification.
					// If the parent is not in runes mode, we need to notify on mutation, too, that the prop
					// has changed because the parent will not be able to detect the change otherwise.
					if (!runes || !mutation || legacy_parent || is_store_sub) {
						/** @type {Function} */ (setter)(mutation ? getter() : value);
					}

					return value;
				}

				return getter();
			}
		);
	}

	// Either prop is written to, but there's no binding, which means we
	// create a derived that we can write to locally.
	// Or we are in legacy mode where we always create a derived to replicate that
	// Svelte 4 did not trigger updates when a primitive value was updated to the same value.
	var overridden = false;

	var d = ((flags & PROPS_IS_IMMUTABLE) !== 0 ? derived : derived_safe_equal)(() => {
		overridden = false;
		return getter();
	});

	// Capture the initial value if it's bindable
	if (bindable) get$1(d);

	var parent_effect = /** @type {Effect} */ (active_effect);

	return /** @type {() => V} */ (
		function (/** @type {any} */ value, /** @type {boolean} */ mutation) {
			if (arguments.length > 0) {
				const new_value = mutation ? get$1(d) : runes && bindable ? proxy(value) : value;

				set(d, new_value);
				overridden = true;

				if (fallback_value !== undefined) {
					fallback_value = new_value;
				}

				return value;
			}

			// special case — avoid recalculating the derived if we're in a
			// teardown function and the prop was overridden locally, or the
			// component was already destroyed (this latter part is necessary
			// because `bind:this` can read props after the component has
			// been destroyed. TODO simplify `bind:this`
			if ((is_destroying_effect && overridden) || (parent_effect.f & DESTROYED) !== 0) {
				return d.v;
			}

			return get$1(d);
		}
	);
}

/**
 * @param {string} binding
 * @param {Array<Promise<void>>} blockers
 * @param {() => Record<string, any>} get_object
 * @param {() => string} get_property
 * @param {number} line
 * @param {number} column
 */
function validate_binding(binding, blockers, get_object, get_property, line, column) {
	run_after_blockers(blockers, () => {
		var warned = false;

		dev_current_component_function?.[FILENAME];

		render_effect(() => {
			if (warned) return;

			var [object, is_store_sub] = capture_store_binding(get_object);

			if (is_store_sub) return;

			var property = get_property();

			var ran = false;

			// by making the (possibly false, but it would be an extreme edge case) assumption
			// that a getter has a corresponding setter, we can determine if a property is
			// reactive by seeing if this effect has dependencies
			var effect = render_effect(() => {
				if (ran) return;

				// eslint-disable-next-line @typescript-eslint/no-unused-expressions
				object[property];
			});

			ran = true;

			if (effect.deps === null) {
				binding_property_non_reactive();

				warned = true;
			}
		});
	});
}

/** @import { ComponentContext, ComponentContextLegacy } from '#client' */
/** @import { EventDispatcher } from './index.js' */
/** @import { NotFunction } from './internal/types.js' */

/**
 * `onMount`, like [`$effect`](https://svelte.dev/docs/svelte/$effect), schedules a function to run as soon as the component has been mounted to the DOM.
 * Unlike `$effect`, the provided function only runs once.
 *
 * It must be called during the component's initialisation (but doesn't need to live _inside_ the component;
 * it can be called from an external module). If a function is returned _synchronously_ from `onMount`,
 * it will be called when the component is unmounted.
 *
 * `onMount` functions do not run during [server-side rendering](https://svelte.dev/docs/svelte/svelte-server#render).
 *
 * @template T
 * @param {() => NotFunction<T> | Promise<NotFunction<T>> | (() => any)} fn
 * @returns {void}
 */
function onMount(fn) {
	if (component_context === null) {
		lifecycle_outside_component();
	}

	if (legacy_mode_flag && component_context.l !== null) {
		init_update_callbacks(component_context).m.push(fn);
	} else {
		user_effect(() => {
			const cleanup = untrack(fn);
			if (typeof cleanup === 'function') return /** @type {() => void} */ (cleanup);
		});
	}
}

/**
 * Legacy-mode: Init callbacks object for onMount/beforeUpdate/afterUpdate
 * @param {ComponentContext} context
 */
function init_update_callbacks(context) {
	var l = /** @type {ComponentContextLegacy} */ (context).l;
	return (l.u ??= { a: [], b: [], m: [] });
}

/** @import { Readable } from './public' */

/**
 * @template T
 * @param {Readable<T> | null | undefined} store
 * @param {(value: T) => void} run
 * @param {(value: T) => void} [invalidate]
 * @returns {() => void}
 */
function subscribe_to_store(store, run, invalidate) {
	if (store == null) {
		// @ts-expect-error
		run(undefined);

		return noop;
	}

	// Svelte store takes a private second argument
	// StartStopNotifier could mutate state, and we want to silence the corresponding validation error
	const unsub = untrack(() =>
		store.subscribe(
			run,
			// @ts-expect-error
			invalidate
		)
	);

	// Also support RxJS
	// @ts-expect-error TODO fix this in the types?
	return unsub.unsubscribe ? () => unsub.unsubscribe() : unsub;
}

/** @import { Readable, StartStopNotifier, Subscriber, Unsubscriber, Updater, Writable } from '../public.js' */
/** @import { Stores, StoresValues, SubscribeInvalidateTuple } from '../private.js' */

/**
 * @type {Array<SubscribeInvalidateTuple<any> | any>}
 */
const subscriber_queue = [];

/**
 * Create a `Writable` store that allows both updating and reading by subscription.
 *
 * @template T
 * @param {T} [value] initial value
 * @param {StartStopNotifier<T>} [start]
 * @returns {Writable<T>}
 */
function writable(value, start = noop) {
	/** @type {Unsubscriber | null} */
	let stop = null;

	/** @type {Set<SubscribeInvalidateTuple<T>>} */
	const subscribers = new Set();

	/**
	 * @param {T} new_value
	 * @returns {void}
	 */
	function set(new_value) {
		if (safe_not_equal(value, new_value)) {
			value = new_value;
			if (stop) {
				// store is ready
				const run_queue = !subscriber_queue.length;
				for (const subscriber of subscribers) {
					subscriber[1]();
					subscriber_queue.push(subscriber, value);
				}
				if (run_queue) {
					for (let i = 0; i < subscriber_queue.length; i += 2) {
						subscriber_queue[i][0](subscriber_queue[i + 1]);
					}
					subscriber_queue.length = 0;
				}
			}
		}
	}

	/**
	 * @param {Updater<T>} fn
	 * @returns {void}
	 */
	function update(fn) {
		set(fn(/** @type {T} */ (value)));
	}

	/**
	 * @param {Subscriber<T>} run
	 * @param {() => void} [invalidate]
	 * @returns {Unsubscriber}
	 */
	function subscribe(run, invalidate = noop) {
		/** @type {SubscribeInvalidateTuple<T>} */
		const subscriber = [run, invalidate];
		subscribers.add(subscriber);
		if (subscribers.size === 1) {
			stop = start(set, update) || noop;
		}
		run(/** @type {T} */ (value));
		return () => {
			subscribers.delete(subscriber);
			if (subscribers.size === 0 && stop) {
				stop();
				stop = null;
			}
		};
	}
	return { set, update, subscribe };
}

/**
 * Get the current value from a store by subscribing and immediately unsubscribing.
 *
 * @template T
 * @param {Readable<T>} store
 * @returns {T}
 */
function get(store) {
	let value;
	subscribe_to_store(store, (_) => (value = _))();
	// @ts-expect-error
	return value;
}

// generated during release, do not modify

const PUBLIC_VERSION = '5';

if (typeof window !== 'undefined') {
	// @ts-expect-error
	((window.__svelte ??= {}).v ??= new Set()).add(PUBLIC_VERSION);
}

ContentFieldOption[FILENAME] = 'src/contenttype/elements/ContentFieldOption.svelte';

var root_2$m = add_locations(from_html(`<span class="badge badge-danger"></span>`), ContentFieldOption[FILENAME], [[37, 8]]);
var root_1$j = add_locations(from_html(`<label> <!></label>`), ContentFieldOption[FILENAME], [[33, 4]]);
var root_3$h = add_locations(from_html(`<small class="form-text text-muted"> </small>`), ContentFieldOption[FILENAME], [[47, 4]]);
var root$4 = add_locations(from_html(`<div><!> <!> <!></div>`), ContentFieldOption[FILENAME], [[25, 0]]);

function ContentFieldOption($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	let attr = prop($$props, 'attr', 3, ""),
		attrShow = prop($$props, 'attrShow', 3, null),
		hint = prop($$props, 'hint', 3, ""),
		label = prop($$props, 'label', 3, ""),
		required = prop($$props, 'required', 3, 0),
		showHint = prop($$props, 'showHint', 3, 0),
		showLabel = prop($$props, 'showLabel', 3, 1);

	if (!$$props.id) {
		console.error("ConetntFieldOption 'id' attribute missing");
	}

	let attrProp = tag(user_derived(() => attr() ? { attr: attr() } : {}), 'attrProp');
	let attrShowProps = tag(state(proxy({})), 'attrShowProps');

	user_effect(() => {
		if (strict_equals(attrShow(), null, false)) {
			if (attrShow()) {
				set(attrShowProps, { style: "" }, true);
			} else {
				set(attrShowProps, { hidden: "", style: "display: none;" }, true);
			}
		}
	});

	var $$exports = { ...legacy_api() };
	var div = root$4();

	attribute_effect(div, () => ({
		id: `${$$props.id ?? ''}-field`,
		class: 'form-group',
		...get$1(attrProp),
		...get$1(attrShowProps),
		[CLASS]: { required: required() }
	}));

	var node = child(div);

	{
		var consequent_1 = ($$anchor) => {
			var label_1 = root_1$j();
			var text = child(label_1);
			var node_1 = sibling(text);

			{
				var consequent = ($$anchor) => {
					var span = root_2$m();

					span.textContent = window.trans("Required");
					append($$anchor, span);
				};

				add_svelte_meta(
					() => if_block(node_1, ($$render) => {
						if (required()) $$render(consequent);
					}),
					'if',
					ContentFieldOption,
					36,
					6
				);
			}

			template_effect(() => {
				set_attribute(label_1, 'for', $$props.id);
				set_text(text, `${label() ?? ''} `);
			});

			append($$anchor, label_1);
		};

		add_svelte_meta(
			() => if_block(node, ($$render) => {
				if (label() && showLabel()) $$render(consequent_1);
			}),
			'if',
			ContentFieldOption,
			32,
			2
		);
	}

	var node_2 = sibling(node, 2);

	slot(node_2, $$props, 'default', {});

	var node_3 = sibling(node_2, 2);

	{
		var consequent_2 = ($$anchor) => {
			var small = root_3$h();
			var text_1 = child(small);

			template_effect(() => {
				set_attribute(small, 'id', `${$$props.id ?? ''}-field-help`);
				set_text(text_1, hint());
			});

			append($$anchor, small);
		};

		add_svelte_meta(
			() => if_block(node_3, ($$render) => {
				if (hint() && showHint()) $$render(consequent_2);
			}),
			'if',
			ContentFieldOption,
			46,
			2
		);
	}
	append($$anchor, div);

	return pop($$exports);
}

function recalcHeight(droppableArea) {
  const contentFields = droppableArea.getElementsByClassName("mt-contentfield");
  let clientHeight = 0;
  for (let i = 0; i < contentFields.length; i++) {
    clientHeight += contentFields[i].offsetHeight;
  }
  if (clientHeight >= droppableArea.clientHeight) {
    jQuery(droppableArea).height(clientHeight + 100);
  } else {
    if (clientHeight >= 400) {
      jQuery(droppableArea).height(clientHeight + 100);
    } else {
      jQuery(droppableArea).height(400 - 8);
    }
  }
}

ContentFieldOptionGroup[FILENAME] = 'src/contenttype/elements/ContentFieldOptionGroup.svelte';

var root_2$l = add_locations(from_html(`<input/>`), ContentFieldOptionGroup[FILENAME], [[66, 2]]);
var root_3$g = add_locations(from_html(`<input/>`), ContentFieldOptionGroup[FILENAME], [[84, 2]]);
var root_4$e = add_locations(from_html(`<input/> <label></label>`, 1), ContentFieldOptionGroup[FILENAME], [[100, 2], [108, 2]]);
var root_5$c = add_locations(from_html(`<select><option></option><option></option><option></option><option></option></select>`), ContentFieldOptionGroup[FILENAME], [[123, 2, [[130, 4], [131, 4], [132, 4], [133, 4]]]]);
var root_1$i = add_locations(from_html(`<input/> <!> <!> <!> <!> <!> <div class="form-group-button"><button type="button" class="btn btn-default"></button></div>`, 1), ContentFieldOptionGroup[FILENAME], [[51, 0], [139, 0, [[140, 2]]]]);

function ContentFieldOptionGroup($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);

	// copied from lib/MT/Template/ContextHandlers.pm
	let field = prop($$props, 'field', 15),
		options = prop($$props, 'options', 15);

	if (!$$props.type) {
		console.error('ContentFieldOptionGroup: "type" attribute is required.');
	}

	user_effect(() => {
		if (!options().display) {
			$$ownership_validator.mutation('options', ['options', 'display'], options(options().display = "default", true), 10, 8);
		}
	});

	user_effect(() => {
		const root = getRoot();

		if (!root) {
			return;
		}

		const elms = root.querySelectorAll("*");

		Array.prototype.slice.call(elms).forEach(function (v) {
			if (v.hasAttribute("id") && !v.classList.contains("mt-custom-contentfield")) {
				v.setAttribute("id", v.getAttribute("id") + "-" + $$props.id);
			}

			if (strict_equals(v.tagName.toLowerCase(), "label") && v.hasAttribute("for")) {
				v.setAttribute("for", v.getAttribute("for") + "-" + $$props.id);
			}
		});
	});

	// inputLabel was removed because unused
	// gatheringData was moved to ContentFields.svelte
	const closePanel = () => {
		const root = getRoot();

		if (!root) {
			return;
		}

		let className = root.className;

		root.className = className.replace(/\s*show\s*/, "");

		const target = document.getElementsByClassName("mt-draggable__area")[0];

		recalcHeight(target);
		jQuery("a[aria-controls='field-options-" + field().id + "']").attr("aria-expanded", "false");
	};

	// changeStateRequired was removed bacause unused
	// $script was removed, and script is written in content field svelte file
	// added in Svelte
	const getRoot = () => {
		return document.querySelector("#field-options-" + field().id);
	};

	var $$exports = { ...legacy_api() };
	var fragment = root_1$i();
	var input = first_child(fragment);

	attribute_effect(
		input,
		() => ({
			type: 'hidden',
			...{ ref: "id" },
			name: 'id',
			id: `${$$props.type ?? ''}-id`,
			class: 'form-control',
			value: field().isNew ? `id:${field().id}` : field().id
		}),
		void 0,
		void 0,
		void 0,
		void 0,
		true
	);

	var node = sibling(input, 2);

	add_svelte_meta(
		() => ContentFieldOption(node, {
			get id() {
				return `${$$props.type ?? ''}-label`;
			},

			label: window.trans("Label"),
			required: 1,

			children: wrap_snippet(ContentFieldOptionGroup, ($$anchor, $$slotProps) => {
				var input_1 = root_2$l();

				attribute_effect(
					input_1,
					() => ({
						type: 'text',
						...{ ref: "label" },
						name: 'label',
						id: `${$$props.type ?? ''}-label`,
						class: 'form-control html5-form',
						required: true,
						'data-mt-content-field-unique': true
					}),
					void 0,
					void 0,
					void 0,
					void 0,
					true
				);

				validate_binding('bind:value={field.label}', [], field, () => 'label', 72, 4);

				bind_value(
					input_1,
					function get() {
						return field().label;
					},
					function set($$value) {
						$$ownership_validator.mutation('field', ['field', 'label'], field(field().label = $$value, true), 72, 16);
					}
				);

				append($$anchor, input_1);
			}),

			$$slots: { default: true }
		}),
		'component',
		ContentFieldOptionGroup,
		60,
		0,
		{ componentTag: 'ContentFieldOption' }
	);

	var node_1 = sibling(node, 2);

	add_svelte_meta(
		() => ContentFieldOption(node_1, {
			get id() {
				return `${$$props.type ?? ''}-description`;
			},

			label: window.trans("Description"),
			showHint: 1,
			hint: window.trans("The entered message is displayed as a input field hint."),

			children: wrap_snippet(ContentFieldOptionGroup, ($$anchor, $$slotProps) => {
				var input_2 = root_3$g();

				attribute_effect(
					input_2,
					() => ({
						type: 'text',
						...{ ref: "description" },
						name: 'description',
						id: `${$$props.type ?? ''}-description`,
						class: 'form-control',
						'aria-describedby': `${$$props.type ?? ''}-description-field-help`
					}),
					void 0,
					void 0,
					void 0,
					void 0,
					true
				);

				validate_binding('bind:value={options.description}', [], options, () => 'description', 91, 4);

				bind_value(
					input_2,
					function get() {
						return options().description;
					},
					function set($$value) {
						$$ownership_validator.mutation('options', ['options', 'description'], options(options().description = $$value, true), 91, 16);
					}
				);

				append($$anchor, input_2);
			}),

			$$slots: { default: true }
		}),
		'component',
		ContentFieldOptionGroup,
		78,
		0,
		{ componentTag: 'ContentFieldOption' }
	);

	var node_2 = sibling(node_1, 2);

	add_svelte_meta(
		() => ContentFieldOption(node_2, {
			get id() {
				return `${$$props.type ?? ''}-required`;
			},

			label: window.trans("Is this field required?"),

			children: wrap_snippet(ContentFieldOptionGroup, ($$anchor, $$slotProps) => {
				var fragment_1 = root_4$e();
				var input_3 = first_child(fragment_1);

				attribute_effect(
					input_3,
					() => ({
						...{ ref: "required" },
						type: 'checkbox',
						class: 'mt-switch form-control',
						id: `${$$props.type ?? ''}-required`,
						name: 'required'
					}),
					void 0,
					void 0,
					void 0,
					void 0,
					true
				);

				validate_binding('bind:checked={options.required}', [], options, () => 'required', 106, 4);

				var label = sibling(input_3, 2);

				label.textContent = window.trans("Is this field required?");
				template_effect(() => set_attribute(label, 'for', `${$$props.type ?? ''}-required`));

				bind_checked(
					input_3,
					function get() {
						return options().required;
					},
					function set($$value) {
						$$ownership_validator.mutation('options', ['options', 'required'], options(options().required = $$value, true), 106, 18);
					}
				);

				append($$anchor, fragment_1);
			}),

			$$slots: { default: true }
		}),
		'component',
		ContentFieldOptionGroup,
		95,
		0,
		{ componentTag: 'ContentFieldOption' }
	);

	var node_3 = sibling(node_2, 2);

	add_svelte_meta(
		() => ContentFieldOption(node_3, {
			get id() {
				return `${$$props.type ?? ''}-display`;
			},

			label: window.trans("Display Options"),
			required: 1,
			showHint: 1,
			hint: window.trans("Choose the display options for this content field in the listing screen."),

			children: wrap_snippet(ContentFieldOptionGroup, ($$anchor, $$slotProps) => {
				var select = root_5$c();

				attribute_effect(select, () => ({
					...{ ref: "display" },
					name: 'display',
					id: `${$$props.type ?? ''}-display`,
					class: 'custom-select form-control form-select'
				}));

				var option = child(select);

				option.textContent = window.trans("Force");
				option.value = option.__value = 'force';

				var option_1 = sibling(option);

				option_1.textContent = window.trans("Default");
				option_1.value = option_1.__value = 'default';

				var option_2 = sibling(option_1);

				option_2.textContent = window.trans("Optional");
				option_2.value = option_2.__value = 'optional';

				var option_3 = sibling(option_2);

				option_3.textContent = window.trans("None");
				option_3.value = option_3.__value = 'none';
				reset(select);
				validate_binding('bind:value={options.display}', [], options, () => 'display', 128, 4);

				bind_select_value(
					select,
					function get() {
						return options().display;
					},
					function set($$value) {
						$$ownership_validator.mutation('options', ['options', 'display'], options(options().display = $$value, true), 128, 16);
					}
				);

				append($$anchor, select);
			}),

			$$slots: { default: true }
		}),
		'component',
		ContentFieldOptionGroup,
		113,
		0,
		{ componentTag: 'ContentFieldOption' }
	);

	var node_4 = sibling(node_3, 2);

	slot(node_4, $$props, 'default', {});

	var div = sibling(node_4, 2);
	var button = child(div);

	button.__click = closePanel;
	button.textContent = window.trans("Close");
	append($$anchor, fragment);

	return pop($$exports);
}

delegate(['click']);

enable_legacy_mode_flag();

StatusMsgTmpl[FILENAME] = 'src/contenttype/elements/StatusMsgTmpl.svelte';

var root_1$h = add_locations(from_html(`<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>`), StatusMsgTmpl[FILENAME], [[39, 4, [[45, 6]]]]);
var root$3 = add_locations(from_html(`<div><!> <!> <!></div>`), StatusMsgTmpl[FILENAME], [[37, 0]]);

function StatusMsgTmpl($$anchor, $$props) {
	check_target(new.target);
	push($$props, false);

	// copied from mtapp_statusmsg.tmpl
	let blogId = prop($$props, 'blogId', 8, "");

	let canClose = prop($$props, 'canClose', 8);
	let canRebuild = prop($$props, 'canRebuild', 8);
	let className = prop($$props, 'class', 8);
	let didReplace = prop($$props, 'didReplace', 8);
	let dynamicAll = prop($$props, 'dynamicAll', 8);
	let hidden = prop($$props, 'hidden', 8);
	let id = prop($$props, 'id', 8);
	let noLink = prop($$props, 'noLink', 8);
	let rebuild = prop($$props, 'rebuild', 8);
	let divProps = mutable_source({});

	legacy_pre_effect(
		() => (
			deep_read_state(id()),
			deep_read_state(className()),
			deep_read_state(canClose()),
			deep_read_state(hidden())
		),
		() => {
			set(divProps, {});

			if (id()) {
				mutate(divProps, get$1(divProps)["id"] = id());
			}

			if (className()) {
				mutate(divProps, get$1(divProps)["class"] = "alert alert-" + className());
			} else {
				mutate(divProps, get$1(divProps)["class"] = "alert alert-info");
			}

			if (canClose()) {
				mutate(divProps, get$1(divProps)["alert-dismissible"] = "");
			}

			if (hidden()) {
				mutate(divProps, get$1(divProps)["style"] = "display: none;");
			}

			if (className().match(/\bwarning|\bdanger/)) {
				mutate(divProps, get$1(divProps)["role"] = "alert");
			}
		}
	);

	legacy_pre_effect_reset();

	var $$exports = { ...legacy_api() };

	init();

	var div = root$3();

	attribute_effect(div, () => ({ ...get$1(divProps) }));

	var node = child(div);

	{
		var consequent = ($$anchor) => {
			var button = root_1$h();

			append($$anchor, button);
		};

		add_svelte_meta(
			() => if_block(node, ($$render) => {
				if (canClose()) $$render(consequent);
			}),
			'if',
			StatusMsgTmpl,
			38,
			2
		);
	}

	var node_1 = sibling(node, 2);

	slot(node_1, $$props, 'msg', {});

	var node_2 = sibling(node_1, 2);

	{
		var consequent_2 = ($$anchor) => {
			var fragment = comment();
			var node_3 = first_child(fragment);

			{
				var consequent_1 = ($$anchor) => {
					var fragment_1 = comment();
					var node_4 = first_child(fragment_1);

					html(node_4, () => (
						deep_read_state(blogId()),
						deep_read_state(rebuild()),
						untrack(() => window.trans("[_1]Publish[_2] your [_3] to see these changes take effect.", `<a href="${window.CMSScriptURI}?__mode=rebuild_confirm&blog_id=${blogId()}&prompt=index" class="mt-rebuild alert-link">`, "</a>", strict_equals(rebuild(), "blog") ? window.trans("blog(s)") : window.trans("website(s)")))
					));

					append($$anchor, fragment_1);
				};

				add_svelte_meta(
					() => if_block(node_3, ($$render) => {
						if (!noLink()) $$render(consequent_1);
					}),
					'if',
					StatusMsgTmpl,
					52,
					4
				);
			}

			append($$anchor, fragment);
		};

		var alternate_3 = ($$anchor) => {
			var fragment_2 = comment();
			var node_5 = first_child(fragment_2);

			{
				var consequent_8 = ($$anchor) => {
					var fragment_3 = comment();
					var node_6 = first_child(fragment_3);

					{
						var consequent_3 = ($$anchor) => {
							var fragment_4 = comment();
							var node_7 = first_child(fragment_4);

							html(node_7, () => (
								deep_read_state(blogId()),
								untrack(() => window.trans("[_1]Publish[_2] your site to see these changes take effect, even when publishing profile is dynamic publishing.", `<a href="${window.CMSScriptURI}?__mode=rebuild_confirm&blog_id=${blogId()}" class="mt-rebuild alert-link">`, "</a>"))
							));

							append($$anchor, fragment_4);
						};

						var alternate_2 = ($$anchor) => {
							var fragment_5 = comment();
							var node_8 = first_child(fragment_5);

							{
								var consequent_5 = ($$anchor) => {
									var fragment_6 = comment();
									var node_9 = first_child(fragment_6);

									{
										var consequent_4 = ($$anchor) => {
											var fragment_7 = comment();
											var node_10 = first_child(fragment_7);

											html(node_10, () => (
												deep_read_state(blogId()),
												untrack(() => window.trans("[_1]Publish[_2] your site to see these changes take effect.", `<a href="${window.CMSScriptURI}?__mode=rebuild_confirm&blog_id=${blogId()}" class="mt-rebuild alert-link">`, "</a>"))
											));

											append($$anchor, fragment_7);
										};

										add_svelte_meta(
											() => if_block(node_9, ($$render) => {
												if (!dynamicAll()) $$render(consequent_4);
											}),
											'if',
											StatusMsgTmpl,
											70,
											6
										);
									}

									append($$anchor, fragment_6);
								};

								var alternate_1 = ($$anchor) => {
									var fragment_8 = comment();
									var node_11 = first_child(fragment_8);

									{
										var consequent_7 = ($$anchor) => {
											var fragment_9 = comment();
											var node_12 = first_child(fragment_9);

											{
												var consequent_6 = ($$anchor) => {
													var fragment_10 = comment();
													var node_13 = first_child(fragment_10);

													html(node_13, () => (
														deep_read_state(blogId()),
														untrack(() => window.trans("[_1]Publish[_2] your site to see these changes take effect.", `<a href="${window.CMSScriptURI}?__mode=rebuild_confirm&blog_id=${blogId()}&prompt=index" class="mt-rebuild alert-link">`, "</a>"))
													));

													append($$anchor, fragment_10);
												};

												add_svelte_meta(
													() => if_block(node_12, ($$render) => {
														if (!dynamicAll()) $$render(consequent_6);
													}),
													'if',
													StatusMsgTmpl,
													78,
													6
												);
											}

											append($$anchor, fragment_9);
										};

										var alternate = ($$anchor) => {
											var fragment_11 = comment();
											var node_14 = first_child(fragment_11);

											html(node_14, rebuild);
											append($$anchor, fragment_11);
										};

										add_svelte_meta(
											() => if_block(
												node_11,
												($$render) => {
													if (strict_equals(rebuild(), "index")) $$render(consequent_7); else $$render(alternate, false);
												},
												true
											),
											'if',
											StatusMsgTmpl,
											77,
											4
										);
									}

									append($$anchor, fragment_8);
								};

								add_svelte_meta(
									() => if_block(
										node_8,
										($$render) => {
											if (strict_equals(rebuild(), "all")) $$render(consequent_5); else $$render(alternate_1, false);
										},
										true
									),
									'if',
									StatusMsgTmpl,
									69,
									4
								);
							}

							append($$anchor, fragment_5);
						};

						add_svelte_meta(
							() => if_block(node_6, ($$render) => {
								if (strict_equals(rebuild(), "cfg_prefs")) $$render(consequent_3); else $$render(alternate_2, false);
							}),
							'if',
							StatusMsgTmpl,
							63,
							4
						);
					}

					append($$anchor, fragment_3);
				};

				add_svelte_meta(
					() => if_block(
						node_5,
						($$render) => {
							if (canRebuild()) $$render(consequent_8);
						},
						true
					),
					'if',
					StatusMsgTmpl,
					62,
					2
				);
			}

			append($$anchor, fragment_2);
		};

		add_svelte_meta(
			() => if_block(node_2, ($$render) => {
				if (didReplace()) $$render(consequent_2); else $$render(alternate_3, false);
			}),
			'if',
			StatusMsgTmpl,
			51,
			2
		);
	}
	append($$anchor, div);

	return pop($$exports);
}

StatusMsg[FILENAME] = 'src/contenttype/elements/StatusMsg.svelte';

function StatusMsg($$anchor, $$props) {
	check_target(new.target);
	push($$props, false);

	// copied from lib/MT/Template/ContextHandlers.pm
	let blogId = prop($$props, 'blogId', 8, "");

	let canClose = prop($$props, 'canClose', 12);
	let className = prop($$props, 'class', 12, "info");
	let id = prop($$props, 'id', 8, "");
	let hidden = prop($$props, 'hidden', 8, "");
	let noLink = prop($$props, 'noLink', 8, "");
	let rebuild = prop($$props, 'rebuild', 8, "");

	legacy_pre_effect(() => (deep_read_state(className())), () => {
		if (!className()) {
			className("info");
		}

		className(className().replace(/\balert\b/, "warning"));
		className(className().replace(/\berror\b/, "danger"));
	});

	legacy_pre_effect(() => (deep_read_state(id()), deep_read_state(canClose())), () => {
		if (id() && (canClose() || strict_equals(canClose(), null))) {
			canClose(1);
		}
	});

	legacy_pre_effect_reset();

	var $$exports = { ...legacy_api() };

	init();

	{
		let $0 = derived_safe_equal(() => hidden() ?? "");
		let $1 = derived_safe_equal(() => noLink() ?? "");

		add_svelte_meta(
			() => StatusMsgTmpl($$anchor, {
				get blogId() {
					return blogId();
				},

				get canClose() {
					return canClose();
				},

				canRebuild: 0,

				get class() {
					return className();
				},

				didReplace: 0,
				dynamicAll: 0,

				get hidden() {
					return get$1($0);
				},

				get id() {
					return id();
				},

				get noLink() {
					return get$1($1);
				},

				get rebuild() {
					return rebuild();
				},

				$$slots: {
					msg: ($$anchor, $$slotProps) => {
						var fragment_1 = comment();
						var node = first_child(fragment_1);

						slot(node, $$props, 'msg', {}, null);
						append($$anchor, fragment_1);
					}
				}
			}),
			'component',
			StatusMsg,
			25,
			0,
			{ componentTag: 'StatusMsgTmpl' }
		);
	}

	return pop($$exports);
}

ContentType[FILENAME] = 'src/contenttype/elements/ContentType.svelte';

var root_2$k = add_locations(from_html(`<input/><label for="content_type-multiple" class="form-label"></label>`, 1), ContentType[FILENAME], [[24, 4], [31, 6]]);
var root_3$f = add_locations(from_html(`<input/>`), ContentType[FILENAME], [[41, 4]]);
var root_4$d = add_locations(from_html(`<input/>`), ContentType[FILENAME], [[57, 4]]);
var root_7$2 = add_locations(from_html(`<option> </option>`), ContentType[FILENAME], [[83, 10]]);
var root_6$4 = add_locations(from_html(`<select></select>`), ContentType[FILENAME], [[75, 6]]);
var root_1$g = add_locations(from_html(`<!> <!> <!> <!>`, 1), ContentType[FILENAME], []);

function ContentType($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;
	var _b;

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	const contentTypes = $$props.optionsHtmlParams.content_type.content_types;

	if (strict_equals(options().multiple, "0")) {
		$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = 0, true), 8, 4);
	}

	if (strict_equals(options().can_add, "0")) {
		$$ownership_validator.mutation('options', ['options', 'can_add'], options(options().can_add = 0, true), 11, 4);
	}

	// changeStateMultiple was removed because unused
	strict_equals(_a = options().min, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'min'], options(options().min = "", true), 14, 53);

	strict_equals(_b = options().max, null, false) && strict_equals(_b, void 0, false)
		? _b
		: $$ownership_validator.mutation('options', ['options', 'max'], options(options().max = "", true), 15, 53);

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'content-type',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(ContentType, ($$anchor, $$slotProps) => {
					var fragment_1 = root_1$g();
					var node = first_child(fragment_1);

					add_svelte_meta(
						() => ContentFieldOption(node, {
							id: 'content_type-multiple',
							label: window.trans("Allow users to select multiple values?"),

							children: wrap_snippet(ContentType, ($$anchor, $$slotProps) => {
								var fragment_2 = root_2$k();
								var input = first_child(fragment_2);

								attribute_effect(
									input,
									() => ({
										...{ ref: "multiple" },
										type: 'checkbox',
										class: 'mt-switch form-control',
										id: 'content_type-multiple',
										name: 'multiple'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:checked={options.multiple}', [], options, () => 'multiple', 30, 6);

								var label = sibling(input);

								label.textContent = window.trans("Allow users to select multiple values?");

								bind_checked(
									input,
									function get() {
										return options().multiple;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = $$value, true), 30, 20);
									}
								);

								append($$anchor, fragment_2);
							}),

							$$slots: { default: true }
						}),
						'component',
						ContentType,
						19,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_1 = sibling(node, 2);

					{
						let $0 = user_derived(() => options().multiple ? true : false);

						add_svelte_meta(
							() => ContentFieldOption(node_1, {
								id: 'content_type-min',
								label: window.trans("Minimum number of selections"),

								get attrShow() {
									return get$1($0);
								},

								children: wrap_snippet(ContentType, ($$anchor, $$slotProps) => {
									var input_1 = root_3$f();

									attribute_effect(
										input_1,
										() => ({
											...{ ref: "min" },
											type: 'number',
											name: 'min',
											id: 'content_type-min',
											class: 'form-control w-25',
											min: '0'
										}),
										void 0,
										void 0,
										void 0,
										void 0,
										true
									);

									validate_binding('bind:value={options.min}', [], options, () => 'min', 48, 6);

									bind_value(
										input_1,
										function get() {
											return options().min;
										},
										function set($$value) {
											$$ownership_validator.mutation('options', ['options', 'min'], options(options().min = $$value, true), 48, 18);
										}
									);

									append($$anchor, input_1);
								}),

								$$slots: { default: true }
							}),
							'component',
							ContentType,
							36,
							2,
							{ componentTag: 'ContentFieldOption' }
						);
					}

					var node_2 = sibling(node_1, 2);

					{
						let $0 = user_derived(() => options().multiple ? true : false);

						add_svelte_meta(
							() => ContentFieldOption(node_2, {
								id: 'content_type-max',
								label: window.trans("Maximum number of selections"),

								get attrShow() {
									return get$1($0);
								},

								children: wrap_snippet(ContentType, ($$anchor, $$slotProps) => {
									var input_2 = root_4$d();

									attribute_effect(
										input_2,
										() => ({
											...{ ref: "max" },
											type: 'number',
											name: 'max',
											id: 'content_type-max',
											class: 'form-control w-25',
											min: '1'
										}),
										void 0,
										void 0,
										void 0,
										void 0,
										true
									);

									validate_binding('bind:value={options.max}', [], options, () => 'max', 64, 6);

									bind_value(
										input_2,
										function get() {
											return options().max;
										},
										function set($$value) {
											$$ownership_validator.mutation('options', ['options', 'max'], options(options().max = $$value, true), 64, 18);
										}
									);

									append($$anchor, input_2);
								}),

								$$slots: { default: true }
							}),
							'component',
							ContentType,
							52,
							2,
							{ componentTag: 'ContentFieldOption' }
						);
					}

					var node_3 = sibling(node_2, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_3, {
							id: 'content_type-source',
							required: 1,
							label: window.trans("Source Content Type"),

							children: wrap_snippet(ContentType, ($$anchor, $$slotProps) => {
								var fragment_3 = comment();
								var node_4 = first_child(fragment_3);

								{
									var consequent = ($$anchor) => {
										var select = root_6$4();

										attribute_effect(select, () => ({
											...{ ref: "source" },
											name: 'source',
											id: 'content_type-source',
											class: 'custom-select form-control html5-form form-select'
										}));

										add_svelte_meta(
											() => each(select, 21, () => contentTypes, index, ($$anchor, ct) => {
												var option = root_7$2();
												var text = child(option, true);

												reset(option);

												var option_value = {};

												template_effect(() => {
													set_text(text, get$1(ct).name);

													if (option_value !== (option_value = get$1(ct).id)) {
														option.value = (option.__value = get$1(ct).id) ?? '';
													}
												});

												append($$anchor, option);
											}),
											'each',
											ContentType,
											82,
											8
										);

										reset(select);
										validate_binding('bind:value={options.source}', [], options, () => 'source', 80, 8);

										bind_select_value(
											select,
											function get() {
												return options().source;
											},
											function set($$value) {
												$$ownership_validator.mutation('options', ['options', 'source'], options(options().source = $$value, true), 80, 20);
											}
										);

										append($$anchor, select);
									};

									var alternate = ($$anchor) => {
										add_svelte_meta(
											() => StatusMsg($$anchor, {
												id: 'no-content-type',
												class: 'warning',
												canClose: 0,

												$$slots: {
													msg: ($$anchor, $$slotProps) => {
														var text_1 = text();

														text_1.nodeValue = window.trans("There is no content type that can be selected. Please create a content type if you use the Content Type field type.");
														append($$anchor, text_1);
													}
												}
											}),
											'component',
											ContentType,
											89,
											6,
											{ componentTag: 'StatusMsg' }
										);
									};

									add_svelte_meta(
										() => if_block(node_4, ($$render) => {
											if (contentTypes.length > 0) $$render(consequent); else $$render(alternate, false);
										}),
										'if',
										ContentType,
										73,
										4
									);
								}

								append($$anchor, fragment_3);
							}),

							$$slots: { default: true }
						}),
						'component',
						ContentType,
						68,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					append($$anchor, fragment_1);
				}),

				$$slots: { default: true }
			}),
			'component',
			ContentType,
			18,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

SingleLineText[FILENAME] = 'src/contenttype/elements/SingleLineText.svelte';

var root_2$j = add_locations(from_html(`<input/>`), SingleLineText[FILENAME], [[15, 4]]);
var root_3$e = add_locations(from_html(`<input/>`), SingleLineText[FILENAME], [[30, 4]]);
var root_4$c = add_locations(from_html(`<input/>`), SingleLineText[FILENAME], [[45, 4]]);
var root_1$f = add_locations(from_html(`<!> <!> <!>`, 1), SingleLineText[FILENAME], []);

function SingleLineText($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;
	var _b;
	var _c;

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	strict_equals(_a = options().min_length, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'min_length'], options(options().min_length = 0, true), 5, 60);

	strict_equals(_b = options().max_length, null, false) && strict_equals(_b, void 0, false)
		? _b
		: $$ownership_validator.mutation('options', ['options', 'max_length'], options(options().max_length = 255, true), 6, 60);

	strict_equals(_c = options().initial_value, null, false) && strict_equals(_c, void 0, false)
		? _c
		: $$ownership_validator.mutation('options', ['options', 'initial_value'], options(options().initial_value = "", true), 7, 63);

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'single-line-text',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(SingleLineText, ($$anchor, $$slotProps) => {
					var fragment_1 = root_1$f();
					var node = first_child(fragment_1);

					add_svelte_meta(
						() => ContentFieldOption(node, {
							id: 'single_line_text-min_length',
							label: window.trans("Min Length"),

							children: wrap_snippet(SingleLineText, ($$anchor, $$slotProps) => {
								var input = root_2$j();

								attribute_effect(
									input,
									() => ({
										...{ ref: "min_length" },
										type: 'number',
										name: 'min_length',
										id: 'single_line_text-min_length',
										class: 'form-control w-25',
										min: '0'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.min_length}', [], options, () => 'min_length', 22, 6);

								bind_value(
									input,
									function get() {
										return options().min_length;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'min_length'], options(options().min_length = $$value, true), 22, 18);
									}
								);

								append($$anchor, input);
							}),

							$$slots: { default: true }
						}),
						'component',
						SingleLineText,
						11,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_1 = sibling(node, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_1, {
							id: 'single_line_text-max_length',
							label: window.trans("Max Length"),

							children: wrap_snippet(SingleLineText, ($$anchor, $$slotProps) => {
								var input_1 = root_3$e();

								attribute_effect(
									input_1,
									() => ({
										...{ ref: "max_length" },
										type: 'number',
										name: 'max_length',
										id: 'single_line_text-max_length',
										class: 'form-control w-25',
										min: '1'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.max_length}', [], options, () => 'max_length', 37, 6);

								bind_value(
									input_1,
									function get() {
										return options().max_length;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'max_length'], options(options().max_length = $$value, true), 37, 18);
									}
								);

								append($$anchor, input_1);
							}),

							$$slots: { default: true }
						}),
						'component',
						SingleLineText,
						26,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_2 = sibling(node_1, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_2, {
							id: 'single_line_text-initial_value',
							label: window.trans("Initial Value"),

							children: wrap_snippet(SingleLineText, ($$anchor, $$slotProps) => {
								var input_2 = root_4$c();

								attribute_effect(
									input_2,
									() => ({
										...{ ref: "initial_value" },
										type: 'text',
										name: 'initial_value',
										id: 'single_line_text-initial_value',
										class: 'form-control'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.initial_value}', [], options, () => 'initial_value', 51, 6);

								bind_value(
									input_2,
									function get() {
										return options().initial_value;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'initial_value'], options(options().initial_value = $$value, true), 51, 18);
									}
								);

								append($$anchor, input_2);
							}),

							$$slots: { default: true }
						}),
						'component',
						SingleLineText,
						41,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					append($$anchor, fragment_1);
				}),

				$$slots: { default: true }
			}),
			'component',
			SingleLineText,
			10,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

MultiLineText[FILENAME] = 'src/contenttype/elements/MultiLineText.svelte';

var root_2$i = add_locations(from_html(`<textarea></textarea>`), MultiLineText[FILENAME], [[21, 4]]);
var root_4$b = add_locations(from_html(`<option> </option>`), MultiLineText[FILENAME], [[43, 8]]);
var root_3$d = add_locations(from_html(`<select></select>`), MultiLineText[FILENAME], [[35, 4]]);
var root_5$b = add_locations(from_html(`<input/><label for="multi_line_text-full_rich_text" class="form-label"></label>`, 1), MultiLineText[FILENAME], [[53, 4], [60, 6]]);
var root_1$e = add_locations(from_html(`<!> <!> <!>`, 1), MultiLineText[FILENAME], []);

function MultiLineText($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	const textFilters = $$props.optionsHtmlParams.multi_line_text.text_filters;

	if (field().isNew) {
		$$ownership_validator.mutation('options', ['options', 'full_rich_text'], options(options().full_rich_text = 1, true), 7, 4);
	}

	if (strict_equals(options().full_rich_text, "0")) {
		$$ownership_validator.mutation('options', ['options', 'full_rich_text'], options(options().full_rich_text = 0, true), 10, 4);
	}

	// changeStateFullRichText was removed because unused
	strict_equals(_a = options().initial_value, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'initial_value'], options(options().initial_value = "", true), 13, 63);

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'multi-line-text',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(MultiLineText, ($$anchor, $$slotProps) => {
					var fragment_1 = root_1$e();
					var node = first_child(fragment_1);

					add_svelte_meta(
						() => ContentFieldOption(node, {
							id: 'multi_line_text-initial_value',
							label: window.trans("Initial Value"),

							children: wrap_snippet(MultiLineText, ($$anchor, $$slotProps) => {
								var textarea = root_2$i();

								remove_textarea_child(textarea);

								attribute_effect(textarea, () => ({
									...{ ref: "initial_value" },
									name: 'initial_value',
									id: 'multi_line_text-initial_value',
									class: 'form-control'
								}));

								validate_binding('bind:value={options.initial_value}', [], options, () => 'initial_value', 26, 6);

								bind_value(
									textarea,
									function get() {
										return options().initial_value;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'initial_value'], options(options().initial_value = $$value, true), 26, 18);
									}
								);

								append($$anchor, textarea);
							}),

							$$slots: { default: true }
						}),
						'component',
						MultiLineText,
						17,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_1 = sibling(node, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_1, {
							id: 'multi_line_text-input_format',
							label: window.trans("Input format"),

							children: wrap_snippet(MultiLineText, ($$anchor, $$slotProps) => {
								var select = root_3$d();

								attribute_effect(select, () => ({
									...{ ref: "input_format" },
									name: 'input_format',
									id: 'multi_line_text-input_format',
									class: 'custom-select form-control form-select'
								}));

								add_svelte_meta(
									() => each(select, 21, () => textFilters, index, ($$anchor, filter) => {
										var option = root_4$b();
										var text = child(option, true);

										reset(option);

										var option_value = {};

										template_effect(() => {
											set_text(text, get$1(filter).filter_label);

											if (option_value !== (option_value = get$1(filter).filter_key)) {
												option.value = (option.__value = get$1(filter).filter_key) ?? '';
											}
										});

										append($$anchor, option);
									}),
									'each',
									MultiLineText,
									42,
									6
								);

								reset(select);
								validate_binding('bind:value={options.input_format}', [], options, () => 'input_format', 40, 6);

								bind_select_value(
									select,
									function get() {
										return options().input_format;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'input_format'], options(options().input_format = $$value, true), 40, 18);
									}
								);

								append($$anchor, select);
							}),

							$$slots: { default: true }
						}),
						'component',
						MultiLineText,
						30,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_2 = sibling(node_1, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_2, {
							id: 'multi_line_text-full_rich_text',
							label: window.trans("Use all rich text decoration buttons"),

							children: wrap_snippet(MultiLineText, ($$anchor, $$slotProps) => {
								var fragment_2 = root_5$b();
								var input = first_child(fragment_2);

								attribute_effect(
									input,
									() => ({
										...{ ref: "full_rich_text" },
										type: 'checkbox',
										class: 'mt-switch form-control',
										id: 'multi_line_text-full_rich_text',
										name: 'full_rich_text'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:checked={options.full_rich_text}', [], options, () => 'full_rich_text', 59, 6);

								var label = sibling(input);

								label.textContent = window.trans("Use all rich text decoration buttons");

								bind_checked(
									input,
									function get() {
										return options().full_rich_text;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'full_rich_text'], options(options().full_rich_text = $$value, true), 59, 20);
									}
								);

								append($$anchor, fragment_2);
							}),

							$$slots: { default: true }
						}),
						'component',
						MultiLineText,
						48,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					append($$anchor, fragment_1);
				}),

				$$slots: { default: true }
			}),
			'component',
			MultiLineText,
			16,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

Number$1[FILENAME] = 'src/contenttype/elements/Number.svelte';

var root_2$h = add_locations(from_html(`<input/>`), Number$1[FILENAME], [[29, 4]]);
var root_3$c = add_locations(from_html(`<input/>`), Number$1[FILENAME], [[42, 4]]);
var root_4$a = add_locations(from_html(`<input/>`), Number$1[FILENAME], [[58, 4]]);
var root_5$a = add_locations(from_html(`<input/>`), Number$1[FILENAME], [[74, 4]]);
var root_1$d = add_locations(from_html(`<!> <!> <!> <!>`, 1), Number$1[FILENAME], []);

function Number$1($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;
	var _b;
	var _c;
	var _d;

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	strict_equals(_a = options().max_value, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'max_value'], options(options().max_value = $$props.config.NumberFieldMaxValue, true), 5, 59);

	strict_equals(_b = options().min_value, null, false) && strict_equals(_b, void 0, false)
		? _b
		: $$ownership_validator.mutation('options', ['options', 'min_value'], options(options().min_value = $$props.config.NumberFieldMinValue, true), 6, 59);

	strict_equals(_c = options().decimal_places, null, false) && strict_equals(_c, void 0, false)
		? _c
		: $$ownership_validator.mutation('options', ['options', 'decimal_places'], options(options().decimal_places = 0, true), 7, 64);

	strict_equals(_d = options().initial_value, null, false) && strict_equals(_d, void 0, false)
		? _d
		: $$ownership_validator.mutation('options', ['options', 'initial_value'], options(options().initial_value = "", true), 8, 63);

	// jQuery(document).ready(function () {...}) is deprecated
	jQuery(function () {
		const minValueOrMaxValueSelector = "input[id^=number-min_value-field-options-], input[id^=number-max_value-field-options-]";

		jQuery(document).on("keyup", minValueOrMaxValueSelector, function () {
			const matched = this.id.match(/[^-]+$/);

			if (!matched) return;

			const fieldId = matched[0];
			const initialValueId = "#number-initial_value-field-options-" + fieldId;
			const jqInitialValue = jQuery(initialValueId);

			if (!jqInitialValue.data("mtValidator")) return;

			/* @ts-expect-error : mtValid is undefined */
			jqInitialValue.mtValid({ focus: false });
		});
	});

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'number',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(Number$1, ($$anchor, $$slotProps) => {
					var fragment_1 = root_1$d();
					var node = first_child(fragment_1);

					add_svelte_meta(
						() => ContentFieldOption(node, {
							id: 'number-min_value',
							label: window.trans("Min Value"),

							children: wrap_snippet(Number$1, ($$anchor, $$slotProps) => {
								var input = root_2$h();

								attribute_effect(
									input,
									() => ({
										...{ ref: "min_value" },
										type: 'number',
										name: 'min_value',
										id: 'number-min_value',
										class: 'form-control html5-form w-25',
										min: $$props.config.NumberFieldMinValue,
										max: $$props.config.NumberFieldMaxValue
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.min_value}', [], options, () => 'min_value', 35, 6);

								bind_value(
									input,
									function get() {
										return options().min_value;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'min_value'], options(options().min_value = $$value, true), 35, 18);
									}
								);

								append($$anchor, input);
							}),

							$$slots: { default: true }
						}),
						'component',
						Number$1,
						28,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_1 = sibling(node, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_1, {
							id: 'number-max_value',
							label: window.trans("Max Value"),

							children: wrap_snippet(Number$1, ($$anchor, $$slotProps) => {
								var input_1 = root_3$c();

								attribute_effect(
									input_1,
									() => ({
										...{ ref: "max_value" },
										type: 'number',
										name: 'max_value',
										id: 'number-max_value',
										class: 'form-control html5-form w-25',
										min: $$props.config.NumberFieldMinValue,
										max: $$props.config.NumberFieldMaxValue
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.max_value}', [], options, () => 'max_value', 48, 6);

								bind_value(
									input_1,
									function get() {
										return options().max_value;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'max_value'], options(options().max_value = $$value, true), 48, 18);
									}
								);

								append($$anchor, input_1);
							}),

							$$slots: { default: true }
						}),
						'component',
						Number$1,
						41,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_2 = sibling(node_1, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_2, {
							id: 'number-decimal_places',
							label: window.trans("Number of decimal places"),

							children: wrap_snippet(Number$1, ($$anchor, $$slotProps) => {
								var input_2 = root_4$a();

								attribute_effect(
									input_2,
									() => ({
										...{ ref: "decimal_places" },
										type: 'number',
										name: 'decimal_places',
										id: 'number-decimal_places',
										class: 'form-control html5-form w-25',
										min: '0',
										max: $$props.config.NumberFieldDecimalPlaces
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.decimal_places}', [], options, () => 'decimal_places', 66, 6);

								bind_value(
									input_2,
									function get() {
										return options().decimal_places;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'decimal_places'], options(options().decimal_places = $$value, true), 66, 18);
									}
								);

								append($$anchor, input_2);
							}),

							$$slots: { default: true }
						}),
						'component',
						Number$1,
						54,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_3 = sibling(node_2, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_3, {
							id: 'number-initial_value',
							label: window.trans("Initial Value"),

							children: wrap_snippet(Number$1, ($$anchor, $$slotProps) => {
								var input_3 = root_5$a();

								attribute_effect(
									input_3,
									() => ({
										...{ ref: "initial_value" },
										type: 'number',
										name: 'initial_value',
										id: 'number-initial_value',
										class: 'form-control html5-form w-25',
										min: options().min_value,
										max: options().max_value
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.initial_value}', [], options, () => 'initial_value', 80, 6);

								bind_value(
									input_3,
									function get() {
										return options().initial_value;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'initial_value'], options(options().initial_value = $$value, true), 80, 18);
									}
								);

								append($$anchor, input_3);
							}),

							$$slots: { default: true }
						}),
						'component',
						Number$1,
						70,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					append($$anchor, fragment_1);
				}),

				$$slots: { default: true }
			}),
			'component',
			Number$1,
			27,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

Url[FILENAME] = 'src/contenttype/elements/Url.svelte';

var root_2$g = add_locations(from_html(`<input/>`), Url[FILENAME], [[13, 4]]);

function Url($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	strict_equals(_a = options().initial_value, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'initial_value'], options(options().initial_value = "", true), 5, 63);

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'url',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(Url, ($$anchor, $$slotProps) => {
					add_svelte_meta(
						() => ContentFieldOption($$anchor, {
							id: 'url-initial_value',
							label: window.trans("Initial Value"),

							children: wrap_snippet(Url, ($$anchor, $$slotProps) => {
								var input = root_2$g();

								attribute_effect(
									input,
									() => ({
										...{ ref: "initial_value" },
										type: 'text',
										name: 'initial_value',
										id: 'url-initial_value',
										class: 'form-control'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.initial_value}', [], options, () => 'initial_value', 19, 6);

								bind_value(
									input,
									function get() {
										return options().initial_value;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'initial_value'], options(options().initial_value = $$value, true), 19, 18);
									}
								);

								append($$anchor, input);
							}),

							$$slots: { default: true }
						}),
						'component',
						Url,
						9,
						2,
						{ componentTag: 'ContentFieldOption' }
					);
				}),

				$$slots: { default: true }
			}),
			'component',
			Url,
			8,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

DateTime[FILENAME] = 'src/contenttype/elements/DateTime.svelte';

var root_2$f = add_locations(from_html(`<input/>`), DateTime[FILENAME], [[14, 4]]);
var root_3$b = add_locations(from_html(`<input/>`), DateTime[FILENAME], [[29, 4]]);
var root_1$c = add_locations(from_html(`<!> <!>`, 1), DateTime[FILENAME], []);

function DateTime($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;
	var _b;

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	strict_equals(_a = options().initial_date, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'initial_date'], options(options().initial_date = "", true), 5, 62);

	strict_equals(_b = options().initial_time, null, false) && strict_equals(_b, void 0, false)
		? _b
		: $$ownership_validator.mutation('options', ['options', 'initial_time'], options(options().initial_time = "", true), 6, 62);

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'date-and-time',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(DateTime, ($$anchor, $$slotProps) => {
					var fragment_1 = root_1$c();
					var node = first_child(fragment_1);

					add_svelte_meta(
						() => ContentFieldOption(node, {
							id: 'date_and_time-initial-date_value',
							label: window.trans("Initial Value (Date)"),

							children: wrap_snippet(DateTime, ($$anchor, $$slotProps) => {
								var input = root_2$f();

								attribute_effect(
									input,
									() => ({
										...{ ref: "initial_date" },
										type: 'text',
										name: 'initial_date',
										id: 'date_and_time-initial_date',
										class: 'form-control date-field w-25',
										placeholder: 'YYYY-MM-DD'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.initial_date}', [], options, () => 'initial_date', 20, 6);

								bind_value(
									input,
									function get() {
										return options().initial_date;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'initial_date'], options(options().initial_date = $$value, true), 20, 18);
									}
								);

								append($$anchor, input);
							}),

							$$slots: { default: true }
						}),
						'component',
						DateTime,
						10,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_1 = sibling(node, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_1, {
							id: 'date_and_time-initial-timevalue',
							label: window.trans("Initial Value (Time)"),

							children: wrap_snippet(DateTime, ($$anchor, $$slotProps) => {
								var input_1 = root_3$b();

								attribute_effect(
									input_1,
									() => ({
										...{ ref: "initial_time" },
										type: 'text',
										name: 'initial_time',
										id: 'date_and_time-initial_time',
										class: 'form-control time-field w-25',
										placeholder: 'HH:mm:ss'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.initial_time}', [], options, () => 'initial_time', 35, 6);

								bind_value(
									input_1,
									function get() {
										return options().initial_time;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'initial_time'], options(options().initial_time = $$value, true), 35, 18);
									}
								);

								append($$anchor, input_1);
							}),

							$$slots: { default: true }
						}),
						'component',
						DateTime,
						25,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					append($$anchor, fragment_1);
				}),

				$$slots: { default: true }
			}),
			'component',
			DateTime,
			9,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

Date$1[FILENAME] = 'src/contenttype/elements/Date.svelte';

var root_2$e = add_locations(from_html(`<input/>`), Date$1[FILENAME], [[14, 4]]);

function Date$1($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	strict_equals(_a = options().initial_value, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'initial_value'], options(options().initial_value = "", true), 5, 63);

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'date-only',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(Date$1, ($$anchor, $$slotProps) => {
					add_svelte_meta(
						() => ContentFieldOption($$anchor, {
							id: 'date_only-initial-date_value',
							label: window.trans("Initial Value"),

							children: wrap_snippet(Date$1, ($$anchor, $$slotProps) => {
								var input = root_2$e();

								attribute_effect(
									input,
									() => ({
										...{ ref: "initial_value" },
										type: 'text',
										name: 'initial_value',
										id: 'initial_value',
										class: 'form-control date-field w-25',
										placeholder: 'YYYY-MM-DD'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.initial_value}', [], options, () => 'initial_value', 20, 6);

								bind_value(
									input,
									function get() {
										return options().initial_value;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'initial_value'], options(options().initial_value = $$value, true), 20, 18);
									}
								);

								append($$anchor, input);
							}),

							$$slots: { default: true }
						}),
						'component',
						Date$1,
						9,
						2,
						{ componentTag: 'ContentFieldOption' }
					);
				}),

				$$slots: { default: true }
			}),
			'component',
			Date$1,
			8,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

Time[FILENAME] = 'src/contenttype/elements/Time.svelte';

var root_2$d = add_locations(from_html(`<input/>`), Time[FILENAME], [[13, 4]]);

function Time($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	strict_equals(_a = options().initial_value, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'initial_value'], options(options().initial_value = "", true), 5, 63);

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'time-only',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(Time, ($$anchor, $$slotProps) => {
					add_svelte_meta(
						() => ContentFieldOption($$anchor, {
							id: 'time_only-initial-value',
							label: window.trans("Initial Value"),

							children: wrap_snippet(Time, ($$anchor, $$slotProps) => {
								var input = root_2$d();

								attribute_effect(
									input,
									() => ({
										...{ ref: "initial_value" },
										type: 'text',
										name: 'initial_value',
										id: 'time_only-initial-value',
										class: 'form-control time-field w-25',
										placeholder: 'HH:mm:ss'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.initial_value}', [], options, () => 'initial_value', 19, 6);

								bind_value(
									input,
									function get() {
										return options().initial_value;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'initial_value'], options(options().initial_value = $$value, true), 19, 18);
									}
								);

								append($$anchor, input);
							}),

							$$slots: { default: true }
						}),
						'component',
						Time,
						9,
						2,
						{ componentTag: 'ContentFieldOption' }
					);
				}),

				$$slots: { default: true }
			}),
			'component',
			Time,
			8,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

const addRow = (values) => {
  values.push({ checked: "", label: "", value: "" });
  return values;
};
const deleteRow = (values, index) => {
  values.splice(index, 1);
  if (values.length === 0) {
    values = [
      {
        checked: "checked",
        label: "",
        value: ""
      }
    ];
  } else {
    let found = false;
    values.forEach(function(v) {
      if (v.checked === "checked") {
        found = true;
      }
    });
    if (!found) {
      values[0].checked = "checked";
    }
  }
  return values;
};
const validateTable = (table) => {
  const jqTable = jQuery(table);
  const tableIsValidated = jqTable.data("mtValidator") ? true : false;
  if (tableIsValidated) {
    const jqNotValidatedLabelsValues = jqTable.find("input[type=text]:not(.is-invalid)");
    if (jqNotValidatedLabelsValues.length > 0) {
      jqNotValidatedLabelsValues.mtValidate("simple");
    } else {
      jqTable.mtValid({ focus: false });
    }
  }
};

SelectBox[FILENAME] = 'src/contenttype/elements/SelectBox.svelte';

var root_2$c = add_locations(from_html(`<input/><label for="select_box-multiple" class="form-label"></label>`, 1), SelectBox[FILENAME], [[122, 4], [130, 6]]);
var root_3$a = add_locations(from_html(`<input/>`), SelectBox[FILENAME], [[140, 4]]);
var root_4$9 = add_locations(from_html(`<input/>`), SelectBox[FILENAME], [[156, 4]]);

var root_6$3 = add_locations(from_html(`<tr class="text-center align-middle"><td><input type="checkbox" class="form-check-input mt-3"/></td><td><input type="text" class="form-control required" name="label"/></td><td><input type="text" class="form-control required" name="value"/></td><td><button type="button" class="btn btn-default btn-sm"><svg role="img" class="mt-icon mt-icon--sm"><title></title><use></use></svg> </button></td></tr>`), SelectBox[FILENAME], [
	[
		189,
		12,

		[
			[190, 14, [[191, 17]]],
			[200, 14, [[202, 16]]],
			[209, 14, [[211, 16]]],
			[218, 14, [[219, 17, [[225, 19, [[226, 21], [226, 60]]]]]]]
		]
	]
]);

var root_5$9 = add_locations(from_html(`<div class="mt-table--outline mb-3"><table><thead><tr><th scope="col"></th><th scope="col"></th><th scope="col"></th><th scope="col"></th></tr></thead><tbody></tbody></table></div> <button type="button" class="btn btn-default btn-sm"><svg role="img" class="mt-icon mt-icon--sm"><title></title><use></use></svg> </button>`, 1), SelectBox[FILENAME], [
	[
		173,
		4,

		[
			[
				174,
				6,

				[
					[
						179,
						8,
						[[180, 10, [[181, 12], [182, 12], [183, 12], [184, 12]]]]
					],

					[187, 8]
				]
			]
		]
	],

	[237, 4, [[243, 7, [[244, 9], [244, 45]]]]]
]);

var root_1$b = add_locations(from_html(`<!> <!> <!> <!>`, 1), SelectBox[FILENAME], []);

function SelectBox($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;
	var _b;

	let field = prop($$props, 'field', 15),
		gather = prop($$props, 'gather', 15, null),
		options = prop($$props, 'options', 15);

	if (strict_equals(options().can_add, "0")) {
		$$ownership_validator.mutation('options', ['options', 'can_add'], options(options().can_add = 0, true), 7, 4);
	}

	if (strict_equals(options().multiple, "0")) {
		$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = 0, true), 10, 4);
	}

	strict_equals(_a = options().min, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'min'], options(options().min = "", true), 12, 53);

	strict_equals(_b = options().max, null, false) && strict_equals(_b, void 0, false)
		? _b
		: $$ownership_validator.mutation('options', ['options', 'max'], options(options().max = "", true), 13, 53);

	let refsTable;

	// <mt:include name="content_field_type_options/selection_common_script.tmpl">
	// copoied some functions from selection_common_script.tmpl below
	if (!options().values) {
		$$ownership_validator.mutation('options', ['options', 'values'], options(options().values = [{ checked: "", label: "", value: "" }], true), 18, 4);
	}

	user_effect(() => {
		if (refsTable) {
			validateTable(refsTable);
		}
	});

	gather(() => {
		return { values: options().values };
	});

	// copied some functions from selection_common_script.tmpl above
	// <mt:include name="content_field_type_options/selection_common_script.tmpl">
	// deleteRow was moved to SelectionCommonScript.svelte
	const enterInitial = (e, index) => {
		const target = e.target;
		const state = target.checked;
		const block = jQuery(e.target).parents(".mt-contentfield");

		// Clear all check when not to allow multiple selection
		if (!options().multiple || strict_equals(options().multiple, 0) || strict_equals(options().multiple, false)) {
			_clearAllInitial(block);
		}

		// Set current item status
		e.target.checked = state;

		$$ownership_validator.mutation('options', ['options', 'values', index, 'checked'], options(options().values[index].checked = state ? "checked" : "", true), 51, 4);

		if (options().multiple || strict_equals(options().multiple, 1)) {
			_updateInittialField(block);
		}

		// added in Svelte
		refreshView();
	};

	const changeStateMultiple = (e) => {
		const target = e.target;
		const block = jQuery(target).parents(".mt-contentfield");

		$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = target.checked, true), 61, 4);

		if (!options().multiple && block.find(".values-option-table").find('input[type="checkbox"]:checked').length > 1) {
			_clearAllInitial(block);
		}

		refreshView();
	};

	const enterMax = (e) => {
		const block = jQuery(e.target).parents(".mt-contentfield");

		_updateInittialField(block);
	};

	const _updateInittialField = (block) => {
		const max = Number(block.find('input[name="max"]').val());
		const cur = block.find(".values-option-table").find('input[type="checkbox"]:checked').length;

		if (strict_equals(max, 0) || cur < max) {
			const chkbox = block.find(".values-option-table").find('input[type="checkbox"]');

			jQuery.each(chkbox, function (i) {
				jQuery(chkbox[i]).prop("disabled", false);
			});
		} else {
			const chkbox = block.find(".values-option-table").find('input[type="checkbox"]:not(:checked)');

			jQuery.each(chkbox, function (i) {
				jQuery(chkbox[i]).prop("disabled", true);
			});
		}
	};

	const _clearAllInitial = (block) => {
		const initials = block.find(".values-option-table").find('input[type="checkbox"]');

		if (initials.length > 1) {
			jQuery.each(initials, function (v) {
				const elm = jQuery(initials[v]);

				elm.prop("checked", false);
				elm.prop("disabled", false);
			});
		}

		options().values.forEach(function (v) {
			v.checked = "";
		});
	};

	// added in Svelte
	const refreshView = () => {
		// eslint-disable-next-line no-self-assign
		options(options());
	};

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'select-box',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(SelectBox, ($$anchor, $$slotProps) => {
					var fragment_1 = root_1$b();
					var node = first_child(fragment_1);

					add_svelte_meta(
						() => ContentFieldOption(node, {
							id: 'select_box-multiple',
							label: window.trans("Allow users to select multiple values?"),

							children: wrap_snippet(SelectBox, ($$anchor, $$slotProps) => {
								var fragment_2 = root_2$c();
								var input = first_child(fragment_2);

								attribute_effect(
									input,
									() => ({
										...{ ref: "multiple" },
										type: 'checkbox',
										class: 'mt-switch form-control form-check-input',
										id: 'select_box-multiple',
										name: 'multiple',
										onclick: changeStateMultiple
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:checked={options.multiple}', [], options, () => 'multiple', 128, 6);

								var label = sibling(input);

								label.textContent = window.trans("Allow users to select multiple values?");

								bind_checked(
									input,
									function get() {
										return options().multiple;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = $$value, true), 128, 20);
									}
								);

								append($$anchor, fragment_2);
							}),

							$$slots: { default: true }
						}),
						'component',
						SelectBox,
						118,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_1 = sibling(node, 2);

					{
						let $0 = user_derived(() => options().multiple ? true : false);

						add_svelte_meta(
							() => ContentFieldOption(node_1, {
								id: 'select_box-min',
								label: window.trans("Minimum number of selections"),

								get attrShow() {
									return get$1($0);
								},

								children: wrap_snippet(SelectBox, ($$anchor, $$slotProps) => {
									var input_1 = root_3$a();

									attribute_effect(
										input_1,
										() => ({
											...{ ref: "min" },
											type: 'number',
											name: 'min',
											id: 'select_box-min',
											class: 'form-control w-25',
											min: '0'
										}),
										void 0,
										void 0,
										void 0,
										void 0,
										true
									);

									validate_binding('bind:value={options.min}', [], options, () => 'min', 147, 6);

									bind_value(
										input_1,
										function get() {
											return options().min;
										},
										function set($$value) {
											$$ownership_validator.mutation('options', ['options', 'min'], options(options().min = $$value, true), 147, 18);
										}
									);

									append($$anchor, input_1);
								}),

								$$slots: { default: true }
							}),
							'component',
							SelectBox,
							135,
							2,
							{ componentTag: 'ContentFieldOption' }
						);
					}

					var node_2 = sibling(node_1, 2);

					{
						let $0 = user_derived(() => options().multiple ? true : false);

						add_svelte_meta(
							() => ContentFieldOption(node_2, {
								id: 'select_box-max',
								label: window.trans("Maximum number of selections"),

								get attrShow() {
									return get$1($0);
								},

								children: wrap_snippet(SelectBox, ($$anchor, $$slotProps) => {
									var input_2 = root_4$9();

									attribute_effect(
										input_2,
										() => ({
											...{ ref: "max" },
											type: 'number',
											name: 'max',
											id: 'select_box-max',
											class: 'form-control w-25',
											min: '1',
											onchange: enterMax
										}),
										void 0,
										void 0,
										void 0,
										void 0,
										true
									);

									validate_binding('bind:value={options.max}', [], options, () => 'max', 163, 6);

									bind_value(
										input_2,
										function get() {
											return options().max;
										},
										function set($$value) {
											$$ownership_validator.mutation('options', ['options', 'max'], options(options().max = $$value, true), 163, 18);
										}
									);

									append($$anchor, input_2);
								}),

								$$slots: { default: true }
							}),
							'component',
							SelectBox,
							151,
							2,
							{ componentTag: 'ContentFieldOption' }
						);
					}

					var node_3 = sibling(node_2, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_3, {
							id: 'select_box-values',
							required: 1,
							label: window.trans("Values"),

							children: wrap_snippet(SelectBox, ($$anchor, $$slotProps) => {
								var fragment_3 = root_5$9();
								var div = first_child(fragment_3);
								var table = child(div);

								attribute_effect(table, () => ({
									class: 'table mt-table values-option-table',
									...{ ref: "table" }
								}));

								var thead = child(table);
								var tr = child(thead);
								var th = child(tr);

								th.textContent = window.trans("Selected");

								var th_1 = sibling(th);

								th_1.textContent = window.trans("Label");

								var th_2 = sibling(th_1);

								th_2.textContent = window.trans("Value");
								next();
								reset(tr);
								reset(thead);

								var tbody = sibling(thead);

								add_svelte_meta(
									() => each(tbody, 21, () => options().values, index, ($$anchor, v, index) => {
										var tr_1 = root_6$3();
										var td = child(tr_1);
										var input_3 = child(td);

										remove_input_defaults(input_3);

										input_3.__change = (e) => {
											enterInitial(e, index);
										};

										reset(td);

										var td_1 = sibling(td);
										var input_4 = child(td_1);

										remove_input_defaults(input_4);
										validate_binding('bind:value={v.label}', [], () => get$1(v), () => 'label', 206, 18);
										reset(td_1);

										var td_2 = sibling(td_1);
										var input_5 = child(td_2);

										remove_input_defaults(input_5);
										validate_binding('bind:value={v.value}', [], () => get$1(v), () => 'value', 215, 18);
										reset(td_2);

										var td_3 = sibling(td_2);
										var button = child(td_3);

										button.__click = () => {
											$$ownership_validator.mutation('options', ['options', 'values'], options(options().values = deleteRow(options().values, index), true), 221, 20);
										};

										var svg = child(button);
										var title = child(svg);

										title.textContent = window.trans("delete");

										var use = sibling(title);

										set_xlink_attribute(use, 'xlink:href', `${window.StaticURI ?? ''}images/sprite.svg#ic_trash`);
										reset(svg);

										var text = sibling(svg, 1, true);

										text.nodeValue = window.trans("delete");
										reset(button);
										reset(td_3);
										reset(tr_1);
										template_effect(() => set_checked(input_3, get$1(v).checked ? true : false));

										bind_value(
											input_4,
											function get() {
												return get$1(v).label;
											},
											function set($$value) {
												(get$1(v).label = $$value);
											}
										);

										bind_value(
											input_5,
											function get() {
												return get$1(v).value;
											},
											function set($$value) {
												(get$1(v).value = $$value);
											}
										);

										append($$anchor, tr_1);
									}),
									'each',
									SelectBox,
									188,
									10
								);

								reset(tbody);
								reset(table);
								bind_this(table, ($$value) => refsTable = $$value, () => refsTable);
								reset(div);

								var button_1 = sibling(div, 2);

								button_1.__click = () => {
									$$ownership_validator.mutation('options', ['options', 'values'], options(options().values = addRow(options().values), true), 239, 8);
								};

								var svg_1 = child(button_1);
								var title_1 = child(svg_1);

								title_1.textContent = window.trans("add");

								var use_1 = sibling(title_1);

								set_xlink_attribute(use_1, 'xlink:href', `${window.StaticURI ?? ''}images/sprite.svg#ic_add`);
								reset(svg_1);

								var text_1 = sibling(svg_1, 1, true);

								text_1.nodeValue = window.trans("add");
								reset(button_1);
								append($$anchor, fragment_3);
							}),

							$$slots: { default: true }
						}),
						'component',
						SelectBox,
						168,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					append($$anchor, fragment_1);
				}),

				$$slots: { default: true }
			}),
			'component',
			SelectBox,
			117,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

delegate(['change', 'click']);

RadioButton[FILENAME] = 'src/contenttype/elements/RadioButton.svelte';

var root_3$9 = add_locations(from_html(`<tr class="text-center align-middle"><td><input type="radio" class="form-check-input mt-3"/></td><td><input type="text" class="form-control required" name="label"/></td><td><input type="text" class="form-control required" name="value"/></td><td><button type="button" class="btn btn-default btn-sm"><svg role="img" class="mt-icon mt-icon--sm"><title></title><use></use></svg> </button></td></tr>`), RadioButton[FILENAME], [
	[
		72,
		12,

		[
			[73, 14, [[74, 17]]],
			[84, 14, [[86, 16]]],
			[93, 14, [[95, 16]]],
			[102, 14, [[103, 17, [[109, 19, [[110, 21], [110, 60]]]]]]]
		]
	]
]);

var root_2$b = add_locations(from_html(`<div class="mt-table--outline mb-3"><table><thead><tr><th scope="col"></th><th scope="col"></th><th scope="col"></th><th scope="col"></th></tr></thead><tbody></tbody></table></div> <button type="button" class="btn btn-default btn-sm"><svg role="img" class="mt-icon mt-icon--sm"><title></title><use></use></svg> </button>`, 1), RadioButton[FILENAME], [
	[
		50,
		4,

		[
			[
				51,
				6,

				[
					[56, 8, [[57, 10, [[58, 12], [61, 12], [64, 12], [67, 12]]]]],
					[70, 8]
				]
			]
		]
	],

	[121, 4, [[127, 7, [[128, 9], [128, 45]]]]]
]);

function RadioButton($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);

	let field = prop($$props, 'field', 15),
		gather = prop($$props, 'gather', 15, null),
		options = prop($$props, 'options', 15);

	let refsTable;

	// <mt:include name="content_field_type_options/selection_common_script.tmpl">
	// copied some functions from selection_common_script.tmpl below
	if (!options().values) {
		$$ownership_validator.mutation('options', ['options', 'values'], options(options().values = [{ checked: "", label: "", value: "" }], true), 9, 4);
	}

	user_effect(() => {
		if (refsTable) {
			validateTable(refsTable);
		}
	});

	gather(() => {
		return { values: options().values };
	});

	// copied some functions from selection_common_script.tmpl above
	// <mt:include name="content_field_type_options/selection_common_script.tmpl">
	const enterInitial = (index) => {
		options().values.forEach(function (v) {
			v.checked = "";
		});

		$$ownership_validator.mutation('options', ['options', 'values', index, 'checked'], options(options().values[index].checked = "checked", true), 33, 4);
		refreshView();
	};

	// deleteRow was moved to SelectionCommonScript.svelte
	// added in Svelte
	const refreshView = () => {
		// eslint-disable-next-line no-self-assign
		options(options());
	};

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'radio-button',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(RadioButton, ($$anchor, $$slotProps) => {
					add_svelte_meta(
						() => ContentFieldOption($$anchor, {
							id: 'radio_button-values',
							required: 1,
							label: window.trans("Values"),

							children: wrap_snippet(RadioButton, ($$anchor, $$slotProps) => {
								var fragment_2 = root_2$b();
								var div = first_child(fragment_2);
								var table = child(div);

								attribute_effect(table, () => ({
									class: 'table mt-table values-option-table',
									...{ ref: "table" }
								}));

								var thead = child(table);
								var tr = child(thead);
								var th = child(tr);

								th.textContent = window.trans("Selected");

								var th_1 = sibling(th);

								th_1.textContent = window.trans("Label");

								var th_2 = sibling(th_1);

								th_2.textContent = window.trans("Value");
								next();
								reset(tr);
								reset(thead);

								var tbody = sibling(thead);

								add_svelte_meta(
									() => each(tbody, 21, () => options().values, index, ($$anchor, v, index) => {
										var tr_1 = root_3$9();
										var td = child(tr_1);
										var input = child(td);

										remove_input_defaults(input);

										input.__change = () => {
											enterInitial(index);
										};

										reset(td);

										var td_1 = sibling(td);
										var input_1 = child(td_1);

										remove_input_defaults(input_1);
										validate_binding('bind:value={v.label}', [], () => get$1(v), () => 'label', 90, 18);
										reset(td_1);

										var td_2 = sibling(td_1);
										var input_2 = child(td_2);

										remove_input_defaults(input_2);
										validate_binding('bind:value={v.value}', [], () => get$1(v), () => 'value', 99, 18);
										reset(td_2);

										var td_3 = sibling(td_2);
										var button = child(td_3);

										button.__click = () => {
											$$ownership_validator.mutation('options', ['options', 'values'], options(options().values = deleteRow(options().values, index), true), 105, 20);
										};

										var svg = child(button);
										var title = child(svg);

										title.textContent = window.trans("delete");

										var use = sibling(title);

										set_xlink_attribute(use, 'xlink:href', `${window.StaticURI ?? ''}images/sprite.svg#ic_trash`);
										reset(svg);

										var text = sibling(svg, 1, true);

										text.nodeValue = window.trans("delete");
										reset(button);
										reset(td_3);
										reset(tr_1);

										template_effect(() => {
											set_attribute(input, 'name', $$props.id + "-initial");
											set_checked(input, get$1(v).checked ? true : false);
										});

										bind_value(
											input_1,
											function get() {
												return get$1(v).label;
											},
											function set($$value) {
												(get$1(v).label = $$value);
											}
										);

										bind_value(
											input_2,
											function get() {
												return get$1(v).value;
											},
											function set($$value) {
												(get$1(v).value = $$value);
											}
										);

										append($$anchor, tr_1);
									}),
									'each',
									RadioButton,
									71,
									10
								);

								reset(tbody);
								reset(table);
								bind_this(table, ($$value) => refsTable = $$value, () => refsTable);
								reset(div);

								var button_1 = sibling(div, 2);

								button_1.__click = () => {
									$$ownership_validator.mutation('options', ['options', 'values'], options(options().values = addRow(options().values), true), 123, 8);
								};

								var svg_1 = child(button_1);
								var title_1 = child(svg_1);

								title_1.textContent = window.trans("add");

								var use_1 = sibling(title_1);

								set_xlink_attribute(use_1, 'xlink:href', `${window.StaticURI ?? ''}images/sprite.svg#ic_add`);
								reset(svg_1);

								var text_1 = sibling(svg_1, 1, true);

								text_1.nodeValue = window.trans("add");
								reset(button_1);
								append($$anchor, fragment_2);
							}),

							$$slots: { default: true }
						}),
						'component',
						RadioButton,
						45,
						2,
						{ componentTag: 'ContentFieldOption' }
					);
				}),

				$$slots: { default: true }
			}),
			'component',
			RadioButton,
			44,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

delegate(['change', 'click']);

Checkboxes[FILENAME] = 'src/contenttype/elements/Checkboxes.svelte';

var root_2$a = add_locations(from_html(`<input/>`), Checkboxes[FILENAME], [[86, 4]]);
var root_3$8 = add_locations(from_html(`<input/>`), Checkboxes[FILENAME], [[101, 4]]);

var root_5$8 = add_locations(from_html(`<tr class="text-center align-middle"><td><input type="checkbox" class="form-check-input mt-3"/></td><td><input type="text" class="form-control required" name="label"/></td><td><input type="text" class="form-control required" name="value"/></td><td><button type="button" class="btn btn-default btn-sm"><svg role="img" class="mt-icon mt-icon--sm"><title></title><use></use></svg> </button></td></tr>`), Checkboxes[FILENAME], [
	[
		140,
		12,

		[
			[141, 14, [[142, 17]]],
			[151, 14, [[153, 16]]],
			[160, 14, [[162, 16]]],
			[169, 14, [[170, 17, [[176, 19, [[177, 21], [179, 28]]]]]]]
		]
	]
]);

var root_4$8 = add_locations(from_html(`<div class="mt-table--outline mb-3"><table><thead><tr><th scope="col"></th><th scope="col"></th><th scope="col"></th><th scope="col"></th></tr></thead><tbody></tbody></table></div> <button type="button" class="btn btn-default btn-sm"><svg role="img" class="mt-icon mt-icon--sm"><title></title><use></use></svg> </button>`, 1), Checkboxes[FILENAME], [
	[
		118,
		4,

		[
			[
				119,
				6,

				[
					[
						124,
						8,
						[[125, 10, [[126, 12], [129, 12], [132, 12], [135, 12]]]]
					],

					[138, 8]
				]
			]
		]
	],

	[191, 4, [[197, 7, [[198, 9], [200, 16]]]]]
]);

var root_1$a = add_locations(from_html(`<!> <!> <!>`, 1), Checkboxes[FILENAME], []);

function Checkboxes($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;
	var _b;

	let field = prop($$props, 'field', 15),
		gather = prop($$props, 'gather', 15, null),
		options = prop($$props, 'options', 15);

	if (strict_equals(options().can_add, "0")) {
		$$ownership_validator.mutation('options', ['options', 'can_add'], options(options().can_add = 0, true), 7, 4);
	}

	if (strict_equals(options().multiple, "0")) {
		$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = 0, true), 10, 4);
	}

	strict_equals(_a = options().min, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'min'], options(options().min = "", true), 12, 53);

	strict_equals(_b = options().max, null, false) && strict_equals(_b, void 0, false)
		? _b
		: $$ownership_validator.mutation('options', ['options', 'max'], options(options().max = "", true), 13, 53);

	let refsTable;

	// <mt:include name="content_field_type_options/selection_common_script.tmpl">
	// copied some functions from selection_common_script.tmpl below
	if (!options().values) {
		$$ownership_validator.mutation('options', ['options', 'values'], options(options().values = [{ checked: "", label: "", value: "" }], true), 18, 4);
	}

	user_effect(() => {
		if (refsTable) {
			validateTable(refsTable);
		}
	});

	gather(() => {
		return { values: options().values };
	});

	// copied some functions from selection_common_script.tmpl above
	// <mt:include name="content_field_type_options/selection_common_script.tmpl">
	const enterInitial = (e, index) => {
		const target = e.target;
		const state = target.checked;
		const block = jQuery(e.target).parents(".mt-contentfield");

		// Set current item status
		e.target.checked = state;

		$$ownership_validator.mutation('options', ['options', 'values', index, 'checked'], options(options().values[index].checked = state ? "checked" : "", true), 44, 4);
		_updateInitialField(block);
		refreshView();
	};

	const enterMax = (e) => {
		const block = jQuery(e.target).parents(".mt-contentfield");

		_updateInitialField(block);
	};

	const _updateInitialField = (block) => {
		const max = Number(block.find('input[name="max"]').val());
		const cur = block.find(".values-option-table").find('input[type="checkbox"]:checked').length;

		if (strict_equals(max, 0) || cur < max) {
			const chkbox = block.find(".values-option-table").find('input[type="checkbox"]');

			jQuery.each(chkbox, function (i) {
				jQuery(chkbox[i]).prop("disabled", false);
			});
		} else {
			const chkbox = block.find(".values-option-table").find('input[type="checkbox"]:not(:checked)');

			jQuery.each(chkbox, function (i) {
				jQuery(chkbox[i]).prop("disabled", true);
			});
		}
	};

	// added in Svelte
	const refreshView = () => {
		// eslint-disable-next-line no-self-assign
		options(options());
	};

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'checkboxes',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(Checkboxes, ($$anchor, $$slotProps) => {
					var fragment_1 = root_1$a();
					var node = first_child(fragment_1);

					add_svelte_meta(
						() => ContentFieldOption(node, {
							id: 'checkboxes-min',
							label: window.trans("Minimum number of selections"),

							children: wrap_snippet(Checkboxes, ($$anchor, $$slotProps) => {
								var input = root_2$a();

								attribute_effect(
									input,
									() => ({
										...{ ref: "min" },
										type: 'number',
										name: 'min',
										id: 'checkboxes-min',
										class: 'form-control w-25',
										min: '0'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.min}', [], options, () => 'min', 93, 6);

								bind_value(
									input,
									function get() {
										return options().min;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'min'], options(options().min = $$value, true), 93, 18);
									}
								);

								append($$anchor, input);
							}),

							$$slots: { default: true }
						}),
						'component',
						Checkboxes,
						82,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_1 = sibling(node, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_1, {
							id: 'checkboxes-max',
							label: window.trans("Maximum number of selections"),

							children: wrap_snippet(Checkboxes, ($$anchor, $$slotProps) => {
								var input_1 = root_3$8();

								attribute_effect(
									input_1,
									() => ({
										...{ ref: "max" },
										type: 'number',
										name: 'max',
										id: 'checkboxes-max',
										class: 'form-control w-25',
										min: '1',
										onchange: enterMax
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.max}', [], options, () => 'max', 108, 6);

								bind_value(
									input_1,
									function get() {
										return options().max;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'max'], options(options().max = $$value, true), 108, 18);
									}
								);

								append($$anchor, input_1);
							}),

							$$slots: { default: true }
						}),
						'component',
						Checkboxes,
						97,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_2 = sibling(node_1, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_2, {
							id: 'checkboxes-values',
							required: 1,
							label: window.trans("Values"),

							children: wrap_snippet(Checkboxes, ($$anchor, $$slotProps) => {
								var fragment_2 = root_4$8();
								var div = first_child(fragment_2);
								var table = child(div);

								attribute_effect(table, () => ({
									class: 'table mt-table values-option-table',
									...{ ref: "table" }
								}));

								var thead = child(table);
								var tr = child(thead);
								var th = child(tr);

								th.textContent = window.trans("Selected");

								var th_1 = sibling(th);

								th_1.textContent = window.trans("Label");

								var th_2 = sibling(th_1);

								th_2.textContent = window.trans("Value");
								next();
								reset(tr);
								reset(thead);

								var tbody = sibling(thead);

								add_svelte_meta(
									() => each(tbody, 21, () => options().values, index, ($$anchor, v, index) => {
										var tr_1 = root_5$8();
										var td = child(tr_1);
										var input_2 = child(td);

										remove_input_defaults(input_2);

										input_2.__change = (e) => {
											enterInitial(e, index);
										};

										reset(td);

										var td_1 = sibling(td);
										var input_3 = child(td_1);

										remove_input_defaults(input_3);
										validate_binding('bind:value={v.label}', [], () => get$1(v), () => 'label', 157, 18);
										reset(td_1);

										var td_2 = sibling(td_1);
										var input_4 = child(td_2);

										remove_input_defaults(input_4);
										validate_binding('bind:value={v.value}', [], () => get$1(v), () => 'value', 166, 18);
										reset(td_2);

										var td_3 = sibling(td_2);
										var button = child(td_3);

										button.__click = () => {
											$$ownership_validator.mutation('options', ['options', 'values'], options(options().values = deleteRow(options().values, index), true), 172, 20);
										};

										var svg = child(button);
										var title = child(svg);

										title.textContent = window.trans("delete");

										var use = sibling(title);

										set_xlink_attribute(use, 'xlink:href', `${window.StaticURI ?? ''}images/sprite.svg#ic_trash`);
										reset(svg);

										var text = sibling(svg);

										text.nodeValue = ` ${window.trans("delete") ?? ''}`;
										reset(button);
										reset(td_3);
										reset(tr_1);
										template_effect(() => set_checked(input_2, get$1(v).checked ? true : false));

										bind_value(
											input_3,
											function get() {
												return get$1(v).label;
											},
											function set($$value) {
												(get$1(v).label = $$value);
											}
										);

										bind_value(
											input_4,
											function get() {
												return get$1(v).value;
											},
											function set($$value) {
												(get$1(v).value = $$value);
											}
										);

										append($$anchor, tr_1);
									}),
									'each',
									Checkboxes,
									139,
									10
								);

								reset(tbody);
								reset(table);
								bind_this(table, ($$value) => refsTable = $$value, () => refsTable);
								reset(div);

								var button_1 = sibling(div, 2);

								button_1.__click = () => {
									$$ownership_validator.mutation('options', ['options', 'values'], options(options().values = addRow(options().values), true), 193, 8);
								};

								var svg_1 = child(button_1);
								var title_1 = child(svg_1);

								title_1.textContent = window.trans("add");

								var use_1 = sibling(title_1);

								set_xlink_attribute(use_1, 'xlink:href', `${window.StaticURI ?? ''}images/sprite.svg#ic_add`);
								reset(svg_1);

								var text_1 = sibling(svg_1);

								text_1.nodeValue = ` ${window.trans("add") ?? ''}`;
								reset(button_1);
								append($$anchor, fragment_2);
							}),

							$$slots: { default: true }
						}),
						'component',
						Checkboxes,
						113,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					append($$anchor, fragment_1);
				}),

				$$slots: { default: true }
			}),
			'component',
			Checkboxes,
			81,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

delegate(['change', 'click']);

Asset[FILENAME] = 'src/contenttype/elements/Asset.svelte';

var root_2$9 = add_locations(from_html(`<input/><label for="asset-multiple" class="form-label"></label>`, 1), Asset[FILENAME], [[22, 4], [29, 6]]);
var root_3$7 = add_locations(from_html(`<input/>`), Asset[FILENAME], [[39, 4]]);
var root_4$7 = add_locations(from_html(`<input/>`), Asset[FILENAME], [[55, 4]]);
var root_5$7 = add_locations(from_html(`<input/><label for="asset-allow_upload" class="form-label"></label>`, 1), Asset[FILENAME], [[70, 4], [77, 6]]);
var root_1$9 = add_locations(from_html(`<!> <!> <!> <!>`, 1), Asset[FILENAME], []);

function Asset($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;
	var _b;

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	if (strict_equals(options().multiple, "0")) {
		$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = 0, true), 6, 4);
	}

	if (strict_equals(options().allow_upload, "0")) {
		$$ownership_validator.mutation('options', ['options', 'allow_upload'], options(options().allow_upload = 0, true), 9, 4);
	}

	// changeStateMultiple was removed because unused
	strict_equals(_a = options().min, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'min'], options(options().min = "", true), 12, 53);

	strict_equals(_b = options().max, null, false) && strict_equals(_b, void 0, false)
		? _b
		: $$ownership_validator.mutation('options', ['options', 'max'], options(options().max = "", true), 13, 53);

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'asset',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(Asset, ($$anchor, $$slotProps) => {
					var fragment_1 = root_1$9();
					var node = first_child(fragment_1);

					add_svelte_meta(
						() => ContentFieldOption(node, {
							id: 'asset-multiple',
							label: window.trans("Allow users to select multiple assets?"),

							children: wrap_snippet(Asset, ($$anchor, $$slotProps) => {
								var fragment_2 = root_2$9();
								var input = first_child(fragment_2);

								attribute_effect(
									input,
									() => ({
										...{ ref: "multiple" },
										type: 'checkbox',
										class: 'mt-switch form-control',
										id: 'asset-multiple',
										name: 'multiple'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:checked={options.multiple}', [], options, () => 'multiple', 28, 6);

								var label = sibling(input);

								label.textContent = window.trans("Allow users to select multiple assets?");

								bind_checked(
									input,
									function get() {
										return options().multiple;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = $$value, true), 28, 20);
									}
								);

								append($$anchor, fragment_2);
							}),

							$$slots: { default: true }
						}),
						'component',
						Asset,
						17,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_1 = sibling(node, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_1, {
							id: 'asset-min',
							label: window.trans("Minimum number of selections"),

							get attrShow() {
								return options().multiple;
							},

							children: wrap_snippet(Asset, ($$anchor, $$slotProps) => {
								var input_1 = root_3$7();

								attribute_effect(
									input_1,
									() => ({
										...{ ref: "min" },
										type: 'number',
										name: 'min',
										id: 'asset-min',
										class: 'form-control w-25',
										min: '0'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.min}', [], options, () => 'min', 46, 6);

								bind_value(
									input_1,
									function get() {
										return options().min;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'min'], options(options().min = $$value, true), 46, 18);
									}
								);

								append($$anchor, input_1);
							}),

							$$slots: { default: true }
						}),
						'component',
						Asset,
						34,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_2 = sibling(node_1, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_2, {
							id: 'asset-max',
							label: window.trans("Maximum number of selections"),

							get attrShow() {
								return options().multiple;
							},

							children: wrap_snippet(Asset, ($$anchor, $$slotProps) => {
								var input_2 = root_4$7();

								attribute_effect(
									input_2,
									() => ({
										...{ ref: "max" },
										type: 'number',
										name: 'max',
										id: 'asset-max',
										class: 'form-control w-25',
										min: '1'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.max}', [], options, () => 'max', 62, 6);

								bind_value(
									input_2,
									function get() {
										return options().max;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'max'], options(options().max = $$value, true), 62, 18);
									}
								);

								append($$anchor, input_2);
							}),

							$$slots: { default: true }
						}),
						'component',
						Asset,
						50,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_3 = sibling(node_2, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_3, {
							id: 'asset-allow_upload',
							label: window.trans("Allow users to upload a new asset?"),

							children: wrap_snippet(Asset, ($$anchor, $$slotProps) => {
								var fragment_3 = root_5$7();
								var input_3 = first_child(fragment_3);

								attribute_effect(
									input_3,
									() => ({
										...{ ref: "allow_upload" },
										type: 'checkbox',
										class: 'mt-switch form-control',
										id: 'asset-allow_upload',
										name: 'allow_upload'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:checked={options.allow_upload}', [], options, () => 'allow_upload', 76, 6);

								var label_1 = sibling(input_3);

								label_1.textContent = window.trans("Allow users to upload a new asset?");

								bind_checked(
									input_3,
									function get() {
										return options().allow_upload;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'allow_upload'], options(options().allow_upload = $$value, true), 76, 20);
									}
								);

								append($$anchor, fragment_3);
							}),

							$$slots: { default: true }
						}),
						'component',
						Asset,
						66,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					append($$anchor, fragment_1);
				}),

				$$slots: { default: true }
			}),
			'component',
			Asset,
			16,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

AssetAudio[FILENAME] = 'src/contenttype/elements/AssetAudio.svelte';

var root_2$8 = add_locations(from_html(`<input/><label for="asset_audio-multiple" class="form-label"></label>`, 1), AssetAudio[FILENAME], [[22, 4], [29, 6]]);
var root_3$6 = add_locations(from_html(`<input/>`), AssetAudio[FILENAME], [[39, 4]]);
var root_4$6 = add_locations(from_html(`<input/>`), AssetAudio[FILENAME], [[55, 4]]);
var root_5$6 = add_locations(from_html(`<input/><label for="asset_audio-allow_upload" class="form-label"></label>`, 1), AssetAudio[FILENAME], [[70, 4], [77, 6]]);
var root_1$8 = add_locations(from_html(`<!> <!> <!> <!>`, 1), AssetAudio[FILENAME], []);

function AssetAudio($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;
	var _b;

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	if (strict_equals(options().multiple, "0")) {
		$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = 0, true), 6, 4);
	}

	if (strict_equals(options().allow_upload, "0")) {
		$$ownership_validator.mutation('options', ['options', 'allow_upload'], options(options().allow_upload = 0, true), 9, 4);
	}

	// changeStateMultiple was removed because unused
	strict_equals(_a = options().min, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'min'], options(options().min = "", true), 12, 53);

	strict_equals(_b = options().max, null, false) && strict_equals(_b, void 0, false)
		? _b
		: $$ownership_validator.mutation('options', ['options', 'max'], options(options().max = "", true), 13, 53);

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'asset-audio',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(AssetAudio, ($$anchor, $$slotProps) => {
					var fragment_1 = root_1$8();
					var node = first_child(fragment_1);

					add_svelte_meta(
						() => ContentFieldOption(node, {
							id: 'asset_audio-multiple',
							label: window.trans("Allow users to select multiple assets?"),

							children: wrap_snippet(AssetAudio, ($$anchor, $$slotProps) => {
								var fragment_2 = root_2$8();
								var input = first_child(fragment_2);

								attribute_effect(
									input,
									() => ({
										...{ ref: "multiple" },
										type: 'checkbox',
										class: 'mt-switch form-control',
										id: 'asset_audio-multiple',
										name: 'multiple'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:checked={options.multiple}', [], options, () => 'multiple', 28, 6);

								var label = sibling(input);

								label.textContent = window.trans("Allow users to select multiple assets?");

								bind_checked(
									input,
									function get() {
										return options().multiple;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = $$value, true), 28, 20);
									}
								);

								append($$anchor, fragment_2);
							}),

							$$slots: { default: true }
						}),
						'component',
						AssetAudio,
						17,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_1 = sibling(node, 2);

					{
						let $0 = user_derived(() => options().multiple ? true : false);

						add_svelte_meta(
							() => ContentFieldOption(node_1, {
								id: 'asset_audio-min',
								label: window.trans("Minimum number of selections"),

								get attrShow() {
									return get$1($0);
								},

								children: wrap_snippet(AssetAudio, ($$anchor, $$slotProps) => {
									var input_1 = root_3$6();

									attribute_effect(
										input_1,
										() => ({
											...{ ref: "min" },
											type: 'number',
											name: 'min',
											id: 'asset_audio-min',
											class: 'form-control w-25',
											min: '0'
										}),
										void 0,
										void 0,
										void 0,
										void 0,
										true
									);

									validate_binding('bind:value={options.min}', [], options, () => 'min', 46, 6);

									bind_value(
										input_1,
										function get() {
											return options().min;
										},
										function set($$value) {
											$$ownership_validator.mutation('options', ['options', 'min'], options(options().min = $$value, true), 46, 18);
										}
									);

									append($$anchor, input_1);
								}),

								$$slots: { default: true }
							}),
							'component',
							AssetAudio,
							34,
							2,
							{ componentTag: 'ContentFieldOption' }
						);
					}

					var node_2 = sibling(node_1, 2);

					{
						let $0 = user_derived(() => options().multiple ? true : false);

						add_svelte_meta(
							() => ContentFieldOption(node_2, {
								id: 'asset_audio-max',
								label: window.trans("Maximum number of selections"),

								get attrShow() {
									return get$1($0);
								},

								children: wrap_snippet(AssetAudio, ($$anchor, $$slotProps) => {
									var input_2 = root_4$6();

									attribute_effect(
										input_2,
										() => ({
											...{ ref: "max" },
											type: 'number',
											name: 'max',
											id: 'asset_audio-max',
											class: 'form-control w-25',
											min: '1'
										}),
										void 0,
										void 0,
										void 0,
										void 0,
										true
									);

									validate_binding('bind:value={options.max}', [], options, () => 'max', 62, 6);

									bind_value(
										input_2,
										function get() {
											return options().max;
										},
										function set($$value) {
											$$ownership_validator.mutation('options', ['options', 'max'], options(options().max = $$value, true), 62, 18);
										}
									);

									append($$anchor, input_2);
								}),

								$$slots: { default: true }
							}),
							'component',
							AssetAudio,
							50,
							2,
							{ componentTag: 'ContentFieldOption' }
						);
					}

					var node_3 = sibling(node_2, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_3, {
							id: 'asset_audio-allow_upload',
							label: window.trans("Allow users to upload a new audio asset?"),

							children: wrap_snippet(AssetAudio, ($$anchor, $$slotProps) => {
								var fragment_3 = root_5$6();
								var input_3 = first_child(fragment_3);

								attribute_effect(
									input_3,
									() => ({
										...{ ref: "allow_upload" },
										type: 'checkbox',
										class: 'mt-switch form-control',
										id: 'asset_audio-allow_upload',
										name: 'allow_upload'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:checked={options.allow_upload}', [], options, () => 'allow_upload', 76, 6);

								var label_1 = sibling(input_3);

								label_1.textContent = window.trans("Allow users to upload a new audio asset?");

								bind_checked(
									input_3,
									function get() {
										return options().allow_upload;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'allow_upload'], options(options().allow_upload = $$value, true), 76, 20);
									}
								);

								append($$anchor, fragment_3);
							}),

							$$slots: { default: true }
						}),
						'component',
						AssetAudio,
						66,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					append($$anchor, fragment_1);
				}),

				$$slots: { default: true }
			}),
			'component',
			AssetAudio,
			16,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

AssetVideo[FILENAME] = 'src/contenttype/elements/AssetVideo.svelte';

var root_2$7 = add_locations(from_html(`<input/><label for="asset_video-multiple" class="form-label"></label>`, 1), AssetVideo[FILENAME], [[22, 4], [29, 6]]);
var root_3$5 = add_locations(from_html(`<input/>`), AssetVideo[FILENAME], [[39, 4]]);
var root_4$5 = add_locations(from_html(`<input/>`), AssetVideo[FILENAME], [[55, 4]]);
var root_5$5 = add_locations(from_html(`<input/><label for="asset_video-allow_upload" class="form-label"></label>`, 1), AssetVideo[FILENAME], [[70, 4], [77, 6]]);
var root_1$7 = add_locations(from_html(`<!> <!> <!> <!>`, 1), AssetVideo[FILENAME], []);

function AssetVideo($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;
	var _b;

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	if (strict_equals(options().multiple, "0")) {
		$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = 0, true), 6, 4);
	}

	if (strict_equals(options().allow_upload, "0")) {
		$$ownership_validator.mutation('options', ['options', 'allow_upload'], options(options().allow_upload = 0, true), 9, 4);
	}

	strict_equals(_a = options().min, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'min'], options(options().min = "", true), 11, 53);

	strict_equals(_b = options().max, null, false) && strict_equals(_b, void 0, false)
		? _b
		: $$ownership_validator.mutation('options', ['options', 'max'], options(options().max = "", true), 12, 53);

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'asset-video',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(AssetVideo, ($$anchor, $$slotProps) => {
					var fragment_1 = root_1$7();
					var node = first_child(fragment_1);

					add_svelte_meta(
						() => ContentFieldOption(node, {
							id: 'asset_video-multiple',
							label: window.trans("Allow users to select multiple video assets?"),

							children: wrap_snippet(AssetVideo, ($$anchor, $$slotProps) => {
								var fragment_2 = root_2$7();
								var input = first_child(fragment_2);

								attribute_effect(
									input,
									() => ({
										...{ ref: "multiple" },
										type: 'checkbox',
										class: 'mt-switch form-control',
										id: 'asset_video-multiple',
										name: 'multiple'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:checked={options.multiple}', [], options, () => 'multiple', 28, 6);

								var label = sibling(input);

								label.textContent = window.trans("Allow users to select multiple video assets?");

								bind_checked(
									input,
									function get() {
										return options().multiple;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = $$value, true), 28, 20);
									}
								);

								append($$anchor, fragment_2);
							}),

							$$slots: { default: true }
						}),
						'component',
						AssetVideo,
						17,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_1 = sibling(node, 2);

					{
						let $0 = user_derived(() => options().multiple ? true : false);

						add_svelte_meta(
							() => ContentFieldOption(node_1, {
								id: 'asset_video-min',
								label: window.trans("Minimum number of selections"),

								get attrShow() {
									return get$1($0);
								},

								children: wrap_snippet(AssetVideo, ($$anchor, $$slotProps) => {
									var input_1 = root_3$5();

									attribute_effect(
										input_1,
										() => ({
											...{ ref: "min" },
											type: 'number',
											name: 'min',
											id: 'asset_video-min',
											class: 'form-control w-25',
											min: '0'
										}),
										void 0,
										void 0,
										void 0,
										void 0,
										true
									);

									validate_binding('bind:value={options.min}', [], options, () => 'min', 46, 6);

									bind_value(
										input_1,
										function get() {
											return options().min;
										},
										function set($$value) {
											$$ownership_validator.mutation('options', ['options', 'min'], options(options().min = $$value, true), 46, 18);
										}
									);

									append($$anchor, input_1);
								}),

								$$slots: { default: true }
							}),
							'component',
							AssetVideo,
							34,
							2,
							{ componentTag: 'ContentFieldOption' }
						);
					}

					var node_2 = sibling(node_1, 2);

					{
						let $0 = user_derived(() => options().multiple ? true : false);

						add_svelte_meta(
							() => ContentFieldOption(node_2, {
								id: 'asset_video-max',
								label: window.trans("Maximum number of selections"),

								get attrShow() {
									return get$1($0);
								},

								children: wrap_snippet(AssetVideo, ($$anchor, $$slotProps) => {
									var input_2 = root_4$5();

									attribute_effect(
										input_2,
										() => ({
											...{ ref: "max" },
											type: 'number',
											name: 'max',
											id: 'asset_video-max',
											class: 'form-control w-25',
											min: '1'
										}),
										void 0,
										void 0,
										void 0,
										void 0,
										true
									);

									validate_binding('bind:value={options.max}', [], options, () => 'max', 62, 6);

									bind_value(
										input_2,
										function get() {
											return options().max;
										},
										function set($$value) {
											$$ownership_validator.mutation('options', ['options', 'max'], options(options().max = $$value, true), 62, 18);
										}
									);

									append($$anchor, input_2);
								}),

								$$slots: { default: true }
							}),
							'component',
							AssetVideo,
							50,
							2,
							{ componentTag: 'ContentFieldOption' }
						);
					}

					var node_3 = sibling(node_2, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_3, {
							id: 'asset_video-allow_upload',
							label: window.trans("Allow users to upload a new video asset?"),

							children: wrap_snippet(AssetVideo, ($$anchor, $$slotProps) => {
								var fragment_3 = root_5$5();
								var input_3 = first_child(fragment_3);

								attribute_effect(
									input_3,
									() => ({
										...{ ref: "allow_upload" },
										type: 'checkbox',
										class: 'mt-switch form-control',
										id: 'asset_video-allow_upload',
										name: 'allow_upload'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:checked={options.allow_upload}', [], options, () => 'allow_upload', 76, 6);

								var label_1 = sibling(input_3);

								label_1.textContent = window.trans("Allow users to upload a new video asset?");

								bind_checked(
									input_3,
									function get() {
										return options().allow_upload;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'allow_upload'], options(options().allow_upload = $$value, true), 76, 20);
									}
								);

								append($$anchor, fragment_3);
							}),

							$$slots: { default: true }
						}),
						'component',
						AssetVideo,
						66,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					append($$anchor, fragment_1);
				}),

				$$slots: { default: true }
			}),
			'component',
			AssetVideo,
			16,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

AssetImage[FILENAME] = 'src/contenttype/elements/AssetImage.svelte';

var root_2$6 = add_locations(from_html(`<input/><label for="asset_image-multiple" class="form-label"></label>`, 1), AssetImage[FILENAME], [[24, 4], [31, 6]]);
var root_3$4 = add_locations(from_html(`<input/>`), AssetImage[FILENAME], [[41, 4]]);
var root_4$4 = add_locations(from_html(`<input/>`), AssetImage[FILENAME], [[57, 4]]);
var root_5$4 = add_locations(from_html(`<input/><label for="asset_image-allow_upload" class="form-label"></label>`, 1), AssetImage[FILENAME], [[72, 4], [79, 6]]);
var root_6$2 = add_locations(from_html(`<input/>`), AssetImage[FILENAME], [[88, 4]]);
var root_7$1 = add_locations(from_html(`<input/>`), AssetImage[FILENAME], [[102, 4]]);
var root_1$6 = add_locations(from_html(`<!> <!> <!> <!> <!> <!>`, 1), AssetImage[FILENAME], []);

function AssetImage($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;
	var _b;
	var _c;
	var _d;

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	if (strict_equals(options().multiple, "0")) {
		$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = 0, true), 6, 4);
	}

	if (strict_equals(options().allow_upload, "0")) {
		$$ownership_validator.mutation('options', ['options', 'allow_upload'], options(options().allow_upload = 0, true), 9, 4);
	}

	// changeStateMultiple was removed because unused
	strict_equals(_a = options().min, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'min'], options(options().min = "", true), 12, 53);

	strict_equals(_b = options().max, null, false) && strict_equals(_b, void 0, false)
		? _b
		: $$ownership_validator.mutation('options', ['options', 'max'], options(options().max = "", true), 13, 53);

	strict_equals(_c = options().preview_width, null, false) && strict_equals(_c, void 0, false)
		? _c
		: $$ownership_validator.mutation('options', ['options', 'preview_width'], options(options().preview_width = 80, true), 14, 63);

	strict_equals(_d = options().preivew_height, null, false) && strict_equals(_d, void 0, false)
		? _d
		: $$ownership_validator.mutation('options', ['options', 'preivew_height'], options(options().preivew_height = 80, true), 15, 64);

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'asset-image',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(AssetImage, ($$anchor, $$slotProps) => {
					var fragment_1 = root_1$6();
					var node = first_child(fragment_1);

					add_svelte_meta(
						() => ContentFieldOption(node, {
							id: 'asset_image-multiple',
							label: window.trans("Allow users to select multiple image assets?"),

							children: wrap_snippet(AssetImage, ($$anchor, $$slotProps) => {
								var fragment_2 = root_2$6();
								var input = first_child(fragment_2);

								attribute_effect(
									input,
									() => ({
										...{ ref: "multiple" },
										type: 'checkbox',
										class: 'mt-switch form-control',
										id: 'asset_image-multiple',
										name: 'multiple'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:checked={options.multiple}', [], options, () => 'multiple', 30, 6);

								var label = sibling(input);

								label.textContent = window.trans("Allow users to select multiple image assets?");

								bind_checked(
									input,
									function get() {
										return options().multiple;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = $$value, true), 30, 20);
									}
								);

								append($$anchor, fragment_2);
							}),

							$$slots: { default: true }
						}),
						'component',
						AssetImage,
						19,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_1 = sibling(node, 2);

					{
						let $0 = user_derived(() => options().multiple ? true : false);

						add_svelte_meta(
							() => ContentFieldOption(node_1, {
								id: 'asset_image-min',
								label: window.trans("Minimum number of selections"),

								get attrShow() {
									return get$1($0);
								},

								children: wrap_snippet(AssetImage, ($$anchor, $$slotProps) => {
									var input_1 = root_3$4();

									attribute_effect(
										input_1,
										() => ({
											...{ ref: "min" },
											type: 'number',
											name: 'min',
											id: 'asset_image-min',
											class: 'form-control w-25',
											min: '0'
										}),
										void 0,
										void 0,
										void 0,
										void 0,
										true
									);

									validate_binding('bind:value={options.min}', [], options, () => 'min', 48, 6);

									bind_value(
										input_1,
										function get() {
											return options().min;
										},
										function set($$value) {
											$$ownership_validator.mutation('options', ['options', 'min'], options(options().min = $$value, true), 48, 18);
										}
									);

									append($$anchor, input_1);
								}),

								$$slots: { default: true }
							}),
							'component',
							AssetImage,
							36,
							2,
							{ componentTag: 'ContentFieldOption' }
						);
					}

					var node_2 = sibling(node_1, 2);

					{
						let $0 = user_derived(() => options().multiple ? true : false);

						add_svelte_meta(
							() => ContentFieldOption(node_2, {
								id: 'asset_image-max',
								label: window.trans("Maximum number of selections"),

								get attrShow() {
									return get$1($0);
								},

								children: wrap_snippet(AssetImage, ($$anchor, $$slotProps) => {
									var input_2 = root_4$4();

									attribute_effect(
										input_2,
										() => ({
											...{ ref: "max" },
											type: 'number',
											name: 'max',
											id: 'asset_image-max',
											class: 'form-control w-25',
											min: '1'
										}),
										void 0,
										void 0,
										void 0,
										void 0,
										true
									);

									validate_binding('bind:value={options.max}', [], options, () => 'max', 64, 6);

									bind_value(
										input_2,
										function get() {
											return options().max;
										},
										function set($$value) {
											$$ownership_validator.mutation('options', ['options', 'max'], options(options().max = $$value, true), 64, 18);
										}
									);

									append($$anchor, input_2);
								}),

								$$slots: { default: true }
							}),
							'component',
							AssetImage,
							52,
							2,
							{ componentTag: 'ContentFieldOption' }
						);
					}

					var node_3 = sibling(node_2, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_3, {
							id: 'asset_image-allow_upload',
							label: window.trans("Allow users to upload a new image asset?"),

							children: wrap_snippet(AssetImage, ($$anchor, $$slotProps) => {
								var fragment_3 = root_5$4();
								var input_3 = first_child(fragment_3);

								attribute_effect(
									input_3,
									() => ({
										...{ ref: "allow_upload" },
										type: 'checkbox',
										class: 'mt-switch form-control',
										id: 'asset_image-allow_upload',
										name: 'allow_upload'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:checked={options.allow_upload}', [], options, () => 'allow_upload', 78, 6);

								var label_1 = sibling(input_3);

								label_1.textContent = window.trans("Allow users to upload a new image asset?");

								bind_checked(
									input_3,
									function get() {
										return options().allow_upload;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'allow_upload'], options(options().allow_upload = $$value, true), 78, 20);
									}
								);

								append($$anchor, fragment_3);
							}),

							$$slots: { default: true }
						}),
						'component',
						AssetImage,
						68,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_4 = sibling(node_3, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_4, {
							id: 'asset_image-preview_width',
							label: window.trans("Thumbnail width"),

							children: wrap_snippet(AssetImage, ($$anchor, $$slotProps) => {
								var input_4 = root_6$2();

								attribute_effect(
									input_4,
									() => ({
										...{ ref: "preview_width" },
										type: 'number',
										class: 'form-control w-25',
										id: 'asset_image-preview_width',
										name: 'preview_width'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.preview_width}', [], options, () => 'preview_width', 94, 6);

								bind_value(
									input_4,
									function get() {
										return options().preview_width;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'preview_width'], options(options().preview_width = $$value, true), 94, 18);
									}
								);

								append($$anchor, input_4);
							}),

							$$slots: { default: true }
						}),
						'component',
						AssetImage,
						84,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_5 = sibling(node_4, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_5, {
							id: 'asset_image-preview_height',
							label: window.trans("Thumbnail height"),

							children: wrap_snippet(AssetImage, ($$anchor, $$slotProps) => {
								var input_5 = root_7$1();

								attribute_effect(
									input_5,
									() => ({
										...{ ref: "preview_height" },
										type: 'number',
										class: 'form-control w-25',
										id: 'asset_image-preview_height',
										name: 'preview_height'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.preview_height}', [], options, () => 'preview_height', 108, 6);

								bind_value(
									input_5,
									function get() {
										return options().preview_height;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'preview_height'], options(options().preview_height = $$value, true), 108, 18);
									}
								);

								append($$anchor, input_5);
							}),

							$$slots: { default: true }
						}),
						'component',
						AssetImage,
						98,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					append($$anchor, fragment_1);
				}),

				$$slots: { default: true }
			}),
			'component',
			AssetImage,
			18,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

EmbeddedText[FILENAME] = 'src/contenttype/elements/EmbeddedText.svelte';

var root_2$5 = add_locations(from_html(`<textarea></textarea>`), EmbeddedText[FILENAME], [[14, 4]]);

function EmbeddedText($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	strict_equals(_a = options().initial_value, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'initial_value'], options(options().initial_value = "", true), 5, 63);

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'embedded-text',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(EmbeddedText, ($$anchor, $$slotProps) => {
					add_svelte_meta(
						() => ContentFieldOption($$anchor, {
							id: 'embedded_text-initial_value',
							label: window.trans("Initial Value"),

							children: wrap_snippet(EmbeddedText, ($$anchor, $$slotProps) => {
								var textarea = root_2$5();

								remove_textarea_child(textarea);

								attribute_effect(textarea, () => ({
									...{ ref: "initial_value" },
									name: 'initial_value',
									id: 'embeddedded_text-initial_value',
									class: 'form-control'
								}));

								validate_binding('bind:value={options.initial_value}', [], options, () => 'initial_value', 19, 6);

								bind_value(
									textarea,
									function get() {
										return options().initial_value;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'initial_value'], options(options().initial_value = $$value, true), 19, 18);
									}
								);

								append($$anchor, textarea);
							}),

							$$slots: { default: true }
						}),
						'component',
						EmbeddedText,
						9,
						2,
						{ componentTag: 'ContentFieldOption' }
					);
				}),

				$$slots: { default: true }
			}),
			'component',
			EmbeddedText,
			8,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

Categories[FILENAME] = 'src/contenttype/elements/Categories.svelte';

var root_2$4 = add_locations(from_html(`<input/><label for="categories-multiple" class="form-label"></label>`, 1), Categories[FILENAME], [[24, 4], [31, 6]]);
var root_3$3 = add_locations(from_html(`<input/>`), Categories[FILENAME], [[41, 4]]);
var root_4$3 = add_locations(from_html(`<input/>`), Categories[FILENAME], [[57, 4]]);
var root_5$3 = add_locations(from_html(`<input/><label for="categories-can_add" class="form-label"></label>`, 1), Categories[FILENAME], [[72, 4], [79, 6]]);
var root_8 = add_locations(from_html(`<option> </option>`), Categories[FILENAME], [[99, 10]]);
var root_7 = add_locations(from_html(`<select></select>`), Categories[FILENAME], [[91, 6]]);
var root_1$5 = add_locations(from_html(`<!> <!> <!> <!> <!>`, 1), Categories[FILENAME], []);

function Categories($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;
	var _b;

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	const categorySets = $$props.optionsHtmlParams.categories.category_sets;

	if (strict_equals(options().multiple, "0")) {
		$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = 0, true), 8, 4);
	}

	if (strict_equals(options().can_add, "0")) {
		$$ownership_validator.mutation('options', ['options', 'can_add'], options(options().can_add = 0, true), 11, 4);
	}

	strict_equals(_a = options().min, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'min'], options(options().min = "", true), 13, 53);

	strict_equals(_b = options().max, null, false) && strict_equals(_b, void 0, false)
		? _b
		: $$ownership_validator.mutation('options', ['options', 'max'], options(options().max = "", true), 14, 53);

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'categories',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(Categories, ($$anchor, $$slotProps) => {
					var fragment_1 = root_1$5();
					var node = first_child(fragment_1);

					add_svelte_meta(
						() => ContentFieldOption(node, {
							id: 'categories-multiple',
							label: window.trans("Allow users to select multiple categories?"),

							children: wrap_snippet(Categories, ($$anchor, $$slotProps) => {
								var fragment_2 = root_2$4();
								var input = first_child(fragment_2);

								attribute_effect(
									input,
									() => ({
										...{ ref: "multiple" },
										type: 'checkbox',
										class: 'mt-switch form-control',
										id: 'categories-multiple',
										name: 'multiple'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:checked={options.multiple}', [], options, () => 'multiple', 30, 6);

								var label = sibling(input);

								label.textContent = window.trans("Allow users to select multiple categories?");

								bind_checked(
									input,
									function get() {
										return options().multiple;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = $$value, true), 30, 20);
									}
								);

								append($$anchor, fragment_2);
							}),

							$$slots: { default: true }
						}),
						'component',
						Categories,
						19,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_1 = sibling(node, 2);

					{
						let $0 = user_derived(() => options().multiple ? true : false);

						add_svelte_meta(
							() => ContentFieldOption(node_1, {
								id: 'categories-min',
								label: window.trans("Minimum number of selections"),

								get attrShow() {
									return get$1($0);
								},

								children: wrap_snippet(Categories, ($$anchor, $$slotProps) => {
									var input_1 = root_3$3();

									attribute_effect(
										input_1,
										() => ({
											...{ ref: "min" },
											type: 'number',
											name: 'min',
											id: 'categories-min',
											class: 'form-control w-25',
											min: '0'
										}),
										void 0,
										void 0,
										void 0,
										void 0,
										true
									);

									validate_binding('bind:value={options.min}', [], options, () => 'min', 48, 6);

									bind_value(
										input_1,
										function get() {
											return options().min;
										},
										function set($$value) {
											$$ownership_validator.mutation('options', ['options', 'min'], options(options().min = $$value, true), 48, 18);
										}
									);

									append($$anchor, input_1);
								}),

								$$slots: { default: true }
							}),
							'component',
							Categories,
							36,
							2,
							{ componentTag: 'ContentFieldOption' }
						);
					}

					var node_2 = sibling(node_1, 2);

					{
						let $0 = user_derived(() => options().multiple ? true : false);

						add_svelte_meta(
							() => ContentFieldOption(node_2, {
								id: 'categories-max',
								label: window.trans("Maximum number of selections"),

								get attrShow() {
									return get$1($0);
								},

								children: wrap_snippet(Categories, ($$anchor, $$slotProps) => {
									var input_2 = root_4$3();

									attribute_effect(
										input_2,
										() => ({
											...{ ref: "max" },
											type: 'number',
											name: 'max',
											id: 'categories-max',
											class: 'form-control w-25',
											min: '1'
										}),
										void 0,
										void 0,
										void 0,
										void 0,
										true
									);

									validate_binding('bind:value={options.max}', [], options, () => 'max', 64, 6);

									bind_value(
										input_2,
										function get() {
											return options().max;
										},
										function set($$value) {
											$$ownership_validator.mutation('options', ['options', 'max'], options(options().max = $$value, true), 64, 18);
										}
									);

									append($$anchor, input_2);
								}),

								$$slots: { default: true }
							}),
							'component',
							Categories,
							52,
							2,
							{ componentTag: 'ContentFieldOption' }
						);
					}

					var node_3 = sibling(node_2, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_3, {
							id: 'categories-can_add',
							label: window.trans("Allow users to create new categories?"),

							children: wrap_snippet(Categories, ($$anchor, $$slotProps) => {
								var fragment_3 = root_5$3();
								var input_3 = first_child(fragment_3);

								attribute_effect(
									input_3,
									() => ({
										...{ ref: "can_add" },
										type: 'checkbox',
										class: 'mt-switch form-control',
										id: 'categories-can_add',
										name: 'can_add'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:checked={options.can_add}', [], options, () => 'can_add', 78, 6);

								var label_1 = sibling(input_3);

								label_1.textContent = window.trans("Allow users to create new categories?");

								bind_checked(
									input_3,
									function get() {
										return options().can_add;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'can_add'], options(options().can_add = $$value, true), 78, 20);
									}
								);

								append($$anchor, fragment_3);
							}),

							$$slots: { default: true }
						}),
						'component',
						Categories,
						68,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_4 = sibling(node_3, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_4, {
							id: 'categories-category_set',
							label: window.trans("Source Category Set"),
							required: 1,

							children: wrap_snippet(Categories, ($$anchor, $$slotProps) => {
								var fragment_4 = comment();
								var node_5 = first_child(fragment_4);

								{
									var consequent = ($$anchor) => {
										var select = root_7();

										attribute_effect(select, () => ({
											...{ ref: "category_sets" },
											name: 'category_set',
											id: 'categories-category_set',
											class: 'custom-select form-control html5-form form-select'
										}));

										add_svelte_meta(
											() => each(select, 21, () => categorySets, index, ($$anchor, cs) => {
												var option = root_8();
												var text = child(option, true);

												reset(option);

												var option_value = {};

												template_effect(() => {
													set_text(text, get$1(cs).name);

													if (option_value !== (option_value = get$1(cs).id)) {
														option.value = (option.__value = get$1(cs).id) ?? '';
													}
												});

												append($$anchor, option);
											}),
											'each',
											Categories,
											98,
											8
										);

										reset(select);
										validate_binding('bind:value={options.category_set}', [], options, () => 'category_set', 96, 8);

										bind_select_value(
											select,
											function get() {
												return options().category_set;
											},
											function set($$value) {
												$$ownership_validator.mutation('options', ['options', 'category_set'], options(options().category_set = $$value, true), 96, 20);
											}
										);

										append($$anchor, select);
									};

									var alternate = ($$anchor) => {
										add_svelte_meta(
											() => StatusMsg($$anchor, {
												id: 'no-cateogry-set',
												class: 'warning',
												canClose: 0,

												$$slots: {
													msg: ($$anchor, $$slotProps) => {
														var text_1 = text();

														text_1.nodeValue = window.trans("There is no content type that can be selected. Please create new content type if you use Content Type field type.");
														append($$anchor, text_1);
													}
												}
											}),
											'component',
											Categories,
											105,
											6,
											{ componentTag: 'StatusMsg' }
										);
									};

									add_svelte_meta(
										() => if_block(node_5, ($$render) => {
											if (categorySets && categorySets.length > 0) $$render(consequent); else $$render(alternate, false);
										}),
										'if',
										Categories,
										89,
										4
									);
								}

								append($$anchor, fragment_4);
							}),

							$$slots: { default: true }
						}),
						'component',
						Categories,
						84,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					append($$anchor, fragment_1);
				}),

				$$slots: { default: true }
			}),
			'component',
			Categories,
			18,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

Tags[FILENAME] = 'src/contenttype/elements/Tags.svelte';

var root_2$3 = add_locations(from_html(`<input/><label for="tags-multiple" class="form-label"></label>`, 1), Tags[FILENAME], [[23, 4], [30, 6]]);
var root_3$2 = add_locations(from_html(`<input/>`), Tags[FILENAME], [[40, 4]]);
var root_4$2 = add_locations(from_html(`<input/>`), Tags[FILENAME], [[56, 4]]);
var root_5$2 = add_locations(from_html(`<input/>`), Tags[FILENAME], [[71, 4]]);
var root_6$1 = add_locations(from_html(`<input/><label for="tags-can_add" class="form-label"></label>`, 1), Tags[FILENAME], [[85, 4], [92, 6]]);
var root_1$4 = add_locations(from_html(`<!> <!> <!> <!> <!>`, 1), Tags[FILENAME], []);

function Tags($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;
	var _b;
	var _c;

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	if (strict_equals(options().multiple, "0")) {
		$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = 0, true), 6, 4);
	}

	if (strict_equals(options().can_add, "0")) {
		$$ownership_validator.mutation('options', ['options', 'can_add'], options(options().can_add = 0, true), 9, 4);
	}

	// changeStateMultiple was removed because unused
	strict_equals(_a = options().min, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'min'], options(options().min = "", true), 12, 53);

	strict_equals(_b = options().max, null, false) && strict_equals(_b, void 0, false)
		? _b
		: $$ownership_validator.mutation('options', ['options', 'max'], options(options().max = "", true), 13, 53);

	strict_equals(_c = options().initial_value, null, false) && strict_equals(_c, void 0, false)
		? _c
		: $$ownership_validator.mutation('options', ['options', 'initial_value'], options(options().initial_value = "", true), 14, 63);

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'tags',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(Tags, ($$anchor, $$slotProps) => {
					var fragment_1 = root_1$4();
					var node = first_child(fragment_1);

					add_svelte_meta(
						() => ContentFieldOption(node, {
							id: 'tags-multiple',
							label: window.trans("Allow users to input multiple values?"),

							children: wrap_snippet(Tags, ($$anchor, $$slotProps) => {
								var fragment_2 = root_2$3();
								var input = first_child(fragment_2);

								attribute_effect(
									input,
									() => ({
										...{ ref: "multiple" },
										type: 'checkbox',
										class: 'mt-switch form-control',
										id: 'tags-multiple',
										name: 'multiple'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:checked={options.multiple}', [], options, () => 'multiple', 29, 6);

								var label = sibling(input);

								label.textContent = window.trans("Allow users to select multiple values?");

								bind_checked(
									input,
									function get() {
										return options().multiple;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'multiple'], options(options().multiple = $$value, true), 29, 20);
									}
								);

								append($$anchor, fragment_2);
							}),

							$$slots: { default: true }
						}),
						'component',
						Tags,
						18,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_1 = sibling(node, 2);

					{
						let $0 = user_derived(() => options().multiple ? true : false);

						add_svelte_meta(
							() => ContentFieldOption(node_1, {
								id: 'tags-min',
								label: window.trans("Minimum number of selections"),

								get attrShow() {
									return get$1($0);
								},

								children: wrap_snippet(Tags, ($$anchor, $$slotProps) => {
									var input_1 = root_3$2();

									attribute_effect(
										input_1,
										() => ({
											...{ ref: "min" },
											type: 'number',
											name: 'min',
											id: 'tags-min',
											class: 'form-control w-25',
											min: '0'
										}),
										void 0,
										void 0,
										void 0,
										void 0,
										true
									);

									validate_binding('bind:value={options.min}', [], options, () => 'min', 47, 6);

									bind_value(
										input_1,
										function get() {
											return options().min;
										},
										function set($$value) {
											$$ownership_validator.mutation('options', ['options', 'min'], options(options().min = $$value, true), 47, 18);
										}
									);

									append($$anchor, input_1);
								}),

								$$slots: { default: true }
							}),
							'component',
							Tags,
							35,
							2,
							{ componentTag: 'ContentFieldOption' }
						);
					}

					var node_2 = sibling(node_1, 2);

					{
						let $0 = user_derived(() => options().multiple ? true : false);

						add_svelte_meta(
							() => ContentFieldOption(node_2, {
								id: 'tags-max',
								label: window.trans("Maximum number of selections"),

								get attrShow() {
									return get$1($0);
								},

								children: wrap_snippet(Tags, ($$anchor, $$slotProps) => {
									var input_2 = root_4$2();

									attribute_effect(
										input_2,
										() => ({
											...{ ref: "max" },
											type: 'number',
											name: 'max',
											id: 'tags-max',
											class: 'form-control w-25',
											min: '1'
										}),
										void 0,
										void 0,
										void 0,
										void 0,
										true
									);

									validate_binding('bind:value={options.max}', [], options, () => 'max', 63, 6);

									bind_value(
										input_2,
										function get() {
											return options().max;
										},
										function set($$value) {
											$$ownership_validator.mutation('options', ['options', 'max'], options(options().max = $$value, true), 63, 18);
										}
									);

									append($$anchor, input_2);
								}),

								$$slots: { default: true }
							}),
							'component',
							Tags,
							51,
							2,
							{ componentTag: 'ContentFieldOption' }
						);
					}

					var node_3 = sibling(node_2, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_3, {
							id: 'tags-initial_value',
							label: window.trans("Initial Value"),

							children: wrap_snippet(Tags, ($$anchor, $$slotProps) => {
								var input_3 = root_5$2();

								attribute_effect(
									input_3,
									() => ({
										...{ ref: "initial_value" },
										type: 'text',
										name: 'initial_value',
										id: 'tags-initial_value',
										class: 'form-control'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.initial_value}', [], options, () => 'initial_value', 77, 6);

								bind_value(
									input_3,
									function get() {
										return options().initial_value;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'initial_value'], options(options().initial_value = $$value, true), 77, 18);
									}
								);

								append($$anchor, input_3);
							}),

							$$slots: { default: true }
						}),
						'component',
						Tags,
						67,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_4 = sibling(node_3, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_4, {
							id: 'tags-can_add',
							label: window.trans("Allow users to create new tags?"),

							children: wrap_snippet(Tags, ($$anchor, $$slotProps) => {
								var fragment_3 = root_6$1();
								var input_4 = first_child(fragment_3);

								attribute_effect(
									input_4,
									() => ({
										...{ ref: "can_add" },
										type: 'checkbox',
										class: 'mt-switch form-control',
										id: 'tags-can_add',
										name: 'can_add'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:checked={options.can_add}', [], options, () => 'can_add', 91, 6);

								var label_1 = sibling(input_4);

								label_1.textContent = window.trans("Allow users to create new tags?");

								bind_checked(
									input_4,
									function get() {
										return options().can_add;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'can_add'], options(options().can_add = $$value, true), 91, 20);
									}
								);

								append($$anchor, fragment_3);
							}),

							$$slots: { default: true }
						}),
						'component',
						Tags,
						81,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					append($$anchor, fragment_1);
				}),

				$$slots: { default: true }
			}),
			'component',
			Tags,
			17,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

List[FILENAME] = 'src/contenttype/elements/List.svelte';

function List($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'list',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				}
			}),
			'component',
			List,
			5,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

Tables[FILENAME] = 'src/contenttype/elements/Tables.svelte';

var root_2$2 = add_locations(from_html(`<input/>`), Tables[FILENAME], [[20, 4]]);
var root_3$1 = add_locations(from_html(`<input/>`), Tables[FILENAME], [[35, 4]]);
var root_4$1 = add_locations(from_html(`<input/><label for="tables-can_increase_decrease_rows" class="form-label"></label>`, 1), Tables[FILENAME], [[50, 4], [57, 6]]);
var root_5$1 = add_locations(from_html(`<input/><label for="tables-can_increase_decrease_cols" class="form-label"></label>`, 1), Tables[FILENAME], [[66, 4], [73, 6]]);
var root_1$3 = add_locations(from_html(`<!> <!> <!> <!>`, 1), Tables[FILENAME], []);

function Tables($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;
	var _b;

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	if (strict_equals(options().increase_decrease_rows, "0")) {
		$$ownership_validator.mutation('options', ['options', 'increase_decrease_rows'], options(options().increase_decrease_rows = 0, true), 6, 4);
	}

	if (strict_equals(options().increase_decrease_cols, "0")) {
		$$ownership_validator.mutation('options', ['options', 'increase_decrease_cols'], options(options().increase_decrease_cols = 0, true), 9, 4);
	}

	strict_equals(_a = options().initial_rows, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'initial_rows'], options(options().initial_rows = 1, true), 11, 62);

	strict_equals(_b = options().initial_cols, null, false) && strict_equals(_b, void 0, false)
		? _b
		: $$ownership_validator.mutation('options', ['options', 'initial_cols'], options(options().initial_cols = 1, true), 12, 62);

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'table',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(Tables, ($$anchor, $$slotProps) => {
					var fragment_1 = root_1$3();
					var node = first_child(fragment_1);

					add_svelte_meta(
						() => ContentFieldOption(node, {
							id: 'tables-initial_rows',
							label: window.trans("Initial Rows"),

							children: wrap_snippet(Tables, ($$anchor, $$slotProps) => {
								var input = root_2$2();

								attribute_effect(
									input,
									() => ({
										...{ ref: "initial_rows" },
										type: 'number',
										name: 'initial_rows',
										id: 'tables-initial_rows',
										class: 'form-control w-25',
										min: '1'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.initial_rows}', [], options, () => 'initial_rows', 27, 6);

								bind_value(
									input,
									function get() {
										return options().initial_rows;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'initial_rows'], options(options().initial_rows = $$value, true), 27, 18);
									}
								);

								append($$anchor, input);
							}),

							$$slots: { default: true }
						}),
						'component',
						Tables,
						16,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_1 = sibling(node, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_1, {
							id: 'tables-initial_cols',
							label: window.trans("Initial Cols"),

							children: wrap_snippet(Tables, ($$anchor, $$slotProps) => {
								var input_1 = root_3$1();

								attribute_effect(
									input_1,
									() => ({
										...{ ref: "initial_cols" },
										type: 'number',
										name: 'initial_cols',
										id: 'tables-initial_cols',
										class: 'form-control w-25',
										min: '1'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:value={options.initial_cols}', [], options, () => 'initial_cols', 42, 6);

								bind_value(
									input_1,
									function get() {
										return options().initial_cols;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'initial_cols'], options(options().initial_cols = $$value, true), 42, 18);
									}
								);

								append($$anchor, input_1);
							}),

							$$slots: { default: true }
						}),
						'component',
						Tables,
						31,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_2 = sibling(node_1, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_2, {
							id: 'tables-can_increase_decrease_rows',
							label: window.trans("Allow users to increase/decrease rows?"),

							children: wrap_snippet(Tables, ($$anchor, $$slotProps) => {
								var fragment_2 = root_4$1();
								var input_2 = first_child(fragment_2);

								attribute_effect(
									input_2,
									() => ({
										...{ ref: "increase_decrease_rows" },
										type: 'checkbox',
										class: 'mt-switch form-control',
										id: 'tables-can_increase_decrease_rows',
										name: 'increase_decrease_rows'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:checked={options.increase_decrease_rows}', [], options, () => 'increase_decrease_rows', 56, 6);

								var label = sibling(input_2);

								label.textContent = window.trans("Allow users to increase/decrease rows?");

								bind_checked(
									input_2,
									function get() {
										return options().increase_decrease_rows;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'increase_decrease_rows'], options(options().increase_decrease_rows = $$value, true), 56, 20);
									}
								);

								append($$anchor, fragment_2);
							}),

							$$slots: { default: true }
						}),
						'component',
						Tables,
						46,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					var node_3 = sibling(node_2, 2);

					add_svelte_meta(
						() => ContentFieldOption(node_3, {
							id: 'tables-can_increase_decrease_cols',
							label: window.trans("Allow users to increase/decrease cols?"),

							children: wrap_snippet(Tables, ($$anchor, $$slotProps) => {
								var fragment_3 = root_5$1();
								var input_3 = first_child(fragment_3);

								attribute_effect(
									input_3,
									() => ({
										...{ ref: "increase_decrease_cols" },
										type: 'checkbox',
										class: 'mt-switch form-control',
										id: 'tables-can_increase_decrease_cols',
										name: 'increase_decrease_cols'
									}),
									void 0,
									void 0,
									void 0,
									void 0,
									true
								);

								validate_binding('bind:checked={options.increase_decrease_cols}', [], options, () => 'increase_decrease_cols', 72, 6);

								var label_1 = sibling(input_3);

								label_1.textContent = window.trans("Allow users to increase/decrease cols?");

								bind_checked(
									input_3,
									function get() {
										return options().increase_decrease_cols;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'increase_decrease_cols'], options(options().increase_decrease_cols = $$value, true), 72, 20);
									}
								);

								append($$anchor, fragment_3);
							}),

							$$slots: { default: true }
						}),
						'component',
						Tables,
						62,
						2,
						{ componentTag: 'ContentFieldOption' }
					);

					append($$anchor, fragment_1);
				}),

				$$slots: { default: true }
			}),
			'component',
			Tables,
			15,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

TextLabel[FILENAME] = 'src/contenttype/elements/TextLabel.svelte';

var root_2$1 = add_locations(from_html(`<textarea></textarea>`), TextLabel[FILENAME], [[24, 4]]);

function TextLabel($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);
	var _a;

	let field = prop($$props, 'field', 15);
		prop($$props, 'gather', 11, null);
		let options = prop($$props, 'options', 15);

	strict_equals(_a = options().text, null, false) && strict_equals(_a, void 0, false)
		? _a
		: $$ownership_validator.mutation('options', ['options', 'text'], options(options().text = "", true), 6, 54);

	onMount(() => {
		// description, required, display field is hidden.
		document.getElementById("text-label-description-field-" + $$props.id).style.display = "none";

		document.getElementById("text-label-required-field-" + $$props.id).style.display = "none";
		document.getElementById("text-label-display-field-" + $$props.id).style.display = "none";
	});

	var $$exports = { ...legacy_api() };

	{
		$$ownership_validator.binding('field', ContentFieldOptionGroup, field);
		$$ownership_validator.binding('options', ContentFieldOptionGroup, options);

		add_svelte_meta(
			() => ContentFieldOptionGroup($$anchor, {
				type: 'text-label',

				get id() {
					return $$props.id;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get options() {
					return options();
				},

				set options($$value) {
					options($$value);
				},

				children: wrap_snippet(TextLabel, ($$anchor, $$slotProps) => {
					add_svelte_meta(
						() => ContentFieldOption($$anchor, {
							id: 'text_label-text',
							label: window.trans("__TEXT_LABEL_TEXT"),
							hint: window.trans("This block is only visible in the administration screen for comments."),
							showHint: 1,

							children: wrap_snippet(TextLabel, ($$anchor, $$slotProps) => {
								var textarea = root_2$1();

								remove_textarea_child(textarea);

								attribute_effect(textarea, () => ({
									...{ ref: "text" },
									name: 'text',
									id: 'text_label-text',
									class: 'form-control'
								}));

								validate_binding('bind:value={options.text}', [], options, () => 'text', 29, 6);

								bind_value(
									textarea,
									function get() {
										return options().text;
									},
									function set($$value) {
										$$ownership_validator.mutation('options', ['options', 'text'], options(options().text = $$value, true), 29, 18);
									}
								);

								append($$anchor, textarea);
							}),

							$$slots: { default: true }
						}),
						'component',
						TextLabel,
						16,
						2,
						{ componentTag: 'ContentFieldOption' }
					);
				}),

				$$slots: { default: true }
			}),
			'component',
			TextLabel,
			15,
			0,
			{ componentTag: 'ContentFieldOptionGroup' }
		);
	}

	return pop($$exports);
}

class ContentFieldTypes {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  static getCoreType(type) {
    return !this.customTypes[type] && this.coreTypes[type];
  }
  static getCustomType(type) {
    return this.customTypes[type];
  }
  static registerCustomType(type, mountFunction) {
    this.customTypes[type] = mountFunction;
  }
}
ContentFieldTypes.coreTypes = {
  "content-type": ContentType,
  "single-line-text": SingleLineText,
  "multi-line-text": MultiLineText,
  number: Number$1,
  url: Url,
  "date-and-time": DateTime,
  "date-only": Date$1,
  "time-only": Time,
  "select-box": SelectBox,
  "radio-button": RadioButton,
  checkboxes: Checkboxes,
  asset: Asset,
  "asset-audio": AssetAudio,
  "asset-video": AssetVideo,
  "asset-image": AssetImage,
  "embedded-text": EmbeddedText,
  categories: Categories,
  tags: Tags,
  list: List,
  tables: Tables,
  "text-label": TextLabel
};
ContentFieldTypes.customTypes = {};

Custom[FILENAME] = 'src/contenttype/elements/Custom.svelte';

var root$2 = add_locations(from_html(`<div class="mt-custom-contentfield"></div>`), Custom[FILENAME], [[36, 0]]);

function Custom($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	const $fieldsStore = () => (
		validate_store($$props.fieldsStore),
		store_get($$props.fieldsStore, '$fieldsStore', $$stores)
	);

	const [$$stores, $$cleanup] = setup_stores();
	let gather = prop($$props, 'gather', 15);
	let customContentFieldObject = tag(state(null), 'customContentFieldObject');
	let target = tag(state(null), 'target');
	let type = tag(state(null), 'type');
	let field = tag(user_derived(() => $fieldsStore()[$$props.fieldIndex]), 'field');
	let customContentFieldMountFunction = tag(user_derived(() => ContentFieldTypes.getCustomType(get$1(field).type)), 'customContentFieldMountFunction');

	user_effect(() => {
		if (strict_equals(get$1(field).type, get$1(type), false) && get$1(customContentFieldObject)) {
			get$1(customContentFieldObject).destroy();
			set(customContentFieldObject, null);
			gather(null);
		}

		if (!get$1(customContentFieldObject) && get$1(customContentFieldMountFunction) && get$1(target)) {
			set(
				customContentFieldObject,
				get$1(customContentFieldMountFunction)(
					{
						config: $$props.config,
						fieldIndex: $$props.fieldIndex,
						fieldsStore: $$props.fieldsStore,
						optionsHtmlParams: $$props.optionsHtmlParams
					},
					get$1(target)
				),
				true
			);

			gather(strict_equals(get$1(customContentFieldObject), null) || strict_equals(get$1(customContentFieldObject), void 0) ? void 0 : get$1(customContentFieldObject).gather);
		}

		set(type, get$1(field).type, true);

		return () => {
			if (get$1(customContentFieldObject)) {
				gather(null);
				get$1(customContentFieldObject).destroy();
				set(customContentFieldObject, null);
			}

			set(type, null);
		};
	});

	var $$exports = { ...legacy_api() };
	var div = root$2();

	bind_this(div, ($$value) => set(target, $$value), () => get$1(target));
	template_effect(() => set_attribute(div, 'id', `custom-content-field-block-${get$1(field).id ?? ''}`));
	append($$anchor, div);

	var $$pop = pop($$exports);

	$$cleanup();

	return $$pop;
}

SVG[FILENAME] = 'src/svg/elements/SVG.svelte';

var root_1$2 = add_locations(from_svg(`<title> </title>`), SVG[FILENAME], [[10, 4]]);
var root$1 = add_locations(from_svg(`<svg role="img"><!><use></use></svg>`), SVG[FILENAME], [[8, 0, [[12, 2]]]]);

function SVG($$anchor, $$props) {
	check_target(new.target);
	push($$props, false);

	let className = prop($$props, 'class', 8);
	let href = prop($$props, 'href', 8);
	let title = prop($$props, 'title', 8);
	let style = prop($$props, 'style', 8, undefined);
	var $$exports = { ...legacy_api() };
	var svg = root$1();
	var node = child(svg);

	{
		var consequent = ($$anchor) => {
			var title_1 = root_1$2();
			var text = child(title_1);
			template_effect(() => set_text(text, title()));
			append($$anchor, title_1);
		};

		add_svelte_meta(
			() => if_block(node, ($$render) => {
				if (title()) $$render(consequent);
			}),
			'if',
			SVG,
			9,
			2
		);
	}

	var use = sibling(node);

	template_effect(() => {
		set_class(svg, 0, clsx(className()));
		set_style(svg, style());
		set_xlink_attribute(use, 'xlink:href', href());
	});

	append($$anchor, svg);

	return pop($$exports);
}

ContentField[FILENAME] = 'src/contenttype/elements/ContentField.svelte';

var root_1$1 = add_locations(from_html(`<span> </span>`), ContentField[FILENAME], [[81, 22]]);

var root = add_locations(from_html(`<div class="mt-collapse__container"><div class="col-auto p-0"><!></div> <div class="col text-wrap p-0"><!> <!></div> <div class="col-auto p-0"><a href="javascript:void(0)" class="d-inline-block duplicate-content-field"><!></a> <a href="javascript:void(0)" class="d-inline-block delete-content-field"><!></a> <a data-bs-toggle="collapse" class="d-inline-block"><!></a></div></div> <div><!> <!></div>`, 1), ContentField[FILENAME], [
	[
		66,
		0,
		[[67, 2], [74, 2], [83, 2, [[85, 4], [96, 4], [106, 4]]]]
	],

	[120, 0]
]);

function ContentField($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);

	let field = prop($$props, 'field', 7),
		fields = prop($$props, 'fields', 7),
		parent = prop($$props, 'parent', 7),
		gather = prop($$props, 'gather', 7);

	let id = tag(user_derived(() => `field-options-${field().id}`), 'id');

	user_effect(() => {
		if (strict_equals(field().isNew, null)) {
			$$ownership_validator.mutation('field', ['field', 'isNew'], field().isNew = false, 9, 8);
		}

		if (strict_equals(field().isShow, null)) {
			$$ownership_validator.mutation('field', ['field', 'isShow'], field().isShow = "", 12, 8);
		}

		if (strict_equals(field().realId, null)) {
			$$ownership_validator.mutation('field', ['field', 'realId'], field().realId = "", 15, 8);
		}

		if (strict_equals(field().options, null)) {
			$$ownership_validator.mutation('field', ['field', 'options'], field().options = {}, 18, 8);
		}
	});

	let gatherCore;
	let gatherCustom;

	user_effect(() => {
		if (ContentFieldTypes.getCoreType(field().type)) {
			gather(gatherCore);
		} else {
			gather(gatherCustom);
		}
	});

	const deleteField = () => {
		const label = field().label ? field().label : window.trans("No Name");

		if (!confirm(window.trans("Do you want to delete [_1]([_2])?", label, field().typeLabel))) {
			return;
		}

		fields(fields().slice(0, $$props.fieldIndex).concat(fields().slice($$props.fieldIndex + 1)));

		// update is not needed in Svelte
		const target = document.getElementsByClassName("mt-draggable__area")[0];

		recalcHeight(target);
	};

	const duplicateField = () => {
		const newItem = jQuery.extend({}, field());

		newItem.options = $$props.gatheringData(parent(), $$props.fieldIndex);
		newItem.id = Math.random().toString(36).slice(-8);

		let label = field().label;

		if (!label) {
			label = jQuery("#content-field-block-" + field().id).find('[name="label"]').val();

			if (strict_equals(label, "")) {
				label = window.trans("No Name");
			}
		}

		newItem.label = window.trans("Duplicate") + "-" + label;
		newItem.options.label = newItem.label;
		newItem.order = fields().length + 1;
		newItem.isNew = true;
		newItem.isShow = "show";
		fields([...fields(), newItem]);

		const target = document.getElementsByClassName("mt-draggable__area")[0];

		recalcHeight(target);

		// update is not needed in Svelte
	};

	var $$exports = { ...legacy_api() };
	var fragment = root();
	var div = first_child(fragment);
	var div_1 = child(div);
	var node = child(div_1);

	add_svelte_meta(
		() => SVG(node, {
			title: window.trans("Move"),
			class: 'mt-icon',
			href: `${window.StaticURI ?? ''}/images/sprite.svg#ic_move`
		}),
		'component',
		ContentField,
		68,
		4,
		{ componentTag: 'SVG' }
	);

	var div_2 = sibling(div_1, 2);
	var node_1 = child(div_2);

	add_svelte_meta(
		() => SVG(node_1, {
			title: window.trans("ContentField"),
			class: 'mt-icon--secondary',
			href: `${window.StaticURI ?? ''}images/sprite.svg#ic_contentstype`
		}),
		'component',
		ContentField,
		75,
		4,
		{ componentTag: 'SVG' }
	);

	var text = sibling(node_1);
	var node_2 = sibling(text);

	{
		var consequent = ($$anchor) => {
			var span = root_1$1();
			var text_1 = child(span);
			template_effect(() => set_text(text_1, `(ID: ${field().realId ?? ''})`));
			append($$anchor, span);
		};

		add_svelte_meta(
			() => if_block(node_2, ($$render) => {
				if (field().realId) $$render(consequent);
			}),
			'if',
			ContentField,
			81,
			4
		);
	}

	var div_3 = sibling(div_2, 2);
	var a = child(div_3);

	a.__click = duplicateField;

	var node_3 = child(a);

	add_svelte_meta(
		() => SVG(node_3, {
			title: window.trans("Duplicate"),
			class: 'mt-icon--secondary',
			href: `${window.StaticURI ?? ''}images/sprite.svg#ic_duplicate`
		}),
		'component',
		ContentField,
		89,
		7,
		{ componentTag: 'SVG' }
	);

	var a_1 = sibling(a, 2);

	a_1.__click = deleteField;

	var node_4 = child(a_1);

	add_svelte_meta(
		() => SVG(node_4, {
			title: window.trans("Delete"),
			class: 'mt-icon--secondary',
			href: `${window.StaticURI ?? ''}images/sprite.svg#ic_trash`
		}),
		'component',
		ContentField,
		100,
		7,
		{ componentTag: 'SVG' }
	);

	var a_2 = sibling(a_1, 2);
	var node_5 = child(a_2);

	add_svelte_meta(
		() => SVG(node_5, {
			title: window.trans("Edit"),
			class: 'mt-icon--secondary',
			href: `${window.StaticURI ?? ''}images/sprite.svg#ic_collapse`
		}),
		'component',
		ContentField,
		112,
		7,
		{ componentTag: 'SVG' }
	);

	var div_4 = sibling(div, 2);

	attribute_effect(div_4, () => ({
		'data-is': field().type,
		class: 'collapse mt-collapse__content',
		id: get$1(id),
		...{ fieldid: field().id, isnew: field().isNew },
		[CLASS]: { show: strict_equals(field().isShow, "show") }
	}));

	var node_6 = child(div_4);

	validate_binding('bind:options={field.options}', [], field, () => 'options');

	add_svelte_meta(
		() => component(node_6, () => ContentFieldTypes.getCoreType(field().type), ($$anchor, $$component) => {
			$$ownership_validator.binding('field', $$component, field);
			$$ownership_validator.binding('field', $$component, () => field().options);

			$$component($$anchor, {
				get config() {
					return $$props.config;
				},

				get id() {
					return get$1(id);
				},

				get optionsHtmlParams() {
					return $$props.optionsHtmlParams;
				},

				get field() {
					return field();
				},

				set field($$value) {
					field($$value);
				},

				get gather() {
					return gatherCore;
				},

				set gather($$value) {
					gatherCore = $$value;
				},

				get options() {
					return field().options;
				},

				set options($$value) {
					$$ownership_validator.mutation('field', ['field', 'options'], field().options = $$value, 134, 18);
				}
			});
		}),
		'component',
		ContentField,
		128,
		2,
		{ componentTag: 'svelte:component' }
	);

	var node_7 = sibling(node_6, 2);

	add_svelte_meta(
		() => Custom(node_7, {
			get config() {
				return $$props.config;
			},

			get fieldIndex() {
				return $$props.fieldIndex;
			},

			get fieldsStore() {
				return $$props.fieldsStore;
			},

			get optionsHtmlParams() {
				return $$props.optionsHtmlParams;
			},

			get gather() {
				return gatherCustom;
			},

			set gather($$value) {
				gatherCustom = $$value;
			}
		}),
		'component',
		ContentField,
		137,
		2,
		{ componentTag: 'Custom' }
	);
	bind_this(div_4, ($$value) => parent($$value), () => parent());

	template_effect(() => {
		set_text(text, ` ${field().label ?? "" ?? ''} (${field().typeLabel ?? ''}) `);
		set_attribute(a_2, 'href', `#field-options-${field().id ?? ''}`);
		set_attribute(a_2, 'aria-expanded', strict_equals(field().isShow, "show") ? "true" : "false");
		set_attribute(a_2, 'aria-controls', `field-options-${field().id ?? ''}`);
	});

	append($$anchor, fragment);

	return pop($$exports);
}

delegate(['click']);

ContentFields[FILENAME] = 'src/contenttype/elements/ContentFields.svelte';

var root_3 = add_locations(from_html(`<option> </option>`), ContentFields[FILENAME], [[511, 26]]);

var root_2 = add_locations(from_html(`<div id="name-field" class="form-group"><h3> <button type="button" class="btn btn-link" data-bs-toggle="modal" data-bs-target="#editDetail"></button></h3> <div id="editDetail" class="modal" data-role="dialog" aria-labelledby="editDetail" aria-hidden="true"><div class="modal-dialog modal-lg" data-role="document"><div class="modal-content"><div class="modal-header"><h4 class="modal-title"></h4> <button type="button" class="close btn-close" data-bs-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div> <div class="modal-body"><div class="col"><div id="name-field" class="form-group"><label for="name" class="form-control-label"> <span class="badge badge-danger"></span></label> <input type="text" name="name" id="name" class="form-control html5-form" required/></div></div> <div class="col"><div id="description-field" class="form-group"><label for="description" class="form-control-label"></label> <textarea name="description" id="description" class="form-control"></textarea></div></div> <div class="col"><div id="label-field" class="form-group"><label for="label_field" class="form-control-label"></label> <select id="label_field" name="label_field" class="custom-select form-control html5-form form-select"><option></option><!></select></div></div> <div class="col"><div id="unique_id-field" class="form-group"><label for="unique_id" class="form-control-label"></label> <input type="text" class="form-control-plaintext w-50" id="unieuq_id" readonly=""/></div></div> <div class="col"><div id="user_disp_option-field" class="form-group"><label for="user_disp_option"></label> <input type="checkbox" class="mt-switch form-control" id="user_disp_option" name="user_disp_option"/> <label for="user_disp_option" class="last-child"></label></div></div></div> <div class="modal-footer"><button type="button" class="btn btn-default" data-bs-dismiss="modal"></button></div></div></div></div></div>`), ContentFields[FILENAME], [
	[
		431,
		8,

		[
			[432, 10, [[434, 12]]],

			[
				441,
				10,

				[
					[
						448,
						12,

						[
							[
								449,
								14,

								[
									[450, 16, [[451, 18], [452, 18, [[458, 20]]]]],

									[
										461,
										16,

										[
											[462, 18, [[463, 20, [[464, 22, [[466, 24]]], [470, 22]]]]],
											[481, 18, [[482, 20, [[483, 22], [486, 22]]]]],
											[493, 18, [[494, 20, [[495, 22], [499, 22, [[505, 24]]]]]]],
											[518, 18, [[519, 20, [[520, 22], [523, 22]]]]],
											[532, 18, [[533, 20, [[534, 22], [541, 22], [548, 22]]]]]
										]
									],

									[556, 16, [[557, 18]]]
								]
							]
						]
					]
				]
			]
		]
	]
]);

var root_4 = add_locations(from_html(`<div id="name-field" class="form-group"><label for="name" class="form-control-label"> <span class="badge badge-danger"></span></label> <input type="text" name="name" id="name" class="form-control html5-form" required/></div>`), ContentFields[FILENAME], [[568, 8, [[569, 10, [[571, 12]]], [574, 10]]]]);
var root_5 = add_locations(from_html(`<div class="mt-draggable__empty"><img width="240" height="120"/> <p></p></div>`), ContentFields[FILENAME], [[618, 8, [[619, 10], [625, 10]]]]);
var root_6 = add_locations(from_html(`<div class="mt-contentfield" draggable="true" aria-grabbed="false" data-is="content-field" style="width: 100%;"><!></div>`), ContentFields[FILENAME], [[630, 8]]);

var root_1 = add_locations(from_html(`<form name="content-type-form" method="POST"><input type="hidden" name="__mode" value="save"/> <input type="hidden" name="blog_id"/> <input type="hidden" name="magic_token"/> <input type="hidden" name="return_args"/> <input type="hidden" name="_type" value="content_type"/> <input type="hidden" name="id"/> <div class="row"><div class="col"><!></div></div></form> <form><fieldset id="content-fields" class="form-group"><legend class="h3"></legend> <div class="mt-collapse__all"><a data-bs-toggle="collapse" href="" class="d-inline-block"> <!></a></div> <div class="mt-draggable__area" style="height:400px;"><!> <!></div> <div class="mt-collapse__all"><a data-bs-toggle="collapse" href=".mt-collapse__content" class="d-inline-block"> <!></a></div></fieldset></form> <button type="button" class="btn btn-primary"></button>`, 1), ContentFields[FILENAME], [
	[
		419,
		0,

		[
			[420, 2],
			[421, 2],
			[422, 2],
			[423, 2],
			[424, 2],
			[425, 2],
			[428, 2, [[429, 4]]]
		]
	],

	[
		589,
		0,

		[
			[
				590,
				2,

				[
					[591, 4],
					[592, 4, [[594, 6]]],
					[610, 4],
					[657, 4, [[658, 6]]]
				]
			]
		]
	],

	[675, 0]
]);

function ContentFields($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$ownership_validator = create_ownership_validator($$props);

	const $fieldsStore = () => (
		validate_store($$props.fieldsStore),
		store_get($$props.fieldsStore, '$fieldsStore', $$stores)
	);

	const [$$stores, $$cleanup] = setup_stores();
	let opts = prop($$props, 'opts', 7);
	let isEmpty = tag_proxy(proxy($fieldsStore().length > 0 ? false : true), 'isEmpty');
	let data = "";
	let droppable = false;
	const observer = opts().observer;
	let dragged = null;
	let draggedItem = null;
	const placeholder = document.createElement("div");

	placeholder.className = "placeholder";

	let dragoverState = false;
	let labelFields = [];
	let labelField = opts().labelField;
	let isExpanded = false;
	const gathers = {};
	const tags = [];

	user_effect(() => {
		const select = $$props.root.querySelector("#label_field");

		if (!select) return;

		jQuery(select).find("option").each(function (index, option) {
			if (option.attributes.getNamedItem("selected")) {
				select.selectedIndex = index;

				return false;
			}
		});
	});

	// Drag start from content field list
	observer.on("mtDragStart", function () {
		droppable = true;
	});

	// Drag end from content field list
	observer.on("mtDragEnd", function () {
		droppable = false;
		onDragEnd();
	});

	// Show detail modal
	jQuery(document).on("show.bs.modal", "#editDetail", function () {
		rebuildLabelFields();

		// update is not needed in Svelte
	});

	// Hide detail modal
	jQuery(document).on("hide.bs.modal", "#editDetail", function () {
		var _a;

		/* @ts-expect-error : mtValidate is not defined */
		if (jQuery("#name-field > input").mtValidate("simple")) {
			$$ownership_validator.mutation('opts', ['opts', 'name'], opts().name = (strict_equals(_a = jQuery("#name-field > input").val(), null) || strict_equals(_a, void 0) ? void 0 : _a.toString()) || "", 51, 8);
			window.setDirty(true);

			// update is not needed in Svelte
		} else {
			return false;
		}
	});

	// Shown collaped block
	jQuery(document).on("shown.bs.collapse", ".mt-collapse__content", function () {
		const target = document.getElementsByClassName("mt-draggable__area")[0];

		recalcHeight(target);
		updateFieldsIsShowAll(); // need to update in Svelte
		updateToggleAll();
	});

	// Hide collaped block
	jQuery(document).on("hidden.bs.collapse", ".mt-collapse__content", function () {
		const target = document.getElementsByClassName("mt-draggable__area")[0];

		recalcHeight(target);
		updateFieldsIsShowAll(); // need to update in Svelte
		updateToggleAll();
	});

	// Cannot drag while focusing on input / textarea
	jQuery(document).on("focus", ".mt-draggable__area input, .mt-draggable__area textarea", function () {
		jQuery(this).closest(".mt-contentfield").attr("draggable", "false");
	});

	// Set draggable back to true while not focusing on input / textarea
	jQuery(document).on("blur", ".mt-draggable__area input, .mt-draggable__area textarea", function () {
		jQuery(this).closest(".mt-contentfield").attr("draggable", "true");
	});

	const onDragOver = (e) => {
		// Allowed only for Content Field and Content Field Type.
		if (droppable) {
			const currentTarget = e.currentTarget;
			const target = e.target;

			if (strict_equals(target.className, "mt-draggable__area", false) && strict_equals(target.className, "mt-draggable", false) && strict_equals(target.className, "mt-contentfield", false)) {
				e.preventDefault();

				return;
			}

			// Highlight droppable area
			if (!dragoverState) {
				// replace with e.currentTarget in Svelte
				currentTarget.classList.add("mt-draggable__area--dragover");

				dragoverState = true;
			}

			if (dragged) {
				if (strict_equals(target.className, "mt-contentfield")) {
					// Inside the dragOver method
					// comment out because unused
					// self.over = e.target;
					const targetRect = target.getBoundingClientRect();

					const parent = target.parentNode;

					if ((e.clientY - targetRect.top) / targetRect.height > 0.5) {
						parent.insertBefore(placeholder, target.nextElementSibling);
					} else {
						parent.insertBefore(placeholder, target);
					}
				}

				if (strict_equals(target.className, "mt-draggable__area")) {
					const fieldElements = target.getElementsByClassName("mt-contentfield");

					if (strict_equals(fieldElements.length, 0) || strict_equals(fieldElements.length, 1) && strict_equals(fieldElements[0], dragged)) {
						target.appendChild(placeholder);
					}
				}
			} else {
				// Dragged from content field types
				// replace with e.currentTarget in Svelte
				currentTarget.appendChild(placeholder);
			}

			e.preventDefault();
		}
	};

	const onDrop = (e) => {
		var _a;
		const currentTarget = e.currentTarget;

		if (dragged) {
			let pos = 0;
			let children = null;

			if (placeholder.parentNode) {
				children = placeholder.parentNode.children;
			}

			if (!children) {
				currentTarget.classList.remove("mt-draggable__area--dragover");
				e.preventDefault();

				return;
			}

			for (let i = 0; i < children.length; i++) {
				if (strict_equals(children[i], placeholder)) break;

				if (strict_equals(children[i], dragged, false) && children[i].classList.contains("mt-contentfield")) {
					pos++;
				}
			}

			if (draggedItem) {
				_moveField(draggedItem, pos);
			}

			window.setDirty(true);

			// update is not needed in Svelte
		} else {
			// Drag from field list
			const fieldType = (strict_equals(_a = e.dataTransfer, null) || strict_equals(_a, void 0) ? void 0 : _a.getData("text")) || "";

			const field = jQuery("[data-field-type='" + fieldType + "']");
			const fieldTypeLabel = field.data("field-label");
			const canDataLabel = field.data("can-data-label");
			const newId = Math.random().toString(36).slice(-8);

			const newField = {
				type: fieldType,
				typeLabel: fieldTypeLabel,
				id: newId,
				isNew: true,
				isShow: "show",
				canDataLabel,
				options: {} // add in Svelte
			};

			$$props.fieldsStore.update((fields) => [...fields, newField]);
			window.setDirty(true);

			// update is not needed in Svelte
			recalcHeight(document.getElementsByClassName("mt-draggable__area")[0]);
		}

		rebuildLabelFields();
		currentTarget.classList.remove("mt-draggable__area--dragover");
		e.preventDefault();
	};

	const onDragLeave = (e) => {
		if (dragoverState) {
			// replace with e.currentTarget in Svelte
			e.currentTarget.classList.remove("mt-draggable__area--dragover");

			dragoverState = false;
		}
	};

	const onDragStart = (e, f) => {
		dragged = e.target;
		draggedItem = f;
		e.dataTransfer.setData("text", f.id || "");
		droppable = true;
	};

	const onDragEnd = () => {
		if (placeholder.parentNode) {
			placeholder.parentNode.removeChild(placeholder);
		}

		droppable = false;
		dragged = null;
		draggedItem = null;
		dragoverState = false;

		// update is not needed in Svelte
	};

	const stopSubmitting = (e) => {
		// e.which is deprecate
		if (strict_equals(e.key, "Enter")) {
			e.preventDefault();

			return false;
		}

		return true;
	};

	const canSubmit = () => {
		if (strict_equals($fieldsStore().length, 0)) {
			return true;
		}

		const invalidFields = $fieldsStore().filter(function (field) {
			return opts().invalid_types[field.type];
		});

		return strict_equals(invalidFields.length, 0) ? true : false;
	};

	const submit = () => {
		if (!canSubmit()) {
			return;
		}

		if (!_validateFields()) {
			return;
		}

		rebuildLabelFields();
		window.setDirty(false);

		const fieldOptions = [];

		if ($fieldsStore()) {
			for (let i = 0; i < $fieldsStore().length; i++) {
				const c = tags[i];
				const options = gatheringData(c, i);
				const newData = {};

				newData.type = $fieldsStore()[i].type;
				newData.options = options;

				if (!$fieldsStore()[i].isNew && options["id"].match(/^\d+$/)) {
					newData.id = options["id"];
				}

				const innerField = $fieldsStore().filter(function (v) {
					return strict_equals(v.id, newData.id);
				});

				if (innerField.length && innerField[0].order) {
					newData.order = innerField[0].order;
				} else {
					newData.order = i + 1;
				}

				fieldOptions.push(newData);
			}

			data = JSON.stringify(fieldOptions);
		} else {
			data = "";
		}

		// bind:value={data} does not work
		addInputData();

		// update is not needed in Svelte
		document.forms["content-type-form"].submit();
	};

	// recalcHeight was moved to Utils.ts
	const rebuildLabelFields = () => {
		var _a;
		const newLabelFields = [];

		for (let i = 0; i < $fieldsStore().length; i++) {
			const required = jQuery("#content-field-block-" + $fieldsStore()[i].id).find('[name="required"]').prop("checked");

			if (required && strict_equals($fieldsStore()[i].canDataLabel, 1)) {
				let label = $fieldsStore()[i].label;
				let id = $fieldsStore()[i].unique_id;

				if (!label) {
					label = (strict_equals(_a = jQuery("#content-field-block-" + $fieldsStore()[i].id).find('[name="label"]').val(), null) || strict_equals(_a, void 0) ? void 0 : _a.toString()) || "";

					if (strict_equals(label, "")) {
						label = window.trans("No Name");
					}
				}

				if (!id) {
					// new field
					id = "id:" + $fieldsStore()[i].id;
				}

				newLabelFields.push({ value: id, label });
			}
		}

		labelFields = newLabelFields;

		// update is not needed in Svelte
	};

	// changeLabelFields was removed because unused
	const toggleAll = () => {
		isExpanded = !isExpanded;

		const newIsShow = isExpanded ? "show" : "";

		$$props.fieldsStore.update((fields) => fields.map((field) => {
			field.isShow = newIsShow;

			return field;
		}));
	};

	const updateToggleAll = () => {
		const collapseEls = document.querySelectorAll(".mt-collapse__content");
		let isAllExpanded = true;

		collapseEls.forEach((collapseEl) => {
			if (collapseEl.classList.contains("show")) {
				isAllExpanded = true;
			} else {
				isAllExpanded = false;
			}
		});

		isExpanded = isAllExpanded ? true : false;
	};

	const _moveField = (item, pos) => {
		$$props.fieldsStore.update((fields) => {
			for (let i = 0; i < fields.length; i++) {
				let field = fields[i];

				if (strict_equals(field.id, item.id)) {
					fields.splice(i, 1);

					break;
				}
			}

			fields.splice(pos, 0, item);

			for (let i = 0; i < fields.length; i++) {
				fields[i].order = i + 1;
			}

			return fields;
		});
	};

	const _validateFields = () => {
		/* @ts-expect-error : mtValidate is not defined */
		const requiredFieldsAreValid = jQuery(".html5-form").mtValidate("simple");

		const textFieldsInTableAreValid = jQuery(".values-option-table input[type=text]").mtValidate("simple");

		/* @ts-expect-error : mtValidate is not defined */
		const tableIsValid = jQuery(".values-option-table").mtValidate("selection-field-values-option");

		/* @ts-expect-error : mtValidate is not defined */
		const contentFieldBlockIsValid = jQuery(".content-field-block").mtValidate("content-field-block");

		const uniqueFieldsAreValid = jQuery("input[data-mt-content-field-unique]").mtValidate("simple");
		const res = requiredFieldsAreValid && textFieldsInTableAreValid && tableIsValid && contentFieldBlockIsValid && uniqueFieldsAreValid;

		if (!res) {
			jQuery(".mt-contentfield").each(function (_i, fld) {
				const jqFld = jQuery(fld);

				if (jqFld.find(".form-control.is-invalid").length > 0) {
					/* @ts-expect-error : collapse is not defined */
					jqFld.find(".collapse").collapse("show");
				}
			});
		}

		return res;
	};

	// copied from lib/MT/Template/ContextHandler.pm
	const gatheringData = (c, index) => {
		const data = {};
		const flds = c.querySelectorAll("[data-is] [ref]");

		Object.keys(flds).forEach(function (k) {
			const f = flds[k];

			if (strict_equals(f.type, "checkbox")) {
				const val = f.checked ? 1 : 0;

				if (f.name in data) {
					if (Array.isArray(data[f.name])) {
						data[f.name].push(val);

						/* comented out because never used */
						// } else {
						//   const array = [];
						//   array.push(data[f.name]);
						//   array.push(val);
					}
				} else {
					data[f.name] = val;
				}
			} else {
				data[f.name] = f.value;
			}
		});

		const fieldId = $fieldsStore()[index].id;

		if (fieldId) {
			const gather = gathers[fieldId];

			if (gather) {
				const customData = gather();

				jQuery.extend(data, customData);
			}
		}

		return data;
	};

	// create in Svelte
	const updateFieldsIsShowAll = () => {
		const collapseEls = document.querySelectorAll(".mt-collapse__content");

		$$props.fieldsStore.update((fields) => fields.map((field, i) => {
			if (collapseEls[i].classList.contains("show")) {
				field.isShow = "show";
			} else {
				field.isShow = "";
			}

			return field;
		}));
	};

	// create in Svelte
	const addInputData = () => {
		const form = document.forms.namedItem("content-type-form");
		const inputId = form.querySelector('input[name="id"]');
		const inputData = document.createElement("input");

		inputData.setAttribute("type", "hidden");
		inputData.setAttribute("name", "data");
		inputData.setAttribute("value", data);
		form.insertBefore(inputData, inputId.nextElementSibling);
	};

	var $$exports = { ...legacy_api() };
	var fragment = root_1();
	var form_1 = first_child(fragment);

	set_attribute(form_1, 'action', window.CMSScriptURI);

	var input = child(form_1);
	var input_1 = sibling(input, 2);

	var input_2 = sibling(input_1, 2);

	var input_3 = sibling(input_2, 2);

	var input_4 = sibling(input_3, 2);
	var input_5 = sibling(input_4, 2);

	var div = sibling(input_5, 2);
	var div_1 = child(div);
	var node = child(div_1);

	{
		var consequent = ($$anchor) => {
			var div_2 = root_2();
			var h3 = child(div_2);
			var text = child(h3);
			var button = sibling(text);

			button.textContent = window.trans("Edit");

			var div_3 = sibling(h3, 2);
			var div_4 = child(div_3);
			var div_5 = child(div_4);
			var div_6 = child(div_5);
			var h4 = child(div_6);

			h4.textContent = window.trans("Content Type");

			var div_7 = sibling(div_6, 2);
			var div_8 = child(div_7);
			var div_9 = child(div_8);
			var label_1 = child(div_9);
			var text_1 = child(label_1);

			text_1.nodeValue = `${window.trans("Content Type Name") ?? ''} `;

			var span = sibling(text_1);

			span.textContent = window.trans("Required");

			var input_6 = sibling(label_1, 2);

			var div_10 = sibling(div_8, 2);
			var div_11 = child(div_10);
			var label_2 = child(div_11);

			label_2.textContent = window.trans("Description");

			var textarea = sibling(label_2, 2);

			var div_12 = sibling(div_10, 2);
			var div_13 = child(div_12);
			var label_3 = child(div_13);

			label_3.textContent = window.trans("Data Label Field");

			var select_1 = sibling(label_3, 2);
			var option_1 = child(select_1);

			option_1.textContent = window.trans("Show input field to enter data label");
			option_1.value = option_1.__value = '';

			var node_1 = sibling(option_1);

			add_svelte_meta(
				() => each(node_1, 17, () => labelFields, index, ($$anchor, lf) => {
					var option_2 = root_3();
					var text_2 = child(option_2, true);

					reset(option_2);

					var option_2_value = {};

					template_effect(() => {
						set_text(text_2, get$1(lf).label);

						if (option_2_value !== (option_2_value = get$1(lf).value)) {
							option_2.value = (option_2.__value = get$1(lf).value) ?? '';
						}
					});

					append($$anchor, option_2);
				}),
				'each',
				ContentFields,
				510,
				24
			);

			var div_14 = sibling(div_12, 2);
			var div_15 = child(div_14);
			var label_4 = child(div_15);

			label_4.textContent = window.trans("Unique ID");

			var input_7 = sibling(label_4, 2);

			var div_16 = sibling(div_14, 2);
			var div_17 = child(div_16);
			var label_5 = child(div_17);

			label_5.textContent = window.trans("Allow users to change the display and sort of fields by display option");

			var input_8 = sibling(label_5, 2);

			var label_6 = sibling(input_8, 2);

			label_6.textContent = window.trans("Allow users to change the display and sort of fields by display option");

			var div_18 = sibling(div_7, 2);
			var button_1 = child(div_18);

			button_1.textContent = window.trans("close");

			template_effect(() => {
				set_text(text, `${opts().name ?? ''} `);
				set_value(input_6, opts().name);
				set_value(textarea, opts().description);
				set_value(input_7, opts().unique_id);
				set_checked(input_8, opts().user_disp_option ? true : false);
			});

			event('keypress', input_6, stopSubmitting);

			bind_select_value(
				select_1,
				function get() {
					return labelField;
				},
				function set($$value) {
					labelField = $$value;
				}
			);

			append($$anchor, div_2);
		};

		var alternate = ($$anchor) => {
			var div_19 = root_4();
			var label_7 = child(div_19);
			var text_3 = child(label_7);

			text_3.nodeValue = `${window.trans("Name") ?? ''} `;

			var span_1 = sibling(text_3);

			span_1.textContent = window.trans("Required");

			var input_9 = sibling(label_7, 2);
			template_effect(() => set_value(input_9, opts().name));
			event('keypress', input_9, stopSubmitting);
			append($$anchor, div_19);
		};

		add_svelte_meta(
			() => if_block(node, ($$render) => {
				if (opts().id) $$render(consequent); else $$render(alternate, false);
			}),
			'if',
			ContentFields,
			430,
			6
		);
	}

	var form_2 = sibling(form_1, 2);
	var fieldset = child(form_2);
	var legend = child(fieldset);

	legend.textContent = window.trans("Content Fields");

	var div_20 = sibling(legend, 2);
	var a = child(div_20);

	a.__click = toggleAll;

	var text_4 = child(a);
	var node_2 = sibling(text_4);

	add_svelte_meta(
		() => SVG(node_2, {
			title: window.trans("Edit"),
			class: 'mt-icon--secondary expand-all-icon',
			href: `${window.StaticURI ?? ''}images/sprite.svg#ic_collapse`
		}),
		'component',
		ContentFields,
		602,
		8,
		{ componentTag: 'SVG' }
	);

	var div_21 = sibling(div_20, 2);
	var node_3 = child(div_21);

	{
		var consequent_1 = ($$anchor) => {
			var div_22 = root_5();
			var img = child(div_22);

			set_attribute(img, 'src', `${window.StaticURI ?? ''}images/dragdrop.gif`);
			set_attribute(img, 'alt', window.trans("Drag and drop area"));

			var p = sibling(img, 2);

			p.textContent = window.trans("Please add a content field.");
			append($$anchor, div_22);
		};

		add_svelte_meta(
			() => if_block(node_3, ($$render) => {
				if (isEmpty) $$render(consequent_1);
			}),
			'if',
			ContentFields,
			617,
			6
		);
	}

	var node_4 = sibling(node_3, 2);

	add_svelte_meta(
		() => each(node_4, 1, $fieldsStore, index, ($$anchor, field, fieldIndex) => {
			const fieldId = tag(user_derived(() => get$1(field).id ?? ""), 'fieldId');

			get$1(fieldId);

			var div_23 = root_6();
			var node_5 = child(div_23);

			validate_binding('bind:gather={gathers[fieldId]}', [], () => (mark_store_binding(), gathers), () => get$1(fieldId), 651, 12);

			add_svelte_meta(
				() => ContentField(node_5, {
					get config() {
						return $$props.config;
					},

					fieldIndex,

					get fieldsStore() {
						return $$props.fieldsStore;
					},

					gatheringData,

					get parent() {
						return tags[fieldIndex];
					},

					get optionsHtmlParams() {
						return $$props.optionsHtmlParams;
					},

					get field() {
						return $fieldsStore()[fieldIndex];
					},

					set field($$value) {
						store_mutate($$props.fieldsStore, untrack($fieldsStore)[fieldIndex] = $$value, untrack($fieldsStore));
					},

					get fields() {
						mark_store_binding();

						return $fieldsStore();
					},

					set fields($$value) {
						store_set($$props.fieldsStore, $$value);
					},

					get gather() {
						return gathers[get$1(fieldId)];
					},

					set gather($$value) {
						gathers[get$1(fieldId)] = $$value;
					}
				}),
				'component',
				ContentFields,
				643,
				10,
				{ componentTag: 'ContentField' }
			);

			reset(div_23);
			validate_binding('bind:this={tags[fieldIndex]}', [], () => (mark_store_binding(), tags), () => fieldIndex, 641, 10);
			bind_this(div_23, ($$value, fieldIndex) => tags[fieldIndex] = $$value, (fieldIndex) => tags?.[fieldIndex], () => [fieldIndex]);
			template_effect(() => set_attribute(div_23, 'id', `content-field-block-${get$1(fieldId) ?? ''}`));

			event('dragstart', div_23, (e) => {
				onDragStart(e, get$1(field));
			});

			event('dragend', div_23, onDragEnd);
			append($$anchor, div_23);
		}),
		'each',
		ContentFields,
		628,
		6
	);

	var div_24 = sibling(div_21, 2);
	var a_1 = child(div_24);

	a_1.__click = toggleAll;

	var text_5 = child(a_1);
	var node_6 = sibling(text_5);

	add_svelte_meta(
		() => SVG(node_6, {
			title: window.trans("Edit"),
			class: 'mt-icon--secondary expand-all-icon',
			href: `${window.StaticURI ?? ''}images/sprite.svg#ic_collapse`
		}),
		'component',
		ContentFields,
		666,
		8,
		{ componentTag: 'SVG' }
	);

	var button_2 = sibling(form_2, 2);

	button_2.__click = submit;
	button_2.textContent = window.trans("Save");

	template_effect(
		($0, $1, $2) => {
			set_value(input_1, opts().blog_id);
			set_value(input_2, opts().magic_token);
			set_value(input_3, opts().return_args);
			set_value(input_5, opts().id);
			set_attribute(a, 'aria-expanded', isExpanded ? "true" : "false");
			set_text(text_4, `${$0 ?? ''} `);
			set_attribute(a_1, 'aria-expanded', isExpanded ? "true" : "false");
			set_text(text_5, `${$1 ?? ''} `);
			button_2.disabled = $2;
		},
		[
			() => isExpanded ? window.trans("Close all") : window.trans("Edit all"),
			() => isExpanded ? window.trans("Close all") : window.trans("Edit all"),
			() => !canSubmit()
		]
	);

	event('drop', div_21, onDrop);
	event('dragover', div_21, onDragOver);
	event('dragleave', div_21, onDragLeave);
	append($$anchor, fragment);

	var $$pop = pop($$exports);

	$$cleanup();

	return $$pop;
}

delegate(['click']);

CustomElementField[FILENAME] = 'src/contenttype/elements/CustomElementField.svelte';

function CustomElementField($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	const $fieldsStore = () => (
		validate_store($$props.fieldsStore),
		store_get($$props.fieldsStore, '$fieldsStore', $$stores)
	);

	const [$$stores, $$cleanup] = setup_stores();
	let field = tag(state(proxy($fieldsStore()[$$props.fieldIndex])), 'field');
	let options = tag(state(proxy(get$1(field).options || {})), 'options');
	let id = tag(state(`field-options-${get$1(field).id}`), 'id');

	user_effect(() => {
		set(field, $fieldsStore()[$$props.fieldIndex], true);
		set(options, get$1(field).options || {}, true);
		set(id, `field-options-${get$1(field).id}`);
	});

	const initElement = (el) => {
		const options = el.options;

		el.options = new Proxy(options, {
			set(_, property, value) {
				options[property] = value;
				store_mutate($$props.fieldsStore, untrack($fieldsStore)[$$props.fieldIndex].options[property] = value, untrack($fieldsStore));
				$$props.updateOptions(options);

				return value;
			}
		});
	};

	var $$exports = { ...legacy_api() };

	add_svelte_meta(
		() => ContentFieldOptionGroup($$anchor, {
			get type() {
				return $$props.type;
			},

			get id() {
				return get$1(id);
			},

			get field() {
				return get$1(field);
			},

			set field($$value) {
				set(field, $$value, true);
			},

			get options() {
				return get$1(options);
			},

			set options($$value) {
				set(options, $$value, true);
			},

			children: wrap_snippet(CustomElementField, ($$anchor, $$slotProps) => {
				var fragment_1 = comment();
				var node = first_child(fragment_1);

				{
					validate_dynamic_element_tag(() => $$props.customElement);

					element(
						node,
						() => $$props.customElement,
						false,
						($$element, $$anchor) => {
							action($$element, ($$node) => initElement?.($$node));
							attribute_effect($$element, ($0) => ({ 'data-options': $0 }), [() => JSON.stringify(get$1(options))]);
						},
						void 0,
						[25, 2]
					);
				}

				append($$anchor, fragment_1);
			}),

			$$slots: { default: true }
		}),
		'component',
		CustomElementField,
		24,
		0,
		{ componentTag: 'ContentFieldOptionGroup' }
	);

	var $$pop = pop($$exports);

	$$cleanup();

	return $$pop;
}

customElements.define("mt-content-field-option", class extends HTMLElement {
  connectedCallback() {
    const id = this.getAttribute("id") || "";
    const attr = this.getAttribute("attr") || "";
    const attrShow = this.getAttribute("attr-show");
    const hint = this.getAttribute("hint") || "";
    const label = this.getAttribute("label") || "";
    const required = this.getAttribute("required") === "1";
    const showHint = this.getAttribute("show-hint") === "1";
    const showLabel = this.getAttribute("show-label") !== "0";
    if (!id) {
      console.error("ContentFieldOption: 'id' attribute missing");
      return;
    }
    const wrapper = document.createElement("div");
    wrapper.id = `${id}-field`;
    wrapper.className = "form-group";
    if (required) {
      wrapper.classList.add("required");
    }
    if (attr) {
      wrapper.setAttribute("attr", attr);
    }
    if (attrShow !== null) {
      if (attrShow === "true") {
        wrapper.style.display = "";
      } else {
        wrapper.hidden = true;
        wrapper.style.display = "none";
      }
    }
    if (label && showLabel) {
      const labelElement = document.createElement("label");
      labelElement.setAttribute("for", id);
      labelElement.textContent = label;
      if (required) {
        const badge = document.createElement("span");
        badge.className = "badge badge-danger";
        badge.textContent = window.trans("Required");
        labelElement.appendChild(badge);
      }
      wrapper.appendChild(labelElement);
    }
    while (this.firstChild) {
      wrapper.appendChild(this.firstChild);
    }
    if (hint && showHint) {
      const hintElement = document.createElement("small");
      hintElement.id = `${id}-field-help`;
      hintElement.className = "form-text text-muted";
      hintElement.textContent = hint;
      wrapper.appendChild(hintElement);
    }
    this.appendChild(wrapper);
  }
});

var _a, _ContentTypeEditor_config_accessor_storage, _ContentTypeEditor_fieldsStore_accessor_storage, _ContentTypeEditor_optionsHtmlParams_accessor_storage, _ContentTypeEditor_opts_accessor_storage;
class CustomElementFieldBase extends HTMLElement {
  constructor() {
    super(...arguments);
    this.options = {};
  }
  connectedCallback() {
    this.options = JSON.parse(this.getAttribute("data-options") || "{}");
  }
  disconnectedCallback() {
  }
}
class ContentTypeEditor {
  static get config() {
    return __classPrivateFieldGet(_a, _a, "f", _ContentTypeEditor_config_accessor_storage);
  }
  static set config(value) {
    __classPrivateFieldSet(_a, _a, value, "f", _ContentTypeEditor_config_accessor_storage);
  }
  static get fieldsStore() {
    return __classPrivateFieldGet(_a, _a, "f", _ContentTypeEditor_fieldsStore_accessor_storage);
  }
  static set fieldsStore(value) {
    __classPrivateFieldSet(_a, _a, value, "f", _ContentTypeEditor_fieldsStore_accessor_storage);
  }
  static get optionsHtmlParams() {
    return __classPrivateFieldGet(_a, _a, "f", _ContentTypeEditor_optionsHtmlParams_accessor_storage);
  }
  static set optionsHtmlParams(value) {
    __classPrivateFieldSet(_a, _a, value, "f", _ContentTypeEditor_optionsHtmlParams_accessor_storage);
  }
  static get opts() {
    return __classPrivateFieldGet(_a, _a, "f", _ContentTypeEditor_opts_accessor_storage);
  }
  static set opts(value) {
    __classPrivateFieldSet(_a, _a, value, "f", _ContentTypeEditor_opts_accessor_storage);
  }
  static registerCustomType(type, mountFunction) {
    if (mountFunction.prototype instanceof CustomElementFieldBase) {
      const customElement = `mt-content-type-custom-type-${type}`;
      customElements.define(customElement, mountFunction);
      mountFunction = (props, target) => {
        let options;
        const customElementField = mount(CustomElementField, {
          props: {
            ...props,
            type,
            customElement,
            updateOptions: (_options) => {
              options = _options;
            }
          },
          target
        });
        return {
          component: customElementField,
          gather: () => {
            return options;
          },
          destroy: () => {
            customElementField.$destroy();
          }
        };
      };
    }
    this.types.registerCustomType(type, mountFunction);
  }
  static mount(targetSelector, opts) {
    const target = this.getContentFieldsTarget(targetSelector);
    this.fieldsStore = writable(opts.fields);
    this.opts = opts;
    mount(ContentFields, {
      props: {
        config: this.config,
        fieldsStore: this.fieldsStore,
        optionsHtmlParams: this.optionsHtmlParams,
        opts: this.opts,
        root: target
      },
      target
    });
  }
  static getContentFieldsTarget(selector) {
    const target = document.querySelector(`[data-is="${selector}"]`);
    if (!target) {
      throw new Error("Target element is not found: " + selector);
    }
    return target;
  }
}
_a = ContentTypeEditor;
_ContentTypeEditor_config_accessor_storage = { value: {} };
_ContentTypeEditor_fieldsStore_accessor_storage = { value: void 0 };
_ContentTypeEditor_optionsHtmlParams_accessor_storage = { value: {} };
_ContentTypeEditor_opts_accessor_storage = { value: void 0 };
ContentTypeEditor.types = ContentFieldTypes;
ContentTypeEditor.CustomElementFieldBase = CustomElementFieldBase;

const getConfigName = (key) => {
  const tmp = key.substring(6);
  return tmp.substring(0, 1).toUpperCase() + tmp.substring(1);
};
if (!window.riot) {
  window.riot = {};
}
window.riot.observable = observable;
window.ContentTypeEditor = ContentTypeEditor;
const scriptContenttype = document.getElementById("script-contenttype");
if (scriptContenttype) {
  for (const key in scriptContenttype.dataset) {
    if (!key.startsWith("config")) {
      continue;
    }
    const configName = getConfigName(key);
    if (configName === "") {
      continue;
    }
    ContentTypeEditor.config[configName] = scriptContenttype.dataset[key];
  }
  if ("optionsHtmlParams" in scriptContenttype.dataset) {
    let optionsHtmlParams = {};
    try {
      optionsHtmlParams = JSON.parse(scriptContenttype.dataset["optionsHtmlParams"] || "{}");
    } catch (error) {
      console.log(error);
    }
    ContentTypeEditor.optionsHtmlParams = optionsHtmlParams;
  }
}
//# sourceMappingURL=contenttype.js.map
