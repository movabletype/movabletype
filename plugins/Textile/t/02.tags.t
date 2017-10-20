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

plan tests => 1 * blocks;

use MT;
my $app = MT->instance;

filters {
    template         => [qw( chomp )],
    expected         => [qw( chomp )],
    expected_dynamic => [qw( chomp )],
};

run {
    my $block = shift;

    if ( $block->expected ) {
        my $tmpl = $app->model('template')->new;
        $tmpl->text( $block->template );
        my $ctx = $tmpl->context;

        my $result = $tmpl->build;
        $result =~ s/(\r\n|\r|\n)+\z//g;

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
$mt->init_plugins();
$ctx =& $mt->context();

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

        if ( $block->expected_dynamic ) {
            open2( my $php_in, my $php_out, 'php -q' );
            print $php_out &php_test_script( $block->template, $block->text );
            close $php_out;
            my $php_result = do { local $/; <$php_in> };
            $php_result =~ s/(\r\n|\r|\n)+\z//g;

            my $name = $block->name . ' - dynamic';
            is( $php_result, $block->expected_dynamic, $name );
        }
    };
}

__END__

=== Textile
--- template
<mt:Textile>
*foo*
_bar_
+baz+
</mt:Textile>
--- expected
<p><strong>foo</strong><br />
<em>bar</em><br />
<ins>baz</ins></p>


=== Textile
--- template
<mt:Unless textile_2="1">
*foo*
_bar_
+baz+
</mt:Unless>
--- expected_dynamic
<p><strong>foo</strong><br />
<em>bar</em><br />
<ins>baz</ins></p>


=== TextileOptions flavor="html"
--- template
<mt:Textile>
<mt:TextileOptions flavor="html" />
foo
bar
baz
</mt:Textile>
--- expected
<p>foo<br>
bar<br>
baz</p>


=== TextileOptions flavor="xml"
--- template
<mt:Textile>
<mt:TextileOptions flavor="xml" />
foo
bar
baz
</mt:Textile>
--- expected
<p>foo<br />
bar<br />
baz</p>


=== TextileHeadOffset start="0"
--- template
<mt:Textile>
<mt:TextileHeadOffset start="0">
h1. Header
</mt:Textile>
--- expected
<h1>Header</h1>


=== TextileHeadOffset start="1"
--- template
<mt:Textile>
<mt:TextileHeadOffset start="1">
h1. Header
</mt:Textile>
--- expected
<h2>Header</h2>


=== TextileHeadOffset start="2"
--- template
<mt:Textile>
<mt:TextileHeadOffset start="2">
h1. Header
</mt:Textile>
--- expected
<h3>Header</h3>
