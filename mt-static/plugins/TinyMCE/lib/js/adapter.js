/*
 * Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
 * This program is distributed under the terms of the
 * GNU General Public License, version 2.
 *
 * $Id$
 */
;(function($) {

MT.Editor.TinyMCE = function() { MT.Editor.apply(this, arguments) };

$.extend(MT.Editor.TinyMCE, MT.Editor, {
    config: {
        script_url: StaticURI +
            'plugins/TinyMCE/tinymce/jscripts/tiny_mce/tiny_mce.js',

        plugins: "lists,style,table,inlinepopups,media,contextmenu,paste,fullscreen,xhtmlxtras,mt",

        language: $('html').attr('lang'),

        theme: "advanced",
        skin: 'mt',
        theme_advanced_toolbar_location: "top",
        theme_advanced_toolbar_align: "left",
        theme_advanced_resizing: true,
        theme_advanced_resize_horizontal: false,

        theme_advanced_statusbar_location: "bottom",
        theme_advanced_path: false,
        theme_advanced_buttons1: "mt_font_size_smaller,mt_font_size_larger,mt_bold,mt_italic,mt_underline,mt_strikethrough,mt_insert_link,mt_insert_email,mt_indent,mt_outdent,mt_insert_unordered_list,mt_insert_ordered_list,mt_justify_left,mt_justify_center,mt_justify_right,mt_insert_image,mt_insert_file,|,mt_source_mode",
        theme_advanced_buttons2: "undo,redo,|,link,unlink,|,hr,removeformat,|,table,|,fullscreen,|,forecolor,backcolor,|,formatselect",
        theme_advanced_buttons3: '',
        theme_advanced_buttons4: '',
        theme_advanced_buttons5: '',

        convert_urls : false,
        extended_valid_elements: "form[action|accept|accept-charset|enctype|method|class|style|mt::asset-id],iframe[src|width|height|name|align|frameborder|scrolling|marginheight|marginwidth]",
        cleanup: true,
        dialog_type: 'modal',

        init_instance_callback: function(ed) {}
    }
});

$.extend(MT.Editor.TinyMCE.prototype, MT.Editor.prototype, {
    initEditor: function(format) {
        var adapter = this;

        adapter.$editorTextarea = $('#' + adapter.id).css({
            width: '100%',
            background: 'white',
            resize: 'none'
        });
        adapter.$editorTextareaParent = adapter.$editorTextarea.parent();
        adapter.$editorElement = adapter.$editorTextarea;

        var config = $.extend({}, this.constructor.config);
        var init_instance_callback = config['init_instance_callback'];
        config['init_instance_callback'] = function(ed) {
            init_instance_callback.apply(this, arguments);
            adapter._init_instance_callback.apply(adapter, arguments);
        };

        $('#' + adapter.id).tinymce(config);
            
        if (MT.EditorManager.toMode(format) == 'source') {
            adapter.setFormat(format);
        }
    },

    setFormat: function(format) {
        var mode = MT.EditorManager.toMode(format);

        this.tinymce.execCommand('mtSetStatus', {
            mode: mode,
            format: format
        });

        if (mode == 'source') {
            if (this.editor !== this.source) {
                this.$editorTextarea
                    .insertAfter(this.$editorIframe)
                    .height(this.$editorIframe.height())
                    .data('base-height', this.$editorIframe.height());

                this.ignoreSetDirty(function() {
                    this.editor.save();
                });

                this.$editorIframe.hide();
                this.$editorTextarea.show();

                this.editor = this.source;
                this.$editorElement = this.$editorTextarea;
            }
        }
        else {
            this.$editorIframe
                .height(this.$editorTextarea.height());
            this.$editorTextarea
                .data('base-height', null)
                .prependTo(this.$editorTextareaParent);

            this.ignoreSetDirty(function() {
                this.tinymce.setContent(this.source.getContent());
            });

            this.$editorIframe.show();
            this.$editorTextarea.hide();

            this.editor = this.tinymce;
            this.$editorElement = this.$editorIframe;
        }
        this.resetUndo();
        this.tinymce.nodeChanged();
    },

    setContent: function(content) {
        if (this.editor) {
            this.editor.setContent(content, {format : 'raw'});
        }
        else {
            this.$editorTextarea.val(content);
        }
    },

    hide: function() {
        this.setFormat('richtext');
        this.tinymce.hide();
    },

    insertContent: function(value) {
        if (this.editor === this.source) {
            this.source.insertContent(value);
        }
        else {
            this.editor.focus();
            this.editor.selection
                .moveToBookmark(this.editor.mt_plugin_bookmark);
            this.editor.execCommand('mceInsertContent', false, value);
        }
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

    _init_instance_callback: function(ed) {
        if (ed.getParam('fullscreen_is_enabled')) {
            return;
        }

        var adapter = this;

        adapter.tinymce = adapter.editor = ed;
        adapter.source = new MT.Editor.Source(adapter.id);
        adapter.proxies = {
            source: new MT.EditorCommand.Source(adapter.source),
            wysiwyg: new MT.EditorCommand.WYSIWYG(adapter)
        };

        ed.execCommand('mtSetProxies', adapter.proxies);

        $('#' + adapter.id + '_tbl').css({
            width: '100%'
        });

        adapter.$editorIframe = $('#' + adapter.id + '_ifr');
        adapter.$editorElement = adapter.$editorIframe;

        var resizeTo = ed.theme.resizeTo;
        ed.theme.resizeTo = function(width, height, store) {
            var base = adapter.$editorTextarea.data('base-height');
            if (base) {
                adapter.$editorTextarea.height(base+height);
                if (store) {
                    adapter.$editorTextarea
                        .data('base-height', base+height);
                }
            }
            resizeTo.apply(ed.theme, arguments);
        };

        var save = ed.save;
        ed.save = function () {
            if (! ed.isHidden()) {
                save.apply(ed, arguments);
            }
        }

        $([
            'onSetContent', 'onKeyDown', 'onReset', 'onPaste',
            'onUndo', 'onRedo'
        ]).each(function() {
            var ev = this;
            ed[ev].add(function() {
                if (! adapter.tinymce.isDirty()) {
                    return;
                }
                adapter.tinymce.isNotDirty = 1;

                adapter.setDirty({
                    target: adapter.$editorTextarea.get(0)
                });
            });
        });

        ed.addCommand('mtSetFormat', function(format) {
            adapter.setFormat(format);
        });
    }
});

MT.Editor.TinyMCE.setupEnsureInitializedMethods([
    'setFormat', 'hide', 'insertContent', 'clearDirty', 'resetUndo'
]);

MT.EditorManager.register('tinymce', MT.Editor.TinyMCE);

})(jQuery);
