

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

        var editorContent;
        if ( this.constructor.Editor && ( editorContent = DOM.getElement( "editor-content" ) ) ) {
            
            var mode = DOM.getElement( "convert_breaks" );
            DOM.addEventListener( mode, "change", this.getIndirectEventListener( "setTextareaMode" ) );

            /* special case */
            window.cur_text_format = mode.value;

            this.editorMode = ( mode.value == "richtext" ) ? "iframe" : "textarea";
            
            this.editor = this.addComponent( new this.constructor.Editor( "editor-content", this.editorMode ) );
            this.editor.textarea.setTextMode( mode.value );

            this.editorInput = {
                content: DOM.getElement( "editor-input-content" ),
                extended: DOM.getElement( "editor-input-extended" )
            };

            if ( this.editorInput.content.value )
                this.editor.setHTML( this.editorInput.content.value );

        }

        if ( this.constructor.CategoryList && DOM.getElement( "category-list" ) ) {
            this.catList = new this.constructor.CategoryList( "category-list" );
            this.setDelegate( "categoryList", this.catList );
            this.catList.redraw( this.catCache );
        }
        
        if ( DOM.getElement( "calendar" ) )
            this.calendar = new this.constructor.Calendar( "calendar", "calendar" );
    },

    
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
                this.editor.setMode("textarea");
                break;

            case "setModeIframe":
                this.editor.setMode("iframe");
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
                
            if ( ancs )
                for ( var i = 0; i < ancs.length; i++ )
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


MT.App.Editor = new Class( Editor, {
    

    setChanged: function() {
        this.changed = true;
        app.setDirty();
    }


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
    

    setTextMode: function( mode ) {
        var editorContent = DOM.getElement( "editor-content" );
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
            
            case "insertUnorderedList":
            case "insertOrderedList":
                var list = text.split( /\r?\n/ );
                var ordered = ( command == "insertOrderedList" ) ? true : false;
                for ( var i = 0; i < list.length; i++ )
                    list[ i ] = ( ordered ? "#" : "*" ) + " " + list[ i ];
                this.setSelection( "\n" + list.join( "\n" ) + "\n" );
                break;

            case "justifyLeft":
                this.setSelection( "< " + text );
                break;

            case "justifyCenter":
                this.setSelection( "= " + text );
                break;

            case "justifyRight":
                this.setSelection( "> " + text );
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
        /* safari forward delete */
        if ( this.isWebKit && event.keyCode == 46 ) {
            this.document.execCommand( "forwardDelete", false, true );
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
        html = html.replace(/<\/?[A-Z]+[\s>]/g, function (m) {
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
        return html;
    }
    // 
    // 
    // getNodeXHTML: function( node ) {
    //     var xhtml = '';
    //     for ( var i = 0; i < node.childNodes.length; i++ ) {
    //         var element = node.childNodes[ i ];
    // 
    //         switch ( element.nodeType ) {
    // 
    //             case Node.ELEMENT_NODE:
    //                 var tag = element.nodeName.toLowerCase();
    //                 var regex = new RegExp( '<' + tag + ' +?([^>]*?)>', 'i' );
    //                 var m = element.parentNode.innerHTML.match( regex );
    //                 xhtml += ( "<" + tag );
    //                 if ( m )
    //                     xhtml += ' ' + m[1].replace( /^\s+/, '' );
    //                 // tags intentionally unsupported:
    //                 //   spacer (proprietary)
    //                 //   frame (only used in standalone documents; not an inline tag)
    //                 //   bgsound (proprietary)
    //                 //   wbr (invalid for xhtml)
    //                 //   embed (proprietary; see http://www.alistapart.com/stories/flashsatay/)
    //                 if ( element.childNodes.length == 0 && tag.match( /^(br|hr|img|input|param)$/ ) )
    //                     xhtml += " />";
    //                 else
    //                     xhtml += '>' + this.getNodeXHTML( element ) + '</' + tag + '>';
    // 
    //                 break;
    // 
    //             case Node.TEXT_NODE:
    //                 if ( !element.nodeValue.match( /^[\r\n\t ]+$/ ) )
    //                     xhtml += element.nodeValue;
    //                 break;
    // 
    //             case 5: // ENTITY_REFERENCE_NODE
    //                 xhtml += "&" + element.nodeName.toLowerCase() + ";"
    //                 break;
    //             
    //         }
    //     }
    //     return xhtml;
    // }

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


Editor.strings.enterEmailAddress = trans('Enter email address:');
Editor.strings.enterLinkAddress = trans('Enter the link address:');
Editor.strings.enterTextToLinkTo = trans('Enter the text to link to:');

