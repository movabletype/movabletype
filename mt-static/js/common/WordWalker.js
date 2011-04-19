/*
DOM WordWalker Library
$Id: WordWalker.js 159 2007-04-24 01:05:37Z ydnar $

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

WordWalker = new Class( Object, {
    WORD_START: /[a-zA-Z0-9\u00C0-\u00FF\u0101-\u017F]/,                                     
    /*-
     * Note: To support French and Italian, either the server or client must break between apostrophes and vowels (i.e., "l'auberge").
     *       Currently, this client part does not do that.
     * Note: There is no support for lower-case (see the comment below, "Break Quoted") in Latin-Extended-A and Latin-Extended-B.
     * Note: ** KEEP "Word Boundary Rules" DOCUMENTATION ABOVE UP-TO-DATE **
     */
    //          Break after '.' char.:                                                       | Break quoted & '(s)'                     | Break-if-not-x-and-not-followed-by section:
    WORD_END: /\.(?=[^a-zA-Z\u00C0-\u00FF\u0101-\u017F0-9'\u2018,][^a-z\u00DF-\u00FF]|[\s]*$)|['"\u2018\u2019\u201c\u201d](?=\s|\)|\]|,)|[^a-zA-Z0-9\u00C0-\u00FF\u0101-\u017F\u2018\-\.'](?!\.\d)|s(?=\))/, 

     //           | Skip '(s)' and other optional pluralities (see if this can be improved for German and Italian; i.e., their equivalents of "documents(s)").

    init: function( rootNode, nodeFilter ) {
        this.rootNode = rootNode;
        this.nodeFilter = nodeFilter;
        this.reset();
    },
    
    
    reset: function() {
        this.range = undefined;
        this.word = undefined;
        this.length = 0;
        return undefined;
    },
    
    
    getNextWord: function() {
        if( defined( this.range ) ) {
            this.range.setStart( this.range.endContainer, this.range.endOffset );
            this.range.collapse( true );
        } else {
            this.reset();
            var node = DOM.Proxy.getNextTextNode( this.rootNode );
            if( !node )
                return undefined;
            this.range = new SelectionRange( node, 0 );
            this.range.collapse( true );
        }
        
        this.word = undefined;
        
        /* find word start */
        var proxy = new DOM.Proxy( this.range.startContainer );
        while( defined( proxy.node ) && !defined( this.word ) ) {
            if( proxy.node.nodeType == Node.TEXT_NODE ) {
                if( proxy.node != this.range.startContainer )
                    this.range.setStart( proxy.node, 0 );
                
                var value = proxy.node.nodeValue;
                var sub = value.substring( this.range.startOffset, value.length );
                
                var offset = sub.search( this.WORD_START );
                if( offset >= 0 )
                    this.word = "";
                else
                    offset = sub.length;
                this.range.startOffset += offset;
                this.range.collapse( true );
            }
            
            if( !defined( this.word ) )
                proxy.getNextNode();
            if( proxy.node === this.rootNode )
                break;
        }
        
        if( !defined( this.word ) )
            return this.reset();
        
        /* find word end */
        var done = false;
        while( !done && defined( proxy.node ) ) {
            if( proxy.node.nodeType == Node.TEXT_NODE ) {
                if( proxy.node != this.range.startContainer )
                    this.range.setEnd( proxy.node, 0 );
                
                var value = proxy.node.nodeValue;
                var sub = value.substring( this.range.endOffset, value.length );

                var offset = sub.search( this.WORD_END );
                if( offset >= 0 ) 
                    done = true;
                else
                    offset = sub.length;
                this.range.endOffset += offset;
                this.word += sub.substr( 0, offset );
            }

            proxy.getNextNode();
            if( !defined( proxy.node ) || proxy.node === this.rootNode || !DOM.isInlineNode( proxy.node ) )
                break;
        }
        
        /* end of document */
        if( this.word.length == 0 )
            return this.reset();
        
        this.length++;
        return this.word;
    }
} );
