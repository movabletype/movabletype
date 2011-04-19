/*
Dialog Library
$Id: Dialog.js 159 2007-04-24 01:05:37Z ydnar $

Copyright (c) 2006, Six Apart, Ltd.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

    * Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above
copyright notice, this list of conditions and the following disclaimer
in the documentation and/or other materials provided with the
distribution.

    * Neither the name of "Six Apart" nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

Dialog = {};


/* modal message dialog subclass */

Dialog.Message = new Class( Modal, {

    /* events */

    /**
     * Class: <code>Dialog.Message</code><br/>
     * Uses <code>getMouseEventCommand</code> to close the dialog if the user has clicked 'ok'.
     * @param event  <code>Event</code> A prepared event object.
     */    
    eventClick: function( event ) {
        var command = this.getMouseEventCommand( event );
        if( !command )
            return;
        command = (command == "ok" ? true : false);
        event.stop();
        this.close( command );
    },
    

    /**
     * Class: <code>Dialog.Message</code><br/>
     * This method allows a <code>Dialog.Message</code> to disappear on keypress of 'esc' (cancels the 
     * dialog action, just like clicking 'cancel' would do) (closes with a value of <code>false</code>), 
     * cancel on keypress of the 'Cancel' button (mouseEventCommand 'cancel') (closes with a value 
     * of <code>false</code>), or close with a value of <code>true</code> (i.e., user presses
     * 'enter' key over the 'ok'/'yes' button) (no mouseEventCommand needed).
     * @param event <code>Event</code>  A prepared (processed by the custom js framework) 
     *              <code>Event</code> object.
     */
    eventKeyPress: function( event ) {
        switch( event.keyCode ) {
            case 13:
                var command = this.getMouseEventCommand( event ); // Handle 'Confirm'-type dialgs.
                event.stop();
                if( command == "cancel" )                    
                    this.close( false );
                else 
                    this.close( true );
                break;
            case 27:
                event.stop();
                this.close( false ); 
        }
    },


    /* execution */
    
    /**
     * Class: <code>Dialog.Message</code><br/>
     * Set the basic customizable properties of the dialog and show it to the user.
     * @param data <code>Object</code> A basic container object for the <code>innerHTML</code> of
     *                                 the message dialog.
     * @param callback <code>function</code> A function/bound-method callback invoked with the arguments 
     *                                       '<code>data</code>, <code>this</code>' when the dialog is closed.
     */
    open: function() {
        arguments.callee.applySuper( this, arguments );
        if( typeof this.data == "string" )
            this.data = { message: this.data };
        var e = DOM.getElement( this.element.id + "-message" );
        if( e )
            e.innerHTML = this.data.message;
    }
} );


/* simple serializing dialog */

Dialog.Simple = new Class( Modal, {
    
    inputBlacklist: { 
        image: defined,
        submit: defined
    },


    destroyObject: function() {
        this.firstInput = null;
        arguments.callee.applySuper( this, arguments );
    },


    /* events */

    /**
     * Class: <code>Dialog.Simple</code><br/>
     * This method allows a <code>Dialog.Simple</code> to disappear on keypress of 'esc' ( cancels the 
     * dialog action, just like clicking 'cancel' would do) or 'return' (finishes the dialog action, 
     * just as clicking 'ok' would do).
     * @param event <code>Event</code>  A prepared (processed by the custom js framework) <code>Event</code> object.
     */
    eventKeyPress: function( event ) {
        switch( event.keyCode ) {
            case 13:
                if( event.target && event.target.tagName && event.target.tagName.toLowerCase() == "textarea" ) 
                    return true;
                this.data = DOM.getFormData( this.element, this.data );
                this.close( this.data );
                return event.stop();
            
            case 27:          
                this.close( false ); 
        }
    },
    

    /**
     * Class: <code>Dialog.Simple</code><br/>
     * Close the dialog without returning data if the user presses 'cancel'.  Otherwise, close the dialog 
     * and return the form data (see the doc for the method <code>open</code>.
     * @param event <code>Event</code>  A prepared (processed by the custom js framework) <code>Event</code> object.
     */
    eventClick: function( event ) {        
        var command = this.getMouseEventCommand( event );

        switch( command ) {
            case "cancel":
                return this.close( false );
                
            case "ok":
                this.data = DOM.getFormData( this.element, this.data );
                return this.close( this.data );
        }
    },
    

    /**
     * Get the first input element that matters to the application data.
     * @param element <code>Node</code> A dom element.
     * @param data <code>Object</code> 
     * @param firstInput <code>Node</code> MAY BE NULL A reference to the first input element in the form.
     * @return firstInput <code>Node</code> A reference to the first input element in the form.
     */    
    getFirstSpecifiedInput: function( element, data, firstInput ) {

        if( !element.tagName )
            return firstInput;
        if( exists( element.name ) && !data.hasOwnProperty( element.name ) )
            return firstInput;

        var tagName = element.tagName.toLowerCase();
        var type = element.getAttribute( "type" );
        type = type ? type.toLowerCase() : "";
        
        switch( tagName ) {
            case "input":
                if( this.inputBlacklist[ type ] === defined || type == "radio" || type == "checkbox"  )
                    return firstInput;

            case "textarea": // Catches "text" input types too.
            case "select":
                if( !firstInput )
                    firstInput = element;
                return firstInput;
        }

        for( var i = 0; i < element.childNodes.length; i++ ) {
            // Reference types are immutable, so we must assign 'firstInput':
            var firstInput = this.getFirstSpecifiedInput( element.childNodes[ i ], data );
            if( firstInput ) 
                return firstInput;
        }
    },


    setFirstInput: function() {
        if( !this.firstInput )
            this.firstInput = this.getFirstSpecifiedInput( this.element, this.data, null );
    },


    selectFirstInput: function() {
        if( this.firstInput && this.firstInput.select )
            this.firstInput.select();
    },


    focusFirstInput: function() {
        if( this.firstInput ) {
            this.firstInput.focus();
            if( this.firstInput.focusIn )
                this.firstInput.focusIn();    
        }
    },

    /* execution */        

    /**
     * Class: <code>Dialog.Simple</code><br/>
     * Set the basic customizable properties of the dialog and show it to the user.
     * @param data <code>Object</code> A combined setting and getting container object for the form data of
     *                                 the message dialog. <br/>On open, the dialog will set any form elements with 
     *                                 a <code>name</code> property equivalent to a property in <code>data</code>
     *                                 to the value of that property in <code>data</code>.<br/>
     *                                 On close, this dialog loads all form data, regardless of name, into the 
     *                                 <code>data</code> object, creating new properties as needed.
     * @param callback <code>function</code> A function/bound-method callback invoked with the arguments 
     *                                       '<code>data</code>, <code>this</code>' when the dialog is closed.
     */
    open: function( data, callback ) {
        arguments.callee.applySuper( this, arguments );
        if( typeof this.data == "string" )
            this.data = { message: this.data };
        var e = DOM.getElement( this.element.id + "-message" );
        if( e )
            e.innerHTML = this.data.message;
        
        this.firstInput = null;
        DOM.setFormData( this.element, this.data );
        this.setFirstInput();
        this.focusFirstInput();
    }
} );
