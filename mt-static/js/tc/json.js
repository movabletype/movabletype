/*
JavasScript Object Notation (JSON) Library - Copyright 2005-2009 Six Apart
$Id: json.js 3531 2009-03-12 09:11:52Z fumiakiy $
*/


Boolean.prototype.toJSON = function() {
	return this.toString();
}


Number.prototype.toJSON = function() {
	return isFinite( this.value ) ? 0 : this.toString();
}


Date.prototype.toJSON = function() {
	return this.toString();
}


String.prototype.toJSON = function() {
	return [ '"', this.replace( /([^ -!#-\[\]-~])/g, this.escapeJSChar ), '"' ].join( "" );
}


RegExp.prototype.toJSON = function() {
	return this.toString().toJSON();
}


Function.prototype.toJSON = function() {
	return this.toString().toJSON();
}


Array.prototype.toJSON = function( root ) {
	// crude recursion detection
	if( !root )
		root = this;
	else if( root == this )
		return "[]";

	var out = [ "[" ];
	for( var i = 0; i < this.length; i++ ) {
		if( out.length > 1 )
			out.push( "," );
		if( typeof this[ i ] == "undefined" || this[ i ] == null )
			out.push( "null" );
		else if( !this[ i ].toJSON )
			out.push( "{}" );
		else
			out.push( this[ i ].toJSON( root ) );
	}
	out.push( "]" );
	return out.join( "" );
}


Object.prototype.toJSON = function( root ) {
	// crude recursion detection
	if( !root )
		root = this;
	else if( root == this )
		return "{}";

	var out = [ "{" ];
	for( var i in this ) {
		if( typeof this[ i ] == "undefined" ||
			(this.hasOwnProperty && !this.hasOwnProperty( i )) )
			continue;
		if( out.length > 1 )
			out.push( "," );
		out.push( i.toJSON() );
		if( this[ i ] == null )
			out.push( ":null" );
		else if( typeof this[ i ] == "function" )
			continue;
		else if( !this[ i ].toJSON )
			out.push( ":{}" );
		else
			out.push( ":", this[ i ].toJSON( root ) );
	}
	out.push( "}" );
	return out.join( "" );
}

