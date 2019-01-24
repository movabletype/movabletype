#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval qq{ use Test::Base; 1 }
        or plan skip_all => 'Test::Base is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

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
        <mt:Contents content_type="test content type" limit="1"><mt:ContentField content_field="multi line text"><mt:ContentFieldValue language="ja"></mt:ContentField></mt:Contents>
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

sub decode_entities {
    my ($str) = @_;
    $str =~ s/&#x([0-9a-f]+);/chr(hex($1))/ige;
    $str =~ s/&#([0-9]+);/chr($1)/ige;
    $str;
}

filters {
    text                      => [qw( chomp )],
    markdown                  => [qw( chomp )],
    markdown_with_smartypants => [qw( chomp )],
};

my $ct = $app->model('content_type')->load( { name => 'test content type' } );
my $cf = $app->model('content_field')->load( { name => 'multi line text' } );
my $cd = $app->model('content_data')->load( { content_type_id => $ct->id } );
my $ct_tmpl = $app->model('template')
    ->load( { name => 'test content type template' } );

run {
    my $block = shift;

    my $template = '<mt:EntryBody />';
    my $tmpl     = $app->model('template')->new;
    $tmpl->text($template);
    my $ctx = $tmpl->context;

    my $entry = $app->model('entry')->new;
    $entry->text( $block->text );
    $ctx->stash( 'entry', $entry );

    for my $text_filter ( 'markdown', 'markdown_with_smartypants' ) {
        $entry->convert_breaks($text_filter);
        my $result = $tmpl->build;
        $result =~ s/(\r\n|\r|\n)+\z//g;
        if ( my $unlike = $block->decode_entities ) {
            chomp($unlike);
            unlike( $result, qr/$unlike/, "unlike: $unlike" );
            $result = decode_entities($result);
        }
        is( $result, $block->$text_filter,
            $block->name . ' text_filter:' . $text_filter );

        $cd->data( { $cf->id => $block->text } );
        my $convert_breaks = {};
        $convert_breaks->{ $cf->id } = $text_filter;
        $cd->convert_breaks( MT::Serialize->serialize( \$convert_breaks ) );
        $cd->save or die $cd->errstr;

        my $ctx2 = $ct_tmpl->context;
        $ctx2->stash( 'content', $cd );

        my $result2 = $ct_tmpl->build;
        $result2 =~ s/(\r\n|\r|\n)+\z//g;
        if ( my $unlike = $block->decode_entities ) {
            chomp($unlike);
            unlike( $result2, qr/$unlike/, "unlike: $unlike" );
            $result2 = decode_entities($result2);
        }
        is( $result2, $block->$text_filter, "content data " . $block->name . ' text_filter:' . $text_filter );

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
    unless ( join( '', `php --version 2>&1` ) =~ m/^php/i ) {
        skip "Can't find executable file: php",
            2 * blocks() + 2 * blocks('decode_entities');
    }

    run {
        my $block    = shift;
        my $template = '<mt:EntryBody />';

        for my $text_filter ( 'markdown', 'markdown_with_smartypants' ) {
        SKIP: {
                open2( my $php_in, my $php_out, 'php -q' );
                print $php_out &php_test_script( $template, $block->text,
                    $text_filter );
                close $php_out;
                my $php_result = do { local $/; <$php_in> };
                $php_result =~ s/(\r\n|\r|\n)+\z//g;
                if ( my $unlike = $block->decode_entities ) {
                    chomp($unlike);
                    unlike( $php_result, qr/$unlike/, "unlike: $unlike" );
                    $php_result = decode_entities($php_result);
                }
                is( $php_result, $block->$text_filter,
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

@@@ Header(#)
--- text
# --foo--
--- markdown
<h1>--foo--</h1>
--- markdown_with_smartypants
<h1>&#8212;foo&#8212;</h1>


@@@ Header(_)
--- text
foo
---
--- markdown
<h2>foo</h2>
--- markdown_with_smartypants
<h2>foo</h2>


@@@ Header(=)
--- text
foo
===
--- markdown
<h1>foo</h1>
--- markdown_with_smartypants
<h1>foo</h1>


@@@ List(*)
--- text
* foo
* bar
--- markdown
<ul>
<li>foo</li>
<li>bar</li>
</ul>
--- markdown_with_smartypants
<ul>
<li>foo</li>
<li>bar</li>
</ul>


@@@ List(+)
--- text
+ foo
+ bar
--- markdown
<ul>
<li>foo</li>
<li>bar</li>
</ul>
--- markdown_with_smartypants
<ul>
<li>foo</li>
<li>bar</li>
</ul>


@@@ List(-)
--- text
- foo
- bar
--- markdown
<ul>
<li>foo</li>
<li>bar</li>
</ul>
--- markdown_with_smartypants
<ul>
<li>foo</li>
<li>bar</li>
</ul>


@@@ Code Block
--- text
    foo
    bar
--- markdown
<pre><code>foo
bar
</code></pre>
--- markdown_with_smartypants
<pre><code>foo
bar
</code></pre>


@@@ Line(*)
--- text
***
--- markdown
<hr />
--- markdown_with_smartypants
<hr />


@@@ Line(-)
--- text
---
--- markdown
<hr />
--- markdown_with_smartypants
<hr />


@@@ Link
--- text
[foo](http://example.com/ "bar")
--- markdown
<p><a href="http://example.com/" title="bar">foo</a></p>
--- markdown_with_smartypants
<p><a href="http://example.com/" title="bar">foo</a></p>


@@@ Emphasis(*)
--- text
*foo*
--- markdown
<p><em>foo</em></p>
--- markdown_with_smartypants
<p><em>foo</em></p>


@@@ Emphasis(_)
--- text
_foo_
--- markdown
<p><em>foo</em></p>
--- markdown_with_smartypants
<p><em>foo</em></p>


@@@ Strong(*)
--- text
**foo**
--- markdown
<p><strong>foo</strong></p>
--- markdown_with_smartypants
<p><strong>foo</strong></p>


@@@ Strong(_)
--- text
__foo__
--- markdown
<p><strong>foo</strong></p>
--- markdown_with_smartypants
<p><strong>foo</strong></p>


@@@ Code
--- text
`foo`
--- markdown
<p><code>foo</code></p>
--- markdown_with_smartypants
<p><code>foo</code></p>


@@@ Image
--- text
![foo](/images/sample.jpg "bar")
--- markdown
<p><img src="/images/sample.jpg" alt="foo" title="bar" /></p>
--- markdown_with_smartypants
<p><img src="/images/sample.jpg" alt="foo" title="bar" /></p>


@@@ TextLink
--- text
<http://example.com/>
--- markdown
<p><a href="http://example.com/">http://example.com/</a></p>
--- markdown_with_smartypants
<p><a href="http://example.com/">http://example.com/</a></p>


@@@ MailLink
--- text
<address@example.com>
--- markdown
<p><a href="mailto:address@example.com">address@example.com</a></p>
--- markdown_with_smartypants
<p><a href="mailto:address@example.com">address@example.com</a></p>
--- decode_entities
address@example.com
