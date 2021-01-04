/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
*/


/*
--------------------------------------------------------------------------------
TC.SpellCheck
live spell checking class
--------------------------------------------------------------------------------
*/

/* constructor */

TC.SpellCheck = function()
{
	this.eventElements = [];
	this.inputElements = [];
	this.displayElements = [];
	this.words = [];
	
	var self = this;
	this.processEventClosure = function( evt ) { return self.processEvent( evt ); };
	this.processWordsClosure = function() { return self.processWords(); };
}


/* config */

TC.SpellCheck.prototype.url = "/t/app/weblog/spell";
TC.SpellCheck.prototype.delay = 250; // milliseconds
TC.SpellCheck.prototype.updateDelay = 1000;


/* instance methods */

TC.SpellCheck.prototype.processEvent = function( evt )
{
	evt = evt || event;
	var element = evt.target || evt.srcElement;
	
	// debug testing
	for( var i in this.displayElements )
	{
		element = this.displayElements[ i ];
		if( element.body )
			element = element.body;
		var color = TC.ColorPicker.prototype.colors[ Math.floor( Math.random( 1.0 ) * 256 ) ];
		element.style.borderBottom = color + " solid 1px";
	}
	// alert( evt.type );
}


TC.SpellCheck.prototype.addEventElement = function( element )
{
	element = TC.elementOrId( element );
	if( !element )
		return;
	this.eventElements.push( element );
	TC.attachEvent( element, "change", this.processEventClosure );
	TC.attachEvent( element, "keydown", this.processEventClosure );
	TC.attachEvent( element, "drop", this.processEventClosure );
	TC.attachEvent( element, "dragdrop", this.processEventClosure );
	TC.attachEvent( element, "mouseup", this.processEventClosure );
}


TC.SpellCheck.prototype.addInputElement = function( element )
{
	element = TC.elementOrId( element );
	if( !element )
		return;
	this.inputElements.push( element );
}


TC.SpellCheck.prototype.addDisplayElement = function( element )
{
	element = TC.elementOrId( element );
	if( !element )
		return;
	this.displayElements.push( element );
}

