/*
 * Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
 * This program is distributed under the terms of the
 * GNU General Public License, version 2.
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
            format: format,
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
    }
});

})(jQuery);
