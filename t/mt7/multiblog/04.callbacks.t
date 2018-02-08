#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use Test::More;

BEGIN {
    eval { require Test::MockObject }
        or plan skip_all => 'Test::MockObject is not installed';
}

use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Test::MockObject::Extends;

use MT;
use MT::Test;

$test_env->prepare_fixture('db_data');

#require MultiBlog;
use MT::RebuildTrigger;

my $app     = MT->instance;
my $request = MT::Request->instance;

my $rebuild_trigger = MT::RebuildTrigger->new();
my $new_blog        = $app->model('blog')->new;
$new_blog->id(9999);

### Utilities
sub is_restored {
    my ( $original, $objects, $restored, $message ) = @_;

    my $old_blog_id
        = $original->{target} == MT::RebuildTrigger::TARGET_BLOG() ? 1 : 0;
    $rebuild_trigger->blog_id($old_blog_id);
    foreach my $key (qw/ action target target_blog_id object_type event /) {
        $rebuild_trigger->$key( $original->{$key} );
    }
    $rebuild_trigger->save;
    MT::RebuildTrigger->post_restore( $objects, undef, undef, sub { } );
    my $new_blog_id
        = $original->{target} == MT::RebuildTrigger::TARGET_BLOG()
        ? $restored->{target_blog_id}
        : 0;
    my $rebuild_trigger_restored
        = MT::RebuildTrigger->load( { blog_id => $new_blog_id } );
    my $data = {};
    foreach my $key (qw/ action target target_blog_id object_type event /) {
        $data->{$key} = $rebuild_trigger_restored->$key;
    }
    is_deeply( $data, $restored, $message );
}

### Do test

is_restored(
    {   action         => MT::RebuildTrigger::ACTION_RI(),
        target         => MT::RebuildTrigger::TARGET_BLOG(),
        target_blog_id => 1,
        object_type    => MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE(),
        event          => MT::RebuildTrigger::EVENT_SAVE(),
    },
    {   'MT::RebuildTrigger#1' => $rebuild_trigger,
        'MT::Blog#1'           => $new_blog,
    },
    {   action         => MT::RebuildTrigger::ACTION_RI(),
        target         => MT::RebuildTrigger::TARGET_BLOG(),
        target_blog_id => 9999,
        object_type    => MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE(),
        event          => MT::RebuildTrigger::EVENT_SAVE(),
    },
    'If restoring data has a trigger for a blog.'
);

is_restored(
    {   action         => MT::RebuildTrigger::ACTION_RI(),
        target         => MT::RebuildTrigger::TARGET_BLOG(),
        target_blog_id => 1,
        object_type    => MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE(),
        event          => MT::RebuildTrigger::EVENT_SAVE(),
    },
    {   'MT::RebuildTrigger#1' => $rebuild_trigger,
        'MT::Website#1'        => $new_blog,
    },
    {   action         => MT::RebuildTrigger::ACTION_RI(),
        target         => MT::RebuildTrigger::TARGET_BLOG(),
        target_blog_id => 9999,
        object_type    => MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE(),
        event          => MT::RebuildTrigger::EVENT_SAVE(),
    },
    'If restoring data has a trigger for a website.'
);

is_restored(
    {   action         => MT::RebuildTrigger::ACTION_RI(),
        target         => MT::RebuildTrigger::TARGET_ALL(),
        target_blog_id => 0,
        object_type    => MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE(),
        event          => MT::RebuildTrigger::EVENT_SAVE(),
    },
    {   'MT::RebuildTrigger#1' => $rebuild_trigger,
        'MT::Blog#1'           => $new_blog,
    },
    {   action         => MT::RebuildTrigger::ACTION_RI(),
        target         => MT::RebuildTrigger::TARGET_ALL(),
        target_blog_id => 0,
        object_type    => MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE(),
        event          => MT::RebuildTrigger::EVENT_SAVE(),
    },
    'If restoring data has a trigger for all.'
);

is_restored(
    {   action         => MT::RebuildTrigger::ACTION_RI(),
        target         => MT::RebuildTrigger::TARGET_BLOGS_IN_WEBSITE(),
        target_blog_id => 1,
        object_type    => MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE(),
        event          => MT::RebuildTrigger::EVENT_SAVE(),
    },
    {   'MT::RebuildTrigger#1' => $rebuild_trigger,
        'MT::Blog#1'           => $new_blog,
    },
    {   action         => MT::RebuildTrigger::ACTION_RI(),
        target         => MT::RebuildTrigger::TARGET_BLOGS_IN_WEBSITE(),
        target_blog_id => 9999,
        object_type    => MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE(),
        event          => MT::RebuildTrigger::EVENT_SAVE(),
    },
    'If restoring data has a trigger for blogs_in_website.'
);

is_restored(
    {   action         => MT::RebuildTrigger::ACTION_RI(),
        target         => MT::RebuildTrigger::TARGET_BLOG(),
        target_blog_id => 1,
        object_type    => MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE(),
        event          => MT::RebuildTrigger::EVENT_SAVE(),
    },
    {   'MT::RebuildTrigger#1' => $rebuild_trigger,
        'MT::Blog#1'           => $new_blog,
    },
    {   action         => MT::RebuildTrigger::ACTION_RI(),
        target         => MT::RebuildTrigger::TARGET_BLOG(),
        target_blog_id => 9999,
        object_type    => MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE(),
        event          => MT::RebuildTrigger::EVENT_SAVE(),
    },
    'If restoring data has a trigger for other_triggers.'
);

done_testing;
