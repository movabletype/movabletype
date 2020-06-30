/*
 * Movable Type (r) (C) 2001-2020 Six Apart Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {

MT.Editor.TinyMCE = function() { MT.Editor.apply(this, arguments) };

var suffix = '';
if(jQuery('script[src*="tinymce.min"]').length){
    // min
    suffix = '.min';
}

$.extend(MT.Editor.TinyMCE, MT.Editor, {
    isMobileOSWYSIWYGSupported: function() {
        return false;
    },
    config: {
        plugins: "lists,media,paste,hr,link,textpattern,table",
        external_plugins: {
            'mt': StaticURI + 'plugins/TinyMCE/lib/js/tinymce/plugins/mt/plugin' + suffix + '.js',
            'mt_fullscreen': StaticURI + 'plugins/TinyMCE/lib/js/tinymce/plugins/mt_fullscreen/plugin' + suffix + '.js',
        },

        language: $('html').attr('lang'),
        
        menubar: false,
        branding: false,
        icons: 'mt',
        icons_url: StaticURI + 'plugins/TinyMCE/lib/js/tinymce/icons.js',

        indent_before : 'p,h1,h2,h3,h4,h5,h6,blockquote,div,title,style,pre,script,td,ul,ol,li,dl,dt,dd,area,table,thead,tfoot,tbody,tr,iframe,section,article,hgroup,aside,figure,option,optgroup,datalist',
        indent_after : 'p,h1,h2,h3,h4,h5,h6,blockquote,div,title,style,pre,script,td,ul,ol,li,dl,dt,dd,area,table,thead,tfoot,tbody,tr,iframe,section,article,hgroup,aside,figure,option,optgroup,datalist',

        toolbar1: '',
        // Buttons using both in source and wysiwyg modes.
        plugin_mt_common_buttons1: 'mt_source_mode',
        // Buttons using in source mode.
        plugin_mt_source_buttons1: 'mt_source_bold mt_source_italic mt_source_blockquote mt_source_unordered_list mt_source_ordered_list mt_source_list_item | mt_source_link mt_insert_file mt_insert_image | mt_fullscreen',
        // Buttons using in wysiwyg mode.
        plugin_mt_wysiwyg_buttons1: 'bold italic underline strikethrough | blockquote bullist numlist hr | link unlink | mt_insert_html mt_insert_file mt_insert_image',
        plugin_mt_wysiwyg_buttons2: 'undo redo | forecolor backcolor removeformat | alignleft aligncenter alignright indent outdent | formatselect | tablecontrols | mt_fullscreen',
        plugin_mt_wysiwyg_buttons3: 'table',
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
        valid_children: 'html[#comment|head|body],head[#comment|title|style|script|noscript|meta|link|command|base],title[#comment|#text],link[#comment],meta[#comment],+style[#text],+noscript[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area],+body[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area],section[#comment|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],nav[#comment|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],article[#comment|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],aside[#comment|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],+h1[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+h2[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+h3[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+h4[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+h5[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+h6[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],hgroup[#comment|h6|h5|h4|h3|h2|h1],header[#comment|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],footer[#comment|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],+address[video|ul|time|table|svg|style|section|ruby|progress|pre|output|ol|noscript|nav|meter|meta|menu|mark|link|keygen|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|dl|div|dialog|details|datalist|command|canvas|blockquote|audio|aside|article|address|area],+p[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+pre[video|time|svg|sup|sub|small|ruby|progress|output|object|noscript|meter|meta|mark|map|link|keygen|img|iframe|embed|datalist|command|canvas|audio|area],dialog[#comment|dt|dd],+blockquote[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area],+li[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area],+dt[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+dd[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area],+a[video|ul|time|table|svg|style|section|ruby|progress|pre|output|ol|noscript|nav|meter|meta|menu|mark|link|keygen|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|dl|div|dialog|details|datalist|command|canvas|blockquote|audio|aside|article|address|area],+em[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+strong[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+small[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+cite[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+q[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+dfn[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+abbr[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+code[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+var[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+samp[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+kbd[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+sub[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+sup[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+i[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+b[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],mark[#comment|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],progress[#comment|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],meter[#comment|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],time[#comment|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],ruby[#comment|rp|rt|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],rt[#comment|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],rp[#comment|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],+bdo[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+span[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+ins[video|time|svg|ruby|progress|output|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],del[#comment|#text|a|abbr|acronym|applet|area|audio|b|basefont|bdo|big|br|button|canvas|cite|code|command|datalist|del|dfn|em|embed|font|i|iframe|img|input|ins|kbd|keygen|label|link|map|mark|meta|meter|noscript|object|output|progress|q|ruby|s|samp|script|select|small|span|strike|strong|sub|sup|svg|textarea|time|tt|u|var|video],figure[#comment|figcaption|legend|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],figcaption[#comment|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],embed[#comment],details[#comment|legend|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],command[#comment],+menu[video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],+legend[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area|ul|table|style|section|pre|p|ol|nav|menu|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|dl|div|dialog|details|blockquote|aside|article|address],+div[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area],source[#comment],audio[#comment|source],video[#comment|source|object],+form[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|form|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area],+fieldset[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area],+label[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+button[video|time|textarea|svg|select|ruby|progress|output|meter|meta|mark|link|label|keygen|input|iframe|embed|datalist|command|canvas|button|audio|area|a],datalist[#comment|option|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],keygen[#comment],output[#comment|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],canvas[#comment],+map[video|var|time|textarea|svg|sup|sub|style|strong|span|small|select|section|samp|ruby|q|progress|output|object|nav|meter|meta|mark|map|link|label|keygen|kbd|input|img|iframe|i|hgroup|header|footer|figure|embed|em|dialog|dfn|details|datalist|command|code|cite|canvas|button|br|bdo|b|audio|aside|article|abbr|a|#text],mathml[#comment],svg[#comment],+caption[video|ul|time|table|svg|style|section|ruby|progress|pre|p|output|ol|noscript|nav|meter|meta|menu|mark|link|keygen|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|dl|div|dialog|details|datalist|command|canvas|blockquote|audio|aside|article|address|area],+th[video|time|svg|ruby|progress|output|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+td[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area],+object[embed|param]',
        non_empty_elements: 'td,th,iframe,video,audio,object,script,img,area,base,basefont,br,col,frame,hr,img,input,isindex,link,meta,param,embed,source,wbr',

        cleanup: true,

        init_instance_callback: function(ed) {},

        // content_css: '',
        body_class: '',
        body_id: '',
        
        content_security_policy: "script-src 'none';",
        
        // tinymce3
        link_class_list: [
            {title: 'unassigned', value: ''},
            {title: 'button', value: 'button'},
            {title: 'pagination', value: 'pagination'},
            {title: 'class_description', value: 'description'},
            {title: 'breadcrumb', value: 'breadcrumb'},
            {title: 'entry', value: 'entry'},
            {title: 'page', value: 'page'},
            {title: 'license', value: 'license'},
            {title: 'poweredby', value: 'poweredby'},
            {title: 'rank-1', value: 'rank-1'},
            {title: 'rank-2', value: 'rank-2'},
            {title: 'rank-3', value: 'rank-3'},
            {title: 'rank-4', value: 'rank-4'},
            {title: 'rank-5', value: 'rank-5'},
            {title: 'rank-6', value: 'rank-6'},
            {title: 'rank-7', value: 'rank-7'}
        ]
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
        var init_instance_callback = config['init_instance_callback'];
        config['init_instance_callback'] = function(ed) {
            init_instance_callback.apply(this, arguments);
            adapter._init_instance_callback.apply(adapter, arguments);
        };
        config['selector'] = '#' + adapter.id;

        if (adapter.commonOptions['content_css_list'].length > 0){
          config['content_css'] =
              (config['content_css'] + ',' + adapter.commonOptions['content_css_list'].join(','))
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
        if(tinymce.Env.browser.isIE()){
            config["verify_html"] = true;
        }

        tinyMCE.init(config);

        adapter.setFormat(format, true);
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
        });

        if (mode == 'source') {
            if (this.editor !== this.source) {
                this.$editorTextarea
                    .insertAfter(this.$editorIframe)
                    .height(this.$editorIframe.height());

                if (! calledInInit) {
                    this.ignoreSetDirty(function() {
                        this.editor.save();
                    });
                }

                setTimeout(function() {
                    self.$editorTextarea.show();
                    self.$editorIframe.hide();
                    self.$editorPathRow.hide();
                }, 0);

                this.editor = this.source;
                this.$editorElement = this.$editorTextarea;
            }
        }
        else {
            this.$editorIframe.height(this.$editorTextarea.innerHeight());
            this.$editorTextarea.prependTo(this.$editorTextareaParent);

            this.ignoreSetDirty(function() {
                this.tinymce.setContent(this.source.getContent());
            });

            this.$editorIframe.show();
            this.$editorPathRow.show();
            this.$editorTextarea.hide();

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
        return (this.editor === this.source) ?
            this.$editorTextarea.height() :
            this.$editorIframe.innerHeight();
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
                adapter.$editorTextarea.height(height);
            }
            else {
                adapter.$editorIframe.parents('.tox-tinymce').height(height);
                adapter.$editorIframe.height(size['iframeHeight']);
            }
        };
        var Cookie = tinymce.plugins.MovableType.Cookie;
        var size = Cookie.getHash("TinyMCE_" + ed.id + "_size");
        if(size)
            ed.resizeTo(size.cw, size.ch);

        $('#' + adapter.id + '_tbl').css({
            width: '100%'
        });

        var save = ed.save;
        ed.save = function () {
            if (adapter.$editorIframe.css('display') != 'none') {
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
            ed.fire('mtChangeFormat', {format: format});
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
            adapter.$editorTextarea.height(size['textareaHeight']);
            adapter.$editorIframe.css({'width': '100%'});
            adapter.$editorTextarea.css({'width': '100%'});
            adapter.$editorIframe.parents('.tox-tinymce').height(size['iframeHeight']);
        });
        var last_updated;
        ed.on('ResizeEditor', function(e){
            var now = new Date();
            if (last_updated && now - last_updated < 150 ) {
                return;
            }
            last_updated = now;
            var height = adapter.$editorIframe.parents('.tox-tinymce').height();

            adapter.$editorTextarea.height(height);
            var width = '100%';
            var Cookie = tinymce.plugins.MovableType.Cookie;
            Cookie.setHash("TinyMCE_" + ed.id + "_size", {
               cw : width,
               ch : height
             });
        });
    }
});

MT.EditorManager.register('tinymce', MT.Editor.TinyMCE);

})(jQuery);
