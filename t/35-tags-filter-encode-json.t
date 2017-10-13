#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}


use lib qw(lib t/lib);

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use MT::Test::Tag;
plan tests => 2 * blocks;

use MT;
use MT::Test qw(:db);
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

sub _unescape {
    # \\b => \b
    s/([^\\])\\b/$1\b/g;
    s/([^\\])\\f/$1\f/g;
    s/([^\\])\\r/$1\r/g;
    s/([^\\])\\n/$1\n/g;
    s/([^\\])\\t/$1\t/g;

    # \\\\b => \\b
    s/\\(\\[b|f|r|n|t])/$1/g;
}

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== quotation mark
--- template _unescape
<MTSetVar name="string" value='"'>
<MTVar name="string">
<MTVar name="string" encode_json="1">
--- expected _unescape
"
\"

=== reverse solidus
--- template _unescape
<MTSetVar name="string" value="\">
<MTVar name="string">
<MTVar name="string" encode_json="1">
--- expected _unescape
\
\\

=== solidus (this is not escaped)
--- template _unescape
<MTSetVar name="string" value="/">
<MTVar name="string">
<MTVar name="string" encode_json="1">
--- expected _unescape
/
/

=== backspace
--- template _unescape
<MTSetVarBlock name="string">foo\bbar</MTSetVarBlock>
<MTVar name="string">
<MTVar name="string" encode_json="1">
--- expected _unescape
foo\bbar
foo\\bbar

=== formfeed
--- template _unescape
<MTSetVarBlock name="string">foo\fbar</MTSetVarBlock>
<MTVar name="string">
<MTVar name="string" encode_json="1">
--- expected _unescape
foo\fbar
foo\\fbar

=== carriage return
--- template _unescape
<MTSetVarBlock name="string">foo\rbar</MTSetVarBlock>
<MTVar name="string">
<MTVar name="string" encode_json="1">
--- expected _unescape
foo\rbar
foo\\rbar

=== newline
--- template _unescape
<MTSetVarBlock name="string">foo\nbar</MTSetVarBlock>
<MTVar name="string">
<MTVar name="string" encode_json="1">
--- expected _unescape
foo\nbar
foo\\nbar

=== horizontal tab
--- template _unescape
<MTSetVarBlock name="string">foo\tbar</MTSetVarBlock>
<MTVar name="string">
<MTVar name="string" encode_json="1">
--- expected _unescape
foo\tbar
foo\\tbar

=== alphabets and numbers (these are not escaped)
--- template _unescape
<MTSetVarBlock name="string">abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ012344567890</MTSetVarBlock>
<MTVar name="string" encode_json="1">
--- expected _unescape
abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ012344567890
