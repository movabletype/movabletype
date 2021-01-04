/*
 * Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {

MT.EditorManager = function() { this.init.apply(this, arguments); };

// Class method
$.extend(MT.EditorManager, {
    editors: {},
    editorsForFormat: {},
    map: {},
    defaultWrapTag: 'div',
    defaultWrapClass: 'mt-editor-manager-wrap',

    register: function(id, editor) {
        var thisConstructor = this;

        this.editors[id] = editor;
        $.each(editor.formatsForCurrentContext(), function() {
            if (! thisConstructor.editorsForFormat[this]) {
                thisConstructor.editorsForFormat[this] = [];
            }
            thisConstructor.editorsForFormat[this].push({
                id: id,
                editor: editor
            });
        });

        editor.onRegister(id);
    },

    updateMap: function(map) {
        $.extend(this.map, map);
    },

    toMode: function(format) {
        var wysiwygs = {wysiwyg:1,richtext:1};
        return wysiwygs[format] ? 'wysiwyg' : 'source';
    },

    _findEditorClass: function(format) {
        var thisConstructor = this;

        if (this.map[format]) {
            var found = null;
            $.each(this.editorsForFormat[format] || [], function() {
                if (this.id == thisConstructor.map[format]) {
                    found = this;
                    return false;
                }
            });
            if (found) {
                return found;
            }
        }

        if (this.editorsForFormat[format]) {
            return this.editorsForFormat[format][0];
        }
        else {
            return false;
        }
    },

    editorClass: function(format) {
        return this._findEditorClass(format) ||
            this._findEditorClass(this.toMode(format));
    },

    insertContent: function(html, field) {
        $('#' + field).data('mt-editor').currentEditor.insertContent(html)
    }
});

// Instance method
$.extend(MT.EditorManager.prototype, {

    init: function(id, options) {
        var manager = this;

        this.id = id;
        var opt = this.options = $.extend({
            format: 'richtext',
            wrap: false,
            wrapTag: this.constructor.defaultWrapTag,
            wrapClass: this.constructor.defaultWrapClass
        }, options);
        this.editors = {};

        this.parentElement = null;
        if (this.options['wrap']) {
            this.parentElement = $('#' + id)
                .wrap('<'+opt['wrapTag']+' class="'+opt['wrapClass']+'" />')
                .parent();
        }
        this.currentEditor = this.editorInstance(this.options['format']);
        this.currentEditor.initOrShow(this.options['format']);

        $('#' + id).data('mt-editor', this);

        $(window).on('pre_autosave', function() {
            manager.save();
        });
    },

    editorInstance: function(format) {
        var editorClass = this.constructor.editorClass(format);

        if (! this.editors[editorClass.id]) {
            this.editors[editorClass.id] =
                new editorClass.editor(this.id, this);
        }

        return this.editors[editorClass.id];
    },

    setMode: function(mode) {
        this.setFormat(mode);
    },

    setFormat: function(format) {
        if (format == this.options['format']) {
            return;
        }
        this.options['format'] = format;

        var editor = this.editorInstance(format);
        if (editor === this.currentEditor) {
            this.currentEditor.setFormat(format);
        }
        else {
            var content = this.currentEditor.getContent();
            var height  = this.currentEditor.getHeight();

            this.currentEditor.hide();
            this.currentEditor = editor;
            this.currentEditor.initOrShow(format);
            this.currentEditor.setContent(content);
            this.currentEditor.setHeight(height);
        }
    },

    hide: function() {
        if (this.parentElement) {
            this.parentElement.hide();
        }
    },

    show: function() {
        if (this.parentElement) {
            this.parentElement.show();
        }
    },

    ignoreSetDirty: function(callback) {
        this.currentEditor.ignoreSetDirty(callback);
    },

    clearDirty: function() {
        this.currentEditor.clearDirty();
    },
    reload: function() {
        this.currentEditor.reload();
    }
});

// Delegate
$.each([
    'focus', 'save',
    'getContent', 'setContent', 'insertContent',
    'getHeight', 'setHeight', 'resetUndo', 'domUpdated'
], function() {
    var method = this;
    MT.EditorManager.prototype[method] = function() {
        return this.currentEditor[method].apply(this.currentEditor, arguments);
    };
});

})(jQuery);
