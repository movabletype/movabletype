/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
*/


/*
--------------------------------------------------------------------------------
TC.ColorPicker
dhtml color picker class
--------------------------------------------------------------------------------
*/

/* constructor */

TC.ColorPicker = function()
{
}


/* config */

TC.ColorPicker.prototype.cookieName = "tc-colorpicker-recent";
TC.ColorPicker.prototype.className = "tc-colorpicker";
TC.ColorPicker.prototype.colorsClassName = "tc-colorpicker-colors";
TC.ColorPicker.prototype.recentClassName = "tc-colorpicker-recent";
TC.ColorPicker.prototype.noneClassName = "tc-colorpicker-none";
TC.ColorPicker.prototype.style = { "position" : "absolute" };
TC.ColorPicker.prototype.recentCount = 8;
TC.ColorPicker.prototype.recentNone = false;
TC.ColorPicker.prototype.allowNone = false;
TC.ColorPicker.prototype.defaultColor = "#777777";
TC.ColorPicker.prototype.colors =
[
	"#FFFFFF", "#CCCCCC", "#999999", "#666666", "#333333", "#000000", "#FFCC00", "#FF9900", "#FF6600", "#FF3300", "#000000", "#333333", "#666666", "#999999", "#CCCCCC", "#FFFFFF",
	"#99CC00", "#000000", "#000000", "#000000", "#000000", "#CC9900", "#FFCC33", "#FFCC66", "#FF9966", "#FF6633", "#CC3300", "#000000", "#000000", "#000000", "#000000", "#CC0033",
	"#CCFF00", "#CCFF33", "#333300", "#666600", "#999900", "#CCCC00", "#FFFF00", "#CC9933", "#CC6633", "#330000", "#660000", "#990000", "#CC0000", "#FF0000", "#FF3366", "#FF0033",
	"#99FF00", "#CCFF66", "#99CC33", "#666633", "#999933", "#CCCC33", "#FFFF33", "#996600", "#993300", "#663333", "#993333", "#CC3333", "#FF3333", "#CC3366", "#FF6699", "#FF0066",
	"#66FF00", "#99FF66", "#66CC33", "#669900", "#999966", "#CCCC66", "#FFFF66", "#996633", "#663300", "#996666", "#CC6666", "#FF6666", "#990033", "#CC3399", "#FF66CC", "#FF0099",
	"#33FF00", "#66FF33", "#339900", "#66CC00", "#99FF33", "#CCCC99", "#FFFF99", "#CC9966", "#CC6600", "#CC9999", "#FF9999", "#FF3399", "#CC0066", "#990066", "#FF33CC", "#FF00CC",
	"#00CC00", "#33CC00", "#336600", "#669933", "#99CC66", "#CCFF99", "#FFFFCC", "#FFCC99", "#FF9933", "#FFCCCC", "#FF99CC", "#CC6699", "#993366", "#660033", "#CC0099", "#330033",
	"#33CC33", "#66CC66", "#00FF00", "#33FF33", "#66FF66", "#99FF99", "#CCFFCC", "#000000", "#000000", "#000000", "#CC99CC", "#996699", "#993399", "#990099", "#663366", "#660066",
	"#006600", "#336633", "#009900", "#339933", "#669966", "#99CC99", "#000000", "#000000", "#000000", "#FFCCFF", "#FF99FF", "#FF66FF", "#FF33FF", "#FF00FF", "#CC66CC", "#CC33CC",
	"#003300", "#00CC33", "#006633", "#339966", "#66CC99", "#99FFCC", "#CCFFFF", "#3399FF", "#99CCFF", "#CCCCFF", "#CC99FF", "#9966CC", "#663399", "#330066", "#9900CC", "#CC00CC",
	"#00FF33", "#33FF66", "#009933", "#00CC66", "#33FF99", "#99FFFF", "#99CCCC", "#0066CC", "#6699CC", "#9999FF", "#9999CC", "#9933FF", "#6600CC", "#660099", "#CC33FF", "#CC00FF",
	"#00FF66", "#66FF99", "#33CC66", "#009966", "#66FFFF", "#66CCCC", "#669999", "#003366", "#336699", "#6666FF", "#6666CC", "#666699", "#330099", "#9933CC", "#CC66FF", "#9900FF",
	"#00FF99", "#66FFCC", "#33CC99", "#33FFFF", "#33CCCC", "#339999", "#336666", "#006699", "#003399", "#3333FF", "#3333CC", "#333399", "#333366", "#6633CC", "#9966FF", "#6600FF",
	"#00FFCC", "#33FFCC", "#00FFFF", "#00CCCC", "#009999", "#006666", "#003333", "#3399CC", "#3366CC", "#0000FF", "#0000CC", "#000099", "#000066", "#000033", "#6633FF", "#3300FF",
	"#00CC99", "#000000", "#000000", "#000000", "#000000", "#0099CA", "#33CCFF", "#66CCFF", "#6699FF", "#3366FF", "#0033CC", "#000000", "#000000", "#000000", "#000000", "#3300CC",
	"#FFFFFF", "#CCCCCC", "#999999", "#666666", "#333333", "#000000", "#00CCFF", "#0099FF", "#0066FF", "#0033FF", "#000000", "#333333", "#666666", "#999999", "#CCCCCC", "#FFFFFF"
];


/* static variables */

TC.ColorPicker.instance = null;


/* static methods */

TC.ColorPicker.pick = function( evt, pickFunc, color )
{
	TC.ColorPicker.init();
	if( TC.ColorPicker.instance )
		return TC.ColorPicker.instance.pick( evt, pickFunc, color );
	return false;
}


TC.ColorPicker.init = function()
{
	if( !TC.ColorPicker.instance )
		TC.ColorPicker.instance = new TC.ColorPicker();
}


/* instance methods */

TC.ColorPicker.prototype.pick = function( evt, pickFunc, color )
{
	evt = evt || event;
	var element = evt.target || evt.srcElement;
	
	this.init();
	this.pickFunc = pickFunc;
	this.window.show();
	
	// eventually use smart window placement code
	var pos = TC.getAbsolutePosition( element );
	this.window.element.style.left = pos.left + "px";
	this.window.element.style.top = pos.top + "px";
	
	return false;
}


TC.ColorPicker.prototype.pickColor = function( color )
{
	this.window.hide();
	this.addRecentColor( color );
	this.showRecentColors();
	this.bakeRecentColors();
	if( this.pickFunc )
		this.pickFunc( color );
}


TC.ColorPicker.prototype.addRecentColor = function( color )
{
	if( !color )
	{
		if( !this.recentNone )
			return;
		color = "";
	}
	var colors = [ color ];
	for( var i in this.recentColors )
		if( color != this.recentColors[ i ] )
			colors[ colors.length ] = this.recentColors[ i ];
	if( colors.length > this.recentElements.length )
		colors.length = this.recentElements.length;
	this.recentColors = colors;
}


TC.ColorPicker.prototype.clearRecentColors = function()
{
	for( var i in this.recentColors )
		this.recentColors[ i ] = "";
}


TC.ColorPicker.prototype.showRecentColors = function()
{
	for( var i = 0; i < this.recentColors.length; i++ )
		this.setElementColor( this.recentElements[ i ], this.recentColors[ i ] );
}


TC.ColorPicker.prototype.fetchRecentColors = function()
{
	if( !this.cookie )
		return;
	if( !this.cookie.fetch() )
		return false;
	if( !this.cookie.value )
		return false;
	var colors = this.cookie.value.split( "," );
	for( var i in this.recentColors )
		this.recentColors[ i ] = colors[ i ] ? colors[ i ] : "";
}


TC.ColorPicker.prototype.bakeRecentColors = function()
{
	if( !this.cookie )
		return;
	var colors = [];
	this.cookie.value = this.recentColors.join( "," );
	this.cookie.expires = new Date();
	this.cookie.expires.setFullYear( parseInt( this.cookie.expires.getFullYear() ) + 100 );
	this.cookie.bake();
}


TC.ColorPicker.prototype.setElementColor = function( element, color, title )
{
	if( !element )
		return;
	if( !color )
		color = this.allowNone ? "" : this.defaultColor;
	if( !title )
		title = color;
	if( !title )
		title = "";
	if( !color )
		element.className = this.noneClassName;
	else if( element.className )
		element.className = "";
	element.style.backgroundColor = color;
	element.setAttribute( "color", color );
	element.setAttribute( "title", title );
}


TC.ColorPicker.prototype.clickColor = function( evt )
{
	evt = evt || event;
	var element = evt.target || evt.srcElement;
	var color = element ? element.getAttribute( "color" ) : "";
	this.pickColor( color );
	return TC.stopEvent( evt );
}


TC.ColorPicker.prototype.init = function()
{
	if( this.inited )
		return;
	
	// basic setup
	this.recentColors = [];
	this.recentElements = [];
	this.window = new TC.Window();
	this.window.quick = true;
	this.window.element.className = this.className;
	this.window.setStyle( this.style );
	
	// cookie setup
	if( TC.Cookie )
		this.cookie = new TC.Cookie( this.cookieName );
	
	// make closures
	var self = this;
	this.clickColorClosure = function( evt ) { return self.clickColor( evt ); };
	
	// create tables
	var recent = this.createPicker( this.recentClassName, this.recentCount );
	var picker = this.createPicker( this.colorsClassName, this.colors.length, this.colors );
	
	// set recent colors
	this.fetchRecentColors();
	this.showRecentColors();
	
	// attach
	this.window.element.appendChild( recent );
	this.window.element.appendChild( picker );
	this.window.attach();
	
	
	// we're good
	this.inited = true;
}


TC.ColorPicker.prototype.createPicker = function( className, count, colors )
{
	// set empty array
	if( !colors )
		colors = [];
	
	// create wrapper div
	var div = document.createElement( "div" );
	div.className = className;
	
	// create color links
	var swatch;
	for( var c = 0; c < count; c++ )
	{
		// try to duplicate node
		if( swatch )
			swatch = swatch.cloneNode( true );
		
		// create new node
		if( !swatch )
		{
			swatch = document.createElement( "a" );
			swatch.appendChild( document.createTextNode( " " ) );
		}
		
		// event handler
		swatch.onclick = this.clickColorClosure;
		
		// get color
		var color = "";
		if( c < colors.length )
			color = colors[ c ];
		else
		{
			this.recentColors[ this.recentColors.length ] = color;
			this.recentElements[ this.recentElements.length ] = swatch;
		}
		
		// color bleeds
		this.setElementColor( swatch, color );
		
		// attach
		div.appendChild( swatch );
	}
	
	return div;
}
