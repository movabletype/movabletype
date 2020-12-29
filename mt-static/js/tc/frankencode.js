/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
*/


/*
--------------------------------------------------------------------------------
TC.FrankenCode
testbed for utility, broken, and otherwise dangerous code. use at your own risk!
--------------------------------------------------------------------------------
*/


/* js 1.2 array methods */

if( !Array.prototype.concat )
{
	Array.prototype.concat = function()
	{
		return this.copy().push( arguments );
	};
	alert( "Array.prototype.concat" );
}

if( !Array.prototype.copy )
{
	Array.prototype.copy = function()
	{
		var out = [];
		for( var i = 0; i < this.length; i++ )
			out[ i ] = this[ i ];
		return out;
	};
}

if( !Array.prototype.push )
{
	Array.prototype.push = function()
	{
		for( var i = 0; i < arguments.length; i++ )
			this[ this.length + 1 ] = arguments[ i ];
		return this.length;		
	};
}

if( !Array.prototype.pop )
{
	Array.prototype.pop = function()
	{
		if( this.length == 0 )
			return undefined;
		var out = this[ this.length - 1 ];
		this.length--;
		return out;
	};
}

if( !Array.prototype.unshift )
{
	Array.prototype.unshift = function()
	{
		for( var i = 0; i < arguments.length; i++ )
		{
			this[ i + arguments.length ] = this[ i ];
			this[ i ] = arguments[ i ];
		}
		return this.length;		
	};
}

if( !Array.prototype.shift )
{
	Array.prototype.shift = function()
	{
		if( this.length == 0 )
			return undefined;
		var out = this[ 0 ];
		for( var i = 1; i < this.length; i++ )
			this[ i - 1 ] = this[ i ];
		this.length--;
		return out;
	};
}


/* json */

Object.prototype.toJSON = function( obj )
{
	obj = obj || this;
    var out = [];
    for( var i in obj )
    {
    	var iJSON = i.toString().toJSON();
    	if( obj[ i ] == null )
    		out.push( iJSON + ":null" );
    	else if( typeof obj[ i ] == "function" )
    		continue;
    	else if( !obj[ i ].toJSON )
    		out.push( iJSON + ":{}" ); // fixme: is this the right idea?
    	else
    		out.push( iJSON + ":" + obj[ i ].toJSON() );
    }
    return "{" + out.join( "," ) + "}";
}

Array.prototype.toJSON = function( obj )
{
	obj = obj || this;
    var out = [];
    for( var i = 0; i < obj.length; i++ )
    {
    	if( obj[ i ] == null )
			out.push( "null" );
		else if( typeof obj[ i ] == "function" || !obj[ i ].toJSON )
			out.push( "{}" ); // fixme: is this the right idea?
		else
			out.push( obj[ i ].toJSON() );
    }
    return "[" + out.join( "," ) + "]";
}

TC.matchJSON = /([\"\\])/g;
String.prototype.toJSON = function( obj )
{
	obj = obj || this;
    return "\"" + obj.replace( TC.matchJSON, "\\$1" ) + "\"";
}

Number.prototype.toJSON = function( obj )
{
	obj = obj || this;
    return obj.toString();
}

Boolean.prototype.toJSON = function( obj )
{
	obj = obj || this;
    return obj.toString();
}

Date.prototype.toJSON = function( obj )
{
	obj = obj || this;
    return obj.toString();
}
