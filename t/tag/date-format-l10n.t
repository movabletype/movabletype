use strict;
use warnings;
use utf8;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => ['TEST_ROOT/plugins'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file("plugins/LanguageXX/config.yaml", <<'PLUGIN_YAML' );
name: LanguageXX

callbacks:
  init_app: $LanguageXX::LanguageXX::cb_init_app
PLUGIN_YAML

    $test_env->save_file("plugins/LanguageXX/lib/LanguageXX.pm", <<'PLUGIN_PERL');
package LanguageXX;
use strict;
use warnings;
use utf8;
use MT::Util;

sub cb_init_app {
    $MT::Util::Languages{xx} = [
        ['nichi', 'getsu', 'ka', 'sui', 'moku', 'kin', 'do'],
        ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
        ['gozen', 'gogo'],
        '%Y nen %b gatsu %e nichi %H:%M',
        '%Y nen %b gatsu %e nichi',
        '%H:%M',
        '%Y nen %b gatsu',
        '%b gatsu %e nichi'
    ];
}

1;
PLUGIN_PERL

    $test_env->save_file("plugins/LanguageXX/php/init.LanguageXX.php", <<'PLUGIN_PHP');
<?php
global $Languages;

$Languages['xx'] = [
    ['nichi', 'getsu', 'ka', 'sui', 'moku', 'kin', 'do'],
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
    ['gozen', 'gogo'],
    '%Y nen %b gatsu %e nichi %H:%M',
    '%Y nen %b gatsu %e nichi',
    '%H:%M',
    '%Y nen %b gatsu',
    '%b gatsu %e nichi'
];
PLUGIN_PHP
}

use MT::Test::Tag;
use MT::Test::PHP;
use MT::Test::Permission;

$test_env->prepare_fixture('db');

my $blog_id = 1;
my $entry1  = MT::Test::Permission->make_entry(
    blog_id     => $blog_id,
    authored_on => '19780131074500',
    title       => 'entry1',
);

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

done_testing;

__DATA__

=== date format for jp
--- template
<MTEntries lastn='1'><MTEntryDate language="jp"></MTEntries>
--- expected
1978年1月31日 07:45

=== date format for ja
--- template
<MTEntries lastn='1'><MTEntryDate language="ja"></MTEntries>
--- expected
1978年1月31日 07:45

=== date format for xx
--- template
<MTEntries lastn='1'><MTEntryDate language="xx"></MTEntries>
--- expected
1978 nen 1 gatsu 31 nichi 07:45
