/* 
$Id: Textarea.js 263 2008-05-07 23:25:24Z auno $

Copyright Six Apart, Ltd. All rights reserved.
Redistribution and use in source and binary forms is
subject to the Six Apart JavaScript license:

http://code.sixapart.com/svn/js/trunk/LICENSE.txt
*/


Editor.Textarea = new Class( Component, {
    

    initObject: function( element, editor ) {
        arguments.callee.applySuper( this, arguments );
        this.editor = editor;
        this.range = null;
    },

    
    destroyObject: function() {
        this.range = null;
        this.editor = null;
        arguments.callee.applySuper( this, arguments );
    },


    eventKeyDown: function( event ) {
        this.editor.setChanged();
    },


    getHTML: function() {
        var selection = this.getSelection();
        if ( selection.createRange ) {
            this.focus();
            this.range = selection.createRange().duplicate();
        }
        return this.element.value;
    },


    setHTML: function( html ) {
        this.element.value = html;
    },

    
    insertHTML: function( html, select, id, isTempId ) {
        this.setSelection( html );
    },
    
    
    focus: function() {
        return this.element.focus();
    },


    execCommand: function( command, userInterface, argument ) {
        /* Possible commands: 
         * fontSizeSmaller - not supported
         * fontSizeLarger - not supported
         * -
         * bold
         * italic
         * underline
         * strikethrough
         * -
         * createLink
         * -
         * indent
         * outdent - not supported
         * -
         * insertUnorderedList
         * insertOrderedList
         * -
         * justifyLeft
         * justifyCenter
         * justifyRight
         * -
         * XXX others?
         */
        var text = this.getSelectedText();
        if ( !defined( text ) )
            text = '';
        switch ( command ) {
            
            case "bold":
                this.setSelection( "<strong>" + text + "</strong>" );
                break;

            case "italic":
                this.setSelection( "<em>" + text + "</em>" );
                break;

            case "underline":
                this.setSelection( "<u>" + text + "</u>" );
                break;
            
            case "strikethrough":
                this.setSelection( "<strike>" + text + "</strike>" );
                break;
            
            case "createLink":
                /* XXX escape() argument? */
                this.setSelection( '<a href="' + argument + '">' + text + "</a>" );
                break;
            
            case "indent":
                this.setSelection( "<blockquote>" + text + "</blockquote>" );
                break;
            
            case "insertUnorderedList":
            case "insertOrderedList":
                var list = text.split( /\r?\n/ );
                var li = [];
                for ( var i = 0; i < list.length; i++ )
                    list[ i ] = "\t<li>" + list[ i ] + "</li>";
                if ( command == "insertUnorderedList" )
                    this.setSelection( "<ul>\n" + list.join( "\n" ) + "\n</ul>" );
                else
                    this.setSelection( "<ol>\n" + list.join( "\n" ) + "\n</ol>" );
                break;

            case "justifyLeft":
                this.setSelection( '<div style="text-align: left;">' + text + "</div>" );
                break;

            case "justifyCenter":
                this.setSelection( '<div style="text-align: center;">' + text + "</div>" );
                break;

            case "justifyRight":
                this.setSelection( '<div style="text-align: right;">' + text + "</div>" );
                break;

        }
        this.editor.setChanged();
    },


    getSelection: function() {
        return DOM.getSelection( this.window, this.document );
    },


    getSelectedText: function() {
        var selection = this.getSelection();
        if ( selection.createRange ) {
            // ie
            this.range = null;
            this.focus();
            var range = selection.createRange();
            return range.text;
        } else {
            var length = this.element.textLength;
            var start = this.element.selectionStart;
            var end = this.element.selectionEnd;
            if ( end == 1 || end == 2 && defined( length ) )
                end = length;
            return this.element.value.substring( start, end );
        }
    },


    setSelection: function( txt ) {
        var el = this.element;
        var selection = this.getSelection();
        if ( selection.createRange ) {
            var range = this.range;
            if ( !range ) {
                this.focus();
                range = selection.createRange();
            }
            range.text = txt;
            range.select();
        } else {
            var scrollTop = el.scrollTop;
            var length = el.textLength;
            var start = el.selectionStart;
            var end = el.selectionEnd;
            if ( end == 1 || end == 2 && defined( length ) )
                end = length;
            el.value = el.value.substring( 0, start ) + txt + el.value.substr( end, length );
            el.selectionStart = start;
            el.selectionEnd = start + txt.length;
            el.scrollTop = scrollTop;
        }
        this.focus();
    },


    isTextSelected: function() {
        return true; /* XXX verify */
    },

    
    getSelectedLink: Function.stub

} );
