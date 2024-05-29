#!/usr/bin/perl
# $Id: 07-builder.t 3022 2008-09-03 20:16:30Z bchoate $

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',  ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use utf8;
use Data::Dumper;

use MT::Test;
use MT;
use MT::Template::Node ':constants';

my $mt = MT->new;

my ( $tokens, $out );

my $builder = MT->builder;
ok( $builder, "Builder constructed okay" );

my $ctx = My::Context->new;
ok( $ctx, "Context constructed okay" );

note("Testing compilation of an empty template");
$tokens = $builder->compile( $ctx, '' );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens,                 "Compiled empty template" );
ok( ref($tokens) eq 'ARRAY', "Empty template produced token list" );
ok( !@$tokens,               "Token list is empty, which is okay" );
is( $builder->build( $ctx, $tokens ), '', "Builds to an empty string" );

note("Testing compilation of a pure-text template (no tags)");
$tokens = $builder->compile( $ctx, 'justified and ancient' );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 1,             "Created one token" );
ok( $tokens->[0][EL_NODE_NAME] eq 'TEXT', "Token is textual" );
ok( $tokens->[0][EL_NODE_VALUE] eq 'justified and ancient',
    "Token text is what we expect" );
is( $builder->build( $ctx, $tokens ),
    'justified and ancient',
    "Builds to what we expect"
);

note("Testing compilation of simple function tag");
$tokens = $builder->compile( $ctx, '<$MTFoo$>' );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 1,            "Created one token" );
ok( $tokens->[0][EL_NODE_NAME] eq 'Foo', "Token is a tag token" );
ok( @{ $tokens->[0] } == 7,   "Length of token object is 7 elements" );
ok( ref( $tokens->[0][EL_NODE_ATTR] ) eq 'HASH',
    "Element 1 of token object is a hashref"
);
is( scalar keys %{ $tokens->[0][EL_NODE_ATTR] }, 0, "Has no attributes" );
is( $builder->build( $ctx, $tokens ),
    'foo', "Building produces expected result" );

note("Testing compilation of function tag with an attribute");
$tokens = $builder->compile( $ctx, '<$MTFoo no="1"$>' );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 1,            "Created one token" );
ok( @{ $tokens->[0] } == 7,   "Length of token object is 7 elements" );
ok( $tokens->[0][EL_NODE_NAME] eq 'Foo', "Token is a tag token" );
ok( ref( $tokens->[0][EL_NODE_ATTR] ) eq 'HASH',
    "Element 1 of token object is a hashref"
);
is( $tokens->[0][EL_NODE_ATTR]{no}, 1, "Attribute 'no' is equal to 1" );
is( $builder->build( $ctx, $tokens ),
    'no foo', "Building produces expected result" );

note("Testing compilation of function tag with multiple attributes");
$tokens = $builder->compile( $ctx, '<$MTFoo no="1" yes="foo bar"$>' );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 1,            "Created one token" );
ok( @{ $tokens->[0] } == 7,   "Length of token object is 7 elements" );
ok( $tokens->[0][EL_NODE_NAME] eq 'Foo', "Token is a tag token" );
ok( ref( $tokens->[0][EL_NODE_ATTR] ) eq 'HASH',
    "Element 1 of token object is a hashref"
);
is( $tokens->[0][EL_NODE_ATTR]{no}, 1, "Attribute 'no' is equal to 1" );
is( $tokens->[0][EL_NODE_ATTR]{yes}, 'foo bar',
    "Attribute 'yes' is equal to 'foo bar'" );
is( $builder->build( $ctx, $tokens ),
    'no foo', "Building produces expected result" );

note(
    "Testing compilation of function tag with attribute an inner single quote"
);
$tokens = $builder->compile( $ctx, '<$MTFoo yes="foo\'s bar"$>' );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 1,            "Created one token" );
ok( @{ $tokens->[0] } == 7,   "Length of token object is 7 elements" );
ok( $tokens->[0][EL_NODE_NAME] eq 'Foo', "Token is a tag token" );
ok( ref( $tokens->[0][EL_NODE_ATTR] ) eq 'HASH',
    "Element 1 of token object is a hashref"
);
is( $tokens->[0][EL_NODE_ATTR]{yes},
    'foo\'s bar', "Attribute 'yes' is equal to \"foo's bar\"" );

note("Testing compilation of text + function tag");
$tokens = $builder->compile( $ctx, <<'TEXT');
All that glitters is not gold.
<$MTFoo$>
TEXT
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 3,             "Created 3 tokens" );
ok( $tokens->[0][EL_NODE_NAME] eq 'TEXT', "Token 1 is a text token" );
ok( $tokens->[0][EL_NODE_VALUE] eq "All that glitters is not gold.\n",
    "Text is expected value" );
ok( $tokens->[1][EL_NODE_NAME] eq 'Foo',  "Token 2 is a tag token" );
ok( $tokens->[2][EL_NODE_NAME] eq 'TEXT', "Token 3 is a text token" );
ok( $tokens->[2][EL_NODE_VALUE] eq "\n",   "Text is expected value" );
is( $builder->build( $ctx, $tokens ),
    "All that glitters is not gold.\nfoo\n",
    "Building produces expected result"
);
is( $builder->build( $ctx, $tokens, { Foo => 0 } ),
    "All that glitters is not gold.\n\n",
    "Building produces expected result, with conditional"
);

note("Testing compilation failure for a block tag (no closing tag)");
$tokens = $builder->compile( $ctx, '<MTBars>' );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( !$tokens, "Compiling failed, as expected" );
like( $builder->errstr => qr!^(<MTBars> with no </MTBars> on line 1.|Tag Bars left unclosed at line 1)\n\z!,
    "Compilation yielded proper error message" );

# diag("Testing compilation failure for a nested block tag");
# $tokens = $builder->compile($ctx, <<EOT);
# <MTBars>
#
#
#
#
# <MTBars>
#
# </MTBars>
#
# <MTBars> # ERROR IS HERE, LINE 10
#
# <MTBars>
#
# </MTBars>
# EOT
# diag("Error: " . $builder->errstr) unless $tokens;
# ok(!$tokens, "Compiling failed, as expected");
# ok($builder->errstr eq "<MTBars> with no </MTBars> on line 10.\n", "Compilation yielded proper error message");

note("Testing compilation of a block tag with nothing in it");
$tokens = $builder->compile( $ctx, '<MTBars></MTBars>' );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 1,                     "Created 1 token" );
ok( $tokens->[0][EL_NODE_NAME] eq 'Bars',         "Token is a tag token" );
ok( ref( $tokens->[0][EL_NODE_CHILDREN] ) eq 'ARRAY', "Token has child token array" );
ok( @{ $tokens->[0][EL_NODE_CHILDREN] } == 0,         "Child token length is 0" );
is( $builder->build( $ctx, $tokens ),
    'Called without tokens!',
    "Building produces expected result"
);

note("Testing compilation of a block tag wrapping plaintext");
$tokens = $builder->compile( $ctx, '<MTBars>foo</MTBars>' );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 1,                     "Created 1 token" );
ok( $tokens->[0][EL_NODE_NAME] eq 'Bars',         "Token is a tag token" );
ok( ref( $tokens->[0][EL_NODE_CHILDREN] ) eq 'ARRAY', "Token has child token array" );
ok( @{ $tokens->[0][EL_NODE_CHILDREN] } == 1,         "Child token length is 1" );
ok( $tokens->[0][EL_NODE_CHILDREN][0][EL_NODE_NAME] eq 'TEXT',   "Child token is textual" );
ok( $tokens->[0][EL_NODE_CHILDREN][0][EL_NODE_VALUE] eq 'foo',    "Child token value is 'foo'" );
is( $builder->build( $ctx, $tokens ),
    'foofoo', "Building produces expected result" );

note("Testing compilation of a block tag wrapping plaintext + function tag");
$tokens = $builder->compile( $ctx, <<'TEXT');
<MTBars>
foo:<$MTBarBaz$>
</MTBars>
TEXT
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 2,                     "Created 2 tokens" );
ok( $tokens->[0][0] eq 'Bars',         "Token 1 is a tag token" );
ok( ref( $tokens->[0][EL_NODE_CHILDREN] ) eq 'ARRAY', "Token has child token array" );
ok( @{ $tokens->[0][EL_NODE_CHILDREN] } == 3,         "Child token array length is 3" );
ok( $tokens->[0][EL_NODE_CHILDREN][0][EL_NODE_NAME] eq 'TEXT',   "First child token is textual" );
ok( $tokens->[0][EL_NODE_CHILDREN][0][EL_NODE_VALUE] eq "\nfoo:", "First child token text matches" );
ok( $tokens->[0][EL_NODE_CHILDREN][1][EL_NODE_NAME] eq 'BarBaz', "Second child token is a tag" );
ok( $tokens->[0][EL_NODE_CHILDREN][2][EL_NODE_NAME] eq 'TEXT',   "Third child token is textual" );
ok( $tokens->[0][EL_NODE_CHILDREN][2][EL_NODE_VALUE] eq "\n",     "Third child token text matches" );
ok( $tokens->[1][EL_NODE_NAME] eq 'TEXT',         "Second token is textual" );
ok( $tokens->[1][EL_NODE_VALUE] eq "\n",           "Second token text matches" );
is( $builder->build( $ctx, $tokens ),
    "\nfoo:baz1\n\nfoo:baz2\n\n",
    "Building produces expected result"
);

$tokens = $builder->compile( $ctx,
    q[<$MTFoo regex="s/(\d+)/$1==0?'None':$1==1?'1 reply':$1.'replies'/e"$>]
);
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 1,            "Created 1 token" );
ok( @{ $tokens->[0] } == 7,   "Length of token object is 7 elements" );
ok( $tokens->[0][EL_NODE_NAME] eq 'Foo', "Token 1 is a tag token" );
ok( ref( $tokens->[0][EL_NODE_ATTR] ) eq 'HASH', "Token has an attribute hashref" );
is( $tokens->[0][EL_NODE_ATTR]{regex},
    q[s/(\d+)/$1==0?'None':$1==1?'1 reply':$1.'replies'/e],
    "'regex' attribute is set properly"
);

note("Testing compilation of nesting a block tag");
$tokens = $builder->compile( $ctx, <<'TEXT');
<MTBars>
Bars:
<MTBars>bar</MTBars>
</MTBars>
TEXT
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 2,                        "Created 2 tokens" );
ok( $tokens->[0][EL_NODE_NAME] eq 'Bars',            "Token 1 is a tag token" );
ok( ref( $tokens->[0][EL_NODE_CHILDREN] ) eq 'ARRAY',    "Token 1 has subtokens" );
ok( @{ $tokens->[0][EL_NODE_CHILDREN] } == 3,            "Subtoken length is 3" );
ok( $tokens->[0][EL_NODE_CHILDREN][0][EL_NODE_NAME] eq 'TEXT',      "Subtoken 1 is textual" );
ok( $tokens->[0][EL_NODE_CHILDREN][0][EL_NODE_VALUE] eq "\nBars:\n", "Subtoken 1 is expected value" );
ok( $tokens->[0][EL_NODE_CHILDREN][1][EL_NODE_NAME] eq 'Bars',      "Subtoken 2 is a tag token" );
ok( ref( $tokens->[0][EL_NODE_CHILDREN][1][EL_NODE_CHILDREN] ) eq 'ARRAY',
    "Subtoken 2 contains subtokens" );
ok( @{ $tokens->[0][EL_NODE_CHILDREN][1][EL_NODE_CHILDREN] } == 1, "Subtoken 2 has 1 child token" );
ok( $tokens->[0][EL_NODE_CHILDREN][1][EL_NODE_CHILDREN][0][EL_NODE_NAME] eq 'TEXT',
    "Subtoken 2's child node is textual"
);
ok( $tokens->[0][EL_NODE_CHILDREN][1][EL_NODE_CHILDREN][0][EL_NODE_VALUE] eq 'bar',
    "Subtoken 2's child node is expected value"
);
ok( $tokens->[0][EL_NODE_CHILDREN][2][EL_NODE_NAME] eq 'TEXT', "Subtoken 3 is textual" );
ok( $tokens->[0][EL_NODE_CHILDREN][2][EL_NODE_VALUE] eq "\n",   "Subtoken 3 is expected value" );
ok( $tokens->[1][EL_NODE_NAME] eq 'TEXT',       "Token 2 is textual" );
ok( $tokens->[1][EL_NODE_VALUE] eq "\n",         "Token 2 is expected value" );
is( $builder->build( $ctx, $tokens ),
    "\nBars:\nbarbar\n\nBars:\nbarbar\n\n",
    "Building produces expected result"
);

note("Testing compilation of an empty block tag (singlet syntax)");
$tokens = $builder->compile( $ctx, "<MTBars/>" );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 1,             "Created 1 token" );
ok( $tokens->[0][EL_NODE_NAME] eq 'Bars', "Token is a tag token" );
ok( !@{ $tokens->[0][EL_NODE_CHILDREN] || [] }, "Subtoken list is empty" );
is( $builder->build( $ctx, $tokens ),
    'Called without tokens!',
    "Building produces expected result"
);

note("Testing compilation with an attribute that has a newline");
$tokens = $builder->compile(
    $ctx, '<$MTFoo no="1
"$>'
);
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 1,            "Created 1 token" );
ok( @{ $tokens->[0] } == 7,   "Length of token object is 7 elements" );
ok( $tokens->[0][EL_NODE_NAME] eq 'Foo', "Token 1 is a tag token" );
ok( ref( $tokens->[0][EL_NODE_ATTR] ) eq 'HASH', "Token 1 has an attribute hashref" );
is( $tokens->[0][EL_NODE_ATTR]{no}, "1\n", "Value of 'no' attribute is set properly" );
is( $builder->build( $ctx, $tokens ),
    'no foo', "Building produces expected result" );

note("Testing conditional tag");
$tokens = $builder->compile( $ctx, '<MTIfBaz>yes</MTIfBaz>' );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields token" );
is( $builder->build( $ctx, $tokens, { IfBaz => 1 } ),
    'yes', "Building with conditional set produces expected result" );
is( $builder->build( $ctx, $tokens, { IfBaz => 0 } ),
    '', "Building with conditional unset produces expected result" );

note("Testing conditional tags with Else tag");
$tokens
    = $builder->compile( $ctx, '<MTIfBaz>yes<MTElse>no</MTElse></MTIfBaz>' );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields token" );
is( $builder->build( $ctx, $tokens, { IfBaz => 1 } ),
    'yes', "Building with conditional set produces expected result" );
is( $builder->build( $ctx, $tokens, { IfBaz => 0 } ),
    'no', "Building with conditional unset produces expected result" );

note("Testing conditional tags with Else (but no closing Else) tag");
$tokens = $builder->compile( $ctx, '<MTIfBaz>yes<MTElse>no</MTIfBaz>' );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields token" );
is( $builder->build( $ctx, $tokens, { IfBaz => 1 } ),
    'yes', "Building with conditional set produces expected result" );
is( $builder->build( $ctx, $tokens, { IfBaz => 0 } ),
    'no', "Building with conditional unset produces expected result" );

note("Testing case-insensitivity for MT templates");
$tokens = $builder->compile( $ctx, '<$MtFoO$>' );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 1,            "Created one token" );
ok( $tokens->[0][EL_NODE_NAME] eq 'FoO', "Token is a tag token" );
ok( @{ $tokens->[0] } == 7,   "Length of token object is 7 elements" );
ok( ref( $tokens->[0][EL_NODE_ATTR] ) eq 'HASH',
    "Element 1 of token object is a hashref"
);
is( scalar keys %{ $tokens->[0][EL_NODE_ATTR] }, 0, "Has no attributes" );
is( $builder->build( $ctx, $tokens ),
    'foo', "Building produces expected result" );

note("Testing optional '\$' syntax for function tags");
$tokens = $builder->compile( $ctx, '<mtfoo>' );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 1,            "Created one token" );
ok( $tokens->[0][EL_NODE_NAME] eq 'foo', "Token is a tag token" );
ok( @{ $tokens->[0] } == 7,   "Length of token object is 7 elements" );
ok( ref( $tokens->[0][EL_NODE_ATTR] ) eq 'HASH',
    "Element 1 of token object is a hashref"
);
is( scalar keys %{ $tokens->[0][EL_NODE_ATTR] }, 0, "Has no attributes" );
is( $builder->build( $ctx, $tokens ),
    'foo', "Building produces expected result" );

note("Testing optional namespace ':' syntax for function tags");
$tokens = $builder->compile( $ctx, '<mt:foo>' );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 1,            "Created one token" );
ok( $tokens->[0][EL_NODE_NAME] eq 'foo', "Token is a tag token" );
ok( @{ $tokens->[0] } == 7,   "Length of token object is 7 elements" );
ok( ref( $tokens->[0][EL_NODE_ATTR] ) eq 'HASH',
    "Element 1 of token object is a hashref"
);
is( scalar keys %{ $tokens->[0][EL_NODE_ATTR] }, 0, "Has no attributes" );
is( $builder->build( $ctx, $tokens ),
    'foo', "Building produces expected result" );

note("Mismatched closing tag in a block");
$tokens = $builder->compile( $ctx, '<mt:setvarblock name="foo"></mt:?Ignore></mt:setvarblock><mt:var name="foo">' );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 2,            "Created two tokens" );
ok( $tokens->[0][EL_NODE_NAME] eq 'setvarblock', "Token is a tag token" );
ok( @{ $tokens->[0] } == 7,   "Length of token object is 7 elements" );
ok( @{ $tokens->[0][EL_NODE_CHILDREN] || [] } == 1, "Token is a child tag token" );
ok( $tokens->[0][EL_NODE_CHILDREN][0][EL_NODE_NAME] eq 'TEXT', "Child token is a text" );
ok( $tokens->[0][EL_NODE_CHILDREN][0][EL_NODE_VALUE] eq '</mt:?Ignore>', "Child token keeps an unmatched closing tag" );
is( $builder->build( $ctx, $tokens ),
    '</mt:?Ignore>', "Building produces expected result" );

note("Mismatched closing tag not in a block");
$tokens = $builder->compile( $ctx, '</mt:?Ignore>' );
note( "Error: " . $builder->errstr ) unless $tokens;
ok( $tokens && ref($tokens) eq 'ARRAY', "Compiles and yields tokens" );
ok( @$tokens == 1,            "Created one token" );
ok( $tokens->[0][EL_NODE_NAME] eq 'TEXT', "Token is a text" );
ok( @{ $tokens->[0] } == 7,   "Length of token object is 7 elements" );
ok( $tokens->[0][EL_NODE_VALUE] eq '</mt:?Ignore>', "Token keeps an unmatched closing tag" );
is( $builder->build( $ctx, $tokens ),
    '</mt:?Ignore>', "Building produces expected result" );

note("More complex mismatched closing tags");
$tokens = $builder->compile( $ctx, <<'TMPL' );
<mt:if test="1">
<mt:setvarblock name="foo">
</mt:if>
</mt:setvarblock><mt:var name="foo">
</mt:if>
TMPL
note( "Error: " . $builder->errstr ) unless $tokens;
ok( !$tokens, "Compiling failed, as expected" );
like( $builder->errstr => qr!^<mt:setvarblock> with no </mt:setvarblock> on line .!,
    "Compilation yielded proper error message" );

$mt->set_language('ja_JP');

note("Unknown localized tag");
$tokens = $builder->compile( $ctx, '<mt:vあr>' );
like $builder->errstr => qr/\Q<mt:vあr>は存在しません(1行目)\E|\Q<mt:vあr>は定義されていません(1行目)\E/,
    "correct error" or note "Error: " . $builder->errstr;

$mt->config->clear_dirty;

done_testing;

package My::Context;

use strict;
use base qw( MT::Template::Context );

sub new {
    my $class = shift;
    my $ctx   = $class->SUPER::new(@_);
    $ctx->{__handlers}{foo}    = \&_hdlr_foo;
    $ctx->{__handlers}{bars}   = [ \&_hdlr_bars, 1 ];
    $ctx->{__handlers}{barbaz} = \&_hdlr_bar_baz;
    $ctx->{__handlers}{ifbaz}
        = [ \&MT::Template::Context::_hdlr_pass_tokens, 1 ];
    return $ctx;
}

sub _hdlr_foo {
    my $args = $_[1];
    $args && $args->{no} ? 'no foo' : 'foo';
}

sub _hdlr_bars {
    my ($ctx) = @_;
    my $tokens = $ctx->stash('tokens');
    return 'Called without tokens!' if !$tokens || !@$tokens;
    my $builder = $ctx->stash('builder');
    my $html    = '';
    for ( 1 .. 2 ) {
        my $bar = { baz => 'baz' . $_ };
        $ctx->stash( 'bar', $bar );
        my $out = $builder->build( $ctx, $tokens );
        return $ctx->error( $builder->errstr ) unless defined $out;
        $html .= $out;
    }
    $html;
}

sub _hdlr_bar_baz {
    my $bar = $_[0]->stash('bar');
    $bar->{baz};
}
