/*
DOM Proxy JavaScript Library
$Id: Proxy.js 159 2007-04-24 01:05:37Z ydnar $

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


DOM.Proxy = new Class( Object, {

    LEADING: -1,
    INITIAL: 0,
    TRAILING: 1,
    
    
    /**
     * class <code>DOM.Proxy</code>
     * Initializes a document object model (dom) node, for proxying by this class.
     * @param node <code>Node</code> A dom node.
     */
    init: function( startNode ) {
        this.startNode = startNode;
        this.update( startNode );
    },
    
    
    /**
     * class <code>DOM.Proxy</code>
     * Updates a node with either of the supplied parameters, and adds references onto the proxy 
     * that refer to dom node properties.
     * @param node <code>Node</code> OPTIONAL 
     * @param edge <code>integer</code> OPTIONAL 
     * @return <code>Node</code> The dom node.
     */
    update: function( node, edge ) {
        if( !node )
            return;
        
        this.node = node || this.node;
        this.edge = edge || this.INITIAL;
        
        this.nodeType = this.node.nodeType || 0;
        this.nodeName = this.node.nodeName || "";
        this.nodeValue = this.node.nodeValue || "";
        this.tagName = this.node.tagName || "";
        this.attributes = this.node.attributes || [];
        this.parentNode = this.node.parentNode;
        this.previousSibling = this.node.previousSibling;
        this.nextSibling = this.node.nextSibling;
        this.firstChild = this.node.firstChild;
        this.lastChild = this.node.lastChild;
        this.childNodes = this.node.childNodes || [];
        this.empty = false;
        
        return node;
    },
    

    /**
     * class <code>DOM.Proxy</code>
     * Gets the previous node in the current walk of the tree.
     * @return <code>Node</code> A dom node OR <code>undefined</code>
     */
    getPreviousNode: function() {
        if( !this.node )
            return undefined;
        
        if( this.lastChild && this.edge != this.LEADING && !this.empty )
            return this.update( this.lastChild, this.TRAILING ); // down
        
        if( this.previousSibling )
            return this.update( this.previousSibling, this.TRAILING ); // left
            
        if( this.parentNode )
            return this.update( this.parentNode, this.LEADING ); // up
        
        return undefined; // borked
    },

    
    /**
     * class <code>DOM.Proxy</code>
     * Gets the previous node in the current walk of the tree.
     * @return <code>Node</code> A dom node OR <code>undefined</code>
     */
    getNextNode: function() {
        if( !this.node )
            return undefined;
        
        if( this.firstChild && this.edge != this.TRAILING && !this.empty )
            return this.update( this.firstChild, this.LEADING ); // down
        
        if( this.nextSibling )
            return this.update( this.nextSibling, this.LEADING ); // right
        
        if( this.parentNode )
            return this.update( this.parentNode, this.TRAILING ); // up
        
        return undefined; // borked
    },
    
    
    /**
     * class <code>DOM.Proxy</code>
     * Generate the markup needed to describe the node (including its subtree, if any).
     * @return <code>string</code> The markup representation of this node.
     */
    toSource: function() {
        return this.serialize.apply( this, arguments );
    },
    
    
    /**
     * class <code>DOM.Proxy</code>
     * Generate the markup needed to describe the node (including its subtree, if any).
     * @return <code>string</code> The markup representation of this node.
     */    
    serialize: function() {
        switch( this.nodeType ) {
            case Node.TEXT_NODE:
                return this.serializeTextNode();
                
            case Node.COMMENT_NODE:
                return this.serializeComment();
            
            case Node.ELEMENT_NODE:
                return this.serializeElement();
            
            default:
                log( "Unknown nodeType: " + this.nodeType );
        }
        return "";
    },

    
    /**
     * class <code>DOM.Proxy</code>
     * Serialize the child nodes of this node, if any.
     * @return <code>string</code> The markup representation of the child nodes of this node.
     */        
    serializeChildNodes: function() {
        var source = "";
        for( var i = 0; i < this.childNodes.length; i++ ) {
            var proxy = new this.constructor( this.childNodes[ i ] );
            source += proxy.serialize();
        }
        return source;
    },


    /**
     * class <code>DOM.Proxy</code>
     * Serialize this text node.
     * @return <code>string</code> The markup representation of this value of this text node.
     */    
    serializeTextNode: function() {
        return this.nodeValue.encodeHTML();
    },


    /**
     * class <code>DOM.Proxy</code>
     * Serialize this comment node.
     * @return <code>string</code> The markup representation of this value of this comment node 
     *         (i.e., the value enclosed between '<!' and '>', in addition to the standard xml 
     *         comment delimeter ('--') ).
     */    
    serializeComment: function() {
        return "<!-- " + this.nodeValue.encodeHTML() + " -->";
    },


    /**
     * class <code>DOM.Proxy</code>
     * Serialize this element node. 
     * @return <code>string</code> The markup representation of this value of this element. 
     */    
    serializeElement: function() {
        if( !this.tagName )
            return "";
        
        var source = "<" + this.tagName;
        source += this.serializeAttributes();
        
        if( this.empty )
            source += " />";
        else {
            source += ">";
            source += this.serializeChildNodes();
            source += "</" + this.tagName + ">";
        }
        
        return source;
    },
    
    
    /**
     * class <code>DOM.Proxy</code>
     * Serialize the attributes of this node. 
     * @return <code>string</code> The markup representation of these attributes. 
     */    
    serializeAttributes: function() {
        var source = "", value;
        for( var i = 0; i < this.attributes.length; i++ ) {
            var name = this.attributes[ i ].nodeName;
            value = this.attributes[ i ].nodeValue;
            if ( exists( value ) && typeof value != "boolean" )
                value = value.toString().encodeHTML();
            else 
                value = "";
            source += " " + name + "=\"" + value + "\"";
        }
        return source;
    }
} );


/* static methods */

extend( DOM.Proxy, {
    /**
     * class <code>DOM.Proxy</code>
     * This is a static method.<br/>
     * It invokes the callback parameter on every previous node to the node parameter until a 
     * not-<code>undefined</code> return value is obtained from the callback.
     * @param node <code>Node</code> A dom node.
     * @param callback <code>function</code> A function / bound-method to call on every discovery of
     *                              a successive, previous node.
     * @return <code>any</code> The result of an invocation of the callback OR <code>undefined</code>
     */    
    forPrevious: function( node, callback ) {
        var proxy = new this( node );
        while( node = proxy.getPreviousNode() ) {
            var out = callback( node, proxy.startNode );
            if( defined( out ) )
                return out;
        }
        return undefined;          
    },
    
    
    /**
     * class <code>DOM.Proxy</code>
     * This is a static method.<br/>
     * It invokes the callback parameter on every next node to the node parameter until a 
     * not-<code>undefined</code> return value is obtained from the callback.
     * @param node <code>Node</code> A dom node.
     * @param callback <code>function</code> A function / bound-method to call on completion.
     * @return <code>any</code> The result of an invocation of the callback OR <code>undefined</code>     
     */    
    forNext: function( node, callback ) {
        var proxy = new this( node );
        while( node = proxy.getNextNode() ) {
            var out = callback( node, proxy.startNode );
            if( defined( out ) )
                return out;
        }
        return undefined;
    },

    
    /**
     * class <code>DOM.Proxy</code>
     * This is a static method.<br/>
     * It returns the previous text node to the parameter node, if any
     * @param node <code>Node</code> A dom node.
     * @return <code>Node</code> OR <code>undefined</code>.
     */    
    getPreviousTextNode: function( node ) {
        return this.forPrevious( node, DOM.isTextNode );
    },

    
    /**
     * class <code>DOM.Proxy</code>
     * This is a static method.<br/>
     * It returns the previous inline text node to the parameter node, if any.
     * @param node <code>Node</code> A dom node OR <code>undefined</code>.
     * @return <code>Node</code> OR <code>undefined</code>.
     */    
    getPreviousInlineTextNode: function( node ) {
        return this.forPrevious( node, DOM.isInlineTextNode );
    },

    
    /**
     * class <code>DOM.Proxy</code>
     * This is a static method.<br/>
     * It returns the text node next to the parameter node, if any.
     * @param node <code>Node</code> A dom node OR <code>undefined</code>.
     * @return <code>Node</code> OR <code>undefined</code>.
     */    
    getNextTextNode: function( node ) {
        return this.forNext( node, DOM.isTextNode );
    },

    
    /**
     * class <code>DOM.Proxy</code>
     * This is a static method.<br/>
     * It returns the inline text node next to the parameter node, if any.
     * @param node <code>Node</code> A dom node OR <code>undefined</code>.
     * @return <code>Node</code> OR <code>undefined</code>.
     */    
    getNextInlineTextNode: function( node ) {
        return this.forNext( node, DOM.isInlineTextNode );
    },
    
    
    /**
     * class <code>DOM.Proxy</code>
     * This is a static method.<br/>  
     * It searches a node and its tree, if any, for matching text in a text node value.
     * @param node <code>Node</code> A dom node. 
     * @param text <code>string</code> The text to search for.
     * @return <code>Object</code> A hash with property <code>node</code> set to 
     *                             the node where the text was found or to <code>undefined</code>,
     *                             and a property <code>offset</code>
     *                             set to either an <code>int</code> (position of the found text in 
     *                             the text node value) or to <code>0</code>.
     */    
    findText: function( node, text ) {
        if( node.nodeType == Node.TEXT_NODE ) {
            var offset = node.nodeValue.indexOf( text );
            if( offset >= 0 )
                return { node: node, offset: offset };
        } else if( node.nodeType == ELEMENT_NODE && node.childNodes ) {
            for( var i = 0; i < node.childNodes.length; i++ ) {
                var found = this.findText( node.childNodes[ i ], text );
                if( found.node )
                    return found;
            }   
        }
        return { node: undefined, offset: 0 };
    },
    
    
    /**
     * class <code>DOM.Proxy</code>
     * This is a static method.<br/>
     * It finds the first text node that exists in a series of text nodes that contains as much 
     * as or more text characters as specified by the parameter <code>offset</code>.
     * @param node <code>Node</code> A dom node. 
     * @param offset <code>int</code> The number of characters to find.
     * @return <code>Object</code> A hash with property <code>node</code> set to 
     *                             the node where the text position was found or to <code>undefined</code>,
     *                             and a property <code>offset</code>
     *                             set to either an <code>int</code> (the difference between the length of the 
     *                             <code>node</code> in the hash and the parameter <code>offset</code>) 
     *                             or to <code>0</code>.       
     */    
    findTextPosition: function( node, offset ) {
        var position = { node: undefined, offset: 0 };
        while( node ) {
            if( node.nodeType == Node.TEXT_NODE ) { 
                position.offset += node.length;
                var delta = position.offset - offset;
                if( delta >= 0 ) {
                    position.node = node;
                    position.offset = node.length - delta;
                    break;
                }
            }
            node = this.getNextTextNode( node );
        }
        return position;
    },
    
    
    /**
     * class <code>DOM.Proxy</code>
     * This is a static method.<br/>
     * Generate the markup needed to describe the parameter <code>node</code> (including its subtree, if any).
     * @param node <code>Node</code> A dom node.
     * @return <code>string</code> The markup representation of this node.
     */    
    serialize: function( node ) {
        var proxy = new this( node );
        return proxy.serialize();
    },
    
    
    /**
     * class <code>DOM.Proxy</code>
     * This is a static method.<br/>
     * Serialize the child nodes of the parameter <code>node</code>, if any.
     * @param node <code>Node</code> A dom node.
     * @return <code>string</code> The markup representation of the child nodes of this node.
     */    
    serializeChildNodes: function( node ) {
        var proxy = new this( node );
        return proxy.serializeChildNodes();
    }
} );
