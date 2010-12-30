/*
List Controller Component
$Id: List.js 209 2007-06-01 19:21:10Z ddavis $

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


List = new Class( Component, {
    
    /* options that can be set with setOption() */
   /* TODO document these
    * Options for list:
    * - disableUnSelect
    * - viewMode
    * - magnifierElement
    * - enableMagnifier
    * - magnifyDelay
    * - singleselect
    * - updateCache
    * - cacheObject
    * - perPage
    * - noClickSelection
    * - hoverDelay
    * - checkboxSelection
    * - selectLimit
    */
    disableUnSelect: false,
    viewMode: "tile",
    enableMagnifier: false,
    magnifierElement: null,
    magnifyDelay: 100,
    singleSelect: false,
    updateCache: false,
    cacheObject: null,
    perPage: 30,
    noClickSelection: false,
    hoverDelay: 100,
    checkboxSelection: false,
    selectLimit: 0, /* no limit */
    
    
    activatable: true,
    flyoutClasses: [
        "flyout-left",
        "flyout-right",
        "flyout-top",
        "flyout-bottom"
    ],
        

    initObject: function( element, templateName ) {
        arguments.callee.applySuper( this, arguments );
        
        this.content = DOM.getElement( element + "-content" );
        
        if ( !this.content )
            this.content = this.element;
        
        if ( !templateName )
            throw "List now takes an element, and a template as arguments";

        this.templateName = templateName;
        /* list of items assigned ids */
        this.selected = [];
        this.focused = false;
        /* list of ids to item list position */
        this.itempos = {};
        /* ordered list of dom elements */
        this.items = [];
        /* ids that shouldn't be selected visibly */
        this.unselectable = {};
        this.lastselected = null;
        /* Used for hover-effect delay functionality */
        this.hoverElement = null;
        this.hoveredElement = null;
        this.hoverTimer = null;

        this.cacheObject = null;

        this.currentPage = 1;
    },
    
    
    destroyObject: function() {
        this.selected.length = 0;
        this.selected = null;
        this.items.length = 0;
        this.items = null;
        this.unselectable = null;
        this.content = null;
        this.hoverElement = null;
        this.hoveredElement = null;
        this.magnifierElement = null;
        this.magnifierElementContent = null;
        this.cacheObject = null;
        arguments.callee.applySuper( this, arguments );
    },

    
    initEventListeners: function() {
        arguments.callee.applySuper( this, arguments );
        
        /* enable mouse scroll */
        this.addEventListener( this.element, "DOMMouseScroll", "eventDOMMouseScroll" );

        /* stop ie text selection */
        /* moz uses a css tag */
        DOM.addEventListener( this.element, "selectstart", Event.stop );
    },


    clearHover: function() {  
        if ( this.hoverElement ) 
            DOM.removeClassName( this.hoverElement, "list-item-hover" );
        this.hoverElement = null;
        if ( this.hoverTimer ) 
            this.hoverTimer.destroy();
        this.hoverTimer = null;
    },


    clearHovered: function() {  
        if ( this.hoveredElement ) 
            DOM.removeClassName( this.hoveredElement, "list-item-hover" );      
    },


    /**
     * This method invokes the superclass method of the same name, and removes any active hover effects.
     */
    deactivate: function() {
        arguments.callee.applySuper( this, arguments );
        this.clearHover();
    },


    setOption: function( opt, value ) {
        switch ( opt ) {
            case "magnifierElement":
                if ( !value )
                    break;
                    
                this.magnifierElement = $( value );
                if( !this.magnifierElement )
                    break;
                
                this.magnifierElementContent = $( value + '-content' );
                if ( !this.magnifierElementContent )
                    this.magnifierElementContent = this.magnifierElement;
                
                /* mouse over hides the magnifier */
                if ( !this.magnifierElement.mouseOverSet ) {
                    var el = this.magnifierElement;
                    DOM.addEventListener( this.magnifierElementContent, "mouseover",
                        function() { DOM.addClassName( el, "hidden" ); } );
                    this.magnifierElement.mouseOverSet = true;
                }
            
                break;

            case "enableMagnifier":
                
                /* force the magnifier to be hidden */
                if ( !value )
                    DOM.addClassName( this.magnifierElement, "hidden" );
                
                this[ opt ] = value;
                
                break;
            case "viewMode":
                DOM.removeClassName( this.element, /^mode-.*/ );
                DOM.addClassName( this.element, "mode-" + value );
                this[ opt ] = value;

                break;
            case "singleselect":
                /* backwards compatable */
                opt = "singleSelect";
                
                /* this needs to fall through here */
            default:
                this[ opt ] = value;
        }
    },

    
    setModel: function( model ) {
        /* clean up the old model */
        if ( this.model )
            this.model.removeObserver( this );
        this.model = model;
        this.model.addObserver( this );
        this.retrieveItems();
    },

    
    getSelectedLength: function() {
        return this.selected.length;
    },
    

    getSelectedIDs: function() {
        return this.selected;
    },


    getFirstSelected: function() {
        return this.selected.length ? this.selected[ 0 ] : null;
    },
   
   
    getSelectedItems: function() {
        var selected = [];
        for ( var i = 0; i < this.selected.length; i++ )
            selected.push( this.items[ this.itempos[ this.selected[ i ] ] ] );
        return selected;
    },
   

    getFirstItem: function() {
        return this.items.length ? this.items[ 0 ] : null;
    },
   
   
    getItem: function( id ) {
        if ( !defined( this.itempos[ id ] ) )
            return null;
        else
            return this.items[ this.itempos[ id ] ];
    },


    getItems: function() {
        return this.items;
    },

    
    getItemIds: function() {
        var ids = [];
        for ( var i = 0; i < this.items.length; i++ )
            ids.push( this.items[ i ].itemId );
        
        return ids;
    },


    replaceItems: function ( items ) {
        /* keep selected items list to re-set those */
        var current = this.selected;
        
        this.resetView();
        
        for ( var i = 0; i < items.length; i++ )
            this.addItem( items[ i ], ( current.indexOf( items[ i ].id ) != -1 ) ? true : false );

        this.broadcastToObservers( "listItemsUpdated", this, false, items );
    },
    

    updateItems: function ( items, classes ) {
        /* keep selected items list to re-set those */
        for ( var i = 0; i < items.length; i++ ) {
            var id = items[ i ].id;
            var pos = this.itempos[ id ];
            var zebra = ( pos % 2 ) ? "even" : "odd";
            
            /* xxx add item if it doesn't exist? */
            if ( !defined( pos ) )
                continue;
            
            var selected = ( this.selected.indexOf( id ) != -1 ) ? true : false;

            /* create element, and process the template */
            var div = document.createElement( "div" );
            div.className = defined( classes ) ? classes : "list-item " + zebra;
            div.innerHTML = Template.process( this.templateName, {
                div: div,
                item: items[ i ],
                is: {
                    selected: selected
                },
                list: this,
                index: pos
            } );
            div.itemId = items[ i ].id;
            
            /* add the class before the replace, and avoid a split second flash */
            if ( selected ) {
                DOM.addClassName( div, "selected" );
                if ( this.checkboxSelection )
                    this.toggleCheckbox( div, true );
            }
            
            this.content.replaceChild( div, this.items[ pos ] );
            this.items[ pos ] = div;
        
            if ( this.updateCache && this.cacheObject )
                this.cacheObject.setItem( items[ i ].id, items[ i ] );
        }
        
        if ( this.items.length )
            this.setListEmpty( false );
        
        this.broadcastToObservers( "listItemsUpdated", this, true, items );
    },


    addItem: function( item, selected, classes ) {
/*        if ( this.items.indexOf( item ) != -1 )
            return;
*/
        
        this.setListEmpty( false );

        var pos = this.items.length;
        var zebra = ( pos % 2 ) ? "even" : "odd";

        var div = document.createElement( "div" );
        div.className = defined( classes ) ? classes : "list-item " + zebra;
        div.innerHTML = Template.process( this.templateName, {
            div: div,
            item: item,
            is: {
                selected: selected
            },
            list: this,
            index: pos 
        } );
        div.itemId = item.id;

        /* fixme special case for chooser, lets fix this */
        if ( defined( item.type ) )
            div.type = item.type;

        /* todo lets do this another way */
        if ( defined( item.unselectable ) && item.unselectable )
            this.unselectable[ item.id ] = true;
        
        this.content.appendChild( div );

        this.items.push( div );
        this.itempos[ item.id ] = pos;
        
        if ( this.updateCache && this.cacheObject )
            this.cacheObject.setItem( item.id, item );
        
        if ( selected ) {
            DOM.addClassName( div, "selected" );
            if ( this.checkboxSelection )
                this.toggleCheckbox( div, true );
            this.selected.add( item.id );
        }
    },
    

    /* xxx this should accept an itemId or dom element */
    removeItem: function( itemid ) {
        if ( !defined( this.itempos[ itemid ] ) )
            return;
        
        log("remove item " + itemid);
        
        this.removeItems( [ itemid ] );
    },


    removeItems: function( items ) {
        var itemids = [];
        for ( var i = 0; i < items.length; i++ ) {
            var idx = this.itempos[ items[ i ] ];
            if ( !defined( idx ) )
                continue;
            
            /* extra check */
            if ( this.items[ idx ].itemId != items[ i ] )
                continue;
            
            this.content.removeChild( this.items[ idx ] );

            if ( this.lastselected == items[ i ] )
                this.lastselected = null;
        
            // recalculate the position index
            var len = this.items.length;
            for ( var j = idx + 1; j < len; j++ )
                this.itempos[ this.items[ j ].itemId ] = ( j - 1 );
        
            this.selected.remove( items[ i ] );
            delete this.itempos[ items[ i ] ];
            this.items.splice( idx, 1 );
        
            if ( this.items.length == 0 )
                this.setListEmpty( true );
            
            itemids.push( items[ i ] );
            
            if ( this.updateCache && this.cacheObject )
                this.cacheObject.deleteItem( items[ i ] );
        }
        
        if ( itemids.length )
            this.broadcastToObservers( "listItemsRemoved", this, itemids );
    },


    reset: function() {
        this.resetView();
        DOM.addClassName( this.element, "list-empty" ); 
    },

    
    resetView: function() {
        this.selected = [];
        this.itempos = {};
        var len = this.items.length;
        for( var i = 0; i < len; i++ )
            this.content.removeChild( this.items[ i ] );
        this.items = [];
        this.lastselected = null;
        this.unselectable = {};
        //this.broadcastToObservers( "listViewReset", this );
        //this.setListEmpty( true );
    },

 
    /* accepts an array of ids */
    setSelection: function( ids, nobcast ) {
        var startlen = this.selected.length;
        var idx;
        var selected = [];
        var e;

        for ( var i = 0; i < ids.length; i++ ) {
            /* you can set selection on items not in the list yet */
            this.selected.add( ids[ i ] );
            idx = this.itempos[ ids[ i ] ];
            if ( defined( idx ) ) {
                e = this.items[ idx ];
                selected.push( e.itemId );
                DOM.addClassName( e, "selected" );
                if ( this.checkboxSelection )
                    this.toggleCheckbox( e, true );
            }
        }
        
        if ( nobcast )
            return;
        
        //this.lastselected = ids[ ( ids.length - 1 ) ];
        // if there are any new selections, then tell the observers
        if ( startlen < this.selected.length && selected.length )
            this.broadcastToObservers( "listItemsSelected", this, selected );
    },


    /* XXX how can we avoid this code duplication? */
    unsetSelection: function( ids ) {
        var startlen = this.selected.length;
        var selected = [];
        var idx;
        var e;

        for ( var i = 0; i < ids.length; i++ ) {
            this.selected.remove( ids[ i ] );
            idx = this.itempos[ ids[ i ] ];
            if ( !defined( idx ) )
                continue;
                
            e = this.items[ idx ];
            selected.push( e.itemId );
            DOM.removeClassName( e, "selected" );
            if ( this.checkboxSelection )
                this.toggleCheckbox( e, false );
        }
        
        if ( startlen > this.selected.length && selected.length )
            this.broadcastToObservers( "listItemsUnSelected", this, selected );
    },


    resetSelection: function() {
        // no need to refire if the selected list is empty
        if ( this.selected.length == 0 )
            return;

        var selected = [];
        var idx;
        var e;

        for ( var i = 0; i < this.selected.length; i++ ) {
            idx = this.itempos[ this.selected[ i ] ];
            if ( !defined( idx ) )
                continue;
            e = this.items[ idx ];
            selected.push( this.selected[ i ] );
            DOM.removeClassName( e, "selected" );
            if ( this.checkboxSelection )
                this.toggleCheckbox( e, false );
        }

        this.selected = [];
        
        if ( selected.length )
            this.broadcastToObservers( "listItemsUnSelected", this, selected );
    },


    getListElementFromTarget: function( target ) {
        return DOM.getFirstAncestorByClassName( target, "list-item", true );
    },


    getItemIdFromTarget: function( target ) {
        var item = this.getListElementFromTarget( target );
        if ( item )
            return item.itemId;
        else
            return undefined;  
    },
    

    /* events */
    
    eventDOMMouseScroll: function( event ) {
        var delta = 0;
        if ( event.wheelDelta ) {
            delta = ( event.wheelDelta * -0.5 );
        } else if ( event.detail ) {
            delta = ( event.detail * 10 );
        }
        var scrollt = this.content.scrollTop;
        this.content.scrollTop += delta;
        /* only trigger reflow if this scroll affects the list */
        if ( scrollt != this.content.scrollTop ) {
            this.reflow();
            event.stop();
        }
    },
    

    eventMouseDown: function( event ) {
        arguments.callee.applySuper( this, arguments );
        var ancestor = this.getListElementFromTarget( event.target );
        if ( ancestor )
            return;
        
        // xxx can add drag select box code here
    },

    
    eventDoubleClick: function( event ) {
        var ancestor = this.getListElementFromTarget( event.target );
        if ( !ancestor )
            return;
        
        if ( this.selected.length )
            this.broadcastToObservers( "listItemsDoubleClicked", this, this.selected );
    },
  
  
    eventMouseOver: function( event ) {
        var element = this.getListElementFromTarget( event.target );
        
        /* TODO convert this from a dom ref to an ID */
        if ( element !== this.hoverElement ) {
        
            this.hoverElement = element; // Delay before hover effect:
            
            if ( this.hoverTimer )
                this.hoverTimer.destroy();
        
            this.hoverTimer = new Timer( this.getIndirectMethod( "timedMouseover" ), this.hoverDelay, 1 ); 
        
            if ( !this.enableMagnifier || !element )
                return;
        }
        
        if ( !this.enableMagnifier )
            return;
        
        if ( this.magnifierAttribute ) {
             var target = DOM.getMouseEventAttribute( event, this.magnifierAttribute );
             /* mouse over an item with an attribute, then show the magnifier */
             if ( !target )
                 return;
        }
        /* auto use assetCache if available */
        if ( !this.cacheObject && window.app && app.assetCache )
            this.cacheObject = app.assetCache;
                
        /* don't reset the timer on remouse over */
        if ( this.magnifyItemId && this.magnifyItemId == element.itemId )
            return;
        
        this.magnifyItemId = element.itemId;
        
        var item = this.cacheObject.getItem( this.magnifyItemId );
        if ( !item )
            return;
        
        /* preload the div */
        this.magnifierElementContent.innerHTML = Template.process( this.magnifierTemplate, { item: item, list: this } );
        
        /* stop any other timer */
        if ( this.magnifyTimer )
            this.magnifyTimer.destroy();
        
        this.magnifyTimer = new Timer( this.getIndirectMethod( "showMagnifier" ), this.magnifyDelay, 1 );
            
        var cli = DOM.getClientDimensions();
        /* get half client dimensions */
        this.clientHX = cli.x / 2;
        this.clientHY = cli.y / 2;
        
        this.positionMagnifier( event );
    },


    showMagnifier: function() {
        if ( !defined( this.magnifyItemId ) )
            return;
         
        /* show magnifier */
        DOM.removeClassName( this.magnifierElement, "hidden" );
    },
    
    
    eventMouseMove: function( event ) {
        if ( !this.enableMagnifier || !defined( this.magnifyItemId ) || !this.getListElementFromTarget( event.target ) )
            return;

        this.positionMagnifier( event );
    },


    positionMagnifier: function( event ) {
        var m = DOM.getAbsoluteCursorPosition( event );
        
        var classX = ( m.x > this.clientHX ) ? 0 : 1;
        var classY = ( m.y > this.clientHY ) ? 2 : 3;
       
        /* avoid resetting the classes if not needed */
        if ( classX != this.magClassX || classY != this.magClassY ) {
            for ( var i = 0; i < this.flyoutClasses.length; i++ ) {
                if ( i == classX || i == classY )
                    continue;
                DOM.removeClassName( this.magnifierElement, this.flyoutClasses[ i ] );
            }
        
            DOM.addClassName( this.magnifierElement, this.flyoutClasses[ classX ] );
            DOM.addClassName( this.magnifierElement, this.flyoutClasses[ classY ] );

            this.magClassX = classX;
            this.magClassY = classY;
        }
        
        /* offset the magnifier so it doesn't cause a 'mouse out, hide, mouse over, repeat' */
        m.x += 10;
        m.y += 15;
        
        /* set inital position */
        DOM.setLeft( this.magnifierElement, m.x );
        DOM.setTop( this.magnifierElement, m.y );
    },


    eventMouseOut: function( event ) { // We don't get the mouseout on the hoverElement here for some reason.
        var element;
        if ( this.magnifierAttribute ) {
             var target = DOM.getMouseEventAttribute( event, this.magnifierAttribute );
             /* mouse over an item with an attribute, then show the magnifier */
             if ( !target )
                return;
        } else {
            element = this.getListElementFromTarget( event.relatedTarget );
            if ( event.relatedTarget && !element )
                this.clearHover(); // So we use 'relatedTarget' instead of 'target'.
        }
        
        if ( this.enableMagnifier && !element ) {
            if ( this.magnifyTimer )
                this.magnifyTimer.destroy();
            DOM.addClassName( this.magnifierElement, "hidden" );
            this.magnifyItemId = undefined;
            event.stop();
        }
    },



    eventClick: function( event ) {
        if ( this.noClickSelection )
            return;
       
        var command = this.getMouseEventCommand( event );
        if ( command )
            return;
        
        var ancestor = this.getListElementFromTarget( event.target );
        if ( !ancestor ) {
            /* deselect everything only if no modifier keys are being used */
            if ( event.ctrlKey || event.metaKey || event.shiftKey )
                return;
            if ( !this.disableUnSelect )
                this.resetSelection();
            return;
        }
        var itemId = ancestor.itemId;

        if ( !this.singleSelect && event.shiftKey ) {
            var sel = [];
           
            /* lastselected is an id
             * using the itempos list, we find the position
             * of the item in our list
             */
           
            // locate start and end of selection in list
            var start = this.itempos[ this.lastselected ] || 0
            //var end = this.items.indexOf( ancestor );
            var end = this.itempos[ itemId ];
            
            if ( start > end ) {
                var tmp = end;
                end = start;
                start = tmp;
            }
            
            /* only select items that are not already selected
             * this cuts down on the number of selected items
             * sent back to the watchers
             */
            for ( var i = start; i <= end; i++ ) {
                if ( this.selectLimit && ( this.selected.length + sel.length ) >= this.selectLimit ) {
                    this.unsetSelection( [ this.items[ i ].itemId ] );
                    continue;
                }
                if ( this.selected.indexOf( this.items[ i ].itemId ) == -1 
                    && !this.unselectable[ this.items[ i ].itemId ] )
                    sel.push( this.items[ i ].itemId );
            }
            
            this.setSelection( sel );
            
            return;
        } else if ( !this.singleSelect && ( event.ctrlKey || event.metaKey ) ) {
            if ( this.selected.indexOf( itemId ) != -1 && !this.unselectable[ itemId ] ) {
                this.lastselected = itemId;
                this.unsetSelection( [ itemId ] );
                return;
            }
        } else {
            if ( this.selected.length == 1 && this.selected[ 0 ] == itemId ) {
                /* selected item that is already selected */
                this.lastselected = itemId;
                if ( this.toggleSelect )
                    this.unsetSelection( [ itemId ] );
                return;
            } else {
                if ( !this.toggleSelect && !this.disableUnSelect )
                    this.resetSelection();
            }
        }
        if ( defined( this.unselectable[ itemId ] ) )
            return;

        this.lastselected = itemId;
        if ( this.toggleSelect ) {
            if ( this.selected.indexOf( itemId ) != -1 ) {
                log("unselecting " + itemId);
                this.unsetSelection( [ itemId ] );
                return;
            }
        }
        
        if ( this.selectLimit && this.selected.length >= this.selectLimit )
            return this.unsetSelection( [ itemId ] );
        
        log("selecting " + itemId);
        this.setSelection( [ itemId ] );
    },


    timedMouseover: function( timer ) { 
        if ( this.hoveredElement ) 
            this.clearHovered();
        if ( this.hoverElement ) {
            DOM.addClassName( this.hoverElement, "list-item-hover" );
            this.hoveredElement = this.hoverElement;
        }
    },

        
    /* emitted by the list model */

    listModelItems: function( modelobj, items, update, total, offset, count ) {

        this.length = total;

        this.broadcastToObservers( "listTotal", this, total, this.currentPage, this.perPage, items.length );

        if ( update ) {
            this.updateItems( items );
            return;
        }

        DOM.removeClassName( this.element, "list-loading" );

        if ( modelobj.filteredEmpty )
            this.setListEmpty( true, true );
        else if ( modelobj.empty )
            this.setListEmpty( true );
        else if ( items.length )
            this.setListEmpty( false );
        else if ( !items.length )
            this.setListEmpty( true );
        else
            this.setListEmpty( false );
            
        this.replaceItems( items );
    },


    setListEmpty: function( empty, filtered ) {
        if ( empty ) {
            if ( filtered )
                DOM.addClassName( this.element, "list-empty-filtered" );
            else
                DOM.removeClassName( this.element, "list-empty-filtered" );
            /*
            var es = DOM.getElementsByClassName( this.element, "list-empty-message" );
            for ( var i = 0; i < es.length; i++ )
                DOM.removeClassName( es[ i ], "hidden" );
            */ 
            DOM.addClassName( this.element, "list-no-results" );
        } else {
            DOM.removeClassName( this.element, "list-no-results" );
            DOM.removeClassName( this.element, "list-empty-filtered" );
        }
        
        DOM.removeClassName( this.element, "list-empty" ); 
         
        this.broadcastToObservers( "listEmpty", this, empty, filtered );
    },

    
    retrieveItems: function() {
        this.model.getItems( ( ( this.currentPage - 1 ) * this.perPage ), this.perPage );
    },
  

    setPerPage: function( perPage ) {
        this.perPage = perPage;
    },
   
    
    setCurrentPage: function( currentPage ) {
        this.currentPage = currentPage;
    },

    
    /* observer called methods */
    
    listModelChanged: function( modelobj ) {
        this.retrieveItems();
    },
    
    
    pagerPageChange: function( pagerobj, page ) {
        this.setCurrentPage( page );
        this.retrieveItems();
    },

    
    componentActivated: function( comp ) {
        /* XXX doesn't get called? */
        if ( !this.enableMagnifier )
            return;
        
        DOM.addClassName( this.magnifierElement, "hidden" );
    },


    componentDeactivated: function( comp ) {
        /* XXX doesn't get called? */
        if ( !this.enableMagnifier )
            return;
            
        DOM.addClassName( this.magnifierElement, "hidden" );
    },

    
    toggleCheckbox: function( e, value ) {
        var es = e.getElementsByTagName( "input" );
        if ( !es )
            return;
        var type;
        for ( var i = 0; i < es.length; i++ ) {
            type = es[ i ].getAttribute( "type" );
            type = type ? type.toLowerCase() : "";
            if ( type == "checkbox" || type == "radio" )
                es[ i ].checked = value;
        }
    }
} );


ListModel = new Class( Observable, {
    init: function() {
        arguments.callee.applySuper( this, arguments );
        if( arguments[ 0 ] instanceof Array )
            this.source = arguments[ 0 ];
        app.c.addObserver( this );
    },

    
    getItems: function( start, end, callback ) {
        if ( !start )
            start = 0;
        if ( !end || end > this.source.length )
            end = this.source.length;
        
        this.broadcastToObservers( "listModelItems", this, this.source.slice( start, end ) );
    },

    
    /* observer called methods */
    assetsDeleted: function( cobj, ids ) {
        this.broadcastToObservers( "listModelChanged", this );
    },

    
    assetsUpdated: function( cobj, ids ) {
        this.broadcastToObservers( "listModelChanged", this );
    }             
} );

    
