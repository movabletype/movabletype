/*
 * Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
 * This program is distributed under the terms of the
 * GNU General Public License, version 2.
 *
 * $Id$
 */
;(function($) {

MT.Editor = function(id, manager) {
    this.id = id;
    this.manager = manager;
    this.initialized = false;
    this.editor = null;
};

// Class method
$.extend(MT.Editor, {
    ensureInitializedMethods: [
        'setFormat', 'setContent', 'insertContent', 'hide', 'clearDirty',
        'setHeight', 'resetUndo', 'domUpdated'
    ],

    defaultCommonOptions: {
        body_class_list: [],
        content_css_list: []
    },

    updateDefaultCommonOptions: function(options) {
        $.extend(this.defaultCommonOptions, options);
    },

    isMobileOSWYSIWYGSupported: function() {
        return true;
    },

    formats: function() {
        if (this.isMobileOSWYSIWYGSupported() ||
            ! navigator.userAgent.match(/Android|i(Phone|Pad|Pod)/)
        ) {
            return ['wysiwyg', 'source'];
        }
        else {
            return ['source'];
        }
    },

    setupEnsureInitializedMethods: function(names) {
        var klass = this;
        $.each(names, function() {
            var original = klass.prototype[this];
            klass.prototype[this] = function() {
                this.ensureInitialized(original, arguments);
            };
        });
    },

    onRegister: function(id) {
        this.setupEnsureInitializedMethods(this.ensureInitializedMethods);
    }
});

// Instance method
$.extend(MT.Editor.prototype, {
    isIgnoreAppSetDirty: false,

    init: function(commonOptions) {
        this.commonOptions =
            $.extend({}, this.constructor.defaultCommonOptions, commonOptions);
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
        // Should be overridden.
    },

    initEditor: function(id, format, opts, callback) {
        // Should be overridden.
    },

    setFormat: function() {
        // Should be overridden, if needed.
    },

    domUpdated: function() {
        // Should be overridden, if needed.
    }
});

// Delegate
$.each([
    'show', 'hide', 'focus', 'save',
    'getContent', 'setContent', 'insertContent',
    'getHeight', 'setHeight', 'resetUndo'
], function() {
    var method = this;
    MT.Editor.prototype[method] = function() {
        return this.editor ? this.editor[method]() : null;
    };
});

})(jQuery);
