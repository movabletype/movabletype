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
use MT::Test::Permission;

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $site
            = MT::Test::Permission->make_website( name => 'test website' );

        my $blog = MT::Test::Permission->make_blog(
            parent_id => $site->id,
            name      => 'test blog'
        );

        my $ct = MT::Test::Permission->make_content_type(
            blog_id => $blog->id,
            name    => 'test content type',
        );

        my $cf = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'single text',
            type            => 'single_line_text',
        );

        my $fields = [
            {   id        => $cf->id,
                label     => 1,
                name      => $cf->name,
                order     => 1,
                type      => $cf->type,
                unique_id => $cf->unique_id,
            }
        ];
        $ct->fields($fields);
        $ct->save or die $ct->errstr;

        my $cd = MT::Test::Permission->make_content_data(
            blog_id         => $ct->blog_id,
            author_id       => 1,
            content_type_id => $ct->id,
            data            => { $cf->id => 'test text' },
        );
    }
);

my $site = MT->model('website')->load( { name => 'test website' } );
my $blog = MT->model('blog')->load( { name => 'test blog' } );
my $ct = MT->model('content_type')->load( { name => 'test content type' } );

require MT::RebuildTrigger;

my $app     = MT->instance;
my $request = MT::Request->instance;

### register triggers
my $rt = MT::RebuildTrigger->new;
$rt->blog_id( $site->id );
$rt->object_type( MT::RebuildTrigger::TYPE_CONTENT_TYPE() );
$rt->action( MT::RebuildTrigger::ACTION_RI() );
$rt->event( MT::RebuildTrigger::EVENT_PUBLISH() );
$rt->target( MT::RebuildTrigger::TARGET_BLOGS_IN_WEBSITE() );
$rt->target_blog_id(0);
$rt->ct_id( $ct->id );
$rt->save;

### initialize mock
my $rebuild_count = 0;

$app = Test::MockObject::Extends->new($app);
$app->mock(
    'rebuild_indexes',
    sub {
        $rebuild_count++;
    }
);

### Utilities
sub clear_cache {
    $rebuild_count = 0;
    $request->{__stash} = {};
}

sub run_test(&) {
    &clear_cache;
    $_[0]->();
}

### Callback

my $cb = MT::Callback->new;

### Do test

run_test {
    my $cd = $app->model('content_data')->load( { blog_id => $ct->blog_id } );
    MT::RebuildTrigger->post_content_save( $cb, $app, $cd );
    is( $rebuild_count, 1, 'called once in post_content_save.' );
};

done_testing;
