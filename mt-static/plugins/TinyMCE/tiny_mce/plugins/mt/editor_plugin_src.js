/*
 * Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {
    $.each(['plugin', 'advanced', 'core'], function() {
        tinymce
            .ScriptLoader
            .add(tinymce.PluginManager.urls['mt'] + '/langs/' + this + '.js');
    });

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
            h = '<a role="button" id="' + this.id + '" href="javascript:;" class="mceMTTextButton ' + cp + ' ' + cp + 'Enabled ' + s['class'] + (l ? ' ' + cp + 'Labeled' : '') +'" onmousedown="return false;" onclick="return false;" aria-labelledby="' + this.id + '_voice" title="' + DOM.encode(s.title) + '">';
            h += s.text;
            h += '</a>';
            return h;
        }
    });

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

        _setupIframeStatus : function(ed) {
            ed.onPostRender.add(function() {
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

        _setupExplicitButtonActivation : function(ed) {
            ed.onPostRender.add(function() {
                var win      = window;
                var button   = '$TinyMCEMTButtonActive';
                var $c       = $(ed.getContainer());
                var selector = '.mceButton, .mceListBoxEnabled, .mceSplitButtonEnabled a';
                $c.find(selector).mousedown(function() {
                    win[button] = $(this).addClass('psedo-active');
                });

                $.each([win.document, ed.getWin().document], function() {
                    var w     = this;
                    var ns    = '.tinymce_mt_button_activate';
                    var event = 'mouseup' + ns + ' touchend' + ns;
                    $(w)
                        .unbind(event)
                        .bind(event, function() {
                            if (win[button]) {
                                win[button].removeClass('psedo-active');
                                win[button] = null;
                            }
                        });
                });
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
                createSessionHistoryFallback(location.href);
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
                    ed.onBeforeExecCommand.add(insertContent);
                    c['window'].TemplateDialog.insert();
                    ed.onBeforeExecCommand.remove(insertContent);
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

            function updateSourceButtonState(ed, cm) {
                $.each(sourceButtons, function(k, command) {
                    cm.setActive(k, ed.mtProxies['source'].isStateActive(command));
                });
            }


            ed.onInit.add(function() {
                $container = $(ed.getContainer());
                updateButtonVisibility();
                initSourceButtons();
                ed.theme.resizeBy(0, 0);
            });

            ed.onPreInit.add(function() {
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
                ed.onPreInit.add(function() {
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

            this._setupExplicitButtonActivation(ed);
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
                title : 'mt.insert_html',
                onclick : function() {
                    ed.windowManager.open({
                        file : url + '/insert_html.html',
                        width : 430,
                        height : 345,
                        inline : 1
                    }, {
                        plugin_url : url
                    });
                }
            });

            ed.addMTButton('mt_insert_image', {
                title : 'mt.insert_image',
                onclick : function() {
                    ed.execCommand('mtSaveBookmark');
                    openDialog(
                        'dialog_asset_modal',
                        '_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blogId + '&amp;dialog_view=1&amp;filter=class&amp;filter_val=image&amp;can_multi=1'
                    );
                }
            });

            ed.addMTButton('mt_insert_file', {
                title : 'mt.insert_file',
                onclick : function() {
                    ed.execCommand('mtSaveBookmark');
                    openDialog(
                        'dialog_asset_modal',
                        '_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blogId + '&amp;dialog_view=1&amp;can_multi=1'
                    );
                }
            });

            ed.addMTButton('mt_source_bold', {
                title : 'mt.source_bold',
                text : 'strong',
                mtButtonClass: 'text',
                onclickFunctions : {
                    source: 'bold'
                }
            });

            ed.addMTButton('mt_source_italic', {
                title : 'mt.source_italic',
                text : 'em',
                mtButtonClass: 'text',
                onclickFunctions : {
                    source: 'italic'
                }
            });

            ed.addMTButton('mt_source_blockquote', {
                title : 'mt.source_blockquote',
                text : 'blockquote',
                mtButtonClass: 'text',
                onclickFunctions : {
                    source: 'blockquote'
                }
            });

            ed.addMTButton('mt_source_unordered_list', {
                title : 'mt.source_unordered_list',
                text : 'ul',
                mtButtonClass: 'text',
                onclickFunctions : {
                    source: 'insertUnorderedList'
                }
            });

            ed.addMTButton('mt_source_ordered_list', {
                title : 'mt.source_ordered_list',
                text : 'ol',
                mtButtonClass: 'text',
                onclickFunctions : {
                    source: 'insertOrderedList'
                }
            });

            ed.addMTButton('mt_source_list_item', {
                title : 'mt.source_list_item',
                text : 'li',
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

            ed.addMTButton('mt_source_template', {
                title : 'template.desc',
                onclickFunctions : {
                    source: function(cmd, ui, val) {
                        tinymce._setActive(ed);
                        ed.execCommand('mceTemplate');
                        setPopupWindowLoadedHook(mtSourceTemplateDialog);
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


            if (! ed.onMTSourceButtonClick) {
                ed.onMTSourceButtonClick = new tinymce.util.Dispatcher(ed);
            }
            ed.onMTSourceButtonClick.add(updateSourceButtonState);

            ed.onNodeChange.add(function(ed, cm, n, co, ob) {
                var s = ed.mtEditorStatus;

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

                updateSourceButtonState(ed, ed.controlManager);
            });
        },

        createControl : function(name, cm) {
            var editor = cm.editor;
            var ctrl   = editor.buttons[name];

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
