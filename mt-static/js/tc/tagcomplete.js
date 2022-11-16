/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
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
    for ( var i = 0; i < words.length; i++ ) {
        if ( typeof words[i] != 'string' )
            words[i] = words[i] + '';
        this.tagCompleteNode.add( words[i] );
    }
    this.delimiter = ' ';
    this.currentWord = '';
    this.insert_pos = -1;
    this.symbols = /[!#$%"'()=\-~^|\\`@\[{}\]\+\*;:<>,\./?_\\]/;
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
            TC.attachEvent( this.input_box, "keydown", keyDown );
            this.input_box.setAttribute("autocomplete", "off");
        }
    }
    
    if (!this.completion_box)
        this.completion_box = document.getElementById( this.id + '_completion' );
    
    // try again on failure
	if( !this.input_box )
        window.setTimeout( "TC.TagComplete.instances[ '" + this.id + "' ].attachElements();", 1000 );
}

TC.TagComplete.prototype.keyDown = function( evt )
{
    evt = evt || event;
    var element = evt.target || evt.srcElement;
    if (evt.ctrlKey) {
        return true;
    }
    if ( evt.keyCode == 8 ) {   // backspace
        this.truncateWord();
    }
    else if ( (evt.keyCode == 9) || (evt.keyCode == 13)) { // tab or enter
        if (this.hasCompletions) {
            this.handleTagComplete();
            this.stopped = evt.keyCode;
            return TC.stopEvent( evt );
        }
    }
    else if ( evt.keyCode == 38 ) {  // up arrow key
        if (this.hasCompletions) {
            this.selectCompletion( -1 );
            this.stopped = evt.keyCode;
            return TC.stopEvent( evt );
        }
    }
    else if ( evt.keyCode == 37 ) {  // left arrow key
        this.currentWord = '';
        this.clearCompletions();
    }
    else if ( evt.keyCode == 39 ) {  // right arrow key
        this.currentWord = '';
        this.clearCompletions();
    }
    else if ( evt.keyCode == 40 ) {  // down arrow key
        if (this.hasCompletions) {
            this.selectCompletion( 1 );
        } else {
            var val = element.value;
            var idx = TC.getCaretPosition(this.input_box);
            if (idx == null) {
                idx = val.lastIndexOf(this.delimiter) + 1;
            } else {
                idx = val.substring(0, idx).lastIndexOf(this.delimiter) + 1;
                this.insert_pos = idx;
            }
            var str = val.substring(idx, val.length);
            var del_pos = str.indexOf(this.delimiter);
            if (del_pos != -1)
                str = str.substring(0, del_pos);
            str = str.replace(/^\s*(.+)\s*$/g, "$1");
            this.currentWord = str;
            this.lookForCompletions();
        }
        this.stopped = evt.keyCode;
        return TC.stopEvent( evt );
    }
    else if ( ( String.fromCharCode(evt.keyCode) == this.delimiter ) ||
              ( ( evt.keyCode == 188 ) && ( this.delimiter == ',' ) ) ) {
        this.currentWord = '';
        this.clearCompletions();
    }
    else if ( (evt.keyCode > 64) && (evt.keyCode < 91) || (evt.keyCode == 32) ) { // uppercase A-Z & space
        this.updateWord( String.fromCharCode(evt.keyCode).toLowerCase() );
    }
    else if ( (evt.keyCode > 47) && (evt.keyCode < 58) ) { // 0-9
        if (evt.shiftKey) return true;
        this.updateWord( String.fromCharCode(evt.keyCode) );
    }
    else {
        return true;
    }
    
    this.processed = evt.keyCode;
    return true;
}

TC.TagComplete.prototype.selectCompletion = function( offset )
{
    if (!this.hasCompletions)
        return;
    var i = this.selectedCompletion + offset;
    if ( ( i < 0 ) || ( i > this.suggestedCompletions.length - 1 ) )
        return;
    this.completion_box.firstElementChild.childNodes[ this.selectedCompletion ].className = 'complete-none';
    this.completion_box.firstElementChild.childNodes[ i ].className = 'complete-highlight';
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
    if (!this.currentWord.length) {
        this.clearCompletions();
    } else
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
    if (this.insert_pos != -1) {
        var rest = this.input_box.value.substring(this.insert_pos+1);
        if (rest.indexOf(this.delimiter) != -1) {
            rest = rest.substring(rest.indexOf(this.delimiter) + 1);
        } else {
            rest = ''
        }
        var completion = word + sep;
        if (this.delimiter != ' ') {
            if (this.insert_pos > 0)
                completion = ' ' + completion;
        }
        this.input_box.value = inputValue.substring( 0, this.insert_pos ) + completion + rest;
        var newPos = (this.insert_pos - 1) + completion.length + 1;
        TC.setCaretPosition( this.input_box, newPos );
    } else {
        this.input_box.value = inputValue.substring( 0, lastDelim ) + (lastDelim != -1 ? sep : '') + word + sep;
    }
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
    if (this.hasCompletions) {
        if (this.insert_pos == -1) {
            var pos = TC.getCaretPosition(this.input_box);
            if (pos != null) {
                var val = this.input_box.value;
                pos = val.substring(0, pos).lastIndexOf(this.delimiter) + 1;
                this.insert_pos = pos;
            }
        }
        this.constructCompletionBox();
    } else {
        this.clearCompletions();
    }
}

TC.TagComplete.prototype.onDivMouseDown = function()
{
    this.tagComplete.handleTagComplete(this.textContent);
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
    var ul = div.firstElementChild;
    while ( ul.hasChildNodes() )
        ul.removeChild( ul.firstChild );
    for ( var i = 0; i < this.suggestedCompletions.length; i++ )
    {
        var inner = document.createElement('span');
        inner.className = 'mt-suggest__select';
        inner.innerHTML = this.suggestedCompletions[ i ];
        inner.onmousedown = TC.TagComplete.prototype.onDivMouseDown;
        inner.tagComplete = this;

        var li = document.createElement('li');
        li.appendChild(inner);
        ul.appendChild(li);
    }
    div.parentElement.style.display = 'block';
    if (ul.firstChild)
        ul.firstChild.className = 'complete-highlight';

    var $scrollableParent = jQuery('.modal-body');
    if ($scrollableParent.length == 0) {
      $scrollableParent = jQuery(window);
    }
    var $parentElement = jQuery(div.parentElement);
    var $inputBox = jQuery(this.input_box);
    var margin = 30;
    if ($scrollableParent.scrollTop() > $inputBox.offset().top) {
      $scrollableParent.scrollTop($inputBox.offset().top - margin);
    } else if ($scrollableParent.scrollTop() + $scrollableParent.height() < $parentElement.offset().top + $parentElement.height()) {
      $scrollableParent.scrollTop($parentElement.offset().top + $parentElement.height() + margin - $scrollableParent.height());
    }
}

TC.TagComplete.prototype.clearCompletions = function()
{
    this.hasCompletions = 0;
    this.insert_pos = -1;
    this.suggestedCompletions = new Array();
    this.selectedCompletion = 0;
    if (this.completion_box)
        this.completion_box.parentElement.style.display = 'none';
}

TC.TagComplete.prototype.keyCodeToAChar = function( keyCode )
{
    var charCode = this.charCode[keyCode];
    if (charCode == -1) return -1;
    return String.fromCharCode(charCode);
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

        for ( var i in this.nodeValue ) {
            if (typeof(this.nodeValue[ i ]) != 'object')
                continue;
            this.nodeValue[ i ].getStrings( str1, str2 + i, outStr );
        }
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
