/*
 * Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {
    $.each(['plugin', 'advanced', 'core'], function() {
        tinymce.ScriptLoader.add(tinymce.PluginManager.urls['mt'] + '/langs/plugin.js');
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
                ed.fire('onMTSourceButtonClick');
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
        if (! opts['onPostRender']) {
            opts['onPostRender'] = function() {
                var self = this;

                ed.on('onMTSourceButtonClick', function(e) {
                    if(ed.mtProxies['source']){
                        self.active(ed.mtProxies['source'].isStateActive(ed.sourceButtons[name]));
                    }
                });
            }

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
            if( ed.inline ) {
                $.each(['wysiwyg'], function(i, k) {
                    var p = 'plugin_mt_' + k + '_insert_toolbar';
                    plugin.buttonSettings +=
                        (plugin.buttonSettings ? ',' : '') + ed.settings[p];

                    ed.settings['insert_toolbar'] += ed.settings[p];
                    buttonRows[k][index-1] = 1;
                    index++;

                    var p = 'plugin_mt_' + k + '_selection_toolbar';
                    plugin.buttonSettings +=
                        (plugin.buttonSettings ? ',' : '') + ed.settings[p];

                    ed.settings['selection_toolbar'] += ed.settings[p];
                    buttonRows[k][index-1] = 1;
                    index++;
                });
            } else {
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
            }
            return buttonRows;
        },

        _setupIframeStatus : function(ed) {
            ed.on('postRender', function() {
                var $win        = $(window);
                var $c          = $(ed.getContainer());
                var $iframe     = $c.find('iframe');
                var $iframeWin  = $(ed.getWin());
                var ns          = '.tinymce_mt_iframe_status_' + ed.id;

                $iframeWin
                    .on('focus', function() {
                        $iframe.addClass('state-focus');
                    })
                    .on('blur', function() {
                        $iframe.removeClass('state-focus');
                    });

                function bindMousemoveToIframe() {
                    $iframeWin.on('mousemove' + ns, function() {
                        $iframeWin.off('mousemove' + ns);
                        $iframe.addClass('state-hover');
                        $win.on('mousemove' + ns, function() {
                            $win.off('mousemove' + ns);
                            $iframe.removeClass('state-hover');
                            bindMousemoveToIframe();
                        });
                    });
                }
                bindMousemoveToIframe();
            });
        },

        _setupExplicitButtonActivation : function(ed) {
            ed.on('postRender', function() {
                var win      = window;
                var button   = '$TinyMCEMTButtonActive';
                var $c       = $(ed.getContainer());
                var selector = '.mceButton, .mceListBoxEnabled, .mceSplitButtonEnabled a';
                $c.find(selector).on('mousedown', function() {
                    win[button] = $(this).addClass('psedo-active');
                });

                $.each([win.document, ed.getWin().document], function() {
                    var w     = this;
                    var ns    = '.tinymce_mt_button_activate';
                    var event = 'mouseup' + ns + ' touchend' + ns;
                    $(w)
                        .off(event)
                        .on(event, function() {
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
            var blogId         = $('[name=blog_id]').val() || 0;
            var proxies        = {};
            var hiddenControls = [];
            var $container     = null;
            var savedBookmark  = null;

            var supportedButtonsCache = {};
            var buttonRows            = this._initButtonSettings(ed);
            ed.sourceButtons         = {};



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
                        .find('[aria-label="' + k + '"]')
                        .css({
                            display: ''
                        })
                        .removeClass('mce_mt_button_hidden');
                });
                hiddenControls = [];

                var supporteds = supportedButtons(s.mode, s.format);

                function update(key) {
                    if (! supporteds[key]) {
                        $container.find('[aria-label="' + key + '"]')
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
                $.each(ed.mtButtons, function(name) {
                    update(name);
                });
                $(ed.editorContainer).find(' .mce-toolbar').each(function(i) {
                    if (buttonRows[s.mode][i]) {
                        $(this).show();
                    }
                    else {
                        $(this).hide();
                    }
                    // common_buttons
                    if( i == 0 ){
                        $(this).addClass('float-right');
                    }
                });

            }

            function openDialog(mode, param) {
                createSessionHistoryFallback(location.href);
                $.fn.mtModal.open(
                    ScriptURI + '?' + '__mode=' + mode + '&amp;' + param,
                    { large: true }
                );
            }

            function setPopupWindowLoadedHook(callback) {
                $.each(ed.windowManager.windows, function(k, w) {
                    w.on('open', function(win){
                        var context = {
                            '$contents': this.$el.contents(),
                            'window': this
                        };
                        callback(context);
                    });
                });
            }

            function mtSourceLinkDialog(c, close) {

                function onSubmit(e) {
                    proxies
                        .source
                        .execCommand(
                            'createLink',
                            null,
                            e.data.href,
                            {
                                'target': e.data.target,
                                'title': e.data.title
                            }
                        );
                    if(typeof(close) == "function")
                        close();
                };
                c["window"].on('submit', onSubmit);

                if (! proxies.source.isSupported('createLink', ed.mtEditorStatus['format'], 'target')) {
                    c['$contents']
                        .find('#targetlistlabel')
                        .closest('tr')
                        .hide();
                }
                c["window"].find('[name=text]')[0].parent().hide();
            }

            function mtSourceTemplateDialog(c, close) {
                function insertContent(e) {
                    if (e.command == 'mceInsertContent' && e.value) {
                        proxies
                            .source
                            .editor
                            .insertContent(e.value);
                    }
                };

                function onSubmit(e) {
                    ed.off('beforeExecCommand', insertContent);
                };
                c["window"].on('submit', onSubmit);
                ed.on('beforeExecCommand', insertContent);
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
                        ed.sourceButtons[name] = command;
                    }
                });
            }
            ed.on('init', function() {
                $container = $(ed.getContainer());
                updateButtonVisibility();
                initSourceButtons();
                // ed.theme.resizeBy(0, 0);
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

                ed.parser.addNodeFilter('link,meta', function(nodes, name) {
                    var i, node;

                    for (i = 0; i < nodes.length; i++) {
                        node = nodes[i];
                        node.remove();
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


            $(window).on('dialogDisposed', function() {
                if (savedBookmark) {
                    ed.selection.moveToBookmark(savedBookmark);
                }
                savedBookmark = null;
            });

            // Register buttons
            ed.addButton('mt_insert_html', {
                icon : 'addhtml',
                tooltip : 'mt_insert_html',
                onclick : function() {

                    win = ed.windowManager.open({
                        title: trans('Insert HTML'),
                        body: {
                            type: 'textbox',
                            label: trans('HTML'),
                            name: 'insert_html',
                            classes: 'insert_html',
                            text: '',
                            multiline: true,
                            minHeight: 290,
                            autofocus: true
                        },
                        onsubmit: function() {
                            ed.execCommand('mceInsertContent', false, $('.mce-insert_html').val());
                        },

                        minWidth: Math.min(tinymce.DOM.getViewPort().w, ed.getParam('template_popup_width', 600)),
                        minHeight: Math.min(tinymce.DOM.getViewPort().h, ed.getParam('template_popup_height', 500))
                    });
                }
            });

            ed.addMTButton('mt_insert_image', {
                icon : 'image',
                tooltip : 'mt_insert_image',
                onclick : function() {
                    ed.execCommand('mtSaveBookmark');
                    openDialog(
                        'dialog_asset_modal',
                        '_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blogId + '&amp;dialog_view=1&amp;filter=class&amp;filter_val=image&amp;can_multi=1'
                    );
                }
            });

            ed.addMTButton('mt_insert_file', {
                icon : 'newdocument',
                tooltip : 'mt_insert_file',
                onclick : function() {
                    ed.execCommand('mtSaveBookmark');
                    openDialog(
                        'dialog_asset_modal',
                        '_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blogId + '&amp;dialog_view=1&amp;can_multi=1'
                    );
                }
            });

            ed.addMTButton('mt_source_bold', {
                tooltip : 'mt_source_bold',
                text : 'strong',
                mtButtonClass: 'text',
                onclickFunctions : {
                    source: 'bold'
                }
            });

            ed.addMTButton('mt_source_italic', {
                tooltip : 'mt_source_italic',
                text : 'em',
                mtButtonClass: 'text',
                onclickFunctions : {
                    source: 'italic'
                }
            });

            ed.addMTButton('mt_source_blockquote', {
                tooltip : 'mt_source_blockquote',
                text : 'blockquote',
                mtButtonClass: 'text',
                onclickFunctions : {
                    source: 'blockquote'
                }
            });

            ed.addMTButton('mt_source_unordered_list', {
                tooltip : 'mt_source_unordered_list',
                text : 'ul',
                mtButtonClass: 'text',
                onclickFunctions : {
                    source: 'insertUnorderedList'
                }
            });

            ed.addMTButton('mt_source_ordered_list', {
                tooltip : 'mt_source_ordered_list',
                text : 'ol',
                mtButtonClass: 'text',
                onclickFunctions : {
                    source: 'insertOrderedList'
                }
            });

            ed.addMTButton('mt_source_list_item', {
                tooltip : 'mt_source_list_item',
                text : 'li',
                mtButtonClass: 'text',
                onclickFunctions : {
                    source: 'insertListItem'
                }
            });

            ed.addMTButton('mt_source_link', {
                icon : 'link',
                tooltip : 'mt_insert_link',
                onclickFunctions : {
                    source: function(cmd, ui, val) {
                        ed.execCommand('mceLink');
                        setPopupWindowLoadedHook(mtSourceLinkDialog);
                    }
                }
            });

            ed.addMTButton('mt_source_template', {
                tooltip : 'template.desc',
                onclickFunctions : {
                    source: function(cmd, ui, val) {
                        ed.buttons.template.onclick();
                        setPopupWindowLoadedHook(mtSourceTemplateDialog);
                    }
                },
            });

            ed.addMTButton('mt_source_mode', {
                icon : 'code',
                tooltip : 'mt_source_mode',
                onclickFunctions : {
                    wysiwyg: function() {
                        ed.execCommand('mtSetFormat', 'none.tinymce_temp');
                    },
                    source: function() {
                        ed.execCommand('mtSetFormat', 'richtext');
                    }
                },
                onPostRender: function() {
                    var self = this;

                    ed.on('onMTSourceButtonClick', function(e) {
                        var s = ed.mtEditorStatus;
                        self.active( s.mode && s.mode == 'source');
                    });
                }
            });
            ed.on('NodeChange', function() {

                var s = ed.mtEditorStatus;

                if (s.mode == 'source' &&
                    s.format != 'none.tinymce_temp'
                ) {
                    $(ed.container).find('.mce-toolbar:eq(0)').css('display', 'none');
                }
                else {
                    $(ed.container).find('.mce-toolbar:eq(0)').css('display', '');
                }

                var active =
                    s.mode == 'source' &&
                    s.format == 'none.tinymce_temp';
                // cm.setActive('mt_source_mode', active);

                if (! ed.mtProxies['source']) {
                    return;
                }
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
                author : 'Six Apart Ltd',
                authorurl : '',
                infourl : '',
                version : '1.0'
            };
        }
    });

    (function() {
    	var each = tinymce.each;

    	tinymce.create('static tinymce.plugins.MovableType.Cookie', {
    		getHash : function(n) {
    			var v = this.get(n), h;

    			if (v) {
    				each(v.split('&'), function(v) {
    					v = v.split('=');
    					h = h || {};
    					h[unescape(v[0])] = unescape(v[1]);
    				});
    			}

    			return h;
    		},

    		setHash : function(n, v, e, p, d, s) {
    			var o = '';

    			each(v, function(v, k) {
    				o += (!o ? '' : '&') + escape(k) + '=' + escape(v);
    			});

    			this.set(n, o, e, p, d, s);
    		},

    		get : function(n) {
    			var c = document.cookie, e, p = n + "=", b;

    			// Strict mode
    			if (!c)
    				return;

    			b = c.indexOf("; " + p);

    			if (b == -1) {
    				b = c.indexOf(p);

    				if (b !== 0)
    					return null;
    			} else
    				b += 2;

    			e = c.indexOf(";", b);

    			if (e == -1)
    				e = c.length;

    			return unescape(c.substring(b + p.length, e));
    		},

    		set : function(n, v, e, p, d, s) {
    			document.cookie = n + "=" + escape(v) +
    				((e) ? "; expires=" + e.toGMTString() : "") +
    				((p) ? "; path=" + escape(p) : "") +
    				((d) ? "; domain=" + d : "") +
    				((s) ? "; secure" : "");
    		},

    		remove : function(name, path, domain) {
    			var date = new Date();

    			date.setTime(date.getTime() - 1000);

    			this.set(name, '', date, path, domain);
    		}
    	});
    })();
    // Register plugin
    tinymce.PluginManager.add('mt', tinymce.plugins.MovableType);
})(jQuery);
