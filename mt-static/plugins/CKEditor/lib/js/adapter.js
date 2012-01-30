/*
 * Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
 * This program is distributed under the terms of the
 * GNU General Public License, version 2.
 *
 * $Id$
 */
;(function($) {

MT.Editor.CKEditor = function() { MT.Editor.apply(this, arguments) };
$.extend(MT.Editor.CKEditor, MT.Editor);
$.extend(MT.Editor.CKEditor.prototype, MT.Editor.prototype, {
    changed: false,
    initEditor: function(id, format) {
        this.show();

        if (format == 'textarea') {
            this.setFormat(format);
        }
    },
    ensureInitializedSetFormat: function(format) {
        var editor = this.editor;
        if (format == 'textarea') {
            editor.fire( 'saveSnapshot' );
            /*
            editor.getCommand( 'source' ).setState( CKEDITOR.TRISTATE_DISABLED );
            */
            editor.setMode('source');

            this._disableButtons();
        }
        else {
            editor.setMode('wysiwyg');

            this._restoreButtons();
        }
    },
    ensureInitializedGetContent: function(content) {
        return this.editor.getData();
    },
    ensureInitializedSetContent: function(content) {
        this.editor.setData(content);
    },
    ensureInitializedHide: function() {
        this.editor.destroy();
        this.editor = null;
    },
    show: function() {
        var instance = this;
        var config = {
            skin: 'movabletype',
            plugins: 'pastefromword,list,table,smiley,tabletools,showborders,scayt,movabletype,maximize,xml,newpage,forms,filebrowser,keystrokes,bidi,clipboard,about,elementspath,templates,a11yhelp,div,showblocks,basicstyles,sourcearea,iframe,popup,removeformat,liststyle,colordialog,print,ajax,dialogadvtab,link,button,format,colorbutton,find,contextmenu,flash,preview,justify,wsc,tab,horizontalrule,resize,blockquote,save,stylescombo,pastetext,entities,undo,specialchar,htmldataprocessor,image,enterkey,pagebreak,wysiwygarea,font,toolbar,indent',
            toolbar_MTCustom: [
            ['mt_font_size_smaller', 'mt_font_size_larger', 'mt_bold', 'mt_italic', 'mt_underline', 'mt_strikethrough', 'mt_insert_link', 'mt_insert_email', 'mt_indent', 'mt_outdent', 'mt_insert_unordered_list', 'mt_insert_ordered_list', 'mt_justify_left', 'mt_justify_center', 'mt_justify_right', 'mt_insert_image', 'mt_insert_file', '-', 'Source'],
            '/',
            ['Undo','Redo','-','Link','Unlink','-','HorizontalRule','RemoveFormat','-','Table','Maximize','-','Font','FontSize'],
            ],
            toolbar: 'MTCustom',
            on: {
                instanceReady: function(ev) {
                    instance.editor = this;
                },
                key: function(ev) {
                    instance.setChanged(ev);
                }
            }
        };
        $('#' + this.id).ckeditor(config);
    },
    isDirty: function() {
        return (this.editor && this.editor.checkDirty()) || this.changed;
    },
    ensureInitializedClearDirty: function() {
        this.editor.resetDirty();
        this.changed = false;
    },
    ensureInitializedSetChanged: function(key) {
        this.changed = true;
    },
    ensureInitializedInsertHTML: function(value) {
        this.editor.insertHtml(value);
    },
    ensureInitializedClearDirty: function() {
        this.editor.isNotDirty = 1;
    },
    ensureInitializedGetHeight: function() {
        return this.editor.getResizable().$.offsetHeight;
    },
    ensureInitializedSetHeight: function(height) {
        this.editor.resize(
            this.editor.getResizable().$.offsetWidth, height-3
        );
    },
    ensureInitializedResetUndo: function(height) {
        this.editor.resetUndo();
    },
    _disableButtons: function() {
        if (! this.hiddenButtons) {
            this.hiddenButtons = $('.cke_button_source').parent().hide();
        }
    },
    _restoreButtons: function() {
        if (this.hiddenButtons) {
            this.hiddenButtons.show();
            this.hiddenButtons = null;
        }
    }
});
MT.EditorManager.register('ckeditor', MT.Editor.CKEditor);

})(jQuery);
