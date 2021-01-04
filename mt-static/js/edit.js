/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
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
            if ( DOM.getElement( "folder-selector" ) )
                this.categorySelector = this.addComponent( new this.constructor.CategorySelector( "folder-selector", "categorySelectorList" ) );
            else
                this.categorySelector = this.addComponent( new this.constructor.CategorySelector( "category-selector", "categorySelectorList" ) );
        }

        this.initEditor();

        if ( this.constructor.CategoryList && DOM.getElement( "category-list" ) ) {
            this.catList = new this.constructor.CategoryList( "category-list" );
            this.setDelegate( "categoryList", this.catList );
            this.catList.redraw( this.catCache );
        }

        var cs = DOM.getElement( "open-category-selector1" );
        if ( defined( MT.App.selectedCategoryList ) && MT.App.selectedCategoryList.length == 0 && cs )
            this.categorySelector.open( cs );

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
        if (typeof MT.EditorManager == 'undefined') {
            this.saveHTML( false );
        }
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


    init: function( element, args ) {
        this.element = DOM.getElement( element );

        if ( !args ) args = {};

        this.catCache = args.catCache;
        this.contentFieldId = args.contentFieldId || 0;
        this.multiple = args.multiple;
        this.selectedCategoryList = args.selectedCategoryList || MT.App.selectedCategoryList;
    },


    destroy: function() {
        this.element = null;
    },


    redraw: function( catCache ) {
        if ( !catCache )
            catCache = this.catCache || app.catCache;
        var id = this.contentFieldId ? 'category-ids-' + this.contentFieldId : 'category-ids';
        var el = DOM.getElement( id );
        if ( el )
            el.value = this.selectedCategoryList.join( "," );
        this.element.innerHTML = Template.process( "categoryList", { items: this.selectedCategoryList, cache: catCache, multiple: this.multiple } );
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
        var contentFieldId = DOM.getMouseEventAttribute( event, 'mt:content-field-id' );
        var categorySelector = contentFieldId
            ? app.fieldCategorySelectors[contentFieldId]
            : app.categorySelector;
        var categoryList = contentFieldId
            ? categorySelector.catList
            : this;
        switch( command ) {

            case "primary":
                if ( !defined( id ) )
                    return;
                /* make category primary */
                var idx = categoryList.selectedCategoryList.indexOf( id );
                if ( idx == -1 )
                    return log.error('could not find cat id:'+id);
                categoryList.selectedCategoryList.splice( idx, 1 );
                categoryList.selectedCategoryList.splice( 0, 0, id );
                categoryList.redraw();
                categorySelector.redraw();
                if (contentFieldId) {
                    setDirty(true);
                }
                break;

            case "remove":
                if ( !defined( id ) )
                    return;
                /* remove a category */
                var idx = categoryList.selectedCategoryList.indexOf( id );
                if ( idx == -1 )
                    return log.error('could not find cat id:'+id);
                categoryList.selectedCategoryList.splice( idx, 1 );
                categoryList.redraw();
                categorySelector.redraw();
                if (contentFieldId) {
                    setDirty(true);
                }
                break;

            case "openCategorySelector":
                categorySelector.open( event.commandElement );
                break;

            case "closeCategorySelector":
                categorySelector.close( event.commandElement );
                break;

            default:
                return;

        }
        return event.stop();
    }
} );

