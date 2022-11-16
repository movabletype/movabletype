/*
 * Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {

MT.EditorCommand.Source = function(editor) {
    MT.EditorCommand.apply(this, arguments);
    this.format = 'default';
};
$.extend(MT.EditorCommand.Source.prototype, MT.EditorCommand.prototype, {
    setFormat: function(format) {
        this.format = format;
        this.commandStates = {};
    },

    isSupported: function(command, format, feature) {
        var format = format || this.format;
        if (! this.commands[format]) {
            format = 'default';
        }

        if (feature) {
            command += '-' + feature;
        }

        return this.commands[format][command];
    },

    execCommand: function( command, userInterface, argument, options ) {
        var text = this.e.getSelectedText();
        if(options && options['text'])
            text = options['text'];
        if ( !defined( text ) )
            text = '';

        var format = this.format;
        if (! this.commands[format]) {
            format = 'default';
        }

        var func = this.commands[format][command];
        if (func) {
            func.apply(this, [command, userInterface, argument, text, options]);
        }

        return this.editor.setDirty();
    },

    commandStates: {},

    isStateActive: function(command) {
        return this.commandStates[command] ? true : false;
    },

    execEnclosingCommand: function(command, open, close, text, selectedCallback) {
        if (! text) {
            if (! this.isStateActive(command)) {
                this.e.setSelection(open);
                this.commandStates[command] = true;
            }
            else {
                this.e.setSelection(close);
                this.commandStates[command] = false;
            }
        }
        else {
            if (selectedCallback) {
                selectedCallback.apply(this, []);
            }
            else {
                this.e.setSelection( open + text + close );
            }
        }
    },

    execLinkCommand: function(command, open, close, text) {
        var selection;

        this.e.setSelection( open );
        if ( text ) {
            this.e.setSelection( text );
        }
        else {
            selection = this.e.saveSelection();
        }
        this.e.setSelection( close );

        if ( selection ) {
            this.e.restoreSelection( selection );
        }
    },

    commands: {}
});

MT.EditorCommand.Source.prototype.commands['default'] = {
    fontSizeSmaller: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<small>', '</small>', text);
    },

    fontSizeLarger: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<big>', '</big>', text);
    },

    bold: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<strong>', '</strong>', text);
    },

    italic: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<em>', '</em>', text);
    },

    underline: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<u>', '</u>', text);
    },

    strikethrough: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<strike>', '</strike>', text);
    },

    insertLink: function(command, userInterface, argument, text) {
        this.createLink();
    },

    insertEmail: function(command, userInterface, argument, text) {
        this.createLink();
    },

    createLink: function(command, userInterface, argument, text, options) {
        var open = '<a href="' + argument + '"';
        if (options) {
            if (options['target']) {
                open += ' target="' + options['target'] + '"';
            }
            if (options['title']) {
                open += ' title="' + options['title'] + '"';
            }
        }
        open += '>';

        this.execLinkCommand(command, open, '</a>', text);
    },

    'createLink-target': true,

    indent: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<blockquote>', '</blockquote>', text);
    },

    blockquote: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<blockquote>', '</blockquote>', text);
    },

    insertUnorderedList: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<ul>', '</ul>', text);
    },

    insertOrderedList: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<ol>', '</ol>', text);
    },

    insertListItem: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<li>', '</li>', text);
    },

    justifyLeft: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<div style="text-align: left;">', '</div>', text);
    },

    justifyCenter: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<div style="text-align: center;">', '</div>', text);
    },

    justifyRight: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<div style="text-align: right;">', '</div>', text);
    }
};

MT.EditorCommand.Source.prototype.commands['markdown'] =
MT.EditorCommand.Source.prototype.commands['markdown_with_smartypants'] = {
    bold: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '**', '**', text);
    },

    italic: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '*', '*', text);
    },

    insertLink: function(command, userInterface, argument, text) {
        this.createLink();
    },

    insertEmail: function(command, userInterface, argument, text) {
        this.createLink();
    },

    createLink: function(command, userInterface, argument, text, options) {
        var close = "](" + argument;
        if (options) {
            if (options['title']) {
                close += ' "' + options['title'] + '"';
            }
        }
        close += ')';

        this.execLinkCommand(command, "[", close, text);
    },

    indent: function(command, userInterface, argument, text) {
        var list = text.split( /\r?\n/ );
        for ( var i = 0; i < list.length; i++ )
            list[ i ] = "> " + list[ i ];
        this.e.setSelection( list.join( "\n" ) );
    },

    blockquote: function(command, userInterface, argument, text) {
        var list = text.split( /\r?\n/ );
        for ( var i = 0; i < list.length; i++ )
            list[ i ] = "> " + list[ i ];
        this.e.setSelection( list.join( "\n" ) );
    },

    insertUnorderedList: function(command, userInterface, argument, text) {
        var list = text.split( /\r?\n/ );
        for ( var i = 0; i < list.length; i++ )
            list[ i ] = " - " + list[ i ];
        this.e.setSelection( "\n" + list.join( "\n" ) );
    },

    insertOrderedList: function(command, userInterface, argument, text) {
        var list = text.split( /\r?\n/ );
        for ( var i = 0; i < list.length; i++ )
            list[ i ] = " " + ( i + 1 ) + ".  " + list[ i ];
        this.e.setSelection( "\n" + list.join( "\n" ) );
    }
};

MT.EditorCommand.Source.prototype.commands['textile_2'] = {
    bold: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '**', '**', text);
    },

    italic: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '_', '_', text);
    },

    strikethrough: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '-', '-', text);
    },

    insertLink: function(command, userInterface, argument, text) {
        this.createLink();
    },

    insertEmail: function(command, userInterface, argument, text) {
        this.createLink();
    },

    createLink: function(command, userInterface, argument, text, options) {
        var close = '';
        if (options) {
            if (options['title']) {
                close += '(' + options['title'] + ')';
            }
        }
        close += '":' + argument;

        this.execLinkCommand(command, '"', close, text);
    },

    indent: function(command, userInterface, argument, text) {
        this.e.setSelection( "bq. " + text );
    },

    blockquote: function(command, userInterface, argument, text) {
        this.e.setSelection( "bq. " + text );
    },

    underline: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<u>', '<u>', text);
    },

    insertUnorderedList: function(command, userInterface, argument, text) {
        var list = text.split( /\r?\n/ );
        for ( var i = 0; i < list.length; i++ )
            list[ i ] = "* " + list[ i ];
        this.e.setSelection( "\n" + list.join( "\n" ) );
    },

    insertOrderedList: function(command, userInterface, argument, text) {
        var list = text.split( /\r?\n/ );
        for ( var i = 0; i < list.length; i++ )
            list[ i ] = "# " + list[ i ];
        this.e.setSelection( "\n" + list.join( "\n" ) );
    },

    justifyLeft: function(command, userInterface, argument, text) {
        this.e.setSelection( "p< " + text );
    },

    justifyCenter: function(command, userInterface, argument, text) {
        this.e.setSelection( "p= " + text );
    },

    justifyRight: function(command, userInterface, argument, text) {
        this.e.setSelection( "p> " + text );
    },

    fontSizeSmaller: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<small>', '<small>', text);
    },

    fontSizeLarger: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<big>', '<big>', text);
    }
};

})(jQuery);
