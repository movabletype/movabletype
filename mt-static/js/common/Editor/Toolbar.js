/* 
$Id: Toolbar.js 194 2007-05-16 00:05:47Z ydnar $

Copyright Six Apart, Ltd. All rights reserved.
Redistribution and use in source and binary forms is
subject to the Six Apart JavaScript license:

http://code.sixapart.com/svn/js/trunk/LICENSE.txt
*/


Editor.Toolbar = new Class( Component, {
    CLASSNAME_ROOT: "editor-state-", 


    initObject: function( element, editor ) {
        arguments.callee.applySuper( this, arguments );
        this.editor = editor;
        this.element.unselectable = "on";
    },
    

    destroyObject: function() {
        this.editor = null;
        arguments.callee.applySuper( this, arguments );
    },


    /* events */    
    
    eventMouseDown: function( event ) {
        event.stop();
    },

    
    eventClick: function( event ) {
        var command = this.getMouseEventCommand( event );
        if( command ) {  
            switch( command ) {
                case "toggleMode":
                    this.editor.toggleMode();
                    this.editor.focus();
                    break;
                    
                case "setModeIframe":
                    this.editor.setMode( "iframe" );
                    this.editor.focus();
                    break;
                
                case "setModeTextarea":
                    this.editor.setMode( "textarea" );
                    this.editor.focus();
                    break;
                    
                case "insertLink":
                    var link = this.editor.getSelectedLink();
                    if( link ) 
                        this.editLink( link );
                    else 
                        this.createLink();
                    break;
                
                default:
                    this.extendedCommand( command, event );
            }
        }  
        return event.stop();
    },
    

    /**
     * class: <code>Editor.Toolbar</code><br/>
     * Extend this method to add click-handler functionality.
     */
    extendedCommand: function( command ) {
        this.editor.execCommand( command );
    },
    

    /* Utilities  */
    /* Toolbar user feature execution */    

    initLinkDataBagUrl: function( dataBag ) {
        if( !dataBag || !dataBag.url || !dataBag.url.trim() )          
            return null;
        dataBag.url = dataBag.url.trim();
        return dataBag;
    },


    /**
     * class: <code>Editor.Toolbar</code><br/>
     * Open the <code>createLink</code> dialog, for creating (or editing) a link.
     */
    createLink: function( url, textSelected, anchor ) {
        var linkedText = "";
        if( !textSelected )
            textSelected = this.editor.isTextSelected();
        if( !url )
            url = "http://";

        url = prompt( Editor.strings.enterLinkAddress, url );
        if( !url )
            return false;
        if( !textSelected ) 
            linkedText = prompt( Editor.strings.enterTextToLinkTo, "" ); 

        this.insertLink( { url: url, linkedText: linkedText, anchor: anchor } );
    },


    /**
     * class: <code>Editor.Toolbar</code><br/>    
     * Edit a pre-existing link in the post.  (This method leverages <code>createLink</code>).
     * @param linkElement <code>Node</code> A DOM element representing an anchor element.
     */ 
    editLink: function( linkElement ) {
        this.createLink( linkElement.href, true, linkElement );
    },


    /**
     * class: <code>Editor.Toolbar</code><br/>
     * Perform final adjustment of data and run the 
     * low-level command to put the link in the editor body.
     * Passively returns if no <code>data</code> or no <code>data.url</code>.
     * @param dataBag <code>Object</code> Must contain the properties: 
     * <code>linkedText<code>, <code>url</code>, and a callback to the <code>insertLink</code> method.  
     */
    insertLink: function( dataBag ) {
        dataBag = this.initLinkDataBagUrl( dataBag );
        if( !dataBag )          
            return;
        if( !dataBag.anchor ) {
            if( dataBag.linkedText  ) {
                var id = "temp_id_for_retrieving_inserted_element_" + Unique.id();
                var html = "<a id='" + id + "'  href='" + dataBag.url + "'>" + dataBag.linkedText + "</a>";
                return this.editor.insertHTML( html, true, id, true );
            } else {
                return this.editor.execCommand( "createLink", false, dataBag.url );
            }
        } else {
            dataBag.anchor.href = dataBag.url;
            return dataBag.anchor;
        }
    }
} );
