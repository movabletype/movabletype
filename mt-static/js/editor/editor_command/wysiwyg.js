/*
 * Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {

MT.EditorCommand.WYSIWYG = function(editor) {
    MT.EditorCommand.apply(this, arguments);
    this.doc = editor.getDocument();
};

$.extend(MT.EditorCommand.WYSIWYG.prototype, MT.EditorCommand.prototype, {
    mutateFontSize: function( element, bigger ) {
        // Basic settings:
        var goSmaller = 0.8;
        var goBigger = 1.25;
        var biggest = Math.pow( goBigger, 3 );
        var smallest = Math.pow( goSmaller, 3);
        var defaultSize = bigger ? goBigger + "em" : goSmaller + "em";

        // Initial detection, rejection, adjusting:
        var fontSize = element.style.fontSize.match( /([\d\.]+)(%|em|$)/ );
        if( fontSize == null || isNaN( fontSize[ 1 ] ) ) // "px" sizes are rejected.
            return defaultSize; // A browser problem or bad user data would lead to "NaN" fontSize.

        var size;
        if( fontSize[ 2 ] == "%" )
            size = fontSize[ 1 ] / 100; // Convert to "em" units.
        else if( fontSize[ 2 ] == "em" || fontSize[ 2 ] == "" )
            size = fontSize[ 1 ];

        // Mutation:
        var factor = bigger ? goBigger : goSmaller;
        size = size * factor;

        if( size > biggest )
            size = biggest;
        else if( size < smallest )
            size = smallest;

        return size + "em";
    },

    changeFontSizeOfSelection: function(doc, bigger) {
        var bogus = "-editor-proxy";
        doc.execCommand( "fontName", false, bogus );

        var elements = null;

        elements = doc.getElementsByTagName( "font" );
        for( var i = 0; i < elements.length; i++ ) {
            var element = elements[ i ];
            if( element.face == bogus ) {
                element.removeAttribute( "face" );
                element.style.fontSize = this.mutateFontSize( element, bigger );
                return;
            }
        }

        elements = doc.getElementsByTagName( "span" );
        for( var i = 0; i < elements.length; i++ ) {
            var element = elements[ i ];
            if( element.style.fontFamily == bogus ) {
                element.style.fontFamily = '';
                element.style.fontSize = this.mutateFontSize( element, bigger );
                return;
            }
        }
    },

    execCommand: function( command, userInterface, argument ) {
        /* Possible commands:
         * fontSizeSmaller
         * fontSizeLarger
         * insertLink
         */

        var func = this.commands[command];
        if (func) {
            func.apply(this, [command, userInterface, argument]);
        }
        else {
            this.doc.execCommand(command, userInterface, argument);
        }

        this.editor.setDirty();
    },

    commands: {}
});

$.extend(MT.EditorCommand.WYSIWYG.prototype.commands, {
    fontSizeSmaller: function(command, userInterface, argument) {
        this.changeFontSizeOfSelection(this.doc, false);
    },

    fontSizeLarger: function(command, userInterface, argument) {
        this.changeFontSizeOfSelection(this.doc, true);
    },

    insertLink: function(command, userInterface, argument) {
        if (argument['anchor']) {
            this.editLink(argument['anchor']);
        }
        else {
            this.createLink(null, argument['textSelected']);
        }
    },

    insertEmail: function(command, userInterface, argument) {
        if (argument['anchor']) {
            this.editEmail(argument['anchor']);
        }
        else {
            this.createEmailLink(null, argument['textSelected']);
        }
    }
});

})(jQuery);
