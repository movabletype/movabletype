#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use Test::More;
use MT::Test::Env;
use Test::Requires qw/Test::Base/;

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use utf8;
use Encode;
use MT::Test 'has_php';
use MT::Test::Permission;

$test_env->prepare_fixture('db');

use IPC::Open2;

delimiters( '@@@', '---' );

use MT;
my $app = MT->instance;

filters {
    text     => [qw( chomp )],
    markdown => [qw( chomp )],
};

sub _ok {
    my ( $got, $expected, $message ) = @_;
    $got =~ s/(\r\n|\r|\n)+\z//g;
    $got = decode_utf8($got) unless Encode::is_utf8($got);
    is( $got, $expected, $message );
}

run {
    my $block = shift;

    my $template = '<mt:EntryBody />';
    my $tmpl     = $app->model('template')->new;
    $tmpl->text($template);
    my $ctx = $tmpl->context;

    my $entry = $app->model('entry')->new;
    $entry->text( $block->text );
    $ctx->stash( 'entry', $entry );

    for my $text_filter ('markdown') {
    TODO: {
            local $TODO = $block->TODO if $block->TODO;
            $entry->convert_breaks($text_filter);
            _ok( $tmpl->build, $block->$text_filter,
                $block->name . ' text_filter:' . $text_filter );
        }
    }
};

sub php_test_script {
    my ( $template, $text, $text_filter ) = @_;
    $text ||= '';
    my $test_script = <<PHP;
<?php
\$MT_HOME   = '@{[ $ENV{MT_HOME} ? $ENV{MT_HOME} : '.' ]}';
\$MT_CONFIG = '@{[ $app->find_config ]}';
\$tmpl = <<<__TMPL__
$template
__TMPL__
;
\$text = <<<__TMPL__
$text
__TMPL__
;
\$text_filter = '$text_filter';
PHP
    $test_script .= <<'PHP';
include_once($MT_HOME . '/php/mt.php');
include_once($MT_HOME . '/php/lib/MTUtil.php');

$mt = MT::get_instance(1, $MT_CONFIG);

$mt = MT::get_instance(1);
$mt->init_plugins();
$ctx =& $mt->context();

$entry = new StdClass();
$entry->entry_text = $text;
$entry->entry_convert_breaks = $text_filter;
$ctx->stash('entry', $entry);

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
    unless ( has_php() ) {
        skip "Can't find executable file: php", 1 * blocks();
    }

    run {
        my $block    = shift;
        my $template = '<mt:EntryBody />';

        for my $text_filter ('markdown') {
        TODO: {
                local $TODO = $block->TODO if $block->TODO;
                open2( my $php_in, my $php_out, 'php -q' );
                my $output = php_test_script( $template, $block->text,
                    $text_filter );
                print $php_out encode_utf8($output);
                close $php_out;
                my $php_result = do { local $/; <$php_in> };
                _ok( $php_result, $block->$text_filter,
                          $block->name
                        . ' text_filter:'
                        . $text_filter
                        . ' - dynamic' );
            }
        }
    };
}

done_testing;

__END__

@@@ FEEDBACK-1463
--- text
# title

<blockquote>
quote
</blockquote>

## foo

hello

<blockquote>
another quote
</blockquote>

## bar

again
--- markdown
<h1>title</h1>

<blockquote>
quote
</blockquote>

<h2>foo</h2>

<p>hello</p>

<blockquote>
another quote
</blockquote>

<h2>bar</h2>

<p>again</p>

@@@ MTC-26823
--- text
- List1-1
- List1-2
- List1-3

テストテスト[リンク](https://www.movabletype.jp/)テストテスト

- List2-1
- List2-2
- List2-3
--- markdown
<ul>
<li>List1-1</li>
<li>List1-2</li>
<li>List1-3</li>
</ul>

<p>テストテスト<a href="https://www.movabletype.jp/">リンク</a>テストテスト</p>

<ul>
<li>List2-1</li>
<li>List2-2</li>
<li>List2-3</li>
</ul>

