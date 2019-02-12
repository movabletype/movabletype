#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
    $ENV{MT_APP}    = 'MT::App::CMS';
}

use File::Find ();

use MT;
use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

my $blog_id = 1;

$test_env->prepare_fixture('db');

my $author = MT->model('author')->load(1) or die;

my $folder1 = MT::Test::Permission->make_folder(
    blog_id => $blog_id,
    label   => 'folder1',
);

my $folder2 = MT::Test::Permission->make_folder(
    blog_id => $blog_id,
    label   => 'folder2',
);

# Mapping
my $template = MT::Test::Permission->make_template(
    blog_id => $blog_id,
    name    => 'Folder Test',
    type    => 'page',
    text    => 'test',
);
my $template_map = MT::Test::Permission->make_templatemap(
    template_id   => $template->id,
    blog_id       => $blog_id,
    archive_type  => 'Page',
    file_template => '%c/%f',
    is_preferred  => 1,
);

my $blog = MT::Blog->load($blog_id);
$blog->site_path( $test_env->root . '/site' );
$blog->save;

subtest 'create page' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user             => $author,
            __test_follow_redirects => 1,
            __mode                  => 'save_entry',
            _type                   => 'page',
            author_id               => $author->id,
            blog_id                 => $blog_id,
            return_args      => "__mode=view&_type=page&blog_id=$blog_id",
            save_revision    => 1,
            entry_prefs      => 'Default',
            custom_prefs     => [qw( tags category feedback assets )],
            title            => 'page1',
            convert_breaks   => 'richtext',
            text             => '<p>test page</p>',
            text_more        => '',
            status           => 2,
            authored_on_date => '2018-08-31',
            authored_on_time => '00:00:00',
            basename         => 'page1',
            category_ids     => $folder1->id,
        },
    );
    delete $app->{__test_output};

    ok -e File::Spec->catfile( $blog->site_path, "folder1/page1.html" );

    my @finfos = MT::FileInfo->load( { blog_id => $blog_id } );
    is @finfos => 1, "1 FileInfo";

    File::Find::find(
        {   wanted => sub {
                if ( -f $File::Find::name ) {
                    note $File::Find::name;
                }
            },
            no_chdir => 1,
        },
        $blog->site_path
    );
};

subtest 'update page (change folder)' => sub {
    my $page1
        = MT->model('page')->load( { blog_id => $blog_id, title => 'page1' } )
        or die;
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user             => $author,
            __test_follow_redirects => 1,
            __mode                  => 'save_entry',
            _type                   => 'page',
            id                      => $page1->id,
            author_id               => $author->id,
            blog_id                 => $blog_id,
            return_args => "__mode=view&_type=page&blog_id=$blog_id&id="
                . $page1->id,
            save_revision    => 1,
            entry_prefs      => 'Default',
            custom_prefs     => [qw( tags category feedback assets )],
            title            => 'page1',
            convert_breaks   => 'richtext',
            text             => '<p>test page</p>',
            text_more        => '',
            old_status       => 2,
            status           => 2,
            authored_on_date => '2018-08-31',
            authored_on_time => '00:00:00',
            basename         => 'page1',
            category_ids     => $folder2->id,
        },
    );
    delete $app->{__test_output};

    ok !-e File::Spec->catfile( $blog->site_path, 'folder1/page1.html' );
    ok -e File::Spec->catfile( $blog->site_path, 'folder2/page1.html' );

    my @finfos = MT::FileInfo->load( { blog_id => $blog_id } );
    is @finfos => 1, "1 FileInfo";

    File::Find::find(
        {   wanted => sub {
                if ( -f $File::Find::name ) {
                    note $File::Find::name;
                }
            },
            no_chdir => 1,
        },
        $blog->site_path
    );
};

subtest 'create other page' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user             => $author,
            __test_follow_redirects => 1,
            __mode                  => 'save_entry',
            _type                   => 'page',
            author_id               => $author->id,
            blog_id                 => $blog_id,
            return_args      => "__mode=view&_type=page&blog_id=$blog_id",
            save_revision    => 1,
            entry_prefs      => 'Default',
            custom_prefs     => [qw( tags category feedback assets )],
            title            => 'page2',
            convert_breaks   => 'richtext',
            text             => '<p>test page</p>',
            text_more        => '',
            status           => 2,
            authored_on_date => '2018-10-31',
            authored_on_time => '00:00:00',
            basename         => 'page2',
            category_ids     => $folder2->id,
        },
    );
    delete $app->{__test_output};

    ok !-e File::Spec->catfile( $blog->site_path, 'folder1/page1.html' );
    ok -e File::Spec->catfile( $blog->site_path, 'folder2/page1.html' );
    ok -e File::Spec->catfile( $blog->site_path, 'folder2/page2.html' );

    my @finfos = MT::FileInfo->load( { blog_id => $blog_id } );
    is @finfos => 2, "2 FileInfo";

    File::Find::find(
        {   wanted => sub {
                if ( -f $File::Find::name ) {
                    note $File::Find::name;
                }
            },
            no_chdir => 1,
        },
        $blog->site_path
    );
};

done_testing;
