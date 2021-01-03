/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
*/


/*
--------------------------------------------------------------------------------
TC.Gestalt
browser capability checking class
--------------------------------------------------------------------------------
*/

/* constructor */

TC.Gestalt = function()
{
}


/* config */

TC.Gestalt.prototype.cookieName = "tc-gestalt";
TC.Gestalt.prototype.names =
[
	"document.addEventListener",
	"document.all",
	"document.appendChild",
	"document.attachEvent",
	"document.createElement",
	"document.designMode",
	"document.execCommand",
	"document.getElementById",
	"document.getElementsByName",
	"document.getElementsByTagName",
	"document.getSelection",
	"document.images",
	"document.implementation",
	"document.layers",
	"window.ActiveXObject",
	"window.frames",
	"window.getSelection",
	"window.XMLHttpRequest"
];


/* static variables */

TC.Gestalt.instance = null;


/* static methods */

TC.Gestalt.detect = function( name )
{
	var g = TC.Gestalt.init();
	if( g )
		g.detect();
}


TC.Gestalt.get = function( name )
{
	var g = TC.Gestalt.init();
	if( g )
		g.get( name );
}


TC.Gestalt.bake = function()
{
	var g = TC.Gestalt.init();
	if( g )
		g.bake();
}


TC.Gestalt.init = function()
{
	if( !TC.Gestalt.instance )
		TC.Gestalt.instance = new TC.Gestalt();
	return TC.Gestalt.instance;
}


/* instance methods */

TC.Gestalt.prototype.detect = function()
{
	this.init();
	var x;
	var y;
	
	// walk navigator
	if( navigator )
	{
		if( navigator.userAgent )
			this.properties[ "navigator.userAgent" ] = navigator.userAgent;
		for( var i in navigator )
		{
			if( i.toLowerCase() == "useragent" )
				continue;
			var value = navigator[ i ];
			if( typeof value == "string" )
				this.properties[ "navigator." + i ] = navigator[ i ];
			else if( typeof value == "boolean" )
				this.properties[ "navigator." + i ] = navigator[ i ] ? 1 : 0;
		}
	}
	
	// walk capability list
	for( var i in this.names )
	{
		var name = this.names[ i ];
		x = eval( name );
		this.properties[ name ] = (TC.defined( x ) && x != null) ? 1 : 0;
	}
	
	// dom/events
	this.properties[ "dom" ] =
		(document.getElementById && document.createElement) ? 1 : 0;
	this.properties[ "events" ] =
		(document.addEventListener || document.attachEvent) ? 1 : 0;
	
	// content editable
	this.properties[ "contentEditable" ] =
		(document.body && document.body.contentEditable != null) ? 1 : 0;
	
	// design mode
	this.properties[ "designMode" ] = 0;
	this.properties[ "execCommand" ] = 0;
	if( document.execCommand )
	{
		x = "" + typeof document.execCommand;
		y = "" + document.execCommand;
		if( x.indexOf( "function" ) == 0 || x.indexOf( "function" ) == 0 )
		{
			this.properties[ "designMode" ] = document.designMode ? 1 : 0;
			this.properties[ "execCommand" ] = 1;
		}
	}
	
	// xml http request
	if( window.XMLHttpRequest )
		x = new XMLHttpRequest();
	else if( window.ActiveXObject )
	{
		try { x = new ActiveXObject( "Microsoft.XMLHTTP" ); }
		catch( e ) { x = null; }
		if( !x )
			this.properties[ "window.ActiveXObject" ] = 0;
	}
	else
		x = null;
	this.properties[ "xmlRequest" ] = x ? 1 : 0;
	
	// first-pass check for platform
	this.properties[ "guess.platform" ] = 0;
	if( navigator.platform )
	{
		var platform = "" + navigator.platform;
		platform = platform.toLowerCase();
		if( platform.indexOf( "mac" ) >= 0 )
			this.properties[ "guess.platform" ] = "mac";
		else if( platform.indexOf( "mac" ) >= 0 )
			this.properties[ "guess.platform" ] = "windows";
	}
	
	// first-pass check for browser
	this.properties[ "guess.browser" ] = navigator.appName ? navigator.appName : 0;
	
	// create some dummy vars
	x = new Array();
	
	// mozilla (has xul controllers array)
	if( window.controllers )
	{
		this.properties[ "guess.browser" ] = "mozilla";
	}
	
	// recent ie windows (by selection and activex and document.all)
	else if( this.properties[ "window.ActiveXObject" ] && document.all &&
		!window.getSelection && !document.getSelection )
	{
		this.properties[ "guess.platform" ] = "windows";
		this.properties[ "guess.browser" ] = "ie";
	}
	
	// ie mac (array object does not support the shift method)
	else if( !x.shift && document.all )
	{
		this.properties[ "guess.platform" ] = "mac";
		this.properties[ "guess.browser" ] = "ie";
	}
	
	// safari (by selection)
	else if( window.getSelection && !document.getSelection )
	{
		this.properties[ "guess.browser" ] = "safari";
	}
	
	// opera (by useragent)
	else if( navigator.userAgent && navigator.userAgent.match( /opera/i ) )
	{
		this.properties[ "guess.browser" ] = "opera";
	}
	
	// icab (by useragent)
	else if( navigator.userAgent && navigator.userAgent.match( /icab/i ) )
	{
		this.properties[ "guess.browser" ] = "icab";
	}
	
	// screen
	if( screen )
	{
		this.properties[ "screen.width" ] = screen.width;
		this.properties[ "screen.height" ] = screen.height;
		this.properties[ "screen.colorDepth" ] = screen.colorDepth;
	}
	
	// done
	this.detected = true;
}


TC.Gestalt.prototype.get = function( name )
{
	this.init();
	if( !this.detected )
		this.detect();
	return this.properties[ name ];
}


TC.Gestalt.prototype.set = function( name, value )
{
	this.init();
	return this.properties[ name ] = value;
}


TC.Gestalt.prototype.toString = function()
{
	var value = '';
	for( var i in this.properties )
	{
		if( value )
			value += "&";
		value += escape( i ) + "=" + escape( this.properties[ i ] ? this.properties[ i ] : 0 );
	}
	return value;
}


TC.Gestalt.prototype.bake = function()
{
	this.init();
	if( !this.detected )
		this.detect();
	
	// create cookie
	if( !this.cookie )
	{
		if( TC.Cookie )
			this.cookie = new TC.Cookie( this.cookieName );
		if( !this.cookie )
			return;
	}
	
	// concat value
	var value = this.toString();
	
	// bake
	this.cookie.value = value;
	this.cookie.path = "/";
	this.cookie.bake();
}


TC.Gestalt.prototype.init = function()
{
	if( this.inited )
		return;
	this.detected = false;
	this.properties = [];
	this.inited = true;
}
