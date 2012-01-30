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
    },

    isSupported: function( command ) {
        var format = this.format;
        if (! this.commands[format]) {
            format = 'default';
        }

        return this.commands[format][command];
    },

    execCommand: function( command, userInterface, argument ) {
        /* Possible commands:
         * fontSizeSmaller
         * fontSizeLarger
         * -
         * bold
         * italic
         * underline
         * strikethrough
         * -
         * createLink
         * -
         * indent
         * outdent
         * -
         * insertUnorderedList
         * insertOrderedList
         * -
         * justifyLeft
         * justifyCenter
         * justifyRight
         */

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

    commands: {}
});

MT.EditorCommand.Source.prototype.commands['default'] = {
    fontSizeSmaller: function(command, userInterface, argument, text) {
        this.e.setSelection( "<small>" + text + "</small>" );
    },

    fontSizeLarger: function(command, userInterface, argument, text) {
        this.e.setSelection( "<big>" + text + "</big>" );
    },

    bold: function(command, userInterface, argument, text) {
        this.e.setSelection( "<strong>" + text + "</strong>" );
    },

    italic: function(command, userInterface, argument, text) {
        this.e.setSelection( "<em>" + text + "</em>" );
    },

    underline: function(command, userInterface, argument, text) {
        this.e.setSelection( "<u>" + text + "</u>" );
    },

    strikethrough: function(command, userInterface, argument, text) {
        this.e.setSelection( "<strike>" + text + "</strike>" );
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
        this.e.setSelection( "<blockquote>" + text + "</blockquote>" );
    },

    insertUnorderedList: function(command, userInterface, argument, text) {
        var list = text.split( /\r?\n/ );
        var li = [];
        for ( var i = 0; i < list.length; i++ )
            list[ i ] = "\t<li>" + list[ i ] + "</li>";
        this.e.setSelection( "<ul>\n" + list.join( "\n" ) + "\n</ul>" );
    },

    insertOrderedList: function(command, userInterface, argument, text) {
        var list = text.split( /\r?\n/ );
        var li = [];
        for ( var i = 0; i < list.length; i++ )
            list[ i ] = "\t<li>" + list[ i ] + "</li>";
        this.e.setSelection( "<ol>\n" + list.join( "\n" ) + "\n</ol>" );
    },

    justifyLeft: function(command, userInterface, argument, text) {
        this.e.setSelection( '<div style="text-align: left;">' + text + "</div>" );
    },

    justifyCenter: function(command, userInterface, argument, text) {
        this.e.setSelection( '<div style="text-align: center;">' + text + "</div>" );
    },

    justifyRight: function(command, userInterface, argument, text) {
        this.e.setSelection( '<div style="text-align: right;">' + text + "</div>" );
    }
};

MT.EditorCommand.Source.prototype.commands['markdown'] =
MT.EditorCommand.Source.prototype.commands['markdown_with_smartypants'] = {
    bold: function(command, userInterface, argument, text) {
        this.e.setSelection( "**" + text + "**" );
    },

    italic: function(command, userInterface, argument, text) {
        this.e.setSelection( "*" + text + "*" );
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

    insertUnorderedList: function(command, userInterface, argument, text) {
        var list = text.split( /\r?\n/ );
        for ( var i = 0; i < list.length; i++ )
            list[ i ] = " - " + list[ i ];
        this.e.setSelection( "\n" + list.join( "\n" ) + "\n" );
    },

    insertOrderedList: function(command, userInterface, argument, text) {
        var list = text.split( /\r?\n/ );
        for ( var i = 0; i < list.length; i++ )
            list[ i ] = " " + ( i + 1 ) + ".  " + list[ i ];
        this.e.setSelection( "\n" + list.join( "\n" ) + "\n" );
    }
};

MT.EditorCommand.Source.prototype.commands['textile_2'] = {
    bold: function(command, userInterface, argument, text) {
        this.e.setSelection( "**" + text + "**" );
    },

    italic: function(command, userInterface, argument, text) {
        this.e.setSelection( "_" + text + "_" );
    },

    strikethrough: function(command, userInterface, argument, text) {
        this.e.setSelection( "-" + text + "-" );
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

    underline: function(command, userInterface, argument, text) {
        this.e.setSelection( "<u>" + text + "</u>" );
    },

    insertUnorderedList: function(command, userInterface, argument, text) {
        var list = text.split( /\r?\n/ );
        for ( var i = 0; i < list.length; i++ )
            list[ i ] = "* " + list[ i ];
        this.e.setSelection( "\n" + list.join( "\n" ) + "\n" );
    },

    insertOrderedList: function(command, userInterface, argument, text) {
        var list = text.split( /\r?\n/ );
        for ( var i = 0; i < list.length; i++ )
            list[ i ] = "# " + list[ i ];
        this.e.setSelection( "\n" + list.join( "\n" ) + "\n" );
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
        this.e.setSelection( "<small>" + text + "</small>" );
    },

    fontSizeLarger: function(command, userInterface, argument, text) {
        this.e.setSelection( "<big>" + text + "</big>" );
    }
};

})(jQuery);
