#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib

use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

### Make test data
$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        # Website
        my $website
            = MT::Test::Permission->make_website( name => 'my website', );

        # Blog
        my $blog = MT::Test::Permission->make_blog(
            parent_id => $website->id,
            name      => 'my blog',
        );

        # Author
        my $ishikawa = MT::Test::Permission->make_author(
            name     => 'ishikawa',
            nickname => 'Yuuki Ishikawa',
        );

        # Entry
        my $entry = MT::Test::Permission->make_entry(
            blog_id   => $blog->id,
            author_id => $ishikawa->id,
            title     => 'my entry',
            status    => MT::Entry::status_int('Draft'),
        );
    }
);

my $admin = MT::Author->load(1);
my $blog  = MT::Blog->load( { name => 'my blog' } );
my $entry = MT::Entry->load( { title => 'my entry' } );

# Run
my ( $app, $out );

subtest 'mode = rebuild_new_phase' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'rebuild_new_phase',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    my $modified_entry = MT::Entry->load( $entry->id );
    ok( !$entry->modified_by,         "Undef." );
    ok( $modified_entry->modified_by, "Modified." );
    ok( $entry->modified_on != $modified_entry->modified_on,
        "Updated modified_on." );
    done_testing();
};

done_testing();
