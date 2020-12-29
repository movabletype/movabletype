/*
 * Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {

var ES = MT.App.EditorStrategy;

ES.Single = function() { ES.apply(this, arguments) };
$.extend(ES.Single.prototype, ES.prototype, {
    create: function(app, ids, format) {
        var id = ids.join('-');
        while ($('#' + id).length > 0) {
            id += '-dummy';
        }
        this.dummy_textarea = $('<textarea />')
            .attr('id', id)
            .insertBefore('#' + ids[0]);
        app.editor = new MT.EditorManager(id, {
            format: format
        });
    },

    set: function(app, id) {
        var key = 'target_textarea';
        var strategy = this;

        var target = this.dummy_textarea.data(key);
        if (target) {
            var content = app.editor.getContent();
            target.val(content);
            target.attr('name', strategy.dummy_textarea.attr('name'));
            strategy.dummy_textarea.removeAttr('name');
        }

        target = $('#' + id);
        this.dummy_textarea.attr('name', target.attr('name'));
        target.removeAttr('name');
        app.editor.ignoreSetDirty(function() {
            app.editor.setContent(target.val());
            app.editor.clearDirty();
        });
        app.editor.resetUndo();
        this.dummy_textarea.data(key, target);
    },

    save: function() {
       app.editor.save();
    }
});

})(jQuery);
