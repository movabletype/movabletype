/*
Copyright 2003 Six Apart. This code cannot be redistributed without
permission from www.sixapart.com.

$Id$
*/


/*
--------------------------------------------------------------------------------
TC.TableSelect
table selection
--------------------------------------------------------------------------------
*/

/* constructor */

TC.TableSelect = function( element )
{
	// make closures
	var self = this;
	this.clickClosure = function( evt ) { return self.click( evt ); };
	this.lastClicked = null;
	this.thisClicked = null;
	this.shiftKey = false;
	
	// initialize
	this.init( element );
}


/* config */

TC.TableSelect.prototype.rowSelect = false;


/* instance methods */

TC.TableSelect.prototype.init = function( container )
{
	container = TC.elementOrId( container );
	if ( !container ) return;

	// basic setup
	this.container = container;

	// event handlers
	TC.attachEvent( container, "click", this.clickClosure );

	// select rows
	this.selectAll();
}


TC.TableSelect.prototype.click = function( evt )
{
	evt = evt || event;
	var element = evt.target || evt.srcElement;
	this.shiftKey = evt.shiftKey;

	// get tag name
	var tagName = element.tagName ? element.tagName.toLowerCase() : null;

	// handle checkboxes
	if ( tagName == "input" &&
		element.type == "checkbox" &&
		TC.hasClassName( element, "select" ) )
		return this.select( element );

	// handle rows
	if ( !this.rowSelect && tagName != "td" ) return;
	if ( ( tagName == 'a') || ( TC.getParentByTagName( element, "a" ) ) )
		return;
	var parent = TC.getParentByTagName( element, "tr" );
	while ( TC.hasClassName( parent, "slave" ) )
		parent = parent.previousSibling;

	if ( parent )
	{
		var elements = TC.getElementsByTagAndClassName( "input", "select", parent );
		for ( var i = 0; i < elements.length; i++ )
		{
			element = elements[ i ];
			if ( element.type == "checkbox" )
			{
				element.checked = !element.checked;
				return this.select( element );
			}
		}
	}
}


TC.TableSelect.prototype.select = function( checkbox )
{
	// setup
	this.thisClicked = checkbox;
	var checked = checkbox.checked ? true : false; // important, trinary value (null is valid)
	var all = checkbox.value == "all" ? true : false;
	
	if ( all )
	{
		this.thisClicked = null;
		this.lastClicked = null;
		return this.selectAll( checkbox );
	}

	var row = TC.getParentByTagName( checkbox, "tr" );
	this.selectRow( row, checked );
	this.selectAll();
	this.lastClicked = this.thisClicked;
}


TC.TableSelect.prototype.selectAll = function( checkbox )
{
	// setup
	var alls = [];
	var count = 0;
	var selectedCount = 0;
	var invert = false;

	var lastClicked = -1;
	var thisClicked = -1;
	
	// iterate
	var rows = this.container.getElementsByTagName( "tr" );

   	for ( var i = 0; i < rows.length; i++ )
	{
		var row = rows[ i ];
		if ( !row || !row.tagName )
			continue;
		var inputs = row.getElementsByTagName( "input" );

		var anyChecked = false;
		for ( var j = 0; j < inputs.length; j++ )
		{
			var input = inputs[ j ];
			if ( input.type != "checkbox" || !TC.hasClassName( input, "select" ) )
				continue;

			if (this.lastClicked && input == this.lastClicked)
				lastClicked = i;

			if (this.thisClicked && input == this.thisClicked)
				thisClicked = i;

			if (input.checked)
				anyChecked = true;
		}

		invert = this.shiftKey;
	}

	for ( var i = 0; i < rows.length; i++ )
	{
		var row = rows[ i ];
		if ( !row || !row.tagName )
			continue;
		var inputs = row.getElementsByTagName( "input" );
		for ( var j = 0; j < inputs.length; j++ )
		{
			var input = inputs[ j ];
			if ( input.type != "checkbox" || !TC.hasClassName( input, "select" ) )
				continue;
			
			// test and select
			var checked;
			if (checkbox)
			{
				var checked;
				if (invert)
					checked = !input.checked;
				else
					checked = checkbox ? checkbox.checked : input.checked;
    			input.checked = checked;
				this.selectRow( row, checked );
			}
			
			// add to alls
			if ( input.value == "all" )
				alls[ alls.length ] = input;
			else
			{
				count++;
				if ( input.checked )
					selectedCount++;
			}
		}
	}

	if ((lastClicked != -1) && (this.shiftKey))
	{
		var low, hi;
		if (thisClicked < lastClicked)
		{
			low = thisClicked;
			hi = lastClicked;
		}
		else
		{
			low = lastClicked;
			hi = thisClicked;
		}
		for (i = low + 1; i < hi; i++)
		{
			var row = rows[ i ];
			if (!row || !row.tagName )
				continue;

			var inputs = row.getElementsByTagName( "input" );

			for ( var j = 0; j < inputs.length; j++ )
			{
				var input = inputs[ j ];
				if ( input.type != "checkbox" || !TC.hasClassName( input, "select" ) || input.value == "all" )
					continue;
				input.checked = this.thisClicked.checked;
			}
			this.selectRow( row, this.thisClicked.checked );
		}
		this.lastClicked.checked = this.thisClicked.checked;
		this.selectRow( rows[ lastClicked ], this.lastClicked.checked );
	}

	// check alls
	for ( var i = 0; i < alls.length; i++ )
	{
		if ( count && count == selectedCount )
			alls[ i ].checked = true;
		else
			alls[ i ].checked = false;
	}
}


TC.TableSelect.prototype.selectRow = function( row, checked )
{
	if ( !row ) return;
	if( checked )
		TC.addClassName( row, "selected" );
	else
		TC.removeClassName( row, "selected" );
	var next = row.nextSibling;
	while (next && TC.hasClassName( next, "slave" )) {
		if ( checked )
			TC.addClassName( next, "selected" );
		else
			TC.removeClassName( next, "selected" );
		next = next.nextSibling;
	}
}

