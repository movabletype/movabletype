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

use MT::Test qw( :app :db );

use IPC::Open2;

plan tests => 2 * blocks;

use MT;
my $app = MT->instance;

filters {
    text      => [qw( chomp )],
    textile_2 => [qw( chomp )],
};

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
