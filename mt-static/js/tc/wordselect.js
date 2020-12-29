/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
*/


/*
--------------------------------------------------------------------------------
TC.WordSelect
double-click detection and override for improved word selection
--------------------------------------------------------------------------------
*/

/* constructor */

TC.WordSelect = function( element )
{
	// make closures
	var self = this;
	this.mouseDownClosure = function( evt ) { return self.mouseDown( evt ); };
	this.mouseUpClosure = function( evt ) { return self.mouseUp( evt ); };
	this.clickClosure = function( evt ) { return self.click( evt ); };
	this.doubleClickClosure = function( evt ) { return self.doubleClick( evt ); };
	this.selectStartClosure = function( evt ) { return self.selectStart( evt ); };
	this.selectionChangeClosure = function( evt ) { return self.selectionChange( evt ); };
	
	// initialize
	this.init( element );
}


/* config */

TC.WordSelect.prototype.downTime = 0;
TC.WordSelect.prototype.upTime = 0;
TC.WordSelect.prototype.clickInterval = 10000;
TC.WordSelect.prototype.doubleClickInterval = 333; // milliseconds
TC.WordSelect.prototype.doubleClicked = false;


/* instance methods */

TC.WordSelect.prototype.init = function( element )
{
	element = TC.elementOrId( element );
	if( !element )
		return;
	
	// assign element
	this.element = element;
	
	// event handlers
	var self = this;
	TC.attachEvent( element, "mousedown", this.mouseDownClosure );
	TC.attachEvent( element, "mouseup", this.mouseUpClosure );
	TC.attachEvent( element, "click", this.clickClosure );
	TC.attachEvent( element, "dblclick", this.doubleClickClosure );
	TC.attachEvent( element, "selectstart", this.selectStartClosure );
	TC.attachEvent( element, "selectionchange", this.selectionChangeClosure );
}


TC.WordSelect.prototype.mouseDown = function( evt )
{
	this.doubleClicked = false;
	var date = new Date();
	var time = date.getTime();
	if( this.upTime > this.downTime )
	{
		this.clickInterval = time - this.downTime;
		this.clickInterval = (time - this.upTime) * 2;	// test
		if( this.clickInterval <= this.doubleClickInterval )
		{
			this.doubleClicked = true;
			
			// mozilla doesn't have selectionchange
			if( !TC.defined( this.element.onselectionchange ) )
				return this.selectionChange( evt );	
		}
	}
	this.downTime = time;
}


TC.WordSelect.prototype.mouseUp = function( evt )
{
	var date = new Date();
	this.upTime = date.getTime();
	
	// get selection
	var selection = TC.getSelection( this.element );
	var range = TC.createRange( selection, this.element );
	if( !range )
		return;
	
	// mozilla
	if( range.startContainer && range.collapsed )
	{
		// get node
		var node = range.endContainer;
		
		// loop
		while( node )
		{
			// check for link
			if( node.nodeType == 1 && node.tagName.toLowerCase() == "a" )
			{
				this.expelCursor( selection, range, node );
				break;
			}
			
			// next
			node = node.parentNode;
		}
	}
}


TC.WordSelect.prototype.click = function( evt )
{
	evt = evt || event;
	var element = evt.target || evt.srcElement;
}


TC.WordSelect.prototype.doubleClick = function( evt )
{
	if( this.doubleClicked || this.clickInterval > this.doubleClickInterval )
	{
		// alert( this.clickInterval + " " + this.doubleClickInterval );
		this.doubleClickInterval = this.clickInterval;
		this.selectWord();
	}
	this.doubleClicked = false;
	TC.stopEvent( evt );
	return false;
}


// msie doesn't fire a second mousedown event before dblclick, so we alias the mousedown handler
TC.WordSelect.prototype.selectStart = TC.WordSelect.prototype.mouseDown;


// msie fires selectionchange event before dblclick
TC.WordSelect.prototype.selectionChange = function( evt )
{
	if( this.doubleClicked )
	{
		this.doubleClicked = false;
		return this.selectWord( evt );
	}
}


// mozilla has a bad habit of placing the insertion point inside
// <a> elements when the user clicks to the left or right of a link
TC.WordSelect.prototype.expelCursor = function( selection, range, node )
{
	// only function in mozilla
	var parentNode = node.parentNode;
	var end = range.endContainer;
	if( !end )
		return;
	
	// check beginning
	if( range.startOffset == 0 )
	{
		// alert( "start" );
		var t = (node.previousSibling && node.previousSibling.nodeType == 3)
			? node.previousSibling
			: node.ownerDocument.createTextNode( "" );
		parentNode.insertBefore( t, node );
		selection.collapse( t, (t.data ? t.data.length : 0 ) );
	}
	
	// check end
	else if( range.endOffset >= (end.data ? end.data.length : end.childNodes.length) )
	{
		// alert( "end" );
		var t = (node.nextSibling && node.nextSibling.nodeType == 3)
			? node.nextSibling
			: node.ownerDocument.createTextNode( "" );
		parentNode.insertBefore( t, node.nextSibling );
		selection.collapse( t, 0 );
	}
}


// mozilla selects the trailing <br> element in an editable doc
// when the user selects all
TC.WordSelect.prototype.fixSelection = function()
{
	// get selection
	var selection = TC.getSelection( this.element );
	var range = TC.createRange( selection, this.element );
	if( !range )
		return;
	
	// mozilla
	if( range.startContainer )
	{
		// only handle non-collapsed selections
		if( range.collapsed )
			return;
		
		// get last node in selection
		var node = range.endContainer;
		if( node.nodeType == 1 && range.endOffset > 0 )
			node = node.childNodes[ range.endOffset - 1 ];
		else if( node.nodeType == 3 && range.endOffset == 0 )
			node = node.previousSibling;
		else
			node = node.lastChild;
		
		// look for <br> and move it out of the selection
		if( node && node.nodeType == 1 && node.tagName.toLowerCase() == "br" )
			range.setEndBefore( node );
	}
}


TC.WordSelect.prototype.selectWord = function( evt )
{
	// get selection
	var selection = TC.getSelection( this.element );
	var range = TC.createRange( selection, this.element );
	if( !range )
		return;
	
	// mozilla
	if( range.startContainer )
	{
		// only handle collapsed text ranges for now
		if( !range.collapsed || range.startContainer.nodeType != 3 )
			return;
		
		// find leading whitespace
		var startNode = range.startContainer;
		var startOffset = 0;
		var text = startNode.data.substr( 0, range.startOffset ) + "T";
		while( startOffset <= 0 )
		{
			startOffset = text.search( /\S+$/ );
			if( startOffset <= 0 )
			{
				var node = TC.getPreviousTextNode( startNode, true );
				if( node )
				{
					startNode = node;
					startOffset = 0;
					text = node.data + "T";
				}
				else
				{
					startOffset = 0;
					break;
				}
			}
		}
		
		// find trailing whitespace
		var endNode = range.endContainer;
		var endOffset = 0;
		text = endNode.data.substr( range.endOffset, endNode.data.length );
		while( endOffset <= 0 )
		{
			endOffset = text.search( /\s/ );
			if( endOffset == 0 )
				break;
			else if( endOffset < 0 )
			{
				var node = TC.getNextTextNode( endNode, true );
				if( node )
				{
					endNode = node;
					endOffset = 0;
					text = node.data;
				}
				else
				{
					endOffset = endNode.data.length;
					break;
				}
			}
		}
		
		// clamp
		if( endNode == range.endContainer )
			endOffset += range.endOffset;
		if( endOffset > endNode.data.length )
			endOffset = endNode.data.length;
		
		// select
		try
		{
			selection.collapse( startNode, startOffset );
			selection.extend( endNode, endOffset );
			// alert( "'" + selection.toString() + "'" );
		}
		catch( e ) {}
	}
	
	// ie
	else if( TC.defined( range.text ) )
	{
		// setup
		range.expand( "word" );
		if( range.text.length == 0 )
			range.moveEnd( "character", 1000000 );
		
		// trim leading whitespace
		var start = range.text.search( /\S/ );
		if( start < 0 )
			start = 0;
		range.moveStart( "character", start );
		
		// trim trailing whitespace
		var end = range.text.search( /\s/ );
		if( end < 0 )
			end = range.text.length;
		if( end == 0 )
			end = 1;
		
		// shrink range to actual word, minus whitespace
		range.collapse( true );
		range.moveEnd( "character", end );
		
		// select
		range.select();
	}
	
	// cancel event
	if( evt )
	{
		TC.stopEvent( evt );
		return false;
	}
}


TC.WordSelect.prototype.bubbleBreaks = function( element )
{
	if( !element )
		element = this.element;
	
	// only examine nodes with children
	if( !element.hasChildNodes )
		return;
		
	// recurse to children
	var node = element.firstChild;
	while( node )
	{
		this.bubbleBreaks( node );
		node = node.nextSibling;
	}
	
	// only examine inline nodes with parent
	var parent = element.parentNode;
	if( !parent || !TC.isInlineNode( element ) )
		return;
	
	// find trailing breaks
	node = element.lastChild;
	while( node && node.nodeType == 1 && node.tagName.toLowerCase() == "br" )
	{
		// move break immediately outside element
		element.removeChild( node );
		parent.insertBefore( node, element.nextSibling );
		node = element.lastChild;
	}
}
