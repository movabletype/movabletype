;(function (window) {
  if (typeof MT.Util === 'undefined') {
    MT.Util = {};
  }

  MT.Util.getByID = function (n, d) {
    if (!d) d = document;
    if (d.getElementById)
        return d.getElementById(n);
    else if (d.all)
        return d.all[n];
  };

  MT.Util.dirify_table = {
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

  MT.Util.dirify = function (s) {
      s = s.replace(/<[^>]+>/g, '');
      for (var p in MT.Util.dirify_table)
          if (s.indexOf(p) != -1)
              s = s.replace(new RegExp(p, "g"), MT.Util.dirify_table[p]);
      s = s.toLowerCase();
      s = s.replace(/&[^;\s]+;/g, '');
      s = s.replace(/[^-a-z0-9_ ]/g, '');
      s = s.replace(/\s+/g, '_');
      s = s.replace(/_+$/, '');
      s = s.replace(/_+/g, '_');
      return s;
  }

  MT.Util.countMarked = function (f, nameRestrict) {
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
  };

  MT.Util.doForMarkedInThisWindow = function (f, singular, plural, nameRestrict,
                                    mode, args, phrase) {
      var count = MT.Util.countMarked(f, nameRestrict);
      if (!count) {
          alert(trans('You did not select any [_1] [_2].', plural, phrase));
          return false;
      }
      f.target = f.target || "_top";
      if (f.elements['itemset_action_input'])
          f.elements['itemset_action_input'].value = '';
      f.elements["__mode"].value = mode;
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
          }
          for (var arg in args) {
              if (f.elements[arg]) f.elements[arg].value = args[arg];
              if (arg == 'search' && f.elements['return_args'].value) {
                  f.elements['return_args'].value += '&do_search=1&search='+encodeURIComponent(args[arg]);
              }
          }
          if (opt && opt['dialog']) {
              var q = jQuery(f).serialize();
              var url = ScriptURI+'?'+q;
              jQuery.fn.mtModal.open(url);
              return false;
          }
      }
      f.submit();
  };

  MT.Util.doRemoveItems = function (f, singular, plural, nameRestrict, args, params) {
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
          return MT.Util.doForMarkedInThisWindow(f, singular, plural, nameRestrict, mode, args);
      } else {
          return false;
      }
  };

  MT.Util.doPluginAction = function (f, plural, args, phrase) {
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
    args['action_name'] = action;
    return MT.Util.doForMarkedInThisWindow(f, '', plural, 'id', 'itemset_action', args, phrase);
  };

  MT.Util.getOwnerDocument = function (element) {
    if( !element )
      return document;
    if( element.ownerDocument )
      return element.ownerDocument;
    if( element.getElementById )
      return element
    return document;
  };

  MT.Util.getComputedStyle = function (element) {
    if( element.currentStyle )
      return element.currentStyle;
    var style = {};
    var owner = MT.Util.getOwnerDocument( element );
    if( owner && owner.defaultView && owner.defaultView.getComputedStyle ) {
      try {
        style = owner.defaultView.getComputedStyle( e, null );
      } catch( e ) {}
    }
    return style;
  };

  MT.Util.getElementsByTagAndClassName = function ( tagName, className, root ) {
  	root = MT.Util.elementOrId( root );
  	if( !root )
  		root = document;
  	var allElements = root.getElementsByTagName( tagName );
  	var elements = [];
  	for( var i = 0; i < allElements.length; i++ )
  	{
  		var element = allElements[ i ];
  		if( !element )
  			continue;
      if ( $(element).hasClass(className) )
    		elements[ elements.length ] = element;
  	}
  	return elements;
  }

  MT.Util.elementOrId = function( element ) {
  	if( !element )
  		return null;
  	if( typeof element == "string" )
  		element = document.getElementById( element );
  	return element;
  }

  MT.Util.isValidDate = function (ts) {
    if (!ts) return false;

    var matched = ts.match(/^(\d{4})-?(\d{2})-?(\d{2})\s*(\d{2}):?(\d{2})(?::?(\d{2}))?$/);
    if (!matched) return false;

    var year = matched[1];
    var month = matched[2];
    var day = matched[3];
    var hour = matched[4];
    var minute = matched[5];
    var second = matched[6] || 0;

    if (second > 59 || second < 0) return false;
    if (minute > 59 || minute < 0) return false;
    if (hour > 23 || hour < 0) return false;
    if (month > 12 || month < 1) return false;
    if (day < 1) return false;
    if (MT.Util.daysIn(month, year) < day && !MT.Util.leapDay(year, month, day)) return false;

    return true;
  };

  MT.Util._daysIn = [ -1, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];

  MT.Util.daysIn = function ( month, year ) {
    if ( month != 2 ) return MT.Util._daysIn[month];
    return year % 4 == 0 && ( year % 100 != 0 || year % 400 == 0 )
      ? 29
      : 28;
  };

  MT.Util.leapDay = function ( year, month, day ) {
    return month == 2
      && day == 29
      && ( year % 4 == 0 )
      && ( year % 100 != 0 || year % 400 == 0 );
  };

  MT.Util.isMobileView = function () {
      return jQuery(window.top).width() < 768;
  };

  // copy from mt-static/js/editor/editor.js
  MT.Util.isIos = function () {
      return window.navigator.userAgent.match(/i(Phone|Pad|Pod)/);
  };

  // copy from Chart API
  MT.Util.isSmartphone = function () {
      var userAgent = window.navigator ? window.navigator.userAgent : '';
      return (/android|iphone|ipod|ipad/i).test(userAgent);
  };

  // DOM change is not applied until scrolling .modal-body on iOS
  MT.Util.refreshModalBodyOnIos = function () {
      if (!MT.Util.isIos()) {
        return;
      }
      var modalBody = jQuery('.modal-body').get(0);
      if (!modalBody) {
        return;
      }
      modalBody.scrollBy(0, 1);
      modalBody.scrollBy(0, -1);
  };



})(window);
