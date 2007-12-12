/*
 * CodePress regular expressions for Movable Type syntax highlighting
 */

// Movable Type (always supplemental to an existing language, so we
// don't replace Language.syntax, we add to it)
Language.syntax.unshift(
	{ input : /(\$)&gt;/g, output : '<u>$1</u>&gt;' }
);
Language.syntax.unshift(
	{ input : /&lt;(\/?\$?MT:?\w*)/ig, output : '&lt;<u>$1</u>' }
);
