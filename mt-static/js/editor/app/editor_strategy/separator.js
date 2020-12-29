/*
 * Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {

var ES = MT.App.EditorStrategy;

ES.Separator = function() { ES.apply(this, arguments) };
$.extend(ES.Separator.prototype, ES.prototype, {
    create: function(app, ids, format) {
        this.ids = ids;

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

        var content = $.map(ids, function(id, index) {
            var value =  $('#' + id).val();
            if (! value || value == '') {
                value = '<p><br /></p>';
            }
            return value;
        }).join('<hr class="movable-type-editor-separator" />');
        app.editor.ignoreSetDirty(function() {
            app.editor.setContent(content);
        });

        $('#editor-header .tab').css({
            visibility: 'hidden'
        });
    },

    save: function(app) {
        var strategy = this;
        var content = app.editor.getContent();
        var contents = content.split(/<hr[^>]*class=['"]?movable-type-editor-separator['"]?[^>]*>/i);
        $.each(strategy.ids, function(i) {
            var value = contents[i];
            if (value.match(/^\s*<p><br[^>]*><\/p>\s*$/)) {
                value = '';
            }
            $('#' + this).val(value);
        });
    }
});

})(jQuery);
