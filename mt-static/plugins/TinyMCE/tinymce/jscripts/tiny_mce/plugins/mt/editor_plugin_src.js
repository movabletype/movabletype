/*
 * Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
 * This program is distributed under the terms of the
 * GNU General Public License, version 2.
 *
 * $Id$
 */
;(function($) {
	function openDialog(mode, param) {
		$.fn.mtDialog.open(
			ScriptURI + '?' + '__mode=' + mode + '&amp;' + param
	    );
	}

    tinymce.Editor.prototype.addMtButton = function(name, opts) {
        var ed = this;

        var modes = {};
        var funcs = opts['onclickFunctions'];
        if (opts['onclickFunctions']) {
            opts['onclick'] = function() {
                var mode = ed.mtEditorStatus['mode'];
                var func = funcs[mode];
                if (typeof(func) == 'string') {
                    ed.mtProxies[mode].execCommand(func);
                }
                else {
                    func.apply(ed, arguments);
                }
            };
            for (k in funcs) {
                modes[k] = 1;
            }
        }
        else {
            modes = {wysiwyg:1,source:1};
        }

        if (! opts['isSupported']) {
            opts['isSupported'] = function(mode, format) {
                if (mode == 'wysiwyg') {
                    return true;
                }
                else if (! modes[mode]) {
                    return false;
                }

                if (funcs) {
                    var func = funcs[ed.mtEditorStatus['mode']];
                    if (typeof(func) == 'string') {
                        return ed.mtProxies['source'].isSupported(func);
                    }
                    else {
                        return true;
                    }
                }
                else {
                    return true;
                }
            };
        }

        if (typeof(ed.mtButtons) == 'undefined') {
            ed.mtButtons = {};
        }
        ed.mtButtons[name] = opts;

        return ed.addButton(name, opts);
    };

    tinymce
        .ScriptLoader
        .add(tinymce.PluginManager.urls['mt'] + '/langs/en.js');

	tinymce.create('tinymce.plugins.MovableType', {
		init : function(ed, url) {
            tinymce.DOM.loadCSS(url + '/css/mt.css');

	        var id      = ed.id;
	        var blogId  = $('#blog-id').val() || 0;
	        var proxies = {};
            var disabledControls = [];

            var supportedButtonsCache = {};
            function supportedButtons(mode, format) {
                var k = mode + '-' + format;
                if (! supportedButtonsCache[k]) {
                    supportedButtonsCache[k] = {};
                    $.each(ed.mtButtons, function(name, button) {
                        if (button.isSupported(mode, format)) {
                            supportedButtonsCache[k][name] = button;
                        }
                    });
                }

                return supportedButtonsCache[k];
            };


            ed.mtProxies = proxies;
            ed.mtEditorStatus = {
                mode: 'wysiwyg',
                format: 'richtext'
            };

            ed.addCommand('mtGetStatus', function() {
                return ed.mtEditorStatus;
            });

            ed.addCommand('mtSetStatus', function(status) {
                var s = ed.mtEditorStatus;
                $.extend(s, status);

                $.each(disabledControls, function() {
                    ed.controlManager.setDisabled(this, false);
                });
                disabledControls = [];

                if (s.mode == 'source') {
                    proxies.source.setFormat(s.format);

                    var supporteds = {};
                    $.each(supportedButtons(s.mode, s.format), function(k, v) {
                        supporteds[id + '_' + k] = 1;
                    });

                    $.each(ed.controlManager.controls, function(k, c) {
                        if (! c.disabled && ! supporteds[k]) {
                            ed.controlManager.setDisabled(k, true);
                            disabledControls.push(k);
                        }
                    });
                }
            });

            ed.addCommand('mtGetProxies', function() {
                return proxies;
            });

            ed.addCommand('mtSetProxies', function(_proxies) {
                $.extend(proxies, _proxies);
            });

			// Register buttons
			ed.addMtButton('mt_font_size_smaller', {
				title : 'mt.font_size_smaller',
				onclickFunctions : {
                    wysiwyg: 'fontSizeSmaller',
                    source: 'fontSizeSmaller'
                }
			});

			ed.addMtButton('mt_font_size_larger', {
				title : 'mt.font_size_larger',
				onclickFunctions : {
                    wysiwyg: 'fontSizeLarger',
                    source: 'fontSizeLarger'
                }
			});

            ed.addMtButton('mt_bold', {
                title : 'mt.bold',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('bold');
				    },
                    source: 'bold'
                }
            });

            ed.addMtButton('mt_italic', {
                title : 'mt.italic',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('italic');
				    },
                    source: 'italic'
                }
            });

            ed.addMtButton('mt_underline', {
                title : 'mt.underline',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('underline');
				    },
                    source: 'underline'
                }
            });

            ed.addMtButton('mt_strikethrough', {
                title : 'mt.strikethrough',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('strikethrough');
				    },
                    source: 'strikethrough'
                }
            });

            ed.addMtButton('mt_insert_link', {
                title : 'mt.insert_link',
				onclickFunctions : {
                    wysiwyg: function() {
                        var anchor =
                            ed.dom.getParent(ed.selection.getNode(), 'A');
                        var textSelected = !ed.selection.isCollapsed();

                        proxies['wysiwyg'].execCommand('insertLink', null, {
                            anchor: anchor,
                            textSelected: textSelected
                        });
				    },
                    source: 'insertLink',
                }
            });

            ed.addMtButton('mt_insert_email', {
                title : 'mt.insert_email',
				onclickFunctions : {
                    wysiwyg: function() {
                        var anchor =
                            ed.dom.getParent(ed.selection.getNode(), 'A');
                        var textSelected = !ed.selection.isCollapsed();

                        proxies['wysiwyg'].execCommand('insertEmail', null, {
                            anchor: anchor,
                            textSelected: textSelected
                        });
				    },
                    source: 'insertEmail',
                }
            });

            ed.addMtButton('mt_indent', {
                title : 'mt.indent',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('indent');
				    },
                    source: 'indent'
                }
            });

            ed.addMtButton('mt_outdent', {
                title : 'mt.outdent',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('outdent');
				    }
                }
            });

            ed.addMtButton('mt_insert_unordered_list', {
                title : 'mt.insert_unordered_list',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('insertUnorderedList');
				    },
                    source: 'insertUnorderedList'
                }
            });

            ed.addMtButton('mt_insert_ordered_list', {
                title : 'mt.insert_ordered_list',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('insertOrderedList');
				    },
                    source: 'insertOrderedList'
                }
            });

            ed.addMtButton('mt_justify_left', {
                title : 'mt.justify_left',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('justifyLeft');
				    },
                    source: 'justifyLeft'
                }
            });

            ed.addMtButton('mt_justify_center', {
                title : 'mt.justify_center',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('justifyCenter');
				    },
                    source: 'justifyCenter'
                }
            });

            ed.addMtButton('mt_justify_right', {
                title : 'mt.justify_right',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('justifyRight');
				    },
                    source: 'justifyRight'
                }
            });

			ed.addMtButton('mt_insert_image', {
				title : 'mt.insert_image',
				onclick : function() {
			        openDialog(
				        'dialog_list_asset',
					    '_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blogId + '&amp;dialog_view=1&amp;filter=class&amp;filter_val=image'
		            );
				}
			});

			ed.addMtButton('mt_insert_file', {
				title : 'mt.insert_file',
				onclick : function() {
			        openDialog(
				        'dialog_list_asset',
					    '_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blogId + '&amp;dialog_view=1'
		            );
				}
			});

            ed.addMtButton('mt_source_mode', {
				title : 'mt.source_mode',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('mtSetFormat', 'none.tinymce_temp');
				    },
                    source: function() {
                        ed.execCommand('mtSetFormat', 'richtext');
                    }
                }
            });


			var stateControls = {
                'mt_bold': 'bold',
                'mt_italic': 'italic',
                'mt_underline': 'underline',
                'mt_strikethrough': 'strikethrough',
                'mt_justify_left': 'justifyleft',
                'mt_justify_center': 'justifycenter',
                'mt_justify_right': 'justifyright'
            }
            ed.onNodeChange.add(function(ed, cm, n, co, ob) {
                var s = ed.mtEditorStatus;
                if (s['mode'] == 'wysiwyg') {
                    $.each(stateControls, function(k, v) {
				        cm.setActive(k, ed.queryCommandState(v));
                    });
                    cm.setDisabled('mt_outdent', !ed.queryCommandState('Outdent'));
                }

                if (ed.getParam('fullscreen_is_enabled')) {
                    cm.setDisabled('mt_source_mode', true);
                }
                else {
                    var disabled =
                        ed.mtEditorStatus['mode'] == 'source' &&
                        ed.mtEditorStatus['format'] != 'none.tinymce_temp';
                    cm.setDisabled('mt_source_mode', disabled);

                    var active =
                        ed.mtEditorStatus['mode'] == 'source' &&
                        ed.mtEditorStatus['format'] == 'none.tinymce_temp';
                    cm.setActive('mt_source_mode', active);
                }
            });
		},

		getInfo : function() {
			return {
				longname : 'MovableType',
				author : 'Six Apart, Ltd',
				authorurl : '',
				infourl : '',
				version : tinymce.majorVersion + "." + tinymce.minorVersion
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('mt', tinymce.plugins.MovableType);
})(jQuery);
