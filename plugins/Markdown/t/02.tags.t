#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test qw( :app :db );

use IPC::Open2;

use Test::Base;
plan tests => blocks() + blocks('php');

use MT;
my $app = MT->instance;

filters {
    text     => [qw( chomp )],
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

run {
    my $block = shift;

    my $tmpl = $app->model('template')->new;
    $tmpl->text( $block->template );
    my $ctx = $tmpl->context;

    if ( $block->text ) {
        my $entry = $app->model('entry')->new;
        $entry->text( $block->text );
        $entry->convert_breaks('markdown');

        $ctx->stash( 'entry', $entry );
    }

    my $result = $tmpl->build;
    $result =~ s/(\r\n|\r|\n)+\z//g;

    if ( ref( $block->expected ) eq 'Regexp' ) {
        like( $result, $block->expected, $block->name );
    }
    else {
        is( $result, $block->expected, $block->name );
    }
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

$mt = MT::get_instance(1);
$mt->init_plugins();
$ctx =& $mt->context();

$entry = new StdClass();
$entry->entry_text = $text;
$entry->entry_convert_breaks = 'markdown';
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
        skip "Can't find executable file: php", 1 * blocks('php');
    }

    run {
        my $block = shift;
        return unless $block->php;

        open2( my $php_in, my $php_out, 'php -q' );
        print $php_out &php_test_script( $block->template, $block->text );
        close $php_out;
        my $php_result = do { local $/; <$php_in> };
        $php_result =~ s/(\r\n|\r|\n)+\z//g;

        my $name = $block->name . ' - dynamic';
        if ( ref( $block->expected ) eq 'Regexp' ) {
            like( $php_result, $block->expected, $name );
        }
        else {
            is( $php_result, $block->expected, $name );
        }
    };
}

__END__

=== MarkdownOptions with no option
--- text
![Image](/images/sample.jpg "Title")
--- template
<mt:MarkdownOptions>
<mt:EntryBody />
</mt:MarkdownOptions>
--- expected
<p><img src="/images/sample.jpg" alt="Image" title="Title" /></p>


=== MarkdownOptions with output="html"
--- text
![Image](/images/sample.jpg "Title")
--- template
<mt:MarkdownOptions output="html">
<mt:EntryBody />
</mt:MarkdownOptions>
--- expected
<p><img src="/images/sample.jpg" alt="Image" title="Title"></p>


=== MarkdownOptions with output="xml"
--- text
![Image](/images/sample.jpg "Title")
--- template
<mt:MarkdownOptions output="xml">
<mt:EntryBody />
</mt:MarkdownOptions>
--- expected
<p><img src="/images/sample.jpg" alt="Image" title="Title" /></p>


=== MarkdownOptions with output="raw"
--- text
![Image](/images/sample.jpg "Title")
--- template
<mt:MarkdownOptions output="raw">
<mt:EntryBody />
</mt:MarkdownOptions>
--- expected
![Image](/images/sample.jpg "Title")


=== SmartyPantsVersion
--- template
<mt:SmartyPantsVersion />
--- expected regexp
\A\d+\.\d+\.\d+\z
--- php
yes


=== smarty_pants
--- template
<mt:Unless smarty_pants="1">"foo"</mt:Unless>
--- expected
&#8220;foo&#8221;


=== smart_quotes
--- template
<mt:Unless smart_quotes="1">"foo"</mt:Unless>
--- expected
&#8220;foo&#8221;


=== smart_dashes
--- template
<mt:Unless smart_dashes="1">--foo--</mt:Unless>
--- expected
&#8212;foo&#8212;


=== smart_ellipses
--- template
<mt:Unless smart_ellipses="1">foo...</mt:Unless>
--- expected
foo&#8230;
