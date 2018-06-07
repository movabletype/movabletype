#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use utf8;

use MT::Test::Tag;

# plan tests => 2 * blocks;
plan tests => 1 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;

use MT::ContentStatus;

my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $ct = MT::Test::Permission->make_content_type(
            name    => 'test content data',
            blog_id => $blog_id,
        );
        my $cd1 = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
            status          => MT::ContentStatus::HOLD(),
        );
        my $cd2 = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
            status          => MT::ContentStatus::RELEASE(),
        );
    }
);

# As Contents tag only lists published contents, allow explicitly to set content with other status to test
MT::Test::Tag->run_perl_tests(
    $blog_id,
    sub {
        my ( $ctx, $block ) = @_;
        my $status = $block->status // return;
        my $ct = MT->model('content_type')
            ->load( { name => 'test content data', blog_id => $blog_id } );
        my $content = MT->model('content_data')->load(
            {   content_type_id => $ct->id,
                blog_id         => $blog_id,
                status          => $status,
            }
        );
        $ctx->stash( content => $content );
    }
);

# MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::ContentStatus
--- template
<mt:Contents content_type="test content data"><mt:ContentStatus>
</mt:Contents>
--- expected
Publish


=== MT::ContentStatus for a draft content
--- template
<mt:ContentStatus>
--- expected
Draft
--- skip_php
1
--- status eval
MT::ContentStatus::HOLD()


=== MT::ContentStatus for a published content
--- template
<mt:ContentStatus>
--- expected
Publish
--- skip_php
1
--- status eval
MT::ContentStatus::RELEASE()
