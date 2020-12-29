/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
*/


/*
--------------------------------------------------------------------------------
TC.Alert
overrides JavaScript's built-in alert() method, putting the results in a newly
spawned console window
--------------------------------------------------------------------------------
*/

/* constructor */

TC.Alert = function()
{
	this.createWindow();
	this.count = this.prev ? this.prev.count : 0;
}


/* config */

TC.Alert.width = 640;
TC.Alert.height = 420;
TC.Alert.windowName = "alert";


/* static variables */

TC.Alert.instance = null;


/* static methods */

TC.Alert.alert =
TC.alert = function( msg )
{
	if( !TC.Alert.instance )
		TC.Alert.instance = new TC.Alert();
	if( TC.Alert.instance )
		return TC.Alert.instance.alert( msg );
	return true;
}


/* instance methods */

TC.Alert.prototype.alert = function( msg )
{
	// create window
	this.createWindow();
	
	// check for no window
	if( !this.window )
	{
		confirm( "Alert popup window blocked. Using confirm() instead.\n\n" + msg );
		return true;
	}
	
	// create div
	var div = this.window.document.createElement( "div" );
	div.style.backgroundColor = (this.count % 2) ? "#eee" : "#fff";
	div.style.width = "auto";
	div.style.padding = "8px";
	div.innerHTML = msg;
	
	// append to window
	this.window.document.body.appendChild( div );
	
	// scroll window to bottom
	this.window.scroll( 0, this.window.document.body.scrollHeight );
	
	// increment msg count
	this.count++;
	
	// end
	return true;
}


TC.Alert.prototype.createWindow = function()
{
	if( this.window && this.window.document )
		return;
	
	// create window
	var x = "auto";
	var y = "auto";
	var attr = "resizable=yes, menubar=no, location=no, directories=no, scrollbars=yes, status=no, " +
		"width=" + TC.Alert.width + ", height=" + TC.Alert.height + 
		"screenX=" + x + ", screenY=" + y + ", " +
		"left=" + x + ", top=" + y + ", ";
	this.window = window.open( "", this.windowName, attr );
	
	// check for blocked popup
	if( !this.window )
		return;
	
	// write body
	this.window.document.write( "<html><head><title>JavaScript Alerts</title></head><body></body></html>" );
	
	// setup style
	this.window.title = "JavaScript Alerts";
	this.window.document.body.style.margin = "0";
	this.window.document.body.style.padding = "0";
	this.window.document.body.style.fontFamily = "verdana, 'lucida grande', geneva, arial, helvetica, sans-serif";
	this.window.document.body.style.fontSize = "10px";
	
	// get previous instance and attach new instance
	this.prev = this.window.tcai;
	this.window.tcai = this;
	
	// dereference previous previous
	if( this.prev )
		this.prev.prev = null;
}


/* overrides */

window.alert = TC.Alert.alert;	// msie
alert = TC.Alert.alert;			// moz
