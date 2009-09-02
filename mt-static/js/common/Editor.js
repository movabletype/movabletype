/*
Editor Library
$Id: Editor.js 201 2007-05-29 22:51:10Z ddavis $

Copyright (c) 2005, Six Apart, Ltd.
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


Editor = new Class( Component, {
    changed: false,
    
    
    init: function( element, mode ) {
        arguments.callee.applySuper( this, arguments );
        this.setMode( mode || "iframe" );
    },
    
    
    initComponents: function() {
        arguments.callee.applySuper( this, arguments );
        
        this.iframe = new this.constructor.Iframe( this.element.id + "-iframe", this );
        this.addComponent( this.iframe );

        this.textarea = new this.constructor.Textarea( this.element.id + "-textarea", this );
        this.addComponent( this.textarea );
        
        this.toolbar = new this.constructor.Toolbar( this.element.id + "-toolbar", this );
        this.addComponent( this.toolbar );
    },
    
        
    destroyObject: function() {
        this.toolbar = null;
        this.textarea = null;
        this.iframe = null;
        arguments.callee.applySuper( this, arguments );
    },
    
    
    toggleMode: function() {
        return this.setMode( this.mode == "iframe" ? "textarea" : "iframe" );
    },
    
    
    setMode: function( mode ) {
        if( mode == this.mode )
            return;
        log( "setting mode " + mode );
        var html = this.actual ? this.actual.getHTML() : null;
        this.setModeActual( mode );
        if ( defined( html ) && html != null )
            this.actual.setHTML( html );
        this.reflow();
        return html;
    },
    
    
    setModeActual: function( mode ) {
        if( mode != "iframe" && mode != "textarea" )
            throw "Unknown editor mode " + mode;
        this.mode = mode;
        this.actual = this[ this.mode ];
        return this.actual;
    },
    
    
    reflow: function() {
        DOM.removeClassName( this.element, /editor-mode-/ );
        DOM.addClassName( this.element, "editor-mode-" + this.mode );
        arguments.callee.applySuper( this, arguments );
    },


    updateToolbar: function() {},


    getKeyEventCommand: function( event ) {
        var c = ( String.fromCharCode( event.charCode || event.keyCode ) || "" ).toUpperCase();
        
        if( (event.metaKey || event.ctrlKey) && !event.shiftKey && !event.altKey ) {
            switch( c ) {
                case "B": return "bold";
                case "I": return "italic";
                case "U": return "underline";
                case "Z": return "undo";
                case "Y": return "redo";
            }
        } else if( (event.metaKey || event.ctrlKey) && event.shiftKey && !event.altKey ) {
            switch( c ) {
                case "Z": return "redo";
            }
        }
    },

    
    execCommand: function( command, userInterface, argument ) {
        this.setChanged();
        return this.actual.execCommand( command, userInterface, argument );
    },
    

    editLink: function( link ) {
        this.toolbar.editLink( link );
    },
    
    
    focus: function() {
        this.actual.focus();
    },

    
    getHTML: function() {
        return this.actual.getHTML();
    },


    setHTML: function( html ) {
        return this.actual.setHTML( html );
    },

    
    insertHTML: function( html, select, id, isTempId ) {
        this.setChanged();
        return this.actual.insertHTML( html, select, id, isTempId );
    },
    
    
    // REFACTOR
    isTextSelected: function( selection ) {
        return this.actual.isTextSelected();
    },

    
    // REFACTOR
    getSelectedLink: function() {
        return this.actual.getSelectedLink();
    },


    setChanged: function() {
        this.changed = true;
    }


} );


Editor.strings = {
    enterLinkAddress: "Enter the link address:",
    enterTextToLinkTo: "Enter the text to link to:"
};
