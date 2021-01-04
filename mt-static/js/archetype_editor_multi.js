/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
*/

App.singletonConstructor =
MT.App = new Class( MT.App, {

    initEditor: function() {
        var self = this;
        if ( self.constructor.Editor && jQuery('.editor-content') ) {
            var self = this;
            self.editors = {};
            self.editorsInput = {};
            self.editor_ids = [];
            jQuery(".convert_breaks").each(function(){
                var mode = jQuery(this).get(0);
                DOM.addEventListener( mode, "change", self.getIndirectEventListener( "setTextareaMode" ) );

                /* special case */
                window.cur_text_format = mode.value;

                var editor_id = jQuery(this).data('target');
                self.editor_ids.push(editor_id);

                var editorMode = ( mode.value == "richtext" ) ? "iframe" : "textarea";
                self.editors[editor_id] = self.addComponent( new MT.App.Editor( editor_id, editorMode ) );
                self.editors[editor_id].editorMode = editorMode;

                self.editors[editor_id].textarea.setTextMode( mode.value );
                self.currentEditor = editor_id;

                self.editorsInput[editor_id] = DOM.getElement( editor_id + "-content" );

                if ( self.editorsInput[editor_id].value )
                    self.editors[editor_id].setHTML( self.editorsInput[editor_id].value );
            })
        }
        self.editor = self.editors[ self.editor_ids[0] ];
        jQuery('button.publish,button.preview').on('click', function(event) {
          self.saveHTML( true );
        });
    },
    setEditor: function( name ) {
        this.saveHTML( false );
        this.currentEditor = name;
        this.editor = this.editors[name];
        this.editors[name].setHTML( this.editorsInput[ this.currentEditor ].value );
    },
    setTextareaMode: function( event ) {
        this.currentEditor = jQuery(event.target).data('target');
        this.editors[ this.currentEditor ].textarea.setTextMode( event.target.value );
    },
    setEditorIframeHTML: function(field_id) {
        if(this.editors && this.editors[ field_id ]){
            this.currentEditor = field_id;
            this.editor = this.editors[this.currentEditor];
        }
        this.editors[this.currentEditor].setHTML( this.editorsInput[ this.currentEditor ].value );
        this.editors[this.currentEditor].setMode( "iframe" );
        this.editors[this.currentEditor].iframe.focus();
    },
    saveHTML: function( resetChanged ) {
        if ( !this.editor_ids )
            return;

        var self = this;
        self.editor_ids.forEach(function(editor_id){
            self.currentEditor = editor_id;
            self.editor = self.editors[ self.currentEditor ];

            self.fixHTML();

            self.editorsInput[ self.currentEditor ].value = self.editor.getHTML();

            if ( resetChanged )
                self.clearDirty();
        });
    },
    insertHTML: function( html, field ) {
        if(field && this.editors[ field ]){
            this.currentEditor = field;
            this.editor = this.editors[ this.currentEditor ];
        }
        this.fixHTML( this.editor.insertHTML( html ) );
    },
    eventClick: function( event ) {
        var editor_id = jQuery(event.target).parents('.editor-content').attr('id');
        if(editor_id && this.editors){
            this.currentEditor = editor_id;
            this.editor = this.editors[ this.currentEditor ];
        }

        var command = this.getMouseEventCommand( event );
        switch( command ) {

            case "openCategorySelector":
                this.categorySelector.open( event.commandElement )
                break;

            case "closeCategorySelector":
                this.categorySelector.close( event.commandElement );
                break;

            /* editor commands */
            case "setModeTextarea":
                this.editor.setMode( "textarea" );
                break;

            case "setModeIframe":
                this.editor.setMode( "iframe" );
                break;

            case "doRemoveItems":
                /* only used for entry edit */
                var form = DOM.getFirstAncestorByTagName( event.target, "form", true );
                if ( !form )
                    return;

                var e = event.target;
                var return_args = '__mode=list&amp;_type='
                    + e.getAttribute( "mt:object-type" )
                    + '&amp;blog_id='
                    + e.getAttribute( "mt:blog-id" );
                if (e.hasAttribute('mt:subtype'))
                    return_args += '&amp;type='
                        + e.getAttribute('mt:subtype');
                if( !doRemoveItems(
                        form,
                        e.getAttribute( "mt:object-singular" ),
                        e.getAttribute( "mt:object-plural" ),
                        false,
                        {
                            'return_args': return_args
                        } ) )
                    return event.stop();
                break;

            case "openCalendarCreatedOn":
                this.calendar.open(
                    {
                        date: DOM.getElement( "created-on" ).value
                        + 'T'
                        + DOM.getElement( "entry_form" ).elements['authored_on_time'].value
                        + 'Z'
                    },
                    this.getIndirectMethod( "handleCreatedOnDate" ),
                    event.commandElement
                );
                break;

            default:
                if (command) {
                    var calendarFields = command.match( /openCalendar(.+)/ );
                    if (calendarFields) {
                        var fieldName = calendarFields[1];
                        fieldName = fieldName.replace( /^Xxx_/, "d_" );
                        if (!fieldName) break;
                        this['handle' + fieldName ] = function ( date ) {
                            if ( !date )
                                return;

                            DOM.getElement( fieldName ).value
                                = date.toISOString().replace( /^(.+)T.*/, "$1" );

                            this.changed = true;
                        };
                        this.calendar.open(
                            {
                                date: DOM.getElement( fieldName ).value
                            },
                            this.getIndirectMethod( "handle" + fieldName ),
                            event.commandElement
                        );
                        break;
                    }
                }
                return arguments.callee.applySuper( this, arguments );

        }
        return event.stop();
    },
    // override
    eventSubmit: function( event ){}
} );


MT.App.Editor = new Class( Editor, {


    setChanged: function() {
        this.changed = true;
        log('changed');
        app.setDirty();
    },
} );


MT.App.Editor.Toolbar = new Class( Editor.Toolbar, {


    eventClick: function( event ) {
        var command = this.getMouseEventCommand( event );
        if ( !command )
            return event.stop();

        switch( command ) {

            case "insertEmail":
                var link = this.editor.getSelectedLink();
                if ( link )
                    this.editEmail( link );
                else
                    this.createEmailLink();
                break;

            case "openDialog":
                app.openDialog( event.commandElement.getAttribute( "mt:dialog-params" ) );
                break;

            case "openFlyout":
                var name = event.commandElement.getAttribute( "mt:flyout" );
                var el = DOM.getElement( name );
                if ( !defined( el ) )
                    return;

                app.closeFlyouts( event.target );

                DOM.removeClassName( el, "hidden" );
                app.targetElement = event.target;
                app.applyAutolayouts( el );
                app.targetElement = null;

                app.openFlyouts.add( name );

                break;

            default:
                return arguments.callee.applySuper( this, arguments );

        }

        return event.stop();
    },


    editEmail: function( linkElement ) {
        this.createEmailLink( linkElement.href, true, linkElement );
    },


    mailtoRegexp: /^mailto:/i,

    createEmailLink: function( url, textSelected, anchor ) {
        var linkedText = "";
        if( !textSelected )
            textSelected = this.editor.isTextSelected();
        if( !url )
            url = "";

        url = url.replace( this.mailtoRegexp, "" );

        url = prompt( Editor.strings.enterEmailAddress, url );
        if( !url )
            return false;
        if( !textSelected )
            linkedText = prompt( Editor.strings.enterTextToLinkTo, "" );

        this.insertLink( { url: "mailto:" + url, linkedText: linkedText, anchor: anchor } );
    }


} );


MT.App.Editor.Textarea = new Class( Editor.Textarea, {

    currentTextMode: "_DEFAULT_",


    getHTML: function() {
        /* we can refocus the last selected element,
         * because the superClass getHTML will focus the editor (if IE) */
        var refocus;
        if ( document.activeElement )
            refocus = document.activeElement;

        var html = arguments.callee.applySuper( this, arguments );

        try { if ( refocus ) refocus.focus(); } catch(e) { };

        return html;
    },


    setTextMode: function( mode ) {
        var editor_id = this.editor.name;
        var editorContent = DOM.getElement( editor_id + "-content" );
        DOM.removeClassName( editorContent, /^editor-textmode-.*/ );
        if ( this[ mode + "Command" ] )
            DOM.addClassName( editorContent, "editor-textmode-" + mode.replace( /_/g, "-" ) );
        this.currentTextMode = mode;
    },


    execCommand: function( command, userInterface, argument ) {
        if ( this.currentTextMode && this[ this.currentTextMode + "Command" ] ) {
            log('executeing command: ' + command + ' in mode: '+this.currentTextMode );
            this[ this.currentTextMode + "Command" ].apply( this, arguments );
            return;
        }

        var text = this.getSelectedText();
        if ( !defined( text ) )
            text = '';
        switch ( command ) {

            case "fontSizeSmaller":
                this.setSelection( "<small>" + text + "</small>" );
                break;

            case "fontSizeLarger":
                this.setSelection( "<big>" + text + "</big>" );
                break;

            default:
                arguments.callee.applySuper( this, arguments );
                break;
        }
    },



    "markdown_with_smartypantsCommand": function() {
        this.markdownCommand.apply( this, arguments );
    },


    markdownCommand: function( command, userInterface, argument ) {
        var text = this.getSelectedText();
        if ( !defined( text ) )
            text = '';
        switch ( command ) {

            case "bold":
                this.setSelection( "**" + text + "**" );
                break;

            case "italic":
                this.setSelection( "*" + text + "*" );
                break;

            case "createLink":
                this.setSelection( "[" + text + "](" + argument + ")" );
                break;

            case "indent":
                var list = text.split( /\r?\n/ );
                for ( var i = 0; i < list.length; i++ )
                    list[ i ] = "> " + list[ i ];
                this.setSelection( list.join( "\n" ) );
                break;

            case "insertUnorderedList":
            case "insertOrderedList":
                var list = text.split( /\r?\n/ );
                var ordered = ( command == "insertOrderedList" ) ? true : false;
                for ( var i = 0; i < list.length; i++ )
                    list[ i ] = " " + ( ordered ? ( ( i + 1 ) + ". " ) : "-" ) + " " + list[ i ];
                this.setSelection( "\n" + list.join( "\n" ) + "\n" );
                break;
        }
    },


    "textile_2Command": function( command, userInterface, argument ) {
        var text = this.getSelectedText();
        if ( !defined( text ) )
            text = '';
        switch ( command ) {

            case "bold":
                this.setSelection( "**" + text + "**" );
                break;

            case "italic":
                this.setSelection( "_" + text + "_" );
                break;

            case "strikethrough":
                this.setSelection( "-" + text + "-" );
                break;

            case "createLink":
                this.setSelection( '"' + text + '":' + argument );
                break;

            case "indent":
                this.setSelection( "bq. " + text );
                break;

            case "underline":
                this.setSelection( "<u>" + text + "</u>" );
                break;

            case "insertUnorderedList":
            case "insertOrderedList":
                var list = text.split( /\r?\n/ );
                var ordered = ( command == "insertOrderedList" ) ? true : false;
                for ( var i = 0; i < list.length; i++ )
                    list[ i ] = ( ordered ? "#" : "*" ) + " " + list[ i ];
                this.setSelection( "\n" + list.join( "\n" ) + "\n" );
                break;

            case "justifyLeft":
                this.setSelection( "p< " + text );
                break;

            case "justifyCenter":
                this.setSelection( "p= " + text );
                break;

            case "justifyRight":
                this.setSelection( "p> " + text );
                break;

            case "fontSizeSmaller":
                this.setSelection( "<small>" + text + "</small>" );
                break;

            case "fontSizeLarger":
                this.setSelection( "<big>" + text + "</big>" );
                break;
        }
    }

} );



MT.App.Editor.Iframe = new Class( Editor.Iframe, {


    initObject: function() {
        arguments.callee.applySuper( this, arguments );
        this.isWebKit = navigator.userAgent.toLowerCase().match(/webkit/);
    },


    eventFocusIn: function( event ) {
       this.eventFocus( event );
    },


    eventFocus: function( event ) {
        if ( this.editor.mode == "textarea" )
            this.editor.focus();
    },


    eventClick: function( event ) {
        /* for safari */
        if ( this.isWebKit && event.target.nodeName == "A" )
            return event.stop();
        return arguments.callee.applySuper( this, arguments );
    },


    eventKeyPress: function( event ) {
        /* safari forward delete */
        if ( this.isWebKit && event.keyCode == 63272 )
            return event.stop();
    },


    eventKeyDown: function( event ) {
        var code = event.keyCode;
        // shift, control, alt, esc, arrows, home, end
        if (!(code >= 16 && code <= 18) && !(code == 27) && !(code >= 33 && code <= 40)) {
            this.editor.setChanged();
        }
        /* safari forward delete */
        if ( this.isWebKit && code == 46 ) {
            this.document.execCommand( "forwardDelete", false, true );
            return false;
        }
    },

    eventKeyUp: function( event ) {
        /* safari always makes this event. ignore for language input method */
        if ( this.isWebKit ) {
            return false;
        }
    },

    extendedExecCommand: function( command, userInterface, argument ) {
        switch( command ) {

            case "fontSizeSmaller":
                this.changeFontSizeOfSelection( false );
                break;

            case "fontSizeLarger":
                this.changeFontSizeOfSelection( true );
                break;

            default:
                return arguments.callee.applySuper( this, arguments );

        }
    },


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


    changeFontSizeOfSelection: function( bigger ) {
        var bogus = "-editor-proxy";
        this.document.execCommand( "fontName", false, bogus );
        var elements = this.document.getElementsByTagName( "font" );
        for( var i = 0; i < elements.length; i++ ) {
            var element = elements[ i ];
            if( element.face == bogus ) {
                element.removeAttribute( "face" );
                element.style.fontSize = this.mutateFontSize( element, bigger );
            }
        }
    },


    getHTML: function() {
        var html = this.document.body.innerHTML;

        // cleanup innerHTML garbage browser regurgitates
        // #1 - lowercase tag names (open and closing tags)
        html = html.replace(/<\/?[A-Z0-9]+[\s>]/g, function (m) {
            return m.toLowerCase();
        });

        // #2 - lowercase attribute names
        html = html.replace(/(<[\w\d]+\s+)([^>]+)>/g, function (x, m1, m2) {
            return m1 + m2.replace(/\b([\w\d:-]+)\s*=\s*(?:'([^']*?)'|"([^"]*?)"|(\S+))/g, function (x, m1, m2, m3, m4) {
                if ( !m2 ) m2 = ''; // for ie
                if ( !m3 ) m3 = ''; // for ie
                if ( !m4 ) m4 = ''; // for ie
                return m1.toLowerCase() + '="' + m2 + m3 + m4 + '"';
            }) + ">";
        });

        // #3 - close singlet tags for img, br, input, param, hr
        html = html.replace(/<(br|img|input|param)([^>]+)?([^\/])?>/g, "<$1$2$3 />");

        // #4 - get absolute path and delete from converted URL
        var path = this.document.URL;
        path = path.replace(/(.*)editor-content.html.*/, "$1");
        var regex = new RegExp(path, "g");
        html = html.replace(regex, "");
        /* XXX for save on ff */
        regex = new RegExp(path.replace(/~/, "%7E"), "g");
        html = html.replace(regex, "");

        return html;
    }
} );
