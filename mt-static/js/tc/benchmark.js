/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
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
