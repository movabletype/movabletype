/*
 * Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
 * This program is distributed under the terms of the
 * GNU General Public License, version 2.
 *
 * $Id$
 */
;(function($) {

MT.Editor.Source = function(id) {
    var editor = this;
    MT.Editor.apply(this, arguments);

    this.$textarea = $('#' + id);
    this.textarea = this.$textarea.get(0);
    this.range = null;

    this.$textarea
        .keydown(function() {
            // Save the position of cursor for the insertion of asset. (IE)
            editor.saveSelection();
            editor.setDirty();
        })
        .keyup(function() {
            editor.saveSelection();
        })
        .mouseup(function() {
            editor.saveSelection();
        });
};
$.extend(MT.Editor.Source, MT.Editor, {
    formats: function() {
        return ['source'];
    }
});
$.extend(MT.Editor.Source.prototype, MT.Editor.prototype, {
    getContent: function() {
        return this.textarea.value;
    },

    setContent: function(content) {
        return this.textarea.value = content;
    },

    clearUndo: function() {
        return '';
    },

    focus: function() {
        this.textarea.focus();
    },

    getHeight: function() {
        return this.$textarea.height();
    },

    setHeight: function(height) {
        this.$textarea.height(height);
    },

    hide: function() {
        this.$textarea.hide();
    },

    insertContent: function(content) {
        this.setSelection(content);
    },

    getSelection: function() {
        var w = window;
        return w.getSelection ? w.getSelection() : w.document.selection;
    },

    getSelectedText: function() {
        var selection = this.getSelection();
        if ( selection.createRange ) {
            // ie
            this.range = null;
            this.focus();
            var range = selection.createRange();
            return range.text;
        } else {
            var length = this.textarea.textLength;
            var start = this.selectionStart || this.textarea.selectionStart;
            var end = this.selectionEnd || this.textarea.selectionEnd;
            if ( end == 1 || end == 2 && defined( length ) )
                end = length;
            return this.textarea.value.substring( start, end );
        }
    },

    setSelection: function( txt, select_inserted_content ) {
        var el = this.textarea;
        var selection = this.getSelection();
        if ( selection.createRange ) {
            var range = this.range;
            if ( !range ) {
                this.focus();
                range = selection.createRange();
            }
            range.text = txt;
            if ( select_inserted_content ) {
                range.select();
            }
        } else {
            var scrollTop = el.scrollTop;
            var length = el.textLength;
            var start = this.selectionStart || el.selectionStart;
            var end = this.selectionEnd || el.selectionEnd;
            if ( (end == 1 || end == 2) && defined( length ) )
                end = length;
            el.value = el.value.substring( 0, start ) + txt + el.value.substr( end, length );
            if ( select_inserted_content ) {
                el.selectionStart = start;
                el.selectionEnd = start + txt.length;
            }
            else {
                el.selectionStart = start + txt.length;
                el.selectionEnd = start + txt.length;
            }
            el.scrollTop = scrollTop;
        }
        if ( !select_inserted_content ) {
            this.saveSelection();
        }
        this.focus();
    },

    saveSelection: function() {
        var selection = this.getSelection();
        var data = {};
        if ( selection.createRange ) {
            data.range = this.range = selection.createRange().duplicate();
        }
        else {
            data.selectionStart = this.selectionStart =
                this.textarea.selectionStart;
            data.selectionEnd   = this.selectionEnd   =
                this.textarea.selectionEnd;
        }
        return data;
    },

    restoreSelection: function( data ) {
        if ( !data ) {
            data = this;
        }

        if (! data.range && ! data.selectionStart) {
            return;
        }

        var selection = this.getSelection();
        if ( selection.createRange ) {
            data.range.select();
        }
        else {
            this.textarea.selectionStart = data.selectionStart;
            this.textarea.selectionEnd   = data.selectionEnd;
        }
    }
});
MT.EditorManager.register('source', MT.Editor.Source);

})(jQuery);
