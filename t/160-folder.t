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


BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use Test::More;
use lib qw(lib extlib t/lib);
use MT::Test qw(:app :db :data);
use MT::Test::Permission;
use MT::CMS::Folder;

my $folder_class = MT->model('folder');

subtest 'category_set_id' => sub {
    my $folder = $folder_class->new(
        blog_id => 1,
        label   => 'test',
    );
    is( $folder->category_set_id, 0, 'default value is 0' );

    $folder->category_set_id(1);
    is( $folder->category_set_id, 0, 'value is always 0' );

    $folder->column( 'category_set_id', 2 );
    $folder->save or die $folder->errstr;
    is( $folder->category_set_id, 0,
        'value cannot be changed even by column method' );
};

subtest 'remove' => sub {
    my $category_id = 1;
    my $init        = sub {
        MT->model('category')->remove_all();
        $folder_class->remove_all();
        my $folder = $folder_class->new;
        $folder->set_values(
            {   id      => $category_id,
                label   => 'Test',
                blog_id => 1,
            }
        );
        $folder->save or die;
    };
    my $check = sub {
        my $folder = $folder_class->load($category_id);
        ok( !$folder, 'removed' );
    };

    subtest 'call with an object' => sub {
        $init->();
        $folder_class->load($category_id)->remove;
        $check->();
        done_testing();
    };

    subtest 'call with a class' => sub {
        $init->();
        $folder_class->remove( { id => $category_id } );
        $check->();
        done_testing();
    };

    done_testing();
};

subtest 'permission_filter methods check' => sub {

    MT->model('folder')->remove_all();

    ### Make test data

    # Website
    my $website        = MT::Test::Permission->make_website();
    my $second_website = MT::Test::Permission->make_website();

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
        nickname => 'Saburo Ukawa',
    );

    my $admin = MT->model('author')->load(1);

    # Role
    my $manage_pages = MT::Test::Permission->make_role(
        name        => 'Manage Pages',
        permissions => "'manage_pages'",
    );

    my $designer = MT::Role->load( { name => MT->translate('Designer') } );

    require MT::Association;
    MT::Association->link( $aikawa, $manage_pages, $website );
    MT::Association->link( $ukawa,  $designer,     $website );

    MT::Association->link( $ichikawa, $manage_pages, $second_website );

    # Folder
    my $folder = MT::Test::Permission->make_folder(
        blog_id   => $website->id,
        author_id => $admin->id,
    );

    # Run tests
    my $app = MT->app;

    subtest 'admin' => sub {
        $app->user($admin);
        $app->blog($website);

        ok( MT::CMS::Folder::can_save( undef, $app, $folder ),
            "can_save with folder by admin" );
        ok( MT::CMS::Folder::can_delete( undef, $app, $folder ),
            "can_delete with folder by admin" );

        ok( MT::CMS::Folder::can_save( undef, $app, undef ),
            "can_save without folder by admin" );
        ok( MT::CMS::Folder::can_delete( undef, $app, undef ),
            "can_delete without folder by admin" );

        $app->blog($second_website);

        ok( MT::CMS::Folder::can_save( undef, $app, undef ),
            "can_save without folder by admin" );
        ok( MT::CMS::Folder::can_save( undef, $app, undef ),
            "can_delete without folder by admin" );

        done_testing();
    };

    subtest 'permitted user' => sub {
        $app->user($aikawa);
        $app->blog($second_website);

        ok( MT::CMS::Folder::can_save( undef, $app, $folder ),
            "can_save method with folder by permitted user"
        );
        ok( MT::CMS::Folder::can_delete( undef, $app, $folder ),
            "can_delete method with folder by permitted user"
        );

        $app->blog($website);

        ok( MT::CMS::Folder::can_save( undef, $app, undef ),
            "can_save method without folder by permitted user"
        );
        ok( MT::CMS::Folder::can_delete( undef, $app, undef ),
            "can_delete method without folder by permitted user"
        );

        done_testing();
    };

    subtest 'not permitted user' => sub {
        $app->blog($second_website);

        ok( !MT::CMS::Folder::can_save( undef, $app, undef ),
            "can_save method without folder by a user permitted in other website"
        );
        ok( !MT::CMS::Folder::can_delete( undef, $app, undef ),
            "can_delete method without folder by a user permitted in other website"
        );

        $app->user($ichikawa);
        $app->blog($website);

        ok( !MT::CMS::Folder::can_save( undef, $app, undef ),
            "can_save method without folder by a user permitted in other website"
        );
        ok( !MT::CMS::Folder::can_delete( undef, $app, undef ),
            "can_delete method without folder by a user permitted in other website"
        );

        $app->user($ukawa);

        ok( !MT::CMS::Folder::can_save( undef, $app, $folder ),
            "can_save method with folder by a user having other permission"
        );
        ok( !MT::CMS::Folder::can_delete( undef, $app, $folder ),
            "can_delete method with folder by a user having other permission"
        );

        ok( !MT::CMS::Folder::can_save( undef, $app, undef ),
            "can_save method without folder by a user having other permission"
        );
        ok( !MT::CMS::Folder::can_delete( undef, $app, undef ),
            "can_delete method without folder by a user having other permission"
        );

        done_testing();
    };

    done_testing();
};

done_testing();
