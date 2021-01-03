/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
*/


/*
--------------------------------------------------------------------------------
TC
core utility class
--------------------------------------------------------------------------------
*/

/* dummy constructor */

TC = function()
{
}


/* static variables */

TC.matchShortWords = /\b(\S*)\b/gi;
TC.matchLeadingSpace = /^\s+/;	
TC.matchTrailingSpace = /\s+$/;
TC.matchSpace = /\s+/g;


/* utility methods */

TC.defined = function( x )
{
	try
	{
		if( typeof x != "undefined" )
			return true;
	}
	catch( e ) {}
	return false;
}


TC.inspect = function( x )
{
	var t = "";
	for( var i in x )
		t += i + " = " + x[ i ] + "<br />";
	return t;
}


TC.elementOrId = function( element )
{
	if( !element )
		return null;
	if( typeof element == "string" )
		element = document.getElementById( element );
	return element;
}


TC.applyFunction = function( elements, func )
{
	if( !elements )
		return;
	for( var i in elements )
	{
		var element = elements[ i ];
		if( !element )
			continue;
		func( element );
	}
}


TC.attachWindowEvent = function( eventName, func )
{
	var onEventName = 'on' + eventName;
	var old = window[onEventName];
	if( typeof old != 'function' )
		window[onEventName] = func;
	else
	{
		window[onEventName] = function( evt )
		{
			old( evt );
			return func( evt );
		};
	}
}


TC.attachLoadEvent = function( func )
{
	TC.attachWindowEvent('load', func);
}


TC.attachBeforeUnloadEvent = function( func )
{
	var old = window.onbeforeunload;
	if( typeof old != 'function' )
		window.onbeforeunload = func;
	else
	{
		window.onbeforeunload = function( evt )
		{
			old( evt );
			return func( evt );
		};
	}
}


TC.attachDocumentEvent = function( element, eventName, func, recurse )
{
	if( !element || !element.document )
		return;
	var doc = element.document;
	TC.attachEvent( doc, eventName, func );
	if( !recurse )
		return;
	
	// get frames
	var elements = [];
	if( doc.frames )
	{
		for( var i in doc.frames );
			elements[ elements.length ] = doc.frames[ i ];
	}
	
	// get iframes
	var iframes = doc.getElementsByTagName( "iframe" ) || [];
	for( var i in iframes )
		elements[ elements.length ] = iframes[ i ];
	
	// attach event handler
	for( var i in elements )
	{
		if( !elements[ i ] || !elements[ i ].contentWindow )
			continue;
		TC.attachDocumentEvent( elements[ i ].contentWindow, eventName, func, recurse );
	}
}


TC.attachEvent = function( element, eventName, func )
{
	element = TC.elementOrId( element );
	if( !element )
		return;
	if( element.addEventListener )
		element.addEventListener( eventName, func, true );
	else if( element.attachEvent )
		element.attachEvent( "on" + eventName, func );
	else
		element[ "on" + eventName ] = func;
}


TC.detachEvent = function( element, eventName, func )
{
	element = TC.elementOrId( element );
	if( !element )
		return;
	if( element.removeEventListener )
		element.removeEventListener( eventName, func, true );
	else if( element.detachEvent )
		element.detachEvent( "on" + eventName, func );
	else
		element[ "on" + eventName ] = null;
}


TC.stopEvent = function( evt )
{
	evt = evt || event;
	
	// moz
	if( evt.preventDefault )
		evt.preventDefault();
	if( evt.stopPropagation )
		evt.stopPropagation();
	
	// ie
	if( TC.defined( evt.returnValue ) )
	{
		evt.cancelBubble = true;
		evt.returnValue = false;
	}
	
	return false;
}


TC.allowTabs = function( element )
{
	element = TC.elementOrId( element );
	TC.attachEvent( element, "keypress", TC.allowTabs.keyPress );
	TC.attachEvent( element, "keydown", TC.allowTabs.keyDown );
}


TC.allowTabs.keyPress = function( evt )
{
	evt = evt || event;
	var element = evt.target || evt.srcElement;
	if( evt.keyCode == 9 )
	{
		return TC.stopEvent( evt );
	}
	return true;
}


TC.allowTabs.keyDown = function( evt )
{
	evt = evt || event;
	var element = evt.target || evt.srcElement;
	if( evt.keyCode == 9 )
	{
		TC.setSelectionValue( element, "\t" );
		return false;
	}
	return true;
}


TC.allowHover = function( element )
{
	element = TC.elementOrId( element );
	TC.attachEvent( element, "mouseover", TC.allowHover.mouseOver );
	TC.attachEvent( element, "mouseout", TC.allowHover.mouseOut );
}


TC.allowHover.mouseOver = function( evt )
{
	evt = evt || event;
	var element = evt.target || evt.srcElement;
	TC.addClassName( element, "hover" );
}


TC.allowHover.mouseOut = function( evt )
{
	evt = evt || event;
	var element = evt.target || evt.srcElement;
	TC.removeClassName( element, "hover" );
}


/* text and selection related methods */

TC.getSelection = function( element )
{
	var doc = TC.getOwnerDocument( element );
	var win = TC.getOwnerWindow( doc );
	if( win.getSelection )
		return win.getSelection();
	else if( doc.getSelection )
		return doc.getSelection();
	else if( doc.selection )
		return doc.selection;
	return null;
}

TC.getCaretPosition = function( element )
{
	var doc = TC.getOwnerDocument( element );
    if (doc.selection) {
        var range = doc.selection.createRange();
    	var isCollapsed = range.compareEndPoints("StartToEnd", range) == 0;
    	if (!isCollapsed)
    		range.collapse(true);
    	var b = range.getBookmark();
    	return b.charCodeAt(2) - 2;
    } else if (element.selectionStart != 'undefined') {
        return element.selectionStart;
    }

    return null;
}

TC.setCaretPosition = function( element, pos )
{
    if (element.createTextRange) {
		var range = element.createTextRange();
		range.collapse(true);
		range.moveStart("character", pos);
		range.select();
        return true;
    } else {
        element.selectionStart = pos;
        element.selectionEnd = pos;
        return true;
    }
    return false;
}

TC.createRange = function( selection, element )
{
	var doc = TC.getOwnerDocument( element );
	if( selection && selection.getRangeAt )
		return selection.getRangeAt( 0 );
	else if( selection && selection.createRange )
		return selection.createRange();
	else if( doc.createRange )
		return doc.createRange();
	return null;
}


TC.extractElementText = function( element )
{
	element = TC.elementOrId( element );
	if( !element || element.nodeType == 8 )	// ignore html comments
		return '';
	var tagName = element.tagName ? element.tagName.toLowerCase() : '';
	if( tagName == 'input' || tagName == 'textarea' )	
		return '';
	
	var text = element.nodeValue != null ? element.nodeValue : '';
	for( var i = 0; i < element.childNodes.length; i++ )
		text += TC.extractElementText( element.childNodes[ i ] );
	
	return text;
}


TC.setSelectionValue = function( element, value )
{
	element = TC.elementOrId( element );
	var scrollFromBottom = element.scrollHeight - element.scrollTop;
	
	// msie
	if( document.selection )
	{
		element.focus();
		document.selection.createRange().text = value;
	}
	
	// mozilla
	else
	{
		var length = element.textLength;
		var start = element.selectionStart;
		var end = element.selectionEnd;
		element.value = element.value.substring( 0, start ) +
			value + element.value.substring( end, length );
		element.caretPos = start + length;
		element.selectionStart = start + value.length;
		element.selectionEnd = start + value.length;
	}
	
	element.scrollTop = element.scrollHeight - scrollFromBottom;
}


TC.normalizeWords = function( text )
{
	text = text.toLowerCase();
	
	var originalWords = text.match( matchShortWords );
	var exists = new Array();
	var words = new Array();
	
	for( i = 0; i < originalWords.length; i++ )
	{
		if( exists[ originalWords[ i ] ] )
			continue;
		exists[ originalWords[ i ] ] = 1;
		words[ words.length ] = originalWords[ i ];
	}
	
	words.sort();
	return words;
}


/* dom methods */

TC.getOwnerDocument = function( element )
{
	if( !element )
		return document;
	if( element.ownerDocument )
		return element.ownerDocument;
	if( element.getElementById )
		return element
	return document;
}


TC.getOwnerWindow = function( element )
{
	if( !element )
		return window;
	
	// msie
	if( element.parentWindow )
		return element.parentWindow;
	
	// mozilla
	var doc = TC.getOwnerDocument( element );
	if( doc && doc.defaultView )
		return doc.defaultView;
	
	return window;
}


TC.getElementsByTagAndClassName = function( tagName, className, root )
{
	root = TC.elementOrId( root );
	if( !root )
		root = document;
	var allElements = root.getElementsByTagName( tagName );
	var elements = [];
	for( var i = 0; i < allElements.length; i++ )
	{
		var element = allElements[ i ];
		if( !element )
			continue;
		if( TC.hasClassName( element, className ) )
			elements[ elements.length ] = element;
	}
	return elements;
}


TC.getElementsByClassName = function( className, root )
{
	return TC.getElementsByTagAndClassName( "*", className, root );
}


TC.getParentByTagName = function( element, tagName )
{
	tagName = tagName.toLowerCase();
	var parent = element.parentNode;
	while( parent )
	{
		if( parent.tagName && parent.tagName.toLowerCase() == tagName )
			return parent;
		parent = parent.parentNode;
	}
	return null;
}


TC.inlineDisplays =
{
	"inline" : 1,
	"inline-block" : 1
}

TC.isInlineNode = function( node )
{
	/* text nodes are inline */
	if( node.nodeType == 3 )
		return true;
	
	/* document nodes are non-inline */
	if( node.nodeType == 9 )
		return false;
	
	/* all non-element nodes are inline */
	if( node.nodeType != 1 )
		return true;
	
	/* br elements are not inline */
	if( node.tagName && node.tagName.toLowerCase() == "br" )
		return false;
	
	/* examine the style property of the inline node */
	var d = TC.getStyle( node, "display" );
	if( TC.inlineDisplays[ d ] )
		return true;
	
	/* assume non-inline */
	return false;
}


TC.getPreviousTextNode = function( node, inline )
{
	var up = false;
	while( node )
	{
		if( !up && node.lastChild )
		{
			node = node.lastChild;			// down
			up = false;
		}
		else if( node.previousSibling )
		{
			node = node.previousSibling;	// left
			up = false;
		}
		else if( node.parentNode )
		{
			node = node.parentNode;			// up
			up = true;
		}
		else
			return null;					// borked
		
		if( node.nodeType == 3 )
			return node;
		if( inline && !TC.isInlineNode( node ) )
			return null;
	}
	return null;
}


TC.getNextTextNode = function( node, inline )
{
	var up = false;
	while( node )
	{
		if( !up && node.firstChild )
		{
			node = node.firstChild;			// down
			up = false;
		}
		else if( node.nextSibling )
		{
			node = node.nextSibling;		// right
			up = false;
		}
		else if( node.parentNode )
		{
			node = node.parentNode;			// up
			up = true;
		}
		else
			return null;					// borked
		
		if( node.nodeType == 3 )
			return node;
		if( inline && !TC.isInlineNode( node ) )
			return null;
	}
	return null;
}


TC.setAttributes = function( element, attr )
{
	element = TC.elementOrId( element );
	if( !element || !attr )
		return;
	for( var a in attr )
		element.setAttribute( a, attr[ a ] );
}


// this and the following classname functions honor w3c case-sensitive classnames
TC.hasClassName = function( element, className )
{
	if( !element || !element.className || typeof element.className != 'string' || !className )
		return false;
	var classNames = element.className.split( TC.matchSpace );
	for( var i = 0; i < classNames.length; i++ )
	{
		if( classNames[ i ] == className )
			return true;
	}
	return false;
}

TC.getClassNames = function( e ) {
    if( !e || !e.className )
        return [];
    return e.className.split( /\s+/g );
}

TC.addClassName = function( e, cn ) {
    if( !e || !cn )
        return false;
    var cs = TC.getClassNames( e );
    for( var i = 0; i < cs.length; i++ ) {
        if( cs[ i ] == cn )
            return true;
    }
    cs.push( cn );
    e.className = cs.join( " " );
    return false;
}

TC.removeClassName = function( e, cn ) {
    var r = false;
    if( !e || !e.className || !cn )
        return r;
    var cs = (e.className && e.className.length)
        ? e.className.split( /\s+/g )
        : [];
    var ncs = [];
    /* support regex */
    if( cn instanceof RegExp ) {
        for( var i = 0; i < cs.length; i++ ) {
            if ( cn.test( cs[ i ] ) ) {
                r = true;
                continue;
            }
            ncs.push( cs[ i ] );
        }
    } else {
        for( var i = 0; i < cs.length; i++ ) {
            if( cs[ i ] == cn ) {
                r = true;
                continue;
            }
            ncs.push( cs[ i ] );
        }
    }
    if( r )
        e.className = ncs.join( " " );
    return r;
}
        
TC.getComputedStyle = function( e )
{
        if( e.currentStyle )
            return e.currentStyle;
        var style = {};
        var owner = TC.getOwnerDocument( e );
        if( owner && owner.defaultView && owner.defaultView.getComputedStyle ) {            
            try {
                style = owner.defaultView.getComputedStyle( e, null );
            } catch( e ) {}
        }
        return style;
}

TC.getStyle = function( element, property )
{
	element = TC.elementOrId( element );
	var style;
	if( window.getComputedStyle )
		style = window.getComputedStyle( element, null ).getPropertyValue( property );
	else if( element.currentStyle )
		style = element.currentStyle[ property ];
	return style;
}


TC.setStyle = function( element, style )
{
	element = TC.elementOrId( element );
	if( !element || !element.style || !style )
		return;
	for( var s in style )
		element.style[ s ] = style[ s ];
}


TC.getAbsolutePosition = function( element )
{
	element = TC.elementOrId( element );
	var pos = { "left" : 0, "top" : 0 };
	if( !element )
		return pos;
	while( element )
	{
		pos.left += element.offsetLeft;
		pos.top += element.offsetTop;
		element = element.offsetParent;
	}
	return pos;
}


TC.getAbsoluteCursorPosition = function( evt )
{
	evt = evt || event;
	
	// get basic position
    var pos =
    {
    	x: evt.clientX,
    	y: evt.clientY
    };
	
    // ie
    if( document.documentElement && TC.defined( document.documentElement.scrollLeft ) )
    {
		pos.x += document.documentElement.scrollLeft;
		pos.y += document.documentElement.scrollTop;
    }
	
	// safari
	else if( TC.defined( window.scrollX ) )
	{
		pos.x += window.scrollX;
		pos.y += window.scrollX;
	}
	
	// opera
	else if( document.body && TC.defined( document.body.scrollLeft ) )
	{
		pos.x += document.body.scrollLeft;
		pos.y += document.body.scrollTop;
	}
	
    return pos;
}


/* array methods */

TC.scramble = function( array )
{
	var length = array.length;
	for( var i = 0; i < length; i++ )
	{
		var a = Math.floor( Math.random() * length );
		var b = Math.floor( Math.random() * length );
		var temp = array[ a ];
		array[ a ] = array[ b ];
		array[ b ] = temp;
	}
}
