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

my $ogawa = MT::Test::Permission->make_author(
    name => 'ogawa',
    nickname => 'Goro ogawa',
);

my $kagawa = MT::Test::Permission->make_author(
    name => 'kagawa',
    nickname => 'Ichiro kagawa',
);

my $kikkawa = MT::Test::Permission->make_author(
    name => 'kikkawa',
    nickname => 'Jiro Kikkawa',
);

my $kumekawa = MT::Test::Permission->make_author(
    name => 'kumekawa',
    nickname => 'Saburo Kumekawa',
);

my $kemikawa = MT::Test::Permission->make_author(
    name => 'kemikawa',
    nickname => 'Shiro Kemikawa',
);

my $admin = MT::Author->load(1);

# Asset
my $pic = MT::Test::Permission->make_asset(
    class => 'image',
    blog_id => 0,
    url => 'http://narnia.na/nana/images/test.jpg',
    file_path => File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test.jpg' ),
    file_name => 'test.jpg',
    file_ext => 'jpg',
    image_width => 640,
    image_height => 480,
    mime_type => 'image/jpeg',
    label => 'Userpic A',
    description => 'Userpic A',
);
$pic->tags('@userpic');
$pic->save;

my $pic2 = MT::Test::Permission->make_asset(
    class => 'image',
    blog_id => $blog->id,
    url => 'http://narnia.na/nana/images/test.jpg',
    file_path => File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test.jpg' ),
    file_name => 'test.jpg',
    file_ext => 'jpg',
    image_width => 640,
    image_height => 480,
    mime_type => 'image/jpeg',
    label => 'Sample Image',
    description => 'Sample photo',
);

# Role
my $create_post = MT::Test::Permission->make_role(
   name  => 'Create Post',
   permissions => "'create_post'",
);

my $manage_pages = MT::Test::Permission->make_role(
   name  => 'Manage Pages',
   permissions => "'manage_pages'",
);

my $edit_assets = MT::Test::Permission->make_role(
    name => 'Edit Assets',
    permissions => "'edit_assets', 'upload'",
);

my $designer = MT::Role->load( { name => MT->translate( 'Designer' ) } );

require MT::Association;
MT::Association->link( $aikawa => $create_post => $blog );
MT::Association->link( $ichikawa => $manage_pages => $blog );
MT::Association->link( $ukawa => $create_post => $second_blog );
MT::Association->link( $egawa => $manage_pages => $second_blog );
MT::Association->link( $ogawa => $designer => $blog );
MT::Association->link( $kagawa => $edit_assets => $blog );
MT::Association->link( $kikkawa => $edit_assets => $second_blog );
MT::Association->link( $kumekawa => $edit_assets => $blog );
MT::Association->link( $kumekawa => $create_post => $blog );
MT::Association->link( $kemikawa => $edit_assets => $second_blog );
MT::Association->link( $kemikawa => $create_post => $second_blog );

# Run
my ( $app, $out );

subtest 'mode = asset_userpic' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'asset_userpic',
            id               => $pic->id,
            user_id          => $admin->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: asset_userpic" );
    ok( $out !~ m!permission=1!i, "asset_userpic by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'asset_userpic',
            id               => $pic->id,
            user_id          => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: asset_userpic" );
    ok( $out !~ m!permission=1!i, "asset_userpic by myself" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'asset_userpic',
            id               => $pic->id,
            user_id          => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: asset_userpic" );
    ok( $out =~ m!permission=1!i, "asset_userpic by other user" );

    done_testing();
};

# Removed. because any user can access this mode now.
# subtest 'mode = complete_insert' => sub {
#     # By admim
#     $app = _run_app(
#         'MT::App::CMS',
#         {   __test_user      => $admin,
#             __request_method => 'POST',
#             __mode           => 'complete_insert',
#             id               => $pic2->id,
#             blog_id          => $blog->id,
#         }
#     );
#     $out = delete $app->{__test_output};
#     ok( $out, "Request: complete_insert" );
#     ok( $out =~ m!__mode=list!i, "complete_insert by admin" );

#     # By Permitted user(A)
#     $app = _run_app(
#         'MT::App::CMS',
#         {   __test_user      => $aikawa,
#             __request_method => 'POST',
#             __mode           => 'complete_insert',
#             id               => $pic2->id,
#             blog_id          => $blog->id,
#         }
#     );
#     $out = delete $app->{__test_output};
#     ok( $out, "Request: complete_insert" );
#     ok( $out =~ m!__mode=start_upload!i, "complete_insert by permitted user (create_post)" );

#     # By Permitted user(B)
#     $app = _run_app(
#         'MT::App::CMS',
#         {   __test_user      => $ichikawa,
#             __request_method => 'POST',
#             __mode           => 'complete_insert',
#             id               => $pic2->id,
#             blog_id          => $blog->id,
#         }
#     );
#     $out = delete $app->{__test_output};
#     ok( $out, "Request: complete_insert" );
#     ok( $out =~ m!__mode=start_upload!i, "complete_insert by permitted user (manage_pages)" );

#     # By non Permitted user(A)
#     $app = _run_app(
#         'MT::App::CMS',
#         {   __test_user      => $ukawa,
#             __request_method => 'POST',
#             __mode           => 'complete_insert',
#             id               => $pic2->id,
#             blog_id          => $blog->id,
#         }
#     );
#     $out = delete $app->{__test_output};
#     ok( $out, "Request: complete_insert" );
#     ok( $out =~ m!Permission=1!i, "complete_insert by other blog (create_post)" );

#     # By non Permitted user(B)
#     $app = _run_app(
#         'MT::App::CMS',
#         {   __test_user      => $egawa,
#             __request_method => 'POST',
#             __mode           => 'complete_insert',
#             id               => $pic2->id,
#             blog_id          => $blog->id,
#         }
#     );
#     $out = delete $app->{__test_output};
#     ok( $out, "Request: complete_insert" );
#     ok( $out =~ m!Permission=1!i, "complete_insert other blog (manage_pages)" );

#     # By other permission
#     $app = _run_app(
#         'MT::App::CMS',
#         {   __test_user      => $ogawa,
#             __request_method => 'POST',
#             __mode           => 'complete_insert',
#             id               => $pic2->id,
#             blog_id          => $blog->id,
#         }
#     );
#     $out = delete $app->{__test_output};
#     ok( $out, "Request: complete_insert" );
#     ok( $out =~ m!Permission=1!i, "complete_insert by other permission" );
# };

subtest 'mode = complete_upload' => sub {
    # By admim
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'complete_upload',
            id               => $pic2->id,
            label            => 'New Label',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: complete_upload" );
    ok( $out =~ m!__mode=list!i, "complete_upload by admin" );

    # By Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'complete_upload',
            id               => $pic2->id,
            label            => 'New Label',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: complete_upload" );
    ok( $out =~ m!__mode=list!i, "complete_upload by permitted user" );

    # By non Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'complete_upload',
            id               => $pic2->id,
            label            => 'New Label',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: complete_upload" );
    ok( $out =~ m!__mode=dashboard&permission=1!i, "complete_upload by other blog" );

    # By other permission
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'complete_upload',
            id               => $pic2->id,
            label            => 'New Label',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: complete_upload" );
    ok( $out =~ m!__mode=dashboard&permission=1!i, "complete_upload by other permission" );
};

subtest 'mode = asset_insert' => sub {
    # By admim
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'asset_insert',
            id               => $pic2->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: asset_insert" );
    ok( $out !~ m!Permission=1!i, "asset_insert by admin" );

    # By Permitted user(A)
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'asset_insert',
            id               => $pic2->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: asset_insert" );
    ok( $out !~ m!Permission=1!i, "asset_insert by permitted user (create_post)" );

    # By Permitted user(B)
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'asset_insert',
            id               => $pic2->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: asset_insert" );
    ok( $out !~ m!Permission=1!i, "asset_insert by permitted user (manage_pages)" );

    # By non Permitted user(A)
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'asset_insert',
            id               => $pic2->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: asset_insert" );
    ok( $out =~ m!Permission=1!i, "asset_insert by other blog (create_post)" );

    # By non Permitted user(B)
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'asset_insert',
            id               => $pic2->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: asset_insert" );
    ok( $out =~ m!Permission=1!i, "asset_insert other blog (manage_pages)" );

    # By other permission
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'asset_insert',
            id               => $pic2->id,
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: asset_insert" );
    ok( $out =~ m!Permission=1!i, "asset_insert by other permission" );
};

subtest 'mode = list' => sub {
    # By admim
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            label            => 'New Label',
            blog_id          => $blog->id,
            _type            => 'asset',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!Permission=1!i, "list by admin" );

    # By Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'list',
            label            => 'New Label',
            blog_id          => $blog->id,
            _type            => 'asset',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!Permission=1!i, "list by permitted user" );

    # By non Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'list',
            label            => 'New Label',
            blog_id          => $blog->id,
            _type            => 'asset',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out =~ m!Permission=1!i, "list by other blog" );

    # By other permission
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'list',
            label            => 'New Label',
            blog_id          => $blog->id,
            _type            => 'asset',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out =~ m!Permission=1!i, "list by other permission" );
};

subtest 'mode = start_upload' => sub {
    # By admim
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'start_upload',
            label            => 'New Label',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_upload" );
    ok( $out !~ m!Permission=1!i, "start_upload by admin" );

    # By Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'start_upload',
            label            => 'New Label',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_upload" );
    ok( $out !~ m!Permission=1!i, "start_upload by permitted user" );

    # By non Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'start_upload',
            label            => 'New Label',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_upload" );
    ok( $out =~ m!Permission=1!i, "start_upload by other blog" );

    # By other permission
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'start_upload',
            label            => 'New Label',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_upload" );
    ok( $out =~ m!Permission=1!i, "start_upload by other permission" );
};

subtest 'mode = start_upload_entry' => sub {
    # By admim
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'start_upload_entry',
            label            => 'New Label',
            blog_id          => $blog->id,
            id               => $pic2->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_upload_entry" );
    ok( $out !~ m!Permission=1!i, "start_upload_entry by admin" );

    # By Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'start_upload_entry',
            label            => 'New Label',
            blog_id          => $blog->id,
            id               => $pic2->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_upload_entry" );
    ok( $out !~ m!Permission=1!i, "start_upload_entry by permitted user" );

    # By non Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemikawa,
            __request_method => 'POST',
            __mode           => 'start_upload_entry',
            label            => 'New Label',
            blog_id          => $blog->id,
            id               => $pic2->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_upload_entry" );
    ok( $out =~ m!Permission=1!i, "start_upload_entry by other blog" );

    # By other permission
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'start_upload_entry',
            label            => 'New Label',
            blog_id          => $blog->id,
            id               => $pic2->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_upload_entry" );
    ok( $out =~ m!Permission=1!i, "start_upload_entry by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'start_upload_entry',
            label            => 'New Label',
            blog_id          => $blog->id,
            id               => $pic2->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_upload_entry" );
    ok( $out =~ m!Permission=1!i, "start_upload_entry by other permission" );
};

subtest 'mode = upload_file' => sub {
    # By admim
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'upload_file',
            label            => 'New Label',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: upload_file" );
    ok( $out !~ m!Permission denied!i, "upload_file by admin" );

    # By Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'upload_file',
            label            => 'New Label',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: upload_file" );
    ok( $out !~ m!Permission denied!i, "upload_file by permitted user" );

    # By non Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'upload_file',
            label            => 'New Label',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: upload_file" );
    ok( $out =~ m!Permission denied!i, "upload_file by other blog" );

    # By other permission
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'upload_file',
            label            => 'New Label',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: upload_file" );
    ok( $out =~ m!Permission denied!i, "upload_file by other permission" );
};

subtest 'mode = save' => sub {
    # By admim
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'asset',
            blog_id          => $blog->id,
            id               => $pic2->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!Permission=1!i, "save by admin" );

    # By Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'asset',
            blog_id          => $blog->id,
            id               => $pic2->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!Permission=1!i, "save by permitted user" );

    # By non Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'asset',
            blog_id          => $blog->id,
            id               => $pic2->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Permission=1!i, "save by other blog" );

    # By other permission
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'asset',
            label            => 'New Label',
            blog_id          => $blog->id,
            id               => $pic2->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Permission=1!i, "save by other permission" );
};

subtest 'mode = delete' => sub {
    my $asset = MT::Test::Permission->make_asset(
        class => 'image',
        blog_id => $blog->id,
        url => 'http://narnia.na/nana/images/test2.jpg',
        file_path => File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test2.jpg' ),
        file_name => 'test2.jpg',
        file_ext => 'jpg',
        image_width => 640,
        image_height => 480,
        mime_type => 'image/jpeg',
        label => 'Sample Image',
        description => 'Sample photo',
    );
    # By admim
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'asset',
            blog_id          => $blog->id,
            id               => $asset->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out !~ m!Permission=1!i, "delete by admin" );

    $asset = MT::Test::Permission->make_asset(
        class => 'image',
        blog_id => $blog->id,
        url => 'http://narnia.na/nana/images/test2.jpg',
        file_path => File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test2.jpg' ),
        file_name => 'test2.jpg',
        file_ext => 'jpg',
        image_width => 640,
        image_height => 480,
        mime_type => 'image/jpeg',
        label => 'Sample Image',
        description => 'Sample photo',
    );
    # By Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'asset',
            blog_id          => $blog->id,
            id               => $asset->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out !~ m!Permission=1!i, "delete by permitted user" );

    $asset = MT::Test::Permission->make_asset(
        class => 'image',
        blog_id => $blog->id,
        url => 'http://narnia.na/nana/images/test2.jpg',
        file_path => File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test2.jpg' ),
        file_name => 'test2.jpg',
        file_ext => 'jpg',
        image_width => 640,
        image_height => 480,
        mime_type => 'image/jpeg',
        label => 'Sample Image',
        description => 'Sample photo',
    );
    # By non Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'asset',
            blog_id          => $blog->id,
            id               => $asset->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!Permission=1!i, "delete by other blog" );

    $asset = MT::Test::Permission->make_asset(
        class => 'image',
        blog_id => $blog->id,
        url => 'http://narnia.na/nana/images/test2.jpg',
        file_path => File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test2.jpg' ),
        file_name => 'test2.jpg',
        file_ext => 'jpg',
        image_width => 640,
        image_height => 480,
        mime_type => 'image/jpeg',
        label => 'Sample Image',
        description => 'Sample photo',
    );
    # By other permission
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'asset',
            label            => 'New Label',
            blog_id          => $blog->id,
            id               => $asset->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!Permission=1!i, "delete by other permission" );
};

subtest 'mode = add_tags' => sub {
    my $asset = MT::Test::Permission->make_asset(
        class => 'image',
        blog_id => $blog->id,
        url => 'http://narnia.na/nana/images/test.jpg',
        file_path => File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test.jpg' ),
        file_name => 'test.jpg',
        file_ext => 'jpg',
        image_width => 640,
        image_height => 480,
        mime_type => 'image/jpeg',
        label => 'Sample Image',
        description => 'Sample photo',
    );

    # By admim
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'asset',
            action_name      => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_asset%26blog_id%3D'.$blog->id,
            blog_id          => $blog->id,
            plugin_action_selector => 'add_tags',
            id               => $asset->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out !~ m!not implemented!i, "add_tags by admin" );

    # By Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'asset',
            action_name      => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_asset%26blog_id%3D'.$blog->id,
            blog_id          => $blog->id,
            plugin_action_selector => 'add_tags',
            id               => $asset->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out !~ m!not implemented!i, "add_tags by permitted user" );

    # By non Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'asset',
            action_name      => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_asset%26blog_id%3D'.$blog->id,
            blog_id          => $blog->id,
            plugin_action_selector => 'add_tags',
            id               => $asset->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out =~ m!not implemented!i, "add_tags by other blog" );

    # By other permission
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'asset',
            action_name      => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_asset%26blog_id%3D'.$blog->id,
            blog_id          => $blog->id,
            plugin_action_selector => 'add_tags',
            id               => $asset->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out =~ m!not implemented!i, "add_tags by other permission" );
};

subtest 'mode = remove_tags' => sub {
    my $asset = MT::Test::Permission->make_asset(
        class => 'image',
        blog_id => $blog->id,
        url => 'http://narnia.na/nana/images/test.jpg',
        file_path => File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test.jpg' ),
        file_name => 'test.jpg',
        file_ext => 'jpg',
        image_width => 640,
        image_height => 480,
        mime_type => 'image/jpeg',
        label => 'Sample Image',
        description => 'Sample photo',
    );

    # By admim
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'asset',
            action_name      => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_asset%26blog_id%3D'.$blog->id,
            blog_id          => $blog->id,
            plugin_action_selector => 'remove_tags',
            id               => $asset->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out !~ m!not implemented!i, "remove_tags by admin" );

    # By Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'asset',
            action_name      => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_asset%26blog_id%3D'.$blog->id,
            blog_id          => $blog->id,
            plugin_action_selector => 'remove_tags',
            id               => $asset->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out !~ m!not implemented!i, "remove_tags by permitted user" );

    # By non Permitted user
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'asset',
            action_name      => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_asset%26blog_id%3D'.$blog->id,
            blog_id          => $blog->id,
            plugin_action_selector => 'remove_tags',
            id               => $asset->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out =~ m!not implemented!i, "remove_tags by other blog" );

    # By other permission
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'asset',
            action_name      => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_asset%26blog_id%3D'.$blog->id,
            blog_id          => $blog->id,
            plugin_action_selector => 'remove_tags',
            id               => $asset->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out =~ m!not implemented!i, "remove_tags by other permission" );
};

done_testing();
