#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib';
use MT::Test qw( :app :db );
use MT::Test::Permission;
use Test::More;

### Make test data

# Website
my $website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog(
    parent_id => $website->id,
);
my $second_blog = MT::Test::Permission->make_blog(
    parent_id => $website->id,
);

# Author
my $aikawa = MT::Test::Permission->make_author(
    name => 'aikawa',
    nickname => 'Ichiro Aikawa',
);

my $ichikawa = MT::Test::Permission->make_author(
    name => 'ichikawa',
    nickname => 'Jiro Ichikawa',
);

my $ukawa = MT::Test::Permission->make_author(
    name => 'ukawa',
    nickname => 'Saburo Ukawa',
);

my $egawa = MT::Test::Permission->make_author(
    name => 'egawa',
    nickname => 'Shiro Egawa',
);

my $admin = MT::Author->load(1);

# Role
my $edit_categories = MT::Test::Permission->make_role(
   name  => 'Edit Categories',
   permissions => "'edit_categories'",
);

my $manage_pages = MT::Test::Permission->make_role(
   name  => 'Manage Pages',
   permissions => "'manage_pages'",
);

my $create_post = MT::Test::Permission->make_role(
   name  => 'Create Post',
   permissions => "'create_post'",
);

my $designer = MT::Role->load( { name => MT->translate( 'Designer' ) } );

require MT::Association;
MT::Association->link( $aikawa => $edit_categories => $blog );
MT::Association->link( $ukawa => $designer => $blog );
MT::Association->link( $egawa => $manage_pages => $blog );

MT::Association->link( $ichikawa => $edit_categories => $second_blog );
MT::Association->link( $ichikawa => $create_post => $blog );

# Category
my $cat = MT::Test::Permission->make_category(
    blog_id => $blog->id,
    author_id => $aikawa->id,
);

# Folder
my $folder = MT::Test::Permission->make_folder(
    blog_id => $blog->id,
    author_id => $egawa->id,
);

# Run
my ( $app, $out );

subtest 'mode = category_do_add' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'category_do_add',
            blog_id          => $blog->id,
            label            => 'New Label',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: category_do_add" );
    ok( $out !~ m!Permission denied!i, "category_do_add by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'category_do_add',
            blog_id          => $blog->id,
            label            => 'New Label',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: category_do_add" );
    ok( $out !~ m!Permission denied!i, "category_do_add by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'category_do_add',
            blog_id          => $blog->id,
            label            => 'New Label',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: category_do_add" );
    ok( $out =~ m!Permission denied!i, "category_do_add by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'category_do_add',
            blog_id          => $blog->id,
            label            => 'New Label',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: category_do_add" );
    ok( $out =~ m!Permission denied!i, "category_do_add by other permission" );

    done_testing();
};

subtest 'mode = js_add_category' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'js_add_category',
            blog_id          => $blog->id,
            label            => 'New Label 1',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: js_add_category" );
    ok( $out !~ m!Permission denied!i, "js_add_category by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'js_add_category',
            blog_id          => $blog->id,
            label            => 'New Label 2',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: js_add_category" );
    ok( $out !~ m!Permission denied!i, "js_add_category by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'js_add_category',
            blog_id          => $blog->id,
            label            => 'New Label 3',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: js_add_category" );
    ok( $out =~ m!Permission denied!i, "js_add_category by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'js_add_category',
            blog_id          => $blog->id,
            label            => 'New Label 4',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: js_add_category" );
    ok( $out =~ m!Permission denied!i, "js_add_category by other permission" );

    done_testing();
};

subtest 'mode = list' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'category',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!permission=1!i, "list by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'category',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!permission=1!i, "list by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'category',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out =~ m!permission=1!i, "list by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'category',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out =~ m!permission=1!i, "list by other permission" );

    done_testing();
};

subtest 'mode = save_cat' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save_cat',
            blog_id          => $blog->id,
            _type            => 'category',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_cat" );
    ok( $out !~ m!permission=1!i, "save_cat by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save_cat',
            blog_id          => $blog->id,
            _type            => 'category',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_cat" );
    ok( $out !~ m!permission=1!i, "save_cat by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save_cat',
            blog_id          => $blog->id,
            _type            => 'category',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_cat" );
    ok( $out =~ m!permission=1!i, "save_cat by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save_cat',
            blog_id          => $blog->id,
            _type            => 'category',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_cat" );
    ok( $out =~ m!permission=1!i, "save_cat by other permission" );

    done_testing();
};

subtest 'mode = bulk_update_category' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'bulk_update_category',
            blog_id          => $blog->id,
            datasource       => 'category',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: bulk_update_category" );
    ok( $out !~ m!permission denied!i, "bulk_update_category by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'bulk_update_category',
            blog_id          => $blog->id,
            datasource       => 'category',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: bulk_update_category" );
    ok( $out !~ m!permission denied!i, "bulk_update_category by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'bulk_update_category',
            blog_id          => $blog->id,
            datasource       => 'category',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: bulk_update_category" );
    ok( $out =~ m!permission denied!i, "bulk_update_category by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'bulk_update_category',
            blog_id          => $blog->id,
            datasource       => 'category',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: bulk_update_category" );
    ok( $out =~ m!permission denied!i, "bulk_update_category by other permission" );

    SKIP: {
        skip 'https://movabletype.fogbugz.com/default.asp?106815', 2;
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $egawa,
                __request_method => 'POST',
                __mode           => 'bulk_update_category',
                blog_id          => $blog->id,
                datasource       => 'folder',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: bulk_update_category" );
        ok( $out =~ m!permission denied!i, "bulk_update_category by type mismatch" );
    };

    done_testing();
};

subtest 'mode = save (new)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'category',
            label            => 'CategoryName',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!Permission=1!i, "save (new) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'category',
            label            => 'CategoryName',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!Permission=1!i, "save (new) by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'category',
            label            => 'CategoryName',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Permission=1!i, "save (new) by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'category',
            label            => 'CategoryName',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Permission=1!i, "save (new) by other permission" );

    done_testing();
};

subtest 'mode = save (edit)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'category',
            label            => 'CategoryName',
            id               => $cat->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!permission=1!i, "save (edit) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'category',
            label            => 'CategoryName',
            id               => $cat->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!permission=1!i, "save (edit) by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'category',
            label            => 'CategoryName',
            id               => $cat->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!permission=1!i, "save (edit) by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'category',
            label            => 'CategoryName',
            id               => $cat->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!permission=1!i, "save (edit) by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'category',
            label            => 'CategoryName',
            id               => $folder->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!permission=1!i, "save (edit) by type mismatch" );

    done_testing();
};

subtest 'mode = edit (new)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'category',
            label            => 'CategoryName',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out !~ m!Permission=1!i, "edit (new) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'category',
            label            => 'CategoryName',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out !~ m!Permission=1!i, "edit (new) by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'category',
            label            => 'CategoryName',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Permission=1!i, "edit (new) by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'category',
            label            => 'CategoryName',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Permission=1!i, "edit (new) by other permission" );

    done_testing();
};

subtest 'mode = edit (edit)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'category',
            id               => $cat->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit (edit) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'category',
            id               => $cat->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit (edit) by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'category',
            id               => $cat->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit (edit) by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'category',
            id               => $cat->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit (edit) by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'category',
            id               => $folder->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit (edit) by type mismatch" );

    done_testing();
};

subtest 'mode = delete ' => sub {
    $cat = MT::Test::Permission->make_category(
        blog_id => $blog->id,
        author_id => $aikawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'category',
            id               => $cat->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out !~ m!permission=1!i, "delete  by admin" );

    $cat = MT::Test::Permission->make_category(
        blog_id => $blog->id,
        author_id => $aikawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'category',
            id               => $cat->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out !~ m!permission=1!i, "delete  by permitted user" );

    $cat = MT::Test::Permission->make_category(
        blog_id => $blog->id,
        author_id => $aikawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'category',
            id               => $cat->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete  by other blog" );

    $cat = MT::Test::Permission->make_category(
        blog_id => $blog->id,
        author_id => $aikawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'category',
            id               => $cat->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete  by other permission" );

    $folder = MT::Test::Permission->make_folder(
        blog_id => $blog->id,
        author_id => $egawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'category',
            id               => $folder->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete  by type mismatch" );

    done_testing();
};

done_testing();
