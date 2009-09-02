/*
DOM Library
$Id: Convert.js 159 2007-04-24 01:05:37Z ydnar $

Copyright (c) 2005, Six Apart, Ltd.
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

  
extend( DOM, {
    detectHTML: function( html, filter ) {
        var e = document.createElement( "div" );
        e.innerHTML = html;
        DOM.mergeTextNodes( e );

        var ns = [];
        var proxy = new DOM.Proxy( e );
        do {
            var n = proxy.getNextNode();
            if( n.nodeType == Node.TEXT_NODE &&
                n.nodeValue.match( /<\/?[A-Za-z][A-Za-z0-9\-_]*[^>]*>/ ) ) {
                if( !filter || filter( n ) )
                    return true;
            }
        } while( n && n != e );
    },
    
    
    convertHTML: function( html, filter ) {
        var e = document.createElement( "div" );
        e.innerHTML = html;
        DOM.mergeTextNodes( e );

        var ns = [];
        var proxy = new DOM.Proxy( e );
        do {
            var n = proxy.getNextNode();
            if( n.nodeType == Node.TEXT_NODE ) {
                if( !filter || filter( n ) )
                    ns.push( n );
            }
        } while( n && n != e );
        
        var hs = [];
        for( var i = 0; i < ns.length; i++ ) {
            var n = ns[ i ];
            if( n.nodeValue.match( /<\/?[A-Za-z][A-Za-z0-9\-_]*[^>]*>/ ) ) {
                hs.push( n.nodeValue );
                n.nodeValue = "$$HTML" + (hs.length - 1) + "$$";
            }
        }

        return e.innerHTML.replace( /\$\$HTML(\d+)\$\$/g,
            function( m, n ) { return hs[ finiteInt( n ) ] } );
    }
} );
