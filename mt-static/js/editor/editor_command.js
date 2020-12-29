/*
 * Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {

MT.EditorCommand = function(editor) {
    this.editor = this.e = editor;
};

$.extend(MT.EditorCommand.prototype, {
    isSupported: function( command ) {
        return true;
    },

    editLink: function( linkElement ) {
        this.createLink( linkElement.getAttribute('href'), true, linkElement );
    },

    createLink: function( url, textSelected, anchor ) {
        var linkedText = "";
        if( !url )
            url = "http://";
        if(typeof(textSelected) == 'undefined')
            textSelected = this.e.getSelectedText();

        url = prompt( Editor.strings.enterLinkAddress, url );
        if( !url )
            return false;
        if( !textSelected )
            linkedText = prompt( Editor.strings.enterTextToLinkTo, "" );

        this.insertLink( { url: url, linkedText: linkedText, anchor: anchor } );
    },

    initLinkDataBagUrl: function( dataBag ) {
        if( !dataBag || !dataBag.url || !dataBag.url.trim() )
            return null;
        dataBag.url = dataBag.url.trim();
        return dataBag;
    },

    insertLink: function( dataBag ) {
        dataBag = this.initLinkDataBagUrl( dataBag );
        if( !dataBag )
            return;
        if( !dataBag.anchor ) {
            if( dataBag.linkedText ) {
                var html = "<a href='" + dataBag.url + "'>" + dataBag.linkedText + "</a>";
                this.editor.insertContent( html );
            } else {
                this.execCommand( "createLink", false, dataBag.url );
            }
        } else {
            dataBag.anchor.href = dataBag.url;
            return dataBag.anchor;
        }
    },

    editEmail: function( linkElement ) {
        this.createEmailLink( linkElement.href, true, linkElement );
    },

    mailtoRegexp: /^mailto:/i,

    createEmailLink: function( url, textSelected, anchor ) {
        var linkedText = "";
        if( !url )
            url = "";
        if(typeof(textSelected) == 'undefined')
            textSelected = this.e.getSelectedText();

        url = url.replace( this.mailtoRegexp, "" );

        url = prompt( Editor.strings.enterEmailAddress, url );
        if( !url )
            return false;
        if( !textSelected )
            linkedText = prompt( Editor.strings.enterTextToLinkTo, "" );

        this.insertLink( { url: "mailto:" + url, linkedText: linkedText, anchor: anchor } );
    },

    focus: function() {
        this.editor.focus();
    }
});

})(jQuery);
