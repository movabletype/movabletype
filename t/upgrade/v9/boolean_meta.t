use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => ['TEST_ROOT/plugins'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file('plugins/Foo/config.yaml', <<'PLUGIN');
id: foo
name: Foo
version: 0.01
object_types:
   foo: MT::Foo
PLUGIN

    $test_env->save_file('plugins/Foo/lib/MT/Foo.pm', <<'PM');
package MT::Foo;
use strict;
use warnings;
use base 'MT::Object';
__PACKAGE__->install_properties({
    column_defs => {
        id   => 'integer not null auto_increment',
        myint => 'integer meta',
        mybool => 'boolean meta',
        mybool2 => 'boolean meta',
        mybool3 => 'boolean meta',
    },
    meta        => 1,
    class_type  => 'foo',
    datasource  => 'foo',
    primary_key => 'id',
});
1;
PM
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Upgrade;

$test_env->prepare_fixture('db');

sub create_site {
    my ($column_values) = @_;
    my $site = MT::Test::Permission->make_website();
    $site->save;
    my $meta_class = $site->meta_pkg;
    $meta_class->new(blog_id => $site->id, type => 'normalize_orientation', vblob => 'ASC:1')->save;
    $meta_class->new(blog_id => $site->id, type => 'publish_empty_archive', vblob => 'ASC:0')->save;
    $meta_class->new(blog_id => $site->id, type => 'auto_rename_non_ascii', vblob => undef)->save;
    $meta_class->new(blog_id => $site->id, type => 'upload_destination', vblob => 'ASC:%s')->save;
    return $site;
}

sub create_foo {
    my $foo = MT->model('foo')->new;
    $foo->save;
    my $meta_class = $foo->meta_pkg;
    $meta_class->new(foo_id => $foo->id, type => 'myint', vinteger => 10)->save;
    $meta_class->new(foo_id => $foo->id, type => 'mybool', vblob => 'ASC:1')->save;
    $meta_class->new(foo_id => $foo->id, type => 'mybool2', vblob => 'ASC:0')->save;
    $meta_class->new(foo_id => $foo->id, type => 'mybool3', vblob => undef)->save;
    return $foo;
}

subtest 'upgrade' => sub {
    subtest 'A site object should migrate successfully' => sub {
        my $site = create_site();

        $site->meta_obj->load_objects;
        is $site->meta_obj->{__objects}{normalize_orientation}->vblob => 'ASC:1', "normalize_orientation has a vblob value";
        is $site->meta_obj->{__objects}{publish_empty_archive}->vblob => 'ASC:0', "publish_empty_archive has a vblob value";
        is $site->meta_obj->{__objects}{auto_rename_non_ascii}->vblob => undef, "auto_rename_non_ascii has a vblob value";
        is $site->meta_obj->{__objects}{upload_destination}->vblob => 'ASC:%s', "upload_destination has a vblob value";

        my $foo = create_foo();
        $foo->meta_obj->load_objects;
        is $foo->meta_obj->{__objects}{myint}->vinteger => 10, "myint has a vinteger value";
        is $foo->meta_obj->{__objects}{mybool}->vblob => 'ASC:1', "mybool has a vblob value";
        is $foo->meta_obj->{__objects}{mybool2}->vblob => 'ASC:0', "mybool2 has a vblob value";
        is $foo->meta_obj->{__objects}{mybool3}->vblob => undef, "mybool3 has a vblob value";
        is $foo->myint => 10, "correct myint";
        is $foo->mybool => 1, "correct mybool";
        is $foo->mybool2 => 0, "correct mybool2";
        is $foo->mybool3 => undef, "correct mybool2";

        MT::Test::Upgrade->upgrade(from => 8.0000);

        $test_env->clear_mt_cache;

        $site->init_meta;
        $site->meta_obj->load_objects;
        is $site->meta_obj->{__objects}{normalize_orientation}->vinteger => 1, "normalize_orientation has a vinteger value";
        is $site->meta_obj->{__objects}{publish_empty_archive}->vinteger => 0, "publish_empty_archive has a vinteger value";
        is $site->meta_obj->{__objects}{auto_rename_non_ascii}->vinteger => undef, "auto_rename_non_ascii has a vinteger value";
        is $site->meta_obj->{__objects}{upload_destination}->vclob => '%s', "upload_destination has a vclob value";
        is $site->normalize_orientation => 1, "correct normalize_orientation";
        is $site->publish_empty_archive => 0, "correct publish_empty_archive";
        is $site->auto_rename_non_ascii => undef, "correct auto_rename_non_ascii";
        is $site->upload_destination => '%s', "correct upload_destination";

        $foo->init_meta;
        $foo->meta_obj->load_objects;
        is $foo->meta_obj->{__objects}{myint}->vinteger => 10, "myint has a vinteger value";
        is $foo->meta_obj->{__objects}{mybool}->vblob => 'ASC:1', "mybool has a vblob value";
        is $foo->meta_obj->{__objects}{mybool2}->vblob => 'ASC:0', "mybool2 has a vblob value";
        is $foo->meta_obj->{__objects}{mybool3}->vblob => undef, "mybool3 has a vblob value";
        is $foo->myint => 10, "correct myint";
        is $foo->mybool => 1, "correct mybool";
        is $foo->mybool2 => 0, "correct mybool2";
        is $foo->mybool3 => undef, "correct mybool3";

        $site->remove;
        $foo->remove;
    };

    subtest 'Site data that has already been migrated should not change when re-applied' => sub {
        my $site = create_site();

        $site->meta_obj->load_objects;
        is $site->meta_obj->{__objects}{normalize_orientation}->vblob => 'ASC:1', "normalize_orientation has a vblob value";
        is $site->meta_obj->{__objects}{upload_destination}->vblob => 'ASC:%s', "upload_destination has a vblob value";

        my $foo = create_foo();
        $foo->meta_obj->load_objects;
        is $foo->meta_obj->{__objects}{myint}->vinteger => 10, "myint has a vinteger value";
        is $foo->meta_obj->{__objects}{mybool}->vblob => 'ASC:1', "mybool has a vblob value";
        is $foo->myint => 10, "correct myint";
        is $foo->mybool => 1, "correct mybool";

        MT::Test::Upgrade->upgrade(from => 8.0000);
        MT::Test::Upgrade->upgrade(from => 8.0000);

        $test_env->clear_mt_cache;

        $site->init_meta;
        $site->meta_obj->load_objects;
        is $site->meta_obj->{__objects}{normalize_orientation}->vinteger => 1, "normalize_orientation has a vinteger value";
        is $site->meta_obj->{__objects}{upload_destination}->vclob => '%s', "upload_destination has a vclob value";
        is $site->normalize_orientation => 1, "correct normalize_orientation";
        is $site->upload_destination => '%s', "correct upload_destination";

        $foo->init_meta;
        $foo->meta_obj->load_objects;
        is $foo->meta_obj->{__objects}{myint}->vinteger => 10, "myint has a vinteger value";
        is $foo->meta_obj->{__objects}{mybool}->vblob => 'ASC:1', "mybool has a vblob value";
        is $foo->myint => 10, "correct myint";
        is $foo->mybool => 1, "correct mybool";

        $site->remove;
        $foo->remove;
    };
};

done_testing;
