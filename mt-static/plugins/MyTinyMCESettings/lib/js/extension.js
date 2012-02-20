(function($) {
    var plugin_name = 'MyTinyMCESettings';

    // Customize configurations
    $.extend(MT.Editor.TinyMCE.config, {
        // Customize button settings
        theme_advanced_buttons2: "undo,redo,|,link,unlink,|,hr,removeformat,|,table,|,fullscreen,|,forecolor,backcolor,|,formatselect",
        // Load my custom plugin
        plugins: MT.Editor.TinyMCE.config.plugins + ',' + plugin_name
    });

    // My custom plugin
	tinymce.create('tinymce.plugins.' + plugin_name, {
		init : function(ed, url) { }
    });
	tinymce.PluginManager.add(plugin_name, tinymce.plugins[plugin_name]);

    // The adapter for another plugin
	tinymce.create('tinymce.plugins.APAdapter', {});
	tinymce.PluginManager.add('APAdapter', tinymce.plugins.APAdapter, [
        {
            prefix: StaticURI + 'plugins/MyTinyMCESettings/lib/js/plugins/',
            resource: 'another_plugin',
            suffix:'/editor_plugin' + tinymce.suffix + '.js'
        }
    ]);
})(jQuery);
