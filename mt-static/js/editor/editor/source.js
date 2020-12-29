/*
 * Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {

MT.Editor.Source = function(id) {
    var editor = this;
    MT.Editor.apply(this, arguments);

    this.editor    = editor;
    this.$textarea = $('#' + id);
    this.textarea  = this.$textarea.get(0);
    this.range     = null;

    var focused = false;
    this.$textarea
        .on('keydown', function() {
            // Save the position of cursor for the insertion of asset. (IE)
            editor.saveSelection();
            editor.setDirty();
        })
        .on('keyup', function() {
            editor.saveSelection();
        })
        .on('focus', function() {
            focused = true;
        })
        .on('blur', function() {
            focused = false;
        });

    $.each(['mouseup', 'touchend'], function(index, event) {
        $(document).on(event, function() {
            if (focused) {
                editor.saveSelection();
            }
        });
    });
};
$.extend(MT.Editor.Source, MT.Editor, {
    ensureInitializedMethods: [],

    formats: function() {
        return ['source'];
    }
});
$.extend(MT.Editor.Source.prototype, MT.Editor.prototype, {
    save: function() {
        return '';
    },

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
        var _this = this;
        setTimeout(function() {_this.textarea.focus()}, 0);
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
            var range = this.range;
            if (! range) {
                this.focus();
                range = selection.createRange();
            }
            return range.text;
        } else {
            var length = this.textarea.textLength;
            var start = this.selectionStart || this.textarea.selectionStart;
            var end = this.selectionEnd || this.textarea.selectionEnd;
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
            range.select();
        } else {
            var scrollTop = el.scrollTop;
            var length = el.textLength;
            var start = this.selectionStart || el.selectionStart;
            var end = this.selectionEnd || el.selectionEnd;
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
        el.focus();
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

})(jQuery);
