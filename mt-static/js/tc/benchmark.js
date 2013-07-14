/*
# Movable Type (r) Open Source (C) 2003-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
*/


/*
--------------------------------------------------------------------------------
TC.Benchmark
benchmarking utility class
--------------------------------------------------------------------------------
*/

/* constructor */

TC.Benchmark = function()
{
	this.ticks = []
	this.start();
}


/* instance methods */

TC.Benchmark.prototype.start = function()
{
	this.ticks = [];
	this.tick( "start" );
}


TC.Benchmark.prototype.tick = function( name )
{
	var date = new Date();
	var time = date.getTime();
	var last = this.ticks.length ? this.ticks[ this.ticks.length - 1 ].time : time;
	var delta = time - last;
	var start = this.ticks.length ? this.ticks[ 0 ].time : time;
	var total = time - start;
	var tick =
	{
		"name" : name,
		"time" : time,
		"delta" : delta,
		"total" : total
	};
	this.ticks[ this.ticks.length ] = tick;
	return tick.total;
}


TC.Benchmark.prototype.report = function( name )
{
	var out = "";
	for( i = 0; i < this.ticks.length; i++ )
	{
		var tick = this.ticks[ i ];
		out += tick.name + ": " + tick.delta + " " + tick.total + "<br />\n";
	}
	return out;
}
