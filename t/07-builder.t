# $Id$

BEGIN { unshift @INC, 't/' }

use Test;
use MT;
use MT::Builder;
use strict;

BEGIN { plan tests => 118 };

my $mt = MT->new;

my($tokens, $out);

my $builder = MT::Builder->new;
ok($builder);

my $ctx = My::Context->new;
ok($ctx);

$tokens = $builder->compile($ctx, '');
ok($tokens);
ok(ref($tokens) eq 'ARRAY');
ok(!@$tokens);
ok($builder->build($ctx, $tokens), '');

$tokens = $builder->compile($ctx, 'justified and ancient');
ok($tokens && ref($tokens) eq 'ARRAY');
ok(@$tokens == 1);
ok($tokens->[0][0] eq 'TEXT');
ok($tokens->[0][1] eq 'justified and ancient');
ok($builder->build($ctx, $tokens), 'justified and ancient');

$tokens = $builder->compile($ctx, '<$MTFoo$>');
ok($tokens && ref($tokens) eq 'ARRAY');
ok(@$tokens == 1);
ok($tokens->[0][0] eq 'Foo');
ok(@{ $tokens->[0] } == 5);
ok(ref($tokens->[0][1]) eq 'HASH');
ok(scalar keys %{ $tokens->[0][1] }, 0);
ok($builder->build($ctx, $tokens), 'foo');

$tokens = $builder->compile($ctx, '<$MTFoo no="1"$>');
ok($tokens && ref($tokens) eq 'ARRAY');
ok(@$tokens == 1);
ok(@{ $tokens->[0] } == 5);
ok($tokens->[0][0] eq 'Foo');
ok(ref($tokens->[0][1]) eq 'HASH');
ok($tokens->[0][1]{no}, 1);
ok($builder->build($ctx, $tokens), 'no foo');

$tokens = $builder->compile($ctx, '<$MTFoo no="1" yes="foo bar"$>');
ok($tokens && ref($tokens) eq 'ARRAY');
ok(@$tokens == 1);
ok(@{ $tokens->[0] } == 5);
ok($tokens->[0][0] eq 'Foo');
ok(ref($tokens->[0][1]) eq 'HASH');
ok($tokens->[0][1]{no}, 1);
ok($tokens->[0][1]{yes}, 'foo bar');
ok($builder->build($ctx, $tokens), 'no foo');

$tokens = $builder->compile($ctx, '<$MTFoo yes="foo\'s bar"$>');
ok($tokens && ref($tokens) eq 'ARRAY');
ok(@$tokens == 1);
ok(@{ $tokens->[0] } == 5);
ok($tokens->[0][0] eq 'Foo');
ok(ref($tokens->[0][1]) eq 'HASH');
ok($tokens->[0][1]{yes}, 'foo\'s bar');

$tokens = $builder->compile($ctx, <<'TEXT');
time to kick out the jams, motherfuckers
<$MTFoo$>
TEXT
ok($tokens && ref($tokens) eq 'ARRAY');
ok(@$tokens == 3);
ok($tokens->[0][0] eq 'TEXT');
ok($tokens->[0][1] eq "time to kick out the jams, motherfuckers\n");
ok($tokens->[1][0] eq 'Foo');
ok($tokens->[2][0] eq 'TEXT');
ok($tokens->[2][1] eq "\n");
ok($builder->build($ctx, $tokens),
    "time to kick out the jams, motherfuckers\nfoo\n");
ok($builder->build($ctx, $tokens, { Foo => 0 }),
    "time to kick out the jams, motherfuckers\n\n");

$tokens = $builder->compile($ctx, '<MTBars>');
ok(!$tokens);
ok($builder->errstr eq "&lt;MTBars> with no &lt;/MTBars>\n");

$tokens = $builder->compile($ctx, '<MTBars></MTBars>');
ok($tokens && ref($tokens) eq 'ARRAY');
ok(@$tokens == 1);
ok($tokens->[0][0] eq 'Bars');
ok(ref($tokens->[0][2]) eq 'ARRAY');
ok(@{ $tokens->[0][2] } == 0);
ok($builder->build($ctx, $tokens), '');

$tokens = $builder->compile($ctx, '<MTBars>foo</MTBars>');
ok($tokens && ref($tokens) eq 'ARRAY');
ok(@$tokens == 1);
ok($tokens->[0][0] eq 'Bars');
ok(ref($tokens->[0][2]) eq 'ARRAY');
ok(@{ $tokens->[0][2] } == 1);
ok($tokens->[0][2][0][0] eq 'TEXT');
ok($tokens->[0][2][0][1] eq 'foo');
ok($builder->build($ctx, $tokens), 'foofoo');

$tokens = $builder->compile($ctx, <<'TEXT');
<MTBars>
foo:<$MTBarBaz$>
</MTBars>
TEXT
ok($tokens && ref($tokens) eq 'ARRAY');
ok(@$tokens == 2);
ok($tokens->[0][0] eq 'Bars');
ok(ref($tokens->[0][2]) eq 'ARRAY');
ok(@{ $tokens->[0][2] } == 3);
ok($tokens->[0][2][0][0] eq 'TEXT');
ok($tokens->[0][2][0][1] eq "foo:");
ok($tokens->[0][2][1][0] eq 'BarBaz');
ok($tokens->[0][2][2][0] eq 'TEXT');
ok($tokens->[0][2][2][1] eq "\n");
ok($tokens->[1][0] eq 'TEXT');
ok($tokens->[1][1] eq "\n");
ok($builder->build($ctx, $tokens), "foo:baz1\nfoo:baz2\n\n");

$tokens = $builder->compile($ctx,
q[<$MTFoo regex="s/(\d+)/$1==0?'None':$1==1?'1 reply':$1.'replies'/e"$>]);
ok($tokens && ref($tokens) eq 'ARRAY');
ok(@$tokens == 1);
ok(@{ $tokens->[0] } == 5);
ok($tokens->[0][0] eq 'Foo');
ok(ref($tokens->[0][1]) eq 'HASH');
ok($tokens->[0][1]{regex}, q[s/(\d+)/$1==0?'None':$1==1?'1 reply':$1.'replies'/e]);

$tokens = $builder->compile($ctx, <<'TEXT');
<MTBars>
Bars:
<MTBars>bar</MTBars>
</MTBars>
TEXT
ok($tokens && ref($tokens) eq 'ARRAY');
ok(@$tokens == 2);
ok($tokens->[0][0] eq 'Bars');
ok(ref($tokens->[0][2]) eq 'ARRAY');
ok(@{ $tokens->[0][2] } == 3);
ok($tokens->[0][2][0][0] eq 'TEXT');
ok($tokens->[0][2][0][1] eq "Bars:\n");
ok($tokens->[0][2][1][0] eq 'Bars');
ok(ref($tokens->[0][2][1][2]) eq 'ARRAY');
ok(@{ $tokens->[0][2][1][2] } == 1);
ok($tokens->[0][2][1][2][0][0] eq 'TEXT');
ok($tokens->[0][2][1][2][0][1] eq 'bar');
ok($tokens->[0][2][2][0] eq 'TEXT');
ok($tokens->[0][2][2][1] eq "\n");
ok($tokens->[1][0] eq 'TEXT');
ok($tokens->[1][1] eq "\n");
ok($builder->build($ctx, $tokens), "Bars:\nbarbar\nBars:\nbarbar\n\n");

$tokens = $builder->compile($ctx, "<MTBars/>");
ok($tokens && ref($tokens) eq 'ARRAY');
ok(@$tokens == 1);
ok($tokens->[0][0] eq 'Bars');
ok(!$tokens->[0][2]);
ok($builder->build($ctx, $tokens), 'Called without tokens!');

$tokens = $builder->compile($ctx, '<$MTFoo no="1
"$>');
ok($tokens && ref($tokens) eq 'ARRAY');
ok(@$tokens == 1);
ok(@{ $tokens->[0] } == 5);
ok($tokens->[0][0] eq 'Foo');
ok(ref($tokens->[0][1]) eq 'HASH');
ok($tokens->[0][1]{no}, "1\n");
ok($builder->build($ctx, $tokens), 'no foo');

$tokens = $builder->compile($ctx, '<MTIfBaz>yes</MTIfBaz>');
ok($tokens && ref($tokens) eq 'ARRAY');
ok($builder->build($ctx, $tokens, { IfBaz => 1 }), 'yes');
ok($builder->build($ctx, $tokens, { IfBaz => 0 }), '');

$tokens = $builder->compile($ctx, '<MTIfBaz>yes<MTElse>no</MTElse></MTIfBaz>');
ok($tokens && ref($tokens) eq 'ARRAY');
ok($builder->build($ctx, $tokens, { IfBaz => 1 }), 'yes');
ok($builder->build($ctx, $tokens, { IfBaz => 0 }), 'no');


package My::Context;
use strict;

use MT::ErrorHandler;
use base qw( MT::ErrorHandler );

sub new {
    my $class = shift;
    my $ctx = bless { }, $class;
    $ctx->register_handler(Else => [ \&_hdlr_pass_tokens, 1 ]);
    $ctx->register_handler(Foo => \&_hdlr_foo);
    $ctx->register_handler(Bars => [ \&_hdlr_bars, 1 ]);
    $ctx->register_handler(BarBaz => \&_hdlr_bar_baz);
    $ctx->register_handler(IfBaz => [ \&_hdlr_pass_tokens, 1 ]);
    $ctx;
}

sub stash {
    my $ctx = shift;
    my $key = shift;
    $ctx->{__stash}->{$key} = shift if @_;
    $ctx->{__stash}->{$key};
}

sub register_handler { $_[0]->{__handlers}{$_[1]} = $_[2] }
sub handler_for      {
    my $v = $_[0]->{__handlers}{$_[1]};
    ref($v) eq 'ARRAY' ? @$v : $v
}

sub post_process_handler { }

sub _hdlr_foo {
    my $args = $_[1];
    $args && $args->{no} ? 'no foo' : 'foo'
}

sub _hdlr_pass_tokens {
    my($ctx, $args, $cond) = @_;
    $ctx->stash('builder')->build($ctx, $ctx->stash('tokens'), $cond);
}

sub _hdlr_bars {
    my($ctx) = @_;
    my $tokens = $ctx->stash('tokens');
    return 'Called without tokens!' if !$tokens;
    my $builder = $ctx->stash('builder');
    my $html = '';
    for (1..2) {
        my $bar = { baz => 'baz' . $_ };
        $ctx->stash('bar', $bar);
        my $out = $builder->build($ctx, $tokens);
        return $ctx->error( $builder->errstr ) unless defined $out;
        $html .= $out;
    }
    $html;
}

sub _hdlr_bar_baz {
    my $bar = $_[0]->stash('bar');
    $bar->{baz};
}
