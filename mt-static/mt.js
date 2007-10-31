/*
Copyright 2001-2007 Six Apart. This code cannot be redistributed without
permission from www.sixapart.com.  For more information, consult your
Movable Type license.

$Id$
*/

var pager;
var CMSScriptURI;
var ScriptURI;
var ScriptBaseURI;
var StaticURI;
var HelpBaseURI;
var Lexicon = {};
var itemset_options = {};

if ((!(navigator.appVersion.indexOf('MSIE') != -1) &&
      (parseInt(navigator.appVersion)==4))) {
    document.write("<style type=\"text/css\">");
    document.write("body { margin-top: -8px; margin-left: -8px; }"); 
    document.write("</style>");
}

var origWidth, origHeight;
if ((navigator.appName == 'Netscape') &&
    (parseInt(navigator.appVersion) == 4)) {
    origWidth = innerWidth;
    origHeight = innerHeight;
    window.onresize = restore;
}

function restore () {
    if (innerWidth != origWidth || innerHeight != origHeight)
        location.reload();
}

function doRebuild (blogID, otherParams) {
    window.open(CMSScriptURI + '?__mode=rebuild_confirm&blog_id=' + blogID + '&' + otherParams, 'rebuild', 'width=400,height=400,resizable=yes');
}

function openManual (section, page) {
    var url;
    if (page)
        url = HelpBaseURI + 'help/' + section + '/' + page + '/';
    else if (section)
        url = HelpBaseURI + 'help/' + section + '/';
    else
        url = HelpBaseURI + 'help/';
    window.open(url, 'mt_help', 
'scrollbars=yes,status=yes,resizable=yes,toolbar=yes,location=yes,menubar=yes');
    return false;
}

function countMarked (f, nameRestrict) {
    var count = 0;
    var e = f.id;
    if (!e) return 0;
    if (e.type && e.type == 'hidden') return 1;
    if (e.value && e.checked)
        count++;
    else
    if (nameRestrict) {
        for (i=0; i<e.length; i++)
            if (e[i].checked && (e[i].name == nameRestrict))
                count++;
    } else {
        for (i=0; i<e.length; i++)
            if (e[i].checked)
                count++;
    }
   return count;
}

//For make-js script
//trans('delete');
//trans('remove');
//trans('enable');
//trans('disable');
function doRemoveItems (f, singular, plural, nameRestrict, args, params) {
    if (params && (typeof(params) == 'string')) {
        params = { 'mode': params };
    } else if (!params) {
        params = {}
    }
    var verb = params['verb'] || trans('delete');
    var mode = params['mode'] || 'delete';
    var object_type;
    if (params['type']) {
        object_type = params['type'];
    } else {
        for (var i = 0; i < f.childNodes.length; i++) {
            if (f.childNodes[i].name == '_type') {
                object_type = f.childNodes[i].value;
                break;
            }
        }
    }
    var count = countMarked(f, nameRestrict);
    if (!count) {
        alert(params['none_prompt'] || trans('You did not select any [_1] to [_2].', plural, verb));
        return false;
    }
    var singularMessage = params['singular_prompt'] || trans('Are you sure you want to [_2] this [_1]?');
    var pluralMessage = params['plural_prompt'] || trans('Are you sure you want to [_3] the [_1] selected [_2]?');
    if (object_type == 'role') {
        singularMessage = trans('Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.');
        pluralMessage = trans('Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.');
    }
    if (confirm(count == 1 ? trans(singularMessage, singular, verb) : trans(pluralMessage, count, plural, verb))) {
        return doForMarkedInThisWindow(f, singular, plural, nameRestrict, mode, args);
    }
}

/* Widget support functions */
// function addWidget(el, f) {
//     if (!TC.Client) return;
//     // Add a new widget to the top of the 'el' element
//     var args = DOM.getFormData( f );
//     args['json'] = '1';
//     TC.Client.call({
//         'load': function(c) { addWidgetToPage(el, c); },
//         'error': function() { showMsg("Error adding widget.", "widget-updated", "alert"); },
//         'method': 'POST',
//         'uri': ScriptURI,
//         'arguments': args
//     });
//     return false;
// }
//
// function addWidgetToPage(el, c) {
//     el = TC.elementOrId(el);
//     var result;
//     try {
//         result = eval('(' + c.responseText + ')');
//     } catch(e) {
//         showMsg("Error adding widget.", "widget-updated", "alert");
//         return;
//     }
//     var new_node = document.createElement('div');
//     new_node.innerHTML = result.result.html;
//     var next;
//     if (el.hasChildNodes()) {
//         if (el.firstChild.nodeType != Node.ELEMENT_NODE)
//             next = DOM.getNextElement(el.firstChild);
//         else
//             next = el.firstChild;
//     }
//     if (next) {
//         el.insertBefore(new_node, next);
//     } else {
//         el.appendChild(new_node);
//     }
// }

function removeWidget(id) {
    var f = getByID(id + '-form');
    f['widget_action'].value = 'remove';
    if ((f['widget_singular'].value == '1') || (!TC.Client)) {
        f.submit();
        return;
    }
    var args = DOM.getFormData(f);
    args['json'] = '1';
    TC.Client.call({
        'load': function(c) { removedWidget(id, c); },
        'error': function() { showMsg("Error removing widget.", "widget-updated", "alert"); },
        'method': 'POST',
        'uri': ScriptURI,
        'arguments': args
    });
}

function removedWidget(id, c) {
    var el = getByID(id);
    var parent = el.parentNode;
    parent.removeChild(el);
}

function updateWidget(id) {
    var f = getByID(id + "-form");
    if (!f) return false;
    f['widget_action'].value = 'save';
    if (!TC.Client) return true;
    // if (f['widget_refresh'] && f['widget_refresh'].value) {
    //     return true;
    // }

    var args = DOM.getFormData( f );
    args['json'] = '1';
    TC.Client.call({
        'load': function(c) { updatedWidget(id, c); },
        'error': function() { showMsg("Error updating widget.", "widget-updated", "alert"); },
        'method': 'POST',
        'uri': ScriptURI,
        'arguments': args
    });
    return false;
}

function updatedWidget(id, c) {
    var el = TC.elementOrId(id);
    var result;
    try {
        result = eval('(' + c.responseText + ')');
    } catch(e) {
        showMsg("Error updating widget.", "widget-updated", "alert");
        return;
    }
    if (result.result.html) {
        // updatePrefs has returned a new widget
        el.innerHTML = result.result.html;
    }
    if (result.result.message) {
        showMsg(result.result.message, "widget-updated", "info");
    }
}

function setObjectStatus (f, singular, plural, new_status, nameRestrict, args) {
    var count = countMarked(f, nameRestrict);
    var status_mode = 'enable';
    var named_status = trans('enable');
    if (new_status == 0) {
        status_mode = 'disable';
        named_status = trans('disable');
    }
    if (!count) {
        alert(trans('You did not select any [_1] to [_2].', plural, named_status));
        return false;
    }
    var toSet = "";
    for (var i = 0; i < f.childNodes.length; i++) {
        if (f.childNodes[i].name == '_type') {
            toSet = f.childNodes[i].value;
            break;
        }
    }
    if (toSet) {
        singularMessage = trans('Are you sure you want to [_2] this [_1]?');
        pluralMessage = trans('Are you sure you want to [_3] the [_1] selected [_2]?');
        if (confirm(count == 1 ? trans(singularMessage, singular, named_status) : trans(pluralMessage, count, plural, named_status))) {
            return doForMarkedInThisWindow(f, singular, plural, nameRestrict, status_mode + '_object', args);
        }
    } 
}

function doForMarkedInThisWindow (f, singular, plural, nameRestrict, 
                                  mode, args, phrase) {
    var count = countMarked(f, nameRestrict);
    if (!count) {
        alert(trans('You did not select any [_1] [_2].', plural, phrase));
        return false;
    }
    f.target = "_top";
    if (f.elements['itemset_action_input'])
        f.elements['itemset_action_input'].value = '';
    if (args) {
        var opt;
        var input;
        if (opt = itemset_options[args['action_name']]) {
            if (opt['min'] && (count < opt['min'])) {
                alert(trans('You can only act upon a minimum of [_1] [_2].', opt['min'], plural));
                return false;
            } else if (opt['max'] && (count > opt['max'])) {
                alert(trans('You can only act upon a maximum of [_1] [_2].', opt['max'], plural));
                return false;
            } else if (opt['input']) {
                if (input = prompt(opt['input'])) {
                    f.elements['itemset_action_input'].value = input;
                } else {
                    return false;
                }
            } else if (opt['continue_prompt']) {
                if (!confirm(opt['continue_prompt'])) {
                    return false;
                }
            }
            if (opt['dialog']) {
                f.target = "dialog_iframe";
                show("dialog-container");
                window.onkeypress = dialogKeyPress;
            }
        }
        for (var arg in args) {
            if (f.elements[arg]) f.elements[arg].value = args[arg];
        }
    }
    f.elements["__mode"].value = mode;
    f.submit();
}

function submitFormConfirm(f, mode, message) {
    log.warn('submitFormConfirm() deprecated');
    if (confirm(message)) {
        if (f.elements["__mode"] && mode)
            f.elements["__mode"].value = mode;
        f.submit();
    }
}

function submitForm(f, mode) {
    log.warn('submitForm() deprecated');
    if (f.elements["__mode"] && mode)
        f.elements["__mode"].value = mode;
    f.submit();
}

function doPluginAction(f, plural, phrase) {
    if (!f) {
        var forms = document.getElementsByTagName( "form" );  
        for ( var i = 0; i < forms.length; i++ ) {  
            var pas = truth( forms[ i ][ 'plugin_action_selector' ] );
            if (pas) {
                f = forms[ i ];
                break;
            }
        }
    }
    if (!f)
        return;
    var sel = f['plugin_action_selector'];
    if (sel.length && sel[0].options) sel = sel[0];
    var action = sel.options[sel.selectedIndex].value;
    if (action == '0' || action == '') {
        alert(trans('You must select an action.'));
        return;
    }
    if (itemset_options[action]) {
        if (itemset_options[action]['js']) {
            return eval(itemset_options[action]['js'] + '(f,action);');
        }
    }
    return doForMarkedInThisWindow(f, '', plural, 'id', 'itemset_action', {'action_name': action}, phrase);
}

function updatePluginAction(s) {
    var frm = s.form;
    frm.elements['plugin_action_selector'].value = s[s.selectedIndex].value;
    // synchronize top and bottom plugin action selection
    var el = frm[s.name];
    for (var i = 0; i < el.length; i++)
        if (el[i].selectedIndex != s.selectedIndex)
            el[i].selectedIndex = s.selectedIndex;
}

function doItemsAreJunk (f, type, plural, nameRestrict) {
    doForMarkedInThisWindow(f, type, plural, nameRestrict,
        'handle_junk', {}, trans('to mark as spam'));
}

function doItemsAreNotJunk (f, type, plural, nameRestrict) {
    doForMarkedInThisWindow(f, type, plural, nameRestrict,
        'not_junk', {}, trans('to remove spam status'));
}

function dialogKeyPress(e) {
    if (e.keyCode == 27) {
        // escape key...
        window.onkeypress = null;
        closeDialog();
    }
}

function openDialog(f, mode, params) {
    var url = ScriptURI;
    url += '?__mode=' + mode;
    if (params) url += '&' + params;
    url += '&__type=dialog';
    show("dialog-container");
    // handle escape key for closing modal dialog
    window.onkeypress = dialogKeyPress;
    openDialogUrl(url);
    return false;
}

function openDialogUrl(url) {
    var iframe = getByID("dialog-iframe");
    var frame_d = iframe.contentDocument;
    if (!frame_d) {
        // Sometimes the contentWindow is unavailable because we've just
        // unhidden the container div that holds the iframe. If this happens
        // we have to wait for the contentWindow object to be created
        // before we can access the document within. This may take an extra
        // try using a setTimeout on this window.
        if (iframe.contentWindow)
            frame_d = iframe.contentWindow.document || iframe.document;
    }
    if (frame_d) {
        frame_d.open();
        frame_d.write("<html><head><style type=\"text/css\">\n"
            + "#dialog-indicator {\nposition: relative;\ntop: 200px;\n"
            + "background: url(" + StaticURI + "images/indicator.gif) "
            + "no-repeat;\nwidth: 66px;\nheight: 66px;\nmargin: 0 auto;"
            + "\n}\n</style><script type=\"text/javascript\">\n"
            + "function init() {\ndocument.location = \"" + url + "\";\n}\n"
            + "if (window.navigator.userAgent.match(/ AppleWebKit\\//))\n"
            + "window.setTimeout(\"init()\", 1500);\n"
            + "else window.onload = init;\n</scr"+"ipt></head><body>"
            + "<div align=\"center\"><div id=\"dialog-indicator\"></div>"
            + "</div></body></html>");
        frame_d.close();
    } else {
        window.setTimeout("openDialogUrl('" + url + "')", 100);
    }
}

function closeDialog(url) {
    var w = window;
    while (w.parent && (w.parent != w))
        w = w.parent;
    if (url)
        w.location = url;
    else
        hide("dialog-container", w.document);
    return false;
}

function getByID(n, d) {
    if (!d) d = document;
    if (d.getElementById)
        return d.getElementById(n);
    else if (d.all)
        return d.all[n];
}

var canFormat = 0;
if (document.selection ||
    (typeof(document.createElement("textarea")["setSelectionRange"]) != "undefined"))
    canFormat = 1;

function getSelected(e) {
    if (document.selection) {
        e.focus();
        var range = document.selection.createRange();
        return range.text;
    } else {
        var length = e.textLength;
        var start = e.selectionStart;
        var end = e.selectionEnd;
        if (end == 1 || end == 2 && length != undefined) end = length;
        return e.value.substring(start, end);
    }
}

function setSelection(e, v) {
    if (document.selection) {
        e.focus();
        var range = document.selection.createRange();
        range.text = v;
    } else {
        var scrollTop = e.scrollTop;
        var length = e.textLength;
        var start = e.selectionStart;
        var end = e.selectionEnd;
        if (end == 1 || end == 2 && length != undefined) end = length;
        e.value = e.value.substring(0, start) + v + e.value.substr(end, length);
        e.selectionStart = start + v.length;
        e.selectionEnd = start + v.length;
        e.scrollTop = scrollTop;
    }
    e.focus();
}

function formatStr(e, v) {
    if (!canFormat) return;
    var str = getSelected(e);
    if (str) setSelection(e, '<' + v + '>' + str + '</' + v + '>');
    return false;
}

function mtShortCuts(e) {
    e = e || event;
    var code;
    if (e.keyCode) code = e.keyCode;
    else if (e.which) code = e.which;
    el = e.target || e.srcElement;
    if (el.nodeType == 3) el = el.parentNode; // Safari bug
    if (e.ctrlKey) {
        switch(e.keyCode) {
            case 66: // b
            case 73: // i
            case 85: // u
            disableCtrlDefault(e);
            if (code == '66') formatStr(el, 'strong');
            if (code == '73') formatStr(el, 'em');
            if (code == '85') formatStr(el, 'u');
        }
    }
}

function disableCtrlDefault(e) {
    if(e.preventDefault) {
        e.preventDefault();
    } else {
        e.returnValue = false;
    }
    return;
}

function insertLink(e, isMail) {
    if (!canFormat) return;
    var str = getSelected(e);
    var link = '';
    if (!isMail) {
        if (str.match(/^https?:/)) {
            link = str;
        } else if (str.match(/^(\w+\.)+\w{2,5}\/?/)) {
            link = 'http://' + str;
        } else if (str.match(/ /)) {
            link = 'http://';
        } else {
            link = 'http://' + str;
        }
    } else {
        if (str.match(/@/)) {
            link = str;
        }
    }
    var my_link = prompt(isMail ? trans('Enter email address:') : trans('Enter URL:'), link);
    if (my_link != null) {
         if (str == '') str = my_link;
         if (isMail) my_link = 'mailto:' + my_link;
        setSelection(e, '<a href="' + my_link + '">' + str + '</a>');
    }
    return false;
}

function execFilter(f) {
    var filter_col = f['filter-col'].options[f['filter-col'].selectedIndex].value;
    var opts = f[filter_col+'-val'].options;
    var filter_val = '';
    if (opts) {
        filter_val = opts[f[filter_col+'-val'].selectedIndex].value;
    } else if (f[filter_col+'-val'].value) {
        filter_val = f[filter_col+'-val'].value;
    }
    getByID('filter').value = filter_col;
    getByID('filter_val').value = filter_val;
    getByID('filter-form').submit();
    return false;
}

function setFilterVal(value) {
    var f = getByID('filter-select-form');
    if (value == '') return;
    var filter_col = f['filter-col'].options[f['filter-col'].selectedIndex].value;
    var val_span = getByID("filter-text-val");
    if (filter_col) {
        var filter_fld = f[filter_col+'-val'];
        if (filter_fld.options) {
            for (var i = 0; i < filter_fld.options.length; i++) {
                if (filter_fld.options[i].value == value) {
                    value = filter_fld.options[i].text;
                    // strip off any leading spacing found on category lists
                    value = value.replace(/^(\xA0 )+/, '');
                    filter_fld.selectedIndex = i;
                    if (val_span)
                        val_span.innerHTML = '<strong>' + value + '</strong>';
                    break;
                }
            }
        } else if (filter_fld.value) {
            filter_fld.value = value;
            if (val_span)
                val_span.innerHTML = '<strong>' + value + '</strong>';
        }
    }
}

function toggleDisplayOptions() {
    return toggleActive('display-options');
}

function toggleEntryDisplayOptions() {
    return toggleActive('display-options-widget');
}

function toggleActive( id ) {
    var div = DOM.getElement( id );
    if ( !div )
        return false;
    if ( DOM.hasClassName( div, 'active' ) )
        DOM.removeClassName( div, 'active' );
    else
        DOM.addClassName( div, 'active' );
    return false;
}

function toggleHidden( id ) {
    var div = DOM.getElement( id );
    if ( !div )
        return false;
    if ( DOM.hasClassName( div, 'hidden' ) )
        DOM.removeClassName( div, 'hidden' );
    else
        DOM.addClassName( div, 'hidden' );
    return false;
}

function tabToggle(selectedTab, tabs) {
    log.warn('tabToggle is deprecated. use mt tab delegate');
    for (var i = 0; i < tabs.length; i++) {
        var tabObject = getByID(tabs[i] + '-tab');
        var contentObject = getByID(tabs[i] + '-panel');
            
        if (tabObject && contentObject) {
            if (tabs[i] == selectedTab) {
                DOM.addClassName( tabObject, 'selected-tab' );
                DOM.addClassName( contentObject, 'selected-tab-panel' );
            } else {
                DOM.removeClassName( tabObject, 'selected-tab' );
                DOM.removeClassName( contentObject, 'selected-tab-panel' );
            }
        }
    }
    return false;
}

function show(id, d, style) {
    var el = getByID(id, d);
    if (!el) return;
    el.style.display = style ? style : 'block';
    /* hack */
    if ( DOM.hasClassName( el, "autolayout-height-parent" ) )
        DOM.setHeight( el, finiteInt( el.parentNode.clientHeight ) );
}

function hide(id, d) {
    var el = getByID(id, d);
    if (!el) return;
    el.style.display = 'none';
}

function showReply(id, d, style) {
    var el = getByID(id, d);
    if (!el) return;
    el.style.visibility = style ? style : 'visible';
}

function hideReply(id, d) {
    var el = getByID(id, d);
    if (!el) return;
    el.style.visibility = 'hidden';
}

function toggleSubPrefs(c) {
    var div = TC.elementOrId((c.name || c.id)+"-prefs") || TC.elementOrId((c.name || c.id)+'_prefs');
    if (div) {
        if (c.type) {
            var on = c.type == 'checkbox' ? c.checked : c.value != 0;
            if (on) {
                TC.removeClassName(div, "hidden");
            } else {
                TC.addClassName(div, "hidden");
            }
            // div.style.display = on ? "block" : "none";
        } else {
            var on = div.style.display && div.style.display != "none";
            if (on) {
                TC.addClassName(div, "hidden");
            } else {
                TC.removeClassName(div, "hidden");
            }
            // div.style.display = on ? "none" : "block";
        }
    }
    return false;
}

function toggleAdvancedPrefs(evt, c) {
    evt = evt || window.event;
    var id;
    var obj;
    if (!c || (typeof c != 'string')) {
        c = c || evt.target || evt.srcElement;
        id = c.id || c.name;
        obj = c;
    } else {
        id = c;
    }
    var div = getByID( id + '-advanced');
    if (div) {
        if (obj) {
            var shiftKey = evt ? evt.shiftKey : undefined;
                if (evt && shiftKey && obj.type == 'checkbox')
                obj.checked = true;
            var on = obj.type == 'checkbox' ? obj.checked : obj.value != 0;
            if (on && shiftKey) {
                if (div.style.display == "block")
                    div.style.display = "none";
                else
                    div.style.display = "block";
            } else {
                div.style.display = "none";
            }
        } else {
            if (div.style.display == "block")
                div.style.display = "none";
            else
                div.style.display = "block";
        }
    }
    return false;
}

function trans(str) {
    if (Lexicon && Lexicon[str])
        str = Lexicon[str];
    if (arguments.length > 1)
        for (var i = 1; i <= arguments.length; i++) {
            /* This matches [_#] or [_#:comment] */
            str = str.replace(new RegExp('\\[_' + i + '(?:\:[^\\]]+)?\\]', 'g'), arguments[i]);
            var re = new RegExp('\\[quant,_' + i + ',(.+?)(?:,(.+?))?(?:\:[^\\]]+)?\\]');
            var matches;
            while (matches = str.match(re)) {
                if (arguments[i] != 1)
                    str = str.replace(re, arguments[i] + ' ' +
                        ((typeof(matches[2]) != 'undefined') ? matches[2]
                                                               : matches[1]
                                                                 + 's'));
                else
                    str = str.replace(re, arguments[i] + ' ' + matches[1]);
            }
        }
    return str;
}

function junkScoreNudge(amount, id, max) {
    if (max == undefined) max = 10;
    var fld = getByID(id);
    score = fld.value;
    score.replace(/\+/, '');
    score = parseFloat(score) + amount;
    if (isNaN(score)) score = amount;
    if (score > max) score = max;
    if (score < 0) score = 0;
    fld.value = score;
    return false;
}

var dirify_table = {
    "\u00C0": 'A',    // A`
    "\u00E0": 'a',    // a`
    "\u00C1": 'A',    // A'
    "\u00E1": 'a',    // a'
    "\u00C2": 'A',    // A^
    "\u00E2": 'a',    // a^
    "\u0102": 'A',    // latin capital letter a with breve
    "\u0103": 'a',    // latin small letter a with breve
    "\u00C6": 'AE',   // latin capital letter AE
    "\u00E6": 'ae',   // latin small letter ae
    "\u00C5": 'A',    // latin capital letter a with ring above
    "\u00E5": 'a',    // latin small letter a with ring above
    "\u0100": 'A',    // latin capital letter a with macron
    "\u0101": 'a',    // latin small letter a with macron
    "\u0104": 'A',    // latin capital letter a with ogonek
    "\u0105": 'a',    // latin small letter a with ogonek
    "\u00C4": 'A',    // A:
    "\u00E4": 'a',    // a:
    "\u00C3": 'A',    // A~
    "\u00E3": 'a',    // a~
    "\u00C8": 'E',    // E`
    "\u00E8": 'e',    // e`
    "\u00C9": 'E',    // E'
    "\u00E9": 'e',    // e'
    "\u00CA": 'E',    // E^
    "\u00EA": 'e',    // e^
    "\u00CB": 'E',    // E:
    "\u00EB": 'e',    // e:
    "\u0112": 'E',    // latin capital letter e with macron
    "\u0113": 'e',    // latin small letter e with macron
    "\u0118": 'E',    // latin capital letter e with ogonek
    "\u0119": 'e',    // latin small letter e with ogonek
    "\u011A": 'E',    // latin capital letter e with caron
    "\u011B": 'e',    // latin small letter e with caron
    "\u0114": 'E',    // latin capital letter e with breve
    "\u0115": 'e',    // latin small letter e with breve
    "\u0116": 'E',    // latin capital letter e with dot above
    "\u0117": 'e',    // latin small letter e with dot above
    "\u00CC": 'I',    // I`
    "\u00EC": 'i',    // i`
    "\u00CD": 'I',    // I'
    "\u00ED": 'i',    // i'
    "\u00CE": 'I',    // I^
    "\u00EE": 'i',    // i^
    "\u00CF": 'I',    // I:
    "\u00EF": 'i',    // i:
    "\u012A": 'I',    // latin capital letter i with macron
    "\u012B": 'i',    // latin small letter i with macron
    "\u0128": 'I',    // latin capital letter i with tilde
    "\u0129": 'i',    // latin small letter i with tilde
    "\u012C": 'I',    // latin capital letter i with breve
    "\u012D": 'i',    // latin small letter i with breve
    "\u012E": 'I',    // latin capital letter i with ogonek
    "\u012F": 'i',    // latin small letter i with ogonek
    "\u0130": 'I',    // latin capital letter with dot above
    "\u0131": 'i',    // latin small letter dotless i
    "\u0132": 'IJ',   // latin capital ligature ij
    "\u0133": 'ij',   // latin small ligature ij
    "\u0134": 'J',    // latin capital letter j with circumflex
    "\u0135": 'j',    // latin small letter j with circumflex
    "\u0136": 'K',    // latin capital letter k with cedilla
    "\u0137": 'k',    // latin small letter k with cedilla
    "\u0138": 'k',    // latin small letter kra
    "\u0141": 'L',    // latin capital letter l with stroke
    "\u0142": 'l',    // latin small letter l with stroke
    "\u013D": 'L',    // latin capital letter l with caron
    "\u013E": 'l',    // latin small letter l with caron
    "\u0139": 'L',    // latin capital letter l with acute
    "\u013A": 'l',    // latin small letter l with acute
    "\u013B": 'L',    // latin capital letter l with cedilla
    "\u013C": 'l',    // latin small letter l with cedilla
    "\u013F": 'l',    // latin capital letter l with middle dot
    "\u0140": 'l',    // latin small letter l with middle dot
    "\u00D2": 'O',    // O`
    "\u00F2": 'o',    // o`
    "\u00D3": 'O',    // O'
    "\u00F3": 'o',    // o'
    "\u00D4": 'O',    // O^
    "\u00F4": 'o',    // o^
    "\u00D6": 'O',    // O:
    "\u00F6": 'o',    // o:
    "\u00D5": 'O',    // O~
    "\u00F5": 'o',    // o~
    "\u00D8": 'O',    // O/
    "\u00F8": 'o',    // o/
    "\u014C": 'O',    // latin capital letter o with macron
    "\u014D": 'o',    // latin small letter o with macron
    "\u0150": 'O',    // latin capital letter o with double acute
    "\u0151": 'o',    // latin small letter o with double acute
    "\u014E": 'O',    // latin capital letter o with breve
    "\u014F": 'o',    // latin small letter o with breve
    "\u0152": 'OE',   // latin capital ligature oe
    "\u0153": 'oe',   // latin small ligature oe
    "\u0154": 'R',    // latin capital letter r with acute
    "\u0155": 'r',    // latin small letter r with acute
    "\u0158": 'R',    // latin capital letter r with caron
    "\u0159": 'r',    // latin small letter r with caron
    "\u0156": 'R',    // latin capital letter r with cedilla
    "\u0157": 'r',    // latin small letter r with cedilla
    "\u00D9": 'U',    // U`
    "\u00F9": 'u',    // u`
    "\u00DA": 'U',    // U'
    "\u00FA": 'u',    // u'
    "\u00DB": 'U',    // U^
    "\u00FB": 'u',    // u^
    "\u00DC": 'U',    // U:
    "\u00FC": 'u',    // u:
    "\u016A": 'U',    // latin capital letter u with macron
    "\u016B": 'u',    // latin small letter u with macron
    "\u016E": 'U',    // latin capital letter u with ring above
    "\u016F": 'u',    // latin small letter u with ring above
    "\u0170": 'U',    // latin capital letter u with double acute
    "\u0171": 'u',    // latin small letter u with double acute
    "\u016C": 'U',    // latin capital letter u with breve
    "\u016D": 'u',    // latin small letter u with breve
    "\u0168": 'U',    // latin capital letter u with tilde
    "\u0169": 'u',    // latin small letter u with tilde
    "\u0172": 'U',    // latin capital letter u with ogonek
    "\u0173": 'u',    // latin small letter u with ogonek
    "\u00C7": 'C',    // ,C
    "\u00E7": 'c',    // ,c
    "\u0106": 'C',    // latin capital letter c with acute
    "\u0107": 'c',    // latin small letter c with acute
    "\u010C": 'C',    // latin capital letter c with caron
    "\u010D": 'c',    // latin small letter c with caron
    "\u0108": 'C',    // latin capital letter c with circumflex
    "\u0109": 'c',    // latin small letter c with circumflex
    "\u010A": 'C',    // latin capital letter c with dot above
    "\u010B": 'c',    // latin small letter c with dot above
    "\u010E": 'D',    // latin capital letter d with caron
    "\u010F": 'd',    // latin small letter d with caron
    "\u0110": 'D',    // latin capital letter d with stroke
    "\u0111": 'd',    // latin small letter d with stroke
    "\u00D1": 'N',    // N~
    "\u00F1": 'n',    // n~
    "\u0143": 'N',    // latin capital letter n with acute
    "\u0144": 'n',    // latin small letter n with acute
    "\u0147": 'N',    // latin capital letter n with caron
    "\u0148": 'n',    // latin small letter n with caron
    "\u0145": 'N',    // latin capital letter n with cedilla
    "\u0146": 'n',    // latin small letter n with cedilla
    "\u0149": 'n',    // latin small letter n preceded by apostrophe
    "\u014A": 'N',    // latin capital letter eng
    "\u014B": 'n',    // latin small letter eng
    "\u00DF": 'ss',   // double-s
    "\u015A": 'S',    // latin capital letter s with acute
    "\u015B": 's',    // latin small letter s with acute
    "\u0160": 'S',    // latin capital letter s with caron
    "\u0161": 's',    // latin small letter s with caron
    "\u015E": 'S',    // latin capital letter s with cedilla
    "\u015F": 's',    // latin small letter s with cedilla
    "\u015C": 'S',    // latin capital letter s with circumflex
    "\u015D": 's',    // latin small letter s with circumflex
    "\u0218": 'S',    // latin capital letter s with comma below
    "\u0219": 's',    // latin small letter s with comma below
    "\u0164": 'T',    // latin capital letter t with caron
    "\u0165": 't',    // latin small letter t with caron
    "\u0162": 'T',    // latin capital letter t with cedilla
    "\u0163": 't',    // latin small letter t with cedilla
    "\u0166": 'T',    // latin capital letter t with stroke
    "\u0167": 't',    // latin small letter t with stroke
    "\u021A": 'T',    // latin capital letter t with comma below
    "\u021B": 't',    // latin small letter t with comma below
    "\u0192": 'f',    // latin small letter f with hook
    "\u011C": 'G',    // latin capital letter g with circumflex
    "\u011D": 'g',    // latin small letter g with circumflex
    "\u011E": 'G',    // latin capital letter g with breve
    "\u011F": 'g',    // latin small letter g with breve
    "\u0120": 'G',    // latin capital letter g with dot above
    "\u0121": 'g',    // latin small letter g with dot above
    "\u0122": 'G',    // latin capital letter g with cedilla
    "\u0123": 'g',    // latin small letter g with cedilla
    "\u0124": 'H',    // latin capital letter h with circumflex
    "\u0125": 'h',    // latin small letter h with circumflex
    "\u0126": 'H',    // latin capital letter h with stroke
    "\u0127": 'h',    // latin small letter h with stroke
    "\u0174": 'W',    // latin capital letter w with circumflex
    "\u0175": 'w',    // latin small letter w with circumflex
    "\u00DD": 'Y',    // latin capital letter y with acute
    "\u00FD": 'y',    // latin small letter y with acute
    "\u0178": 'Y',    // latin capital letter y with diaeresis
    "\u00FF": 'y',    // latin small letter y with diaeresis
    "\u0176": 'Y',    // latin capital letter y with circumflex
    "\u0177": 'y',    // latin small letter y with circumflex
    "\u017D": 'Z',    // latin capital letter z with caron
    "\u017E": 'z',    // latin small letter z with caron
    "\u017B": 'Z',    // latin capital letter z with dot above
    "\u017C": 'z',    // latin small letter z with dot above
    "\u0179": 'Z',    // latin capital letter z with acute
    "\u017A": 'z'     // latin small letter z with acute
};

function dirify (s) {
    s = s.replace(/<[^>]+>/g, '');
    for (var p in dirify_table)
        if (s.indexOf(p) != -1)
            s = s.replace(new RegExp(p, "g"), dirify_table[p]);
    s = s.toLowerCase();
    s = s.replace(/&[^;\s]+;/g, '');
    s = s.replace(/[^-a-z0-9_ ]/g, '');
    s = s.replace(/\s+/g, '-');
    return s;
}

function setElementValue(domID, newVal) {
    getByID(domID).value = newVal;
}

/* pager and datasource */

/***
 * Datasource class
 * A class for navigating and displaying data from an AJAX datasource.
 * Methods:
 *   constructor(el, datatype): Creates a new datasource using DOM
 *     element 'el' as a container for the data (table rows typically)
 *     and datatype is used to communicate the '_type' parameter to
 *     the server.
 *   setPager(pager): Sets a Pager class object which is refreshed
 *     upon receiving new data.
 *   search(string): Invokes a search on the datasource.
 *   navigate(offset): Used to navigate to a particular offset within
 *     the dataset.
 */
Datasource = new Class(Object, {
    init: function(el, datatype) {
        // this.id = id;
        // this.document = doc || document;
        this.element = TC.elementOrId(el);
        this.searching = false;
        this.navigating = false;
        this.type = datatype;
        this.onUpdate = null;
    },
    setPager: function(pager, pager2) {
        this.pager = pager;
        if (pager2) this.pager2 = pager2
        if (pager) pager.datasource = this;
        if (pager2) pager2.datasource = this;
        if (pager) pager.render();
        if (pager2) pager2.render();
    },
    search: function(str) {
        if (this.searching) return;

        var doc = TC.getOwnerDocument(this.element);
        var args = doc.location.search;
        args = args.replace(/^\?/, '');
        args = args.replace(/&?offset=\d+/, '');
        args = 'search=' + escape(str) + (args ? '&' + args : '') + '&json=1';
        if (this.type) {
            args = args.replace(/&?_type=\w+/, '');
            args += '&_type=' + this.type;
        }

        this.searching = true;
        if (this.pager)
            this.pager.render();
        if (this.pager2)
            this.pager2.render();
        var self = this;
        TC.Client.call({
            'load': function(c,r) { self.searched(r); },
            'error': function() { alert("Error during search."); self.searched(null); },
            'method': 'POST',
            'uri': ScriptURI,
            'arguments': args
        });
    },
    searched: function(c) {
        this.searching = false;
        if (c) {
            try {
                data = eval('(' + c + ')');
                this.update(data['html']);
                if (this.pager)
                    this.pager.setState({});
                if (this.pager2)
                    this.pager2.setState({});
            } catch (e) {
                alert("Error in response: " + e);
                if (this.pager)
                    this.pager.render();
                if (this.pager2)
                    this.pager2.render();
            }
        } else {
            if (this.pager)
                this.pager.render();
            if (this.pager2)
                this.pager2.render();
        }
    },
    update: function(html) {
        if (!this.element) return;
        this.element.innerHTML = html;
        this.updated();
    },
    updated: function() {
        if (this.onUpdate) this.onUpdate(this);
    },
    navigate: function(offset) {
        if (offset == null) return;
        if (this.navigating) return;

        var doc = TC.getOwnerDocument(this.element);
        var args = doc.location.search;
        args = args.replace(/^\?/, '');
        //args = args.replace(/&?search=[^&]+/, '');
        //args = args.replace(/&?do_search=1/, '');
        args = args.replace(/&?offset=\d+/, '');
        args = 'offset=' + offset + (args ? '&' + args : '') + '&json=1';
        if (this.type) {
            args = args.replace(/&?_type=\w+/, '');
            args = args + '&_type=' + this.type;
        }

        this.navigating = true;
        if (this.pager)
            this.pager.render();
        if (this.pager2)
            this.pager2.render();
        var self = this;
        TC.Client.call({
            'load': function(c,r) { self.navigated(r); },
            'error': function() { alert("Error in request."); self.navigated(null); },
            'method': 'POST',
            'uri': ScriptURI,
            'arguments': args
        });
        return false;
    },
    navigated: function(c) {
        var data;
        this.navigating = false;
        if (c) {
            try {
                data = eval('(' + c + ')');
                this.update(data['html']);
                if (this.pager)
                    this.pager.setState(data['pager']);
                if (this.pager2)
                    this.pager2.setState(data['pager']);
            } catch (e) {
                alert("Error in response: " + e);
                if (this.pager)
                    this.pager.render();
                if (this.pager2)
                    this.pager2.render();
            }
        } else {
            if (this.pager) this.pager.render();
            if (this.pager2) this.pager2.render();
        }
    }
});
//These two lines are to translate phrases in list_tags.tmpl
//trans("The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]'?");
//trans("The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]' across all weblogs?");

/***
 * Pager class
 * Expects a 'state' object containing:
 *   offset: offset into listing (10, means first row displayed is 11)
 *   listTotal: total number of rows in dataset
 *   rows: number of rows being displayed
 *   chronological: boolean, whether listing is reverse-chronological
 *     or not.
 *  Methods:
 *    constructor(el): constructs using DOM element el as a container
 *    setDatasource(ds): used to assign a datasource object
 *    setState(state): used to update state settings
 *    previous: navigates datasource to previous page
 *    next: navigates datasource to next page
 *    first: navigates datasource to first page
 *    last: navigates datasource to last page
 *    previousOffset: calculates and returns offset for previous page
 *    nextOffset: calculates and returns offset for next page
 *    lastOffset: calculates and returns offset for 'last' page
 *    render: refreshes the pagination controls
 */
Pager = new Class(Object, {
    init: function(el) {
        this.element = TC.elementOrId(el);
        this.state = {};
    },
    setDatasource: function(ds) {
        this.datasource = ds;
        this.render();
    },
    setState: function(state) {
        this.state = state;
        this.render();
    },
    previous: function(e) {
        this.navigate(this.previousOffset());
        return TC.stopEvent(e || window.event);
    },
    navigate: function(offset) {
        if (offset == null) return;
        if (this.datasource)
            return this.datasource.navigate(offset);
        // traditional navigation...
        var doc = TC.getOwnerDocument(this.element);
        new_loc = doc.location.href;
        if (this.state.method == 'POST') {
            new_loc += '?' + this.state.return_args;
        }
        new_loc = new_loc.replace(/&?offset=\d+/, '');
        new_loc += '&offset=' + offset;
        window.location = new_loc;
        return false;
    },
    previousOffset: function() {
        if (this.state.offset > 0) {
            var offset = this.state.offset - this.state.limit;
            if (offset < 0)
                offset = 0;
            return offset;
        }
        return null;
    },
    nextOffset: function() {
        if (this.state.listTotal) {
            var listStart = (this.state.offset ? this.state.offset : 0) + 1;
            var offset = (this.state.offset ? this.state.offset : 0) + this.state.rows;
            if (offset >= this.state.listTotal) {
                offset = null;
            }
            return offset;
        }
        return null;
    },
    lastOffset: function() {
        var offset = 0;
        if (this.state.listTotal) {
            var listStart = (this.state.offset ? this.state.offset : 0) + 1;
            var listEnd = (this.state.offset ? this.state.offset : 0) + this.state.rows;
            if (listEnd >= this.state.listTotal) {
                offset = null;
            } else {
                offset = this.state.listTotal - this.state.rows;
                if (offset < listStart)
                    offset = null;
            }
            return offset;
        }
        return null;
    },
    next: function(e) {
        this.navigate(this.nextOffset());
        return TC.stopEvent(e || window.event);
    },
    first: function(e) {
        this.navigate(0);
        return TC.stopEvent(e || window.event);
    },
    last: function(e) {
        this.navigate(this.lastOffset());
        return TC.stopEvent(e || window.event);
    },
    render: function() {
        if (!this.element) return;

        /*
        This long method is concerned with creating the elements of
        the pagination control. It refreshes the controls based on
        the 'state' member of the Pager object. This control is
        typically tied to a Datasource object. So the navigation
        links of the control will influence the Datasource.
        Likewise, upon navigating the Datasource, it will invoke
        the pager to refresh when the data has been updated.

        pager.rows (number of rows shown)
        pager.listTotal (total number of rows in datasource)
        pager.offset (offset currently used)
        pager.chronological (boolean, whether the listing is chronological or not)
        */
        var html = '';
        /* TODO - this can all be replaced with a js template */
        if (this.datasource && this.datasource.navigating) {
            // TODO: change this to use a CSS class instead.
            html = "<div>" + trans('Loading...') + " <img src=\"" + StaticURI + "images/indicator.white.gif\" height=\"10\" width=\"10\" alt=\"...\" /></div>";
            this.element.innerHTML = html;
        } else if ((this.state.rows != null) && (this.state.rows > 0)) {
            this.element.innerHTML = '';
            var listStart = (this.state.offset ? this.state.offset : 0) + 1;
            var listEnd = (this.state.offset ? this.state.offset : 0) + this.state.rows;

            var doc = TC.getOwnerDocument(this.element);
            var self = this;
            // pagination control structure
            if (this.state.offset > 0) {
                var link = doc.createElement('a');
                link.href = 'javascript:void(0)';
                link.onclick = function(e) { return self.first(e) };
                link.className = 'start';
                link.innerHTML = '<em>&lt;&lt;</em>&nbsp;';
                this.element.appendChild(link);
            } else {
                var txt = doc.createElement('span');
                txt.className = 'start-disabled';
                txt.innerHTML = '<em>&lt;&lt;</em>&nbsp;';
                this.element.appendChild(txt);
            }
            if (this.previousOffset() != null) {
                var link = doc.createElement('a');
                link.href = 'javascript:void(0)';
                link.onclick = function(e) { return self.previous(e) };
                link.className = 'to-start';
                link.innerHTML = '<em>&lt;</em>&nbsp;';
                this.element.appendChild(link);
            } else {
                var txt = doc.createElement('span');
                txt.className = 'to-start-disabled';
                txt.innerHTML = '<em>&lt;</em>&nbsp;';
                this.element.appendChild(txt);
            }
            var showing = doc.createElement('span');
            showing.className = 'current-rows';
            if (this.state.listTotal)
                showing.innerHTML = trans('[_1] &ndash; [_2] of [_3]', listStart, listEnd, this.state.listTotal);
            else
                showing.innerHTML = trans('[_1] &ndash; [_2]', listStart, listEnd);
            this.element.appendChild(showing);
            if (this.nextOffset() != null) {
                var link = doc.createElement('a');
                link.href = 'javascript:void(0)';
                link.onclick = function(e) { return self.next(e) };
                link.className = 'to-end';
                link.innerHTML = '&nbsp;<em>&gt;</em>';
                this.element.appendChild(link);
            } else {
                var txt = doc.createElement('span');
                txt.className = 'to-end-disabled';
                txt.innerHTML = '&nbsp;<em>&gt;</em>';
                this.element.appendChild(txt);
            }
            if (this.lastOffset() != null) {
                var link = doc.createElement('a');
                link.href = 'javascript:void(0)';
                link.onclick = function(e) { return self.last(e) };
                link.className = 'end';
                link.innerHTML = '&nbsp;<em>&gt;&gt;</em>';
                this.element.appendChild(link);
            } else {
                var txt = doc.createElement('span');
                txt.className = 'end-disabled';
                txt.innerHTML = '&nbsp;<em>&gt;&gt;</em>';
                this.element.appendChild(txt);
            }
        } else {
            this.element.innerHTML = '';
        }
    }
});


MT = {};


if ( window.App ) {

App.singletonConstructor =
MT.App = new Class( App, {
  

    NAMESPACE: "mt",
    changed: false,
    autoSaveDelay: 15000, /* ms */


    initComponents: function() {
        arguments.callee.applySuper( this, arguments );
                    
        this.setDelegate( "navMenu", new this.constructor.NavMenu() );

        this.initFormElements();
        
        if ( this.constructor.Resizer ) {
            this.setDelegate( "resizer", new this.constructor.Resizer( this.getIndirectMethod( "resizeComplete" ) ) );
            this.setDelegateListener( "eventMouseUp", "resizer" );
            this.setDelegateListener( "eventMouseMove", "resizer" );
        }

        if ( this.constructor.DefaultValue )
            this.setDelegate( "defaultValue", new this.constructor.DefaultValue() );
        
        if ( this.constructor.TabContainer )
            this.setDelegate( "tabContainer", new this.constructor.TabContainer() );
        
        var forms = DOM.getElementsByTagAndAttribute( this.document, "form", "mt:auto-save" );
        if ( forms.length )
            window.onbeforeunload = this.getIndirectEventListener( "eventBeforeUnload" );

        for ( var i = 0; i < forms.length; i++ ) {
            var autosave = truth( forms[ i ].getAttribute( "mt:auto-save" ) );
            if ( !autosave )
                continue;

            this.form = forms[ i ];
            log('found autosave form '+i);

            var autoSaveDelay;
            if ( autoSaveDelay = parseInt( forms[ i ].getAttribute( "mt:auto-save-delay" ) ) || 0 ) {
                this.autoSaveDelay = autoSaveDelay;
                log('using auto save delay: '+this.autoSaveDelay);
            }

            var es = Array.fromPseudo(
                forms[ i ].getElementsByTagName( "input" ),
                forms[ i ].getElementsByTagName( "textarea" )
            );
            for ( var j = 0; j < es.length; j++ ) {
                if ( es[ j ].getAttribute && es[ j ].getAttribute( "mt:watch-change" ) ) {
                    log('adding watcher to '+es[ j ].name);
                    DOM.addEventListener( es[ j ], "change", this.getIndirectEventListener( "setDirty" ) );
                }
                if ( autosave && es[ j ].nodeName == "TEXTAREA" ) {
                    /* don't attach to the editor textarea in this form */
                    if ( this.editor && es[ j ].id == this.editor.textarea.element.id )
                        continue;
                    DOM.addEventListener( es[ j ], "keydown", this.getIndirectEventListener( "setDirty" ) );
                }
            }
        }

        if ( MT.App.dirty )
            this.changed = true;    
    },


    destroyObject: function() {
        this.autoSaveReq = null;
        this.autoSaveTimer = null;
        this.form = null;
        this.cpeList = null;
        arguments.callee.applySuper( this, arguments );
    },


    initFormElements: function() {
        var forms = document.getElementsByTagName( "form" );
        for( var i = 0; i < forms.length; i++ ) {
            forms[ i ].submitted = false;
            DOM.addEventListener( forms[ i ], "submit", this.getIndirectEventListener( "eventSubmit" ) );
            var tareas = forms[ i ].getElementsByTagName( "textarea" );
            var tabs = 0;
            for ( var j = 0; j < tareas.length; j++ ) {
                if ( ( tabs = tareas[ j ].getAttribute( "mt:allow-tabs" ) ) )
                    if ( truth ( tabs ) )
                        this.attachTabsToTextarea( tareas[ j ] );

                if ( tareas[ j ].getAttribute( "mt:editor" ) == "codepress" ) {
                    if ( this.constructor.CodePress.isSupported() ) {
                        var ed = new this.constructor.CodePress( tareas[ j ] );
                        if ( ed ) {
                            if ( !this.cpeList )
                                this.cpeList = [];
                            this.cpeList.push( ed );
                        }
                    }
                }
            }
        }
    },


    eventSubmit: function( event ) {
        var form = DOM.getFirstAncestorByTagName( event.target, "form", true );
        if ( !form )
            return;
            
        if ( form.getAttribute( "mt:once" ) ) {
        
            if ( form.submitted )
                return event.stop();
        
            this.toggleSubmit( form, true );
        }

        if ( this.cpeList )
            this.cpeList.forEach( function( cpe ) { cpe.onSubmit() } );

        form.submitted = true;
    },


    eventBeforeUnload: function( event ) {
        if ( this.changed ) {
            if ( this.constructor.Editor )
                return event.returnValue = Editor.strings.unsavedChanges;
            else if ( window.Editor )
                return event.returnValue = window.Editor.strings.unsavedChanges;
        }
        
        return undefined;
    },


    toggleSubmit: function( form, disable ) {
        /* sane default */
        if ( !disable )
            disable = false;
        var elements = form.getElementsByTagName( "*" );
        for( var i = 0; i < elements.length; i++ ) {
            var element = elements[ i ];
            var tagName = element.tagName.toLowerCase();
            var type = element.getAttribute( "type" );
            type = type ? type.toLowerCase() : "";
            if ( tagName == "button" || 
                (tagName == "input" && (type == "button" || type == "submit" || type == "image")) )
                element.disabled = disable;
        }
    },


    eventClick: function( event ) {
        var command = this.getMouseEventCommand( event );
        switch( command ) {
            
            case "openSelectBlog":
                app.openDialog( '__mode=dialog_select_weblog&amp;select_favorites=1&return_args='
                    + escape( event.commandElement.getAttribute( "mt:href" ) ) );
                break;

            case "goToLocation":
                this.gotoLocation( event.commandElement.getAttribute( "href" ) );
                break;
            
            case "autoSave":
                this.autoSave();
                break;

            case "setModeCodepressOn":
                this.cpeList.forEach( function( cpe ) { cpe.toggleOn( true ); } );
                break;

            case "setModeCodepressOff":
                this.cpeList.forEach( function( cpe ) { cpe.toggleOff( true ); } );
                break;

            default:
                var form = DOM.getFirstAncestorByTagName( event.target, "form", true );
                if ( !form )
                    return;

                var mode = event.target.getAttribute( "mt:mode" );
                if ( !mode && event.commandElement )
                    mode = event.commandElement.getAttribute( "mt:mode" );

                if ( mode ) {
                    log('setting __mode in this form: '+mode);
                    var elements = form.getElementsByTagName( "input" );
                    for( var i = 0; i < elements.length; i++ ) {
                        if ( elements[ i ].name == "__mode" ) {
                            log('found __mode element');
                            elements[ i ].value = mode;
                            break;
                        }
                    }
                }

                if ( command == "submit" ) {
                    event.stop();
                    var msg;
                    if ( event.commandElement && ( msg = event.commandElement.getAttribute( "mt:confirm-msg" ) ) )
                        if ( !confirm( msg ) )
                            return;
                    form.submit();
                }

                return;

        }
        return event.stop();
    },
    

    /* from blog selector transient */
    gotoUrl: function( url ) {
        if ( url )
            this.gotoLocation( url );
    },


    toggleActive: function( id ) {
        log('toggleactive:'+id);
        var div = DOM.getElement( id );
        if ( DOM.hasClassName( div, 'active' ) )
            DOM.removeClassName( div, 'active' );
        else
            DOM.addClassName( div, 'active' );
    },


    openDialog: function( params ) {
        show("dialog-container");
        /* TODO remove this cruft */
        /*  handle escape key for closing modal dialog */
        window.onkeypress = dialogKeyPress;
        openDialogUrl( ScriptURI + "?" + params );
        /* IE hack to get the dialog modal to reflow */
        if ( document.all ) {
            var container = DOM.getElement( "dialog-container" );
            DOM.addClassName( container, "hidden" );
            DOM.removeClassName( container, "hidden" );
        }
    },


    attachTabsToTextarea: function( element ) {
        DOM.addEventListener( element, "keypress", this.getIndirectMethod( "eventKeyPressAllowTabs" ) );
        DOM.addEventListener( element, "keydown", this.getIndirectMethod( "eventKeyDownAllowTabs" ) );
    },


    eventKeyPressAllowTabs: function( event ) {
        if ( event.keyCode == 9 )
            return event.stop();
    },
    
    
    eventKeyDownAllowTabs: function( event ) {
        if ( event.keyCode == 9 ) {
		    TC.setSelectionValue( ( event.target || event.srcElement ) , "\t" );
            return false;
        }
    },


    resizeComplete: function( target, xStart, yStart, x, y, width, height ) {
        
        switch ( target.id ) {
            case "textarea-enclosure":
                var es = [ "text", "text_cpe" ];
                for ( var i = 0; i < es.length; i++ ) {
                    es[ i ] = DOM.getElement( es[ i ] );
                    if ( es[ i ] )
                        DOM.setHeight( es[ i ], height );
                }
                break;

            /* expand here */
        }

    },
    
    
    autoSave: function() {
        var data = DOM.getFormData( this.form );
        data["_autosave"] = 1;

        if ( this.cpeList )
            this.cpeList.forEach( function( cpe ) { cpe.autoSave( data ) } );

        /* don't cancel a pending save */
        if ( defined( this.autoSaveReq ) )
            return;
        
        var areas = [
            DOM.getElement( "autosave-notification" ),
            DOM.getElement( "autosave-notification-top" ),
            DOM.getElement( "autosave-notification-bottom" )
        ];
        if ( areas )
            for ( var i = 0; i < areas.length; i++ )
                if ( areas[ i ] )
                    areas[ i ].innerHTML = Template.process( "autoSave", { saving: true } );

        this.autoSaveReq = TC.Client.call({
            load: this.getIndirectMethod( "autoSaveComplete" ),
            error: this.getIndirectMethod( "autoSaveError" ),
            method: 'POST',
            uri: this.form.action,
            arguments: data
        });
    },


    autoSaveComplete: function( c, r ) {
        this.autoSaveTimer = this.autoSaveReq = undefined;

        log('auto save complete '+r);
        if ( r != "true" )
            return log.error( "Error auto-saving post: "+r );
        
        var areas = [
            DOM.getElement( "autosave-notification" ),
            DOM.getElement( "autosave-notification-top" ),
            DOM.getElement( "autosave-notification-bottom" )
        ];
        var d = new Date();
        if ( areas )
            for ( var i = 0; i < areas.length; i++ )
                if ( areas[ i ] )
                    areas[ i ].innerHTML = Template.process( "autoSave", {
                        saving: false,
                        hh: d.getHours().toString().pad( 2, "0" ),
                        mm: d.getMinutes().toString().pad( 2, "0" ),
                        ss: d.getSeconds().toString().pad( 2, "0" )
                    } );
    },

    
    autoSaveError: function( c, r ) {
        this.autoSaveTimer = this.autoSaveReq = undefined;
        
        log.error( "Error auto-saving post" );
        var areas = [
            DOM.getElement( "autosave-notification" ),
            DOM.getElement( "autosave-notification-top" ),
            DOM.getElement( "autosave-notification-bottom" )
        ];
        if ( areas )
            for ( var i = 0; i < areas.length; i++ )
                if ( areas[ i ] )
                    areas[ i ].innerHTML = ''
    },


    setDirty: function( event ) {
        var autoSaveDelay = this.autoSaveDelay;
        if ( event && event.target ) {
            var form = DOM.getFirstAncestorByTagName( event.target, "form", true );
            if ( form ) {
                log('found dirty form: '+form);
                this.form = form;
                if ( autoSaveDelay = parseInt( form.getAttribute( "mt:auto-save-delay" ) ) || 0 ) {
                    this.autoSaveDelay = autoSaveDelay;
                    log('using auto save delay: '+this.autoSaveDelay);
                }
            }
        }
            
        this.changed = true;
        if ( autoSaveDelay < 1 )
            return;

        if ( defined( this.autoSaveTimer ) )
            return this.autoSaveTimer.reset();
        this.autoSaveTimer = new Timer( this.getIndirectMethod( "autoSave" ), autoSaveDelay, 1 );
    },


    clearDirty: function( event ) {
        this.changed = false;
    },

    
    insertCode: function( code ) {
        if ( this.cpeList )
            this.cpeList[ 0 ].insertCode( code );
        else if ( this.editor )
            this.editor.insertHTML( code );
        else {
            var txt = DOM.getElement( "text" );
            setSelection( txt, code );
            DOM.focus( txt );
        }
    }
    

} );

if ( window.Calendar ) {

MT.App.Calendar = new Class( Calendar, {


    open: function( data, callback ) {
        if ( data.date && data.date.length )
            data.date = data.date.replace( /^(\S+).*/, "$1" );
        arguments.callee.applySuper( this, arguments );
       
        /* reset invalid dates to the current date */
        if ( !this.dateObject )
            this.dateObject = new Date();
    },


    eventClick: function() {
        arguments.callee.applySuper( this, arguments );
        if ( this.callback )
            this.callback( this.dateObject );
    }


} );

}




MT.App.Resizer = new Class( Object, {


    dragging: false,
    element: null,
    
    xLock: false,
    yLock: false,

    xStart: null,
    yStart: null,


    init: function( callback ) {
        if ( callback )
            this.callback = callback;
    },


    destroy: function() {
        this.callback = null;
    },


    eventMouseDown: function( event ) {
        this.dragging = true;
        
        this.reset();
        
        this.target = event.attributeElement.getAttribute( "mt:target" );

        /* x or y locking */
        var lock = event.attributeElement.getAttribute( "mt:lock" );
        if ( lock ) {
            if ( lock == "x" || lock == "X" )
                this.xLock = true;
            else if ( lock == "y" || lock == "Y" )
                this.yLock = true;
        }
        
        /* clone the drag node */
        this.element = event.attributeElement.cloneNode( true );
        /* using the current mouse position, set the positon of the drag obj */
        var d = DOM.getAbsoluteCursorPosition( event );
        this.yStart = d.y;
        this.xStart = d.x;
        
        var dm = DOM.getAbsoluteDimensions( event.attributeElement );
        var adm = DOM.getAbsoluteDimensions( event.attributeElement );
        
        if ( !this.yLock )
            DOM.setTop( this.element,  d.y );
        else
            DOM.setTop( this.element, adm.absoluteTop );

        if ( !this.xLock )
            DOM.setLeft( this.element,  d.x );
        else
            DOM.setLeft( this.element, adm.absoluteLeft );

        DOM.setWidth( this.element, dm.offsetWidth );
        DOM.setHeight( this.element, dm.offsetHeight );
        
        var mask = DOM.getElement( "resize-mask" );
        mask.insertBefore( this.element, mask.firstChild );
        DOM.addClassName( this.element, "moving" );
        DOM.removeClassName( mask, "hidden" );
        /* TODO autolayout this */
        DOM.setHeight( mask, finiteInt( mask.parentNode.clientHeight ) );

        return event.stop();
    },


    eventMouseMove: function( event ) {
        if ( !this.dragging )
            return;
        
        var d = DOM.getAbsoluteCursorPosition( event );
        
        if ( !this.yLock )
            DOM.setTop( this.element, d.y );

        if ( !this.xLock )
            DOM.setLeft( this.element, d.x );

        return event.stop();
    },


    eventMouseUp: function( event ) {
        if ( !this.dragging )
            return;
       
        this.dragging = false;
        var d = DOM.getAbsoluteCursorPosition( event );
            
        DOM.addClassName( DOM.getElement( "resize-mask" ), "hidden" );
        
        /* cleanup */
        if ( this.element && this.element.parentNode )
            this.element.parentNode.removeChild( this.element );

        var target = DOM.getElement( this.target );
        if ( !target )
            return this.reset();

        var targetDim = DOM.getDimensions( target );
        
        var height = d.y - targetDim.offsetTop;
        if ( !this.yLock ) {
            var hMin = target.getAttribute( "mt:min-height" );
            if ( hMin )
                if ( height < parseInt( hMin ) )
                    height = parseInt( hMin );
        
            var hMax = target.getAttribute( "mt:max-height" );
            if ( hMax )
                if ( height > parseInt( hMax ) )
                    height = parseInt( hMax );

            log('new height: '+height);
        }

        var width = d.x - targetDim.offsetLeft;
        if ( !this.xLock ) {
            var wMin = target.getAttribute( "mt:min-width" );
            if ( wMin )
                if ( width < parseInt( wMin ) )
                    width = parseInt( wMin );
        
            var wMax = target.getAttribute( "mt:max-width" );
            if ( wMax )
                if ( width > parseInt( wMax ) )
                    width = parseInt( wMax );

            log('new width: '+width);
        }
       
        /* give the callback a chance to stop us from setting this height and width */
        if ( this.callback && ( this.callback( target, this.xStart, this.yStart, d.x, d.y, width, height ) ) )
            return this.reset();
        
        if ( !this.yLock )
            DOM.setHeight( target, height );

        if ( !this.xLock )
            DOM.setWidth( target, width );

        var hUpdate = target.getAttribute( "mt:update-field-height" );
        if ( hUpdate && ( hUpdate = DOM.getElement( hUpdate ) ) )
            hUpdate.value = height;
        
        var wUpdate = target.getAttribute( "mt:update-field-width" );
        if ( wUpdate && ( wUpdate = DOM.getElement( wUpdate ) ) )
            wUpdate.value = width;

        this.reset();
    },


    reset: function() {
        /* remove left over drag obj, if any */
        if ( this.element && this.element.parentNode )
            this.element.parentNode.removeChild( this.element );
        
        this.xStart = this.yStart = this.element = this.target = null;
        this.xLock = this.yLock = false;
    }


} );


MT.App.DefaultValue = new Class( Object, {


    init: function() {
        var es = DOM.getElementsByAttributeAndValue( document, "mt:delegate", "default-value" );
        for ( var i = 0; i < es.length; i++ ) {
            var val = es[ i ].getAttribute( "mt:default" );
            if ( !val )
                continue;
            
            if ( es[ i ].value != val )
                DOM.removeClassName( es[ i ], "input-hint" );
        }
    },


    eventFocus: function( event ) {
        var element = event.attributeElement;
        var val = element.getAttribute( "mt:default" );
        if ( !val )
            return;

        DOM.removeClassName( element, "input-hint" );
        
        if ( element.value == val )
            element.value = "";
    },


    eventBlur: function( event ) {
        var element = event.attributeElement;
        var val = element.getAttribute( "mt:default" );
        if ( !val )
            return;
        
        var opts = {};
        /* simple options for now */
        var opt = element.getAttribute( "mt:delegate-options" );
        if ( opt && opt == "-class" ) {
            opts.noclassChange = true;
        }
        
        if ( element.value != "" )
            return;
        
        element.value = val;
        if ( opts.noclassChange )
            return;

        DOM.addClassName( element, "input-hint" );
    },
    
    
    /* hate on IE */
    eventFocusIn: function( event ) {
        return this.eventFocus( event );
    },
    

    eventFocusOut: function( event ) {
        this.eventBlur( event );
    },


    eventSubmit: function( event ) {
        return event.stop();
    }
    
    
} );


MT.App.TabContainer = new Class( Object, {

    init: function() {
        var es = DOM.getElementsByAttributeAndValue( document, "mt:delegate", "tab-container" );
        var t;
        for ( var i = 0; i < es.length; i++ ) {
            if ( t = es[ i ].getAttribute( "mt:selected-tab" ) ) {
                this.selectTab( es[ i ], t );
                continue;
            }

            if ( t = es[ i ].getAttribute( "mt:persist-tab-cookie" ) ) {
                log( 'found persisted tab setting: '+t);
                t = Cookie.fetch( t );
                if ( t && t.value && t.value != "" ) {
                    log( 'cookie: '+t.value);
                    this.selectTab( es[ i ], t.value );
                }
            }
        }
    },


    eventClick: function( event ) {
        var command = app.getMouseEventCommand( event );
        if (!event.commandElement) return;
        var tab = event.commandElement.getAttribute( "mt:tab" );
        if ( tab && command != "selectTab" )
            this.selectTab( event.attributeElement, tab );

        switch( command ) {
            
            case "setEditorContent":
                event.stop();
                app.setEditor( "content" );
                break;

            case "setEditorExtended":
                event.stop();
                app.setEditor( "extended" );
                break;
            
            case "selectTab":
                if ( !tab )
                    tab = event.commandElement.getAttribute( "mt:select-tab" );

                if ( tab ) {
                    this.selectTab( event.attributeElement, tab );
                    var cookie = event.attributeElement.getAttribute( "mt:persist-tab-cookie" );
                    if ( cookie ) {
                        var d = new Date();
                        d.setYear( d.getYear() + 1902 ); /* two years */
                        Cookie.bake( cookie, tab, undefined, undefined, d );
                    }
                }
                
                event.stop();
                break;

        }
    },


    selectTab: function( element, name ) {
        log('select tab '+name);
        var es = DOM.getElementsByAttribute( element, "mt:tab" );
        for ( var i = 0; i < es.length; i++ ) {
            if ( es[ i ].getAttribute( "mt:tab" ) == name )
                DOM.addClassName( es[ i ], "selected-tab" );
            else
                DOM.removeClassName( es[ i ], "selected-tab" );
        }

        /* look for tab contents elements matching 'name' */
        es = DOM.getElementsByAttribute( element, "mt:tab-content" );
        for ( var i = 0; i < es.length; i++ ) {
            /* then hide everything except the tab content we want to show */
            if ( es[ i ].getAttribute( "mt:tab-content" ) == name )
                DOM.removeClassName( es[ i ], "hidden" );
            else
                DOM.addClassName( es[ i ], "hidden" );
        }
    }


} );


MT.App.NavMenu = new Class( Object, {

    opened: false,
    outTimer: null,
    inTimer: null,
    el: null,
    al: null,


    eventMouseOver: function( event ) {
        var el = DOM.getFirstAncestorByClassName( event.target, "nav-menu", true );
        if ( !el )
            return;
        
        /* if they moused in, but moved to a new menu, reset the in timer */
        if ( this.inTimer && this.el && this.el !== el )
            this.inTimer.stop();
        
        this.al = event.attributeElement;
        this.el = el;

        if ( this.outTimer )
            this.outTimer.stop();

        if ( this.al.getAttribute( "mt:is-opened" ) == "1" )
            return this.openMenu();
       
        var delay = event.attributeElement.getAttribute( "mt:nav-delayed-open" ); // ms

        if ( delay ) {
            delay = parseInt( delay );
            /* no hover in? */
            if ( delay < 0 )
                return;
            if ( this.inTimer )
                this.inTimer.stop();
            this.inTimer = new Timer( this.getIndirectMethod( "openMenu" ), delay, 1 );
            return;
        } else
            this.openMenu();
    },


    eventMouseOut: function( event ) {
        var el = DOM.getFirstAncestorByClassName( event.target, "nav-menu", true );
        if ( !el )
            return;

        this.al = event.attributeElement;
        this.el = el;

        var delay = event.attributeElement.getAttribute( "mt:nav-delayed-close" ); // ms
        if ( delay ) {
            delay = parseInt( delay );
            /* no hover out? */
            if ( delay < 0 )
                return;
            if ( this.outTimer )
                this.outTimer.stop();
            this.outTimer = new Timer( this.getIndirectMethod( "closeMenu" ), delay, 1 );
        } else
            this.closeMenu();
    },


    eventClick: function( event ) {
        var command = app.getMouseEventCommand( event );
        if ( !command ) {
            if ( this.inTimer )
                this.inTimer.stop();
            return;
        }

        var el = DOM.getFirstAncestorByClassName( event.target, "nav-menu", true );
        if ( !el )
            return;
        this.al = event.attributeElement;

        if ( command == "openMenu" ) {
            event.stop();
            this.openMenu( el );
        }
    },


    openMenu: function() {
        if ( !this.el )
            return;

        if ( this.outTimer )
            this.outTimer.stop();
        if ( this.inTimer )
            this.inTimer.stop();
        
        var es = DOM.getElementsByClassName( window.document, "show-nav" );
        for ( var i = 0; i < es.length; i++ )
            if ( es[ i ] !== this.el )
                DOM.removeClassName( es[ i ], "show-nav" );

        DOM.addClassName( this.el, "show-nav" );

        DOM.setElementAttribute( this.al, "mt:is-opened", "1" );

        /* actually hides select boxes, not the dropdown */
        hideDropDown();
        this.inTimer = null;
        this.outTimer = null;
    },


    closeMenu: function() {
        if ( this.al ) {
            var es = DOM.getElementsByClassName( window.document, "show-nav" );
            for ( var i = 0; i < es.length; i++ )
                DOM.removeClassName( es[ i ], "show-nav" );
        }
        
        if ( this.inTimer )
            this.inTimer.stop();

        DOM.setElementAttribute( this.al, "mt:is-opened", "0" );

        /* actually shows select boxes, not the dropdown */
        showDropDown();
        this.outTimer = null;
        this.inTimer = null;
    }


} );


MT.App.CodePress = new Class( Object, {

    init: function( textarea ) {
        var iframe = this.iframe = document.createElement('iframe');
        this.textarea = textarea;

        /* XXX do we need this id swapping */
        var id = this.textarea.id;
        this.textarea.id = id + '_cpe';
        this.iframe.id = id;

        this.textarea.disabled = true;
        this.textarea.style.overflow = 'hidden';
        iframe.style.height = this.textarea.clientHeight +'px';
        iframe.style.width = this.textarea.clientWidth +'px';
        this.textarea.style.overflow = 'auto';
        iframe.style.border = 'none';
        iframe.frameBorder = 0;
        iframe.style.visibility = 'hidden';
        iframe.style.position = 'absolute';

        this.options = this.textarea.getAttribute( "mt:editor-options" );
        
        this.textarea.parentNode.insertBefore( this.iframe, this.textarea );
        
        log('textarea attached to editor: codepress');
        this.edit();
    },


    eventIframeLoaded: function( event ) {
        this.editor = this.iframe.contentWindow.CodePress;
        this.editor.body = this.iframe.contentWindow.document.getElementsByTagName( 'body' )[0];
        if ( this.editor.body.spellcheck )
            this.editor.body.spellcheck = false;
        this.editor.setCode( this.textarea.value );
        this.setOptions();
        this.editor.syntaxHighlight( 'init' );
        this.textarea.style.display = 'none';
        this.iframe.style.position = 'static';
        this.iframe.style.visibility = 'visible';
        this.iframe.style.display = 'inline';
        this.editor.onModified = app.getIndirectMethod( "setDirty" );
        /* match the textarea's tab index */
        if ( this.textarea[ "tabIndex" ] )
            this.iframe.setAttribute( "tabIndex", this.textarea[ "tabIndex" ] );
        DOM.addClassName( document.body, "codepress-editor-enabled codepress-editor-on" );
        var t = Cookie.fetch( "codepressoff" );
        if ( t && t.value && t.value != "" ) {
            log( 'codepress editor off: '+t.value);
            this.toggleOff();
        }
    },


    // obj can by a textarea id or a string (code)
    edit: function( obj, language ) {
        if ( obj ) {
            var el = DOM.getElement( obj );
            this.textarea.value = ( el ) ? el.value : obj;
        }
        if ( !this.textarea.disabled )
            return;
        this.language = language ? language : this.getLanguage();
        this.iframe.src = window.StaticURI + 'codepress/index.html?language=' + this.language + '&r=' + (new Date).getTime();
        DOM.addEventListener( this.iframe, "load", this.eventIframeLoaded.bind( this ) );
    },


    getLanguage: function() {
        var languages = MT.App.CodePress.languages;
        for ( lang in languages ) {
            if ( !languages.hasOwnProperty( lang ) )
                continue;
            if ( this.options.match( 'lang:' + lang ) ) {
                log('matched code language: '+languages[ lang ] );
                return lang;
            }
        }
        log('defaulting to code language: generic');
        return 'generic';
    },

    
    setOptions: function() {
        if ( this.options.match( 'readonly:on' ) )
            this.toggleReadOnly();
        
        if ( this.options.match( 'autocomplete:off' ) )
            this.toggleAutoComplete();
        
        if ( this.options.match( 'linenumbers:off' ) )
            this.toggleLineNumbers();
    },


    toString: function() {
        return this.getCode();
    },


    onSubmit: function() {
        if ( this.textarea.disabled )
            this.toggleOff();
    },


    autoSave: function( data ) {
        if ( !this.textarea.disabled )
            return;
        log('setting autosave data on: '+this.textarea.name);
        data[ this.textarea.name ] = this.editor.getCode();
    },

    
    getCode: function() {
        return this.textarea.disabled ? this.editor.getCode() : this.textarea.value;
    },


    setCode: function(code) {
        this.textarea.disabled ? this.editor.setCode( code ) : this.textarea.value = code;
    },


    toggleAutoComplete: function() {
        this.editor.autocomplete = this.editor.autocomplete ? false : true;
    },

    
    toggleReadOnly: function() {
        this.textarea.readOnly = ( this.textarea.readOnly ) ? false : true;
        // prevent exception on FF + iframe with display:none
        if ( this.iframe.style.display != 'none' )
            this.editor.readOnly( this.textarea.readOnly ? true : false );
    },

    
    toggleLineNumbers: function() {
        var cn = this.editor.body.className;
        this.editor.body.className = ( cn == '' || cn == 'show-line-numbers' )
            ? 'hide-line-numbers' : 'show-line-numbers';
    },
 
   
    toggleEditor: function() {
        if ( this.textarea.disabled )
            this.toggleOff( true );
        else
            this.toggleOn( true );
    },


    toggleOff: function( cookie ) {
        if ( !this.textarea.disabled )
            return;
        this.textarea.value = this.getCode();
        this.textarea.disabled = false;
        this.iframe.style.display = 'none';
        this.textarea.style.display = 'inline';
        DOM.removeClassName( document.body, "codepress-editor-on" );
        if ( cookie ) {
            var d = new Date();
            d.setYear( d.getYear() + 1902 ); /* two years */
            Cookie.bake( "codepressoff", 1, undefined, undefined, d );
        }
    },
    
    
    toggleOn: function( cookie ) {
        if ( this.textarea.disabled )
            return;
        this.textarea.disabled = true;
        this.setCode( this.textarea.value );
        this.editor.syntaxHighlight('init');
        this.iframe.style.display = 'inline';
        this.textarea.style.display = 'none';
        DOM.addClassName( document.body, "codepress-editor-on" );
        if ( cookie )
            Cookie.remove( "codepressoff" );
    },


    insertCode: function( code, putCursorBefore ) {
        if ( this.textarea.disabled ) {
            var edit_node = this.editor.body.getElementsByTagName('pre')[0];
            if (!edit_node) edit_node = this.editor.body;
            DOM.focus(edit_node);
            this.editor.insertCode( code, putCursorBefore );
		 	this.editor.syntaxHighlight( this.getLanguage() );
        } else {
		    TC.setSelectionValue( this.textarea, code );
            DOM.focus( this.textarea );
        }
    }


} );

extend( MT.App.CodePress, {
   

    isSupported: function() {
        return ( navigator.userAgent.toLowerCase().match(/webkit/) ) ? false : true;
    },


    languages: {
        csharp : 'C#', 
        css : 'CSS', 
        generic : 'Generic',
        html : 'HTML',
        java : 'Java', 
        javascript : 'JavaScript', 
        perl : 'Perl', 
        ruby : 'Ruby',  
        php : 'PHP', 
        text : 'Text', 
        sql : 'SQL',
        vbscript : 'VBScript',
        mt: 'Movable Type'
    }

} );

} /* if window.App */



function showMsg(message, id, type, rebuild, blogID) {
    if (getByID(id)) {
        msg = getByID(id);
        msg.style.display = 'block';
    } else {
        var msg = document.createElement("div");
        msg.setAttribute("id", id);
        DOM.addClassName(msg, 'msg');
        DOM.addClassName(msg, 'msg-'+type);
    }
    msg.innerHTML = "<a href=\"javascript:void(0)\" onclick=\"javascript:hide('"+id+"');\" class=\"close-me\"><span>close</span></a>"+message;
    if (rebuild == 'all')
        msg.innerHTML += ' ' + trans('[_1]Publish[_2] your site to see these changes take effect.', '<a href="javascript:void(0);" class="rebuild-link" onclick="doRebuild(\''+blogID+'\');">', '</a>');
    if (rebuild == 'index')
        msg.innerHTML += ' ' + trans('[_1]Publish[_2] your site to see these changes take effect.', '<a href="javascript:void(0);" class="rebuild-link" onclick="doRebuild(\''+blogID+'\', prompt=\'index\');">', '</a>');
    getByID('msg-block').appendChild(msg);
}

function hideDropDown() { // hides SELECT lists under the nav on IE6
    if((/MSIE/.test(navigator.userAgent)) && parseInt(navigator.appVersion)==4) {
        var dd = document.getElementsByTagName('select');
    	for (var i=0; i<dd.length; i++) {
    		dd[i].style.visibility='hidden';
    	}
    }
	return;
}

function showDropDown() {
    if ((/MSIE/.test(navigator.userAgent)) && parseInt(navigator.appVersion)==4) {
        var dd = document.getElementsByTagName('select');
    	for (var i=0; i<dd.length; i++) {
    		dd[i].style.visibility='visible';
    	}
    }
	return;
}

function setBarPosition(radio) {
    var mode = radio.value ? radio.value.toLowerCase() : radio;
    var c = TC.elementOrId('container');
    var s = "show-actions-bar-";
    if (mode == 'bottom') {
        TC.removeClassName(c, s + "top");
        TC.addClassName(c, s + "bottom");
    } else if (mode == 'both') {
        TC.addClassName(c, s + "top");
        TC.addClassName(c, s + "bottom");
    } else if (mode == 'top') {
        TC.addClassName(c, s + "top");
        TC.removeClassName(c, s + "bottom");
    }
}
