

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
                this.categorySelector.open( null, Function.stub, event.commandElement );
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
                return arguments.callee.applySuper( this, arguments );

        }
        return event.stop();
    },

    
    setEditorIframeHTML: function( html ) {
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


MT.App.CategorySelector = new Class( Transient, {
    

    transitory: true,
    opening: false,
    
    
    initObject: function( element, template ) {
        arguments.callee.applySuper( this, arguments );

        this.catForm = DOM.getElement( "add-category-form" );
        this.catInput = DOM.getElement( "add-category-input" );

        this.list = this.addComponent( new List( element + '-list', template ) );
        this.list.setOption( "checkboxSelection", true );
        this.list.addObserver( this );

        if ( element.match( /category/ ) ) {
            this.type = "category";
            this.list.setOption( "singleSelect", false );
            this.list.setOption( "toggleSelect", true );
        } else {
            this.type = "folder";
            this.list.setOption( "singleSelect", true );
            this.list.setOption( "toggleSelect", false );
        }

        this.parentID = 0;
        var cats = MT.App.categoryList;
        var selcats = MT.App.selectedCategoryList;
        var catlen = cats.length;
        var selected = {};
        for ( var i = 0; i < selcats; i++ )
            selected[ selcats[ i ] ] = true;
        for ( var i = 0; i < catlen; i++ )
            this.list.addItem( cats[ i ], selected.hasOwnProperty( cats[ i ] ) );
    },

    
    destroyObject: function() {
        this.list = null;
        this.catForm = null;
        this.catInput = null;
        this.catFormMovable = null;
        arguments.callee.applySuper( this, arguments );
    },


    eventKeyDown: function( event ) {
        if ( event.target.nodeName != "INPUT" )
            return;

        if ( event.keyCode == 13 ) {
            this.createCategory();
            return event.stop();
        }
    },
    
    
    open: function() {
        arguments.callee.applySuper( this, arguments );
        /* hack to keep the broadcast from nuking our list */
        this.opening = true;
        this.list.resetSelection();
        this.opening = false;
        /* this keeps our list order if they made one a primary since the last open */
        this.list.setSelection( MT.App.selectedCategoryList );
    },


    eventClick: function( event ) {
        var command = this.getMouseEventCommand( event );
        switch( command ) {

            case "close":
                this.removeMovable();
                this.close( this.list.getSelectedIDs() );
                break;
            
            case "showAddCategory":
                this.removeMovable();
                /* show the add category block inside the flyout */
                var id = DOM.getMouseEventAttribute( event, "mt:id" );
                if ( id ) {
                    /* adding a sub cat/folder */
                    this.catInput.value = '';
                    DOM.addClassName( this.catForm, "hidden" );
                    var item = this.list.getListElementFromTarget( event.target );
                    this.catFormMovable = document.createElement( "div" );
                    this.catFormMovable.innerHTML = Template.process( "categorySelectorAddForm", { div: this.catFormMovable } );
                    this.list.content.insertBefore( this.catFormMovable, item.nextSibling );
                    this.catInputMovable = DOM.getElement( "add-category-input-movable" );
                    DOM.removeClassName( this.catFormMovable, "hidden" );
                    this.parentID = id;
                    this.catInputMovable.focus();
                } else {
                    DOM.removeClassName( this.catForm, "hidden" );
                    this.catInput.focus();
                }
                break;

            case "cancel":
                this.removeMovable();
                /* hide it */
                DOM.addClassName( this.catForm, "hidden" );
                break;

            case "add":
                /* add a category */
                this.createCategory();
                break;

            default:
                return;

        }
        return event.stop();
    },


    removeMovable: function() {
        this.parentID = 0;
        if ( !this.catFormMovable )
            return;
        this.catFormMovable.parentNode.removeChild( this.catFormMovable );
        this.catFormMovable = undefined;
    },


    createCategory: function() {
        var inputElement = ( this.parentID == 0 )
            ? this.catInput : this.catInputMovable;
        var name = inputElement.value;
        if ( !name || name == "" || name.match( /^\s+$/ ) )
            return;
        
        /* ignore the faded default text that could be in the box */
        var defaultText = inputElement.getAttribute( "mt:default" );
        if ( defaultText && name == defaultText )
            return;

        DOM.addClassName( this.catForm, "hidden" );
        DOM.addClassName( this.catFormMovable, "hidden" );
        this.catInput.value = '';
        
        var args = {
            __mode: "js_add_category",
            magic_token: app.form["magic_token"].value,
            blog_id: app.form["blog_id"].value,
            parent: parseInt( this.parentID ),
            _type: this.type
        };
        args.label = name;
        
        /* hahah, safari crashes during the keydown */
        new Timer( this.getIndirectMethod( "removeMovable" ), 20, 1 );
        
        TC.Client.call({
            load: this.getIndirectMethod( "createCategoryComplete" ),
            error: this.getIndirectMethod( "createCategoryError" ),
            method: 'POST',
            uri: app.form.action,
            arguments: args,
            label: name
        });
    },


    createCategoryComplete: function( c, r, p ) {
        /* {"error":null,"result":{"basename":"foobar","id":7}} */
        log("create category complete "+r+' parent:'+p.arguments.parent );
        if ( r.charAt( 0 ) != "{" )
            return log.error( r );
        var obj = eval( "(" + r + ")" );
        if ( obj.error )
            return log.error( obj.error );
        if ( obj.result && obj.result.id )
            this.addCategory( obj.result.id, p.label, p.arguments.parent );
    },


    createCategoryError: function( c, r ) {
        log.error("error creating category");
    },


    addCategory: function( id, name, parent ) {
        var cat = {
            id: id,
            label: name,
            path: []
        };
        var catlist = MT.App.categoryList;
        parent = parseInt( parent );

        /* single selection, and we're about to select the new folder */
        if ( this.type == 'folder' )
            this.list.resetSelection();

        if ( parent != 0 ) {
            var idx;
            for ( var i = 0; i < catlist.length; i++ )
                if ( parseInt( catlist[ i ].id ) == parent ) {
                    idx = i;
                    parent = catlist[ i ];
                    break;
                }
            if ( !defined( idx ) )
                return log.error( "can't find parent id "+parent.id+" in category list");
            /* get the parents path for our own, and add the parent */
            /* use fromPseudo to copy this array, not take a ref to it */
            cat.path = Array.fromPseudo( parent.path || [] );
            cat.path.push( parent.id );
            catlist.splice( idx, 0, cat );
            /* update the cache */
            app.catCache.setItem( "cat:" + cat.id, cat );
            /* add puts the item at the bottom, so we hide it and move it */
            this.list.addItem( cat, true, "list-item hidden" );
            var div = this.list.getItem( cat.id );
            div.parentNode.removeChild( div );
            var parentItem = this.list.getItem( parent.id );
            /* move it after the parent */
            this.list.content.insertBefore( div, parentItem.nextSibling );
            DOM.removeClassName( div, "hidden" );
        } else {
            catlist.push( cat );
            /* update the cache */
            app.catCache.setItem( "cat:" + cat.id, cat );
            this.list.addItem( cat, true );
        }
        /* recheck selection */
        this.listItemsSelected( this.list );
    },


    listItemsSelected: function( list, ids ) {
        MT.App.selectedCategoryList = Array.fromPseudo( list.getSelectedIDs() );
        app.catList.redraw();
    },


    listItemsUnSelected: function( list, ids ) {
        if ( this.opening || this.type == "folder" )
            return;
        MT.App.selectedCategoryList = Array.fromPseudo( list.getSelectedIDs() );
        app.catList.redraw();
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
                break;
                
            case "openCategorySelector":
                app.categorySelector.open( null, Function.stub, event.commandElement );
                break;

            default:
                return;

        }
        return event.stop();
    }
    

} );

