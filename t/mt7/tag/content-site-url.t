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

plan tests => 2 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
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
        my $cd = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
        );
        my $blog = $cd->blog;
        $blog->site_url('https://example.com/~abby');
        $blog->save or die $blog->errstr;
    }
);

MT::Test::Tag->run_perl_tests($blog_id);

MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::ContentSiteURL
--- template
<mt:Contents content_type="test content data"><mt:ContentSiteURL></mt:Contents>
--- expected
https://example.com/~abby/

