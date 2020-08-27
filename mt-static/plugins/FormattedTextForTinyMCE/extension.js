(function($) {

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
        ed.onInit.add(function() {
            ed.windowManager.onOpen.add(function(windowManager, window) {
                var popup = window.tinyMCEPopup;
                if (! popup || ! popup.params['plugin_url']) {
                    return;
                }

                if (! popup.params['plugin_url'].match(/\/template$/)) {
                    return;
                }


                // Overwrite messages for the template dialog.

                window.trans = window.parent.trans;

                var requireLangPack = popup.requireLangPack;
                popup.requireLangPack = function() {
                    requireLangPack.apply(this, arguments);

                    var url = StaticURI + 'plugins/FormattedTextForTinyMCE/langs/template.js';
			        if (! tinymce.ScriptLoader.isDone(url)) {
				        window.document.write('<script type="text/javascript" src="' + url + '"></script>');
				        tinymce.ScriptLoader.markDone(url);
			        }
                };
            });
        });

        // Overwrite description for the template button.
        tinyMCE.addI18n(tinyMCE.settings.language + '.template', {
            desc: trans('Insert Boilerplate')
        });
    }
}); 

tinymce.PluginManager.add('mt_formatted_text', tinymce.plugins.MTFormattedText, ['template']);

})(jQuery);
