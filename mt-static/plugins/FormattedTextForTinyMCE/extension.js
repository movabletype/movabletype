/*
 * Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {

var config  = MT.Editor.TinyMCE.config;
var wisiwyg_buttons = config.plugin_mt_wysiwyg_buttons1 + ',|,template';
var source_buttons  = (function(buttons) {
    var replaced        = false;
    var before          = /,mt_insert_image/;
    var template_button = ',|,mt_source_template';

    buttons = buttons.replace(before, function($0) {
        replaced = true;
        return $0 + template_button;
    });

    if (! replaced) {
        buttons += template_button;
    }

    return buttons;
})(config.plugin_mt_source_buttons1);

$.extend(config, {
    plugins: config.plugins + ',template,mt_formatted_text',
    plugin_mt_wysiwyg_buttons1: wisiwyg_buttons,
    plugin_mt_source_buttons1: source_buttons
});

tinymce.create('tinymce.plugins.MTFormattedText', {
    init : function(ed, url) {
        var _open = ed.windowManager.open;
        ed.windowManager.open = function(args, params) {
            if (args.title === 'Insert template') {
                args.title = 'Insert Boilerplate';

                args.body[0]['label'] = 'Boilerplate Name';
                args.body[1]['label'] = 'Boilerplate Description';

                args.body[2]['minHeight'] = tinymce.DOM.getViewPort().h - 300;
            }

            return _open.apply(this, arguments);
        };

        // Overwrite description for the template button.
        tinyMCE.addI18n(tinyMCE.settings.language, {
            "Insert template": trans('Insert Boilerplate'),
            "Insert Boilerplate": trans('Insert Boilerplate'),
            "Boilerplate Name": trans("Name"),
            "Boilerplate Description": trans("Description")
        });
    }
}); 

tinymce.PluginManager.add('mt_formatted_text', tinymce.plugins.MTFormattedText, ['template']);

})(jQuery);
