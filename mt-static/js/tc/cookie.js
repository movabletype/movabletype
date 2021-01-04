/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
*/


/*
--------------------------------------------------------------------------------
TC.Cookie
netscape cookie handling class
--------------------------------------------------------------------------------
*/

/* constructor */

TC.Cookie = function( name, value, domain, path, expires, secure )
{
	this.name = name;
	this.value = value;
	this.domain = domain;
	this.path = path;
	this.expires = expires;
	this.secure = secure;
}


/* static methods */

TC.Cookie.fetch = function( name )
{
	var cookie = new TC.Cookie( name );
	cookie.fetch();
	return cookie;
}


TC.Cookie.bake = function( name, value, domain, path, expires, secure )
{
	var cookie = new TC.Cookie( name, value, domain, path, expires, secure );
	cookie.bake();
	return cookie;
}


/* instance methods */

TC.Cookie.prototype.fetch = function()
{
	if( this.name == null )
		return false;
	
	// parse document.cookie
	var dc = document.cookie;
	var prefix = this.name + "=";
	var start = dc.indexOf( "; " + prefix );
	if( start > 0 )
		start += 2;
	else
	{
		start = dc.indexOf( prefix );
		if( start != 0 )
			return null;
	}
	var end = document.cookie.indexOf( ";", start );
	if( end < 0 )
		end = dc.length;
	// set value and return
	this.value = unescape( dc.substring( start + prefix.length, end ) );
	return true;
}


TC.Cookie.prototype.bake = function()
{
	if( this.name == null || this.value == null )
		return false;
	var string = this.name + "=" + escape( this.value ) +
		(this.domain ? "; domain=" + escape( this.domain ) : "") +
		(this.path ? "; path=" + escape( this.path ) : "") +
		(this.expires ? "; expires=" + this.expires.toGMTString() : "") +
		(this.secure ? "; secure=1"  : "");
	document.cookie = string;
	return true;
}
