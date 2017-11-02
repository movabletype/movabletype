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

use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

$test_env->prepare_fixture('db');

my $cat_class = MT->model('category');

### Make test data

# Website
my $website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );
my $second_blog
    = MT::Test::Permission->make_blog( parent_id => $website->id, );

# Author
my $aikawa = MT::Test::Permission->make_author(
    name     => 'aikawa',
    nickname => 'Ichiro Aikawa',
);

my $ichikawa = MT::Test::Permission->make_author(
    name     => 'ichikawa',
    nickname => 'Jiro Ichikawa',
);

my $ukawa = MT::Test::Permission->make_author(
    name     => 'ukawa',
    nickname => 'Ukawa Saburo',
);

my $admin = MT->model('author')->load(1);

# Role
my $edit_categories = MT::Test::Permission->make_role(
    name        => 'Edit Categories',
    permissions => "'edit_categories'",
);

my $designer = MT::Role->load( { name => MT->translate('Designer') } );

require MT::Association;
MT::Association->link( $aikawa, $edit_categories, $blog );
MT::Association->link( $ukawa,  $designer,        $blog );

MT::Association->link( $ichikawa, $edit_categories, $second_blog );

# Run tests
my ( $app, $out );

subtest 'permission_filter methods check' => sub {
    my $cat = MT::Test::Permission->make_category(
        blog_id   => $blog->id,
        author_id => $admin->id,
    );

    my $app = MT->app;
    $app->user($aikawa);
    $app->blog($blog);

    require MT::CMS::Category;

    subtest 'admin' => sub {
        $app->user($admin);
        $app->blog($blog);

        ok( MT::CMS::Category::can_save( undef, $app, $cat ),
            "can_save with category by admin" );
        ok( MT::CMS::Category::can_view( undef, $app, $cat ),
            "can_view with category by admin" );
        ok( MT::CMS::Category::can_delete( undef, $app, $cat ),
            "can_delete with category by admin" );

        ok( MT::CMS::Category::can_save( undef, $app, undef ),
            "can_save without category by admin" );
        ok( MT::CMS::Category::can_view( undef, $app, undef ),
            "can_view without category by admin" );
        ok( MT::CMS::Category::can_delete( undef, $app, undef ),
            "can_delete without category by admin" );

        $app->blog($second_blog);

        ok( MT::CMS::Category::can_save( undef, $app, undef ),
            "can_save without category by admin" );
        ok( MT::CMS::Category::can_view( undef, $app, undef ),
            "can_view without category by admin" );
        ok( MT::CMS::Category::can_delete( undef, $app, undef ),
            "can_delete without category by admin" );

        done_testing();
    };

    subtest 'permitted user' => sub {
        $app->user($aikawa);
        $app->blog($second_blog);

        ok( MT::CMS::Category::can_save( undef, $app, $cat ),
            "can_save with category by permitted user"
        );
        ok( MT::CMS::Category::can_view( undef, $app, $cat ),
            "can_view with category by permitted user"
        );
        ok( MT::CMS::Category::can_delete( undef, $app, $cat ),
            "can_delete with category by permitted user"
        );

        $app->blog($blog);

        ok( MT::CMS::Category::can_save( undef, $app, undef ),
            "can_save without category by permitted user"
        );
        ok( MT::CMS::Category::can_view( undef, $app, undef ),
            "can_view without category by permitted user"
        );
        ok( MT::CMS::Category::can_delete( undef, $app, undef ),
            "can_delete without category by permitted user"
        );

        done_testing();
    };

    subtest 'not permitted user' => sub {
        $app->blog($second_blog);

        ok( !MT::CMS::Category::can_save( undef, $app, undef ),
            "can_save without category by a user permitted in other blog"
        );
        ok( !MT::CMS::Category::can_view( undef, $app, undef ),
            "can_view without category by a user permitted in other blog"
        );
        ok( !MT::CMS::Category::can_delete( undef, $app, undef ),
            "can_delete without category by a user permitted in other blog"
        );

        $app->user($ichikawa);
        $app->blog($blog);

        ok( !MT::CMS::Category::can_save( undef, $app, undef ),
            "can_save without category by a user permitted in other blog"
        );
        ok( !MT::CMS::Category::can_view( undef, $app, undef ),
            "can_view without category by a user permitted in other blog"
        );
        ok( !MT::CMS::Category::can_delete( undef, $app, undef ),
            "can_delete without category by a user permitted in other blog"
        );

        $app->user($ukawa);

        ok( !MT::CMS::Category::can_save( undef, $app, $cat ),
            "can_save with category by a user having other permission"
        );
        ok( !MT::CMS::Category::can_view( undef, $app, $cat ),
            "can_view with category by a user having other permission"
        );
        ok( !MT::CMS::Category::can_delete( undef, $app, $cat ),
            "can_delete with category by a user having other permission"
        );

        ok( !MT::CMS::Category::can_save( undef, $app, undef ),
            "can_save without category by a user having other permission"
        );
        ok( !MT::CMS::Category::can_view( undef, $app, undef ),
            "can_view without category by a user having other permission"
        );
        ok( !MT::CMS::Category::can_delete( undef, $app, undef ),
            "can_deleteout with category by a user having other permission"
        );

        done_testing();
    };

    done_testing();
};

done_testing();

