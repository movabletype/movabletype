/*
 * Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {

    MT.Editor.TinyMCE = function() { MT.Editor.apply(this, arguments) };

    $.extend(MT.Editor.TinyMCE, MT.Editor, {
        isMobileOSWYSIWYGSupported: function() {
            return true;
        },
        config: {
            mode: "exact",
            plugins: 'lists,media,paste,mt_fullscreen,mt,hr,link,textcolor,colorpicker,textpattern,fullscreen,compat3x,table',
            language: $('html').attr('lang'),
            theme: "modern",
            skin: 'lightgray',
            menubar: false,
            branding: false,
            forced_root_block: 'p',
            resize: true,

            // Buttons using both in source and wysiwyg modes.
            plugin_mt_common_buttons1: 'mt_source_mode',

            // Buttons using in source mode.
            plugin_mt_source_buttons1:'mt_source_bold,mt_source_italic,mt_source_blockquote,mt_source_unordered_list,mt_source_ordered_list,mt_source_list_item,|,mt_source_link,mt_insert_file,mt_insert_image,|,mt_fullscreen',
            // Buttons using in wysiwyg mode.
            plugin_mt_wysiwyg_buttons1:'bold,italic,underline,strikethrough,|,blockquote,bullist,numlist,hr,|,link,unlink,|,mt_insert_html,mt_insert_file,mt_insert_image,|,table,',
            plugin_mt_wysiwyg_buttons2:'undo,redo,|,forecolor,backcolor,removeformat,|,alignleft,aligncenter,alignright,indent,outdent,|,formatselect,|,mt_fullscreen',

            plugin_mt_wysiwyg_insert_toolbar: 'bold,italic,underline,strikethrough,|,blockquote,bullist,numlist,hr,|,link,unlink',
            plugin_mt_wysiwyg_selection_toolbar: 'bold,italic,underline,strikethrough,|,blockquote,bullist,numlist,hr,|,link,unlink',

            plugin_mt_inlinepopups_window_sizes: {
                'advanced/link.htm': {
                    width: 350,
                    height: 220
                },
                'advanced/color_picker.htm': {
                    width: 370,
                    height: 280,
                    onload: function(context) {
                        var $contents = $(context['iframe']).contents();

                        $contents.find('a[onmouseover^=showColor]')
                        .each(function() {
                            var callback = this.onmouseover;
                            $(this).on('click', function() {
                                callback();
                                return false;
                            });
                        })
                        .attr('onmouseover', '')
                        .attr('onfocus', '')
                        .attr('href', 'javascript:;');
                    }
                },
                'template/template.htm': {
                    top: function() {
                        var height = $(window).height() - 110,
                        vp     = tinymce.DOM.getViewPort();
                        return Math.round(Math.max(vp.y, vp.y + (vp.h / 2.0) - ((height+60) / 2.0)));
                    },
                    height: function() {
                        return $(window).height() - 110;
                    },
                    onload: function(context) {
                        var window = context['iframe'].contentWindow;
                        var dialog = window.TemplateDialog;
                        if (! dialog) {
                            return;
                        }
                        var resize = dialog.resize;
                        dialog.resize = function() {
                            resize();

                            var e = window.document.getElementById('templatesrc');
                            if (e) {
                                e.style.height =
                                (parseInt(e.style.height, 10) - 30) + 'px';
                            }
                        };
                        dialog.resize();
                    }
                }
            },

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
            media_strict: false,
            verify_html: false,
            valid_children: '+a[video|ul|time|table|svg|style|section|ruby|progress|pre|output|ol|noscript|nav|meter|meta|menu|mark|link|keygen|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|dl|div|dialog|details|datalist|command|canvas|blockquote|audio|aside|article|address|area]',
            non_empty_elements: 'td,th,iframe,video,audio,object,script,img,area,base,basefont,br,col,frame,hr,img,input,isindex,link,meta,param,embed,source,wbr',

            cleanup: true,
            dialog_type: 'modal',

            init_instance_callback: function(ed) {},

            content_css: '',
            body_class: '',
            body_id: '',
            content_security_policy: "script-src 'none';",
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
            config['elements'] = adapter.id;

            config['content_css'] =
            (config['content_css'] + ',' + adapter.commonOptions['content_css_list'].join(','))
            .replace(/^,+|,+$/g, '').replace(/"/g, '&qquot;');
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
                    config.theme = "modern";
                    config.inline = false;
                } else {
                    config.theme = "inlite";
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
                    .height(this.$editorIframe.height());
                    if (! this.tinymce.queryCommandValue('mtFullScreenIsEnabled')) {
                        var h = this.$editorIframe.height();
                        this.$editorTextarea.data('base-height', h);
                        if (tinyMCE.isIE) {
                            this.$editorTextarea.data('base-height-adjustment', h);
                        }
                        else {
                            this.$editorTextarea.data('base-height-adjustment', 0);
                        }
                    }

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
                this.$editorIframe.height(this.$editorTextarea.innerHeight());
                this.$editorTextarea
                .data('base-height', null)
                .prependTo(this.$editorTextareaParent);

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
        },

        resetUndo: function() {
            this.tinymce.undoManager.clear();
        },

        getDocument: function() {
            return this.editor.getDoc();
        },

        domUpdated: function() {
            var format = this.tinymce.execCommand('mtGetStatus')['format'];
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

            var resizeTo = ed.theme.resizeTo;
            ed.theme.resizeTo = function(width, height, store, isFullscreen) {
                if (isFullscreen) {
                    adapter.$editorTextarea.height(height);
                }
                else {
                    var base       = adapter.$editorTextarea.data('base-height');
                    var adjustment = adapter.$editorTextarea.data('base-height-adjustment');
                    if (base) {
                        adapter.$editorTextarea.height(base+height-adjustment);
                        if (store) {
                            adapter.$editorTextarea
                            .data('base-height', base+height-adjustment);
                        }
                    }
                }
                resizeTo.apply(ed.theme, arguments);
            };

            var Cookie = tinymce.plugins.MovableType.Cookie;
            var size = Cookie.getHash("TinyMCE_" + ed.id + "_size");
            if(size && !this.tinymce.inline)
                ed.theme.resizeTo(size.cw, size.ch);


            $('#' + adapter.id + '_tbl').css({
                width: '100%'
            });

            adapter.$editorIframe = $('#' + adapter.id + '_ifr');
            adapter.$editorElement = adapter.$editorIframe;
            adapter.$editorPathRow = $(ed.getContainer()).find('.mce-path');
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
                    iframeHeight: adapter.$editorIframe.height(),
                    textareaHeight: adapter.$editorTextarea.height(),
                };
            });

            ed.addCommand('mtRestoreEditorSize', function(size) {
                if(!size) return;
                editorContainer = adapter.tinymce.getContainer();
                jQuery(editorContainer).width('');
                adapter.$editorIframe.height(size['iframeHeight']);
                adapter.$editorTextarea.height(size['textareaHeight']);
                adapter.$editorIframe.css({'width': '100%'});
                adapter.$editorTextarea.css({'width': ''});
            });
            var last_updated;
            ed.on('ResizeEditor', function(e){
                var now = new Date();
                if (last_updated && now - last_updated < 150 ) {
                    return;
                }
                last_updated = now;
                var height = adapter.$editorIframe.height();
                adapter.$editorTextarea.height(height);
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
