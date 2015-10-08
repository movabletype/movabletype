#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib t/lib);

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use IPC::Open2;

use Test::Base;
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

my $mt = MT->instance;

run {
    my $block = shift;

SKIP:
    {
        skip $block->skip, 1 if $block->skip;

        my $tmpl = $app->model('template')->new;
        $tmpl->text( _unescape( $block->template ) );
        my $ctx = $tmpl->context;

        my $blog = MT::Blog->load($blog_id);
        $ctx->stash( 'blog',          $blog );
        $ctx->stash( 'blog_id',       $blog->id );
        $ctx->stash( 'local_blog_id', $blog->id );
        $ctx->stash( 'builder',       MT::Builder->new );

        my $result = $tmpl->build;
        $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;

        is( $result, _unescape( $block->expected ), $block->name );
    }
};

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

sub php_test_script {
    my ( $template, $text ) = @_;
    $text ||= '';

    my $test_script = <<PHP;
<?php
\$MT_HOME   = '@{[ $ENV{MT_HOME} ? $ENV{MT_HOME} : '.' ]}';
\$MT_CONFIG = '@{[ $app->find_config ]}';
\$blog_id   = '$blog_id';
\$tmpl = <<<__TMPL__
$template
__TMPL__
;
\$text = <<<__TMPL__
$text
__TMPL__
;
PHP
    $test_script .= <<'PHP';
include_once($MT_HOME . '/php/mt.php');
include_once($MT_HOME . '/php/lib/MTUtil.php');

$mt = MT::get_instance(1, $MT_CONFIG);
$mt->init_plugins();

$db = $mt->db();
$ctx =& $mt->context();

$ctx->stash('blog_id', $blog_id);
$ctx->stash('local_blog_id', $blog_id);
$blog = $db->fetch_blog($blog_id);
$ctx->stash('blog', $blog);

if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
    $ctx->_eval('?>' . $_var_compiled);
} else {
    print('Error compiling template module.');
}

?>
PHP
}

SKIP:
{
    unless ( join( '', `php --version 2>&1` ) =~ m/^php/i ) {
        skip "Can't find executable file: php",
            1 * blocks('expected_dynamic');
    }

    run {
        my $block = shift;

    SKIP:
        {
            skip $block->skip, 1 if $block->skip;

            open2( my $php_in, my $php_out, 'php -q' );
            print $php_out &php_test_script( _unescape( $block->template ),
                $block->text );
            close $php_out;
            my $php_result = do { local $/; <$php_in> };
            $php_result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;

            my $name = $block->name . ' - dynamic';
            is( $php_result, _unescape( $block->expected ), $name );
        }
    };
}

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
