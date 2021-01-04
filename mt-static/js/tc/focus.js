/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
*/


/*
--------------------------------------------------------------------------------
TC.Focus
focus handling class
--------------------------------------------------------------------------------
*/

/* constructor */

TC.Focus = function( rootElement, className, tagNames )
{
	this.rootElement = TC.elementOrId( rootElement );
	if( className )
		this.className = className;
	if( tagNames )
		this.tagNames = tagNames;
	this.elements = [];
	
	// create closures
	var self = this;
	this.focusClosure = function( evt )
	{
		return self.focus( evt );
	};
	
	// attach event handlers
	TC.attachDocumentEvent( window, "focus", this.focusClosure, true );
	TC.attachDocumentEvent( window, "focusin", this.focusClosure, true );	// ie
	TC.attachDocumentEvent( window, "mousedown", this.focusClosure, true );
}


/* focus */

TC.Focus.prototype.className = "focus";
TC.Focus.prototype.tagNames = [];


/* instance methods */

TC.Focus.prototype.focus = function( evt )
{
	evt = evt || event;
	var element = evt.target || evt.srcElement;
	if (!element) return;

	// skip document elements or get parent of text nodes
	if( element.nodeType == 9 )
		return;
	if( element.nodeType == 3 )
		element = element.parentNode;
	
	// unfocus?
	var unfocus = false;
	if( this.tagNames.length )
	{
		unfocus = true;
		var tagName = element.tagName.toLowerCase();
		for( var i = 0; i < this.tagNames.length; i++ )
		{
			if( tagName == this.tagNames[ i ] )
			{
				unfocus = false;
				break;
			}
		}
	}
	
	// create element list
	var elements = [];
	while( element )
	{
		elements[ elements.length ] = element;
		if( element == this.rootElement )
			break;
		element = element.parentNode;
	}
	
	// ignore if root not found
	if( this.rootElement && element != this.rootElement )
		return;
	
	// walk element lists
	var length = elements.length > this.elements.length
		? elements.length
		: this.elements.length;
	for( var i = 1; i <= length; i++ )
	{
		// get new and old elements from end of list
		// they should match up initially
		var newElement = unfocus ? null : elements[ elements.length - i ];
		var oldElement = this.elements[ this.elements.length - i ];
		
		// set/remove focus classname
		if( oldElement && oldElement != newElement )
			TC.removeClassName( oldElement, this.className );
		if( newElement )
			TC.addClassName( newElement, this.className );
	}
	
	// use new list
	this.elements = elements;
	
	// normal event processing
	return true;
}
