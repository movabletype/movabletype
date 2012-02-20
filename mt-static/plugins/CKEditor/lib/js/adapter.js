/*
 * Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
 * This program is distributed under the terms of the
 * GNU General Public License, version 2.
 *
 * $Id$
 */
;(function($) {

MT.Editor.CKEditor = function() { MT.Editor.apply(this, arguments) };

$.extend(MT.Editor.CKEditor, MT.Editor, {
    isMobileOSWYSIWYGSupported: function() {
        return false;
    },
    config: {
        resize_minWidth: 500,
        resize_dir: 'vertical',
        skin: 'mt',
        plugins: 'list,table,mt,maximize,elementspath,basicstyles,sourcearea,removeformat,liststyle,link,button,format,contextmenu,justify,tab,horizontalrule,resize,blockquote,undo,image,enterkey,wysiwygarea,font,toolbar,indent,colordialog,colorbutton',
        toolbar_mt: [
            ['mt_font_size_smaller', 'mt_font_size_larger', 'mt_bold', 'mt_italic', 'mt_underline', 'mt_strikethrough', 'mt_insert_link', 'mt_insert_email', 'mt_indent', 'mt_outdent', 'mt_insert_unordered_list', 'mt_insert_ordered_list', 'mt_justify_left', 'mt_justify_center', 'mt_justify_right', 'mt_insert_image', 'mt_insert_file', '-', 'Source'],
            '/',
            ['Undo','Redo','-','Link','Unlink','-','HorizontalRule','RemoveFormat','-','Table','Maximize'],['TextColor','BGColor'],['Format']
        ],
        toolbar: 'mt',
        on: {
            instanceReady: function(ev) {},
            mode: function(ev) {}
        }
    }
});

$.extend(MT.Editor.CKEditor.prototype, MT.Editor.prototype, {
    initEditor: function(format) {
        this.proxies = {};

        this.show();

        if (MT.EditorManager.toMode(format) == 'source') {
            this.setFormat(format);
        }
    },

    setFormat: function(format) {
        var mode = MT.EditorManager.toMode(format);
        var editor = this.editor;

        editor.execCommand('mtSetStatus', {
            mode: mode,
            format: format
        });
    },

    getContent: function(content) {
        if (this.editor) {
            return this.editor.getData();
        }
        else {
            return $('#' + this.id).val();
        }
    },

    setContent: function(content) {
        this.editor.setData(content);
    },

    hide: function() {
        this.editor.destroy();
        this.editor = null;
    },

    show: function() {
        var adapter = this;

        var config = $.extend({}, this.constructor.config);
        config.on = $.extend({}, config.on);

        var instanceReady = config.on['instanceReady'];
        config.on['instanceReady'] = function(ev) {
            instanceReady.apply(this, arguments);
            adapter.editor = this;

            this.on('key', function(ev) {
                adapter.setDirty({
                    target: adapter.editor.element['$']
                });
            });

            this.on('resize', function(ev) {
                adapter.editor.container.$.style.width = '';
            });
        };

        var mode = config.on['mode'];
        config.on['mode'] = function(ev) {
            mode.apply(this, arguments);
            adapter.editor = this;

            var proxies = {};
            if (this.mode == 'source') {
                adapter.source = new MT.Editor.Source(this.textarea.$.id);
                adapter.proxies['source'] =
                    new MT.EditorCommand.Source(adapter.source);
            }
            else if (this.mode == 'wysiwyg') {
                adapter.proxies['wysiwyg'] =
                    new MT.EditorCommand.WYSIWYG(adapter)
            }

            this.execCommand('mtSetProxies', adapter.proxies);
        };

        $('#' + this.id).ckeditor(config);
    },

    insertContent: function(value) {
        this.editor.insertHtml(value);
    },

    clearDirty: function() {
        this.editor.isNotDirty = 1;
    },

    getHeight: function() {
        if (this.editor) {
            return this.editor.getResizable().$.offsetHeight;
        }
        else {
            return null;
        }
    },

    setHeight: function(height) {
        this.editor.resize(
            this.editor.getResizable().$.offsetWidth, height-3
        );
    },

    resetUndo: function() {
        this.editor.resetUndo();
    },

    getDocument: function() {
        return this.editor.document.$;
    }
});

MT.Editor.CKEditor.setupEnsureInitializedMethods([
    'setFormat', 'hide', 'insertContent', 'setContent',
    'clearDirty', 'resetUndo', 'setHeight'
]);

MT.EditorManager.register('ckeditor', MT.Editor.CKEditor);

})(jQuery);
