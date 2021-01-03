/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
*/


/*
--------------------------------------------------------------------------------
TC.TableSelect
table selection
--------------------------------------------------------------------------------
*/

/* constructor */

TC.TableSelect = function( element ) {
    // make closures
    var self = this;
    this.clickClosure = function( evt ) { return self.click( evt ); };
//    this.keyPressClosure = function( evt ) { return self.eventKeyPress( evt ); };
    this.focusRow = null;
    this.lastClicked = null;
    this.thisClicked = null;
    this.updating = false;
    this.shiftKey = false;
    this.onChange = null;

    // initialize
    this.init( element );
}


/* config */

TC.TableSelect.prototype.rowSelect = false;


/* instance methods */

TC.TableSelect.prototype.init = function( container ) {
    container = TC.elementOrId( container );
    if ( !container ) return;

    // basic setup
    this.container = container;

    // event handlers
    TC.attachEvent( container, "click", this.clickClosure );
//    TC.attachEvent( window, "keypress", this.keyPressClosure );

    // select rows
    this.selectAll();
}

TC.TableSelect.prototype.eventKeyPress = function( evt ) {
    evt = evt || event;
    var element = evt.target || evt.srcElement;
    /* this was preventing keypress detection when a checkbox is selected
     *if (element && element.type) return evt;
     */
    var c = ( String.fromCharCode( evt.charCode || evt.keyCode ) || "" );

    switch (c) {
        // case 78:   // N -- next
        case 'J':   // J -- down
            this.focusSelect();
        // case 110:  // n -- next
        case 'j':  // j -- down
            this.focusNext();
            break;
        // case 80:   // P -- previous
        case 'K':   // K -- up
            this.focusPrevious();
            this.focusSelect();
            break;
        // case 112:  // p -- previous
        case 'k':  // k -- up
            this.focusPrevious();
            break;
        case 'X':   // X -- select
            this.shiftKey = true;
        case 'x':  // x -- select
            this.focusSelect();
            break;
        // case 35:   // # (trash)
        // case 111:  // o - open
        // case 13:   // return (navigate to item)
        // case 47:   // 'slash' (search)
        // case 33:   // ! - report as spam
    }
    return evt;
}

TC.TableSelect.prototype.focusNext = function() {
    var next = this.getNextSibling( this.focusRow );
    var n;
    while ( next && (
            ((next.tagName ? next.tagName.toLowerCase() : '') != 'tr')
            || (TC.hasClassName( next, "slave" ))
            || !( ( n = TC.getComputedStyle( next ) ) && n["display"] != "none" )
        ) ) {
        next = this.getNextSibling( next );
    }
    if (next) {
        this.setFocus( next );
    }
}

TC.TableSelect.prototype.focusPrevious = function() {
    var prev = this.getPreviousSibling( this.focusRow );
    var n;
    while (prev && (
            ((prev.tagName ? prev.tagName.toLowerCase() : '') != 'tr')
            || (TC.hasClassName( prev, "slave" ))
            || !( ( n = TC.getComputedStyle( prev ) ) && n["display"] != "none" )
        ) ) {
        prev = this.getPreviousSibling( prev );
    }
    if (prev) {
        this.setFocus( prev );
    }
}

TC.TableSelect.prototype.focusSelect = function() {
    var parent = this.focusRow;
    if (!parent) return;
    var elements = TC.getElementsByTagAndClassName( "input", "select", parent );
    for ( var i = 0; i < elements.length; i++ ) {
        element = elements[ i ];
        if ( (element.type == "checkbox") || (element.type == "radio") ) {
            element.checked = !element.checked;
            return this.select( element );
        }
    }
}

TC.TableSelect.prototype.click = function( evt ) {
    evt = evt || event;
    var element = evt.target || evt.srcElement;
    this.shiftKey = evt.shiftKey;

    // get tag name
    var tagName = element.tagName ? element.tagName.toLowerCase() : null;

    // handle checkboxes
    if ( tagName == "input" &&
        TC.hasClassName( element, "select" ) ) {
        if ((element.type == "checkbox") || (element.type == "radio"))
            var parent = TC.getParentByTagName( element, "tr" );
            if (parent) this.setFocus( parent );
            evt.preventDefault();
            return this.select( element );
    }

    // handle rows
    if ( !this.rowSelect && tagName != "td" ) return;
    if ( ( tagName == 'a') || ( TC.getParentByTagName( element, "a" ) ) )
        return;

    var parent;
    if ( ( tagName == "li" || tagName == "label" || tagName == "span" ) && TC.hasClassName( TC.getParentByTagName( element, "div" ), "mt-table__hierarchy" ) ) {
        if(tagName == "li") {
            parent = element;
        } else {
            parent = TC.getParentByTagName( element, "li" );
        }
    } else {
        parent = TC.getParentByTagName( element, "tr" );
    }
    while ( TC.hasClassName( parent, "slave" ) )
        parent = this.getPreviousSibling( parent );

    if ( parent ) {
        this.setFocus( parent );
        var elements = TC.getElementsByTagAndClassName( "input", "select", parent );
        for ( var i = 0; i < elements.length; i++ ) {
            element = elements[ i ];
            if ( (element.type == "checkbox") || (element.type == "radio") ) {
                if ( element.disabled ) return;
                element.checked = !element.checked;
                evt.preventDefault();
                return this.select( element, parent );
            }
        }
    }
}


TC.TableSelect.prototype.select = function( checkbox, row ) {
    // setup
    this.thisClicked = checkbox;
    var checked = checkbox.checked ? true : false; // important, trinary value (null is valid)
    var all = checkbox.value == "all" ? true : false;
    
    if ( all ) {
        this.thisClicked = null;
        this.lastClicked = null;
        this.focusRow = null;
        return this.selectAll( checkbox );
    }

    if (this.selectRow( row, checked )) {
        if (this.onChange) this.onChange(this, row, checked);
        if (checkbox.type == "radio") {
            this.lastClicked = null;
            this.clearOthers(row);
            return;
        }
    }
    this.selectAll();
    this.lastClicked = this.thisClicked;
}

TC.TableSelect.prototype.clearOthers = function( sel_row ) {
    var rows = this.container.getElementsByTagName( "tr" );
    for ( var i = 0; i < rows.length; i++ ) {
        var row = rows[ i ];
        if ( !row || !row.tagName )
            continue;
        if (row.id == sel_row.id)
            continue;
        this.selectRow(row, false);
    }
}

TC.TableSelect.prototype.setFocus = function( row ) {
    if (this.focusRow) {
        TC.removeClassName(this.focusRow, "has-focus");
        var next = this.getNextSibling( this.focusRow );
        while (next && TC.hasClassName(next, "slave")) {
            TC.removeClassName(next, "has-focus");
            next = this.getNextSibling( next );
        }
    }
    this.focusRow = row;
    if (this.focusRow) {
        TC.addClassName(this.focusRow, "has-focus");
        var next = this.getNextSibling( this.focusRow );
        while (next && TC.hasClassName(next, "slave")) {
            TC.addClassName(next, "has-focus");
            next = this.getNextSibling( next );
        }
    }
}

TC.TableSelect.prototype.selectAll = function( checkbox ) {
    // setup
    if (this.updating) return;
    this.updating = true;
    var alls = [];
    var count = 0;
    var selectedCount = 0;
    var invert = false;

    var lastClicked = -1;
    var thisClicked = -1;
    
    // iterate
    var rows = this.container.getElementsByTagName( "tr" );

    for ( var i = 0; i < rows.length; i++ ) {
        var row = rows[ i ];
        if ( !row || !row.tagName )
            continue;
        var inputs = row.getElementsByTagName( "input" );

        for ( var j = 0; j < inputs.length; j++ ) {
            var input = inputs[ j ];
            if ( ((input.type != "checkbox") && (input.type != "radio")) ||
                !TC.hasClassName( input, "select" ) )
                continue;

            if (this.lastClicked && input == this.lastClicked)
                lastClicked = i;

            if (this.thisClicked && input == this.thisClicked)
                thisClicked = i;
        }

        invert = this.shiftKey;
    }

    for ( var i = 0; i < rows.length; i++ ) {
        var row = rows[ i ];
        if ( !row || !row.tagName )
            continue;
        var inputs = row.getElementsByTagName( "input" );
        for ( var j = 0; j < inputs.length; j++ ) {
            var input = inputs[ j ];
            if ( ((input.type != "checkbox") && (input.type != "radio")) ||
                !TC.hasClassName( input, "select" ) )
                continue;

            if (input.value != 'all') {
                if (this.focusRow == null)
                    this.setFocus( row );
            }

            // test and select
            var checked;
            if (checkbox) {
                var checked;
                if (invert)
                    checked = !input.checked;
                else
                    checked = checkbox ? checkbox.checked : input.checked;
                input.checked = checked;
                if (this.selectRow( row, checked )) {
                    if ( input.value != "all" ) {
                        if (this.onChange) this.onChange(this, row, checked);
                    }
                }
            }

            // add to alls
            if ( input.value == "all" )
                alls[ alls.length ] = input;
            else {
                count++;
                if ( input.checked )
                    selectedCount++;
            }
        }
    }

    if ((lastClicked != -1) && (this.shiftKey)) {
        var low, hi;
        if (thisClicked < lastClicked) {
            low = thisClicked;
            hi = lastClicked;
        } else {
            low = lastClicked;
            hi = thisClicked;
        }
        for (i = low + 1; i < hi; i++) {
            var row = rows[ i ];
            if (!row || !row.tagName )
                continue;

            var inputs = row.getElementsByTagName( "input" );

            for ( var j = 0; j < inputs.length; j++ ) {
                var input = inputs[ j ];
                if ( ((input.type != "checkbox") && (input.type != "radio")) ||
                    !TC.hasClassName( input, "select" ) || input.value == "all" )
                    continue;
                input.checked = this.thisClicked.checked;
            }
            if (this.selectRow( row, this.thisClicked.checked )) {
                if (this.onChange) this.onChange(this, row, this.thisClicked.checked);
            }
        }
        this.lastClicked.checked = this.thisClicked.checked;
        if (this.selectRow( rows[ lastClicked ], this.lastClicked.checked )) {
            if (this.onChange) this.onChange(this, rows[ lastClicked ], this.lastClicked.checked);
        }
    }

    // check alls
    for ( var i = 0; i < alls.length; i++ ) {
        if ( count && count == selectedCount ) {
            alls[ i ].checked = true;
        } else
            alls[ i ].checked = false;
    }
    this.shiftKey = false;
    this.updating = false;
}


TC.TableSelect.prototype.selected = function() {
    // setup
    var values = [];

    // iterate
    var rows = this.container.getElementsByTagName( "tr" );

    for ( var i = 0; i < rows.length; i++ ) {
        var row = rows[ i ];
        if ( !row || !row.tagName )
            continue;
        var inputs = row.getElementsByTagName( "input" );

        for ( var j = 0; j < inputs.length; j++ ) {
            var input = inputs[ j ];
            if ( ( (input.type != "checkbox") && (input.type != "radio")) ||
                !TC.hasClassName( input, "select" ) )
                continue;

            if (input.checked)
                values[values.length] = input;
        }
    }

    return values;
}


TC.TableSelect.prototype.selectRow = function( row, checked ) {
    if ( !row ) return false;
    var changed = false;
    if( checked ) {
        if (!TC.hasClassName( row, "mt-table__highlight" )) {
            TC.addClassName( row, "mt-table__highlight" );
            changed = true;
        }
    } else {
        if (TC.hasClassName( row, "mt-table__highlight" )) {
            TC.removeClassName( row, "mt-table__highlight" );
            changed = true;
        }
    }
    if (changed) {
        // sync checkbox if necessary
        var inputs = row.getElementsByTagName( "input" );

        for ( var j = 0; j < inputs.length; j++ ) {
            var input = inputs[ j ];
            if ( input.type != "checkbox" || !TC.hasClassName( input, "select" ) )
                continue;
            input.checked = checked;
        }

        var next = this.getNextSibling( row );
        while (next && TC.hasClassName( next, "slave" )) {
            if ( checked )
                TC.addClassName( next, "mt-table__highlight" );
            else
                TC.removeClassName( next, "mt-table__highlight" );
            next = this.getNextSibling( next );
        }
    }
    return changed;
}

TC.TableSelect.prototype.selectThese = function(list) {
    // list is an array of DOM IDs
    for (var i = 0; i < list.length; i++) {
        var el = TC.elementOrId(list[i]);
        this.selectRow(el, true);
    }
    this.selectAll();
}

TC.TableSelect.prototype.getNextSibling = function( el ) {
    while ( el ) {
        el = el.nextSibling;
        if ( el && el.tagName && el.tagName.toLowerCase() == 'tr' )
            break;
    }
    return el;
}

TC.TableSelect.prototype.getPreviousSibling = function( el ) {
    while ( el ) {
        el = el.previousSibling;
        if ( el && el.tagName && el.tagName.toLowerCase() == 'tr' )
            break;
    }
    return el;
}
