/*
JavasSript Object Notation (JSON) - Copyright 2005 Six Apart
$Id: JSON.js 264 2008-06-11 22:46:16Z ddavis $

Copyright (c) 2005-2006, Six Apart, Ltd.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

    * Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above
copyright notice, this list of conditions and the following disclaimer
in the documentation and/or other materials provided with the
distribution.

    * Neither the name of "Six Apart" nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/


extend( Object, {
    toJSON: function( o ) {
        if( !defined( o ) || o == null )
            return "null";
        if( typeof o.toJSON == "function" && o.toJSON !== arguments.callee )
            return o.toJSON();
        var out = [ "{" ];
        for( var p in o ) {
            if( o.hasOwnProperty && !o.hasOwnProperty( p ) )
                continue;
            if( o[ p ] === undefined ) /* http://search.cpan.org/~makamaka/JSON-1.09/lib/JSON.pm#Mapping */
                continue;
            if( out.length > 1 )
                out.push( "," );
            out.push( Object.toJSON( p ), ":", Object.toJSON( o[ p ] ) );
        }
        out.push( "}" );
        return out.join( "" );
    },
    
    
    fromJSON: function( s ) {
        try {
            return eval( "(" + s.replace( /=/g, "\\u003D" ).replace( /\(/g, "\\u0028" ) + ")" );
        } catch( e ) {}
        return undefined;
    }
} );


Array.prototype.toJSON = function() {
    var out = [ "[" ];
    for( var i = 0; i < this.length; i++ ) {
        if( out.length > 1 )
            out.push( "," );
        out.push( Object.toJSON( this[ i ] ) );
    }
    out.push( "]" );
    return out.join( "" );
}


Boolean.prototype.toJSON = function() {
    return this.toString();
}


Number.prototype.toJSON = function() {
    return isFinite( this ) ? this.toString() : "0";
}


Date.prototype.toJSON = function() {
    return this.toUTCISOString
        ? this.toUTCISOString().toJSON()
        : this.toString().toJSON();
}


String.prototype.toJSON = function() {
    return '"' + this.escapeJS() + '"';
}


RegExp.prototype.toJSON = function() {
    return this.toString().toJSON();
}


Function.prototype.toJSON = function() {
    return this.toString().toJSON();
}
