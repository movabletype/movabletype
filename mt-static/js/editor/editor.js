/*
 * Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
 * This program is distributed under the terms of the
 * GNU General Public License, version 2.
 *
 * $Id$
 */
;(function($) {

MT.Editor = function(id) {
    this.id = id;
    this.initialized = false;
    this.editor = null;
};

// Class method
$.extend(MT.Editor, {
    formats: function() {
        return ['wysiwyg', 'source'];
    },
    setupEnsureInitializedMethods: function(names) {
        var klass = this;
        $.each(names, function() {
            var original = klass.prototype[this];
            klass.prototype[this] = function() {
                this.ensureInitialized(original, arguments);
            };
        });
    }
});

// Instance method
$.extend(MT.Editor.prototype, {
    isIgnoreAppSetDirty: false,

    init: function() {
        this.initialized = true;
        this.initEditor.apply(this, arguments);
    },

    initOrShow: function(format) {
        if (! this.initialized) {
            this.init(format);
        }
        else {
            this.show();
            this.setFormat(format);
        }
    },

    ensureInitialized: function(func, args) {
        var instance = this;

        if (instance.editor) {
            func.apply(instance, args);
        }
        else {
            var id = setInterval(function() {
                if (instance.editor) {
                    clearInterval(id);
                    func.apply(instance, args);
                }
            }, 100);
        }
    },

    setDirty: function() {
        this.setAppDirty.apply(this, arguments);
    },

    setAppDirty: function() {
        if (! this.isIgnoreAppSetDirty && window.app) {
            window.app.setDirty.apply(window.app, arguments);
        }
    },

    ignoreSetDirty: function(callback) {
        var saved = this.isIgnoreAppSetDirty;
        this.isIgnoreAppSetDirty = true;
        callback.apply(this, []);
        this.isIgnoreAppSetDirty = saved;
    },

    clearDirty: function() {
        // Should be overried.
    },

    initEditor: function(id, format, opts, callback) {
        // Should be overried.
    }
});

// Delegate
$.each([
    'show', 'hide', 'focus', 'setFormat',
    'getContent', 'setContent', 'insertContent',
    'getHeight', 'setHeight', 'resetUndo'
], function() {
    var method = this;
    MT.Editor.prototype[method] = function() {
        return this.editor ? this.editor[method]() : null;
    };
});

})(jQuery);
