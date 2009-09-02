/* 
AdEngine
$Id: AdEngine.js 226 2007-09-18 18:20:57Z janine $

Copyright (c) 2006, Six Apart, Ltd.
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

AdEngine = {

    /* called from window.onload ONLY on the logged out blog side (view) */
    init: function() {
        var es = document.getElementsByTagName( "script" );
        for ( var i = 0; i < es.length; i++ ) {
            var ar = es[ i ].getAttribute( "defersrc" );
            if( !ar )
                continue;
        
            var cl = es[ i ].cloneNode( true );
            if ( !cl )
                continue;

            cl.setAttribute( "src", ar );
            cl.removeAttribute( "defersrc" );
        
            /* replace new, old */
            try {
                es[ i ].parentNode.replaceChild( cl, es[ i ] );
            } catch (e) {}
        }
    },
    
    
    insertAdResponse: function( params ) {
        var e = document.getElementById( params.id );
        if( !e )
            return;
        if( params.html ) {
            var e2 = document.createElement( "div" );
            e2.innerHTML = params.html;
            e.innerHTML = ""; // clear old content
            e.appendChild( e2 );
        }
        if( params.js )
            return eval( "(" + params.js + ")" );
    },

    insertAdsMulti: function( params ) {
        var i = 0;
        for (i = 0; i < params.length; i++) {
            AdEngine.insertAdResponse( params[i] );
        }
    }

};
