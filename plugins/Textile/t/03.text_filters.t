#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
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
        my $convert_breaks = {};
        $convert_breaks->{ $cf->id } = 'textile_2';
        $cd->convert_breaks( MT::Serialize->serialize( \$convert_breaks ) );

        $cd->save or die $cd->errstr;

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

use MT;
my $app = MT->instance;

filters {
    text      => [qw( chomp )],
    textile_2 => [qw( chomp )],
};
my $ct = $app->model('content_type')->load( { name => 'test content type' } );
my $cf = $app->model('content_field')->load( { name => 'multi line text' } );
my $cd = $app->model('content_data')->load( { content_type_id => $ct->id } );
my $ct_tmpl = $app->model('template')
    ->load( { name => 'test content type template' } );
run {
    my $block = shift;

    my $tmpl = $app->model('template')->new;
    $tmpl->text('<mt:EntryBody />');
    my $ctx = $tmpl->context;

    my $entry = $app->model('entry')->new;
    $entry->text( $block->text );
    $ctx->stash( 'entry', $entry );

    $entry->convert_breaks('textile_2');
    my $result = $tmpl->build;
    $result =~ s/(\r\n|\r|\n)+\z//g;
    is( $result, $block->textile_2, $block->name );

    $cd->data( { $cf->id => $block->text } );
    $cd->save or die $cd->errstr;
    my $ctx2 = $ct_tmpl->context;
    $ctx2->stash( 'content', $cd );

    my $result2 = $ct_tmpl->build;
    $result2 =~ s/(\r\n|\r|\n)+\z//g;
    is( $result2, $block->textile_2, "content data " . $block->name );

};

sub php_test_script {
    my ( $template, $text ) = @_;
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
PHP
    $test_script .= <<'PHP';
include_once($MT_HOME . '/php/mt.php');
include_once($MT_HOME . '/php/lib/MTUtil.php');

$mt = MT::get_instance(1, $MT_CONFIG);
$mt->init_plugins();
$ctx =& $mt->context();

$entry = new StdClass();
$entry->entry_text = $text;
$entry->entry_convert_breaks = 'textile_2';
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
        skip "Can't find executable file: php", 1 * blocks;
    }

    run {
        my $block = shift;

        open2( my $php_in, my $php_out, 'php -q' );
        print $php_out &php_test_script( '<mt:EntryBody />', $block->text );
        close $php_out;
        my $php_result = do { local $/; <$php_in> };
        $php_result =~ s/(\r\n|\r|\n)+\z//g;
        is( $php_result, $block->textile_2, $block->name . ' - dynamic' );
    };
}
done_testing;


__END__

=== Strong
--- text
*foo*
--- textile_2
<p><strong>foo</strong></p>


=== Emphasis
--- text
_bar_
--- textile_2
<p><em>bar</em></p>


=== Insert
--- text
+baz+
--- textile_2
<p><ins>baz</ins></p>


=== Delete
--- text
-foo-
--- textile_2
<p><del>foo</del></p>


=== Cite
--- text
??foo??
--- textile_2
<p><cite>foo</cite></p>


=== Code
--- text
@foo@
--- textile_2
<p><code>foo</code></p>


=== Header1
--- text
h1. header
--- textile_2
<h1>header</h1>


=== Header2
--- text
h2. header
--- textile_2
<h2>header</h2>


=== Header3
--- text
h3. header
--- textile_2
<h3>header</h3>


=== Link
--- text
"Foo":http://example.com/
--- textile_2
<p><a href="http://example.com/">Foo</a></p>


=== Table
--- text
||Col1|Col2|
|Foo|Foo-Col1|Foo-Col2|
|Bar|Bar-Col1|Bar-Col2|
--- textile_2
<table><tr><td></td><td>Col1</td><td>Col2</td></tr><tr><td>Foo</td><td>Foo-Col1</td><td>Foo-Col2</td></tr><tr><td>Bar</td><td>Bar-Col1</td><td>Bar-Col2</td></tr></table>


=== Capped
--- text
text ABC
--- textile_2
<p>text <span class="caps">ABC</span></p>


=== Capped Overlap. #112878
--- text
text <span class="caps">ABC</span>
--- textile_2
<p>text <span class="caps">ABC</span></p>
