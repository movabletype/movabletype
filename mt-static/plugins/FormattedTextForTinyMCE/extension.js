(function($) {

var config  = MT.Editor.TinyMCE.config;
var buttons = config.plugin_mt_wysiwyg_buttons1 || '';
if (buttons) {
    buttons += ',|,';
}
buttons += 'template';

$.extend(config, {
    plugins: config.plugins + ',template,mt_formatted_text',
    plugin_mt_wysiwyg_buttons1: buttons
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
            desc: trans('Insert Formatted Text')
        });
    }
}); 

tinymce.PluginManager.add('mt_formatted_text', tinymce.plugins.MTFormattedText, ['template']);

})(jQuery);
