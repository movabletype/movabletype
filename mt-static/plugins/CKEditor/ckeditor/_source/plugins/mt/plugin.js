/*
 * Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
 * This program is distributed under the terms of the
 * GNU General Public License, version 2.
 *
 * $Id$
 */
;(function($) {

function openDialog(mode, param) {
	$.fn.mtDialog.open(
		ScriptURI + '?' + '__mode=' + mode + '&amp;' + param
	);
}

function getSelectedAnchor(ed) {
    var selection = ed.getSelection();
    var firstElement = selection.getStartElement();
    var path = new CKEDITOR.dom.elementPath(firstElement);
    var anchor = path.lastElement && path.lastElement.getAscendant('a', true);
    return anchor ? anchor.$ : null;
}

function addMtButton(name, opts) {
    var ed = this;

    var modes = opts['modes'] || {};
    var funcs = opts['clickFunctions'];
    if (opts['clickFunctions']) {
        opts['click'] = function() {
            var mode = ed.mode;
            var func = funcs[mode];
            if (typeof(func) == 'string') {
                ed.mtProxies[mode].execCommand(func);
            }
            else {
                func.apply(ed, arguments);
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
            if (mode == 'wysiwyg') {
                return true;
            }
            else if (! modes[mode]) {
                return false;
            }

            if (funcs) {
                var func = funcs[ed.mtEditorStatus['mode']];
                if (typeof(func) == 'string') {
                    return ed.mtProxies['source'].isSupported(func);
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


    if (! opts['command']) {
        ed.addCommand(name, {
            modes: modes,
            exec: opts['click']
        });
        delete(opts['click']);

        opts['command'] = name;
    }
    return ed.ui.addButton(name, opts);
};

CKEDITOR.plugins.add('mt', {

lang : [ 'en' ],

init : function(ed) {
	var id = ed.element['$'].id;
	var blog_id = $('#blog-id').val() || 0;

    ed.addMtButton = addMtButton;

	var proxies = {};

    var notSupportedButtonsCache = {};
    function notSupportedButtons(mode, format) {
        var k = mode + '-' + format;
        if (! notSupportedButtonsCache[k]) {
            notSupportedButtonsCache[k] = {};
            $.each(ed.mtButtons, function(name, button) {
                if (! button.isSupported(mode, format)) {
                    notSupportedButtonsCache[k][name] = button;
                }
            });
        }

        return notSupportedButtonsCache[k];
    };

    ed.mtProxies = proxies;
    ed.mtEditorStatus = {
        mode: 'wysiwyg',
        format: 'richtext'
    };

    ed.addCommand('mtGetStatus', {
        modes: {wysiwyg:1,source:1},
        exec: function() {
            return ed.mtEditorStatus;
        }
    });

    ed.addCommand('mtSetStatus', {
        modes: {wysiwyg:1,source:1},
        exec: function(ed, status) {
            $.extend(ed.mtEditorStatus, status);

            var previousEditorMode = ed.mode;
            if (ed.mtEditorStatus['mode'] == 'source') {
                ed.fire('saveSnapshot');
                ed.setMode('source');
            }
            else {
                ed.setMode('wysiwyg');
            }

            if (previousEditorMode == ed.mode) {
                ed.fire('mode', {previousMode: previousEditorMode});
            }
        }
    });

    ed.on('mode', function() {
        var s = ed.mtEditorStatus;
        if (ed.mode == 'source') {
            proxies.source.setFormat(s.format);

            $.each(notSupportedButtons(ed.mode, s.format), function(k, v) {
                ed.getCommand(k).setState(CKEDITOR.TRISTATE_DISABLED);
            });

            if (s.mode != 'wysiwyg') {
                setTimeout(function() {
                    ed.getCommand('source').
                        setState(CKEDITOR.TRISTATE_DISABLED);
                }, 0);
            }
        }
    });

    ed.addCommand('mtGetProxies', {
        modes: {wysiwyg:1,source:1},
        exec: function() {
            return proxies;
        }
    });

    ed.addCommand('mtSetProxies', {
        modes: {wysiwyg:1,source:1},
        exec: function(ed, _proxies) {
            $.extend(proxies, _proxies);
        }
    });


    var icon_path = this.path + 'img/toolbar.png';

	ed.addMtButton('mt_font_size_smaller', {
		label: ed.lang.mt.font_size_smaller,
        clickFunctions : {
            wysiwyg: 'fontSizeSmaller',
            source: 'fontSizeSmaller'
        },
		icon: icon_path,
        iconOffset: 0
	});

	ed.addMtButton('mt_font_size_larger', {
		label: ed.lang.mt.font_size_larger,
        clickFunctions : {
            wysiwyg: 'fontSizeLarger',
            source: 'fontSizeLarger'
        },
		icon: icon_path,
        iconOffset: 1
	});

	ed.addMtButton('mt_bold', {
		label: ed.lang.mt.bold,
        clickFunctions : {
            wysiwyg: function() {
                ed.execCommand('bold');
            },
            source:  'bold'
        },
		icon: icon_path,
        iconOffset: 2
	});

	ed.addMtButton('mt_italic', {
		label: ed.lang.mt.italic,
		clickFunctions : {
            wysiwyg: function() {
                ed.execCommand('italic');
			},
            source: 'italic'
        },
		icon: icon_path,
        iconOffset: 3
	});

	ed.addMtButton('mt_underline', {
		label: ed.lang.mt.underline,
		clickFunctions : {
            wysiwyg: function() {
                ed.execCommand('underline');
			},
            source: 'underline'
        },
		icon: icon_path,
        iconOffset: 4
	});

	ed.addMtButton('mt_strikethrough', {
		label: ed.lang.mt.strikethrough,
		clickFunctions : {
            wysiwyg: function() {
                ed.execCommand('strike');
			},
            source: 'strikethrough'
        },
		icon: icon_path,
        iconOffset: 5
	});

	ed.addMtButton('mt_insert_link', {
		label: ed.lang.mt.insert_link,
		clickFunctions : {
            wysiwyg: function() {
                var anchor = getSelectedAnchor(this);
                var textSelected =
                        !this.getSelection().getRanges()[0].collapsed;

                proxies['wysiwyg'].execCommand('insertLink', null, {
                    anchor: anchor,
                    textSelected: textSelected
                });
			},
            source: 'insertLink'
        },
		icon: icon_path,
        iconOffset: 7
	});

	ed.addMtButton('mt_insert_email', {
		label: ed.lang.mt.insert_email,
		clickFunctions : {
            wysiwyg: function() {
                var anchor = getSelectedAnchor(this);
                var textSelected =
                        !this.getSelection().getRanges()[0].collapsed;

                proxies['wysiwyg'].execCommand('insertEmail', null, {
                    anchor: anchor,
                    textSelected: textSelected
                });
			},
            source: 'insertEmail'
        },
		icon: icon_path,
        iconOffset: 8
	});

	ed.addMtButton('mt_indent', {
		label: ed.lang.mt.indent,
		clickFunctions : {
            wysiwyg: function() {
                ed.execCommand('indent');
			},
            source: 'indent'
        },
		icon: icon_path,
        iconOffset: 9
	});

	ed.addMtButton('mt_outdent', {
		label: ed.lang.mt.outdent,
		clickFunctions : {
            wysiwyg: function() {
                ed.execCommand('outdent');
			}
        },
		icon: icon_path,
        iconOffset: 10
	});

	ed.addMtButton('mt_insert_unordered_list', {
		label: ed.lang.mt.insert_unordered_list,
		clickFunctions : {
            wysiwyg: function() {
                ed.execCommand('bulletedlist');
			},
            source: 'insertUnorderedList'
        },
		icon: icon_path,
        iconOffset: 11
	});

	ed.addMtButton('mt_insert_ordered_list', {
		label: ed.lang.mt.insert_ordered_list,
		clickFunctions : {
            wysiwyg: function() {
                ed.execCommand('numberedlist');
			},
            source: 'insertOrderedList'
        },
		icon: icon_path,
        iconOffset: 12
	});

	ed.addMtButton('mt_justify_left', {
		label: ed.lang.mt.justify_left,
		clickFunctions : {
            wysiwyg: function() {
                ed.execCommand('justifyleft');
			},
            source: 'justifyLeft'
        },
		icon: icon_path,
        iconOffset: 16
	});

	ed.addMtButton('mt_justify_center', {
		label: ed.lang.mt.justify_center,
		clickFunctions : {
            wysiwyg: function() {
                ed.execCommand('justifycenter');
			},
            source: 'justifyCenter'
        },
		icon: icon_path,
        iconOffset: 17
	});

	ed.addMtButton('mt_justify_right', {
		label: ed.lang.mt.justify_right,
		clickFunctions : {
            wysiwyg: function() {
                ed.execCommand('justifyright');
			},
            source: 'justifyRight'
        },
		icon: icon_path,
        iconOffset: 18
	});

	ed.addMtButton('mt_insert_image', {
		label: ed.lang.mt.insert_image,
		click : function() {
			openDialog(
				'dialog_list_asset',
				'_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blog_id +
				'&amp;dialog_view=1&amp;filter=class&amp;filter_val=image'
			);
		},
		icon: icon_path,
        iconOffset: 20
	});

	ed.addMtButton('mt_insert_file', {
		label: ed.lang.mt.insert_file,
        click : function() {
			openDialog(
				'dialog_list_asset',
				'_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blog_id +
				'&amp;dialog_view=1'
			);
        },
		icon: icon_path,
        iconOffset: 21
	});
}

});

})(jQuery);
