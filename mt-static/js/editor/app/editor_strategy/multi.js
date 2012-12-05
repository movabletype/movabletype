/*
 * Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
 * This program is distributed under the terms of the
 * GNU General Public License, version 2.
 *
 * $Id$
 */
;(function($) {

var ES = MT.App.EditorStrategy;

ES.Multi = function() { ES.apply(this, arguments) };
$.extend(ES.Multi.prototype, ES.prototype, {
    create: function(app, ids, format) {
        app.editors = {};
        $.each(ids, function() {
            $('#' + this).show();

            app.editors[this] = new MT.EditorManager(this, {
                format: format,
                wrap: true
            });

            var setFormat = app.editors[this]['setFormat'];
            app.editors[this]['setFormat'] = function(format) {
                $.each(app.editors, function() {
                    setFormat.apply(this, [format]);
                });
            };
        });
    },

    set: function(app, id) {
        var strategy = this;
        if (app.editor) {
            var height = app.editor.getHeight();
            strategy._setWithHeight(app, id, height);
        }
        else {
            strategy._setWithHeight(app, id, null);
        }
    },

    _setWithHeight: function(app, id, height) {
        $(app.editorIds).each(function() {
            if (id == this) {
                app.editors[this].show();
                app.editor = app.editors[this];
                if (height) {
                    app.editor.setHeight(height);
                }
            }
            else {
                app.editors[this].hide();
            }
        });
    }
});

})(jQuery);
