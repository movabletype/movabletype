/*
 * Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
 * This program is distributed under the terms of the
 * GNU General Public License, version 2.
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
        $.each(editor.formats(), function() {
            if (! thisConstructor.editorsForFormat[this]) {
                thisConstructor.editorsForFormat[this] = [];
            }
            thisConstructor.editorsForFormat[this].push({
                id: id,
                editor: editor
            });
        });
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
        $('#' + field).data('mt-editor')
            .insertContent(html);
    }
});

// Instance method
$.extend(MT.EditorManager.prototype, {

    init: function(id, options) {
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
    },

    editorInstance: function(format) {
        var editorClass = this.constructor.editorClass(format);

        if (! this.editors[editorClass.id]) {
            this.editors[editorClass.id] = new editorClass.editor(this.id);
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
            this.currentEditor.hide();
            this.currentEditor = editor;
            this.currentEditor.initOrShow(format);
            this.currentEditor.setContent(content);
        }
    },

    hide: function() {
        this.parentElement.hide();
    },

    show: function() {
        this.parentElement.show();
    },

    insertContent: function(html) {
        this.currentEditor.insertContent(html);
    },

    focus: function() {
        this.currentEditor.focus();
    },

    ignoreSetDirty: function(callback) {
        this.currentEditor.ignoreSetDirty(callback);
    },

    clearDirty: function() {
        this.currentEditor.clearDirty();
    }
});

// Delegate
$.each([
    'focus',
    'getContent', 'setContent', 'insertContent',
    'getHeight', 'setHeight', 'resetUndo'
], function() {
    var method = this;
    MT.EditorManager.prototype[method] = function() {
        return this.currentEditor[method].apply(this.currentEditor, arguments);
    };
});

})(jQuery);
