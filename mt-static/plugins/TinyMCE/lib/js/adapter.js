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
    isMobileOSWYSIWYGSupported: function() {
        return false;
    },
    config: {
        mode: "exact",

        plugins: "lists,style,table,inlinepopups,media,contextmenu,paste,fullscreen,xhtmlxtras,mt",

        language: $('html').attr('lang'),

        theme: "advanced",
        skin: 'mt',
        theme_advanced_toolbar_location: "top",
        theme_advanced_toolbar_align: "left",
        theme_advanced_resizing: true,
        theme_advanced_resize_horizontal: false,

        theme_advanced_statusbar_location: "bottom",
        theme_advanced_buttons1: 'mt_source_bold,mt_source_italic,mt_source_blockquote,mt_source_unordered_list,mt_source_ordered_list,mt_source_list_item,mt_source_link,bold,italic,underline,strikethrough,link,unlink,blockquote,indent,outdent,unordered_list,bullist,numlist,justifyleft,justifycenter,justifyright,mt_insert_file,|,mt_source_mode',
        theme_advanced_buttons2: 'undo,redo,|,removeformat,hr,|,table,|,fullscreen,|,forecolor,backcolor',
        theme_advanced_buttons3: '',
        theme_advanced_buttons4: '',
        theme_advanced_buttons5: '',

        convert_urls : false,
        media_strict: false,
        valid_elements: '@[title|subject|style|spellcheck|role|itemprop|hidden|item|draggable|dir|class|accesskey|id],html[manifest],head[],title[],base[target|href],link[sizes|type|media|rel|href],meta[charset|content|name|http-equiv],style[scoped|media|type|xml::space|xml::lang|lang],script[async|defer|src|type|charset|xml::space|language],noscript[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],body[alink|vlink|link|text|bgcolor|background|onunload|onload|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],section[],nav[],article[],aside[],h1[align|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],h2[align|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],h3[align|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],h4[align|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],h5[align|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],h6[align|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],hgroup[],header[],footer[],address[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],p[align|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],br[clear],pre[xml::space|width|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],dialog[],blockquote[cite|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],ol[reversed|start|compact|type|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],ul[compact|type|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],li[value|type|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],dl[compact|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],dt[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],dd[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],a[type|media|rel|ping|target|href|coords|shape|rev|hreflang|name|charset|onblur|onfocus|tabindex|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],em[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],strong[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],small[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],cite[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],q[cite|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],dfn[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],abbr[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],code[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],var[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],samp[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],kbd[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],sub[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],sup[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],i[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],b[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],mark[],progress[max|value],meter[optimum|high|low|max|min|value],time[datetime],ruby[],rt[],rp[],bdo[xml::lang|lang|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick],span[onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],ins[datetime|cite|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],del[datetime|cite|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],figure[],figcaption[],img[ismap|usemap|width|height|src|alt|vspace|hspace|border|align|longdesc|name|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],iframe[seamless|sandbox|width|height|src|name|align|scrolling|marginheight|marginwidth|frameborder|longdesc],embed[type|width|height|src],object[classid|form|name|usemap|width|height|type|data|vspace|hspace|border|align|tabindex|standby|archive|codetype|codebase|declare|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],param[value|name|type|valuetype],details[open],command[radiogroup|checked|disabled|icon|label|type],menu[label|type|compact|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],legend[align|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],div[align|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],source[media|type|src],audio[controls|loop|autoplay|autobuffer|src],video[poster|height|width|controls|loop|autoplay|autobuffer|src],hr[width|size|noshade|align|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],form[target|novalidate|name|method|enctype|autocomplete|action|accept-charset|accept|onreset|onsubmit|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],fieldset[name|form|disabled|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],label[for|form|onblur|onfocus|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],input[value|files|width|step|src|size|required|readonly|placeholder|pattern|multiple|min|maxlength|max|list|height|formtarget|formnovalidate|formmethod|formenctype|formaction|form|disabled|checked|autocomplete|alt|accept|type|align|onchange|onselect|usemap|name|onblur|onfocus|tabindex|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],button[type|value|name|formtarget|formnovalidate|formmethod|formenctype|formaction|form|disabled|autofocus|onblur|onfocus|tabindex|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],select[size|name|multiple|form|disabled|autofocus|onchange|onblur|onfocus|tabindex|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],datalist[],optgroup[label|disabled|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],option[value|label|selected|disabled|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],textarea[wrap|cols|rows|required|readonly|placeholder|name|maxlength|form|disabled|autofocus|onchange|onselect|onblur|onfocus|tabindex|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],keygen[name|keytype|form|disabled|challenge|autofocus],output[name|form|for],canvas[height|width],map[name|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],area[type|ping|rel|media|target|alt|href|coords|shape|nohref|onblur|onfocus|tabindex|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],mathml[],svg[],table[summary|bgcolor|align|cellpadding|cellspacing|rules|frame|border|width|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],caption[align|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],colgroup[span|valign|charoff|char|align|width|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],col[span|valign|charoff|char|align|width|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],thead[valign|charoff|char|align|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],tfoot[valign|charoff|char|align|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],tbody[valign|charoff|char|align|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],tr[bgcolor|valign|charoff|char|align|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],th[scope|colspan|rowspan|headers|height|width|bgcolor|nowrap|valign|charoff|char|align|axis|abbr|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang],td[colspan|rowspan|headers|height|width|bgcolor|nowrap|valign|charoff|char|align|scope|axis|abbr|onkeyup|onkeydown|onkeypress|onmouseout|onmousemove|onmouseover|onmouseup|onmousedown|ondblclick|onclick|xml::lang|lang]',
        extended_valid_elements: 'form[*]',
        valid_children: 'html[#comment|head|body],head[#comment|title|style|script|noscript|meta|link|command|base],title[#comment|#text],link[#comment],meta[#comment],+style[#text],+script[#text],+noscript[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area],+body[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area],section[#comment|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],nav[#comment|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],article[#comment|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],aside[#comment|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],+h1[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+h2[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+h3[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+h4[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+h5[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+h6[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],hgroup[#comment|h6|h5|h4|h3|h2|h1],header[#comment|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],footer[#comment|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],+address[video|ul|time|table|svg|style|section|ruby|progress|pre|output|ol|noscript|nav|meter|meta|menu|mark|link|keygen|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|dl|div|dialog|details|datalist|command|canvas|blockquote|audio|aside|article|address|area],+p[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+pre[video|time|svg|sup|sub|small|ruby|progress|output|object|noscript|meter|meta|mark|map|link|keygen|img|iframe|embed|datalist|command|canvas|audio|area],dialog[#comment|dt|dd],+blockquote[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area],+li[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area],+dt[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+dd[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area],+a[video|ul|time|table|svg|style|section|ruby|progress|pre|p|output|ol|noscript|nav|meter|meta|menu|mark|link|keygen|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|dl|div|dialog|details|datalist|command|canvas|blockquote|audio|aside|article|address|area|a],+em[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+strong[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+small[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+cite[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+q[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+dfn[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+abbr[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+code[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+var[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+samp[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+kbd[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+sub[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+sup[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+i[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+b[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],mark[#comment|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],progress[#comment|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],meter[#comment|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],time[#comment|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],ruby[#comment|rp|rt|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],rt[#comment|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],rp[#comment|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],+bdo[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+span[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+ins[video|time|svg|ruby|progress|output|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+del[video|time|svg|ruby|progress|output|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],figure[#comment|figcaption|legend|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],figcaption[#comment|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],embed[#comment],details[#comment|legend|video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],command[#comment],+menu[video|var|ul|time|textarea|table|svg|sup|sub|style|strong|span|small|select|section|script|samp|ruby|q|progress|pre|p|output|object|ol|noscript|nav|meter|meta|menu|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|em|dl|div|dialog|dfn|details|del|datalist|command|code|cite|canvas|button|br|blockquote|bdo|b|audio|aside|article|address|area|abbr|a|#text],+legend[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area|ul|table|style|section|pre|p|ol|nav|menu|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|dl|div|dialog|details|blockquote|aside|article|address],+div[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area],source[#comment],audio[#comment|source],video[#comment|source],+form[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|form|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area],+fieldset[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area],+label[video|time|svg|ruby|progress|output|noscript|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+button[video|time|textarea|svg|select|ruby|progress|output|meter|meta|mark|link|label|keygen|input|iframe|embed|datalist|command|canvas|button|audio|area|a],datalist[#comment|option|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],keygen[#comment],output[#comment|video|var|time|textarea|svg|sup|sub|strong|span|small|select|script|samp|ruby|q|progress|output|object|noscript|meter|meta|mark|map|link|label|keygen|kbd|ins|input|img|iframe|i|embed|em|dfn|del|datalist|command|code|cite|canvas|button|br|bdo|b|audio|area|abbr|a|#text],canvas[#comment],+map[video|var|time|textarea|svg|sup|sub|style|strong|span|small|select|section|samp|ruby|q|progress|output|object|nav|meter|meta|mark|map|link|label|keygen|kbd|input|img|iframe|i|hgroup|header|footer|figure|embed|em|dialog|dfn|details|datalist|command|code|cite|canvas|button|br|bdo|b|audio|aside|article|abbr|a|#text],mathml[#comment],svg[#comment],+caption[video|ul|time|table|svg|style|section|ruby|progress|pre|p|output|ol|noscript|nav|meter|meta|menu|mark|link|keygen|hr|hgroup|header|h6|h5|h4|h3|h2|h1|form|footer|figure|fieldset|embed|dl|div|dialog|details|datalist|command|canvas|blockquote|audio|aside|article|address|area],+th[video|time|svg|ruby|progress|output|meter|meta|mark|link|keygen|embed|datalist|command|canvas|audio|area],+td[video|time|svg|style|section|ruby|progress|output|nav|meter|meta|mark|link|keygen|hgroup|header|footer|figure|embed|dialog|details|datalist|command|canvas|audio|aside|article|area]',

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
            'white-space': 'pre',
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
        config['elements'] = adapter.id;

        config['content_css'] =
            adapter.commonOptions['content_css_list'].join(',');

        tinyMCE.init(config);
            
        adapter.setFormat(format, true);
    },

    setFormat: function(format, calledInInit) {
        var mode = MT.EditorManager.toMode(format);

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
                    .height(this.$editorIframe.height())
                    .data('base-height', this.$editorIframe.height());

                if (! calledInInit) {
                    this.ignoreSetDirty(function() {
                        this.editor.save();
                    });
                }

                this.$editorIframe.hide();
                this.$editorPathRow.hide();
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
            this.$editorPathRow.show();
            this.$editorTextarea.hide();

            this.editor = this.tinymce;
            this.$editorElement = this.$editorIframe;
        }
        this.resetUndo();
        this.tinymce.nodeChanged();
    },

    setFormatFullscreen: function(format) {
        var mode = MT.EditorManager.toMode(format);

        this.tinymce.execCommand('mtSetStatus', {
            mode: mode,
            format: format
        });

        if (mode == 'source') {
            this.source.setContent(this.tinymce.getContent());
            this.$editorIframe.hide();
            this.$editorPathRow.hide();
            this.$editorTextarea.show();
        }
        else {
            this.tinymce.setContent(this.source.getContent());
            this.$editorTextarea.hide();
            this.$editorIframe.show();
            this.$editorPathRow.show();
        }

        this._fixFullscreenEditorSize();
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

    domUpdated: function() {
        if (this.tinymce) {
            var format = this.tinymce.execCommand('mtGetStatus')['format'];
            try {
                this.tinymce.remove();
            }
            catch(e) {
                $('#' + this.id + '_parent').remove();
                delete tinyMCE.editors[this.id];
            }
            this.initEditor(format);
        }
    },

    _fixFullscreenEditorSize: function(ed) {
        var $t = $('#mce_fullscreen_tbl')
        var t_h = $t.height();
        var t_w = $t.width();

        var $i = $('.mceIframeContainer', $t);
        var i_h = $i.height();
        var i_w = $i.width();

        var $w = $(window);
        var w_h = $w.height();
        var w_w = $w.width();

        if (! ed) {
            ed = this.tinymce;
        }

        ed.theme.resizeTo(w_w - t_w + i_w, w_h - t_h + i_h);
    },

    _init_instance_callback: function(ed) {
        var adapter = this;

        if (ed.getParam('fullscreen_is_enabled')) {
            adapter = $.extend(adapter);

            ed.addCommand('mtSetFormat', function(format) {
                adapter.setFormatFullscreen(format);
            });

            adapter.$editorIframe   = $('#mce_fullscreen_ifr');
            adapter.$editorTextarea = $('<textarea />')
                .attr('id', 'mce_fullscreen_textarea')
                .css({
                    background: 'white',
                    resize: 'none'
                })
                .insertAfter(adapter.$editorIframe)
                .hide();
            adapter.$editorPathRow = $('#mce_fullscreen_path_row');
            adapter._fixFullscreenEditorSize(ed);
        }

        adapter.tinymce = adapter.editor = ed;
        adapter.source =
            new MT.Editor.Source(adapter.$editorTextarea.attr('id'));
        adapter.proxies = {
            source: new MT.EditorCommand.Source(adapter.source),
            wysiwyg: new MT.EditorCommand.WYSIWYG(adapter)
        };

        ed.execCommand('mtSetProxies', adapter.proxies);


        var resizeTo = ed.theme.resizeTo;
        ed.theme.resizeTo = function(width, height, store) {
            if (ed.getParam('fullscreen_is_enabled')) {
                adapter.$editorTextarea.width(width);
                adapter.$editorTextarea.height(height);
            }
            else {
                var base = adapter.$editorTextarea.data('base-height');
                if (base) {
                    adapter.$editorTextarea.height(base+height);
                    if (store) {
                        adapter.$editorTextarea
                            .data('base-height', base+height);
                    }
                }
            }
            resizeTo.apply(ed.theme, arguments);
        };

        if (ed.getParam('fullscreen_is_enabled')) {
            return;
        }

        $('#' + adapter.id + '_tbl').css({
            width: '100%'
        });

        adapter.$editorIframe = $('#' + adapter.id + '_ifr');
        adapter.$editorElement = adapter.$editorIframe;
        adapter.$editorPathRow = $('#' + adapter.id + '_path_row');

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
