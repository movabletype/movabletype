/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
*/

/*
--------------------------------------------------------------------------------
TC.AutoComplete
auto-completion of words using an input box and a DHTML selection menu
--------------------------------------------------------------------------------
*/

/*
- Given an array of possible auto-completion words...
- Keep in memory the current word being typed
- on keyDown:
    - if the character is a space, kill the internal word memory
    - if the character is a tab, autocomplete with the selected word
    - otherwise, narrow down the list of possible matches
    - present a DHTML menu with the list of matches
*/

TC.AutoComplete = function( id, words )
{
    this.id = id;
    this.autoCompleteNode = new TC.AutoCompleteNode();
    for ( var i = 0; i < words.length; i++ )
        this.autoCompleteNode.add( words[i] );
    this.currentWord = '';
    TC.AutoComplete.instances[ this.id ] = this;
    this.clearCompletions();
    this.attachElements();
}

TC.AutoComplete.instances = new Array();

TC.AutoComplete.prototype.attachElements = function()
{
    if ( !this.attachAttempts )
        this.attachAttempts = 0;
    else if ( this.attachAttempts > 5 )
        return;
    this.attachAttempts++;
    
    if ( !this.input_box ) {
        this.input_box = document.getElementById(this.id);
        if ( this.input_box ) {
            var self = this;
            var keyDown = function( event ) { return self.keyDown( event ); }
            TC.attachEvent( this.input_box, "keydown", keyDown );
        }
    }
    
    if (!this.completion_box)
        this.completion_box = document.getElementById( this.id + '_completion' );
    
    // try again on failure
	if( !this.input_box )
        window.setTimeout( "TC.AutoComplete.instances[ '" + this.id + "' ].attachElements();", 1000 );
}

TC.AutoComplete.prototype.keyDown = function( evt )
{
    evt = evt || event;
    var element = evt.target || evt.srcElement;
    if ( evt.keyCode == 9 )
    {
        if (this.hasCompletions)
            this.handleAutoComplete();
        return TC.stopEvent( evt );
    }
    else if ( evt.keyCode == 8 )
        this.truncateWord();
    else if ( evt.keyCode == 32 ) {
        this.currentWord = '';
        this.clearCompletions();
    }
    else if ( evt.keyCode == 38 )
        this.selectCompletion( -1 );
    else if ( evt.keyCode == 40 )
        this.selectCompletion( 1 );
    else
        this.updateWord( String.fromCharCode(evt.keyCode).toLowerCase() );
    return true;
}

TC.AutoComplete.prototype.selectCompletion = function( offset )
{
    if (!this.hasCompletions)
        return;
    var i = this.selectedCompletion + offset;
    if ( ( i < 0 ) || ( i > this.suggestedCompletions.length - 1 ) )
        return;
    this.completion_box.childNodes[ this.selectedCompletion ].className = 'complete-none';
    this.completion_box.childNodes[ i ].className = 'complete-highlight';
    this.selectedCompletion = i;
}

TC.AutoComplete.prototype.updateWord = function( c )
{
    this.currentWord += c;
    this.lookForCompletions();
}

TC.AutoComplete.prototype.truncateWord = function()
{
    this.currentWord = this.currentWord.substring( 0, this.currentWord.length - 1 );
    if (!this.currentWord.length)
        this.clearCompletions();
    else
        this.lookForCompletions();
}

TC.AutoComplete.prototype.handleAutoComplete = function( word )
{
    if ( !this.hasCompletions ) return;
    var inputValue = this.input_box.value;
    word = word || this.suggestedCompletions[ this.selectedCompletion ];
    var lastSpace = inputValue.lastIndexOf( ' ' );
    this.input_box.value = inputValue.substring( 0, lastSpace ) + (lastSpace != -1 ? ' ' : '') + word + ' ';
    this.currentWord = '';
    this.clearCompletions();
}

TC.AutoComplete.prototype.lookForCompletions = function()
{
    if (!this.currentWord)
        return;
    this.suggestedCompletions = new Array();
    this.autoCompleteNode.getStrings(this.currentWord, '', this.suggestedCompletions);
    this.hasCompletions = this.suggestedCompletions.length ? 1 : 0;
    if (this.hasCompletions)
        this.constructCompletionBox();
    else
        this.clearCompletions();
}

TC.AutoComplete.prototype.onDivMouseDown = function()
{
    this.autoComplete.handleAutoComplete(this.innerHTML);
}

TC.AutoComplete.prototype.onDivMouseOver = function()
{
    this.className = 'complete-highlight';
}

TC.AutoComplete.prototype.onDivMouseOut = function()
{
    this.className = 'complete-none';
}

TC.AutoComplete.prototype.constructCompletionBox = function()
{
    var div = this.completion_box;
    while ( div.hasChildNodes() )
        div.removeChild( div.firstChild );
    for ( var i = 0; i < this.suggestedCompletions.length; i++ )
    {
        var inner = document.createElement('div');
        div.appendChild(inner);
        inner.innerHTML = this.suggestedCompletions[ i ];
        inner.onmousedown = TC.AutoComplete.prototype.onDivMouseDown;
        inner.onmouseover = TC.AutoComplete.prototype.onDivMouseOver;
        inner.onmouseout = TC.AutoComplete.prototype.onDivMouseOut;
        inner.autoComplete = this;
    }
    div.style.display = 'block';
    if (div.firstChild)
        div.firstChild.className = 'complete-highlight';
}

TC.AutoComplete.prototype.clearCompletions = function()
{
    this.hasCompletions = 0;
    this.suggestedCompletions = new Array();
    this.selectedCompletion = 0;
    if (this.completion_box)
        this.completion_box.style.display = 'none';
}

/*
--------------------------------------------------------------------------------
TC.AutoCompleteNode
a tree structure for fast auto-completion
--------------------------------------------------------------------------------
*/

TC.AutoCompleteNode = function()
{
    this.isLeaf = false;
    this.childCount = 0;
    this.nodeValue = new Object;
}

TC.AutoCompleteNode.prototype.add = function( str )
{
    this.childCount++;
    if ( str == '' )
        this.isLeaf = true;
    else
    {
        var first = str.substring( 0, 1 );
        var rest = str.substring( 1, str.length );
        if ( !this.nodeValue[ first ] )
            this.nodeValue[ first ] = new TC.AutoCompleteNode();
        this.nodeValue[ first ].add( rest );
    }
}

TC.AutoCompleteNode.prototype.getStrings = function(str1, str2, outStr)
{
    if ( str1 == '' )
    {
        if ( this.isLeaf ) 
            outStr.push( str2 );

        for ( var i in this.nodeValue )
            this.nodeValue[ i ].getStrings( str1, str2 + i, outStr );
    }
    else
    {
        var letter = str1.substring( 0, 1 );
        var rest = str1.substring( 1, str1.length );
    
        letter = letter.toLowerCase();
        if ( this.nodeValue[ letter ] )
            this.nodeValue[ letter ].getStrings( rest, str2 + letter, outStr );

        letter = letter.toUpperCase();
        if ( this.nodeValue[ letter ] )
            this.nodeValue[ letter ].getStrings( rest, str2 + letter, outStr );
    }
}
