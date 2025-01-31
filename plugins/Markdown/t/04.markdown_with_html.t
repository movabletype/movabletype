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

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $ct = MT::Test::Permission->make_content_type(
            blog_id => 1,
            name    => 'test content type',
        );

        my $cf = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'multi line text',
            type            => 'multi_line_text',
        );

        my $fields = [
            {   id        => $cf->id,
                label     => 1,
                name      => $cf->name,
                order     => 1,
                type      => $cf->type,
                unique_id => $cf->unique_id,
            }
        ];
        $ct->fields($fields);
        $ct->save or die $ct->errstr;

        my $cd = MT::Test::Permission->make_content_data(
            blog_id         => $ct->blog_id,
            author_id       => 1,
            content_type_id => $ct->id,
            data            => { $cf->id => 'test text', },
        );

        my $tmpl_text = << "TMPL";
        <mt:Contents content_type="test content type" limit="1"><mt:ContentField content_field="multi line text"><mt:ContentFieldValue
language="ja"></mt:ContentField></mt:Contents>
TMPL

        my $tmpl = MT::Test::Permission->make_template(
            name            => 'test content type template',
            text            => $tmpl_text,
            content_type_id => $ct->id,
        );
    }
);

use IPC::Open2;

delimiters( '@@@', '---' );

use MT;
my $app = MT->instance;

filters {
    text     => [qw( chomp )],
    markdown => [qw( chomp )],
};

my $ct = $app->model('content_type')->load( { name => 'test content type' } );
my $cf = $app->model('content_field')->load( { name => 'multi line text' } );
my $cd = $app->model('content_data')->load( { content_type_id => $ct->id } );
my $ct_tmpl = $app->model('template')
    ->load( { name => 'test content type template' } );

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

            $cd->data( { $cf->id => $block->text } );
            my $convert_breaks = {};
            $convert_breaks->{ $cf->id } = $text_filter;
            $cd->convert_breaks(
                MT::Serialize->serialize( \$convert_breaks ) );
            $cd->save or die $cd->errstr;

            my $ctx2 = $ct_tmpl->context;
            $ctx2->stash( 'content', $cd );

            _ok( $ct_tmpl->build, $block->$text_filter,
                      "content data "
                    . $block->name
                    . ' text_filter:'
                    . $text_filter );

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
    print($_var_compiled);
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

