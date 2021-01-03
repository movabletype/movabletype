/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
*/


/*
--------------------------------------------------------------------------------
TC.Mixer.TagMatch
class for tag matching entry lists
--------------------------------------------------------------------------------
*/

/* constructor */

TC.Mixer.TagMatch = function( mixer, regExp, inclusive, randomize )
{
	this.mixer = mixer;
	this.regExp = regExp;
	this.greedy = this.regExp ? this.regExp.global : true;
	this.inclusive = inclusive;
	this.randomize = randomize;
	this.matches = [];
	this.entries = {};
}


/* instance methods */

TC.Mixer.TagMatch.prototype.match = function( entry )
{
	// var bench = new TC.Benchmark();
	
	// init
	var matches = new Array();
	var entries = new Array();
	
	// find matching entries
	if( entry )
	{
		for( var i in entry.tags )
		{
			var tag = entry.tags[ i ];
			if( this.regExp )
			{
				var m = tag.match( this.regExp );
				if( !m || m.length == 0 )
					continue;
			}
			
			var tagIndex = this.mixer.tagIndexes[ tag ];
			if( !tagIndex )
				continue;
			for( var j in tagIndex )
			{
				var tagEntry = tagIndex[ j ];
				if( entries[ tagEntry.name ] )
					continue;

				// include this entry?
				if( !this.inclusive &&
					(tagEntry == entry || this.mixer.matchedEntries[ tagEntry.name ]) )
					continue;

				// add entry
				entries[ tagEntry.name ] = tagEntry;
				matches.push( tagEntry );
			}
			
			// non-greedy matches only look at the first matching tag
			if( !this.greedy )
				break;
		}
	}
	
	// bench.tick( "match" );
	
	// compare existing list to new list, and short-circuit if they contain same items
	if( matches.length == this.matches.length )
	{
		var same = true;
		for( var i in entries )
		{
			if( entries[ i ] != this.entries[ i ] )
			{
				same = false;
				break;
			}
		}
		
		// bench.tick( "compare" );
		
		if( same )
		{
			// alert( bench.report() + "num matches: " + this.matches.length );
			return false;
		}
	}
	
	// randomize/sort matching entries
	if( this.randomize )
		TC.scramble( matches );
	else
		matches = matches.sort( this.mixer.sortEntryClosure );
	
	// bench.tick( "sort" );
	
	// copy to object
	this.entries = entries;
	this.matches.length = matches.length;
	for( var i in matches )
		this.matches[ i ] = matches[ i ];
	
	// bench.tick( "copy" );
	// alert( bench.report() + "num matches: " + this.matches.length );
	
	// found new matches
	return true;
}
