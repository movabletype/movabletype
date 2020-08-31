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
        tinymce.addI18n(tinyMCE.settings.language, {
            'Insert template': trans('Insert Boilerplate'),
            'Templates': trans('Name'),
        });
    }
});

tinymce.PluginManager.add('mt_formatted_text', tinymce.plugins.MTFormattedText, ['template']);

})(jQuery);
