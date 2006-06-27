/*
Copyright 2001-2006 Six Apart. This code cannot be redistributed without
permission from www.sixapart.com.  For more information, consult your
Movable Type license.

$Id$
*/

var ScriptURI;
var ScriptBaseURI;
var StaticURI;
var HelpBaseURI;
var Lexicon = {
    '_BLOG_CONFIG_MODE_BASIC': 'Basic Settings',
    '_BLOG_CONFIG_MODE_DETAIL': 'Detailed Settings'
};
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
    window.open(ScriptURI + '?__mode=rebuild_confirm&blog_id=' + blogID + '&' + otherParams, 'rebuild', 'width=400,height=250,resizable=yes');
}

function openManual (section, page) {
    window.open(HelpBaseURI + 'help/' + section + '/' + page + '.html' , '_blank', 
'width=800,height=600,scrollbars=yes,status=yes,resizable=yes,toolbar=yes,location=yes,menubar=yes');
    return false;
}

function gatherMarked (f, nameRestrict) {
    var url = '';
    var e = f.id;
    if (!e) return;
    if (e.value && e.checked)
        url += '&id=' + e.value;
    else
	if (nameRestrict) {
	    for (i=0; i<e.length; i++)
        	if (e[i].checked && (e[i].name == nameRestrict))
                    url += '&id=' + e[i].value;
	} else {
	    for (i=0; i<e.length; i++)
        	if (e[i].checked)
                    url += '&id=' + e[i].value;
	}
   return url;
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

function doRemoveItems (f, singular, plural, nameRestrict, args) {
    var count = countMarked(f, nameRestrict);
    if (!count) {
        alert(trans('You did not select any [_1] to delete.', plural));
        return false;
    }
    var toRemove = "";
    for (var i in f.childNodes) {
        if (f.childNodes[i].name == '_type') {
            toRemove = f.childNodes[i].value;
            break;
        }
    }
    if(toRemove == 'author') {
        singularMessage = trans('Deleting an author is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire an author or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete this author?');
        pluralMessage = trans('Deleting an author is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire an author or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete the [_1] selected authors?');
    } else {
        singularMessage = trans('Are you sure you want to delete this [_1]?');
        pluralMessage = trans('Are you sure you want to delete the [_1] selected [_2]?');
    } 

    if (confirm(count == 1 ? trans(singularMessage, singular) : trans(pluralMessage, count, plural))) {
        return doForMarkedInThisWindow(f, singular, plural, nameRestrict, 'delete', args, trans('to delete'));
    }
}

function doForMarkedInThisWindow (f, singular, plural, nameRestrict, 
                                  mode, args, phrase) {
    var count = countMarked(f, nameRestrict);
    if (!count) {
        alert(trans('You did not select any [_1] [_2].', plural, phrase));
        return false;
    }
    if (f.elements['itemset_action_input'])
        f.elements['itemset_action_input'].value = '';
    if (args) {
        var opt;
        var input;
        if (opt = itemset_options[args['action_name']]) {
            if (opt['input']) {
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
        }
        for (var arg in args) {
            if (f.elements[arg]) f.elements[arg].value = args[arg];
        }
    }
    f.elements["__mode"].value = mode;
    f.submit();
}

function submitFormConfirm(f, mode, message) {
    if (confirm(message)) {
        if (f.elements["__mode"] && mode)
            f.elements["__mode"].value = mode;
        f.submit();
    }
}

function submitForm(f, mode) {
    if (f.elements["__mode"] && mode)
        f.elements["__mode"].value = mode;
    f.submit();
}

function doPluginAction(f, plural, phrase) {
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
        'handle_junk', {}, trans('to mark as junk'));
}

function doItemsAreNotJunk (f, type, plural, nameRestrict) {
    doForMarkedInThisWindow(f, type, plural, nameRestrict,
        'not_junk', {}, trans('to remove "junk" status'));
}

function doRemoveItem (f, id, type) {
    var url = ScriptURI;
    url += '?__mode=delete_confirm&_type=' + type + '&id=' + id + '&return_args=' + (f ? escape(f['return_args'].value) : '');
    window.open(url, 'confirm_delete', 'width=370,height=250,scrollbars=yes');
}

function getByID (n) {
    var d = window.document;
    if (d.getElementById)
        return d.getElementById(n);
    else if (d.all)
        return d.all[n];
}

var theForm;
var requestSubmitted = false;
function disableButton (e) {
    if (!requestSubmitted) {
        e.disabled = true;
        theForm = e.form;
        requestSubmitted = true;
        setTimeout('submitIt()', 250);
    } else {
        return false;
    }
}

function submitIt () {
    theForm.submit();
    return false;
}

function checkAndSubmit (f) {
    if (requestSubmitted == true) {
        return false;
    } else {
        requestSubmitted = true;
        f.submit();
        return false;
    }
}

var canFormat = 0;
if (document.selection ||
    (typeof(document.createElement("textarea")["setSelectionRange"]) != "undefined"))
    canFormat = 1;
var ua = navigator.userAgent;

function getSelected (e) {
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

function setSelection (e, v) {
    if (document.selection) {
        e.focus();
        var range = document.selection.createRange();
        range.text = v;
    } else {
        var length = e.textLength;
        var start = e.selectionStart;
        var end = e.selectionEnd;
        if (end == 1 || end == 2 && length != undefined) end = length;
        e.value = e.value.substring(0, start) + v + e.value.substr(end, length);
        e.selectionStart = start + v.length;
        e.selectionEnd = start + v.length;
    }
    e.focus();
}

function formatStr (e, v) {
    if (!canFormat) return;
    var str = getSelected(e);
    if (str) setSelection(e, '<' + v + '>' + str + '</' + v + '>');
    return false;
}

function mtShortCuts(e) {
    e = e || event;
    if (!e || (!e.ctrlKey)) return;
    /* we have to add 64 to keyCode since the user hit a control key */
    var code = (e.keyCode) ? (e.keyCode + 64) :
               ((e.which) ? e.which : 0);
    var ch = String.fromCharCode(code);
    el = e.target || e.srcElement;
    if (el.nodeType == 3) el = el.parentNode; // Safari bug
    if (ch == 'A') insertLink(el, false);
    if (ch == 'B') formatStr(el, 'strong');
    if (ch == 'I') formatStr(el, 'em');
    if (ch == 'U') formatStr(el, 'u');
}

function insertLink (e, isMail) {
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

function doCheckAll (f, v) {
    var e = f.id;
    if (e.value)
        e.checked = v;
    else
        for (i=0; i<e.length; i++) 
            e[i].checked = v;
}

function doCheckboxCheckAll (t) {
	var v = t.checked;
    var e = t.form.id;
    if (e.value)
        e.checked = v;
    else
        for (i=0; i<e.length; i++) 
            e[i].checked = v;
}

function execFilter(f) {
    if (f['filter-mode'].selectedIndex == 0) {  // no filter
        getByID('filter').value = '';
        getByID('filter_val').value = '';
        getByID('filter-form').submit();
    } else {
        var filter_col = f['filter-col'].options[f['filter-col'].selectedIndex].value;
        var opts = f[filter_col+'-val'].options;
        if (opts) {
            filter_val = opts[f[filter_col+'-val'].selectedIndex].value;
        } else if (f[filter_col+'-val'].value) {
            filter_val = f[filter_col+'-val'].value;
        }
        getByID('filter').value = filter_col;
        getByID('filter_val').value = filter_val;
        getByID('filter-form').submit();
    }
    return false;
}

function setFilterVal(value) {
    var f = getByID('filter-select');
    if (f['filter-mode'].selectedIndex == 0) return;
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

function toggleActive(el) {
	var opt = TC.elementOrId(el);
	if (opt) {
		if (TC.hasClassName(opt, 'active'))
			TC.removeClassName(opt, 'active');
		else
			TC.addClassName(opt, 'active');
	}
	return false;
}

function tabToggle(selectedTab, tabs) {
    for (var i = 0; i < tabs.length; i++) {
        var tabObject = getByID(tabs[i] + '-tab');
        var contentObject = getByID(tabs[i] + '-panel');
            
        if (tabObject && contentObject) {
            if (tabs[i] == selectedTab) {
                tabObject.className = 'yah';
                contentObject.style.display = 'block';
            } else {
                tabObject.className = 'default';
                contentObject.style.display = 'none';
            }
        }
    }
	return false;
}

function show(id) {
    var el = getByID(id);
    if (!el) return;
    el.style.display = 'block';
}

function hide(id) {
    var el = getByID(id);
    if (!el) return;
    el.style.display = 'none';
}

function toggleSubPrefs(c) {
	var div = TC.elementOrId((c.name || c.id)+"-prefs") || TC.elementOrId((c.name || c.id)+'_prefs');
	if (div) {
		if (c.type) {
			var on = c.type == 'checkbox' ? c.checked : c.value != 0;
			div.style.display = on ? "block" : "none";
		} else {
			var on = div.style.display && div.style.display != "none";
			div.style.display = on ? "none" : "block";
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
            str = str.replace(new RegExp('\\[_' + i + '\\]', 'g'), arguments[i]);
            var re = new RegExp('\\[quant,_' + i + ',(.+?)(?:,(.+?))?\\]');
            var matches;
            while (matches = str.match(re)) {
                if (arguments[i] > 1)
                    str = str.replace(re, arguments[i] + ' ' +
                        ((typeof(matches[2]) != 'undefined') > 2 ? matches[2]
                                                                 : matches[1]
                                                                   + 's'));
                else
                    str = str.replace(re, arguments[i] + ' ' + matches[1]);
            }
        }
    return str;
}

function expandEditor( id, mode ) {
    var height_change;
    var min_height = 66;
    
    if ( mode == 'expand' ) {
        height_change = 32;
    } else if ( mode == 'contract' )  {
        height_change = -32;
    }

    var element = document.getElementById( id );
    var element_height = document.getElementById( id + '_height' );

    if ( element && element_height ) {
        var new_height;
        if (element_height)
            new_height = parseInt(element_height.value) + height_change;
        else
            new_height = parseInt(element.style.height) + height_change;
        if ( new_height >= min_height ) {
            if (element_height)
                element_height.value = new_height;
            element.style.height = new_height + 'px';
        } else {
            if (element_height)
                element_height.value = min_height;
            element.style.height = min_height + 'px';
        }
    }

    return false;
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
    s = s.replace(/\s+/g, '_');
    return s;
}

function setElementValue(domID, newVal) {
    getByID(domID).value = newVal;
}
