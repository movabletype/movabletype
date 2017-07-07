;(function ($, window) {
  if (typeof window.MT === 'undefined') {
    window.MT = {};
  }

  var MT = window.MT;

  MT.TagComplete = function( id, words )
  {
      this.id = id;
      this.tagCompleteNode = new MT.TagCompleteNode();
      for ( var i = 0; i < words.length; i++ ) {
          if ( typeof words[i] != 'string' )
              words[i] = words[i] + '';
          this.tagCompleteNode.add( words[i] );
      }
      this.delimiter = ' ';
      this.currentWord = '';
      this.insert_pos = -1;
      this.symbols = /[!#$%"'()=\-~^|\\`@\[{}\]\+\*;:<>,\./?_\\]/;
      MT.TagComplete.instances[ this.id ] = this;
      this.clearCompletions();
      this.attachElements();
  }

  MT.TagComplete.instances = new Array();

  MT.TagComplete.prototype.attachElements = function()
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
              $(this.input_box).on('keydown', keyDown);
              this.input_box.setAttribute("autocomplete", "off");
          }
      }

      if (!this.completion_box)
          this.completion_box = document.getElementById( this.id + '_completion' );

      // try again on failure
  	if( !this.input_box )
          window.setTimeout( "TC.TagComplete.instances[ '" + this.id + "' ].attachElements();", 1000 );
  }

  function stopEvent( evt ) {
    evt.preventDefault();
    evt.stopPropagation();
    return false;
  }

  function getOwnerDocument( element ) {
  	if( !element )
  		return document;
  	if( element.ownerDocument )
  		return element.ownerDocument;
  	if( element.getElementById )
  		return element
  	return document;
  }

  function getCaretPosition( element ) {
    var doc = getOwnerDocument( element );
    if (doc.selection) {
        var range = doc.selection.createRange();
    	var isCollapsed = range.compareEndPoints("StartToEnd", range) == 0;
    	if (!isCollapsed)
    		range.collapse(true);
    	var b = range.getBookmark();
    	return b.charCodeAt(2) - 2;
    } else if (element.selectionStart != 'undefined') {
        return element.selectionStart;
    }
    return null;
  }

  MT.TagComplete.prototype.keyDown = function( evt )
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
              return stopEvent(evt);
          }
      }
      else if ( evt.keyCode == 38 ) {  // up arrow key
          if (this.hasCompletions) {
              this.selectCompletion( -1 );
              this.stopped = evt.keyCode;
              return stopEvent(evt);
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
              var idx = getCaretPosition(this.input_box);
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
          return stopEvent( evt );
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

  MT.TagComplete.prototype.selectCompletion = function( offset )
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

  MT.TagComplete.prototype.updateWord = function( c )
  {
      this.currentWord += c;
      this.lookForCompletions();
  }

  MT.TagComplete.prototype.truncateWord = function()
  {
      this.currentWord = this.currentWord.substring( 0, this.currentWord.length - 1 );
      if (!this.currentWord.length) {
          this.clearCompletions();
      } else
          this.lookForCompletions();
  }

  MT.TagComplete.prototype.handleTagComplete = function( word )
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
          setCaretPosition( this.input_box, newPos );
      } else {
          this.input_box.value = inputValue.substring( 0, lastDelim ) + (lastDelim != -1 ? sep : '') + word + sep;
      }
      this.currentWord = '';
      this.clearCompletions();
  }

  MT.TagComplete.prototype.lookForCompletions = function()
  {
      if (!this.currentWord)
          return;
      this.suggestedCompletions = new Array();
      this.tagCompleteNode.getStrings(this.currentWord, '', this.suggestedCompletions);
      this.hasCompletions = this.suggestedCompletions.length ? 1 : 0;
      if (this.hasCompletions) {
          if (this.insert_pos == -1) {
              var pos = getCaretPosition(this.input_box);
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

  MT.TagComplete.prototype.onDivMouseDown = function()
  {
      this.tagComplete.handleTagComplete(this.textContent);
  }

  MT.TagComplete.prototype.onDivMouseOver = function()
  {
      this.className = 'complete-highlight';
  }

  MT.TagComplete.prototype.onDivMouseOut = function()
  {
      this.className = 'complete-none';
  }

  MT.TagComplete.prototype.constructCompletionBox = function()
  {
      var div = this.completion_box;
      while ( div.hasChildNodes() )
          div.removeChild( div.firstChild );
      for ( var i = 0; i < this.suggestedCompletions.length; i++ )
      {
          var inner = document.createElement('div');
          div.appendChild(inner);
          inner.innerHTML = this.suggestedCompletions[ i ];
          inner.onmousedown = MT.TagComplete.prototype.onDivMouseDown;
          inner.onmouseover = MT.TagComplete.prototype.onDivMouseOver;
          inner.onmouseout = MT.TagComplete.prototype.onDivMouseOut;
          inner.tagComplete = this;
      }
      div.style.display = 'block';
      if (div.firstChild)
          div.firstChild.className = 'complete-highlight';
  }

  MT.TagComplete.prototype.clearCompletions = function()
  {
      this.hasCompletions = 0;
      this.insert_pos = -1;
      this.suggestedCompletions = new Array();
      this.selectedCompletion = 0;
      if (this.completion_box)
          this.completion_box.style.display = 'none';
  }

  MT.TagComplete.prototype.keyCodeToAChar = function( keyCode )
  {
      var charCode = this.charCode[keyCode];
      if (charCode == -1) return -1;
      return String.fromCharCode(charCode);
  }

  MT.TagCompleteNode = function()
  {
      this.isLeaf = false;
      this.childCount = 0;
      this.nodeValue = new Object;
  }

  MT.TagCompleteNode.prototype.add = function( str )
  {
      this.childCount++;
      if ( str == '' )
          this.isLeaf = true;
      else
      {
          var first = str.substring( 0, 1 );
          var rest = str.substring( 1, str.length );
          if ( !this.nodeValue[ first ] )
              this.nodeValue[ first ] = new MT.TagCompleteNode();
          this.nodeValue[ first ].add( rest );
      }
  }

  MT.TagCompleteNode.prototype.getStrings = function(str1, str2, outStr)
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
})(jQuery, window);
