/*
 * Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {

$.extend(MT.App, {
    defaultEditorStrategy: 'multi',

    setDefaultEditorStrategy: function(strategy) {
        this.defaultEditorStrategy = strategy;
    },

    getDefaultEditorStrategy: function() {
        return this.defaultEditorStrategy;
    },

    newEditorStrategy: function(strategy) {
        if (! strategy) {
            strategy = this.defaultEditorStrategy;
        }
        return MT.App.EditorStrategy.newInstance(strategy);
    }
});
MT.App.prototype = $.extend({}, MT.App.prototype, {
    initEditor: function() {
        var format = $('#convert_breaks').val();

        // Fall backing to the source editor when any WYSIWYG editor isn't
        // available.
        if (! MT.EditorManager.editorClass('wysiwyg')) {
            $('#convert_breaks option[value="richtext"]').remove();
            format = $('#convert_breaks').val();
        }

        if (! this.editorStrategy) {
            this.editorStrategy = this.constructor.newEditorStrategy();
        }

        this.editorIds = $.map($('#editor-content textarea'), function(elm, i) {
            return elm.id;
        });

        this.editorStrategy.create(this, this.editorIds, format);
        this.editorStrategy.set(this, this.editorIds[0]);
    },

    setEditorIframeHTML: function() {
        this.editor.setFormat('richtext');
    },

    saveHTML: function(resetChanged) {
        this.editorStrategy.save(this);
        if (resetChanged) {
            this.clearDirty();
            this.editor.clearDirty();
        }
    },

    setEditor: function(id) {
        this.editorStrategy.set(this, 'editor-input-' + id);
    },

    insertHTML: function(html, field) {
        MT.EditorManager.insertContent(html, field);
    },
    reloadEditor: function(id){
        MT.EditorManager.reloadEditor(id);
    }
});

})(jQuery);
