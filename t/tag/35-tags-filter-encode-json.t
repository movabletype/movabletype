#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Encode;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;
plan tests => 2 * blocks;

use MT;
use MT::Test qw(:db);
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp _unescape )],
    expected => [qw( chomp _unescape )],
};

my $mt = MT->instance;

sub _unescape {
    my ($s) = @_;

    # \\b => \b
    $s =~ s/([^\\])\\b/$1\b/g;
    $s =~ s/([^\\])\\f/$1\f/g;
    $s =~ s/([^\\])\\r/$1\r/g;
    $s =~ s/([^\\])\\n/$1\n/g;
    $s =~ s/([^\\])\\t/$1\t/g;

    # \\\\b => \\b
    $s =~ s/\\(\\[b|f|r|n|t])/$1/g;

    return $s;
}

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== quotation mark
--- template
<MTSetVar name="string" value='"'>
<MTVar name="string">
<MTVar name="string" encode_json="1">
--- expected
"
\"

=== reverse solidus
--- template
<MTSetVar name="string" value="\">
<MTVar name="string">
<MTVar name="string" encode_json="1">
--- expected
\
\\

=== solidus (this is not escaped)
--- template
<MTSetVar name="string" value="/">
<MTVar name="string">
<MTVar name="string" encode_json="1">
--- expected
/
/

=== backspace
--- template
<MTSetVarBlock name="string">foo\bbar</MTSetVarBlock>
<MTVar name="string">
<MTVar name="string" encode_json="1">
--- expected
foo\bbar
foo\\bbar

=== formfeed
--- template
<MTSetVarBlock name="string">foo\fbar</MTSetVarBlock>
<MTVar name="string">
<MTVar name="string" encode_json="1">
--- expected
foo\fbar
foo\\fbar

=== carriage return
--- template
<MTSetVarBlock name="string">foo\rbar</MTSetVarBlock>
<MTVar name="string">
<MTVar name="string" encode_json="1">
--- expected
foo\rbar
foo\\rbar

=== newline
--- template
<MTSetVarBlock name="string">foo\nbar</MTSetVarBlock>
<MTVar name="string">
<MTVar name="string" encode_json="1">
--- expected
foo\nbar
foo\\nbar

=== horizontal tab
--- template
<MTSetVarBlock name="string">foo\tbar</MTSetVarBlock>
<MTVar name="string">
<MTVar name="string" encode_json="1">
--- expected
foo\tbar
foo\\tbar

=== alphabets and numbers (these are not escaped)
--- template
<MTSetVarBlock name="string">abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ012344567890</MTSetVarBlock>
<MTVar name="string" encode_json="1">
--- expected
abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ012344567890

=== Japanese characters
--- template _unescape
<MTSetVarBlock name="string">あい\うえお</MTSetVarBlock>
<MTVar name="string">
<MTVar name="string" encode_json="1">
--- expected _unescape
あい\うえお
あい\\うえお
