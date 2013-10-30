/*
 * Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {
    $.each(['plugin', 'core'], function() {
        tinymce
            .ScriptLoader
            .add(tinymce.PluginManager.urls['mt'] + '/langs/' + this + '.js');
    });

    tinymce.Editor.prototype.addMTButton = function(name, opts) {
        var ed = this;

        var modes = {};
        var funcs = opts['onclickFunctions'];
        var onPostRender = opts['onPostRender'];

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
                    ed.fire('MTSourceButtonClick', ed, ed.controlManager);
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

        opts['onPostRender'] = function() {
            opts['_ctrl'] = this;
            if (onPostRender) {
                onPostRender.apply(this, arguments);
            }
        };

        if (typeof(ed.mtButtons) == 'undefined') {
            ed.mtButtons = {};
        }
        ed.mtButtons[name] = opts;

        return ed.addButton(name, opts);
    };

    tinymce.create('tinymce.plugins.MovableType', {
        buttonSettings : '',

        _initButtonSettings : function(ed) {
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

                    ed.settings['toolbar'+index] =
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

        _setupIframeStatus : function(ed) {
            ed.on('PostRender', function() {
                var $win        = $(window);
                var $c          = $(ed.getContainer());
                var $iframe     = $c.find('iframe');
                var $iframeWin  = $(ed.getWin());
                var ns          = '.tinymce_mt_iframe_status_' + ed.id;

                $iframeWin
                    .focus(function() {
                        $iframe.addClass('state-focus');
                    })
                    .blur(function() {
                        $iframe.removeClass('state-focus');
                    });

                function bindMousemoveToIframe() {
                    $iframeWin.bind('mousemove' + ns, function() {
                        $iframeWin.unbind('mousemove' + ns);
                        $iframe.addClass('state-hover');
                        $win.bind('mousemove' + ns, function() {
                            $win.unbind('mousemove' + ns);
                            $iframe.removeClass('state-hover');
                            bindMousemoveToIframe();
                        });
                    });
                }
                bindMousemoveToIframe();
            });
        },

        init : function(ed, url) {
            var plugin         = this;
            var id             = ed.id;
            var idLengbth      = id.length;
            var blogId         = $('#blog-id').val() || 0;
            var proxies        = {};
            var hiddenControls = [];
            var $container     = null;
            var savedBookmark  = null;

            var supportedButtonsCache = {};
            var buttonRows            = this._initButtonSettings(ed);
            var sourceButtons         = {};



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
                        .find('.mce-i-' + k)
                        .css({
                            display: ''
                        })
                        .removeClass('mce_mt_button_hidden');
                    if (ed.mtButtons[k]['_ctrl']) {
                        ed.mtButtons[k]['_ctrl'].disabled(false);
                    }
                });
                hiddenControls = [];

                var supporteds = supportedButtons(s.mode, s.format);

                function update(key) {
                    if (! supporteds[key]) {
                        $container.find('.mce-i-' + key)
                            .css({
                                display: 'none'
                            })
                            .addClass('mce_mt_button_hidden');
                        hiddenControls.push(key);
                    }
                }

                if (s.mode == 'source') {
                    proxies.source.setFormat(s.format);
                }

                $.each(ed.mtButtons, function(name, button) {
                    update(name);
                });
                $container.find('.mce-container.mce-toolbar').each(function(i) {
                    if (buttonRows[s.mode][i]) {
                        $(this).show();
                    }
                    else {
                        $(this).hide();
                    }
                });
            }

            ed.on('PostRender', function() {
                $container = $(ed.getContainer());
                $container.find('.mce-widget.mce-btn.mce-btn-small button').each(function() {
                    if ($(this).find('i').length === 0) {
                        $(this).addClass('mce-mt-textbutton');
                    }
                });

                $container.find('.mce-btn-group:not(:last-child)').each(function() {
                    $(this).after('<span class="mce-mt-separator"></span>');
                });

            });

            function openDialog(mode, param) {
                createSessionHistoryFallback(location.href);
                $.fn.mtDialog.open(
                    ScriptURI + '?' + '__mode=' + mode + '&amp;' + param
                );
            }

            function mtSourceTemplateDialog(c, close) {
                function insertContent(ed, cmd, ui, val, a) {
                    if (cmd == 'mceInsertContent') {
                        proxies
                            .source
                            .editor
                            .insertContent(val);
                        a.terminate = true;
                    }
                };

                function onSubmit() {
                    ed.on('BeforeExecCommand', insertContent);
                    c['window'].TemplateDialog.insert();
                    ed.on('BeforeExecCommand', insertContent);
                };

                setTimeout(function() {
                    c['$contents']
                        .find('form')
                        .attr('onsubmit', '')
                        .submit(onSubmit);
                }, 0);
            }

            function initSourceButtons(mode, format) {
                $.each(ed.mtButtons, function(name, button) {
                    var command;
                    if (
                        button['onclickFunctions'] &&
                        (command = button['onclickFunctions']['source']) &&
                        (typeof(command) == 'string') &&
                        (plugin.buttonSettings.indexOf(name) != -1)
                       ) {
                        sourceButtons[name] = command;
                    }
                });
            }

            function updateSourceButtonState() {
                $.each(sourceButtons, function(k, command) {
                    ed.mtButtons[k]['_ctrl']
                        .active(ed.mtProxies['source'].isStateActive(command));
                });
            }


            ed.on('Init', function() {
                $container = $(ed.getContainer());
                updateButtonVisibility();
                initSourceButtons();
                //ed.theme.resizeBy(0, 0);
            });

            ed.on('PreInit', function() {
                var attrPrefix  = 'data-mce-mt-',
                    attrRegExp  = new RegExp('^' + attrPrefix),
                    placeholder = 'javascript:void("mce-mt-event-placeholer");return false';

                // Save/Restore event handler of the node.
                ed.parser.addAttributeFilter([/^on|action/], function(nodes, name) {
                    var i, node,
                        internalName = attrPrefix + name;

                    for (i = 0; i < nodes.length; i++) {
                        node = nodes[i];

                        node.attr(internalName, node.attr(name));
                        node.attr(name, placeholder);
                    }
                });

                ed.serializer.addAttributeFilter([attrRegExp], function(nodes, internalName) {
                    var i, node, savedValue, attrValue,
                        name = internalName.substring(attrPrefix.length);

                    for (i = 0; i < nodes.length; i++) {
                        node       = nodes[i];
                        attrValue  = node.attr(name)
                        savedValue = node.attr(internalName);

                        if (attrValue === placeholder) {
                            if (! (savedValue && savedValue.length > 0)) {
                                savedValue = null;
                            }
                            node.attr(name, savedValue);
                        }
                        node.attr(internalName, null);
                    }
                });

                // Escape/Unescape comment/cdata for security
                ed.parser.addNodeFilter('#comment,#cdata', function(nodes, name) {
                    var i, node;

                    for (i = 0; i < nodes.length; i++) {
                        node = nodes[i];
                        node.value = escape(node.value);
                    }
                });

                ed.serializer.addNodeFilter('#comment', function(nodes, name) {
                    var i, node;

                    for (i = 0; i < nodes.length; i++) {
                        node = nodes[i];
                        node.value = unescape(node.value);
                        if (node.value.indexOf('[CDATA[') === 0) {
                            node.name = '#cdata';
                            node.type = 4;
                            node.value = node.value.replace(/^\[CDATA\[|\]\]$/g, '');
                        }
                    }
                });
            });

            if (ed.settings['plugin_mt_tainted_input'] && tinymce.isIE) {
                ed.on('PreInit', function() {
                    var attrPrefix  = 'data-mce-mtie-',
                        placeholder = '-mt-placeholder:auto;',
                        valuePrefix = 'mce-mt-',
                        valueRegExp = new RegExp('^' + valuePrefix);

                    // Save/Restore CSS
                    ed.parser.addNodeFilter('link', function(nodes, name) {
                        var i, node;

                        for (i = 0; i < nodes.length; i++) {
                            node = nodes[i];
                            $.each(['type', 'rel'], function(i, k) {
                                var value = node.attr(k);
                                if (value) {
                                    node.attr(k, valuePrefix + value);
                                }
                            });
                        }
                    });

                    ed.parser.addNodeFilter('style', function(nodes, name) {
                        var i, node;

                        for (i = 0; i < nodes.length; i++) {
                            node = nodes[i];
                            node.attr('type', valuePrefix + (node.attr('type') || 'text/css'));
                        }
                    });

                    ed.serializer.addNodeFilter('link,style', function(nodes, name) {
                        var i, node, value;

                        for (i = 0; i < nodes.length; i++) {
                            node  = nodes[i];
                            $.each(['type', 'rel'], function(i, k) {
                                var value = node.attr(k);
                                if (value) {
                                    node.attr(k, value.replace(valueRegExp, ''));
                                }
                            });
                        }
                    });

                    ed.parser.addAttributeFilter('style', function(nodes, name) {
                        var i, node,
                            internalName = attrPrefix + name;

                        for (i = 0; i < nodes.length; i++) {
                            node = nodes[i];
                            node.attr(internalName, node.attr(name));
                            node.attr(name, placeholder);
                        }
                    });

                    ed.serializer.addAttributeFilter(attrPrefix + 'style', function(nodes, internalName) {
                        var i, node, savedValue, attrValue,
                            name = internalName.substring(attrPrefix.length);

                        for (i = 0; i < nodes.length; i++) {
                            node       = nodes[i];
                            attrValue  = node.attr(name)
                            savedValue = node.attr(internalName);

                            if (attrValue === placeholder) {
                                if (! (savedValue && savedValue.length > 0)) {
                                    savedValue = null;
                                }
                                node.attr(name, savedValue);
                            }
                            node.attr(internalName, null);
                        }
                    });
                });
            }

            this._setupIframeStatus(ed);

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

            ed.addCommand('mtRestoreBookmark', function(bookmark) {
                if (! bookmark) {
                    bookmark = savedBookmark;
                }
                if (bookmark) {
                    ed.selection.moveToBookmark(savedBookmark);
                }
            });

            ed.addCommand('mtSaveBookmark', function() {
                return savedBookmark = ed.selection.getBookmark();
            });


            $(window).bind('dialogDisposed', function() {
                if (savedBookmark) {
                    ed.selection.moveToBookmark(savedBookmark);
                }
                savedBookmark = null;
            });

            // Register buttons
            ed.addButton('mt_insert_html', {
                title : 'mt_insert_html',
                onclick : function() {
		            ed.windowManager.open({
			            title: 'mt_insert_html',
			            body: [
				            {
					            name: 'source',
					            type: 'textbox',
                                multiline: true,
					            rows: 14,
					            autofocus: true,
                                minWidth: 450,
                                minHeight: 220
				            }
			            ],
			            onSubmit: function(e) {
				            var data = e.data, source = data.source;

                            ed.insertContent(source);
			            }
		            });
                }
            });

            ed.addMTButton('mt_insert_image', {
                title : 'mt_insert_image',
                onclick : function() {
                    ed.execCommand('mtSaveBookmark');
                    openDialog(
                        'dialog_list_asset',
                        '_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blogId + '&amp;dialog_view=1&amp;filter=class&amp;filter_val=image'
                    );
                }
            });

            ed.addMTButton('mt_insert_file', {
                title : 'mt_insert_file',
                onclick : function() {
                    ed.execCommand('mtSaveBookmark');
                    openDialog(
                        'dialog_list_asset',
                        '_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blogId + '&amp;dialog_view=1'
                    );
                }
            });

            ed.addMTButton('mt_source_bold', {
                title : 'mt_source_bold',
                text : 'strong',
                mtButtonClass: 'text',
                onclickFunctions : {
                    source: 'bold'
                }
            });

            ed.addMTButton('mt_source_italic', {
                title : 'mt_source_italic',
                text : 'em',
                mtButtonClass: 'text',
                onclickFunctions : {
                    source: 'italic'
                }
            });

            ed.addMTButton('mt_source_blockquote', {
                title : 'mt_source_blockquote',
                text : 'blockquote',
                mtButtonClass: 'text',
                onclickFunctions : {
                    source: 'blockquote'
                }
            });

            ed.addMTButton('mt_source_unordered_list', {
                title : 'mt_source_unordered_list',
                text : 'ul',
                mtButtonClass: 'text',
                onclickFunctions : {
                    source: 'insertUnorderedList'
                }
            });

            ed.addMTButton('mt_source_ordered_list', {
                title : 'mt_source_ordered_list',
                text : 'ol',
                mtButtonClass: 'text',
                onclickFunctions : {
                    source: 'insertOrderedList'
                }
            });

            ed.addMTButton('mt_source_list_item', {
                title : 'mt_source_list_item',
                text : 'li',
                mtButtonClass: 'text',
                onclickFunctions : {
                    source: 'insertListItem'
                }
            });

            ed.addMTButton('mt_source_link', {
                title : 'mt_insert_link',
                onclickFunctions : {
                    source: function(cmd, ui, val) {
                        ed.focus();

                        var _open = ed.windowManager.open;
                        ed.windowManager.open = function(args, params) {
                            args.body[0]['minWidth'] = 263;
                            var spliced = args.body.splice(1, args.body.length-1);
                            if (proxies.source.isSupported('createLink', ed.mtEditorStatus['format'], 'target')) {
                                args.body.push(spliced.pop());
                            }
                            return _open.apply(this, arguments);
                        };
                        ed.buttons['link'].onclick();
                        ed.windowManager.open = _open;

                        var win         = ed.windowManager.windows[0],
                            selected    = proxies.source.e.getSelectedText() || '',
                            targetInput = win.find('#target')[0];

                        win.settings.data.text = '-mt-dummy-initial-text';

                        function createLink(args) {
                            if (args.command == 'mceInsertContent') {
                                proxies
                                    .source
                                    .execCommand(
                                        'createLink',
                                        null,
                                        win.find('#href')[0].value(),
                                        {
                                            'target': targetInput
                                                         ? targetInput.value()
                                                         : ''
                                        }
                                    );

                                ed.off('BeforeExecCommand', createLink);
                            }
                        }

                        ed.on('BeforeExecCommand', createLink);
                        win.on('close', function() {
                            ed.off('BeforeExecCommand', createLink);
                        });
                    }
                }
            });

            ed.addMTButton('mt_source_template', {
                title : 'Template',
                onclickFunctions : {
                    source: function(cmd, ui, val) {
                        ed.focus();
                        ed.buttons['template'].onclick();

                        function insertContent(args) {
                            if (args.command == 'mceInsertContent') {
                                proxies
                                    .source
                                    .editor
                                    .insertContent(args.value);
                                args.isDefaultPrevented = function(){return false};

                                ed.off('BeforeExecCommand', insertContent);
                            }
                        };

                        ed.on('BeforeExecCommand', insertContent);
                        ed.windowManager.windows[0].on('close', function() {
                            ed.off('BeforeExecCommand', insertContent);
                        });
                    }
                }
            });

            ed.addMTButton('mt_source_mode', {
                title : 'mt_source_mode',
                onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('mtSetFormat', 'none.tinymce_temp');
                    },
                    source: function() {
                        ed.execCommand('mtSetFormat', 'richtext');
                    }
                },
                onPostRender : function() {
                    var ctrl = this;

                    ed.on('NodeChange', function(options) {
                        var s = ed.mtEditorStatus,
                            $button = $container
                                .find('.mce-i-mt_source_mode')
                                .closest('div');

                        if (ed.mtEditorStatus['mode'] == 'source' &&
                            ed.mtEditorStatus['format'] != 'none.tinymce_temp'
                        ) {
                            $button.css('display', 'none');
                        }
                        else {
                            $button.css('display', '');
                        }

                        var active =
                            ed.mtEditorStatus['mode'] == 'source' &&
                            ed.mtEditorStatus['format'] == 'none.tinymce_temp';
                        ctrl.active(active);

                        if (! ed.mtProxies['source']) {
                            return;
                        }

                        updateSourceButtonState(ed, ed.controlManager);
                    });
                }
            });

            ed.on('MTSourceButtonClick', updateSourceButtonState);
        },

        getInfo : function() {
            return {
                longname : 'MovableType',
                author : 'Six Apart, Ltd',
                authorurl : '',
                infourl : '',
                version : '2.0'
            };
        }
    });

    // Register plugin
    tinymce.PluginManager.add('mt', tinymce.plugins.MovableType);
})(jQuery);
