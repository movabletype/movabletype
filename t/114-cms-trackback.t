#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test qw( :app :db );
use MT::Test::Permission;
use MT::Util;

### Make test data

# Website
my $website        = MT::Test::Permission->make_website();
my $second_website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );
my $second_blog
    = MT::Test::Permission->make_blog( parent_id => $second_website->id, );

# Author
my $admin = MT::Author->load(1);

# Page
my $website_page = MT::Test::Permission->make_page(
    blog_id   => $website->id,
    author_id => $admin->id,
);

# Category
my $website_cat = MT::Test::Permission->make_category(
    blog_id   => $website->id,
    author_id => $admin->id,
);
my $website_other_cat = MT::Test::Permission->make_category(
    blog_id   => $website->id,
    author_id => $admin->id,
);
my $blog_cat = MT::Test::Permission->make_category(
    blog_id   => $blog->id,
    author_id => $admin->id,
);
my $second_website_cat = MT::Test::Permission->make_category(
    blog_id   => $second_website->id,
    author_id => $admin->id,
);
my $second_blog_cat = MT::Test::Permission->make_category(
    blog_id   => $second_blog->id,
    author_id => $admin->id,
);

# Trackback
my $tb_page = MT::Test::Permission->make_tb(
    blog_id  => $website->id,
    entry_id => $website_page->id,
);
my $tb_website_cat = MT::Test::Permission->make_tb(
    blog_id     => $website->id,
    category_id => $website_cat->id,
    entry_id    => 0,
);
my $tb_website_other_cat = MT::Test::Permission->make_tb(
    blog_id     => $website->id,
    category_id => $website_other_cat->id,
    entry_id    => 0,
);
my $tb_blog_cat = MT::Test::Permission->make_tb(
    blog_id     => $blog->id,
    category_id => $blog_cat->id,
    entry_id    => 0,
);
my $tb_second_website_cat = MT::Test::Permission->make_tb(
    blog_id     => $second_website->id,
    category_id => $second_website_cat->id,
    entry_id    => 0,
);
my $tb_second_blog_cat = MT::Test::Permission->make_tb(
    blog_id     => $second_blog->id,
    category_id => $second_blog->id,
    entry_id    => 0,
);

# Ping
my $ping_website_cat = MT::Test::Permission->make_ping(
    blog_id => $website->id,
    tb_id   => $tb_website_cat->id,
    excerpt => 'Ichiro Aikawa',
);
my $ping_page = MT::Test::Permission->make_ping(
    blog_id => $website->id,
    tb_id   => $tb_page->id,
    excerpt => 'Jiro Ichikawa',
);
my $ping_website_other_cat = MT::Test::Permission->make_ping(
    blog_id => $website->id,
    tb_id   => $tb_website_other_cat->id,
    excerpt => 'Saburo Ukawa',
);
my $ping_blog_cat = MT::Test::Permission->make_ping(
    blog_id => $blog->id,
    tb_id   => $tb_blog_cat->id,
    excerpt => 'Shiro Egawa',
);
my $ping_second_website_cat = MT::Test::Permission->make_ping(
    blog_id => $second_website->id,
    tb_id   => $tb_second_website_cat->id,
    excerpt => 'Goro Ogawa',
);
my $ping_second_blog_cat = MT::Test::Permission->make_ping(
    blog_id => $second_blog->id,
    tb_id   => $tb_second_blog_cat->id,
    excerpt => 'Ichiro Kagawa',
);

# Run test
my ( $app, $out );
plan tests => 2;

subtest "Check filtered_list method of Trackback in a website" => sub {
    plan tests => 7;

    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'filtered_list',
            datasource       => 'ping',
            blog_id          => $website->id,
            columns          => 'excerpt,blog_name,target,created_on',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: filtered_list" );

    like( $out, qr/Ichiro Aikawa/, "Category trackback exists." );
    like( $out, qr/Jiro Ichikawa/, "Page trackback in same website exists." );
    like(
        $out,
        qr/Saburo Ukawa/,
        "A category trackback in same website exists."
    );
    like(
        $out,
        qr/Shiro Egawa/,
        "A category trackback in child blog exists."
    );
    unlike( $out, qr/Goro Ogawa/,
        "A category trackback in other website does not exist." );
    unlike(
        $out,
        qr/Ichiro Kagawa/,
        "A category trackback in other blog does not exist."
    );

    done_testing();
};

subtest "Check filtered_list method of Trackback in a category of website" => sub {
    plan tests => 7;

    my @param = (
        {   type => 'category_id',
            args => {
                option => 'equal',
                value  => $website_cat->id,
            },
        }
    );
    my $json = MT::Util::to_json( \@param, { canonical => 1 } );

    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'filtered_list',
            datasource       => 'ping',
            blog_id          => $website->id,
            columns          => 'excerpt,blog_name,target,created_on',
            items            => $json,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: filtered_list" );

    like( $out, qr/Ichiro Aikawa/, "Category trackback exists." );
    unlike(
        $out,
        qr/Jiro Ichikawa/,
        "Page trackback in same website does not exist."
    );
    unlike(
        $out,
        qr/Saburo Ukawa/,
        "A category trackback in same website does not exist."
    );
    unlike(
        $out,
        qr/Shiro Egawa/,
        "A category trackback in child blog does not exist."
    );
    unlike( $out, qr/Goro Ogawa/,
        "A category trackback in other website does not exist." );
    unlike(
        $out,
        qr/Ichiro Kagawa/,
        "A category trackback in other blog does not exist."
    );

    done_testing();
};

done_testing();
