;(function($) {

CKEDITOR.plugins.add('movabletype', {

lang : [ 'en', 'ja' ],

init : function(editor) {
	var id = editor.element['$'].id;
	var blog_id = $('#blog-id').val() || 0;

	function openDialog(mode, param) {
		$.fn.mtDialog.open(
			ScriptURI + '?' + '__mode=' + mode + '&amp;' + param
		);
	}


	editor.addCommand('mt_font_size_smaller', {
		exec: function() {
            document.execCommand('fontSizeSmaller', false, null);
		}
	});

	editor.addCommand('mt_font_size_larger', {
		exec: function() {
            document.execCommand('fontSizeLarger', false, null);
		}
	});

    editor.addCommand('mt_bold', {
		exec: function() {
            document.execCommand('mt_bold', false, null);
		}
	});

    editor.addCommand('mt_italic', {
		exec: function() {
            document.execCommand('mt_italic', false, null);
		}
	});

    editor.addCommand('mt_underline', {
		exec: function() {
            document.execCommand('mt_underline', false, null);
		}
	});

    editor.addCommand('mt_strikethrough', {
		exec: function() {
            document.execCommand('mt_strikethrough', false, null);
		}
	});

    editor.addCommand('mt_insert_link', {
		exec: function() {
            document.execCommand('mt_insert_link', false, null);
		}
	});

    editor.addCommand('mt_insert_email', {
		exec: function() {
            document.execCommand('mt_insert_email', false, null);
		}
	});
    editor.addCommand('mt_indent', {
		exec: function() {
            document.execCommand('mt_indent', false, null);
		}
	});

    editor.addCommand('mt_outdent', {
		exec: function() {
            document.execCommand('mt_outdent', false, null);
		}
	});
    editor.addCommand('mt_insert_unordered_list', {
		exec: function() {
            document.execCommand('mt_insert_unordered_list', false, null);
		}
	});

    editor.addCommand('mt_insert_ordered_list', {
		exec: function() {
            document.execCommand('mt_insert_ordered_list', false, null);
		}
	});

    editor.addCommand('mt_justify_left', {
		exec: function() {
            document.execCommand('mt_justify_left', false, null);
		}
	});

    editor.addCommand('mt_justify_center', {
		exec: function() {
            document.execCommand('mt_justify_center', false, null);
		}
	});

    editor.addCommand('mt_justify_right', {
		exec: function() {
            document.execCommand('mt_justify_right', false, null);
		}
	});

	editor.addCommand('mt_insert_image', {
		exec: function() {
			openDialog(
				'dialog_list_asset',
				'_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blog_id +
				'&amp;dialog_view=1&amp;filter=class&amp;filter_val=image'
			);
		}
	});

	editor.addCommand('mt_insert_file', {
		exec: function() {
			openDialog(
				'dialog_list_asset',
				'_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blog_id +
				'&amp;dialog_view=1'
			);
		}
	});

	editor.ui.addButton('mt_font_size_smaller', {
        modes : { wysiwyg:1, source:1 },
		label : editor.lang.movabletype.font_size_smaller,
		command : 'mt_font_size_smaller',
        click : function() { },
		icon: this.path + 'img/toolbar.png',
        iconOffset: 0
	});
	editor.ui.addButton('mt_font_size_larger', {
        modes : { wysiwyg:1, source:1 },
		label : editor.lang.movabletype.font_size_larger,
		command : 'mt_font_size_larger',
		icon: this.path + 'img/toolbar.png',
        iconOffset: 1
	});
	editor.ui.addButton('mt_bold', {
        modes : { wysiwyg:1, source:1 },
		label : editor.lang.movabletype.bold,
		command : 'mt_bold',
		icon: this.path + 'img/toolbar.png',
        iconOffset: 2
	});
	editor.ui.addButton('mt_italic', {
        modes : { wysiwyg:1, source:1 },
		label : editor.lang.movabletype.italic,
		command : 'mt_italic',
		icon: this.path + 'img/toolbar.png',
        iconOffset: 3
	});
	editor.ui.addButton('mt_underline', {
        modes : { wysiwyg:1, source:1 },
		label : editor.lang.movabletype.underline,
		command : 'mt_underline',
		icon: this.path + 'img/toolbar.png',
        iconOffset: 4
	});
	editor.ui.addButton('mt_strikethrough', {
        modes : { wysiwyg:1, source:1 },
		label : editor.lang.movabletype.strikethrough,
		command : 'mt_strikethrough',
		icon: this.path + 'img/toolbar.png',
        iconOffset: 5
	});
	editor.ui.addButton('mt_insert_link', {
        modes : { wysiwyg:1, source:1 },
		label : editor.lang.movabletype.insert_link,
		command : 'mt_insert_link',
		icon: this.path + 'img/toolbar.png',
        iconOffset: 7
	});
	editor.ui.addButton('mt_insert_email', {
        modes : { wysiwyg:1, source:1 },
		label : editor.lang.movabletype.insert_email,
		command : 'mt_insert_email',
		icon: this.path + 'img/toolbar.png',
        iconOffset: 8
	});
	editor.ui.addButton('mt_indent', {
        modes : { wysiwyg:1, source:1 },
		label : editor.lang.movabletype.indent,
		command : 'mt_indent',
		icon: this.path + 'img/toolbar.png',
        iconOffset: 9
	});
	editor.ui.addButton('mt_outdent', {
        modes : { wysiwyg:1, source:1 },
		label : editor.lang.movabletype.outdent,
		command : 'mt_outdent',
		icon: this.path + 'img/toolbar.png',
        iconOffset: 10
	});
	editor.ui.addButton('mt_insert_unordered_list', {
        modes : { wysiwyg:1, source:1 },
		label : editor.lang.movabletype.insert_unordered_list,
		command : 'mt_insert_unordered_list',
		icon: this.path + 'img/toolbar.png',
        iconOffset: 11
	});
	editor.ui.addButton('mt_insert_ordered_list', {
        modes : { wysiwyg:1, source:1 },
		label : editor.lang.movabletype.insert_ordered_list,
		command : 'mt_insert_ordered_list',
		icon: this.path + 'img/toolbar.png',
        iconOffset: 12
	});
	editor.ui.addButton('mt_justify_left', {
        modes : { wysiwyg:1, source:1 },
		label : editor.lang.movabletype.justify_left,
		command : 'mt_justify_left',
		icon: this.path + 'img/toolbar.png',
        iconOffset: 16
	});
	editor.ui.addButton('mt_justify_center', {
        modes : { wysiwyg:1, source:1 },
		label : editor.lang.movabletype.justify_center,
		command : 'mt_justify_center',
		icon: this.path + 'img/toolbar.png',
        iconOffset: 17
	});
	editor.ui.addButton('mt_justify_right', {
        modes : { wysiwyg:1, source:1 },
		label : editor.lang.movabletype.justify_right,
		command : 'mt_justify_right',
		icon: this.path + 'img/toolbar.png',
        iconOffset: 18
	});
	editor.ui.addButton('mt_insert_image', {
        modes : { wysiwyg:1, source:1 },
		label : editor.lang.movabletype.insert_image,
		command : 'mt_insert_image',
		icon: this.path + 'img/toolbar.png',
        iconOffset: 20
	});
	editor.ui.addButton('mt_insert_file', {
        modes : { wysiwyg:1, source:1 },
		label : editor.lang.movabletype.insert_file,
		command : 'mt_insert_file',
		icon: this.path + 'img/toolbar.png',
        iconOffset: 21
	});
}

});

})(jQuery);
