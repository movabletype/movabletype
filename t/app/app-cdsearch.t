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

$test_env->prepare_fixture('db_data');

my $site_id = 1;
my $site    = MT->model('blog')->load($site_id) or die;

my $content_type
    = MT::Test::Permission->make_content_type( blog_id => $site_id );

my $tmpl = MT->model('template')->load(
    {   blog_id    => $site_id,
        identifier => 'main_index',
    }
) or die;

my $app = _run_app(
    'MT::App::Search::ContentData',
    {   __request_method => 'GET',
        IncludeBlogs     => $site_id,
        ContentTypes     => $content_type->id,
        template_id      => $tmpl->id,
        archive_type     => 'Index',
        limit            => 5,
        page             => 2,
    },
);
my $out = delete $app->{__test_output};

ok( $out !~ /Invalid query:/ );

done_testing;

