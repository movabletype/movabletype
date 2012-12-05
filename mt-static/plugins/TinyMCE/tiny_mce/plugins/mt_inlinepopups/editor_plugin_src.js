/*
 * Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
 * This program is distributed under the terms of the
 * GNU General Public License, version 2.
 *
 * $Id$
 */
;(function($) {
    var DOM = tinymce.DOM;

    tinymce.create('tinymce.plugins.MTInlinepopupsPlugin', {
        init : function(ed, url) {
            defineMTInlineWindowManager();
            ed.onBeforeRenderUI.add(function() {
                ed.windowManager = new tinymce.MTInlineWindowManager(ed);
            });
        },

        getInfo : function() {
            return {
                longname : 'MTInlinepopups',
                author : 'Six Apart, Ltd',
                authorurl : '',
                infourl : '',
                version : '1.0'
            };
        }
    });

    function defineMTInlineWindowManager() {
        tinymce.create('tinymce.MTInlineWindowManager:tinymce.InlineWindowManager', {
            MTInlineWindowManager : function(ed) {
                this.parent(ed);
            },

            open : function(f, p) {
                var ed = this.editor;
                var url, sizes, w;
                if (sizes = ed.settings.plugin_mt_inlinepopups_window_sizes) {
                    url = f.url || f.file;
                    $.each(sizes, function(k, v) {
                        if ((new RegExp(k + '$')).test(url)) {
                            f = $.extend({}, f, v);
                        }
                    });
                }

                ed.focus(true);

                w = tinymce.InlineWindowManager.prototype.open.apply(this, [f, p]);

                $('#' + w.iframeElement.id).load(function() {
                    if (f.body_id) {
                        $(this).contents().find('body').attr('id', f.body_id);
                    }
                    if (f.onload) {
                        f.onload({
                            'iframe': this
                        });
                    }
                });

                return w;
            }
        });
    }

    // Register plugin
    tinymce.PluginManager.add('mt_inlinepopups', tinymce.plugins.MTInlinepopupsPlugin, ['inlinepopups']);
})(jQuery);
