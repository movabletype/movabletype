/*
 * Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {

    // XXX: Remove localStrage items for TinyMCE 5.x.
    // The silver theme use some JSON strigified storage items.
    // But MT has a probrem with JSON.strigify in mt-static/js/common/JSON.js.
    // So we remove storage items to avoid this problem.
    ["tinymce-url-history", "tinymce-custom-colors"].forEach(function(k) {
        tinymce.util.Tools.resolve('tinymce.util.LocalStorage').removeItem(k);
    });
    var setItem = tinymce.util.Tools.resolve('tinymce.util.LocalStorage').setItem;
    tinymce.util.Tools.resolve('tinymce.util.LocalStorage').setItem = function(key, value){
        // Not Save url-history or custom-colors
        if(key == 'tinymce-url-history' || key == 'tinymce-custom-colors') return;
        setItem.call(this, key, value);
    }

    MT.Editor.TinyMCE = function() { MT.Editor.apply(this, arguments) };

    var suffix = '';
    if(jQuery('script[src*="tinymce.min"]').length){
        // min
        suffix = '.min';
    }
    var cache_suffix = jQuery('script[src*="tinymce"]').attr("src").replace(/.*\?/, '');

    $.extend(MT.Editor.TinyMCE, MT.Editor, {
        isMobileOSWYSIWYGSupported: function() {
            return true;
        },
        config: {
            plugins: 'lists,media,paste,hr,link,textpattern,fullscreen,table,quickbars',
            external_plugins: {
                'mt': StaticURI + 'plugins/TinyMCE5/lib/js/tinymce/plugins/mt/plugin' + suffix + '.js',
                'mt_fullscreen': StaticURI + 'plugins/TinyMCE5/lib/js/tinymce/plugins/mt_fullscreen/plugin' + suffix + '.js',
            },
  
            language: $('html').attr('lang'),
            menubar: false,
            forced_root_block: 'p',
            resize: true,
            icons: 'mt',
            icons_url: StaticURI + 'plugins/TinyMCE5/lib/js/icons.js',

            // Buttons using both in source and wysiwyg modes.
            plugin_mt_common_buttons1: 'mt_source_mode',

            // Buttons using in source mode.
            plugin_mt_source_buttons1:'mt_source_bold mt_source_italic mt_source_blockquote mt_source_unordered_list mt_source_ordered_list mt_source_list_item | mt_source_link mt_insert_file mt_insert_image | mt_fullscreen',
            // Buttons using in wysiwyg mode.
            plugin_mt_wysiwyg_buttons1:'bold italic underline strikethrough | blockquote bullist numlist hr | link unlink | mt_insert_html mt_insert_file mt_insert_image | table',
            plugin_mt_wysiwyg_buttons2:'undo redo | forecolor backcolor removeformat | alignleft aligncenter alignright indent outdent | formatselect | mt_fullscreen',

            plugin_mt_wysiwyg_selection_toolbar: 'bold italic underline strikethrough | blockquote bullist numlist hr | link unlink',
            plugin_mt_wysiwyg_insert_toolbar: 'bold italic underline strikethrough | blockquote bullist numlist hr | link unlink',

            toolbar1: '',
            toolbar2: '',
            quickbars_insert_toolbar: false,
            quickbars_selection_toolbar: false,

            formats: {
                strikethrough: [
                    {
                        inline: 'del',
                        remove : 'all',
                        onformat: function(elm, fmt, vars) {
                            function z(str) {
                                return ('0' + str).slice(-2);
                            }

                            var now = new Date();
                            var m = now.toString().match(/(\-|\+)(\d{2}).?(\d{2})/);

                            var datetime = [
                                now.getFullYear(),
                                z(now.getMonth()+1),
                                z(now.getDate())
                            ].join('-') + 'T' + [
                                z(now.getHours()),
                                z(now.getMinutes()),
                                z(now.getSeconds())
                            ].join(':') + m[1] + m[2] + ':' + m[3];

                            $(elm).attr('datetime', datetime);
                        }
                    },
                    {inline : 'span', styles : {textDecoration : 'line-through'}, exact : true},
                    {inline : 'strike', remove : 'all'}
                ],
                removeformat: [
                    {
                        selector: 'b,strong,em,i,font,u,strike,del',
                        remove: 'all',
                        split: true,
                        expand: false,
                        block_expand: true,
                        deep : true
                    },
                    {selector : 'span', attributes : ['style', 'class'], remove : 'empty', split : true, expand : false, deep : true},
                    {selector : '*', attributes : ['style', 'class'], split : false, expand : false, deep : true}
                ]
            },

            entity_encoding: 'raw',
            convert_urls: false,
            verify_html: false,
            valid_children: '+a[video|ul|time|table|svg|style|section|ruby|progress|pre|output|ol|noscript|nav|meter|meta|menu|mark|link|keygen|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|dl|div|dialog|details|datalist|command|canvas|blockquote|audio|aside|article|address|area]',

            cleanup: true,

            init_instance_callback: function(ed) {},

            body_class: '',
            body_id: '',
            content_security_policy: "script-src 'none';",
            cache_suffix: cache_suffix,
        }
    });

    $.extend(MT.Editor.TinyMCE.prototype, MT.Editor.prototype, {
        initEditor: function(format) {
            var adapter = this;

            adapter.$editorTextarea = $('#' + adapter.id).css({
                width: '100%',
                background: 'white',
                'white-space': 'pre-wrap',
                resize: 'none'
            });
            adapter.$editorTextareaParent = adapter.$editorTextarea.parent();
            adapter.$editorElement = adapter.$editorTextarea;

            var config = $.extend({}, this.constructor.config);

            // ignore errors in the setup function added by the thrid-party plugin.
            ['init_instance_callback', 'setup'].forEach(function(key) {
                var orig = config[key];
                if (! orig) {
                   return;
                }

                config[key] = function(ed) {
                    try {
                        orig.apply(this, arguments);
                    }
                    catch (e) {
                        console.error(e);
                    }
                }
            });

            var init_instance_callback = config['init_instance_callback'];
            config['init_instance_callback'] = function(ed) {
                init_instance_callback.apply(this, arguments);
                adapter._init_instance_callback.apply(adapter, arguments);
            };
            config['selector'] = '#' + adapter.id;

            if (adapter.commonOptions['content_css_list'].length > 0){
                config['content_css'] =
                ((config['content_css'] ? config['content_css'] + ',' : '') + adapter.commonOptions['content_css_list'].join(','))
                .replace(/^,+|,+$/g, '').replace(/"/g, '&qquot;');
            }
            config['body_class'] =
            config['body_class'] + ' ' + adapter.commonOptions['body_class_list'].join(' ')
            if (! ('plugin_mt_tainted_input' in config)) {
                config['plugin_mt_tainted_input'] = adapter.commonOptions['tainted_input'];
            }

            if (! config['body_id']) {
                config['body_id'] = adapter.id;
            }

            var text_format = $('[data-target=' + adapter.id+']').val();
            if( text_format == 'richtext'){
                if ($('#'+adapter.id).attr('data-full_rich_text')) {
                    config.theme = "silver";
                    config.inline = false;
                } else {
                    config.theme = "silver";
                    config.inline = true;
                }
            }

            if( text_format == 'richtext' && config.inline) {
                if( $('#' + adapter.id).prop('nodeName') == 'TEXTAREA' ) {
                    var textarea  = $('#' + adapter.id);
                    var attrs = {};
                    $.each(textarea.get(0).attributes, function(idx, attr){
                        attrs[attr.nodeName] = attr.nodeValue;
                    });
                    var editorElement = textarea.replaceWith(function(){
                        return $('<div />', attrs);
                    });
                    var setup = config['setup'];
                    config['setup'] = function(editor){
                      if(setup) setup.apply(this, arguments);
                      editor.on('init', function(){
                        editor.setContent(adapter.$editorElement.val())
                      });
                    };
                    $('#' + adapter.id).css({
                        'height': 'auto',
                        'min-height': '350px',
                        'max-width': '100%',
                        'overflow-x': 'auto',
                    });
                }
                config["quickbars_insert_toolbar"] = config["plugin_mt_wysiwyg_insert_toolbar"];
                config["quickbars_selection_toolbar"] = config["plugin_mt_wysiwyg_selection_toolbar"];
                config["verify_html"] = true;
            } else {
                if( $('#' + adapter.id).prop('nodeName') == 'DIV') {
                    var div  = $('#' + adapter.id);
                    var attrs = {};
                    $.each(div.get(0).attributes, function(idx, attr){
                        attrs[attr.nodeName] = attr.nodeValue;
                    });
                    var editorElement = div.replaceWith(function(){
                        var html = adapter.$editorElement.html();
                        html = html.replace(/<br\s?(?:data-mce-bogus)?.*?>/g,'');
                        if(html.match(/^<p><\/p>$/)) html = '';
                        return $('<textarea />', attrs).val(html);
                    });
                    $('#' + adapter.id).css({
                        'height': '',
                        'min-height': '',
                        'max-width': '',
                        'overflow-x': '',
                    });
                }
                config["quickbars_insert_toolbar"] = false;
                config["quickbars_selection_toolbar"] = false;
                config["verify_html"] = false;

                if(tinymce.Env.browser.isIE()){
                    config["verify_html"] = true;
                }
            }
            adapter.$editorTextarea = $('#' + adapter.id);

            // default height
            config["height"] = 350;
            var text_height = parseInt(adapter.$editorTextarea.css('height').replace('px', ''));
            if( config["height"] < text_height ){
                config["height"] = text_height;
            }

            tinyMCE.init(config);

            adapter.setFormat(format, true);

            if (MT.Util.isMobileView()) {
                window.oncontextmenu = function(event) {
                    event.preventDefault();
                    event.stopPropagation();
                    return false;
                };
            }
        },

        setFormat: function(format, calledInInit) {
            var self = this,
            mode = MT.EditorManager.toMode(format);

            if (calledInInit && mode != 'source') {
                return;
            }

            this.tinymce.execCommand('mtSetStatus', {
                mode: mode,
                format: format
            }, null, {skip_focus: true});

            if (mode == 'source') {
                if (this.editor !== this.source) {
                    this.$editorTextarea
                    .insertAfter(this.$editorIframe)
                   .height('auto');

                    if (! calledInInit) {
                        this.ignoreSetDirty(function() {
                            this.editor.save.apply(this);
                        });
                    }

                    setTimeout(function() {
                        self.$editorTextarea.show();
                        self.$editorIframe.hide();
                        self.$editorPathRow.children().hide();
                        self.tinymce.hidden = true;
                    }, 0);

                    this.editor = this.source;
                    this.$editorElement = this.$editorTextarea;
                }
            }
            else {
                var height = this.$editorIframe.parents('.tox-tinymce').height();
                this.$editorIframe.height(height - (jQuery('.tox-editor-header').height() + jQuery('.tox-statusbar').height()));
                this.$editorTextarea.prependTo(this.$editorTextareaParent);

                this.ignoreSetDirty(function() {
                    this.tinymce.setContent(this.source.getContent());
                });

                this.$editorIframe.show();
                this.$editorPathRow.children().show();
                this.$editorTextarea.hide();
                self.tinymce.hidden = false;

                this.editor = this.tinymce;
                this.$editorElement = this.$editorIframe;
            }
            this.resetUndo();
            this.tinymce.nodeChanged();
            this._fullScreenFitToWindow();
        },

        _fullScreenFitToWindow: function() {
            var self = this;
            setTimeout(function() {
                self.tinymce.execCommand('mtFullScreenUpdateFitToWindow');
                self.tinymce.execCommand('mtFullScreenFitToWindow');
            }, 0);
        },

        setContent: function(content) {
            if (this.editor) {
                this.editor.setContent(content, {format : 'raw'});
            }
            else {
                this.$editorTextarea.val(content);
            }
        },

        insertContent: function(value) {
            if (this.editor === this.source) {
                this.source.insertContent(value);
            }
            else {
                var selection = this.editor.selection,
                node, originalIsCollapsed;

                this.editor.focus();
                this.editor.execCommand('mtRestoreBookmark');

                node = selection.getNode();
                if (node && node.nodeName === 'IMG') {
                    originalIsCollapsed = selection.isCollapsed;
                    selection.isCollapsed = function(){ return true; };
                    this.editor.execCommand('mceInsertContent', false, value);
                    selection.isCollapsed = originalIsCollapsed;
                }
                else {
                    this.editor.execCommand('mceInsertContent', false, value);
                }
            }
        },

        hide: function() {
            this.setFormat('richtext');
            this.tinymce.hide();
        },

        clearDirty: function() {
            this.tinymce.isNotDirty = 1;
        },

        getHeight: function() {
            return this.$editorElement.height();
        },

        setHeight: function(height) {
            this.$editorElement.height(height);
            let parent = this.$editorElement.parents('.tox-tinymce');
            parent.height(parseInt(height) + parent.find('.tox-editor-header').height() + parent.find('.tox-statusbar').height());
        },

        resetUndo: function() {
            this.tinymce.undoManager.clear();
        },

        getDocument: function() {
            return this.editor.getDoc();
        },

        domUpdated: function() {
            var format = this.tinymce.queryCommandValue('mtGetStatus')['format'];
            try {
                this.tinymce.remove();
            }
            catch(e) {
                $('#' + this.id + '_parent').remove();
                delete tinyMCE.editors[this.id];
            }
            this.initEditor(format);
        },

        _init_instance_callback: function(ed) {
            var adapter = this;

            adapter.tinymce = adapter.editor = ed;
            adapter.source =
            new MT.Editor.Source(adapter.$editorTextarea.attr('id'));
            adapter.proxies = {
                source: new MT.EditorCommand.Source(adapter.source),
                wysiwyg: new MT.EditorCommand.WYSIWYG(adapter)
            };

            ed.execCommand('mtSetProxies', adapter.proxies, null, {skip_focus: true});

            adapter.$editorIframe = $('#' + adapter.id + '_ifr');
            adapter.$editorElement = adapter.$editorIframe;
            adapter.$editorPathRow = $('#' + adapter.id + '_path_row');

            ed.resizeTo = function(width, height, store, isFullscreen) {
                if (isFullscreen) {
                    adapter.$editorTextarea.height('auto');
                }
                else {
                    var wrapper = adapter.$editorIframe.parents('.tox-tinymce');
                    wrapper.height(parseInt(height));
                    adapter.$editorIframe.height(parseInt(height) - (wrapper.find('.tox-editor-header').height() + wrapper.find('.tox-statusbar').height()) );
                }
            };
            var Cookie = tinymce.plugins.MovableType.Cookie;
            var size = Cookie.getHash("TinyMCE_" + ed.id + "_size");
            if(size)
                ed.resizeTo(size.cw, size.ch);

            $('#' + adapter.id + '_tbl').css({
                width: '100%'
            });

            if(adapter.$editorIframe.length){
                adapter.$editorIframeDoc = adapter.$editorIframe.get(0).contentWindow.document;
                adapter.$editorIframeBody = jQuery('body', adapter.$editorIframeDoc);
                adapter.$editorIframeBody.css({
                    'white-space': 'pre-wrap',
                    'word-wrap': 'break-word'
                });
            }
            var save = ed.save;
            ed.save = function () {
                if ( ! ed.isHidden() ) {
                    save.apply(ed, arguments);
                }
            }

            $([
                'SetContent', 'KeyDown', 'Reset', 'Paste',
                'Undo', 'Redo'
            ]).each(function() {
                var ev = this;
                ed.on(ev, function() {
                    if (! adapter.tinymce.isDirty()) {
                        return;
                    }
                    adapter.tinymce.isNotDirty = 1;

                    adapter.setDirty({
                        target: adapter.$editorTextarea.get(0)
                    });
                });
            });

            ed.on('SaveContent', function(ed) {
                ed.content = ed.content.replace(/\u00a0/g, '\u0020');
            });

            ed.addCommand('mtSetFormat', function(format) {
                adapter.manager.setFormat(format);
            });

            ed.addQueryValueHandler('mtGetEditorSize', function() {
                return {
                    iframeHeight: adapter.$editorIframe.parents('.tox-tinymce').height(),
                    textareaHeight: adapter.$editorTextarea.height(),
                };
            });

            ed.addCommand('mtRestoreEditorSize', function(size) {
                if(!size) return;
                editorContainer = adapter.tinymce.getContainer();
                jQuery(editorContainer).width('');
                adapter.$editorIframe.height(size['iframeHeight']);
                adapter.$editorTextarea.height('auto');
                adapter.$editorIframe.css({'width': '100%'});
                adapter.$editorTextarea.css({'width': '100%'});
                var wrapper = adapter.$editorIframe.parents('.tox-tinymce');
                wrapper.height(size['iframeHeight'] + wrapper.find('.tox-editor-header').height() + wrapper.find('.tox-statusbar').height());
            });
            var last_updated;
            ed.on('ResizeEditor', function(e){
                var now = new Date();
                if (last_updated && now - last_updated < 150 ) {
                    return;
                }
                last_updated = now;
                var wrapper = adapter.$editorIframe.parents('.tox-tinymce');
                var height = wrapper.height();
                adapter.$editorIframe.height( parseInt(height) - parseInt(wrapper.find('.tox-editor-header').height() + wrapper.find('.tox-statusbar').height()) );
                adapter.$editorTextarea.height('auto');
                var width = '100%';
                var Cookie = tinymce.plugins.MovableType.Cookie;
                Cookie.setHash("TinyMCE_" + ed.id + "_size", {
                   cw : width,
                   ch : height
                 });
            });
        },
        reload: function(){
            if(this.tinymce) {
                if(!this.tinymce.inline){
                    this.$editorTextarea.parents('.mt-editor-manager-wrap').append(this.$editorTextarea);
                }
                this.tinymce.remove();
                var self = this;
                ["editor","source","proxies","$editorIframe", "$editorElement", "$editorPathRow"].forEach(function(val, index, arr){
                    delete self[val];
                });
                this.$editorTextarea.show();
            }

            this.initEditor($('[data-target=' + this.id+']').val());

        }
    });

    MT.EditorManager.register('tinymce', MT.Editor.TinyMCE);

})(jQuery);
