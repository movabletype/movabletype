/*
 * Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
 * This program is distributed under the terms of the
 * GNU General Public License, version 2.
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

    isSupported: function(command, format) {
        var format = format || this.format;
        if (! this.commands[format]) {
            format = 'default';
        }

        return this.commands[format][command];
    },

    execCommand: function( command, userInterface, argument ) {
        var text = this.e.getSelectedText();
        if ( !defined( text ) )
            text = '';

        var format = this.format;
        if (! this.commands[format]) {
            format = 'default';
        }

        var func = this.commands[format][command];
        if (func) {
            func.apply(this, [command, userInterface, argument, text]);
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
                selectedCallback();
            }
            else {
                this.e.setSelection( open + text + close );
            }
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

    createLink: function(command, userInterface, argument, text) {
        this.e.setSelection( '<a href="' + argument + '">' + text + "</a>" );
    },

    indent: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<blockquote>', '</blockquote>', text);
    },

    blockquote: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<blockquote>', '</blockquote>', text);
    },

    insertUnorderedList: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<ul>', '</ul>', text, function() {
            var list = text.split( /\r?\n/ );
            var li = [];
            for ( var i = 0; i < list.length; i++ )
                list[ i ] = "\t<li>" + list[ i ] + "</li>";
            this.e.setSelection( "<ul>\n" + list.join( "\n" ) + "\n</ul>" );
        });
    },

    insertOrderedList: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<ol>', '</ol>', text, function() {
            var list = text.split( /\r?\n/ );
            var li = [];
            for ( var i = 0; i < list.length; i++ )
                list[ i ] = "\t<li>" + list[ i ] + "</li>";
            this.e.setSelection( "<ul>\n" + list.join( "\n" ) + "\n</ul>" );
        });
    },

    insertListItem: function(command, userInterface, argument, text) {
        this.execEnclosingCommand(command, '<li>', '</li>\n', text);
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

    createLink: function(command, userInterface, argument, text) {
        this.e.setSelection( "[" + text + "](" + argument + ")" );
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

    createLink: function(command, userInterface, argument, text) {
        this.e.setSelection( '"' + text + '":' + argument );
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
