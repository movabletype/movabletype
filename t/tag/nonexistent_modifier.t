use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => [qw(
            MT_HOME/plugins
            MT_HOME/t/plugins
            TEST_ROOT/plugins
        )]
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    my $config_yaml = 'plugins/TestTextFilter/config.yaml';
    $test_env->save_file( $config_yaml, <<'YAML' );
id: TestTextFilter
name: TestTextFilter
text_filters:
    nonexistent:
        label: 'vacuum'
YAML
}

use MT::Test::Tag;
plan tests => 2 * blocks;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

$test_env->prepare_fixture('db_data');

for my $entry ( MT::Entry->load ) {
    $entry->convert_breaks('nonexistent');
    $entry->save;
}

# Silence "Bad text filter" warnings
local $SIG{__WARN__} = sub {};
MT::Test::Tag->run_perl_tests($blog_id);

MT::Test::Tag->run_php_tests($blog_id);

__DATA__

=== nonexistent modifier
--- template
Head
<mt:Entries><mt:EntryBody filter="nonexistent"></mt:Entries>
Foot
--- expected
Head
On a drizzly day last weekend,The weight of this sad time we must obey,
Speak what we feel, not what we ought to say.
The oldest hath borne most: we that are young
Shall never see so much, nor live so long.The Devil hath power
To assume a pleasing shape.Me, poor man, my library
Was dukedom large enough.Look like the innocent flower,
But be the serpent under it.
Foot
