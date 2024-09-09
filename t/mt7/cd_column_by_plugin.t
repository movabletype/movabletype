use strict;
use warnings;
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

    $test_env->save_file("plugins/ContentTypeColumn/config.yaml", <<'YAML' );
name: ContentTypeColumn
schema_version: 0.01

callbacks:
  init_app: $ContentTypeColumn::ContentTypeColumn::cb_init_app
  MT::ContentData::pre_save: $ContentTypeColumn::ContentTypeColumn::cb_pre_save

object_types:
  cd:
    random: integer
YAML

    $test_env->save_file("plugins/ContentTypeColumn/lib/ContentTypeColumn.pm", <<'PM');
package ContentTypeColumn;
use strict;
use warnings;

sub cb_init_app {
    my $reg = MT->component('core')->registry('list_properties');
    for my $key ( grep {/^content_data\./} keys %$reg ) {
        my $value = $reg->{$key};
        $value->{random} = _list_prop_for_random();
    }
}

sub cb_pre_save {
    my ( $cb, $obj, $orig ) = @_;
    $obj->random( int rand(10) );
    1;
}

sub _list_prop_for_random {
    {   base    => '__virtual.integer',
        col     => 'random',
        display => 'force',
        label   => 'Random',
        raw     => sub {
            my ( $prop, $obj ) = @_;
            $obj->random // -1;
        },
    };
}

1;
PM
}

$test_env->prepare_fixture('content_data');

# MTC-25513
ok my $cd = MT->model('cd')->load(1);
ok $cd->has_column('random'), "has random column";
like $cd->random => qr/^[0-9]+$/, "random column value looks like a number";

done_testing;
