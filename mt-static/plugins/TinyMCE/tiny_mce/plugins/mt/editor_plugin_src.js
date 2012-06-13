/*
 * Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
 * This program is distributed under the terms of the
 * GNU General Public License, version 2.
 *
 * $Id$
 */
;(function($) {
    tinymce
        .ScriptLoader
        .add(tinymce.PluginManager.urls['mt'] + '/langs/en.js');

    tinymce.Editor.prototype.addMTButton = function(name, opts) {
        var ed = this;

        var modes = {};
        var funcs = opts['onclickFunctions'];
        if (funcs) {
            opts['onclick'] = function() {
                var mode = ed.mtEditorStatus['mode'];
                var func = funcs[mode];
                if (typeof(func) == 'string') {
                    ed.mtProxies[mode].execCommand(func);
                }
                else {
                    func.apply(ed, arguments);
                }

                if (mode == 'source') {
                    ed.onMTSourceButtonClick.dispatch(ed, ed.controlManager);
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
                if (! modes[mode]) {
                    return false;
                }

                if (funcs && mode == 'source') {
                    var func = funcs[mode];
                    if (typeof(func) == 'string') {
                        return ed.mtProxies['source'].isSupported(func, format);
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

    tinymce.create('tinymce.ui.MTTextButton:tinymce.ui.Button', {
        renderHTML : function() {
            var DOM = tinymce.DOM;
            var cp = this.classPrefix, s = this.settings, h, l;

            l = DOM.encode(s.label || '');
            h = '<a role="button" id="' + this.id + '" href="javascript:;" class="mceMTTextButton ' + cp + ' ' + cp + 'Enabled ' + s['class'] + (l ? ' ' + cp + 'Labeled' : '') +'" onmousedown="return false;" onclick="return false;" aria-labelledby="' + this.id + '_voice">';
            h += s.title;
            h += '</a>';
            return h;
        }
    });

	tinymce.create('tinymce.plugins.MovableType', {
        buttonSettings : '',
        initButtonSettings : function(ed) {
            var plugin = this;
            plugin.buttonIDs = {};

            var buttonRows = {
                source: {},
                wysiwyg: {}
            };

            var index = 1;
            $.each(['common', 'source', 'wysiwyg'], function(i, k) {
                var p = 'plugin_mt_' + k + '_buttons';
                for (var j = 1; ed.settings[p+j]; j++) {
                    plugin.buttonSettings +=
                        (plugin.buttonSettings ? ',' : '') + ed.settings[p+j];

                    ed.settings['theme_advanced_buttons'+index] =
                        ed.theme.settings['theme_advanced_buttons'+index] =
                        ed.settings[p + j];
                    if (k == 'common') {
                        buttonRows['source'][index-1] =
                            buttonRows['wysiwyg'][index-1] = 1;
                    }
                    else {
                        buttonRows[k][index-1] = 1;
                    }

                    index++;
                }
            });

            return buttonRows;
        },
		init : function(ed, url) {
            var plugin         = this;
            var id             = ed.id;
            var idLengbth      = id.length;
            var blogId         = $('#blog-id').val() || 0;
            var proxies        = {};
            var hiddenControls = [];
            var $container     = null;

            var supportedButtonsCache = {};
            var buttonRows            = this.initButtonSettings(ed);


            ed.mtProxies = proxies;
            ed.mtEditorStatus = {
                mode: 'wysiwyg',
                format: 'richtext'
            };


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

            function updateButtonVisibility() {
                var s = ed.mtEditorStatus;
                $.each(hiddenControls, function(i, k) {
                    $container
                        .find('.mce_' + k)
                        .css({
                            display: ''
                        })
                        .removeClass('mce_mt_button_hidden');
                    ed.controlManager.setDisabled(this, false);
                });
                hiddenControls = [];

                var supporteds = supportedButtons(s.mode, s.format);

                function update(key) {
                    if (! supporteds[key]) {
                        $container.find('.mce_' + key)
                            .css({
                                display: 'none'
                            })
                            .addClass('mce_mt_button_hidden');
                        hiddenControls.push(key);
                    }
                }

                if (s.mode == 'source') {
                    proxies.source.setFormat(s.format);
                    $.each(ed.controlManager.controls, function(k, c) {
                        if (! c.classPrefix) {
                            return;
                        }
                        update(k.substr(idLengbth+1));
                    });
                }
                else {
                    $.each(ed.mtButtons, function(name, button) {
                        update(name);
                    });
                }
                $('#' + id + '_toolbargroup > span > table').each(function(i) {
                    if (buttonRows[s.mode][i]) {
                        $(this).show();
                    }
                    else {
                        $(this).hide();
                    }
                });
            }

	        function openDialog(mode, param) {
		        $.fn.mtDialog.open(
			        ScriptURI + '?' + '__mode=' + mode + '&amp;' + param
	            );
	        }

            function setPopupWindowLoadedHook(callback) {
			    $.each(ed.windowManager.windows, function(k, w) {
                    var iframe  = w.iframeElement;
                    $('#' + iframe.id).load(function() {
                        var win = this.contentWindow;
                        var context = {
                            '$contents': $(this).contents(),
                            'window': win
                        };
                        callback(context, function() {
                            win.tinyMCEPopup.close();

				            //Move focus if webkit so that navigation back will read the item.
				            if (tinymce.isWebKit) {
                                $('#convert_breaks').focus();
				            }
                            proxies.source.focus();
                        });
                    });
                });
            }

            function mtSourceLinkDialog(c, close) {
                function onSubmit() {
                    var $form = $(this);
                    proxies
                        .source
                        .execCommand(
                            'createLink',
                            null,
                            $form.find('#href').val(),
                            {
                                'target': $form.find('#target_list').val(),
                                'title': $form.find('#linktitle').val()
                            }
                        );
                    close();
                };

                c['$contents']
                    .find('form')
                    .attr('onsubmit', '')
                    .submit(onSubmit);

                if (! proxies.source.isSupported('createLink', ed.mtEditorStatus['format'], 'target')) {
                    c['$contents']
                        .find('#targetlistlabel')
                        .closest('tr')
                        .hide();
                }
            }


            ed.onInit.add(function() {
                $container = $(ed.getContainer());
                updateButtonVisibility();
                ed.theme.resizeBy(0, 0);
            });


            ed.addCommand('mtGetStatus', function() {
                return ed.mtEditorStatus;
            });

            ed.addCommand('mtSetStatus', function(status) {
                $.extend(ed.mtEditorStatus, status);
                updateButtonVisibility();
            });

            ed.addCommand('mtGetProxies', function() {
                return proxies;
            });

            ed.addCommand('mtSetProxies', function(_proxies) {
                $.extend(proxies, _proxies);
            });


			// Register buttons
            ed.addButton('mt_insert_html', {
                title : 'mt.insert_html',
                onclick : function() {
                    ed.windowManager.open({
                        file : url + '/insert_html.html',
                        width : 430,
                        height : 335,
                        inline : 1
                    }, {
                        plugin_url : url
                    });
                }
            });

			ed.addMTButton('mt_font_size_smaller', {
				title : 'mt.font_size_smaller',
				onclickFunctions : {
                    wysiwyg: 'fontSizeSmaller',
                    source: 'fontSizeSmaller'
                }
			});

			ed.addMTButton('mt_font_size_larger', {
				title : 'mt.font_size_larger',
				onclickFunctions : {
                    wysiwyg: 'fontSizeLarger',
                    source: 'fontSizeLarger'
                }
			});

            ed.addMTButton('mt_bold', {
                title : 'mt.bold',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('bold');
				    },
                    source: 'bold'
                }
            });

            ed.addMTButton('mt_italic', {
                title : 'mt.italic',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('italic');
				    },
                    source: 'italic'
                }
            });

            ed.addMTButton('mt_underline', {
                title : 'mt.underline',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('underline');
				    },
                    source: 'underline'
                }
            });

            ed.addMTButton('mt_strikethrough', {
                title : 'mt.strikethrough',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('strikethrough');
				    },
                    source: 'strikethrough'
                }
            });

            ed.addMTButton('mt_insert_link', {
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
                    source: 'insertLink'
                }
            });

            ed.addMTButton('mt_insert_email', {
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
                    source: 'insertEmail'
                }
            });

            ed.addMTButton('mt_indent', {
                title : 'mt.indent',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('indent');
				    },
                    source: 'indent'
                }
            });

            ed.addMTButton('mt_outdent', {
                title : 'mt.outdent',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('outdent');
				    }
                }
            });

            ed.addMTButton('mt_insert_unordered_list', {
                title : 'mt.insert_unordered_list',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('insertUnorderedList');
				    },
                    source: 'insertUnorderedList'
                }
            });

            ed.addMTButton('mt_insert_ordered_list', {
                title : 'mt.insert_ordered_list',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('insertOrderedList');
				    },
                    source: 'insertOrderedList'
                }
            });

            ed.addMTButton('mt_justify_left', {
                title : 'mt.justify_left',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('justifyLeft');
				    },
                    source: 'justifyLeft'
                }
            });

            ed.addMTButton('mt_justify_center', {
                title : 'mt.justify_center',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('justifyCenter');
				    },
                    source: 'justifyCenter'
                }
            });

            ed.addMTButton('mt_justify_right', {
                title : 'mt.justify_right',
				onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('justifyRight');
				    },
                    source: 'justifyRight'
                }
            });

			ed.addMTButton('mt_insert_image', {
				title : 'mt.insert_image',
				onclick : function() {
			        openDialog(
				        'dialog_list_asset',
					    '_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blogId + '&amp;dialog_view=1&amp;filter=class&amp;filter_val=image'
		            );
				}
			});

			ed.addMTButton('mt_insert_file', {
				title : 'mt.insert_file',
				onclick : function() {
			        openDialog(
				        'dialog_list_asset',
					    '_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blogId + '&amp;dialog_view=1'
		            );
				}
			});

            ed.addMTButton('mt_source_bold', {
                title : 'strong',
                mtButtonClass: 'text',
				onclickFunctions : {
                    source: 'bold'
                }
            });

            ed.addMTButton('mt_source_italic', {
                title : 'em',
                mtButtonClass: 'text',
				onclickFunctions : {
                    source: 'italic'
                }
            });

            ed.addMTButton('mt_source_blockquote', {
                title : 'blockquote',
                mtButtonClass: 'text',
				onclickFunctions : {
                    source: 'blockquote'
                }
            });

            ed.addMTButton('mt_source_unordered_list', {
                title : 'ul',
                mtButtonClass: 'text',
				onclickFunctions : {
                    source: 'insertUnorderedList'
                }
            });

            ed.addMTButton('mt_source_ordered_list', {
                title : 'ol',
                mtButtonClass: 'text',
				onclickFunctions : {
                    source: 'insertOrderedList'
                }
            });

            ed.addMTButton('mt_source_list_item', {
                title : 'li',
                mtButtonClass: 'text',
				onclickFunctions : {
                    source: 'insertListItem'
                }
            });

            ed.addMTButton('mt_source_link', {
                title : 'mt.insert_link',
				onclickFunctions : {
                    source: function(cmd, ui, val) {
			            tinymce._setActive(ed);
                        this.theme['_mceLink'].apply(this.theme);
                        setPopupWindowLoadedHook(mtSourceLinkDialog);
				    }
                }
            });

            ed.addMTButton('mt_source_mode', {
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
            };
            $.each(stateControls, function(k, v) {
                if (plugin.buttonSettings.indexOf(k) == -1) {
                    delete stateControls[k];
                }
            });
            ed.onNodeChange.add(function(ed, cm, n, co, ob) {
                var s = ed.mtEditorStatus;
                if (s['mode'] == 'wysiwyg') {
                    $.each(stateControls, function(k, v) {
				        cm.setActive(k, ed.queryCommandState(v));
                    });
                    cm.setDisabled('mt_outdent', !ed.queryCommandState('Outdent'));
                }

                if (ed.mtEditorStatus['mode'] == 'source' &&
                    ed.mtEditorStatus['format'] != 'none.tinymce_temp'
                ) {
                    $('#' + id + '_mt_source_mode').css('display', 'none');
                }
                else {
                    $('#' + id + '_mt_source_mode').css('display', '');
                }

                var active =
                    ed.mtEditorStatus['mode'] == 'source' &&
                    ed.mtEditorStatus['format'] == 'none.tinymce_temp';
                cm.setActive('mt_source_mode', active);

                if (! ed.mtProxies['source']) {
                    return;
                }

                $.each(sourceButtons, function(k, command) {
                    cm.setActive(k, ed.mtProxies['source'].isStateActive(command));
                });
            });

            if (! ed.onMTSourceButtonClick) {
			    ed.onMTSourceButtonClick = new tinymce.util.Dispatcher(ed);
            }
            var sourceButtons = {
                'mt_source_bold': 'bold',
                'mt_source_italic': 'italic',
                'mt_source_blockquote': 'blockquote',
                'mt_source_unordered_list': 'insertUnorderedList',
                'mt_source_ordered_list': 'insertOrderedList',
                'mt_source_list_item': 'insertListItem',
                'mt_source_link': 'createLink'
            };
            $.each(sourceButtons, function(k, v) {
                if (plugin.buttonSettings.indexOf(k) == -1) {
                    delete stateControls[k];
                }
            });
            ed.onMTSourceButtonClick.add(function(ed, cm) {
                $.each(sourceButtons, function(k, command) {
                    cm.setActive(k, ed.mtProxies['source'].isStateActive(command));
                });
            });
		},

        createControl : function(name, cm) {
            var editor = cm.editor;
            var ctrl = editor.buttons[name];

            if (
                    (name == 'mt_insert_image')
                    || (name == 'mt_insert_file')
            ) {
                if (! this.buttonIDs[name]) {
                    this.buttonIDs[name] = [];
                }

                var id = name + '_' + this.buttonIDs[name].length;
                this.buttonIDs[name].push(id);

                return cm.createButton(id, $.extend({}, ctrl, {
                    'class': 'mce_' + name
                }));
            }

            if (ctrl && ctrl['mtButtonClass']) {
                var button, buttonClass, escapedButtonClass;
                switch (ctrl['mtButtonClass']) {
                case 'text':
                      buttonClass = tinymce.ui.MTTextButton;
                      break;
                default:
                      throw new Error('Not implemented:' + ctrl['mtButtonClass']);
                }

                if (cm._cls.button) {
                    escapedButtonClass = cm._cls.button;
                }
                cm._cls.button = buttonClass;

                button = cm.createButton(name, $.extend({}, ctrl));

                if (escapedButtonClass !== 'undefined') {
                    cm._cls.button = escapedButtonClass
                }

                return button;
            }


            return null;
        },

		getInfo : function() {
			return {
				longname : 'MovableType',
				author : 'Six Apart, Ltd',
				authorurl : '',
				infourl : '',
				version : '1.0'
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('mt', tinymce.plugins.MovableType);
})(jQuery);
