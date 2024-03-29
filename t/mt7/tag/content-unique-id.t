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

use MT::Test::Tag;

plan tests => (1 + 2) * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

my $uid;

sub uid {
    $uid;
}

filters {
    template => [qw( chomp )],
    expected => [qw( uid chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $ct = MT::Test::Permission->make_content_type(
            name    => 'test content data',
            blog_id => $blog_id,
        );
        my $cd = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
        );
    }
);

my $ct = MT::ContentType->load( { name => 'test content data' } );
my $cd = MT::ContentData->load(
    {   blog_id         => $blog_id,
        content_type_id => $ct->id,
    }
);

$uid = $cd->unique_id;

MT::Test::Tag->run_perl_tests($blog_id);

MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::ContentUniqueID
--- template
<mt:Contents content_type="test content data"><mt:ContentUniqueID> </mt:Contents>
--- expected
__dummy__

