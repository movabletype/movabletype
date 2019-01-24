#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new( StaticWebPath => undef, );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use utf8;

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
        my $userpic = MT::Test::Permission->make_asset(
            blog_id   => 0,
            class     => 'image',
            label     => 'Userpic',
            file_path => './mt-static/images/logo/movable-type-logo.png',
            file_name => 'movable-type-logo.png',
            url       => '%s/images/logo/movable-type-logo.png',
        );
        my $author = $cd->author;
        $author->userpic_asset_id( $userpic->id );
        $author->save or die $author->errstr;
    }
);

MT::Test::Tag->run_perl_tests($blog_id);

MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::ContentAuthorUserpicURL
--- template
<mt:Contents content_type="test content data"><mt:ContentAuthorUserpicURL></mt:Contents>
--- expected
/cgi-bin/mt-static/support/assets_c/userpics/userpic-1-100x100.png

