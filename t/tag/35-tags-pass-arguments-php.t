#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval qq{ use Test::Base; 1 }
        or plan skip_all => 'Test::Base is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginSwitch => ['Textile/textile2.pl=1'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test 'has_php';

$test_env->prepare_fixture('db');

use IPC::Open2;

plan tests => 2 * blocks;

use MT;
my $app = MT->instance;

filters {
    template         => [qw( chomp )],
    expected         => [qw( chomp )],
    expected_dynamic => [qw( chomp )],
};

run {
    my $block = shift;

    {
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
    unless ( has_php() ) {
        skip "Can't find executable file: php",
            1 * blocks('expected_dynamic');
    }

    run {
        my $block = shift;

        {
            open2( my $php_in, my $php_out, 'php -q' );
            print $php_out &php_test_script( $block->template, $block->text );
            close $php_out;
            my $php_result = do { local $/; <$php_in> };
            $php_result =~ s/(\r\n|\r|\n)+\z//g;

            my $name = $block->name . ' - dynamic';
            is( $php_result, $block->expected, $name );
        }
    };
}

__END__

=== Pass hash variable
--- template
<mt:Var name="hsh" key="ky" value="hoge">
<mt:If name="hsh{ky}" eq="fuga">
fuga!
<mt:ElseIf eq="hoge">
hoge!
<mt:Else>
moga!
</mt:If>
--- expected
hoge!


=== Pass array variable
--- template
<mt:Var name="arr" index="1" value="hoge">
<mt:If name="arr[1]" eq="fuga">
fuga!
<mt:ElseIf eq="hoge">
hoge!
<mt:Else>
moga!
</mt:If>
--- expected
hoge!


=== Pass primitive variable
--- template
<mt:Var name="normal" value="hoge">
<mt:If name="normal" eq="fuga">
fuga!
<mt:ElseIf eq="hoge">
hoge!
<mt:Else>
moga!
</mt:If>
--- expected
hoge!
