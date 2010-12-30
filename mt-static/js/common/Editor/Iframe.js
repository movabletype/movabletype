/* 
$Id: Iframe.js 271 2009-10-22 01:46:46Z auno $

Copyright Six Apart, Ltd. All rights reserved.
Redistribution and use in source and binary forms is
subject to the Six Apart JavaScript license:

http://code.sixapart.com/svn/js/trunk/LICENSE.txt
*/


Editor.Iframe = new Class( Component, {

    FORMAT_BLOCK_TAG: "div",
    
    /**
     * class: <code>Editor.Iframe</code><br/>
     * @param element <code>Node</code> The dom node to use for the rich-text editor area.
     * @param editor <code>Editor</code> The "manager" of this object.
     */
    initObject: function( element, editor ) {
        arguments.callee.applySuper( this, arguments );
        
        this.editor = editor;
        this.window = this.element.contentWindow;
        this.document = this.element.contentDocument || this.element.contentWindow.document;
        
        if( defined( this.document.body.contentEditable ) )
            this.document.body.contentEditable = true;
        else
            this.document.designMode = "on";
        
        try {
            this.document.execCommand( "useCSS", false, true );
            this.document.execCommand( "styleWithCSS", false, false );
        } catch( e ) {}
        
        // clear out the document completely
        this.document.body.innerHTML = " ";
    },
   
    
    destroyObject: function() {
        this.savedSelection = null;
        this.document = null;
        this.window = null;
        this.editor = null;
        arguments.callee.applySuper( this, arguments );
    },
    

    /* events */

    /**
     * class: <code>Editor.Iframe</code><br/>
     */
    initEventListeners: function() {
        this.addEventListener( this.document, "mousedown", "eventMouseDown", true );
        this.addEventListener( this.document, "mouseup", "eventMouseUp", true );
        this.addEventListener( this.document, "mouseover", "eventMouseOver", false );
        this.addEventListener( this.document, "mouseout", "eventMouseOut", false );
        
        this.addEventListener( this.document, "click", "eventClick", true );
        this.addEventListener( this.document, "dblclick", "eventDoubleClick", true );
        this.addEventListener( this.document, "contextmenu", "eventContextMenu" );       
        
        this.addEventListener( this.document, "keydown", "eventKeyDown", true );
        this.addEventListener( this.document, "keypress", "eventKeyPress", true );
        this.addEventListener( this.document, "keyup", "eventKeyUp", true );
        
        this.addEventListener( this.document, "focus", "eventFocus" );
        this.addEventListener( this.document, "focusin", "eventFocusIn" );
        this.addEventListener( this.window, "blur", "eventBlur" );
        this.addEventListener( this.element, "beforedeactivate", "eventBeforeDeactivate" );
    },
    
    
    /**
     * class: <code>Editor.Iframe</code><br/>
     * See the class-level jsdoc on this event. 
     * @param event  <code>Event</code> A prepared event object.
     */
    eventBlur: function( event ) {
        this.saveSelection();
    },
    

    /**
     * class: <code>Editor.Iframe</code><br/>
     * See class-level jsdoc on this event.
     * @param event  <code>Event</code> A prepared event object.
     */
    eventBeforeDeactivate: function( event ) {
        if( event.target !== this.element )
            return;
        this.saveSelection();
    },


    /**
     * class: <code>Editor.Iframe</code><br/>  See doc on <code>this.eventKeyPress</code>.
     * @param event  <code>Event</code> A prepared event object.
     * @return variant <ul>
     *                     <li><code>boolean</code> <code>false</code> if keydown was an 
     *                         application-level command (i.e., save-post). </li>
     *                     <li>. . . or otherwise, <code>undefined</code> if no character deletion was performed</li>
     *                     <li> . . . or otherwise, <code>variant</code> -- the result of the 
     *                          <code>this.captureDelete</code> method</li>
     *                 </ul>
     */
    eventKeyDown: function( event ) {
        if( event.ctrlKey || event.metaKey ) { 
            // Here is a hook to allow the application ('app') responds to its own keybindings.
            var appBinding = app.eventKeyDown ? app.eventKeyDown( event ) : void 0; 
            if( defined( appBinding ) )
                return appBinding;
        }

        this.monitorSelection();
        this.editor.setChanged();
        switch( event.keyCode ) {
            case 8:     // backspace
            case 46:    // delete
                return this.captureDelete( event );
        }
    },


    /**
     * class: <code>Editor.Iframe</code><br/>  This method is used for handling 
     * application-specific event-modifier-key commands, such as save-post.  However, the 
     * specific commands themselves are left up to extending classes of <code>Editor</code>.  
     * The associciated events need to be stopped to prevent them from triggering operating-system specific 
     * actions, such as the save-this-page-as dialog on ('cntrl/cmd-s').                   
     * @param event  <code>Event</code> A prepared event object.
     * @return variant <ul>    
     *                     <li><code>boolean</code> <code>false</code>if a valid Editor command was
     *                         sent in the event (i.e., bold, 
     *                         italic, etc.) or application-level command (i.e., save-post) 
     *                         exists in the key event command</li>
     *                     <li> . . . or otherwise, nothing (result <code>undefined</code>)</li>
     *                 </ul>
     */
    eventKeyPress: function( event ) {
        var command = this.editor.getKeyEventCommand( event );
        if( command ) {
            this.execCommand( command, false, null );
            return event.stop();
        }        
    },


    /**
     * class: <code>Editor.Iframe</code><br/>
     * @param event  <code>Event</code> A prepared event object.
     */
    eventKeyUp: function( event ) {
        this.monitorSelection( event );
    },


    /**
     * class: <code>Editor.Iframe</code><br/>
     * @param event  <code>Event</code> A prepared event object.
     * @return boolean true (always -- for IE 6: Ensure the survival of this event beyond the capturing.)
     */
    eventMouseDown: function( event ) {
        this.monitorSelection( event );
        return true; 
    },
    

    /**
     * class: <code>Editor.Iframe</code><br/>
     * @param event  <code>Event</code> A prepared event object.
     */
    eventMouseUp: function( event ) {
        this.eventClick( event );
    },
   
    
    /**
     * class: <code>Editor.Iframe</code><br/>
     * @param event  <code>Event</code> A prepared event object.
     */
    eventClick: function( event ) {        
        this.monitorSelection( event );
    },


    /* misc */

    /**
     * class: <code>Editor.Iframe</code><br/>
     * @param event  <code>Event</code> A prepared event object.
     */
    focus: function( event ) {
        if( this.element.focus ) { // try-catches silence incorrect NS error on Mozilla (FF 1.5).
            try {
                this.element.focus();
            } catch ( e ) {};
        }     
        if( this.window.focus ) {
            try { 
                this.window.focus();
            } catch ( e ) {};
        }
        this.monitorSelection( event );
    },
    
    
    /* selection */

    /**
     * class: <code>Editor.Iframe</code><br/>
     * @return Selection The current selection in the rich-text editor, or the 
     *                   insertion point (collapsed selection).
     */
    getSelection: function() {
        return DOM.getSelection( this.window, this.document );
    },


    /**
     * class: <code>Editor.Iframe</code><br/>
     * Used for saving the selection on browsers that lose the current selection when
     * a screen element outside of the current selection is clicked/selected.
     */
    saveSelection: function() {
        var selection = this.getSelection();
        if( selection.createRange ) {
            var range = selection.createRange();
            if( range.parentElement ) {
                var element = range.parentElement();
                if( element && element.ownerDocument === this.document ) 
                    this.savedSelection = range.getBookmark();
            }
        } else if( selection.getRangeAt ) 
            this.savedSelection = selection.getRangeAt( 0 ).cloneRange();
    },


    /**
     * class: <code>Editor.Iframe</code><br/>
     */
    restoreSelection: function() {
        this.focus();
        if( !this.savedSelection )
            return;

        var selection = this.getSelection();

        if( selection.createRange ) {        
            var range = this.document.body.createTextRange();        
            range.moveToBookmark( this.savedSelection );
            range.select();
        } else if( selection.getRangeAt ) {
            selection.removeAllRanges();            
            selection.addRange( this.savedSelection );                         
        }   
        
        this.savedSelection = null;
    },


    /**
     * class: <code>Editor.Iframe</code><br/>
     */
    deleteSelection: function() {
        var selection = this.getSelection();
        
        // internet explorer
        if( selection.createRange ) {
            var range = selection.createRange();
            range.execCommand( "delete", false, null );
        }

        // mozilla
        else {
            this.document.execCommand( "delete", false, null );
        }
    },
    

    /**
     * class: <code>Editor.Iframe</code><br/>
     * Keep the insertion point and selection in sane condition.
     * @param event  <code>Event</code> A prepared event object.
     */    
    monitorSelection: function( event ) {
        var selection = this.getSelection();
            
        // mozilla/w3c:
        if( selection.rangeCount ) {
            this.editor.updateToolbar( selection );
            var range = selection.getRangeAt( 0 ).cloneRange();
            var collapsed = range.collapsed;
            
            if( event && event.type == "mousedown" && event.button != 2  ) { // The 'range' methods don't deselect. 
                selection.collapse( selection.anchorNode, selection.anchorOffset ); // Don't do this on right-click
                collapsed = true; 
            }
            // test for immutable elements
            var immutable = DOM.getImmutable( range.startContainer );
            if( immutable ) {
                range.setStartBefore( immutable );
                if( collapsed )
                    range.collapse( true );
                else
                    range.setEndAfter( immutable );
            }
            
            // test for mouseup, setting caret at the end of a link
            else if( collapsed && event && event.type && event.type.match( /keyup|mouseup/ ) ) {
                var arrowKey = "";
                if( event.keyCode == 37 )
                    arrowKey = "left";
                else if( event.keyCode == 39 )
                    arrowKey = "right";     
                this.setCaretOutsideElement( selection, range, arrowKey, event.type.match( /mouseup/ ) );            
            }
            // nada
            else
                return;
         
            // do it
            selection.removeAllRanges();            
            selection.addRange( range );
        } 
        else { // If the user did not type a printing character, update the toolbar button state:
            if( event && event.type.match( /keyup|mouseup/ ) ) { // Note: 'jsc' doesn't work with literal w.s. in literal regexps.
                if( event.keyCode && ( new RegExp( "\\w| " ).test( String.fromCharCode( event.keyCode ) ) ) ) 
                    return;  // ** FIX - regexp above won't work with non-Latin charsets; check range.text.length, etc. instead.
                var updateToolbar = this.editor.getIndirectMethod( "updateToolbar" );
                var callUpdate = function() { updateToolbar( selection ); }; //    IE needs the time; otherwise, 
                new Timer( callUpdate, 400, 1 );       // it sometimes returns the wrong object as the selection.
            }
        }
        
    },
    

    /* immutables */

    /**
     * class: <code>Editor.Iframe</code><br/>
     * @param node <code>Node</code> Any dom node.   
     * @return Node If element is not a text node and meets requirements of method
     *              <code>DOM.isImmutable</code> (<code>null</code> otherwise).
     */
    isContentOrImmutable: function( node ) {
        if( node.nodeType == Node.TEXT_NODE && node.nodeValue.match( /\S/ ) )
            return null;
        if( DOM.isImmutable( node ) )
            return node;
    },


    /**
     * class: <code>Editor.Iframe</code><br/>
     * @param node <code>Node</code> Any dom node.   
     * @return Node (<code>null</code> if none)
     */
    getPreviousImmutable: function( node ) {
        return DOM.Proxy.forPrevious( node, this.isContentOrImmutable );
    },


    /**
     * class: <code>Editor.Iframe</code><br/>
     * @param node <code>Node</code> Any dom node.   
     * @return Node (<code>null</code> if none)
     */
    getNextImmutable: function( node ) {
        return DOM.Proxy.forNext( node, this.isContentOrImmutable );
    },


    /**
     * class: <code>Editor.Iframe</code><br/>
     * Perform deletion in a manner pleasing to the user.
     * @param event  <code>Event</code> A prepared event object.
     * @return variant <ul>
     *                     <li><code>undefined</code> if <code>event.ctrlKey</code> or 
     *                     w3c/mozilla selection</li>
     *                     <li> . . . or otherwise, <code>boolean</code> <code>false</code>.</li>
     *                 </ul>
     */
    captureDelete: function( event ) {
        var selection = this.getSelection();
        if( event.ctrlKey )
            return; // Control deletes/backspaces work fine natively.
   
        // internet explorer control selection
        if( selection.type == "Control" ) 
            this.deleteSelection();
        
        // internet explorer zero-width text selection
        else if( selection.createRange && selection.type == "None" ) {
            var range = selection.createRange();
            var bookmark = range.getBookmark();

            // - - - - Prep range for deletion:
            if( event.keyCode == 8 || event.keyCode == 46 ) { // backspace is 8; delete is 46.
                var vector = event.keyCode == 8 ? -1 : 1;
                var originalText = range.text;
                range.moveStart( "character", vector ); 
                // Avoid getting stuck behind a block-level element: If not on text, go into fight-IE-to-the-death mode:
                if( vector == -1 && !range.text.length ) { 
                    range.moveStart( "character", vector ); // Pegged!
                    if( range.text.length ) // Catch-and-release if in a block level element containing text. 
                        range.moveStart( "character", ( -1 ) * vector );
                    var nonCharDelete = true;
                }
            }
            range.select();

            // - - - - Do deletion:
            selection = this.getSelection();
            if( selection.type == "Control" || nonCharDelete ) { // Handle non-characters and hard-to-delete situ's:
                //                                 .*.
                //      Nuke!                 '''*((@))*'''        
                this.deleteSelection(); // .  . ' ._|_. ' .  .   
                range.select(); // Needed to avoid cursor jumping after deletion.
            } else { // Easy deletions: Handle deletion/backspace of a character and other situations:
                if( vector == 1 ) { // IE needs a helping-hand with forward-delete:
                    range.moveToBookmark( bookmark ); 
                    range.select();
                } else if( range.text == originalText ) { // Avoid forward-deleting on backspace at top of post:
                    range.collapse( true ); // Keeps the selection easy for IE to handle (avoid lock-up). 
                    return false;
                } // Catch-all for the easy deletions:
                this.document.execCommand( "delete", false, null );  
            }            
        }

        // mozilla
        else if( selection.getRangeAt ) {
            if( !selection.isCollapsed )
                return;

            var range = selection.getRangeAt( 0 );
            var node = range.startContainer;
            var offset = range.startOffset;

            var immutable;

            // backspace
            if( event.keyCode == 8 && ( node.nodeType != Node.TEXT_NODE || offset == 0 ) ) {
                immutable = this.getPreviousImmutable( node );
                try {
                    if( immutable )
                        range.setStartBefore( immutable );
                } catch( e ) {}
            }

            // delete
            else if( event.keyCode == 46 && ( node.nodeType != Node.TEXT_NODE || 
                     offset == node.nodeValue.length ) ) {
                immutable = this.getNextImmutable( node );
                try {
                    if( immutable )
                        range.setEndAfter( immutable );
                } catch( e ) {}
            }

            // set the selection to enclose the immutable 
            if( immutable ) {
                selection.removeAllRanges();
                selection.addRange( range );
                this.deleteSelection(); // let mozilla handle deletion?
            }
            
            return;
        }
        
        // anything else
        else
            this.document.execCommand( "delete", false, null );
        
        // we own these keys
        return event.stop();
    },
    
    
    /* html filtering */

    /**
     * class: <code>Editor.Iframe</code><br/>
     * @return string The html "behind" the display in the rich-text editor area.
     */    
    getHTML: function() {    
        var html = this.document.body.innerHTML;
        return html;
    },


    /**
     * class: <code>Editor.Iframe</code><br/>
     * Set all the html of the rich-text editor.
     * @param html <code>string</code> The html to set.
     */
    setHTML: function( html ) {
        this.formatBlock(); // bugid: 39059
        this.document.body.innerHTML = html;
    },


    /**
     * class: <code>Editor.Iframe</code><br/>
     * @param html <code>string</code> The html to insert at point.
     * @param select <code>boolean</code> OPTIONAL Whether or not to select the inserted html (works on 
     * text selections only).
     * @param id <code>string</code> OPTIONAL Only needed and used on IE (6 at this time).
     *           An i.d. to use to retrieve the inserted element, used if 
     *           element cannot be found via the <code>selection</code> object (as is the case on IE 6 
     *           when pasting in an html element).
     * @param isTempId <code>boolean</code> OPTIONAL If <code>true</code>, remove the <code>id</code> 
     *                 attribute supplied above after the method is done using it.
     * @return Node An object that is the inserted element.
     */
    insertHTML: function( html, select, id, isTempId ) { 
        this.beginCommand();
        this.restoreSelection();
        var selection = this.getSelection();
        var inserted = null;
        if( selection.createRange ) { // Internet Explorer (IE)
            var range = selection.createRange();
            if( selection.type == "None" || selection.type == "Text" ) {
                try {
                    range.pasteHTML( html );
                } catch ( err ) {
                    log( "Error pasting html on selection of type 'Text' or 'None': " + err );                
                }
                if( defined( id ) ) {
                    inserted = this.document.getElementById( id );
                    if( select ) 
                        range.moveToElementText( inserted );                        
                } else {
                    if( range.moveStart ) {
                        range.moveStart( "character", ( ( html.length ) * ( -1 ) ) );                            
                        inserted = range.parentElement();
                    }
                }
                if( select ) 
                    range.select();
            } else { // IE 'Control' selection    
                range.item( 0 ).outerHTML = html; // Not perfect but much better than nothing.               
                inserted = range.item( 0 ); 
            }
        }
 
        // mozilla: Try to use w3c "range" methods where possible instead of proprietary "selection" methods.
        else if( selection.getRangeAt ) {
            var range;
            if( selection.rangeCount )
                range = selection.getRangeAt( 0 );
            else {
                range = this.document.createRange();
                range.setStart( this.document.body, 0 );
                range.setEnd( this.document.body, 0 );
                selection.addRange( range );
            }
            var anchor = range.startContainer;

            // Enable the user to set caret after inserted element by clicking there:
            if( selection && range && this.isCaretAtEnd( selection, range ) ) { 
                var paragraph = this.document.createElement( this.FORMAT_BLOCK_TAG );
                paragraph.insertBefore( this.document.createElement( "br" ), null );
                this.document.getElementsByTagName( "body" )[ 0 ].insertBefore( paragraph, null );
            } 

            if( select && anchor.nodeType == Node.TEXT_NODE && !html.match( /<[a-z][a-z]*\s/i ) ) { // Consider improving.           
                range.setStart( anchor, selection.anchorOffset );
                var insertNode = this.document.createTextNode( html );
                range.insertNode( insertNode );
                var inserted = insertNode;
            } else {
                var pS = anchor.previousSibling; // Cache for check below:
                var nS = anchor.nextSibling;
                var m = html.match(/^(<.*(?:src|href)=")(.[^"]*)(".*>)$/) || null;
                if ( m ) html = m[1]+'####'+m[3];
                this.document.execCommand( "insertHTML", false, html );
                if ( m ) { // FireFox sets the relative path to innerHTML, so replace it to original path.
                    var html = this.document.body.innerHTML;
                    html = html.replace(/####/, m[2]);
                    this.document.body.innerHTML = html;
                }
                if( pS !== anchor.previousSibling ) // We simply check what changed to find the target to select.
                    inserted = anchor.previousSibling;
                else if( nS !== anchor.nextSibling )   
                    inserted = anchor.nextSibling;
                else 
                    inserted = anchor.firstChild;                 
            }

            if( defined( id ) ) // Final optional override of 'inserted' value:
                inserted = this.document.getElementById( id );
            if( inserted && inserted.tagName && inserted.tagName.toLowerCase() == "a" ) 
                this.tagJustInserted = true; // See class-level jsdoc.
            if( select ) {
                range.selectNode( inserted );
                this.monitorSelection(); // Required for Mozilla for proper arrow keys on highlighted link.
            }
            selection.addRange( range );        
        }

        if( isTempId && inserted ) {
            inserted.id = undefined; // For IE 6.     
            inserted.removeAttribute( "id" );
        }

        this.endCommand();

        return inserted; 
    },


    /**
     * class: <code>Editor.Iframe</code><br/>
     * Set the caret outside of the first inline ancestor element, if any, of the starting container of the 
     * first range in the current selection <em>if</em> the user has tried (via the arrow or mousebutton)
     * to get out of the element.  For example, put the caret outside of a link (anchor element)
     * when the user is at an edge of the link.  This method is needed since FF 1+ will not otherwise easily
     * "end" hyperlinks and other inline containers as the user is typing.
     * @param selection <code>Selection</code>  The current selection.
     * @param range <code>Range</code> OPTIONAL The first range from the current selection
     * @param arrowKey <code>String</code> OPTIONAL If supplied, value must be 'left' or 'right'.  As a workaround
     *                 for FF 1.5, when 'tagJustInserted' is <code>true</code> (see jsdoc above), method will
     *                 put the caret to the side specified by 'arrowKey' of the first inline ancestor element, if any. 
     * @param mouseUp <code>boolean</code> OPTIONAL Whether the user has just moused-up.  
     */
    setCaretOutsideElement: function( selection, range, arrowKey, mouseUp ) {
        if( selection.rangeCount ) { // w3c (Mozilla, etc) 
            if( !range ) 
                range = selection.getRangeAt( 0 ).cloneRange();

                var node = range.startContainer;
                var nodeLength = node.data ? node.data.length : node.childNodes.length;                
                var element = this.getFirstAncestorElementByDisplayType( node, true, true );           
     
                if( element && DOM.isInlineNode( element ) ) {
                    if( !arrowKey && !mouseUp )
                        return;
                    if( ( ( arrowKey == "left" && this.tagJustInserted ) || range.startOffset == 0 ) && 
                        !node.previousSibling ) { // 'tagJustInserted' is a workaround for FF 1.5; see jsdoc above.
                        var t = ( element.previousSibling && element.previousSibling.nodeType == Node.TEXT_NODE )
                                ? element.previousSibling : element.ownerDocument.createTextNode( "" );
                        element.parentNode.insertBefore( t, element );
                        range.setStart( t, t.data.length );
                        range.collapse( true );
                    } else if( ( ( arrowKey == "right"  && this.tagJustInserted )  || 
                                   range.endOffset >= nodeLength ) && !node.nextSibling ) {
                        var t = ( element.nextSibling && element.nextSibling.nodeType == Node.TEXT_NODE )
                                ? element.nextSibling : element.ownerDocument.createTextNode( "" );
                        element.parentNode.insertBefore( t, element.nextSibling );
                        range.setEnd( t, 0 );
                        range.collapse( false );
                    }                        
                }
            }
    },

    
    isCaretAtEnd: function( selection, range ) {
        var focusNode = range.endContainer;

        // Return 'false' if there exists a following node:    
        if( focusNode.nextSibling )
            return false;
        var node = focusNode;
        while ( node && node.parentNode && 
                ( !node.parentNode.tagName || node.parentNode.tagName.toLowerCase() != "body" ) ) {
            node = node.parentNode;
            if( node.nextSibling )
                return false;
        }    
        
        if( focusNode.nodeType == Node.TEXT_NODE ) { 
            if( range.endOffSet < focusNode.nodeValue.length )
                return false; // 'false' if text node and not at end of text.
        }

        return true;
    },


    getFirstAncestorElementByDisplayType: function( element, inline, includeSelf ) {
        var ancestors = DOM.getAncestors( element, includeSelf );
        for( var i = 0; i < ancestors.length; i++ ) {
            if( ancestors[ i ].nodeType == Node.TEXT_NODE )
                continue;     
            if( inline && DOM.isInlineNode( ancestors[ i ] ) || 
                 !inline && !DOM.isInlineNode( ancestors[ i ] ) )                          
                return ancestors[ i ];
        }
    },
    
    
    isTextSelected: function() { 
        var selection = this.getSelection();
        if( !selection )
            return;
        if( (selection.type && selection.type == "Text") ||     // IE 6
            (selection.toString && (selection + '').length) )   // w3c 
            return true;
    },
    
    
    getSelectedLink: function() {
        var selection = this.getSelection();
        var selectionRange = new SelectionRange( selection );
        return DOM.getFirstAncestorByTagName( selectionRange.getCommonAncestorContainer(), "a" ) ||
            DOM.filterElementsByTagName( selectionRange.getNodes(), "a" )[ 0 ];
    },


    /* commands */

    /**
     * class: <code>Editor.Iframe</code><br/>
     * Prepares the <code>body</code> element with the appropriate css classname.
     */
    beginCommand: function() {
        DOM.addClassName( this.document.body, "editor-transient" );
    },


    /**
     * class: <code>Editor.Iframe</code><br/>
     * Removes the appropriate css classname from the <code>body</code> element.
     */
    endCommand: function() {
        DOM.removeClassName( this.document.body, "editor-transient" );
    },


    /**
     * class: <code>Editor.Iframe</code><br/>
     * @param command  <code>string</code> A valid rich-text-editor command identifier.  These can be
     * either application-specific (non-native) commands, or native commands.  The native commands are
     * identified and defined in the user-agent OEM <a 
     * href="http://msdn.microsoft.com/workshop/author/dhtml/reference/commandids.asp">documentation</a>
     * on msdn.com for the Internet Explorer browser, which is a de-facto standard followed by the other
     * rich-text editor, and in the Mozilla <a 
     * href="http://www.mozilla.org/editor/midas-spec.html">Midas documentation.</a><br/>
     * Note:   The result of the execCommand operation does return a boolean value (<code>true</code> if 
     * successful), but this is not wired currently. 
     * @param userInterface  <code>boolean</code> See the documentation linked above.
     * @param argument  <code>string</code>  See the documentation linked above. 
     */
    execCommand: function( command, userInterface, argument ) {
        this.beginCommand();
        this.restoreSelection(); 
        
        log( command );
        
        switch( command ) {
            case "unlink":
                this.commandUnlink( argument );
                break;
            
            case "createLink":
                if( command == "createLink" ) {
                    var selection = this.getSelection();            
                    this.tagJustInserted = true; // See jsdoc.
                }
            
            default:      
                this.extendedExecCommand( command, userInterface, argument );
        }
        
        this.monitorSelection();        
        this.endCommand();            
        this.editor.setChanged();
    },


    /**
     * Override this method with extended <code>execCommand</code> functionality, if any.
     * @param command  <code>string</code> A valid rich-text-editor command identifier.  See the 
     *                 documentation of the <code>execCommand</code> method.
     * @param userInterface  <code>boolean</code> See the documentation linked above.
     * @param argument  <code>string</code>  See the documentation linked above. 
     */
    extendedExecCommand: function( command, userInterface, argument ) {      
        this.document.execCommand( command, userInterface, argument );
    },
    
    
    commandUnlink: function( argument ) {
        var element = this.getSelectedLink();
        if( !element )
            return false;
        
        var selection = this.getSelection();
        if( selection.getRangeAt ) {
            var range = selection.getRangeAt( 0 );
            range.selectNode( element ); 
        } else if( element.select )
            element.select();
        
        this.document.execCommand( "unlink", false, null );
    },
    

    formatBlock: function() {
        this.document.execCommand( "formatBlock", false, this.FORMAT_BLOCK_TAG ); 
    }
} );
