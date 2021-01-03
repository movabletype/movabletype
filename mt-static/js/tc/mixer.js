/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
*/


/*
--------------------------------------------------------------------------------
TC.Mixer
class for client-side "remixing" of tagged data
--------------------------------------------------------------------------------
*/

/* constructor */

TC.Mixer = function( name )
{
	this.name = name;
	this.entry = null;
	this.selected = [];
	this.history = [];
	this.maxHistory = 0;
	this.entries = {};
	this.matchedEntries = {};
	this.tagIndexes = {};
	this.tagMatches = [];
	this.displays = [];
	this.entryEvents = [];
	this.onselect = null;
	
	var self = this;
	this.sortEntryClosure = function( a, b ) { return self.sortEntry( a, b ); };
}


/* instance methods */

TC.Mixer.prototype.remix = function()
{
	// bench = new TC.Benchmark();
	
	// check to see if selection has changed
	if( this.name && this.entry != this.entries[ this.name ] )
	{
		this.entry = this.entries[ this.name ];
		this.selected[ 0 ] = this.entry;
		
		// find in history
		var isNew = true;
		for( var i in this.history )
		{
			if( this.history[ i ] == this.entry )
			{
				isNew = false;
				break;
			}
		}
		
		// add to history
		if( isNew )
			this.history.push( this.entry );
		
		// limit history length
		if( this.history.length > this.maxHistory )
			this.history[ 0 ] = this.history.shift();
	}
	
	// check for null selection
	else if( !this.name )
	{
		this.entry = null;
		this.selected[ 0 ] = null;
	}
	
	// tag matches
	this.matchedEntries = {};

	// walk match list
	for( var i in this.tagMatches )
	{
		var tagMatch = this.tagMatches[ i ];
        if (typeof(tagMatch) != 'object')
            continue;
		if( tagMatch.match( this.entry ) )
			this.dirtyDisplays( tagMatch.matches );
		
		// add to exclusion list
		for( var j in tagMatch.entries )
			this.matchedEntries[ j ] = tagMatch.entries[ j ];
	}
	
	// bench.tick( "match" );
	
	// redisplay if necessary
	this.display();
	
	// bench.tick( "display" );
	// alert( bench.report() );
}


TC.Mixer.prototype.display = function()
{
	for( var i in this.displays )
	{
		var display = this.displays[ i ];
        if (typeof(display) != 'object')
            continue;
		if (display) display.display();
	}
}


/* entry methods */

TC.Mixer.prototype.selectEntry = function( name )
{
	this.name = name;
	this.remix();
	if (this.onselect) {
	    this.onselect(this, name);
	}
}

TC.Mixer.prototype.addEntry = 
TC.Mixer.prototype.addEntries = function()
{
	var changed = false;
	var args = arguments;
	for( var i = 0; i < arguments.length; i++ )
	{
		var entry = arguments[ i ];
		if( !entry.name || !typeof( entry.name ) == "string" || entry.name.length == 0 )
			continue;
		this.entries[ entry.name ] = entry;
		changed = true;
	}
	if( changed )
		this.createTagIndexes();
}

TC.Mixer.prototype.addEntryEvent = function( name, func )
{
	this.entryEvents[ name ] = func;
}

TC.Mixer.prototype.sortEntry = function( a, b )
{
	if( a.sort < b.sort )
		return -1;
	else if( a.sort > b.sort )
		return 1;
	else
		return 0;
}


/* tag index methods */

TC.Mixer.prototype.createTagIndexes = function()
{
	// zero
	for( var tag in this.tagIndexes )
		this.tagIndexes[ tag ].length = 0;
	
	// index
	for( var i in this.entries )
	{
		var entry = this.entries[ i ];
		if( !entry )
			continue;
		for( var j in entry.tags )
		{
			var tag = entry.tags[ j ];
			if( !this.tagIndexes[ tag ] )
				this.tagIndexes[ tag ] = [];
			this.tagIndexes[ tag ].push( entry );
		}
	}
	
	// sort
	for( var tag in this.tagIndexes )
	{
		var tagIndex = this.tagIndexes[ tag ];
		var sorted = tagIndex.sort( this.sortEntryClosure );
		for( var i in sorted )
			tagIndex[ i ] = sorted[ i ];
	}
}


TC.Mixer.prototype.getTagIndex = function( tag )
{
	if( !this.tagIndexes[ tag ] )
		this.tagIndexes[ tag ] = [];
	return this.tagIndexes[ tag ];
}


/* tag match methods */

TC.Mixer.prototype.addTagMatch = function( regExp, inclusive, randomize )
{
	var tagMatch;
	var rs = regExp ? regExp.source : null;
	
	// try to find existing tag match
	for( var i in this.tagMatches )
	{
		tagMatch = this.tagMatches[ i ];
		if( tagMatch.inclusive != inclusive ||
			tagMatch.randomize != randomize ||
			(!tagMatch.regExp && regExp) ||
			(tagMatch.regExp && !regExp) ||
			tagMatch.regExp.source != rs )
			continue;
		return tagMatch;
	}
	
	// add a new one
	tagMatch = new TC.Mixer.TagMatch( this, regExp, inclusive, randomize );
	this.tagMatches.push( tagMatch );
	return tagMatch;
}


TC.Mixer.prototype.addInclusiveTagMatch = function( regExp )
{
	return this.addTagMatch( regExp, true, false );
}


TC.Mixer.prototype.addRandomTagMatch = function( regExp )
{
	return this.addTagMatch( regExp, false, true );
}


/* display methods */

// passing null or void source dirties all displays
TC.Mixer.prototype.dirtyDisplays = function( source )
{
	for( var i in this.displays )
	{
		var display = this.displays[ i ];
        if (typeof(display) != 'object')
            continue;
		if( !source || display.source == source )
			display.dirty = true;
	}
}


TC.Mixer.prototype.addDisplay = function( id, entryList, start, count, imageProperty )
{
	var display = new TC.Mixer.Display( this, id, entryList, start, count, imageProperty );
	this.displays.push( display );
	return display;
}


TC.Mixer.prototype.addClonedDisplay = function( id, display )
{
	if( !display )
		return null;
	display = display.clone();
	this.displays.push( display );
	return display;
}


TC.Mixer.prototype.addInitialDisplay = function( id )
{
	return this.addDisplay( id, this.history, 0, 1, "imageSmall" );
}


TC.Mixer.prototype.addSelectedDisplay = function( id )
{
	return this.addDisplay( id, this.selected, 0, 1, "imageBig" );
}


TC.Mixer.prototype.addBigSelectedDisplay = function( id )
{
	return this.addDisplay( id, this.selected, 0, 1, "imageSmall" );
}


TC.Mixer.prototype.addHistoryDisplay = function( id, count )
{
	if( count > this.maxHistory )
		this.maxHistory = count;
	return this.addDisplay( id, this.history, -1, count * -1, "imageSmall" );
}


TC.Mixer.prototype.addTagIndexDisplay = function( id, count, tag )
{
	var tagIndex = this.getTagIndex( tag );
	return this.addDisplay( id, tagIndex, 0, count, "imageSmall" );
}


TC.Mixer.prototype.addTagMatchDisplay = function( id, count, regExp )
{
	var tagMatch = this.addInclusiveTagMatch( regExp );
	return this.addDisplay( id, tagMatch.matches, 0, count, "imageSmall" );
}


TC.Mixer.prototype.addRandomTagMatchDisplay = function( id, count, regExp )
{
	var tagMatch = this.addRandomTagMatch( regExp );
	return this.addDisplay( id, tagMatch.matches, 0, count, "imageSmall" );
}
