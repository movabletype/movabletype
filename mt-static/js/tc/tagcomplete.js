/*
Copyright 2004 Six Apart. This code cannot be redistributed without
permission from www.sixapart.com.

$Id$
*/

/*
--------------------------------------------------------------------------------
TC.TagComplete
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

TC.TagComplete = function( id, words )
{
    this.id = id;
    this.tagCompleteNode = new TC.TagCompleteNode();
    for ( var i = 0; i < words.length; i++ )
        this.tagCompleteNode.add( words[i] );
    this.delimiter = ' ';
    this.currentWord = '';
    TC.TagComplete.instances[ this.id ] = this;
    this.clearCompletions();
    this.attachElements();
}

TC.TagComplete.instances = new Array();

TC.TagComplete.prototype.attachElements = function()
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
            var keyPress = function( event ) { return self.keyPress( event ); }
            TC.attachEvent( this.input_box, "keydown", keyDown );
            TC.attachEvent( this.input_box, "keypress", keyPress );
            this.input_box.setAttribute("autocomplete", "off");
        }
    }
    
    if (!this.completion_box)
        this.completion_box = document.getElementById( this.id + '_completion' );
    
    // try again on failure
	if( !this.input_box )
        window.setTimeout( "TC.TagComplete.instances[ '" + this.id + "' ].attachElements();", 1000 );
}

TC.TagComplete.prototype.keyPress = function( evt )
{
    evt = evt || event;
    var element = evt.target || evt.srcElement;
    if (( evt.keyCode == 9 ) || ( evt.keyCode == 13 ))
    {
        return TC.stopEvent( evt );
    }
}

TC.TagComplete.prototype.keyDown = function( evt )
{
    evt = evt || event;
    var element = evt.target || evt.srcElement;
    if ( (evt.keyCode == 9) || (evt.keyCode == 13))
    {
        if (this.hasCompletions)
            this.handleTagComplete();
        return TC.stopEvent( evt );
    }
    else if ( evt.keyCode == 8 )
        this.truncateWord();
    else if ( String.fromCharCode(evt.keyCode) == this.delimiter ) {
        if (this.hasCompletions)
            this.handleTagComplete();
        this.currentWord = '';
        this.clearCompletions();
        return TC.stopEvent( evt );
    }
    /*else if ( evt.keyCode == 32 ) {
        this.currentWord = '';
        this.clearCompletions();
    }*/
    else if ( evt.keyCode == 38 )
        this.selectCompletion( -1 );
    else if ( evt.keyCode == 40 ) {
        if (this.hasCompletions) {
            this.selectCompletion( 1 );
        } else {
            var val = element.value;
            var idx = val.lastIndexOf(this.delimiter);
            var str = val.substring(idx+1, val.length);
            str = str.replace(/^\s*(.+)$/g, "$1");
            this.currentWord = str;
            this.lookForCompletions();
        }
    }
    else
        this.updateWord( String.fromCharCode(evt.keyCode).toLowerCase() );
    return true;
}

TC.TagComplete.prototype.selectCompletion = function( offset )
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

TC.TagComplete.prototype.updateWord = function( c )
{
    this.currentWord += c;
    this.lookForCompletions();
}

TC.TagComplete.prototype.truncateWord = function()
{
    this.currentWord = this.currentWord.substring( 0, this.currentWord.length - 1 );
    if (!this.currentWord.length)
        this.clearCompletions();
    else
        this.lookForCompletions();
}

TC.TagComplete.prototype.handleTagComplete = function( word )
{
    if ( !this.hasCompletions ) return;
    var inputValue = this.input_box.value;
    word = word || this.suggestedCompletions[ this.selectedCompletion ];
    if (word.indexOf(this.delimiter) != -1)
        word = '"' + word + '"';
    var lastDelim = inputValue.lastIndexOf( this.delimiter );
    var sep = this.delimiter + (this.delimiter == ' ' ? '' : ' ' );
    this.input_box.value = inputValue.substring( 0, lastDelim ) + (lastDelim != -1 ? sep : '') + word + sep;
    this.currentWord = '';
    this.clearCompletions();
}

TC.TagComplete.prototype.lookForCompletions = function()
{
    if (!this.currentWord)
        return;
    this.suggestedCompletions = new Array();
    this.tagCompleteNode.getStrings(this.currentWord, '', this.suggestedCompletions);
    this.hasCompletions = this.suggestedCompletions.length ? 1 : 0;
    if (this.hasCompletions)
        this.constructCompletionBox();
    else
        this.clearCompletions();
}

TC.TagComplete.prototype.onDivMouseDown = function()
{
    this.tagComplete.handleTagComplete(this.innerHTML);
}

TC.TagComplete.prototype.onDivMouseOver = function()
{
    this.className = 'complete-highlight';
}

TC.TagComplete.prototype.onDivMouseOut = function()
{
    this.className = 'complete-none';
}

TC.TagComplete.prototype.constructCompletionBox = function()
{
    var div = this.completion_box;
    while ( div.hasChildNodes() )
        div.removeChild( div.firstChild );
    for ( var i = 0; i < this.suggestedCompletions.length; i++ )
    {
        var inner = document.createElement('div');
        div.appendChild(inner);
        inner.innerHTML = this.suggestedCompletions[ i ];
        inner.onmousedown = TC.TagComplete.prototype.onDivMouseDown;
        inner.onmouseover = TC.TagComplete.prototype.onDivMouseOver;
        inner.onmouseout = TC.TagComplete.prototype.onDivMouseOut;
        inner.tagComplete = this;
    }
    div.style.display = 'block';
    if (div.firstChild)
        div.firstChild.className = 'complete-highlight';
}

TC.TagComplete.prototype.clearCompletions = function()
{
    this.hasCompletions = 0;
    this.suggestedCompletions = new Array();
    this.selectedCompletion = 0;
    if (this.completion_box)
        this.completion_box.style.display = 'none';
}

/*
--------------------------------------------------------------------------------
TC.TagCompleteNode
a tree structure for fast auto-completion
--------------------------------------------------------------------------------
*/

TC.TagCompleteNode = function()
{
    this.isLeaf = false;
    this.childCount = 0;
    this.nodeValue = new Object;
}

TC.TagCompleteNode.prototype.add = function( str )
{
    this.childCount++;
    if ( str == '' )
        this.isLeaf = true;
    else
    {
        var first = str.substring( 0, 1 );
        var rest = str.substring( 1, str.length );
        if ( !this.nodeValue[ first ] )
            this.nodeValue[ first ] = new TC.TagCompleteNode();
        this.nodeValue[ first ].add( rest );
    }
}

TC.TagCompleteNode.prototype.getStrings = function(str1, str2, outStr)
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

        var upperLetter = letter.toUpperCase();
        if (letter != upperLetter) {
            letter = upperLetter;
            if ( this.nodeValue[ letter ] )
                this.nodeValue[ letter ].getStrings( rest, str2 + letter, outStr );
        }
    }
}
