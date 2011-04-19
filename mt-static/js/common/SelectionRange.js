/*
SelectionRange Class - Copyright 2005 Six Apart
$Id: SelectionRange.js 164 2007-04-25 20:41:19Z ydnar $
*/


SelectionRange = new Class( Object, {
    init: function() {
        // mozilla selection
        if( arguments[ 0 ].getRangeAt )
            this.fromMozillaSelection( arguments[ 0 ] );
        
        // khtml (safari) selection
        else if( arguments[ 0 ].setBaseAndExtent )
            this.fromKHTMLSelection( arguments[ 0 ] );
        
        // w3c range
        else if( arguments[ 0 ].selectNodeContents )
            this.fromRange( arguments[ 0 ] );
        
        // internet explorer selection
        else if( arguments[ 0 ].createRange )
            this.fromIESelection( arguments[ 0 ] );
        
        // internet explorer control range
        else if( arguments[ 0 ].addElement )
            this.fromIEControlRange( arguments[ 0 ] );
        
        // internet explorer text range
        else if( arguments[ 0 ].compareEndPoints )
            this.fromIETextRange( arguments[ 0 ] );
        
        // 4-argument form
        else {
            this.startContainer = arguments[ 0 ];
            this.startOffset = arguments[ 1 ];
            this.endContainer = arguments[ 2 ] || arguments[ 0 ];
            this.endOffset = arguments[ 3 ] || arguments[ 1 ];
        }
    },
    
    
    fromMozillaSelection: function( selection ) {
        var range = selection.getRangeAt( 0 );
        this.fromRange( range );
    },
    
    
    fromKHTMLSelection: function( selection ) {
        this.startContainer = selection.baseNode;
        this.startOffset = selection.baseOffset;
        this.endContainer = selection.extentNode;
        this.endOffset = selection.extentOffset;
    },
    
    
    fromIESelection: function( selection ) {
        var range = selection.createRange();
        this.fromIERange( range );
    },
    
    
    fromRange: function( range ) {
        this.startContainer = range.startContainer;
        this.startOffset = range.startOffset;
        this.endContainer = range.endContainer;
        this.endOffset = range.endOffset;
    },
    
    
    fromIERange: function( range ) {
        if( range.addElement )
            this.fromIEControlRange( range );
        else if( range.compareEndPoints )
            this.fromIETextRange( range );
    },
    
    
    fromIEControlRange: function( range ) {
        // fixme: this is kinda broken
        this.startContainer = range.item( 0 );
        this.startOffset = 0;
        this.endContainer = range.item( range.length - 1 );
        this.endOffset = 0;
    },
    
    
    fromIETextRange: function( range ) {
        var position = this.findIETextRangePosition( range, "StartToStart" );
        this.startContainer = position.node;
        this.startOffset = position.offset;
        
        position = this.findIETextRangePosition( range, "EndToEnd" );
        this.endContainer = position.node;
        this.endOffset = position.offset;
    },
    
    
    findIETextRangePosition: function( range, compareType ) {
        var range2 = range.duplicate();
        range2.collapse( true );
        var parent = range2.parentElement();
        range2.moveToElementText( parent );
        var length = range2.text.length;
        var delta = max( 1, finiteInt( length * 0.5 ) );
        range2.collapse( true );
        var offset = 0;
        var offsets = {};
        var steps = 0;
        var broken = false;
        
        /* this breaks if the user selects all, where the selection endpoint is at the end of body */
        /* hence storing previously-visited offsets */
        
        while( test = range2.compareEndPoints( compareType, range ) ) {
            if( test < 0 ) {
                range2.move( "character", delta );
                offset += delta;
            } else {
                range2.move( "character", -delta );
                offset -= delta;
            }
            
            delta = max( 1, finiteInt( delta * 0.5 ) );
            
            /* visited this offset before? */
            if( offsets[ offset ] === offset ) {
                broken = true;
                break;
            }
            offsets[ offset ] = offset;
            
            /* infinite loop bug */
            steps++;
            if( steps > 1000 || (offset < 0 || offset > length + 1) ) {
                broken = true;
                break;
            }
        }
        
        /*
        if( broken )
            log( "BROKEN: " + parent.tagName + " " + length + " " + compareType + " " + test + " " + delta + " " + offset );
        else
            log( "GOOD: " + parent.tagName + " " + offset );
        */
        
        return DOM.Proxy.findTextPosition( parent, offset );
    },
    
    
    setStart: function( startContainer, startOffset ) {
        this.startContainer = startContainer;
        this.startOffset = startOffset;
    },
    
    
    setEnd: function( endContainer, endOffset ) {
        this.endContainer = endContainer;
        this.endOffset = endOffset;
    },
    
    
    collapse: function( toStart ) {
        if( toStart )
            this.setEnd( this.startContainer, this.startOffset );
        else
            this.setStart( this.endContainer, this.endOffset );
    },
    
    
    getCommonAncestorContainer: function() {
        if( this.startContainer == this.endContainer )
            return this.startContainer;
        var start = DOM.getAncestors( this.startContainer, true );
        var end = DOM.getAncestors( this.endContainer, true );
        var common = null;
        for( i = 1; i <= start.length && i <= end.length; i++ ) {
            if( start[ start.length - i ] == end[ end.length - i ] )
                common = start[ start.length - i ];
        }
        return common;
    },
    
    
    getNodes: function() {
        var nodes = [];
        if( !this.startContainer )
            return nodes;
        nodes.push( this.startContainer );
        if( this.startContainer === this.endContainer &&
            (this.startOffset == this.endOffset || !this.startContainer.firstChild) )
            return nodes;
        var proxy = new DOM.Proxy( this.startContainer );
        while( proxy.getNextNode() && proxy.node != this.endContainer )
            nodes.push( proxy.node );
        return nodes;
    },
    
    
    getTextNodes: function() {
        var proxy = new DOM.Proxy( this.startContainer );
        var nodes = proxy.node.nodeType == Node.TEXT_NODE ? [ proxy.node ] : [];
        while( proxy.node != this.endContainer ) {
            proxy.getNextNode();
            if( proxy.node.nodeType == Node.TEXT_NODE )
                nodes.push( proxy.node );
        }
        return nodes;
    },
    
    
    surround: function( tagName, attributes ) {
        // fixme: make this work with non-text nodes
        if( this.startContainer.nodeType != Node.TEXT_NODE ||
            this.endContainer.nodeType != Node.TEXT_NODE )
            return;
        
        var nodes = this.getTextNodes();
        var last;
        for( var i = 0; i < nodes.length; i++ ) {
            var node = nodes[ i ];
            var startOffset = i == 0
                ? this.startOffset
                : 0;
            var endOffset = i == (nodes.length - 1)
                ? this.endOffset
                : node.nodeValue.length
            var inside = this.surroundTextNode( node, startOffset, endOffset, tagName, attributes );
            if( i == 0 )
                this.setStart( inside, 0 );
            if( i == (nodes.length - 1) )
                this.setEnd( inside, inside.nodeValue.length );
        }
        
        return last;
    },
    
    
    surroundTextNode: function( node, startOffset, endOffset, tagName, attributes ) {
        var document = this.startContainer.ownerDocument;
        
        var parent = node.parentNode;
        if( endOffset < startOffset ) {
            var temp = endOffset;
            endOffset = startOffset;
            startOffset = temp;
        }
        
        var element = document.createElement( tagName );
        for( var attribute in attributes ) {
            if( attributes.hasOwnProperty( attribute ) ) {
                if( attribute == "class" )
                    element.className = attributes[ attribute ];
                else
                    element.setAttribute( attribute, attributes[ attribute ] );
            }
        }
        
        var value = node.nodeValue;
        
        var inner = document.createTextNode( value.substring( startOffset, endOffset ) );
        element.appendChild( inner );
        parent.replaceChild( element, node );
        
        if( startOffset > 0 ) {
            var before = document.createTextNode( value.substring( 0, startOffset ) );
            parent.insertBefore( before, element );
        }
        
        if( endOffset < value.length ) {
            var after = document.createTextNode( value.substring( endOffset, value.length ) );
            parent.insertBefore( after, element.nextSibling );
        }
        
        return inner;
    },
    
    
    replaceText: function( value ) {
        var offset = 0;
        var nodes = this.getTextNodes();
        for( var i = 0; i < nodes.length; i++ ) {
            var node = nodes[ i ];
            var nodeValue = node.nodeValue;
            
            if( offset >= value.length && value.length > 0 )
                value = "";
            
            if( node === this.startContainer ) {
                var delta = nodeValue.length - this.startOffset;
                if( delta > (value.length - offset) ||
                    node === this.endContainer )
                    delta = value.length - offset;
                node.nodeValue = nodeValue.substring( 0, this.startOffset )
                    + value.substr( offset, delta );
                offset += delta;
            } else if( node === this.endContainer ) {
                node.nodeValue = value.substring( offset, value.length ) +
                    nodeValue.substring( this.endOffset, nodeValue.length );
                offset = value.length;
            } else {
                var delta = nodeValue.length;
                node.nodeValue = value.substr( offset, delta );
                offset += delta;
            }
        }
    }
} );
