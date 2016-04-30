#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib t/lib);

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

BEGIN {
    use Test::More;
    eval { require Test::MockObject }
      or plan skip_all => 'Test::MockObject is not installed';
}
use Test::MockObject::Extends;

use MT;
use MT::Test qw(:db :data);
use MultiBlog;

my $app     = MT->instance;
my $request = MT::Request->instance;

my $plugin = $app->component('MultiBlog');

my $plugin_data = $app->model('plugindata')->new;
$plugin_data->plugin('MultiBlog');
my $new_blog    = $app->model('blog')->new;
$new_blog->id(9999);

### Utilities
sub is_restored {
    my ( $original, $objects, $restored, $message ) = @_;

    $plugin_data->data($original);
    MultiBlog::post_restore( $plugin, undef, $objects, undef, undef, sub { } );
    is_deeply( $plugin_data->data, $restored, $message );
}

### Do test

is_restored(
    { rebuild_triggers => 'ri:1:entry_save', },
    {
        'MT::PluginData#1' => $plugin_data,
        'MT::Blog#1'       => $new_blog,
    },
    { rebuild_triggers => 'ri:9999:entry_save' },
    'If restoring data has a trigger for a blog.'
);

is_restored(
    { rebuild_triggers => 'ri:1:entry_save', },
    {
        'MT::PluginData#1' => $plugin_data,
        'MT::Website#1'    => $new_blog,
    },
    { rebuild_triggers => 'ri:9999:entry_save' },
    'If restoring data has a trigger for a website.'
);

is_restored(
    { rebuild_triggers => 'ri:_all:entry_save', },
    {
        'MT::PluginData#1' => $plugin_data,
        'MT::Blog#1'       => $new_blog,
    },
    { rebuild_triggers => 'ri:_all:entry_save' },
    'If restoring data has a trigger for all.'
);

is_restored(
    {
        rebuild_triggers          => 'ri:_blogs_in_website:entry_save',
        blogs_in_website_triggers => { 'ri' => { 1 => 1, } },
    },
    {
        'MT::PluginData#1' => $plugin_data,
        'MT::Blog#1'       => $new_blog,
    },
    {
        rebuild_triggers          => 'ri:_blogs_in_website:entry_save',
        blogs_in_website_triggers => { 'ri' => { 9999 => 1, } },
    },
    'If restoring data has a trigger for blogs_in_website.'
);

is_restored(
    { other_triggers => { 'ri' => { 1 => 1, } }, },
    {
        'MT::PluginData#1' => $plugin_data,
        'MT::Blog#1'       => $new_blog,
    },
    { other_triggers => { 'ri' => { 9999 => 1, } }, },
    'If restoring data has a trigger for other_triggers.'
);

done_testing;
