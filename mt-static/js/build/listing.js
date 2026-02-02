
(function(l, r) { if (!l || l.getElementById('livereloadscript')) return; r = l.createElement('script'); r.async = 1; r.src = '//' + (self.location.host || 'localhost').split(':')[0] + ':35730/livereload.js?snipver=1'; r.id = 'livereloadscript'; l.getElementsByTagName('head')[0].appendChild(r) })(self.document);
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

// generated during release, do not modify

const PUBLIC_VERSION = '5';

if (typeof window !== 'undefined') {
	// @ts-expect-error
	((window.__svelte ??= {}).v ??= new Set()).add(PUBLIC_VERSION);
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

const ATTACHMENT_KEY = '@attach';

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

/**
 * When encountering a situation like `let [a, b, c] = $derived(blah())`,
 * we need to stash an intermediate value that `a`, `b`, and `c` derive
 * from, in case it's an iterable
 * @template T
 * @param {ArrayLike<T> | Iterable<T>} value
 * @param {number} [n]
 * @returns {Array<T>}
 */
function to_array(value, n) {
	// return arrays unchanged
	if (Array.isArray(value)) {
		return value;
	}

	// if value is not iterable, or `n` is unspecified (indicates a rest
	// element, which means we're not concerned about unbounded iterables)
	// convert to an array with `Array.from`
	if (!(Symbol.iterator in value)) {
		return Array.from(value);
	}

	// otherwise, populate an array with `n` values

	/** @type {T[]} */
	const array = [];

	for (const element of value) {
		array.push(element);
		if (array.length === n) break;
	}

	return array;
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
 * `%name%(...)` cannot be used in runes mode
 * @param {string} name
 * @returns {never}
 */
function lifecycle_legacy_only(name) {
	{
		throw new Error(`https://svelte.dev/e/lifecycle_legacy_only`);
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

/* This file is generated by scripts/process-messages/index.js. Do not edit! */


/**
 * %handler% should be a function. Did you mean to %suggestion%?
 * @param {string} handler
 * @param {string} suggestion
 */
function event_handler_invalid(handler, suggestion) {
	{
		console.warn(`https://svelte.dev/e/event_handler_invalid`);
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

/** True if experimental.async=true */
/** True if we're not certain that we only have Svelte 5 code in the compilation */
let legacy_mode_flag = false;
/** True if $inspect.trace is used */
let tracing_mode_flag = false;

function enable_legacy_mode_flag() {
	legacy_mode_flag = true;
}

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
	if (micro_tasks.length === 0 && true) {
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

			{
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

/**
 * In dev, warn if an event handler is not a function, as it means the
 * user probably called the handler or forgot to add a `() =>`
 * @param {() => (event: Event, ...args: any) => void} thunk
 * @param {EventTarget} element
 * @param {[Event, ...any]} args
 * @param {any} component
 * @param {[number, number]} [loc]
 * @param {boolean} [remove_parens]
 */
function apply(
	thunk,
	element,
	args,
	component,
	loc,
	has_side_effects = false,
	remove_parens = false
) {
	let handler;
	let error;

	try {
		handler = thunk();
	} catch (e) {
		error = e;
	}

	if (typeof handler !== 'function' && (has_side_effects || handler != null || error)) {
		const filename = component?.[FILENAME];
		loc ? ` at ${filename}:${loc[0]}:${loc[1]}` : ` in ${filename}`;
		const phase = args[0]?.eventPhase < Event.BUBBLING_PHASE ? 'capture' : '';
		args[0]?.type + phase;

		event_handler_invalid();

		if (error) {
			throw error;
		}
	}
	handler?.apply(element, args);
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
 * Schedules a callback to run immediately after the component has been updated.
 *
 * The first time the callback runs will be after the initial `onMount`.
 *
 * In runes mode use `$effect` instead.
 *
 * @deprecated Use [`$effect`](https://svelte.dev/docs/svelte/$effect) instead
 * @param {() => void} fn
 * @returns {void}
 */
function afterUpdate(fn) {
	if (component_context === null) {
		lifecycle_outside_component();
	}

	if (component_context.l === null) {
		lifecycle_legacy_only();
	}

	init_update_callbacks(component_context).a.push(fn);
}

/**
 * Legacy-mode: Init callbacks object for onMount/beforeUpdate/afterUpdate
 * @param {ComponentContext} context
 */
function init_update_callbacks(context) {
	var l = /** @type {ComponentContextLegacy} */ (context).l;
	return (l.u ??= { a: [], b: [], m: [] });
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

/** @import { TemplateNode } from '#client' */

/**
 * @template V
 * @param {TemplateNode} node
 * @param {() => V} get_key
 * @param {(anchor: Node) => TemplateNode | void} render_fn
 * @returns {void}
 */
function key(node, get_key, render_fn) {

	var branches = new BranchManager(node);

	var legacy = !is_runes();

	block(() => {
		var key = get_key();

		// key blocks in Svelte <5 had stupid semantics
		if (legacy && key !== null && typeof key === 'object') {
			key = /** @type {V} */ ({});
		}

		branches.ensure(key, render_fn);
	});
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

	if (hash) {
		classname = classname ? classname + ' ' + hash : hash;
	}

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

/**
 * Makes an `export`ed (non-prop) variable available on the `$$props` object
 * so that consumers can do `bind:x` on the component.
 * @template V
 * @param {Record<string, unknown>} props
 * @param {string} prop
 * @param {V} value
 * @returns {void}
 */
function bind_prop(props, prop, value) {
	var desc = get_descriptor(props, prop);

	if (desc && desc.set) {
		props[prop] = value;
		teardown(() => {
			props[prop] = null;
		});
	}
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

DisplayOptionsColumns[FILENAME] = 'src/listing/elements/DisplayOptionsColumns.svelte';

var root_1$e = add_locations(from_html(`<div class="alert alert-warning"></div>`), DisplayOptionsColumns[FILENAME], [[20, 2]]);
var root_4$8 = add_locations(from_html(`<li class="list-inline-item"><div class="form-check"><input/> <label class="form-check-label form-label"> </label></div></li>`), DisplayOptionsColumns[FILENAME], [[51, 10, [[56, 12, [[59, 14], [68, 14]]]]]]);
var root_3$b = add_locations(from_html(`<li class="list-inline-item"><div class="form-check"><input type="checkbox" class="form-check-input"/> <label class="form-check-label form-label"><!></label></div></li> <!>`, 1), DisplayOptionsColumns[FILENAME], [[28, 8, [[33, 10, [[36, 12], [44, 12]]]]]]);
var root_2$9 = add_locations(from_html(`<div class="field-content"><ul id="disp_cols" class="list-inline m-0"></ul></div>`), DisplayOptionsColumns[FILENAME], [[24, 2, [[25, 4]]]]);
var root$o = add_locations(from_html(`<div class="field-header"><label class="form-label"></label></div> <!>`, 1), DisplayOptionsColumns[FILENAME], [[15, 0, [[17, 2]]]]);

function DisplayOptionsColumns($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	const toggleColumn = (e) => {
		var _a;
		const columnId = strict_equals(_a = e.currentTarget, null) || strict_equals(_a, void 0) ? void 0 : _a.id;

		$$props.store.trigger("toggle_column", columnId);
	};

	const toggleSubField = (e) => {
		var _a;
		const subFieldId = strict_equals(_a = e.currentTarget, null) || strict_equals(_a, void 0) ? void 0 : _a.id;

		$$props.store.trigger("toggle_sub_field", subFieldId);
	};

	var $$exports = { ...legacy_api() };
	var fragment = root$o();
	var div = first_child(fragment);
	var label = child(div);

	label.textContent = window.trans("Column");

	var node = sibling(div, 2);

	{
		var consequent = ($$anchor) => {
			var div_1 = root_1$e();

			div_1.textContent = window.trans("User Display Option is disabled now.");
			append($$anchor, div_1);
		};

		var alternate = ($$anchor) => {
			var div_2 = root_2$9();
			var ul = child(div_2);

			add_svelte_meta(
				() => each(ul, 21, () => $$props.store.columns, index, ($$anchor, column) => {
					const hiddenColumn = tag(user_derived(() => Boolean(get$1(column).force_display)), 'hiddenColumn');

					get$1(hiddenColumn);

					var fragment_1 = root_3$b();
					var li = first_child(fragment_1);
					let styles;
					var div_3 = child(li);
					var input = child(div_3);

					remove_input_defaults(input);
					input.__change = toggleColumn;

					var label_1 = sibling(input, 2);
					var node_1 = child(label_1);

					html(node_1, () => get$1(column).label);
					reset(label_1);
					reset(div_3);
					reset(li);

					var node_2 = sibling(li, 2);

					add_svelte_meta(
						() => each(node_2, 17, () => get$1(column).sub_fields, index, ($$anchor, subField) => {
							const hiddenSubField = tag(user_derived(() => Boolean(get$1(subField).force_display)), 'hiddenSubField');

							get$1(hiddenSubField);

							var li_1 = root_4$8();
							let styles_1;
							var div_4 = child(li_1);
							var input_1 = child(div_4);

							attribute_effect(
								input_1,
								($0) => ({
									type: 'checkbox',
									id: get$1(subField).id,
									...{ pid: get$1(subField).parent_id },
									class: `form-check-input ${get$1(subField).class ?? ''}`,
									disabled: !get$1(column).checked,
									checked: $0,
									onchange: toggleSubField
								}),
								[() => Boolean(get$1(subField).checked)],
								void 0,
								void 0,
								void 0,
								true
							);

							var label_2 = sibling(input_1, 2);
							var text = child(label_2, true);

							reset(label_2);
							reset(div_4);
							reset(li_1);

							template_effect(() => {
								set_attribute(li_1, 'hidden', get$1(hiddenSubField));
								styles_1 = set_style(li_1, '', styles_1, { display: get$1(hiddenSubField) ? "none" : "" });
								set_attribute(label_2, 'for', get$1(subField).id);
								set_text(text, get$1(subField).label);
							});

							append($$anchor, li_1);
						}),
						'each',
						DisplayOptionsColumns,
						49,
						8
					);

					template_effect(
						($0) => {
							set_attribute(li, 'hidden', get$1(hiddenColumn));
							styles = set_style(li, '', styles, { display: get$1(hiddenColumn) ? "none" : "" });
							set_attribute(input, 'id', get$1(column).id);
							set_checked(input, $0);
							input.disabled = $$props.store.isLoading;
							set_attribute(label_1, 'for', get$1(column).id);
						},
						[() => Boolean(get$1(column).checked)]
					);

					append($$anchor, fragment_1);
				}),
				'each',
				DisplayOptionsColumns,
				26,
				6
			);
			append($$anchor, div_2);
		};

		add_svelte_meta(
			() => if_block(node, ($$render) => {
				if ($$props.disableUserDispOption) $$render(consequent); else $$render(alternate, false);
			}),
			'if',
			DisplayOptionsColumns,
			19,
			0
		);
	}

	append($$anchor, fragment);

	return pop($$exports);
}

delegate(['change']);

DisplayOptionsLimit[FILENAME] = 'src/listing/elements/DisplayOptionsLimit.svelte';

var root$n = add_locations(from_html(`<div class="field-header"><label class="form-label"></label></div> <div class="field-content"><select><option></option><option></option><option></option><option></option><option></option></select></div>`, 1), DisplayOptionsLimit[FILENAME], [
	[7, 0, [[9, 2]]],

	[
		11,
		0,
		[[12, 2, [[20, 4], [21, 4], [22, 4], [23, 4], [24, 4]]]]
	]
]);

function DisplayOptionsLimit($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	let limit = tag(user_derived(() => $$props.store.limit || 0), 'limit');
	let limitToString = tag(user_derived(() => get$1(limit).toString()), 'limitToString');
	var $$exports = { ...legacy_api() };
	var fragment = root$n();
	var div = first_child(fragment);
	var label = child(div);

	label.textContent = window.trans("Show");

	var div_1 = sibling(div, 2);
	var select = child(div_1);

	attribute_effect(select, () => ({
		id: 'row',
		class: 'custom-select form-control form-select',
		style: 'width: 100px;',
		...{ ref: "limit" },
		onchange: $$props.changeLimit
	}));

	var option = child(select);

	option.textContent = window.trans("[_1] rows", "10");
	option.value = option.__value = '10';

	var option_1 = sibling(option);

	option_1.textContent = window.trans("[_1] rows", "25");
	option_1.value = option_1.__value = '25';

	var option_2 = sibling(option_1);

	option_2.textContent = window.trans("[_1] rows", "50");
	option_2.value = option_2.__value = '50';

	var option_3 = sibling(option_2);

	option_3.textContent = window.trans("[_1] rows", "100");
	option_3.value = option_3.__value = '100';

	var option_4 = sibling(option_3);

	option_4.textContent = window.trans("[_1] rows", "200");
	option_4.value = option_4.__value = '200';

	bind_select_value(
		select,
		function get() {
			return get$1(limitToString);
		},
		function set$1($$value) {
			set(limitToString, $$value);
		}
	);

	append($$anchor, fragment);

	return pop($$exports);
}

DisplayOptionsDetail[FILENAME] = 'src/listing/elements/DisplayOptionsDetail.svelte';

var root_1$d = add_locations(from_html(`<div class="actions-bar actions-bar-bottom"><a href="javascript:void(0);" id="reset-display-options"></a></div>`), DisplayOptionsDetail[FILENAME], [[22, 6, [[24, 8]]]]);
var root$m = add_locations(from_html(`<div id="display-options-detail" class="collapse"><div class="card card-block p-3"><fieldset class="form-group"><div data-is="display-options-limit" id="per_page-field"><!></div></fieldset> <fieldset class="form-group"><div data-is="display-options-columns" id="display_columns-field"><!></div></fieldset> <!></div></div>`), DisplayOptionsDetail[FILENAME], [[9, 0, [[10, 2, [[11, 4, [[12, 6]]], [16, 4, [[17, 6]]]]]]]]);

function DisplayOptionsDetail($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	const resetColumns = () => {
		$$props.store.trigger("reset_columns");
	};

	var $$exports = { ...legacy_api() };
	var div = root$m();
	var div_1 = child(div);
	var fieldset = child(div_1);
	var div_2 = child(fieldset);
	var node = child(div_2);

	add_svelte_meta(
		() => DisplayOptionsLimit(node, {
			get changeLimit() {
				return $$props.changeLimit;
			},

			get store() {
				return $$props.store;
			}
		}),
		'component',
		DisplayOptionsDetail,
		13,
		8,
		{ componentTag: 'DisplayOptionsLimit' }
	);

	var fieldset_1 = sibling(fieldset, 2);
	var div_3 = child(fieldset_1);
	var node_1 = child(div_3);

	add_svelte_meta(
		() => DisplayOptionsColumns(node_1, {
			get disableUserDispOption() {
				return $$props.disableUserDispOption;
			},

			get store() {
				return $$props.store;
			}
		}),
		'component',
		DisplayOptionsDetail,
		18,
		8,
		{ componentTag: 'DisplayOptionsColumns' }
	);

	var node_2 = sibling(fieldset_1, 2);

	{
		var consequent = ($$anchor) => {
			var div_4 = root_1$d();
			var a = child(div_4);

			a.__click = resetColumns;
			a.textContent = window.trans("Reset defaults");
			append($$anchor, div_4);
		};

		add_svelte_meta(
			() => if_block(node_2, ($$render) => {
				if (!$$props.disableUserDispOption) $$render(consequent);
			}),
			'if',
			DisplayOptionsDetail,
			21,
			4
		);
	}
	append($$anchor, div);

	return pop($$exports);
}

delegate(['click']);

DisplayOptions[FILENAME] = 'src/listing/elements/DisplayOptions.svelte';

var root$l = add_locations(from_html(`<div class="row"><div class="col-12"><button class="btn btn-default dropdown-toggle float-end" data-bs-toggle="collapse" data-bs-target="#display-options-detail" aria-expanded="false" aria-controls="display-options-detail"></button></div></div> <div class="row"><div data-is="display-options-detail" class="col-12"><!></div></div>`, 1), DisplayOptions[FILENAME], [[5, 0, [[6, 2, [[7, 4]]]]], [18, 0, [[19, 2]]]]);

function DisplayOptions($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$exports = { ...legacy_api() };
	var fragment = root$l();
	var div = first_child(fragment);
	var div_1 = child(div);
	var button = child(div_1);

	button.textContent = window.trans("Display Options");

	var div_2 = sibling(div, 2);
	var div_3 = child(div_2);
	var node = child(div_3);

	add_svelte_meta(
		() => DisplayOptionsDetail(node, {
			get changeLimit() {
				return $$props.changeLimit;
			},

			get disableUserDispOption() {
				return $$props.disableUserDispOption;
			},

			get store() {
				return $$props.store;
			}
		}),
		'component',
		DisplayOptions,
		20,
		4,
		{ componentTag: 'DisplayOptionsDetail' }
	);
	append($$anchor, fragment);

	return pop($$exports);
}

DisplayOptionsForMobile[FILENAME] = 'src/listing/elements/DisplayOptionsForMobile.svelte';

var root$k = add_locations(from_html(`<div class="row d-md-none"><div class="col-auto mx-auto"><div class="form-inline"><label for="row-for-mobile" class="form-label"></label> <select><option></option><option></option><option></option><option></option><option></option></select></div></div></div>`), DisplayOptionsForMobile[FILENAME], [
	[
		7,
		0,

		[
			[
				8,
				2,

				[
					[
						9,
						4,

						[
							[10, 6],
							[13, 6, [[20, 8], [21, 8], [22, 8], [23, 8], [24, 8]]]
						]
					]
				]
			]
		]
	]
]);

function DisplayOptionsForMobile($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	let limit = tag(user_derived(() => $$props.store.limit || 0), 'limit');
	let limitToString = tag(user_derived(() => get$1(limit).toString()), 'limitToString');
	var $$exports = { ...legacy_api() };
	var div = root$k();
	var div_1 = child(div);
	var div_2 = child(div_1);
	var label = child(div_2);

	label.textContent = window.trans("Show") + ":";

	var select = sibling(label, 2);

	attribute_effect(select, () => ({
		id: 'row-for-mobile',
		class: 'custom-select form-control form-select',
		...{ ref: "limit" },
		onchange: $$props.changeLimit
	}));

	var option = child(select);

	option.textContent = window.trans("[_1] rows", "10");
	option.value = option.__value = '10';

	var option_1 = sibling(option);

	option_1.textContent = window.trans("[_1] rows", "25");
	option_1.value = option_1.__value = '25';

	var option_2 = sibling(option_1);

	option_2.textContent = window.trans("[_1] rows", "50");
	option_2.value = option_2.__value = '50';

	var option_3 = sibling(option_2);

	option_3.textContent = window.trans("[_1] rows", "100");
	option_3.value = option_3.__value = '100';

	var option_4 = sibling(option_3);

	option_4.textContent = window.trans("[_1] rows", "200");
	option_4.value = option_4.__value = '200';

	bind_select_value(
		select,
		function get() {
			return get$1(limitToString);
		},
		function set$1($$value) {
			set(limitToString, $$value);
		}
	);

	append($$anchor, div);

	return pop($$exports);
}

enable_legacy_mode_flag();

ListActionsForMobile[FILENAME] = 'src/listing/elements/ListActionsForMobile.svelte';

var root_2$8 = add_locations(from_html(`<a class="dropdown-item" href="javascript:void(0);"><!></a>`), ListActionsForMobile[FILENAME], [[40, 8]]);
var root_3$a = add_locations(from_html(`<a class="dropdown-item" href="javascript:void(0);"><!></a>`), ListActionsForMobile[FILENAME], [[52, 8]]);
var root_4$7 = add_locations(from_html(`<h6 class="dropdown-header">Plugin Actions</h6>`), ListActionsForMobile[FILENAME], [[63, 8]]);
var root_5$5 = add_locations(from_html(`<a class="dropdown-item" href="javascript:void(0);"><!></a>`), ListActionsForMobile[FILENAME], [[68, 8]]);
var root_1$c = add_locations(from_html(`<div class="btn-group"><button class="btn btn-default dropdown-toggle" data-bs-toggle="dropdown"></button> <div class="dropdown-menu"><!> <!> <!> <!></div></div>`), ListActionsForMobile[FILENAME], [[33, 2, [[34, 4], [37, 4]]]]);

function ListActionsForMobile($$anchor, $$props) {
	check_target(new.target);
	push($$props, false);

	let buttonActions = prop($$props, 'buttonActions', 8);
	let doAction = prop($$props, 'doAction', 8);
	let listActions = prop($$props, 'listActions', 8);
	let moreListActions = prop($$props, 'moreListActions', 8);

	const buttonActionsForMobile = () => {
		return _getActionsForMobile(buttonActions());
	};

	const listActionsForMobile = () => {
		return _getActionsForMobile(listActions());
	};

	const moreListActionsForMobile = () => {
		return _getActionsForMobile(moreListActions());
	};

	const _getActionsForMobile = (actions) => {
		const mobileActions = {};

		Object.keys(actions).forEach((key) => {
			const action = actions[key];

			if (action.mobile) {
				mobileActions[key] = action;
			}
		});

		return mobileActions;
	};

	const hasActionForMobile = () => {
		const mobileActionCount = Object.keys(buttonActionsForMobile()).length + Object.keys(listActionsForMobile()).length + Object.keys(moreListActionsForMobile()).length;

		return mobileActionCount > 0;
	};

	var $$exports = { ...legacy_api() };

	init();

	var fragment = comment();
	var node = first_child(fragment);

	{
		var consequent_1 = ($$anchor) => {
			var div = root_1$c();
			var button = child(div);

			button.textContent = (untrack(() => window.trans("Select action")));

			var div_1 = sibling(button, 2);
			var node_1 = child(div_1);

			add_svelte_meta(
				() => each(node_1, 1, () => (untrack(() => Object.entries(buttonActionsForMobile()))), index, ($$anchor, $$item) => {
					var $$array = user_derived(() => to_array(get$1($$item), 2));
					let key = () => get$1($$array)[0];

					key();

					let action = () => get$1($$array)[1];

					action();

					var a = root_2$8();

					a.__click = function (...$$args) {
						apply(doAction, this, $$args, ListActionsForMobile, [44, 19]);
					};

					var node_2 = child(a);

					html(node_2, () => (action(), untrack(() => action().label)));
					reset(a);
					template_effect(() => set_attribute(a, 'data-action-id', key()));
					append($$anchor, a);
				}),
				'each',
				ListActionsForMobile,
				38,
				6
			);

			var node_3 = sibling(node_1, 2);

			add_svelte_meta(
				() => each(node_3, 1, () => (untrack(() => Object.entries(listActionsForMobile()))), index, ($$anchor, $$item) => {
					var $$array_1 = user_derived(() => to_array(get$1($$item), 2));
					let key = () => get$1($$array_1)[0];

					key();

					let action = () => get$1($$array_1)[1];

					action();

					var a_1 = root_3$a();

					a_1.__click = function (...$$args) {
						apply(doAction, this, $$args, ListActionsForMobile, [56, 19]);
					};

					var node_4 = child(a_1);

					html(node_4, () => (action(), untrack(() => action().label)));
					reset(a_1);
					template_effect(() => set_attribute(a_1, 'data-action-id', key()));
					append($$anchor, a_1);
				}),
				'each',
				ListActionsForMobile,
				50,
				6
			);

			var node_5 = sibling(node_3, 2);

			{
				var consequent = ($$anchor) => {
					var h6 = root_4$7();

					append($$anchor, h6);
				};

				add_svelte_meta(
					() => if_block(node_5, ($$render) => {
						if ((
							untrack(() => Object.keys(moreListActionsForMobile()).length > 0)
						)) $$render(consequent);
					}),
					'if',
					ListActionsForMobile,
					62,
					6
				);
			}

			var node_6 = sibling(node_5, 2);

			add_svelte_meta(
				() => each(node_6, 1, () => (untrack(() => Object.entries(moreListActionsForMobile()))), index, ($$anchor, $$item) => {
					var $$array_2 = user_derived(() => to_array(get$1($$item), 2));
					let key = () => get$1($$array_2)[0];

					key();

					let action = () => get$1($$array_2)[1];

					action();

					var a_2 = root_5$5();

					a_2.__click = function (...$$args) {
						apply(doAction, this, $$args, ListActionsForMobile, [72, 19]);
					};

					var node_7 = child(a_2);

					html(node_7, () => (action(), untrack(() => action().label)));
					reset(a_2);
					template_effect(() => set_attribute(a_2, 'data-action-id', key()));
					append($$anchor, a_2);
				}),
				'each',
				ListActionsForMobile,
				66,
				6
			);
			append($$anchor, div);
		};

		add_svelte_meta(
			() => if_block(node, ($$render) => {
				if ((untrack(hasActionForMobile))) $$render(consequent_1);
			}),
			'if',
			ListActionsForMobile,
			32,
			0
		);
	}

	append($$anchor, fragment);

	return pop($$exports);
}

delegate(['click']);

ListActionsForPc[FILENAME] = 'src/listing/elements/ListActionsForPc.svelte';

var root_1$b = add_locations(from_html(`<button class="btn btn-default mr-2"><!></button>`), ListActionsForPc[FILENAME], [[6, 2]]);
var root_3$9 = add_locations(from_html(`<a class="dropdown-item" href="javascript:void(0);"><!></a>`), ListActionsForPc[FILENAME], [[19, 8]]);
var root_4$6 = add_locations(from_html(`<h6 class="dropdown-header"></h6>`), ListActionsForPc[FILENAME], [[30, 8]]);
var root_5$4 = add_locations(from_html(`<a class="dropdown-item" href="javascript:void(0);"><!></a>`), ListActionsForPc[FILENAME], [[37, 8]]);
var root_2$7 = add_locations(from_html(`<div class="btn-group"><button class="btn btn-default dropdown-toggle" data-bs-toggle="dropdown"></button> <div class="dropdown-menu"><!> <!> <!></div></div>`), ListActionsForPc[FILENAME], [[12, 2, [[13, 4], [16, 4]]]]);
var root$j = add_locations(from_html(`<!> <!>`, 1), ListActionsForPc[FILENAME], []);

function ListActionsForPc($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$exports = { ...legacy_api() };
	var fragment = root$j();
	var node = first_child(fragment);

	add_svelte_meta(
		() => each(node, 17, () => Object.entries($$props.buttonActions), index, ($$anchor, $$item) => {
			var $$array = user_derived(() => to_array(get$1($$item), 2));
			let key = () => get$1($$array)[0];

			key();

			let action = () => get$1($$array)[1];

			action();

			var button = root_1$b();

			button.__click = function (...$$args) {
				apply(() => $$props.doAction, this, $$args, ListActionsForPc, [6, 69]);
			};

			var node_1 = child(button);

			html(node_1, () => action().label);
			reset(button);
			template_effect(() => set_attribute(button, 'data-action-id', key()));
			append($$anchor, button);
		}),
		'each',
		ListActionsForPc,
		5,
		0
	);

	var node_2 = sibling(node, 2);

	{
		var consequent_1 = ($$anchor) => {
			var div = root_2$7();
			var button_1 = child(div);

			button_1.textContent = window.trans("More actions...");

			var div_1 = sibling(button_1, 2);
			var node_3 = child(div_1);

			add_svelte_meta(
				() => each(node_3, 17, () => Object.entries($$props.listActions), index, ($$anchor, $$item) => {
					var $$array_1 = user_derived(() => to_array(get$1($$item), 2));
					let key = () => get$1($$array_1)[0];

					key();

					let action = () => get$1($$array_1)[1];

					action();

					var a = root_3$9();

					a.__click = function (...$$args) {
						apply(() => $$props.doAction, this, $$args, ListActionsForPc, [23, 19]);
					};

					var node_4 = child(a);

					html(node_4, () => action().label);
					reset(a);
					template_effect(() => set_attribute(a, 'data-action-id', key()));
					append($$anchor, a);
				}),
				'each',
				ListActionsForPc,
				17,
				6
			);

			var node_5 = sibling(node_3, 2);

			{
				var consequent = ($$anchor) => {
					var h6 = root_4$6();

					h6.textContent = window.trans("Plugin Actions");
					append($$anchor, h6);
				};

				add_svelte_meta(
					() => if_block(node_5, ($$render) => {
						if (Object.keys($$props.moreListActions).length > 0) $$render(consequent);
					}),
					'if',
					ListActionsForPc,
					29,
					6
				);
			}

			var node_6 = sibling(node_5, 2);

			add_svelte_meta(
				() => each(node_6, 17, () => Object.entries($$props.moreListActions), index, ($$anchor, $$item) => {
					var $$array_2 = user_derived(() => to_array(get$1($$item), 2));
					let key = () => get$1($$array_2)[0];

					key();

					let action = () => get$1($$array_2)[1];

					action();

					var a_1 = root_5$4();

					a_1.__click = function (...$$args) {
						apply(() => $$props.doAction, this, $$args, ListActionsForPc, [41, 19]);
					};

					var node_7 = child(a_1);

					html(node_7, () => action().label);
					reset(a_1);
					template_effect(() => set_attribute(a_1, 'data-action-id', key()));
					append($$anchor, a_1);
				}),
				'each',
				ListActionsForPc,
				35,
				6
			);
			append($$anchor, div);
		};

		add_svelte_meta(
			() => if_block(node_2, ($$render) => {
				if ($$props.hasPulldownActions) $$render(consequent_1);
			}),
			'if',
			ListActionsForPc,
			11,
			0
		);
	}

	append($$anchor, fragment);

	return pop($$exports);
}

delegate(['click']);

ListActions[FILENAME] = 'src/listing/elements/ListActions.svelte';

var root$i = add_locations(from_html(`<div data-is="list-actions-for-pc" class="d-none d-md-block"><!></div> <div data-is="list-actions-for-mobile" class="d-md-none"><!></div>`, 1), ListActions[FILENAME], [[118, 0], [127, 0]]);

function ListActions($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	let selectedAction;
	let selectedActionId;
	let selectedActionPhrase;

	const doAction = (e) => {
		var _a;

		selectedActionId = (strict_equals(_a = e.target, null) || strict_equals(_a, void 0) ? void 0 : _a.dataset.actionId) || "";
		selectedAction = getAction(selectedActionId);

		if (!selectedAction) {
			return false;
		}

		selectedActionPhrase = selectedAction.js_message || window.trans("act upon");

		const args = {};

		if (!checkCount()) {
			return false;
		}

		if (selectedAction.input) {
			const input = prompt(selectedAction.input);

			if (input) {
				args.itemsetActionInput = input;
			} else {
				return false;
			}
		}

		if (!selectedAction.no_prompt) {
			if (selectedAction.continue_prompt) {
				if (!confirm(selectedAction.continue_prompt)) {
					return false;
				}
			} else {
				if (!confirm(getConfirmMessage())) {
					return false;
				}
			}
		}

		const requestArgs = generateRequestArguments(args);

		if (!selectedAction.xhr) {
			if (selectedAction.dialog) {
				// eslint-disable-next-line @typescript-eslint/no-explicit-any
				const requestData = $$props.listActionClient.generateRequestData(requestArgs);

				requestData.dialog = 1;

				const url = window.ScriptURI + "?" + jQuery.param(requestData, true);

				/* @ts-expect-error : mtModal is not defined */
				jQuery.fn.mtModal.open(url, { large: true });
			} else {
				sendRequest(requestArgs);
			}
		}
	};

	const sendRequest = (postArgs) => {
		$$props.listActionClient.post(postArgs);
	};

	const generateRequestArguments = (args) => {
		return {
			action: selectedAction,
			actionName: selectedActionId,
			allSelected: $$props.store.checkedAllRows,
			filter: $$props.store.currentFilter,
			ids: $$props.store.getCheckedRowIds(),
			...args
		};
	};

	const getAction = (actionId) => {
		return $$props.buttonActions[actionId] || $$props.listActions[actionId] || $$props.moreListActions[actionId] || null;
	};

	const getCheckedRowCount = () => {
		return $$props.store.getCheckedRowCount();
	};

	const checkCount = () => {
		const checkedRowCount = getCheckedRowCount();

		if (!checkedRowCount) {
			alertNoSelectedError();

			return false;
		}

		if (selectedAction && selectedAction.min && checkedRowCount < Number(selectedAction.min)) {
			alertMinimumError();

			return false;
		}

		if (selectedAction && selectedAction.max && checkedRowCount > Number(selectedAction.max)) {
			alertMaximumError();

			return false;
		}

		return true;
	};

	const alertNoSelectedError = () => {
		alert(window.trans("You did not select any [_1] to [_2].", $$props.plural, selectedActionPhrase));
	};

	const alertMinimumError = () => {
		alert(window.trans("You can only act upon a minimum of [_1] [_2].", selectedAction && selectedAction.min || "", $$props.plural));
	};

	const alertMaximumError = () => {
		alert(window.trans("You can only act upon a maximum of [_1] [_2].", selectedAction && selectedAction.max || "", $$props.plural));
	};

	const getConfirmMessage = () => {
		const checkedRowCount = getCheckedRowCount();

		if (strict_equals(checkedRowCount, 1)) {
			return window.trans("Are you sure you want to [_2] this [_1]?", $$props.singular, selectedActionPhrase);
		} else {
			return window.trans("Are you sure you want to [_3] the [_1] selected [_2]?", checkedRowCount.toString(), $$props.plural, selectedActionPhrase);
		}
	};

	var $$exports = { ...legacy_api() };
	var fragment = root$i();
	var div = first_child(fragment);
	var node = child(div);

	add_svelte_meta(
		() => ListActionsForPc(node, {
			get buttonActions() {
				return $$props.buttonActions;
			},

			doAction,

			get listActions() {
				return $$props.listActions;
			},

			get hasPulldownActions() {
				return $$props.hasPulldownActions;
			},

			get moreListActions() {
				return $$props.moreListActions;
			}
		}),
		'component',
		ListActions,
		119,
		2,
		{ componentTag: 'ListActionsForPc' }
	);

	var div_1 = sibling(div, 2);
	var node_1 = child(div_1);

	add_svelte_meta(
		() => ListActionsForMobile(node_1, {
			get buttonActions() {
				return $$props.buttonActions;
			},

			doAction,

			get listActions() {
				return $$props.listActions;
			},

			get moreListActions() {
				return $$props.moreListActions;
			}
		}),
		'component',
		ListActions,
		128,
		2,
		{ componentTag: 'ListActionsForMobile' }
	);
	append($$anchor, fragment);

	return pop($$exports);
}

ListCount[FILENAME] = 'src/listing/elements/ListCount.svelte';

var root$h = add_locations(from_html(`<div> </div>`), ListCount[FILENAME], [[10, 0]]);

function ListCount($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	let count = tag(user_derived(() => $$props.store.count || 0), 'count');
	let limit = tag(user_derived(() => $$props.store.limit || 0), 'limit');
	let page = tag(user_derived(() => $$props.store.page || 0), 'page');
	let from = tag(user_derived(() => strict_equals(get$1(count), 0) ? 0 : get$1(limit) * (get$1(page) - 1) + 1), 'from');
	let to = tag(user_derived(() => get$1(limit) * get$1(page) > get$1(count) ? get$1(count) : get$1(limit) * get$1(page)), 'to');
	var $$exports = { ...legacy_api() };
	var div = root$h();
	var text = child(div);
	template_effect(() => set_text(text, `${get$1(from) ?? ''} - ${get$1(to) ?? ''} / ${get$1(count) ?? ''}`));
	append($$anchor, div);

	return pop($$exports);
}

SVG[FILENAME] = 'src/svg/elements/SVG.svelte';

var root_1$a = add_locations(from_svg(`<title> </title>`), SVG[FILENAME], [[10, 4]]);
var root$g = add_locations(from_svg(`<svg role="img"><!><use></use></svg>`), SVG[FILENAME], [[8, 0, [[12, 2]]]]);

function SVG($$anchor, $$props) {
	check_target(new.target);
	push($$props, false);

	let className = prop($$props, 'class', 8);
	let href = prop($$props, 'href', 8);
	let title = prop($$props, 'title', 8);
	let style = prop($$props, 'style', 8, undefined);
	var $$exports = { ...legacy_api() };
	var svg = root$g();
	var node = child(svg);

	{
		var consequent = ($$anchor) => {
			var title_1 = root_1$a();
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

ListFilterItemField[FILENAME] = 'src/listing/elements/ListFilterItemField.svelte';

function ListFilterItemField($$anchor, $$props) {
	check_target(new.target);
	push($$props, false);

	let field = prop($$props, 'field', 8);
	let parentDiv = prop($$props, 'parentDiv', 8);
	let item = prop($$props, 'item', 8);
	let localeCalendarHeader = prop($$props, 'localeCalendarHeader', 8);

	afterUpdate(() => {
		setValues();
		initializeDateOption();
		initializeOptionWithBlank();
	});

	const setValues = () => {
		if (!parentDiv()) {
			return;
		}

		for (let key in item().args) {
			if (strict_equals(typeof item().args[key], "string", false) && strict_equals(typeof item().args[key], "number", false)) {
				continue;
			}

			const selector = "." + item().type + "-" + key;
			const elements = parentDiv().querySelectorAll(selector);

			Array.prototype.slice.call(elements).forEach(function (element) {
				if (strict_equals(element.tagName, "INPUT") || strict_equals(element.tagName, "SELECT")) {
					element.value = item().args[key];
				} else {
					element.textContent = item().args[key];
				}
			});
		}
	};

	const initializeDateOption = () => {
		if (!parentDiv()) {
			return;
		}

		const dateOption = ($node) => {
			const val = $node.val();
			let type;

			switch (val) {
				case "hours":
					type = "hours";
					break;

				case "days":
					type = "days";
					break;

				case "before":

				case "after":
					type = "date";
					break;

				case "future":

				case "past":

				case "blank":

				case "not_blank":
					type = "none";
					break;

				default:
					type = "range";
			}

			$node.parents(".item-content").find(".date-options span.date-option").hide();
			$node.parents(".item-content").find(".date-option." + type).show();
		};

		jQuery(parentDiv()).find(".filter-date").each(function (_index, element) {
			const $node = jQuery(element);

			dateOption($node);

			$node.on("change", function () {
				dateOption($node);
			});
		});

		jQuery(parentDiv()).find("input.date").datepicker({
			dateFormat: "yy-mm-dd",
			dayNamesMin: localeCalendarHeader(),

			monthNames: [
				"- 01",
				"- 02",
				"- 03",
				"- 04",
				"- 05",
				"- 06",
				"- 07",
				"- 08",
				"- 09",
				"- 10",
				"- 11",
				"- 12"
			],

			showMonthAfterYear: true,
			prevText: "<",
			nextText: ">"
		});
	};

	const initializeOptionWithBlank = () => {
		if (!parentDiv()) {
			return;
		}

		const changeOption = ($node) => {
			if (strict_equals($node.val(), "blank") || strict_equals($node.val(), "not_blank")) {
				$node.parent().find("input[type=text]").hide();
			} else {
				$node.parent().find("input[type=text]").show();
			}
		};

		jQuery(parentDiv()).find(".filter-blank").each(function (_index, element) {
			const $node = jQuery(element);

			changeOption($node);

			$node.on("change", function () {
				changeOption($node);
			});
		});
	};

	var $$exports = { ...legacy_api() };

	init();

	var fragment = comment();
	var node = first_child(fragment);

	html(node, field);
	append($$anchor, fragment);

	return pop($$exports);
}

ListFilterItem[FILENAME] = 'src/listing/elements/ListFilterItem.svelte';

var root_5$3 = add_locations(from_html(`<a href="javascript:void(0);" class="d-inline-block"><!></a>`), ListFilterItem[FILENAME], [[109, 16]]);
var root_6$2 = add_locations(from_html(`<a href="javascript:void(0);"><!></a>`), ListFilterItem[FILENAME], [[123, 16]]);
var root_3$8 = add_locations(from_html(`<div><div class="item-content form-inline"><!> <!> <!></div></div>`), ListFilterItem[FILENAME], [[91, 10, [[95, 12]]]]);
var root_1$9 = add_locations(from_html(`<div></div>`), ListFilterItem[FILENAME], [[88, 4]]);
var root_9 = add_locations(from_html(`<a href="javascript:void(0);" class="d-inline-block"><!></a>`), ListFilterItem[FILENAME], [[153, 10]]);
var root_7$2 = add_locations(from_html(`<div data-mt-list-item-content-index="0"><div class="item-content form-inline"><!> <!></div></div>`), ListFilterItem[FILENAME], [[138, 4, [[142, 6]]]]);
var root$f = add_locations(from_html(`<div class="filteritem"><button class="close btn-close" aria-label="Close"><span aria-hidden="true">&times;</span></button> <!> <!></div>`), ListFilterItem[FILENAME], [[83, 0, [[84, 2, [[85, 4]]]]]]);

function ListFilterItem($$anchor, $$props) {
	check_target(new.target);
	push($$props, false);

	const filterTypeHash = mutable_source();
	let currentFilter = prop($$props, 'currentFilter', 8);
	let filterTypes = prop($$props, 'filterTypes', 8);
	let item = prop($$props, 'item', 8);
	let listFilterTopAddFilterItemContent = prop($$props, 'listFilterTopAddFilterItemContent', 8);
	let listFilterTopRemoveFilterItem = prop($$props, 'listFilterTopRemoveFilterItem', 8);
	let listFilterTopRemoveFilterItemContent = prop($$props, 'listFilterTopRemoveFilterItemContent', 8);
	let localeCalendarHeader = prop($$props, 'localeCalendarHeader', 8);
	let fieldParentDivs = mutable_source([]);

	const addFilterItemContent = (e) => {
		const target = e.target;

		if (!target) {
			return;
		}

		const itemIndex = getListItemIndex(target);
		const contentIndex = getListItemContentIndex(target);
		let item = currentFilter().items[itemIndex];

		if (strict_equals(item.type, "pack")) {
			item = item.args.items[contentIndex];
		}

		jQuery(target).parent().each(function () {
			jQuery(this).find(":input").each(function () {
				var _a;
				const re = new RegExp(item.type + "-(\\w+)");
				const key = ((strict_equals(_a = jQuery(this).attr("class"), null) || strict_equals(_a, void 0) ? void 0 : _a.match(re)) || [])[1];

				if (key && !Object.prototype.hasOwnProperty.call(item.args, key)) {
					item.args[key] = jQuery(this).val();
				}
			});
		});

		listFilterTopAddFilterItemContent()(itemIndex.toString(), contentIndex.toString());
	};

	const getListItemIndex = (element) => {
		while (!Object.prototype.hasOwnProperty.call(element.dataset, "mtListItemIndex")) {
			if (element.parentElement) {
				element = element.parentElement;
			} else {
				return -1;
			}
		}

		return Number(element.dataset.mtListItemIndex);
	};

	const getListItemContentIndex = (element) => {
		while (!Object.prototype.hasOwnProperty.call(element.dataset, "mtListItemContentIndex")) {
			if (element.parentElement) {
				element = element.parentElement;
			} else {
				return -1;
			}
		}

		return Number(element.dataset.mtListItemContentIndex);
	};

	const removeFilterItem = (e) => {
		const target = e.target;

		if (!target) {
			return;
		}

		const itemIndex = getListItemIndex(target);

		listFilterTopRemoveFilterItem()(itemIndex.toString());
	};

	const removeFilterItemContent = (e) => {
		const target = e.target;

		if (!target) {
			return;
		}

		const itemIndex = getListItemIndex(target);
		const contentIndex = getListItemContentIndex(target);

		listFilterTopRemoveFilterItemContent()(itemIndex.toString(), contentIndex.toString());
	};

	legacy_pre_effect(() => (deep_read_state(filterTypes())), () => {
		set(filterTypeHash, filterTypes().reduce(
			(hash, filterType) => {
				hash[filterType.type] = filterType;

				return hash;
			},
			{}
		));
	});

	legacy_pre_effect_reset();

	var $$exports = { ...legacy_api() };

	init();

	var div = root$f();
	var button = child(div);

	button.__click = removeFilterItem;

	var node = sibling(button, 2);

	{
		var consequent_3 = ($$anchor) => {
			var div_1 = root_1$9();

			add_svelte_meta(
				() => each(
					div_1,
					5,
					() => (
						deep_read_state(item()),
						untrack(() => item().args.items)
					),
					index,
					($$anchor, loopItem, index) => {
						var fragment = comment();
						var node_1 = first_child(fragment);

						{
							var consequent_2 = ($$anchor) => {
								var div_2 = root_3$8();

								set_attribute(div_2, 'data-mt-list-item-content-index', index);

								var div_3 = child(div_2);
								var node_2 = child(div_3);

								add_svelte_meta(
									() => key(
										node_2,
										() => (
											deep_read_state(currentFilter()),
											get$1(fieldParentDivs),
											index,
											untrack(() => currentFilter() || get$1(fieldParentDivs)[index])
										),
										($$anchor) => {
											add_svelte_meta(
												() => ListFilterItemField($$anchor, {
													get field() {
														return (
															get$1(filterTypeHash),
															get$1(loopItem),
															untrack(() => get$1(filterTypeHash)[get$1(loopItem).type].field)
														);
													},

													get item() {
														return get$1(loopItem);
													},

													get parentDiv() {
														return (
															get$1(fieldParentDivs),
															index,
															untrack(() => get$1(fieldParentDivs)[index])
														);
													},

													get localeCalendarHeader() {
														return localeCalendarHeader();
													}
												}),
												'component',
												ListFilterItem,
												100,
												16,
												{ componentTag: 'ListFilterItemField' }
											);
										}
									),
									'key',
									ListFilterItem,
									99,
									14
								);

								var node_3 = sibling(node_2, 2);

								{
									var consequent = ($$anchor) => {
										var a = root_5$3();

										a.__click = addFilterItemContent;

										var node_4 = child(a);

										add_svelte_meta(
											() => SVG(node_4, {
												title: (untrack(() => window.trans("Add"))),
												class: 'mt-icon mt-icon--sm',

												href: (
													untrack(() => window.StaticURI + "images/sprite.svg#ic_add")
												)
											}),
											'component',
											ListFilterItem,
											114,
											18,
											{ componentTag: 'SVG' }
										);

										reset(a);
										append($$anchor, a);
									};

									add_svelte_meta(
										() => if_block(node_3, ($$render) => {
											if ((
												get$1(filterTypeHash),
												get$1(loopItem),
												untrack(() => !get$1(filterTypeHash)[get$1(loopItem).type].singleton)
											)) $$render(consequent);
										}),
										'if',
										ListFilterItem,
										107,
										14
									);
								}

								var node_5 = sibling(node_3, 2);

								{
									var consequent_1 = ($$anchor) => {
										var a_1 = root_6$2();

										a_1.__click = removeFilterItemContent;

										var node_6 = child(a_1);

										add_svelte_meta(
											() => SVG(node_6, {
												title: (untrack(() => window.trans("Remove"))),
												class: 'mt-icon mt-icon--sm',

												href: (
													untrack(() => window.StaticURI + "images/sprite.svg#ic_remove")
												)
											}),
											'component',
											ListFilterItem,
											124,
											18,
											{ componentTag: 'SVG' }
										);

										reset(a_1);
										append($$anchor, a_1);
									};

									add_svelte_meta(
										() => if_block(node_5, ($$render) => {
											if ((
												get$1(filterTypeHash),
												get$1(loopItem),
												deep_read_state(item()),
												untrack(() => !get$1(filterTypeHash)[get$1(loopItem).type].singleton && item().args.items.length > 1)
											)) $$render(consequent_1);
										}),
										'if',
										ListFilterItem,
										121,
										14
									);
								}

								reset(div_3);
								bind_this(div_3, ($$value, index) => mutate(fieldParentDivs, get$1(fieldParentDivs)[index] = $$value), (index) => get$1(fieldParentDivs)?.[index], () => [index]);
								reset(div_2);

								template_effect(() => set_class(div_2, 1, (
									get$1(loopItem),
									untrack(() => "filtertype type-" + get$1(loopItem).type)
								)));

								append($$anchor, div_2);
							};

							add_svelte_meta(
								() => if_block(node_1, ($$render) => {
									if ((
										get$1(filterTypeHash),
										get$1(loopItem),
										untrack(() => get$1(filterTypeHash)[get$1(loopItem).type])
									)) $$render(consequent_2);
								}),
								'if',
								ListFilterItem,
								90,
								8
							);
						}

						append($$anchor, fragment);
					}
				),
				'each',
				ListFilterItem,
				89,
				6
			);
			append($$anchor, div_1);
		};

		add_svelte_meta(
			() => if_block(node, ($$render) => {
				if ((
					deep_read_state(item()),
					untrack(() => strict_equals(item().type, "pack"))
				)) $$render(consequent_3);
			}),
			'if',
			ListFilterItem,
			87,
			2
		);
	}

	var node_7 = sibling(node, 2);

	{
		var consequent_5 = ($$anchor) => {
			var div_4 = root_7$2();
			var div_5 = child(div_4);
			var node_8 = child(div_5);

			add_svelte_meta(
				() => key(
					node_8,
					() => (
						deep_read_state(currentFilter()),
						get$1(fieldParentDivs),
						untrack(() => currentFilter() || get$1(fieldParentDivs)[0])
					),
					($$anchor) => {
						add_svelte_meta(
							() => ListFilterItemField($$anchor, {
								get field() {
									return (
										get$1(filterTypeHash),
										deep_read_state(item()),
										untrack(() => get$1(filterTypeHash)[item().type].field)
									);
								},

								get item() {
									return item();
								},

								get parentDiv() {
									return (
										get$1(fieldParentDivs),
										untrack(() => get$1(fieldParentDivs)[0])
									);
								},

								get localeCalendarHeader() {
									return localeCalendarHeader();
								}
							}),
							'component',
							ListFilterItem,
							144,
							10,
							{ componentTag: 'ListFilterItemField' }
						);
					}
				),
				'key',
				ListFilterItem,
				143,
				8
			);

			var node_9 = sibling(node_8, 2);

			{
				var consequent_4 = ($$anchor) => {
					var a_2 = root_9();

					a_2.__click = addFilterItemContent;

					var node_10 = child(a_2);

					add_svelte_meta(
						() => SVG(node_10, {
							title: (untrack(() => window.trans("Add"))),
							class: 'mt-icon mt-icon--sm',

							href: (
								untrack(() => window.StaticURI + "images/sprite.svg#ic_add")
							)
						}),
						'component',
						ListFilterItem,
						158,
						12,
						{ componentTag: 'SVG' }
					);
					append($$anchor, a_2);
				};

				add_svelte_meta(
					() => if_block(node_9, ($$render) => {
						if ((
							get$1(filterTypeHash),
							deep_read_state(item()),
							untrack(() => !get$1(filterTypeHash)[item().type].singleton)
						)) $$render(consequent_4);
					}),
					'if',
					ListFilterItem,
					151,
					8
				);
			}
			bind_this(div_5, ($$value) => mutate(fieldParentDivs, get$1(fieldParentDivs)[0] = $$value), () => get$1(fieldParentDivs)?.[0]);

			template_effect(() => set_class(div_4, 1, (
				deep_read_state(item()),
				untrack(() => "filtertype type-" + item().type)
			)));

			append($$anchor, div_4);
		};

		add_svelte_meta(
			() => if_block(node_7, ($$render) => {
				if ((
					deep_read_state(item()),
					get$1(filterTypeHash),
					untrack(() => strict_equals(item().type, "type", false) && get$1(filterTypeHash)[item().type])
				)) $$render(consequent_5);
			}),
			'if',
			ListFilterItem,
			137,
			2
		);
	}
	append($$anchor, div);

	return pop($$exports);
}

delegate(['click']);

ListFilterSaveModal[FILENAME] = 'src/listing/elements/ListFilterSaveModal.svelte';

var root$e = add_locations(from_html(`<div><div class="modal-dialog modal-sm"><div class="modal-content"><div class="modal-header"><h5 class="modal-title"> </h5> <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div> <div class="modal-body"><div style="padding-bottom: 30px;"><h6></h6> <input/></div></div> <div class="modal-footer"><button class="btn btn-primary"></button> <button class="btn btn-default" data-bs-dismiss="modal"></button></div></div></div></div>`), ListFilterSaveModal[FILENAME], [
	[
		41,
		0,

		[
			[
				48,
				2,

				[
					[
						49,
						4,

						[
							[50, 6, [[51, 8], [56, 8, [[62, 10]]]]],
							[65, 6, [[66, 8, [[67, 10], [68, 10]]]]],
							[77, 6, [[78, 8], [81, 8]]]
						]
					]
				]
			]
		]
	]
]);

function ListFilterSaveModal($$anchor, $$props) {
	check_target(new.target);
	push($$props, false);

	var $$ownership_validator = create_ownership_validator($$props);
	let currentFilter = prop($$props, 'currentFilter', 12);
	let listFilterTopGetItemValues = prop($$props, 'listFilterTopGetItemValues', 8);
	let store = prop($$props, 'store', 8);
	let modal = mutable_source();
	let filterName = mutable_source();
	let saveAs = mutable_source();

	const closeModal = () => {
		var _a;

		/* @ts-expect-error : bootstrap is not defined */
		strict_equals(_a = bootstrap.Modal.getInstance(get$1(modal)), null) || strict_equals(_a, void 0) ? void 0 : _a.hide();
	};

	const openModal = (args) => {
		if (!args) {
			args = {};
		}

		/* @ts-expect-error : mtUnvalidate is not defined */
		jQuery(get$1(filterName)).mtUnvalidate();

		if (args.filterLabel) {
			mutate(filterName, get$1(filterName).value = args.filterLabel);
		}

		set(saveAs, args.saveAs);

		/* @ts-expect-error : bootstrap is not defined */
		let $bsmodal = new bootstrap.Modal(get$1(modal), {});

		$bsmodal.show();
	};

	const saveFilter = () => {
		/* @ts-expect-error : mtValidate is not defined */
		if (!jQuery(get$1(filterName)).mtValidate("simple")) {
			return false;
		}

		listFilterTopGetItemValues()();
		$$ownership_validator.mutation(null, ['currentFilter', 'label'], currentFilter(currentFilter().label = get$1(filterName).value, true), 32, 4);

		if (get$1(saveAs)) {
			$$ownership_validator.mutation(null, ['currentFilter', 'id'], currentFilter(currentFilter().id = "", true), 34, 8);
		}

		store().trigger("save_filter", currentFilter());
		closeModal();
	};

	var $$exports = {
		get openModal() {
			return openModal;
		},

		...legacy_api()
	};

	init();

	var div = root$e();

	attribute_effect(div, () => ({
		id: 'save-filter',
		class: 'modal fade',
		tabindex: '-1',
		...{ ref: "modal" }
	}));

	var div_1 = child(div);
	var div_2 = child(div_1);
	var div_3 = child(div_2);
	var h5 = child(div_3);
	var text = child(h5);

	var div_4 = sibling(div_3, 2);
	var div_5 = child(div_4);
	var h6 = child(div_5);

	h6.textContent = (untrack(() => window.trans("Filter Label")));

	var input = sibling(h6, 2);

	attribute_effect(
		input,
		() => ({
			type: 'text',
			class: 'text full required form-control',
			name: 'filter_name',
			...{ ref: "filterName" }
		}),
		void 0,
		void 0,
		void 0,
		void 0,
		true
	);

	bind_this(input, ($$value) => set(filterName, $$value), () => get$1(filterName));

	var div_6 = sibling(div_4, 2);
	var button = child(div_6);

	button.__click = saveFilter;
	button.textContent = (untrack(() => window.trans("Save")));

	var button_1 = sibling(button, 2);

	button_1.__click = closeModal;
	button_1.textContent = (untrack(() => window.trans("Cancel")));
	bind_this(div, ($$value) => set(modal, $$value), () => get$1(modal));

	template_effect(($0) => set_text(text, $0), [
		() => (
			get$1(saveAs),

			untrack(() => get$1(saveAs)
				? window.trans("Save As Filter")
				: window.trans("Save Filter"))
		)
	]);

	append($$anchor, div);
	bind_prop($$props, 'openModal', openModal);

	return pop($$exports);
}

delegate(['click']);

ListFilterButtons[FILENAME] = 'src/listing/elements/ListFilterButtons.svelte';

var root_1$8 = add_locations(from_html(`<button class="btn btn-default"></button>`), ListFilterButtons[FILENAME], [[59, 2]]);
var root$d = add_locations(from_html(`<button class="btn btn-primary"></button> <button class="btn btn-default"></button> <!> <!>`, 1), ListFilterButtons[FILENAME], [[43, 0], [50, 0]]);

function ListFilterButtons($$anchor, $$props) {
	check_target(new.target);
	push($$props, false);

	let currentFilter = prop($$props, 'currentFilter', 8);
	let listFilterTopGetItemValues = prop($$props, 'listFilterTopGetItemValues', 8);
	let listFilterTopIsUserFilter = prop($$props, 'listFilterTopIsUserFilter', 8);
	let listFilterTopValidateFilterDetails = prop($$props, 'listFilterTopValidateFilterDetails', 8);
	let objectLabel = prop($$props, 'objectLabel', 8);
	let store = prop($$props, 'store', 8);
	let openModal = mutable_source();

	const applyFilter = () => {
		if (!listFilterTopValidateFilterDetails()()) {
			return false;
		}

		listFilterTopGetItemValues()();

		const noFilterId = true;

		store().trigger("apply_filter", currentFilter(), noFilterId);
	};

	const saveFilter = () => {
		if (!listFilterTopValidateFilterDetails()()) {
			return false;
		}

		if (listFilterTopIsUserFilter()()) {
			listFilterTopGetItemValues()();
			store().trigger("save_filter", currentFilter());
		} else {
			const filterLabel = store().getNewFilterLabel(objectLabel());

			get$1(openModal)({ filterLabel });
		}
	};

	const saveAsFilter = () => {
		if (!listFilterTopValidateFilterDetails()()) {
			return false;
		}

		get$1(openModal)({ filterLabel: currentFilter().label, saveAs: true });
	};

	var $$exports = { ...legacy_api() };

	init();

	var fragment = root$d();
	var button = first_child(fragment);

	button.__click = applyFilter;
	button.textContent = (untrack(() => window.trans("Apply")));

	var button_1 = sibling(button, 2);

	button_1.__click = saveFilter;
	button_1.textContent = (untrack(() => window.trans("Save")));

	var node = sibling(button_1, 2);

	{
		var consequent = ($$anchor) => {
			var button_2 = root_1$8();

			button_2.__click = saveAsFilter;
			button_2.textContent = (untrack(() => window.trans("Save As")));
			append($$anchor, button_2);
		};

		add_svelte_meta(
			() => if_block(node, ($$render) => {
				if ((
					deep_read_state(currentFilter()),
					untrack(() => currentFilter().id && currentFilter().items.length > 0)
				)) $$render(consequent);
			}),
			'if',
			ListFilterButtons,
			58,
			0
		);
	}

	var node_1 = sibling(node, 2);

	add_svelte_meta(
		() => ListFilterSaveModal(node_1, {
			get currentFilter() {
				return currentFilter();
			},

			get listFilterTopGetItemValues() {
				return listFilterTopGetItemValues();
			},

			get store() {
				return store();
			},

			get openModal() {
				return get$1(openModal);
			},

			set openModal($$value) {
				set(openModal, $$value);
			},

			$$legacy: true
		}),
		'component',
		ListFilterButtons,
		63,
		0,
		{ componentTag: 'ListFilterSaveModal' }
	);

	template_effect(
		($0) => {
			button.disabled = (
				deep_read_state(currentFilter()),
				untrack(() => strict_equals(currentFilter().items.length, 0))
			);

			button_1.disabled = $0;
		},
		[
			() => (
				deep_read_state(currentFilter()),
				untrack(() => strict_equals(currentFilter().items.length, 0) || strict_equals(currentFilter().can_save?.toString(), "0"))
			)
		]
	);

	append($$anchor, fragment);

	return pop($$exports);
}

delegate(['click']);

ListFilterDetail[FILENAME] = 'src/listing/elements/ListFilterDetail.svelte';

var root_2$6 = add_locations(from_html(`<a href="#"><!></a>`), ListFilterDetail[FILENAME], [[31, 16]]);
var root_3$7 = add_locations(from_html(`<li data-is="list-filter-item" class="list-group-item"><!></li>`), ListFilterDetail[FILENAME], [[56, 8]]);

var root$c = add_locations(from_html(`<div class="row"><div class="col-12"><ul class="list-inline"><li class="list-inline-item"><div class="dropdown"><button class="btn btn-default dropdown-toggle" data-bs-toggle="dropdown"></button> <div class="dropdown-menu"></div></div></li></ul></div></div> <div class="row mb-3"><div class="col-12"><ul class="list-group"></ul></div></div> <div class="row"><div data-is="list-filter-buttons" class="col-12"><!></div></div>`, 1), ListFilterDetail[FILENAME], [
	[
		16,
		0,

		[
			[17, 2, [[18, 4, [[19, 6, [[20, 8, [[21, 10], [27, 10]]]]]]]]]
		]
	],

	[51, 0, [[52, 2, [[53, 4]]]]],
	[75, 0, [[76, 2]]]
]);

function ListFilterDetail($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	const addFilterItem = (e) => {
		var _a, _b;

		if (strict_equals(_a = e.currentTarget, null) || strict_equals(_a, void 0) ? void 0 : _a.classList.contains("disabled")) {
			e.preventDefault();
			e.stopPropagation();

			return;
		}

		const filterType = (strict_equals(_b = e.currentTarget, null) || strict_equals(_b, void 0) ? void 0 : _b.dataset.mtFilterType) || "";

		$$props.listFilterTopAddFilterItem(filterType);
	};

	var $$exports = { ...legacy_api() };
	var fragment = root$c();
	var div = first_child(fragment);
	var div_1 = child(div);
	var ul = child(div_1);
	var li = child(ul);
	var div_2 = child(li);
	var button = child(div_2);

	button.textContent = window.trans("Select Filter Item...");

	var div_3 = sibling(button, 2);

	add_svelte_meta(
		() => each(div_3, 21, () => $$props.filterTypes, index, ($$anchor, filterType) => {
			var fragment_1 = comment();
			var node = first_child(fragment_1);

			{
				var consequent = ($$anchor) => {
					var a = root_2$6();
					let classes;

					a.__click = addFilterItem;

					var node_1 = child(a);

					html(node_1, () => get$1(filterType).label);
					reset(a);

					template_effect(
						($0) => {
							classes = set_class(a, 1, 'dropdown-item', null, classes, $0);
							set_attribute(a, 'data-mt-filter-type', get$1(filterType).type);
						},
						[
							() => ({
								disabled: $$props.isFilterItemSelected($$props.currentFilter, get$1(filterType).type)
							})
						]
					);

					append($$anchor, a);
				};

				add_svelte_meta(
					() => if_block(node, ($$render) => {
						if (get$1(filterType).editable) $$render(consequent);
					}),
					'if',
					ListFilterDetail,
					29,
					14
				);
			}

			append($$anchor, fragment_1);
		}),
		'each',
		ListFilterDetail,
		28,
		12
	);

	var div_4 = sibling(div, 2);
	var div_5 = child(div_4);
	var ul_1 = child(div_5);

	add_svelte_meta(
		() => each(ul_1, 21, () => $$props.currentFilter.items, index, ($$anchor, item, index) => {
			var li_1 = root_3$7();

			set_attribute(li_1, 'data-mt-list-item-index', index);

			var node_2 = child(li_1);

			add_svelte_meta(
				() => ListFilterItem(node_2, {
					get currentFilter() {
						return $$props.currentFilter;
					},

					get filterTypes() {
						return $$props.filterTypes;
					},

					get item() {
						return get$1(item);
					},

					get listFilterTopAddFilterItemContent() {
						return $$props.listFilterTopAddFilterItemContent;
					},

					get listFilterTopRemoveFilterItem() {
						return $$props.listFilterTopRemoveFilterItem;
					},

					get listFilterTopRemoveFilterItemContent() {
						return $$props.listFilterTopRemoveFilterItemContent;
					},

					get localeCalendarHeader() {
						return $$props.localeCalendarHeader;
					}
				}),
				'component',
				ListFilterDetail,
				61,
				10,
				{ componentTag: 'ListFilterItem' }
			);

			reset(li_1);
			append($$anchor, li_1);
		}),
		'each',
		ListFilterDetail,
		54,
		6
	);

	var div_6 = sibling(div_4, 2);
	var div_7 = child(div_6);
	var node_3 = child(div_7);

	add_svelte_meta(
		() => ListFilterButtons(node_3, {
			get currentFilter() {
				return $$props.currentFilter;
			},

			get listFilterTopGetItemValues() {
				return $$props.listFilterTopGetItemValues;
			},

			get listFilterTopIsUserFilter() {
				return $$props.listFilterTopIsUserFilter;
			},

			get listFilterTopValidateFilterDetails() {
				return $$props.listFilterTopValidateFilterDetails;
			},

			get objectLabel() {
				return $$props.objectLabel;
			},

			get store() {
				return $$props.store;
			}
		}),
		'component',
		ListFilterDetail,
		77,
		4,
		{ componentTag: 'ListFilterButtons' }
	);
	append($$anchor, fragment);

	return pop($$exports);
}

delegate(['click']);

ListFilterSelectModal[FILENAME] = 'src/listing/elements/ListFilterSelectModal.svelte';

var root_3$6 = add_locations(from_html(`<a href="#"> </a> <div class="float-end d-none d-md-block"><a href="#"></a> <a href="#" class="d-inline-block"><!></a></div>`, 1), ListFilterSelectModal[FILENAME], [[88, 20], [91, 20, [[93, 22], [97, 22]]]]);
var root_4$5 = add_locations(from_html(`<div class="form-inline"><div class="form-group form-group-sm"><input/> <button class="btn btn-default form-control"></button> <button class="btn btn-default form-control"></button></div></div>`), ListFilterSelectModal[FILENAME], [[107, 20, [[108, 22, [[109, 24], [115, 24], [122, 24]]]]]]);
var root_2$5 = add_locations(from_html(`<li class="filter line"><!> <!></li>`), ListFilterSelectModal[FILENAME], [[81, 16]]);
var root_7$1 = add_locations(from_html(`<li class="filter line"><a href="#"> </a></li>`), ListFilterSelectModal[FILENAME], [[160, 18, [[166, 20]]]]);
var root_5$2 = add_locations(from_html(`<div class="filter-list-block"><h6 class="filter-list-label"></h6> <ul id="built-in-filters" class="list-unstyled"></ul></div>`), ListFilterSelectModal[FILENAME], [[153, 10, [[154, 12], [157, 12]]]]);

var root$b = add_locations(from_html(`<div><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><h5 class="modal-title"></h5> <button type="button" class="close btn-close" data-bs-dismiss="modal"><span>×</span></button></div> <div class="modal-body"><div class="filter-list-block"><h6 class="filter-list-label"></h6> <ul id="user-filters" class="list-unstyled editable"><!> <li class="filter line d-none d-md-block"><a href="#" id="new_filter" class="icon-mini-left addnew create-new apply-link d-md-inline-block"><!> </a></li></ul></div> <!></div></div></div></div>`), ListFilterSelectModal[FILENAME], [
	[
		59,
		0,

		[
			[
				66,
				2,

				[
					[
						67,
						4,

						[
							[68, 6, [[69, 8], [70, 8, [[71, 11]]]]],

							[
								74,
								6,
								[[75, 8, [[76, 10], [77, 10, [[134, 12, [[136, 14]]]]]]]]
							]
						]
					]
				]
			]
		]
	]
]);

function ListFilterSelectModal($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	let isEditingFilter = tag(state(proxy({})), 'isEditingFilter');
	let modal;

	const applyFilter = (e) => {
		var _a;

		closeModal();

		const filterId = strict_equals(_a = e.target.parentElement, null) || strict_equals(_a, void 0) ? void 0 : _a.dataset.mtListFilterId;

		$$props.store.trigger("apply_filter_by_id", filterId);
	};

	const closeModal = () => {
		/* @ts-expect-error : bootstrap is not defined */
		bootstrap.Modal.getInstance(modal).hide();
	};

	const createNewFilter = () => {
		closeModal();
		$$props.store.trigger("open_filter_detail");
		$$props.listFilterTopCreateNewFilter();
		$$props.listFilterTopUpdate();
	};

	const renameFilter = (e) => {
		var _a, _b, _c;
		const target = e.target;
		const filterId = strict_equals(_c = strict_equals(_b = strict_equals(_a = target.parentElement, null) || strict_equals(_a, void 0) ? void 0 : _a.parentElement, null) || strict_equals(_b, void 0) ? void 0 : _b.parentElement, null) || strict_equals(_c, void 0) ? void 0 : _c.dataset.mtListFilterId;
		const filterLabel = target.previousElementSibling.value;

		if (!filterId) {
			return;
		}

		$$props.store.trigger("rename_filter_by_id", filterId, filterLabel);
		get$1(isEditingFilter)[filterId] = false;
	};

	const removeFilter = (e) => {
		const filterData = e.target.closest("[data-mt-list-filter-label]").dataset;
		const message = window.trans("Are you sure you want to remove filter '[_1]'?", filterData.mtListFilterLabel || "");

		if (strict_equals(confirm(message), false)) {
			return false;
		}

		$$props.store.trigger("remove_filter_by_id", filterData.mtListFilterId);
	};

	const startEditingFilter = (e) => {
		var _a, _b;
		const filterData = strict_equals(_b = strict_equals(_a = e.target.parentElement, null) || strict_equals(_a, void 0) ? void 0 : _a.parentElement, null) || strict_equals(_b, void 0) ? void 0 : _b.dataset;
		const filterId = (strict_equals(filterData, null) || strict_equals(filterData, void 0) ? void 0 : filterData.mtListFilterId) || "";

		if (strict_equals(filterId, "")) {
			return;
		}

		stopEditingAllFilters();
		get$1(isEditingFilter)[filterId] = true;
	};

	const stopEditingAllFilters = () => {
		set(isEditingFilter, {}, true);
	};

	const stopEditingFilter = (filterId) => {
		get$1(isEditingFilter)[filterId] = false;
	};

	var $$exports = { ...legacy_api() };
	var div = root$b();

	attribute_effect(div, () => ({
		class: 'modal fade',
		id: 'select-filter',
		tabindex: '-1',
		...{ ref: "modal" }
	}));

	var div_1 = child(div);
	var div_2 = child(div_1);
	var div_3 = child(div_2);
	var h5 = child(div_3);

	h5.textContent = window.trans("Select Filter");

	var div_4 = sibling(div_3, 2);
	var div_5 = child(div_4);
	var h6 = child(div_5);

	h6.textContent = window.trans("My Filters");

	var ul = sibling(h6, 2);
	var node = child(ul);

	add_svelte_meta(
		() => each(node, 17, () => $$props.store.filters, index, ($$anchor, filter) => {
			const filterId = tag(user_derived(() => get$1(filter).id ?? ""), 'filterId');

			get$1(filterId);

			var fragment = comment();
			var node_1 = first_child(fragment);

			{
				var consequent_2 = ($$anchor) => {
					var li = root_2$5();
					var node_2 = child(li);

					{
						var consequent = ($$anchor) => {
							var fragment_1 = root_3$6();
							var a = first_child(fragment_1);

							a.__click = applyFilter;

							var text = child(a, true);

							reset(a);

							var div_6 = sibling(a, 2);
							var a_1 = child(div_6);

							a_1.__click = startEditingFilter;
							a_1.textContent = `[${window.trans("rename") ?? ''}]`;

							var a_2 = sibling(a_1, 2);

							a_2.__click = removeFilter;

							var node_3 = child(a_2);

							add_svelte_meta(
								() => SVG(node_3, {
									title: window.trans("Remove"),
									class: 'mt-icon mt-icon--sm',
									href: window.StaticURI + "images/sprite.svg#ic_trash"
								}),
								'component',
								ListFilterSelectModal,
								98,
								24,
								{ componentTag: 'SVG' }
							);

							reset(a_2);
							reset(div_6);
							template_effect(() => set_text(text, get$1(filter).label));
							append($$anchor, fragment_1);
						};

						add_svelte_meta(
							() => if_block(node_2, ($$render) => {
								if (!get$1(isEditingFilter)[get$1(filterId)]) $$render(consequent);
							}),
							'if',
							ListFilterSelectModal,
							86,
							18
						);
					}

					var node_4 = sibling(node_2, 2);

					{
						var consequent_1 = ($$anchor) => {
							var div_7 = root_4$5();
							var div_8 = child(div_7);
							var input = child(div_8);

							attribute_effect(
								input,
								() => ({
									type: 'text',
									class: 'form-control rename-filter-input',
									value: get$1(filter).label,
									...{ ref: "label" }
								}),
								void 0,
								void 0,
								void 0,
								void 0,
								true
							);

							var button = sibling(input, 2);

							button.__click = renameFilter;
							button.textContent = window.trans("Save");

							var button_1 = sibling(button, 2);

							button_1.__click = () => stopEditingFilter(get$1(filterId));
							button_1.textContent = window.trans("Cancel");
							reset(div_8);
							reset(div_7);
							append($$anchor, div_7);
						};

						add_svelte_meta(
							() => if_block(node_4, ($$render) => {
								if (get$1(isEditingFilter)[get$1(filterId)]) $$render(consequent_1);
							}),
							'if',
							ListFilterSelectModal,
							106,
							18
						);
					}

					reset(li);

					template_effect(() => {
						set_attribute(li, 'data-mt-list-filter-id', get$1(filter).id);
						set_attribute(li, 'data-mt-list-filter-label', get$1(filter).label);
					});

					append($$anchor, li);
				};

				add_svelte_meta(
					() => if_block(node_1, ($$render) => {
						if (strict_equals(get$1(filter).can_save?.toString(), "1")) $$render(consequent_2);
					}),
					'if',
					ListFilterSelectModal,
					80,
					14
				);
			}

			append($$anchor, fragment);
		}),
		'each',
		ListFilterSelectModal,
		78,
		12
	);

	var li_1 = sibling(node, 2);
	var a_3 = child(li_1);

	a_3.__click = createNewFilter;

	var node_5 = child(a_3);

	add_svelte_meta(
		() => SVG(node_5, {
			title: window.trans("Add"),
			class: 'mt-icon mt-icon--sm',
			href: window.StaticURI + "images/sprite.svg#ic_add"
		}),
		'component',
		ListFilterSelectModal,
		142,
		16,
		{ componentTag: 'SVG' }
	);

	var text_1 = sibling(node_5);

	text_1.nodeValue = ` ${window.trans("Create New") ?? ''}`;

	var node_6 = sibling(div_5, 2);

	{
		var consequent_4 = ($$anchor) => {
			var div_9 = root_5$2();
			var h6_1 = child(div_9);

			h6_1.textContent = window.trans("Built in Filters");

			var ul_1 = sibling(h6_1, 2);

			add_svelte_meta(
				() => each(ul_1, 21, () => $$props.store.filters, index, ($$anchor, filter) => {
					var fragment_2 = comment();
					var node_7 = first_child(fragment_2);

					{
						var consequent_3 = ($$anchor) => {
							var li_2 = root_7$1();
							var a_4 = child(li_2);

							a_4.__click = applyFilter;

							var text_2 = child(a_4, true);

							reset(a_4);
							reset(li_2);

							template_effect(() => {
								set_attribute(li_2, 'data-mt-list-filter-id', get$1(filter).id);
								set_attribute(li_2, 'data-mt-list-filter-label', get$1(filter).label);
								set_text(text_2, get$1(filter).label);
							});

							append($$anchor, li_2);
						};

						add_svelte_meta(
							() => if_block(node_7, ($$render) => {
								if (strict_equals(get$1(filter).can_save?.toString(), "0")) $$render(consequent_3);
							}),
							'if',
							ListFilterSelectModal,
							159,
							16
						);
					}

					append($$anchor, fragment_2);
				}),
				'each',
				ListFilterSelectModal,
				158,
				14
			);
			append($$anchor, div_9);
		};

		add_svelte_meta(
			() => if_block(node_6, ($$render) => {
				if ($$props.store.hasSystemFilter()) $$render(consequent_4);
			}),
			'if',
			ListFilterSelectModal,
			152,
			8
		);
	}
	bind_this(div, ($$value) => modal = $$value, () => modal);
	append($$anchor, div);

	return pop($$exports);
}

delegate(['click']);

ListFilterHeader[FILENAME] = 'src/listing/elements/ListFilterHeader.svelte';

var root_1$7 = add_locations(from_html(`<a href="#" id="allpass-filter"></a>`), ListFilterHeader[FILENAME], [[36, 10]]);

var root$a = add_locations(from_html(`<div class="row"><div class="col-12 col-md-11"><ul class="list-inline mb-0"><li class="list-inline-item"></li> <li class="list-inline-item"><a href="#" id="opener" data-bs-toggle="modal" data-bs-target="#select-filter"><u> </u></a> <!></li> <li class="list-inline-item"><!></li></ul></div> <div class="d-none d-md-block col-md-1"><button id="toggle-filter-detail" class="btn btn-default dropdown-toggle float-end" data-bs-toggle="collapse" data-bs-target="#list-filter-collapse" aria-expanded="false" aria-controls="list-filter-collapse" aria-label="filter toggle"></button></div></div>`), ListFilterHeader[FILENAME], [
	[
		11,
		0,

		[
			[
				12,
				2,
				[[13, 4, [[14, 6], [17, 6, [[19, 8, [[25, 10]]]]], [33, 6]]]]
			],

			[43, 2, [[44, 4]]]
		]
	]
]);

function ListFilterHeader($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	const resetFilter = () => {
		$$props.listActionClient.removeFilterKeyFromReturnArgs();
		$$props.listActionClient.removeFilterItemFromReturnArgs();
		$$props.store.trigger("close_filter_detail");
		$$props.store.trigger("reset_filter");
	};

	var $$exports = { ...legacy_api() };
	var div = root$a();
	var div_1 = child(div);
	var ul = child(div_1);
	var li = child(ul);

	li.textContent = window.trans("Filter:");

	var li_1 = sibling(li, 2);
	var a = child(li_1);
	var u = child(a);
	var text = child(u);

	var node = sibling(a, 2);

	add_svelte_meta(
		() => ListFilterSelectModal(node, {
			get listFilterTopCreateNewFilter() {
				return $$props.listFilterTopCreateNewFilter;
			},

			get listFilterTopUpdate() {
				return $$props.listFilterTopUpdate;
			},

			get store() {
				return $$props.store;
			}
		}),
		'component',
		ListFilterHeader,
		27,
		8,
		{ componentTag: 'ListFilterSelectModal' }
	);

	var li_2 = sibling(li_1, 2);
	var node_1 = child(li_2);

	{
		var consequent = ($$anchor) => {
			var a_1 = root_1$7();

			a_1.__click = resetFilter;
			a_1.textContent = `[ ${window.trans("Reset Filter") ?? ''} ]`;
			append($$anchor, a_1);
		};

		add_svelte_meta(
			() => if_block(node_1, ($$render) => {
				if (strict_equals($$props.isAllpassFilter, false)) $$render(consequent);
			}),
			'if',
			ListFilterHeader,
			34,
			8
		);
	}
	template_effect(($0) => set_text(text, $0), [() => window.trans($$props.currentFilter.label)]);
	append($$anchor, div);

	return pop($$exports);
}

delegate(['click']);

ListFilter[FILENAME] = 'src/listing/elements/ListFilter.svelte';

var root$9 = add_locations(from_html(`<div data-is="list-filter-header" class="card-header"><!></div> <div id="list-filter-collapse" class="collapse"><div data-is="list-filter-detail" id="filter-detail" class="card-block p-3"><!></div></div>`, 1), ListFilter[FILENAME], [[168, 0], [178, 0, [[179, 2]]]]);

function ListFilter($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	let currentFilter = tag(state(proxy($$props.store.currentFilter)), 'currentFilter');
	let validateErrorMessage;

	const validateFilterName = (name) => {
		return !$$props.store.filters.some(function (filter) {
			return strict_equals(filter.label, name);
		});
	};

	/* @ts-expect-error : mtValidateRules is not defined */
	jQuery.mtValidateRules["[name=filter_name], .rename-filter-input"] = function (e) {
		const val = e.val();

		if (strict_equals(typeof val, "string", false)) {
			return this.raise(window.trans("Invalid type: [_1]", typeof val));
		}

		if (validateFilterName(val)) {
			return true;
		} else {
			return this.raise(window.trans('Label "[_1]" is already in use.', val));
		}
	};

	$$props.store.on("refresh_current_filter", () => {
		set(currentFilter, $$props.store.currentFilter, true);
	});

	$$props.store.on("open_filter_detail", () => {
		/* @ts-expect-error : collapse is not defined */
		jQuery("#list-filter-collapse").collapse("show");
	});

	$$props.store.on("close_filter_detail", () => {
		/* @ts-expect-error : collapse is not defined */
		jQuery("#list-filter-collapse").collapse("hide");
	});

	const addFilterItem = (filterType) => {
		if (get$1(isAllpassFilter)) {
			createNewFilter(window.trans("New Filter"));
		}

		get$1(currentFilter).items.push({ type: filterType, args: { items: [] } });
		update();
	};

	const addFilterItemContent = (itemIndex, contentIndex) => {
		getItemValues();

		if (strict_equals(get$1(currentFilter).items[itemIndex].type, "pack", false)) {
			const items = [get$1(currentFilter).items[itemIndex]];

			get$1(currentFilter).items[itemIndex] = { type: "pack", args: { op: "and", items } };
		}

		const type = get$1(currentFilter).items[itemIndex].args.items[0].type;

		get$1(currentFilter).items[itemIndex].args.items.splice(contentIndex + 1, 0, { type, args: {} });
		update();
	};

	const createNewFilter = (filterLabel) => {
		set(
			currentFilter,
			{
				can_delete: 0,
				can_save: 1,
				can_edit: 0,
				id: "",
				items: [],
				label: filterLabel || window.trans("New Filter")
			},
			true
		);
	};

	const getItemValues = () => {
		const items = jQuery("#filter-detail .filteritem:not(.error)");

		// eslint-disable-next-line @typescript-eslint/no-explicit-any
		let vals = [];

		items.each(function () {
			let data = {};
			const fields = [];
			const types = jQuery(this).find(".filtertype");

			types.each(function () {
				var _a;
				const type = ((strict_equals(_a = jQuery(this).attr("class"), null) || strict_equals(_a, void 0) ? void 0 : _a.match(/type-(\w+)/)) || [])[1];

				jQuery(this).find(".item-content").each(function () {
					const args = {};

					jQuery(this).find(":input").each(function () {
						var _a;
						const re = new RegExp(type + "-(\\w+)");
						const key = ((strict_equals(_a = jQuery(this).attr("class"), null) || strict_equals(_a, void 0) ? void 0 : _a.match(re)) || [])[1];

						if (key && !Object.prototype.hasOwnProperty.call(args, key)) {
							args[key] = jQuery(this).val();
						}
					});

					fields.push({ type, args });
				});
			});

			if (fields.length > 1) {
				data["type"] = "pack";
				data["args"] = { op: "and", items: fields };
			} else {
				data = fields.pop();
			}

			vals.push(data);
		});

		get$1(currentFilter).items = vals;
	};

	let isAllpassFilter = tag(user_derived(() => strict_equals(get$1(currentFilter).id, $$props.store.allpassFilter.id)), 'isAllpassFilter');

	/* add "filter" argument for updating this output after changing "filter" */
	const isFilterItemSelected = (filter, type) => {
		return filter.items.some(function (item) {
			return strict_equals(item.type, type);
		});
	};

	const isUserFilter = () => {
		return get$1(currentFilter).id && get$1(currentFilter).id.match(/^[1-9][0-9]*$/) ? true : false;
	};

	const removeFilterItem = (itemIndex) => {
		get$1(currentFilter).items.splice(Number(itemIndex), 1);
		update();
	};

	const removeFilterItemContent = (itemIndex, contentIndex) => {
		get$1(currentFilter).items[itemIndex].args.items.splice(contentIndex, 1);
		update();
	};

	const showMessage = (content, cls) => {
		const error_block = jQuery("<div />").attr("class", "msg msg-" + cls).append(jQuery("<p />").attr("class", "msg-text alert alert-danger alert-dismissible").append('<button type="button" class="close btn-close" data-bs-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>').append(content));

		jQuery("#msg-block").append(error_block);

		return error_block;
	};

	const validateFilterDetails = () => {
		if (validateErrorMessage) {
			validateErrorMessage.remove();
		}

		let errors = 0;

		jQuery("div#filter-detail div.filteritem").each(function () {
			/* @ts-expect-error : mtValidate is not defined */
			if (!jQuery(this).find("input:visible").mtValidate()) {
				errors++;
				jQuery(this).addClass("highlight error bg-warning");
			} else {
				jQuery(this).removeClass("highlight error bg-warning");
			}
		});

		if (errors) {
			validateErrorMessage = showMessage(window.trans("One or more fields in the filter item are not filled in properly."), "error");
		}

		return errors ? false : true;
	};

	const update = () => {
		// eslint-disable-next-line no-self-assign
		set(currentFilter, get$1(currentFilter), true);
	};

	var $$exports = { ...legacy_api() };
	var fragment = root$9();
	var div = first_child(fragment);
	var node = child(div);

	add_svelte_meta(
		() => ListFilterHeader(node, {
			get currentFilter() {
				return get$1(currentFilter);
			},

			get isAllpassFilter() {
				return get$1(isAllpassFilter);
			},

			listFilterTopCreateNewFilter: createNewFilter,
			listFilterTopUpdate: update,

			get listActionClient() {
				return $$props.listActionClient;
			},

			get store() {
				return $$props.store;
			}
		}),
		'component',
		ListFilter,
		169,
		2,
		{ componentTag: 'ListFilterHeader' }
	);

	var div_1 = sibling(div, 2);
	var div_2 = child(div_1);
	var node_1 = child(div_2);

	add_svelte_meta(
		() => ListFilterDetail(node_1, {
			get currentFilter() {
				return get$1(currentFilter);
			},

			get filterTypes() {
				return $$props.filterTypes;
			},

			isFilterItemSelected,
			listFilterTopAddFilterItem: addFilterItem,
			listFilterTopAddFilterItemContent: addFilterItemContent,
			listFilterTopGetItemValues: getItemValues,
			listFilterTopIsUserFilter: isUserFilter,
			listFilterTopRemoveFilterItem: removeFilterItem,
			listFilterTopRemoveFilterItemContent: removeFilterItemContent,
			listFilterTopValidateFilterDetails: validateFilterDetails,

			get localeCalendarHeader() {
				return $$props.localeCalendarHeader;
			},

			get objectLabel() {
				return $$props.objectLabel;
			},

			get store() {
				return $$props.store;
			}
		}),
		'component',
		ListFilter,
		180,
		4,
		{ componentTag: 'ListFilterDetail' }
	);
	append($$anchor, fragment);

	return pop($$exports);
}

ListPaginationForMobile[FILENAME] = 'src/listing/elements/ListPaginationForMobile.svelte';

var root_1$6 = add_locations(from_html(`<li><a href="javascript:void(0);" class="page-link"> </a></li>`), ListPaginationForMobile[FILENAME], [[24, 4, [[26, 6]]]]);
var root_2$4 = add_locations(from_html(`<li><a href="javascript:void(0);" class="page-link"> </a></li>`), ListPaginationForMobile[FILENAME], [[38, 4, [[40, 6]]]]);
var root_3$5 = add_locations(from_html(`<li><a href="javascript:void(0);" class="page-link"> </a></li>`), ListPaginationForMobile[FILENAME], [[52, 4, [[54, 6]]]]);
var root_4$4 = add_locations(from_html(`<li><a href="javascript:void(0);" class="page-link"> </a></li>`), ListPaginationForMobile[FILENAME], [[66, 4, [[68, 6]]]]);
var root_5$1 = add_locations(from_html(`<li><a href="javascript:void(0);" class="page-link"> </a></li>`), ListPaginationForMobile[FILENAME], [[88, 4, [[90, 6]]]]);
var root_6$1 = add_locations(from_html(`<li><a href="javascript:void(0);" class="page-link"> </a></li>`), ListPaginationForMobile[FILENAME], [[102, 4, [[104, 6]]]]);
var root_7 = add_locations(from_html(`<li><a href="javascript:void(0);" class="page-link"> </a></li>`), ListPaginationForMobile[FILENAME], [[116, 4, [[118, 6]]]]);
var root_8 = add_locations(from_html(`<li><a href="javascript:void(0);" class="page-link"> </a></li>`), ListPaginationForMobile[FILENAME], [[130, 4, [[132, 6]]]]);

var root$8 = add_locations(from_html(`<ul class="pagination__mobile d-md-none"><li><a><!></a></li> <!> <!> <!> <!> <li><a class="page-link"> <span class="visually-hidden">(current)</span></a></li> <!> <!> <!> <!> <li class="page-item"><a><!></a></li></ul>`), ListPaginationForMobile[FILENAME], [
	[
		5,
		0,

		[
			[6, 2, [[8, 4]]],
			[79, 2, [[81, 4, [[83, 6]]]]],
			[143, 2, [[145, 4]]]
		]
	]
]);

function ListPaginationForMobile($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$exports = { ...legacy_api() };
	var ul = root$8();
	var li = child(ul);
	let classes;
	var a = child(li);

	attribute_effect(a, () => ({
		href: 'javascript:void(0);',
		class: 'page-link',
		...$$props.previousDisabledProp,
		'data-page': $$props.page - 1,
		onclick: $$props.movePage
	}));

	var node = child(a);

	add_svelte_meta(
		() => SVG(node, {
			title: window.trans("Previous"),
			class: 'mt-icon--inverse mt-icon--sm',
			href: window.StaticURI + "images/sprite.svg#ic_tri-left"
		}),
		'component',
		ListPaginationForMobile,
		15,
		6,
		{ componentTag: 'SVG' }
	);

	var node_1 = sibling(li, 2);

	{
		var consequent = ($$anchor) => {
			var li_1 = root_1$6();
			let classes_1;
			var a_1 = child(li_1);

			a_1.__click = function (...$$args) {
				apply(() => $$props.movePage, this, $$args, ListPaginationForMobile, [30, 17]);
			};

			var text = child(a_1);

			template_effect(() => {
				classes_1 = set_class(li_1, 1, 'page-item', null, classes_1, { 'me-auto': $$props.isTooNarrowWidth });
				set_attribute(a_1, 'data-page', $$props.page - 4);
				set_text(text, $$props.page - 4);
			});

			append($$anchor, li_1);
		};

		add_svelte_meta(
			() => if_block(node_1, ($$render) => {
				if ($$props.page - 4 >= 1 && $$props.store.pageMax - $$props.page < 1) $$render(consequent);
			}),
			'if',
			ListPaginationForMobile,
			23,
			2
		);
	}

	var node_2 = sibling(node_1, 2);

	{
		var consequent_1 = ($$anchor) => {
			var li_2 = root_2$4();
			let classes_2;
			var a_2 = child(li_2);

			a_2.__click = function (...$$args) {
				apply(() => $$props.movePage, this, $$args, ListPaginationForMobile, [44, 17]);
			};

			var text_1 = child(a_2);

			template_effect(() => {
				classes_2 = set_class(li_2, 1, 'page-item', null, classes_2, { 'me-auto': $$props.isTooNarrowWidth });
				set_attribute(a_2, 'data-page', $$props.page - 3);
				set_text(text_1, $$props.page - 3);
			});

			append($$anchor, li_2);
		};

		add_svelte_meta(
			() => if_block(node_2, ($$render) => {
				if ($$props.page - 3 >= 1 && $$props.store.pageMax - $$props.page < 2) $$render(consequent_1);
			}),
			'if',
			ListPaginationForMobile,
			37,
			2
		);
	}

	var node_3 = sibling(node_2, 2);

	{
		var consequent_2 = ($$anchor) => {
			var li_3 = root_3$5();
			let classes_3;
			var a_3 = child(li_3);

			a_3.__click = function (...$$args) {
				apply(() => $$props.movePage, this, $$args, ListPaginationForMobile, [58, 17]);
			};

			var text_2 = child(a_3);

			template_effect(() => {
				classes_3 = set_class(li_3, 1, 'page-item', null, classes_3, { 'me-auto': $$props.isTooNarrowWidth });
				set_attribute(a_3, 'data-page', $$props.page - 2);
				set_text(text_2, $$props.page - 2);
			});

			append($$anchor, li_3);
		};

		add_svelte_meta(
			() => if_block(node_3, ($$render) => {
				if ($$props.page - 2 >= 1) $$render(consequent_2);
			}),
			'if',
			ListPaginationForMobile,
			51,
			2
		);
	}

	var node_4 = sibling(node_3, 2);

	{
		var consequent_3 = ($$anchor) => {
			var li_4 = root_4$4();
			let classes_4;
			var a_4 = child(li_4);

			a_4.__click = function (...$$args) {
				apply(() => $$props.movePage, this, $$args, ListPaginationForMobile, [72, 17]);
			};

			var text_3 = child(a_4);

			template_effect(() => {
				classes_4 = set_class(li_4, 1, 'page-item', null, classes_4, { 'me-auto': $$props.isTooNarrowWidth });
				set_attribute(a_4, 'data-page', $$props.page - 1);
				set_text(text_3, $$props.page - 1);
			});

			append($$anchor, li_4);
		};

		add_svelte_meta(
			() => if_block(node_4, ($$render) => {
				if ($$props.page - 1 >= 1) $$render(consequent_3);
			}),
			'if',
			ListPaginationForMobile,
			65,
			2
		);
	}

	var li_5 = sibling(node_4, 2);
	let classes_5;
	var a_5 = child(li_5);
	var text_4 = child(a_5);

	var node_5 = sibling(li_5, 2);

	{
		var consequent_4 = ($$anchor) => {
			var li_6 = root_5$1();
			let classes_6;
			var a_6 = child(li_6);

			a_6.__click = function (...$$args) {
				apply(() => $$props.movePage, this, $$args, ListPaginationForMobile, [94, 17]);
			};

			var text_5 = child(a_6);

			template_effect(() => {
				classes_6 = set_class(li_6, 1, 'page-item', null, classes_6, { 'me-auto': $$props.isTooNarrowWidth });
				set_attribute(a_6, 'data-page', $$props.page + 1);
				set_text(text_5, $$props.page + 1);
			});

			append($$anchor, li_6);
		};

		add_svelte_meta(
			() => if_block(node_5, ($$render) => {
				if ($$props.page + 1 <= $$props.store.pageMax) $$render(consequent_4);
			}),
			'if',
			ListPaginationForMobile,
			87,
			2
		);
	}

	var node_6 = sibling(node_5, 2);

	{
		var consequent_5 = ($$anchor) => {
			var li_7 = root_6$1();
			let classes_7;
			var a_7 = child(li_7);

			a_7.__click = function (...$$args) {
				apply(() => $$props.movePage, this, $$args, ListPaginationForMobile, [108, 17]);
			};

			var text_6 = child(a_7);

			template_effect(() => {
				classes_7 = set_class(li_7, 1, 'page-item', null, classes_7, { 'me-auto': $$props.isTooNarrowWidth });
				set_attribute(a_7, 'data-page', $$props.page + 2);
				set_text(text_6, $$props.page + 2);
			});

			append($$anchor, li_7);
		};

		add_svelte_meta(
			() => if_block(node_6, ($$render) => {
				if ($$props.page + 2 <= $$props.store.pageMax) $$render(consequent_5);
			}),
			'if',
			ListPaginationForMobile,
			101,
			2
		);
	}

	var node_7 = sibling(node_6, 2);

	{
		var consequent_6 = ($$anchor) => {
			var li_8 = root_7();
			let classes_8;
			var a_8 = child(li_8);

			a_8.__click = function (...$$args) {
				apply(() => $$props.movePage, this, $$args, ListPaginationForMobile, [122, 17]);
			};

			var text_7 = child(a_8);

			template_effect(() => {
				classes_8 = set_class(li_8, 1, 'page-item', null, classes_8, { 'me-auto': $$props.isTooNarrowWidth });
				set_attribute(a_8, 'data-page', $$props.page + 3);
				set_text(text_7, $$props.page + 3);
			});

			append($$anchor, li_8);
		};

		add_svelte_meta(
			() => if_block(node_7, ($$render) => {
				if ($$props.page + 3 <= $$props.store.pageMax && $$props.page <= 2) $$render(consequent_6);
			}),
			'if',
			ListPaginationForMobile,
			115,
			2
		);
	}

	var node_8 = sibling(node_7, 2);

	{
		var consequent_7 = ($$anchor) => {
			var li_9 = root_8();
			let classes_9;
			var a_9 = child(li_9);

			a_9.__click = function (...$$args) {
				apply(() => $$props.movePage, this, $$args, ListPaginationForMobile, [136, 17]);
			};

			var text_8 = child(a_9);

			template_effect(() => {
				classes_9 = set_class(li_9, 1, 'page-item', null, classes_9, { 'me-auto': $$props.isTooNarrowWidth });
				set_attribute(a_9, 'data-page', $$props.page + 4);
				set_text(text_8, $$props.page + 4);
			});

			append($$anchor, li_9);
		};

		add_svelte_meta(
			() => if_block(node_8, ($$render) => {
				if ($$props.page + 4 <= $$props.store.pageMax && $$props.page <= 1) $$render(consequent_7);
			}),
			'if',
			ListPaginationForMobile,
			129,
			2
		);
	}

	var li_10 = sibling(node_8, 2);
	var a_10 = child(li_10);

	attribute_effect(a_10, () => ({
		href: 'javascript:void(0);',
		class: 'page-link',
		...$$props.nextDisabledProp,
		'data-page': $$props.page + 1,
		onclick: $$props.movePage
	}));

	var node_9 = child(a_10);

	add_svelte_meta(
		() => SVG(node_9, {
			title: window.trans("Next"),
			class: 'mt-icon--inverse mt-icon--sm',
			href: window.StaticURI + "images/sprite.svg#ic_tri-right"
		}),
		'component',
		ListPaginationForMobile,
		152,
		6,
		{ componentTag: 'SVG' }
	);

	template_effect(() => {
		classes = set_class(li, 1, 'page-item', null, classes, { 'me-auto': $$props.isTooNarrowWidth });
		classes_5 = set_class(li_5, 1, 'page-item active', null, classes_5, { 'me-auto': $$props.isTooNarrowWidth });
		set_text(text_4, `${$$props.page ?? ''} `);
	});

	append($$anchor, ul);

	return pop($$exports);
}

delegate(['click']);

ListPaginationForPc[FILENAME] = 'src/listing/elements/ListPaginationForPc.svelte';

var root_1$5 = add_locations(from_html(`<li class="page-item first-last"><a href="javascript:void(0);" class="page-link">1</a></li>`), ListPaginationForPc[FILENAME], [[20, 4, [[22, 6]]]]);
var root_2$3 = add_locations(from_html(`<li class="page-item" aria-hidden="true">...</li>`), ListPaginationForPc[FILENAME], [[34, 4]]);
var root_3$4 = add_locations(from_html(`<li><a href="javascript:void(0);" class="page-link"> </a></li>`), ListPaginationForPc[FILENAME], [[38, 4, [[40, 6]]]]);
var root_4$3 = add_locations(from_html(`<li><a href="javascript:void(0);" class="page-link"> </a></li>`), ListPaginationForPc[FILENAME], [[60, 4, [[62, 6]]]]);
var root_5 = add_locations(from_html(`<li class="page-item" aria-hidden="true">...</li>`), ListPaginationForPc[FILENAME], [[74, 4]]);
var root_6 = add_locations(from_html(`<li class="page-item first-last"><a href="javascript:void(0);" class="page-link"> </a></li>`), ListPaginationForPc[FILENAME], [[78, 4, [[80, 6]]]]);

var root$7 = add_locations(from_html(`<ul class="pagination d-none d-md-flex"><li class="page-item"><a></a></li> <!> <!> <!> <li class="page-item active"><a class="page-link"> <span class="visually-hidden">(current)</span></a></li> <!> <!> <!> <li class="page-item"><a></a></li></ul>`), ListPaginationForPc[FILENAME], [
	[
		5,
		0,

		[
			[6, 2, [[8, 4]]],
			[51, 2, [[53, 4, [[55, 6]]]]],
			[91, 2, [[93, 4]]]
		]
	]
]);

function ListPaginationForPc($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$exports = { ...legacy_api() };
	var ul = root$7();
	var li = child(ul);
	var a = child(li);

	attribute_effect(a, () => ({
		href: 'javascript:void(0);',
		class: 'page-link',
		...$$props.previousDisabledProp,
		'data-page': $$props.page - 1,
		onclick: $$props.movePage
	}));

	a.textContent = window.trans("Previous");

	var node = sibling(li, 2);

	{
		var consequent = ($$anchor) => {
			var li_1 = root_1$5();
			var a_1 = child(li_1);

			set_attribute(a_1, 'data-page', 1);

			a_1.__click = function (...$$args) {
				apply(() => $$props.movePage, this, $$args, ListPaginationForPc, [26, 17]);
			};
			append($$anchor, li_1);
		};

		add_svelte_meta(
			() => if_block(node, ($$render) => {
				if ($$props.page - 2 >= 1) $$render(consequent);
			}),
			'if',
			ListPaginationForPc,
			19,
			2
		);
	}

	var node_1 = sibling(node, 2);

	{
		var consequent_1 = ($$anchor) => {
			var li_2 = root_2$3();

			append($$anchor, li_2);
		};

		add_svelte_meta(
			() => if_block(node_1, ($$render) => {
				if ($$props.page - 3 >= 1) $$render(consequent_1);
			}),
			'if',
			ListPaginationForPc,
			33,
			2
		);
	}

	var node_2 = sibling(node_1, 2);

	{
		var consequent_2 = ($$anchor) => {
			var li_3 = root_3$4();
			let classes;
			var a_2 = child(li_3);

			a_2.__click = function (...$$args) {
				apply(() => $$props.movePage, this, $$args, ListPaginationForPc, [44, 17]);
			};

			var text = child(a_2);

			template_effect(() => {
				classes = set_class(li_3, 1, 'page-item', null, classes, { 'first-last': strict_equals($$props.page - 1, 1) });
				set_attribute(a_2, 'data-page', $$props.page - 1);
				set_text(text, $$props.page - 1);
			});

			append($$anchor, li_3);
		};

		add_svelte_meta(
			() => if_block(node_2, ($$render) => {
				if ($$props.page - 1 >= 1) $$render(consequent_2);
			}),
			'if',
			ListPaginationForPc,
			37,
			2
		);
	}

	var li_4 = sibling(node_2, 2);
	var a_3 = child(li_4);
	var text_1 = child(a_3);

	var node_3 = sibling(li_4, 2);

	{
		var consequent_3 = ($$anchor) => {
			var li_5 = root_4$3();
			let classes_1;
			var a_4 = child(li_5);

			a_4.__click = function (...$$args) {
				apply(() => $$props.movePage, this, $$args, ListPaginationForPc, [66, 17]);
			};

			var text_2 = child(a_4);

			template_effect(() => {
				classes_1 = set_class(li_5, 1, 'page-item', null, classes_1, {
					'first-last': strict_equals($$props.page + 1, $$props.store.pageMax)
				});

				set_attribute(a_4, 'data-page', $$props.page + 1);
				set_text(text_2, $$props.page + 1);
			});

			append($$anchor, li_5);
		};

		add_svelte_meta(
			() => if_block(node_3, ($$render) => {
				if ($$props.page + 1 <= $$props.store.pageMax) $$render(consequent_3);
			}),
			'if',
			ListPaginationForPc,
			59,
			2
		);
	}

	var node_4 = sibling(node_3, 2);

	{
		var consequent_4 = ($$anchor) => {
			var li_6 = root_5();

			append($$anchor, li_6);
		};

		add_svelte_meta(
			() => if_block(node_4, ($$render) => {
				if ($$props.page + 3 <= $$props.store.pageMax) $$render(consequent_4);
			}),
			'if',
			ListPaginationForPc,
			73,
			2
		);
	}

	var node_5 = sibling(node_4, 2);

	{
		var consequent_5 = ($$anchor) => {
			var li_7 = root_6();
			var a_5 = child(li_7);

			a_5.__click = function (...$$args) {
				apply(() => $$props.movePage, this, $$args, ListPaginationForPc, [84, 17]);
			};

			var text_3 = child(a_5);

			template_effect(() => {
				set_attribute(a_5, 'data-page', $$props.store.pageMax);
				set_text(text_3, $$props.store.pageMax);
			});

			append($$anchor, li_7);
		};

		add_svelte_meta(
			() => if_block(node_5, ($$render) => {
				if ($$props.page + 2 <= $$props.store.pageMax) $$render(consequent_5);
			}),
			'if',
			ListPaginationForPc,
			77,
			2
		);
	}

	var li_8 = sibling(node_5, 2);
	var a_6 = child(li_8);

	attribute_effect(a_6, () => ({
		href: 'javascript:void(0);',
		class: 'page-link',
		...$$props.nextDisabledProp,
		'data-page': $$props.page + 1,
		onclick: $$props.movePage
	}));

	a_6.textContent = window.trans("Next");
	template_effect(() => set_text(text_1, `${$$props.page ?? ''} `));
	append($$anchor, ul);

	return pop($$exports);
}

delegate(['click']);

ListPagination[FILENAME] = 'src/listing/elements/ListPagination.svelte';

var root$6 = add_locations(from_html(`<div><nav><!> <!></nav></div>`), ListPagination[FILENAME], [[57, 0, [[58, 2]]]]);

function ListPagination($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	let nextDisabledProp = {};
	let isTooNarrowWidth;
	let previousDisabledProp = {};
	let page = tag(user_derived(() => $$props.store.page || 0), 'page');

	user_effect(() => {
		previousDisabledProp = {};

		if (get$1(page) <= 1) {
			previousDisabledProp.disabled = "disabled";
		}
	});

	user_effect(() => {
		nextDisabledProp = {};

		if (get$1(page) >= $$props.store.pageMax) {
			nextDisabledProp.disabled = "disabled";
		}
	});

	onMount(() => {
		checkTooNarrowWidth();
	});

	const checkTooNarrowWidth = () => {
		isTooNarrowWidth = $$props.store.pageMax >= 5 && window.innerWidth < 400;
	};

	const movePage = (e) => {
		const currentTarget = e.currentTarget;

		if (currentTarget.getAttribute("disabled")) {
			return false;
		}

		let nextPage;

		/* Comment out old unused code */
		// if (target.tagName === "INPUT") {
		//   if (e.which !== 13) {
		//     return false;
		//   }
		//   nextPage = Number((target as HTMLInputElement).value);
		// } else {
		//   nextPage = Number(currentTarget.dataset.page);
		// }
		nextPage = Number(currentTarget.dataset.page);

		if (!nextPage) {
			return false;
		}

		const moveToPagination = true;

		$$props.store.trigger("move_page", nextPage, moveToPagination);

		return false;
	};

	var $$exports = { ...legacy_api() };
	var div = root$6();

	event('resize', $window, checkTooNarrowWidth);
	event('orientationchange', $window, checkTooNarrowWidth);

	let classes;
	var nav = child(div);
	var node = child(nav);

	add_svelte_meta(
		() => ListPaginationForPc(node, {
			movePage,

			get nextDisabledProp() {
				return nextDisabledProp;
			},

			get page() {
				return get$1(page);
			},

			get previousDisabledProp() {
				return previousDisabledProp;
			},

			get store() {
				return $$props.store;
			}
		}),
		'component',
		ListPagination,
		59,
		4,
		{ componentTag: 'ListPaginationForPc' }
	);

	var node_1 = sibling(node, 2);

	add_svelte_meta(
		() => ListPaginationForMobile(node_1, {
			get isTooNarrowWidth() {
				return isTooNarrowWidth;
			},

			get nextDisabledProp() {
				return nextDisabledProp;
			},

			get page() {
				return get$1(page);
			},

			get previousDisabledProp() {
				return previousDisabledProp;
			},

			movePage,

			get store() {
				return $$props.store;
			}
		}),
		'component',
		ListPagination,
		66,
		4,
		{ componentTag: 'ListPaginationForMobile' }
	);

	template_effect(() => {
		classes = set_class(div, 1, 'col-auto mx-auto', null, classes, { 'w-100': isTooNarrowWidth });
		set_attribute(nav, 'aria-label', $$props.store.listClient.objectType + " list");
	});

	append($$anchor, div);

	return pop($$exports);
}

ListTableRow[FILENAME] = 'src/listing/elements/ListTableRow.svelte';

var root_2$2 = add_locations(from_html(`<div class="form-check"><input type="checkbox" name="id" class="form-check-input"/> <span class="custom-control-indicator"></span> <label class="form-check-label"><span class="visually-hidden"></span></label></div>`), ListTableRow[FILENAME], [[37, 6, [[40, 8], [48, 8], [49, 8, [[50, 11]]]]]]);
var root_1$4 = add_locations(from_html(`<td><!></td>`), ListTableRow[FILENAME], [[32, 2]]);
var root_4$2 = add_locations(from_html(`<td data-is="list-table-column"><!></td>`), ListTableRow[FILENAME], [[59, 4]]);
var root$5 = add_locations(from_html(`<!> <!>`, 1), ListTableRow[FILENAME], []);

function ListTableRow($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	const classes = (index) => {
		const nameClass = $$props.store.showColumns[index].id;
		let classes;

		if ($$props.store.hasMobileColumn()) {
			if (strict_equals($$props.store.getMobileColumnIndex().toString(), index)) {
				classes = "d-md-none";
			} else {
				classes = "d-none d-md-table-cell";
			}
		} else {
			if ($$props.store.showColumns[index].primary) {
				classes = "";
			} else {
				classes = "d-none d-md-table-cell";
			}
		}

		if (classes.length > 0) {
			return nameClass + " " + classes;
		} else {
			return nameClass;
		}
	};

	var $$exports = { ...legacy_api() };
	var fragment = root$5();
	var node = first_child(fragment);

	{
		var consequent_1 = ($$anchor) => {
			var td = root_1$4();
			let classes_1;
			var node_1 = child(td);

			{
				var consequent = ($$anchor) => {
					var div = root_2$2();
					var input = child(div);

					var label = sibling(input, 4);
					var span = child(label);

					span.textContent = window.trans("Select");

					template_effect(() => {
						set_attribute(input, 'id', "select_" + $$props.object[0]);
						set_value(input, $$props.object[0]);
						set_checked(input, $$props.checked);
						set_attribute(label, 'for', "select_" + $$props.object[0]);
					});

					append($$anchor, div);
				};

				add_svelte_meta(
					() => if_block(node_1, ($$render) => {
						if ($$props.object[0]) $$render(consequent);
					}),
					'if',
					ListTableRow,
					36,
					4
				);
			}

			template_effect(() => classes_1 = set_class(td, 1, '', null, classes_1, {
				'd-none': !$$props.hasMobilePulldownActions,
				'd-md-table-cell': !$$props.hasMobilePulldownActions
			}));

			append($$anchor, td);
		};

		add_svelte_meta(
			() => if_block(node, ($$render) => {
				if ($$props.hasListActions) $$render(consequent_1);
			}),
			'if',
			ListTableRow,
			31,
			0
		);
	}

	var node_2 = sibling(node, 2);

	add_svelte_meta(
		() => each(node_2, 17, () => $$props.object, index, ($$anchor, content, index) => {
			var fragment_1 = comment();
			var node_3 = first_child(fragment_1);

			{
				var consequent_2 = ($$anchor) => {
					var td_1 = root_4$2();
					var node_4 = child(td_1);

					html(node_4, () => get$1(content));
					reset(td_1);
					template_effect(($0) => set_class(td_1, 1, $0), [() => clsx(classes((index - 1).toString()))]);
					append($$anchor, td_1);
				};

				add_svelte_meta(
					() => if_block(node_3, ($$render) => {
						if (index > 0) $$render(consequent_2);
					}),
					'if',
					ListTableRow,
					57,
					2
				);
			}

			append($$anchor, fragment_1);
		}),
		'each',
		ListTableRow,
		56,
		0
	);

	append($$anchor, fragment);

	return pop($$exports);
}

ListTableBody[FILENAME] = 'src/listing/elements/ListTableBody.svelte';

var root_1$3 = add_locations(from_html(`<tr><td> </td></tr>`), ListTableBody[FILENAME], [[46, 2, [[47, 4]]]]);
var root_2$1 = add_locations(from_html(`<tr style="background-color: #ffffff;"><td><a href="javascript:void(0);"> </a></td></tr>`), ListTableBody[FILENAME], [[54, 2, [[55, 4, [[57, 6]]]]]]);
var root_3$3 = add_locations(from_html(`<tr class="success"><td> </td></tr>`), ListTableBody[FILENAME], [[65, 2, [[66, 4]]]]);
var root_4$1 = add_locations(from_html(`<tr><!></tr>`), ListTableBody[FILENAME], [[74, 2]]);
var root$4 = add_locations(from_html(`<!> <!> <!> <!>`, 1), ListTableBody[FILENAME], []);

function ListTableBody($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	const clickRow = (e) => {
		$$props.store.trigger("reset_all_clicked_rows");

		const target = e.target;

		if (strict_equals(target.tagName, "A") || strict_equals(target.tagName, "IMG") || strict_equals(target.tagName, "svg")) {
			return false;
		}

		const currentTarget = e.currentTarget;

		/* @ts-expect-error : MT is not defined */
		if (MT.Util.isMobileView()) {
			let mobileColumn;

			if (strict_equals(target.dataset.is, "list-table-column")) {
				mobileColumn = jQuery(target);
			} else {
				mobileColumn = jQuery(target).parents("[data-is=list-table-column]");
			}

			if (mobileColumn.length > 0 && mobileColumn.find("a").length > 0) {
				mobileColumn.find("a")[0].click();
				$$props.store.trigger("click_row", currentTarget.dataset.index);

				return false;
			}
		}

		e.stopPropagation();
		$$props.store.trigger("toggle_row", currentTarget.dataset.index);
	};

	const checkAllRows = () => {
		$$props.store.trigger("check_all_rows");
	};

	const trProps = (obj) => {
		let props = {};

		if (obj.checked || obj.clicked) {
			props.class = "mt-table__highlight";
		}

		if (obj.checked) {
			props.checked = "checked";
		}

		return props;
	};

	var $$exports = { ...legacy_api() };
	var fragment = root$4();
	var node = first_child(fragment);

	{
		var consequent = ($$anchor) => {
			var tr = root_1$3();
			var td = child(tr);
			var text = child(td);

			template_effect(
				($0) => {
					set_attribute(td, 'colspan', $$props.store.columns.length + 1);
					set_text(text, $0);
				},
				[
					() => window.trans("No [_1] could be found.", $$props.zeroStateLabel)
				]
			);

			append($$anchor, tr);
		};

		add_svelte_meta(
			() => if_block(node, ($$render) => {
				if (!$$props.store.objects || strict_equals($$props.store.objects.length, 0)) $$render(consequent);
			}),
			'if',
			ListTableBody,
			45,
			0
		);
	}

	var node_1 = sibling(node, 2);

	{
		var consequent_1 = ($$anchor) => {
			var tr_1 = root_2$1();
			var td_1 = child(tr_1);
			var a = child(td_1);

			a.__click = checkAllRows;

			var text_1 = child(a);

			template_effect(
				($0) => {
					set_attribute(td_1, 'colspan', $$props.store.columns.length + 1);
					set_text(text_1, $0);
				},
				[
					() => window.trans("Select all [_1] items", $$props.store.count.toString())
				]
			);

			append($$anchor, tr_1);
		};

		add_svelte_meta(
			() => if_block(node_1, ($$render) => {
				if ($$props.store.pageMax > 1 && $$props.store.checkedAllRowsOnPage && !$$props.store.checkedAllRows) $$render(consequent_1);
			}),
			'if',
			ListTableBody,
			53,
			0
		);
	}

	var node_2 = sibling(node_1, 2);

	{
		var consequent_2 = ($$anchor) => {
			var tr_2 = root_3$3();
			var td_2 = child(tr_2);
			var text_2 = child(td_2);

			template_effect(
				($0) => {
					set_attribute(td_2, 'colspan', $$props.store.columns.length + 1);
					set_text(text_2, $0);
				},
				[
					() => window.trans("All [_1] items are selected", $$props.store.count.toString())
				]
			);

			append($$anchor, tr_2);
		};

		add_svelte_meta(
			() => if_block(node_2, ($$render) => {
				if ($$props.store.pageMax > 1 && $$props.store.checkedAllRows) $$render(consequent_2);
			}),
			'if',
			ListTableBody,
			64,
			0
		);
	}

	var node_3 = sibling(node_2, 2);

	add_svelte_meta(
		() => each(node_3, 17, () => $$props.store.objects, index, ($$anchor, obj, index) => {
			var tr_3 = root_4$1();

			attribute_effect(
				tr_3,
				($0) => ({
					'data-is': 'list-table-row',
					onclick: clickRow,
					'data-index': index,
					...$0
				}),
				[() => trProps(get$1(obj))]
			);

			var node_4 = child(tr_3);

			add_svelte_meta(
				() => ListTableRow(node_4, {
					get checked() {
						return get$1(obj).checked;
					},

					get hasListActions() {
						return $$props.hasListActions;
					},

					get hasMobilePulldownActions() {
						return $$props.hasMobilePulldownActions;
					},

					get object() {
						return get$1(obj).object;
					},

					get store() {
						return $$props.store;
					}
				}),
				'component',
				ListTableBody,
				80,
				4,
				{ componentTag: 'ListTableRow' }
			);

			reset(tr_3);
			append($$anchor, tr_3);
		}),
		'each',
		ListTableBody,
		72,
		0
	);

	append($$anchor, fragment);

	return pop($$exports);
}

delegate(['click']);

ListTableHeaderForMobile[FILENAME] = 'src/listing/elements/ListTableHeaderForMobile.svelte';

var root_2 = add_locations(from_html(`<th class="mt-table__control"><div class="form-check"><input type="checkbox" class="form-check-input" id="select-all"/> <label class="form-check-label" for="select-all"><span class="visually-hidden"></span></label></div></th>`), ListTableHeaderForMobile[FILENAME], [[8, 6, [[9, 8, [[12, 10], [19, 10, [[20, 12]]]]]]]]);
var root_3$2 = add_locations(from_html(`<span></span>`), ListTableHeaderForMobile[FILENAME], [[30, 8]]);
var root_1$2 = add_locations(from_html(`<tr class="d-md-none"><!><th scope="col"><!> <span class="float-end"> </span></th></tr>`), ListTableHeaderForMobile[FILENAME], [[6, 2, [[27, 4, [[34, 6]]]]]]);

function ListTableHeaderForMobile($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	var $$exports = { ...legacy_api() };
	var fragment = comment();
	var node = first_child(fragment);

	{
		var consequent_2 = ($$anchor) => {
			var tr = root_1$2();
			var node_1 = child(tr);

			{
				var consequent = ($$anchor) => {
					var th = root_2();
					var div = child(th);
					var input = child(div);

					input.__change = function (...$$args) {
						apply(() => $$props.toggleAllRowsOnPage, this, $$args, ListTableHeaderForMobile, [17, 22]);
					};

					var label = sibling(input, 2);
					var span = child(label);

					span.textContent = window.trans("Select All");
					template_effect(() => set_checked(input, $$props.store.checkedAllRowsOnPage));
					append($$anchor, th);
				};

				add_svelte_meta(
					() => if_block(node_1, ($$render) => {
						if ($$props.hasMobilePulldownActions) $$render(consequent);
					}),
					'if',
					ListTableHeaderForMobile,
					7,
					4
				);
			}

			var th_1 = sibling(node_1);
			var node_2 = child(th_1);

			{
				var consequent_1 = ($$anchor) => {
					var span_1 = root_3$2();

					span_1.__click = function (...$$args) {
						apply(() => $$props.toggleAllRowsOnPage, this, $$args, ListTableHeaderForMobile, [30, 23]);
					};

					span_1.textContent = window.trans("All");
					append($$anchor, span_1);
				};

				add_svelte_meta(
					() => if_block(node_2, ($$render) => {
						if ($$props.hasMobilePulldownActions) $$render(consequent_1);
					}),
					'if',
					ListTableHeaderForMobile,
					28,
					6
				);
			}

			var span_2 = sibling(node_2, 2);
			var text = child(span_2);

			template_effect(($0) => set_text(text, $0), [
				() => window.trans("[_1] - [_2] of [_3]", $$props.store.getListStart().toString(), $$props.store.getListEnd().toString(), $$props.store.count.toString())
			]);

			append($$anchor, tr);
		};

		add_svelte_meta(
			() => if_block(node, ($$render) => {
				if ($$props.store.count) $$render(consequent_2);
			}),
			'if',
			ListTableHeaderForMobile,
			5,
			0
		);
	}

	append($$anchor, fragment);

	return pop($$exports);
}

delegate(['change', 'click']);

ListTableHeaderForPc[FILENAME] = 'src/listing/elements/ListTableHeaderForPc.svelte';

var root_1$1 = add_locations(from_html(`<th class="mt-table__control"><div class="form-check"><input type="checkbox" class="form-check-input" id="select-all"/> <label class="form-check-label form-label" for="select-all"><span class="visually-hidden"></span></label></div></th>`), ListTableHeaderForPc[FILENAME], [[23, 4, [[24, 6, [[27, 8], [34, 8, [[35, 10]]]]]]]]);
var root_4 = add_locations(from_html(`<a><!></a>`), ListTableHeaderForPc[FILENAME], [[54, 10]]);
var root_3$1 = add_locations(from_html(`<th scope="col"><!></th>`), ListTableHeaderForPc[FILENAME], [[44, 6]]);
var root$3 = add_locations(from_html(`<tr class="d-none d-md-table-row"><!><!></tr>`), ListTableHeaderForPc[FILENAME], [[21, 0]]);

function ListTableHeaderForPc($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	const classProps = (column) => {
		if (column.sortable && strict_equals($$props.store.sortBy, column.id)) {
			if (strict_equals($$props.store.sortOrder, "ascend")) {
				return { class: "mt-table__ascend" };
			} else if (strict_equals($$props.store.sortOrder, "descend")) {
				return { class: "mt-table__descend" };
			} else {
				return {};
			}
		} else {
			return {};
		}
	};

	var $$exports = { ...legacy_api() };
	var tr = root$3();
	var node = child(tr);

	{
		var consequent = ($$anchor) => {
			var th = root_1$1();
			var div = child(th);
			var input = child(div);

			input.__change = function (...$$args) {
				apply(() => $$props.toggleAllRowsOnPage, this, $$args, ListTableHeaderForPc, [32, 20]);
			};

			var label = sibling(input, 2);
			var span = child(label);

			span.textContent = window.trans("Select All");
			template_effect(() => set_checked(input, $$props.store.checkedAllRowsOnPage));
			append($$anchor, th);
		};

		add_svelte_meta(
			() => if_block(node, ($$render) => {
				if ($$props.hasListActions) $$render(consequent);
			}),
			'if',
			ListTableHeaderForPc,
			22,
			2
		);
	}

	var node_1 = sibling(node);

	add_svelte_meta(
		() => each(node_1, 17, () => $$props.store.columns, index, ($$anchor, column) => {
			var fragment = comment();
			var node_2 = first_child(fragment);

			{
				var consequent_2 = ($$anchor) => {
					var th_1 = root_3$1();
					let classes;
					var node_3 = child(th_1);

					{
						var consequent_1 = ($$anchor) => {
							var a = root_4();

							attribute_effect(
								a,
								($0) => ({
									href: 'javascript:void(0)',
									onclick: $$props.toggleSortColumn,
									...$0
								}),
								[() => classProps(get$1(column))]
							);

							var node_4 = child(a);

							html(node_4, () => get$1(column).label);
							reset(a);
							append($$anchor, a);
						};

						var alternate = ($$anchor) => {
							var fragment_1 = comment();
							var node_5 = first_child(fragment_1);

							html(node_5, () => get$1(column).label);
							append($$anchor, fragment_1);
						};

						add_svelte_meta(
							() => if_block(node_3, ($$render) => {
								if (get$1(column).sortable) $$render(consequent_1); else $$render(alternate, false);
							}),
							'if',
							ListTableHeaderForPc,
							52,
							8
						);
					}

					reset(th_1);

					template_effect(() => {
						set_attribute(th_1, 'data-id', get$1(column).id);

						classes = set_class(th_1, 1, 'text-truncate', null, classes, {
							primary: get$1(column).primary,
							sortable: get$1(column).sortable,
							sorted: strict_equals($$props.store.sortBy, get$1(column).id)
						});
					});

					append($$anchor, th_1);
				};

				add_svelte_meta(
					() => if_block(node_2, ($$render) => {
						if (get$1(column).checked && strict_equals(get$1(column).id, "__mobile", false)) $$render(consequent_2);
					}),
					'if',
					ListTableHeaderForPc,
					43,
					4
				);
			}

			append($$anchor, fragment);
		}),
		'each',
		ListTableHeaderForPc,
		42,
		2
	);
	append($$anchor, tr);

	return pop($$exports);
}

delegate(['change']);

ListTableHeader[FILENAME] = 'src/listing/elements/ListTableHeader.svelte';

var root$2 = add_locations(from_html(`<!> <!>`, 1), ListTableHeader[FILENAME], []);

function ListTableHeader($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	const toggleAllRowsOnPage = () => {
		$$props.store.trigger("toggle_all_rows_on_page");
	};

	const toggleSortColumn = (e) => {
		var _a, _b;
		const columnId = strict_equals(_b = strict_equals(_a = e.currentTarget, null) || strict_equals(_a, void 0) ? void 0 : _a.parentElement, null) || strict_equals(_b, void 0) ? void 0 : _b.dataset.id;

		$$props.store.trigger("toggle_sort_column", columnId);
	};

	var $$exports = { ...legacy_api() };
	var fragment = root$2();
	var node = first_child(fragment);

	add_svelte_meta(
		() => ListTableHeaderForPc(node, {
			get hasListActions() {
				return $$props.hasListActions;
			},

			get store() {
				return $$props.store;
			},

			toggleAllRowsOnPage,
			toggleSortColumn
		}),
		'component',
		ListTableHeader,
		14,
		0,
		{ componentTag: 'ListTableHeaderForPc' }
	);

	var node_1 = sibling(node, 2);

	add_svelte_meta(
		() => ListTableHeaderForMobile(node_1, {
			get hasMobilePulldownActions() {
				return $$props.hasMobilePulldownActions;
			},

			get store() {
				return $$props.store;
			},

			toggleAllRowsOnPage
		}),
		'component',
		ListTableHeader,
		20,
		0,
		{ componentTag: 'ListTableHeaderForMobile' }
	);

	append($$anchor, fragment);

	return pop($$exports);
}

ListTable[FILENAME] = 'src/listing/elements/ListTable.svelte';

var root_1 = add_locations(from_html(`<tbody><tr><td></td></tr></tbody>`), ListTable[FILENAME], [[13, 2, [[14, 4, [[15, 6]]]]]]);
var root_3 = add_locations(from_html(`<tbody data-is="list-table-body"><!></tbody>`), ListTable[FILENAME], [[21, 2]]);
var root$1 = add_locations(from_html(`<thead data-is="list-table-header"><!></thead> <!>`, 1), ListTable[FILENAME], [[9, 0]]);

function ListTable($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	let isLoading = tag(user_derived(() => $$props.store.isLoading), 'isLoading');
	let hasObjects = tag(user_derived(() => !!$$props.store.objects && $$props.store.objects.length > 0), 'hasObjects');
	let columnsLength = tag(user_derived(() => $$props.store.columns.length), 'columnsLength');
	var $$exports = { ...legacy_api() };
	var fragment = root$1();
	var thead = first_child(fragment);
	var node = child(thead);

	add_svelte_meta(
		() => ListTableHeader(node, {
			get hasListActions() {
				return $$props.hasListActions;
			},

			get hasMobilePulldownActions() {
				return $$props.hasMobilePulldownActions;
			},

			get store() {
				return $$props.store;
			}
		}),
		'component',
		ListTable,
		10,
		2,
		{ componentTag: 'ListTableHeader' }
	);

	var node_1 = sibling(thead, 2);

	{
		var consequent = ($$anchor) => {
			var tbody = root_1();
			var tr = child(tbody);
			var td = child(tr);

			td.textContent = window.trans("Loading...");
			template_effect(() => set_attribute(td, 'colspan', get$1(columnsLength) + 1));
			append($$anchor, tbody);
		};

		var alternate = ($$anchor) => {
			var fragment_1 = comment();
			var node_2 = first_child(fragment_1);

			{
				var consequent_1 = ($$anchor) => {
					var tbody_1 = root_3();
					var node_3 = child(tbody_1);

					add_svelte_meta(
						() => ListTableBody(node_3, {
							get hasListActions() {
								return $$props.hasListActions;
							},

							get hasMobilePulldownActions() {
								return $$props.hasMobilePulldownActions;
							},

							get store() {
								return $$props.store;
							},

							get zeroStateLabel() {
								return $$props.zeroStateLabel;
							}
						}),
						'component',
						ListTable,
						22,
						4,
						{ componentTag: 'ListTableBody' }
					);
					append($$anchor, tbody_1);
				};

				add_svelte_meta(
					() => if_block(
						node_2,
						($$render) => {
							if (get$1(hasObjects)) $$render(consequent_1);
						},
						true
					),
					'if',
					ListTable,
					20,
					0
				);
			}

			append($$anchor, fragment_1);
		};

		add_svelte_meta(
			() => if_block(node_1, ($$render) => {
				if (get$1(isLoading)) $$render(consequent); else $$render(alternate, false);
			}),
			'if',
			ListTable,
			12,
			0
		);
	}

	append($$anchor, fragment);

	return pop($$exports);
}

ListTop[FILENAME] = 'src/listing/elements/ListTop.svelte';

var root = add_locations(from_html(`<div class="d-none d-md-block mb-3" data-is="display-options"><!></div> <div id="actions-bar-top" class="row mb-5 mb-md-3"><div class="col"><!></div> <div class="col-auto align-self-end list-counter"><!></div></div> <div class="row mb-5 mb-md-3"><div class="col-12"><div class="card"><!> <div style="overflow-x: auto"><table><!></table></div></div></div></div> <div class="row"><!></div> <!>`, 1), ListTop[FILENAME], [
	[62, 0],
	[65, 0, [[66, 2], [80, 2]]],
	[84, 0, [[85, 2, [[86, 4, [[96, 6, [[97, 8]]]]]]]]],
	[109, 0]
]);

function ListTop($$anchor, $$props) {
	check_target(new.target);
	push($$props, true);

	let store = prop($$props, 'store', 7);
	let callListReady = false;
	let hidden = tag(user_derived(() => strict_equals(store().count, 0)), 'hidden');

	onMount(() => {
		store().trigger("load_list");
	});

	user_effect(() => {
		// update sub_fields not managed in the svelte lifecycle
		updateSubFields();

		if (callListReady) {
			callListReady = false;
			jQuery(window).trigger("listReady");
		}
	});

	store().on("refresh_view", (args) => {
		if (!args) args = {};

		update();

		if (args.moveToPagination) {
			window.document.body.scrollTop = window.document.body.scrollHeight;
		}

		if (!args.notCallListReady) {
			// trigger a "listReady" event in afterUpdate() after the DOM has been updated
			callListReady = true;
		}
	});

	const changeLimit = (e) => {
		var _a;

		store().trigger("update_limit", strict_equals(_a = e.target, null) || strict_equals(_a, void 0) ? void 0 : _a.value);
	};

	const update = () => {
		// eslint-disable-next-line no-self-assign
		store(store());
	};

	const updateSubFields = () => {
		store().columns.forEach((column) => {
			column.sub_fields.forEach((subField) => {
				const selector = "td." + subField.parent_id + " ." + subField.class;

				if (subField.checked) {
					jQuery(selector).show();
				} else {
					jQuery(selector).hide();
				}
			});
		});
	};

	const tableClass = () => {
		return "list-" + ($$props.objectTypeForTableClass || $$props.objectType);
	};

	var $$exports = { ...legacy_api() };
	var fragment = root();
	var div = first_child(fragment);
	var node = child(div);

	add_svelte_meta(
		() => DisplayOptions(node, {
			changeLimit,

			get disableUserDispOption() {
				return $$props.disableUserDispOption;
			},

			get store() {
				return store();
			}
		}),
		'component',
		ListTop,
		63,
		2,
		{ componentTag: 'DisplayOptions' }
	);

	var div_1 = sibling(div, 2);
	var div_2 = child(div_1);
	var node_1 = child(div_2);

	{
		var consequent = ($$anchor) => {
			add_svelte_meta(
				() => ListActions($$anchor, {
					get buttonActions() {
						return $$props.buttonActions;
					},

					get hasPulldownActions() {
						return $$props.hasPulldownActions;
					},

					get listActions() {
						return $$props.listActions;
					},

					get listActionClient() {
						return $$props.listActionClient;
					},

					get moreListActions() {
						return $$props.moreListActions;
					},

					get plural() {
						return $$props.plural;
					},

					get singular() {
						return $$props.singular;
					},

					get store() {
						return store();
					}
				}),
				'component',
				ListTop,
				68,
				6,
				{ componentTag: 'ListActions' }
			);
		};

		add_svelte_meta(
			() => if_block(node_1, ($$render) => {
				if ($$props.useActions) $$render(consequent);
			}),
			'if',
			ListTop,
			67,
			4
		);
	}

	var div_3 = sibling(div_2, 2);
	var node_2 = child(div_3);

	add_svelte_meta(
		() => ListCount(node_2, {
			get store() {
				return store();
			}
		}),
		'component',
		ListTop,
		81,
		4,
		{ componentTag: 'ListCount' }
	);

	var div_4 = sibling(div_1, 2);
	var div_5 = child(div_4);
	var div_6 = child(div_5);
	var node_3 = child(div_6);

	{
		var consequent_1 = ($$anchor) => {
			add_svelte_meta(
				() => ListFilter($$anchor, {
					get filterTypes() {
						return $$props.filterTypes;
					},

					get listActionClient() {
						return $$props.listActionClient;
					},

					get localeCalendarHeader() {
						return $$props.localeCalendarHeader;
					},

					get objectLabel() {
						return $$props.objectLabel;
					},

					get store() {
						return store();
					}
				}),
				'component',
				ListTop,
				88,
				8,
				{ componentTag: 'ListFilter' }
			);
		};

		add_svelte_meta(
			() => if_block(node_3, ($$render) => {
				if ($$props.useFilters) $$render(consequent_1);
			}),
			'if',
			ListTop,
			87,
			6
		);
	}

	var div_7 = sibling(node_3, 2);
	var table = child(div_7);
	var node_4 = child(table);

	add_svelte_meta(
		() => ListTable(node_4, {
			get hasListActions() {
				return $$props.hasListActions;
			},

			get hasMobilePulldownActions() {
				return $$props.hasMobilePulldownActions;
			},

			get store() {
				return store();
			},

			get zeroStateLabel() {
				return $$props.zeroStateLabel;
			}
		}),
		'component',
		ListTop,
		98,
		10,
		{ componentTag: 'ListTable' }
	);

	var div_8 = sibling(div_4, 2);
	let styles;
	var node_5 = child(div_8);

	add_svelte_meta(
		() => ListPagination(node_5, {
			get store() {
				return store();
			}
		}),
		'component',
		ListTop,
		110,
		2,
		{ componentTag: 'ListPagination' }
	);

	var node_6 = sibling(div_8, 2);

	add_svelte_meta(
		() => DisplayOptionsForMobile(node_6, {
			changeLimit,

			get store() {
				return store();
			}
		}),
		'component',
		ListTop,
		112,
		0,
		{ componentTag: 'DisplayOptionsForMobile' }
	);

	template_effect(
		($0) => {
			set_attribute(table, 'id', `${$$props.objectType ?? ''}-table`);
			set_class(table, 1, `table mt-table ${$0 ?? ''}`);
			set_attribute(div_8, 'hidden', get$1(hidden));
			styles = set_style(div_8, '', styles, { display: get$1(hidden) ? "none" : "" });
		},
		[tableClass]
	);

	append($$anchor, fragment);

	return pop($$exports);
}

function getListTopTarget() {
  const listTopTarget = document.querySelector('[data-is="list-top"]');
  if (!listTopTarget) {
    throw new Error("Target element is not found");
  }
  return listTopTarget;
}
function svelteMountListTop(props) {
  mount(ListTop, {
    target: getListTopTarget(),
    props
  });
}
if (!window.riot) {
  window.riot = {};
}
window.riot.observable = observable;
window.svelteMountListTop = svelteMountListTop;
//# sourceMappingURL=listing.js.map
