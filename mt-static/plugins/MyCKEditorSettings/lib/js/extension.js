(function($) {
    var plugin_name = 'MyCKEditorSettings';

    // Customize configurations
    $.extend(MT.Editor.CKEditor.config, {
        // Customize button settings
        toolbar_mt: [
            ['mt_font_size_smaller', 'mt_font_size_larger', 'mt_bold', 'mt_italic', 'mt_underline', 'mt_strikethrough', 'mt_insert_link', 'mt_insert_email', 'mt_indent', 'mt_outdent', 'mt_insert_unordered_list', 'mt_insert_ordered_list', 'mt_justify_left', 'mt_justify_center', 'mt_justify_right', 'mt_insert_image', 'mt_insert_file', '-', 'Source'],
            '/',
            ['Undo','Redo','-','Link','Unlink','-','HorizontalRule','RemoveFormat','-','Table','Maximize'],['TextColor','BGColor'],['Format']
        ],
        // Load my custom plugin
        plugins: MT.Editor.CKEditor.config.plugins + ',' + plugin_name + ',another_plugin'
    });

    // My custom plugin
    CKEDITOR.plugins.add(plugin_name, {
        init : function(ed) { }
    });

    // The adapter for another plugin
    CKEDITOR.plugins.addExternal(
        'another_plugin',
        StaticURI + 'plugins/MyCKEditorSettings/lib/js/plugins/another_plugin/',
        'plugin.js'
    );

})(jQuery);
