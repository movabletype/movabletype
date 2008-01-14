/*
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
*/

App.singletonConstructor =
MT.App = new Class( MT.App, {


    currentEditor: "content",
    editorMode: "textarea",
    

    initComponents: function() {
        arguments.callee.applySuper( this, arguments );

        var cats;
        if ( this.constructor.CategorySelector && ( cats = MT.App.categoryList ) ) {
            /* cache all the categories */
            this.catCache = new Cache( cats.length + 50 );
            for ( var i = 0; i < cats.length; i++ )
                this.catCache.setItem( 'cat:'+cats[ i ].id, cats[ i ] );
            if ( DOM.getElement( "folder-selector" ) ) {
                this.categorySelector = this.addComponent( new this.constructor.CategorySelector( "folder-selector", "categorySelectorList" ) );
            } else
                this.categorySelector = this.addComponent( new this.constructor.CategorySelector( "category-selector", "categorySelectorList" ) );
        }

        this.initEditor();

        if ( this.constructor.CategoryList && DOM.getElement( "category-list" ) ) {
            this.catList = new this.constructor.CategoryList( "category-list" );
            this.setDelegate( "categoryList", this.catList );
            this.catList.redraw( this.catCache );
        }
        
        if ( DOM.getElement( "calendar" ) )
            this.calendar = new this.constructor.Calendar( "calendar", "calendar" );
    },


    initEditor: Function.stub,

    
    destroyObject: function() {
        this.categorySelector = null;
        this.catList = null;
        this.editor = null;
        this.editorInput = null;
        arguments.callee.applySuper( this, arguments );
    },

    
    eventBeforeUnload: function( event ) {
        if ( this.editor ) {
            if ( this.editor.changed ) 
                this.changed = true;
       
            /* preserve what they changed ( if they hit back ) */
            if ( this.changed )
                this.saveHTML( false );
        }

        return arguments.callee.applySuper( this, arguments );
    },


    eventSubmit: function( event ) {
        var r = arguments.callee.applySuper( this, arguments );
        this.saveHTML( true );
        return r;
    },


    eventClick: function( event ) {
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
                if( !doRemoveItems(
                        form,
                        e.getAttribute( "mt:object-singular" ),
                        e.getAttribute( "mt:object-plural" ),
                        false,
                        {
                            'return_args': '__mode=list_'+e.getAttribute( "mt:object-type" )
                                +'&amp;blog_id='+e.getAttribute( "mt:blog-id" )
                        } ) )
                    return event.stop();
                break;

            case "openCalendarCreatedOn":
                this.calendar.open(
                    {
                        date: DOM.getElement( "created-on" ).value
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

    
    setEditorIframeHTML: function() {
        this.editor.setHTML( this.editorInput[ app.currentEditor ].value );
        this.editor.setMode( "iframe" );
        this.editor.iframe.focus();
    },


    handleCreatedOnDate: function( date ) {
        if ( !date )
            return;

        DOM.getElement( "created-on" ).value
            = date.toISOString().replace( /^(.+)T.*/, "$1" );

        this.changed = true;
    },
    
    
    saveHTML: function( resetChanged ) {
        if ( !this.editor )
            return;
        
        this.fixHTML();

        this.editorInput[ this.currentEditor ].value = this.editor.getHTML();

        if ( resetChanged )
            this.clearDirty();
    },


    clearDirty: function() {
        this.changed = this.editor.changed = false;
    },


    fixHTML: function( inserted ) {
        /* fix firefox's tendency to convert the src attribute to relative */
        /* anchor tag is also similar */
        if ( window.controllers && this.editor.mode == "iframe" ) {
            log.debug('fixing relative path in image tags, and setting contentEditable false');
            var imgs;
            var ancs;
            var forms = [];
            if ( inserted && inserted.getElementsByTagName ) {
                log.debug('using inserted method');
                imgs = inserted.getElementsByTagName( "img" );
                ancs = inserted.getElementsByTagName( "a" );
                forms = inserted.getElementsByTagName( "form" );
                if ( forms )
                    forms = Array.fromPseudo( forms );
                if ( inserted.tagName && inserted.tagName.toLowerCase() == "form" )
                    forms.push( inserted );
            } else {
                log.debug('using iframe method');
                imgs = this.editor.iframe.document.getElementsByTagName( "img" );
                ancs = this.editor.iframe.document.getElementsByTagName( "a" );
                forms = this.editor.iframe.document.getElementsByTagName( "form" );
            }
                
            if ( imgs )
                for ( var i = 0; i < imgs.length; i++ )
                    imgs[ i ].src = imgs[ i ].src;
                
            /* fix links, skiping over any with a anchor */
            if ( ancs )
                for ( var i = 0; i < ancs.length; i++ )
                    if ( !ancs[ i ].href.match( /#/ ) )
                        ancs[ i ].href = ancs[ i ].href;

            if ( forms )
                for ( var i = 0; i < forms.length; i++ )
                    forms[ i ].setAttribute( "contentEditable", false );
        }
    },


    insertHTML: function( html, field ) {
        /* field is ignored now, we have one editor */
        this.fixHTML( this.editor.insertHTML( html ) );
    },


    setEditor: function( name ) {
        this.saveHTML( false );
        this.currentEditor = name;
        this.editor.setHTML( this.editorInput[ this.currentEditor ].value );
    },


    autoSave: function() {
        this.saveHTML( false );
        return arguments.callee.applySuper( this, arguments );
    },


    resizeComplete: function( target, xStart, yStart, x, y, width, height ) {
        arguments.callee.applySuper( this, arguments );

        if ( target.id == "editor-content-enclosure" ) {
            /* TODO remove this, and set the two fields to 100% height */
            var es = [ "editor-content-textarea", "editor-content-iframe" ];
            for ( var i = 0; i < es.length; i++ ) {
                var element = DOM.getElement( es[ i ] );
                if ( !element )
                    continue;
                DOM.setHeight( element, height );
            }
        }
    },


    setTextareaMode: function( event ) {
        this.editor.textarea.setTextMode( event.target.value );
    }


} );


MT.App.CategoryList = new Class( Object, {

    
    init: function( element ) {
        this.element = DOM.getElement( element );
    },


    destroy: function() {
        this.element = null;
    },

        
    redraw: function( catCache ) {
        if ( !catCache )
            catCache = app.catCache;
        var el = DOM.getElement( "category-ids" );
        if ( el )
            el.value = MT.App.selectedCategoryList.join( "," );
        this.element.innerHTML = Template.process( "categoryList", { items: MT.App.selectedCategoryList, cache: catCache } );
    },


    eventMouseOver: function( event ) {
        var target;
        if ( event.target &&
            ( target = DOM.getFirstAncestorByAttribute( event.target, "mt:focus-hover" ) ) )
                DOM.addClassName( target, "focus" );
    },


    eventMouseOut: function( event ) {
        var target;
        if ( event.target &&
            ( target = DOM.getFirstAncestorByAttribute( event.target, "mt:focus-hover" ) ) )
                DOM.removeClassName( target, "focus" );
    },


    eventClick: function( event ) {
        var command = app.getMouseEventCommand( event );
        var id = DOM.getMouseEventAttribute( event, "mt:id" );
        switch( command ) {

            case "primary":
                if ( !defined( id ) )
                    return;
                id = parseInt( id );
                /* make category primary */
                var idx = MT.App.selectedCategoryList.indexOf( id );
                if ( idx == -1 )
                    return log.error('could not find cat id:'+id);
                MT.App.selectedCategoryList.splice( idx, 1 );
                MT.App.selectedCategoryList.splice( 0, 0, id );
                this.redraw();
                app.categorySelector.redraw();
                break;
            
            case "remove":
                if ( !defined( id ) )
                    return;
                id = parseInt( id );
                /* remove a category */
                var idx = MT.App.selectedCategoryList.indexOf( parseInt( id ) );
                if ( idx == -1 )
                    return log.error('could not find cat id:'+id);
                MT.App.selectedCategoryList.splice( idx, 1 );
                this.redraw();
                app.categorySelector.redraw();
                break;
                
            case "openCategorySelector":
                app.categorySelector.open( event.commandElement );
                break;

            case "closeCategorySelector":
                app.categorySelector.close( event.commandElement );
                break;

            default:
                return;

        }
        return event.stop();
    }
    

} );

