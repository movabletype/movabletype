/*
 * Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {
    var enabled = false;
    var fitToWindow = function(){};
    var editorSize = null;
    var last_updated = null;

    tinymce
        .ScriptLoader
        .add(tinymce.PluginManager.urls['mt_fullscreen'] + '/langs/plugin.js');

    tinymce.create('tinymce.plugins.MTFullScreenPlugin', {
        init : function(ed, url) {
            var plugin = this;
            plugin.buttonIDs = {};

            tinymce.DOM.loadCSS(url + '/css/mt_fullscreen.css');

            var $window, $container, $parent, $header, $tabs, affectedEditors;

            function forEachAffectedEditors(func) {
                $.each(affectedEditors, function(i, id) {
                    if (tinyMCE.editors[id]) {
                        func.apply(tinyMCE.editors[id], []);
                    }
                });
            }

            ed.addCommand('mtFullScreenUpdateFitToWindow', function() {
                if (! enabled) {
                    return;
                }
                var now = new Date();
                if (last_updated && now - last_updated < 150 ) {
                    return;
                }
                last_updated = now;

                var header_height = $header.outerHeight();

                fitToWindow = function() {
                    var $outer = $parent.find('.mt-editor-manager-wrap:visible');
                    var $inner = $parent.find('iframe:visible, textarea:visible').parent();
                    var offset_height =
                            $outer.outerHeight() - $inner.outerHeight() + header_height,
                        $visibleStatusbarComponents =
                            $parent.find('.mce-resizehandle:visible, .mce-path:visible').filter(function() {
                                return $(this).css('visibility') !== 'hidden';
                            });

                    if ($visibleStatusbarComponents.length === 0) {
                        offset_height -= $parent
                                            .find('.mce-statusbar:visible')
                                            .outerHeight();
                    }

                    forEachAffectedEditors(function() {
                        this.theme.resizeTo(null, $window.height() - offset_height);
                    });
                };
            });

            ed.addCommand('mtFullScreenFitToWindow', function() {
                if (fitToWindow) {
                    fitToWindow();
                }
            });

            ed.addCommand('mtFullScreenIsEnabled', function(hash) {
                hash['enabled'] = enabled;
            });

            ed.addCommand('mtFullScreen', function() {
                if (! enabled) {
                    editorSize = ed.execCommand('mtGetEditorSize');

                    $parent
                        .addClass('fullscreen_editor')
                        .css({
                            width: '100%',
                            margin: '0',
                            padding: '0'
                        });
                    $('body').addClass('fullscreen_editor_screen');

                    forEachAffectedEditors(function() {
                        $(ed.getContainer()).find('.mce-resizehandle').hide();
                    });

                    enabled = true;
                    ed.execCommand('mtFullScreenUpdateFitToWindow');
                    fitToWindow();
                    $window.bind('resize.mt_fullscreen', fitToWindow);
                }
                else {
                    ed.execCommand('mtRestoreEditorSize', editorSize);

                    $parent
                        .removeClass('fullscreen_editor')
                        .css({
                            width: '',
                            margin: '',
                            padding: ''
                        });
                    $('body').removeClass('fullscreen_editor_screen');

                    forEachAffectedEditors(function() {
                        $(ed.getContainer()).find('.mce-resizehandle').show();
                    });


                    enabled = false;
                    fitToWindow = function(){};
                    $window.unbind('resize.mt_fullscreen');
                }

                forEachAffectedEditors(function() {
                    this.nodeChanged();
                });
            });

            ed.addMTButton('mt_fullscreen', {
                title: 'fullscreen',
                cmd: 'mtFullScreen',
                onPostRender: function() {
                    var ctrl = this;

                    ed.on('NodeChange', function(e) {
                        ctrl.active(enabled);
                    });
                }
            });

            ed.on('Init', function() {
                $window     = $(window);
                $container  = $(ed.getContainer());
                $parent     = $container.closest('#text-field');
                $header     = $parent.find('.editor-header');
                $tabs       = $header.find('.tab');
                if ($header.length == 0 || $tabs.length == 0) {
                    $parent = $container.closest('.field-content');
                }
                fitToWindow = function(){};

                affectedEditors = $parent
                    .find('textarea')
                    .map(function() { return this.id });
            });
        },

        getInfo : function() {
            return {
                longname : 'MTFullscreen',
                author : 'Six Apart, Ltd',
                authorurl : '',
                infourl : '',
                version : '1.0'
            };
        }
    });

    // Register plugin
    tinymce.PluginManager.add('mt_fullscreen', tinymce.plugins.MTFullScreenPlugin, ['mt']);
})(jQuery);
